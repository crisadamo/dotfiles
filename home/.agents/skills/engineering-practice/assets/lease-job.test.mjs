import test from "node:test";
import assert from "node:assert/strict";
import { createJob, step } from "./lease-job.ts";

const initial = () => createJob({ maxAttempts: 2, leaseMs: 10 });
const claim = (state, now) => step(state, { kind: "claim", now });
const complete = (state, now, attempt, result = "report") =>
  step(state, { kind: "complete", now, attempt, result });
const terminal = state => ["succeeded", "cancelled", "failed"].includes(state.status);

test("a caller can claim and complete without coordinating internal flags", () => {
  const owned = claim(initial(), 100);
  assert.equal(owned.kind, "changed");
  assert.deepEqual(owned.state, {
    status: "running", policy: { maxAttempts: 2, leaseMs: 10 }, attempt: 1, expiresAt: 110,
  });
  assert.deepEqual(complete(owned.state, 109, 1).state, {
    status: "succeeded", policy: { maxAttempts: 2, leaseMs: 10 }, attempt: 1, result: "report",
  });
});

test("only an expired lease can be reclaimed; the old worker cannot publish", () => {
  const first = claim(initial(), 100).state;
  assert.equal(claim(first, 109).reason, "busy");
  const second = claim(first, 110).state;
  assert.equal(second.attempt, 2);
  const stale = complete(second, 111, 1, "old");
  assert.equal(stale.reason, "stale");
  assert.equal(stale.state, second);
  assert.equal(complete(second, 111, 2, "new").state.result, "new");
});

test("expiry is an exact boundary, even before a replacement worker claims", () => {
  const running = claim(initial(), 100).state;
  assert.equal(complete(running, 110, 1).reason, "expired");
  assert.equal(complete(running, 109, 1).state.status, "succeeded");
});

test("cancellation and completion preserve whichever terminal outcome committed first", () => {
  const running = claim(initial(), 100).state;
  const cancelled = step(running, { kind: "cancel" }).state;
  assert.equal(complete(cancelled, 101, 1).reason, "terminal");
  assert.equal(step(cancelled, { kind: "cancel" }).state, cancelled);
  const succeeded = complete(running, 101, 1).state;
  assert.equal(step(succeeded, { kind: "cancel" }).state, succeeded);
  assert.equal(complete(succeeded, 102, 1, "different").state.result, "report");
});

test("an expired final attempt becomes a terminal failure instead of retrying forever", () => {
  const first = claim(initial(), 100).state;
  const second = claim(first, 110).state;
  const exhausted = claim(second, 120);
  assert.equal(exhausted.state.status, "failed");
  assert.equal(exhausted.state.reason, "attempts-exhausted");
  assert.equal(claim(exhausted.state, 130).reason, "terminal");
});

test("invalid policy/time and pre-claim completion cannot establish ownership", () => {
  for (const value of [0, -1, NaN, Infinity, 1.5, Number.MAX_SAFE_INTEGER + 1]) {
    assert.throws(() => createJob({ maxAttempts: value, leaseMs: 10 }), RangeError);
    assert.throws(() => createJob({ maxAttempts: 2, leaseMs: value }), RangeError);
  }
  for (const now of [-1, NaN, Infinity, 1.5, Number.MAX_SAFE_INTEGER]) {
    assert.equal(claim(initial(), now).reason, "invalid-input");
  }
  assert.equal(complete(initial(), 0, 1).reason, "stale");
});

test("the decision core does not mutate the supplied snapshot or retain caller policy", () => {
  const policy = { maxAttempts: 2, leaseMs: 10 };
  const state = createJob(policy);
  policy.maxAttempts = 99;
  assert.equal(state.policy.maxAttempts, 2);
  Object.freeze(state.policy);
  Object.freeze(state);
  assert.equal(claim(state, 100).state.status, "running");
  assert.equal(state.status, "queued");
});

test("bounded exploration preserves safety across command orderings", t => {
  // Finite abstraction: two attempts, 1ms lease, owner times 0..4, depth <= 7.
  // This checks the model's safety; it is not a liveness or database proof.
  const root = createJob({ maxAttempts: 2, leaseMs: 1 });
  const queue = [{ state: root, now: 0, trace: [] }];
  const seen = new Set([JSON.stringify([root, 0])]);
  let transitions = 0;
  for (let index = 0; index < queue.length; index++) {
    const { state, now, trace } = queue[index];
    if (trace.length === 7) continue;
    for (let time = now; time <= 4; time++) {
      const commands = [
        { kind: "claim", now: time }, { kind: "cancel" },
        ...[1, 2, 3].map(attempt => ({ kind: "complete", now: time, attempt, result: "x" })),
      ];
      for (const command of commands) {
        const before = structuredClone(state);
        const decision = step(state, command);
        const next = decision.state;
        const context = JSON.stringify([...trace, command]);
        assert.deepEqual(state, before, context);
        assert.ok(next.attempt >= state.attempt && next.attempt <= 2, context);
        assert.deepEqual(next.policy, { maxAttempts: 2, leaseMs: 1 }, context);
        if (terminal(state)) assert.deepEqual(next, state, context);
        if (decision.kind === "rejected") assert.deepEqual(next, state, context);
        if (!terminal(state) && next.status === "succeeded") {
          assert.equal(state.status, "running", context);
          assert.equal(command.kind, "complete", context);
          assert.equal(command.attempt, state.attempt, context);
          assert.ok(command.now < state.expiresAt, context);
        }
        if (next.attempt > state.attempt) {
          assert.equal(command.kind, "claim", context);
          assert.ok(state.status === "queued" || time >= state.expiresAt, context);
        }
        transitions++;
        const key = JSON.stringify([next, time]);
        if (!seen.has(key)) {
          seen.add(key);
          queue.push({ state: next, now: time, trace: [...trace, command] });
        }
      }
    }
  }
  t.diagnostic(`${seen.size} state/time pairs; ${transitions} transitions explored`);
});
