// Pure job model. Persistence, authorization, and external effects belong to adapters.
type Policy = Readonly<{ maxAttempts: number; leaseMs: number }>;
type Base = Readonly<{ policy: Policy; attempt: number }>;

export type Job = Base & (
  | Readonly<{ status: "queued" }>
  | Readonly<{ status: "running"; expiresAt: number }>
  | Readonly<{ status: "succeeded"; result: string }>
  | Readonly<{ status: "cancelled" }>
  | Readonly<{ status: "failed"; reason: "attempts-exhausted" }>
);

export type Command =
  | Readonly<{ kind: "claim"; now: number }>
  | Readonly<{ kind: "complete"; now: number; attempt: number; result: string }>
  | Readonly<{ kind: "cancel" }>;

export type Decision =
  | Readonly<{ kind: "changed"; state: Job }>
  | Readonly<{
      kind: "rejected";
      state: Job;
      reason: "terminal" | "busy" | "stale" | "expired" | "invalid-input";
    }>;

export function createJob(policy: Policy): Job {
  if (!positiveInteger(policy.maxAttempts) || !positiveInteger(policy.leaseMs)) {
    throw new RangeError("maxAttempts and leaseMs must be positive safe integers");
  }
  // Copy so mutation of the caller's configuration cannot change an existing job.
  return { status: "queued", attempt: 0, policy: { ...policy } };
}

// The caller must atomically commit this decision against the version it read.
// now comes from the state owner's clock; worker-supplied time is not authoritative.
export function step(job: Job, command: Command): Decision {
  const reject = (reason: Extract<Decision, { kind: "rejected" }>['reason']): Decision =>
    ({ kind: "rejected", state: job, reason });
  if (job.status !== "queued" && job.status !== "running") return reject("terminal");
  const base: Base = { policy: job.policy, attempt: job.attempt };

  switch (command.kind) {
    case "cancel":
      return { kind: "changed", state: { ...base, status: "cancelled" } };
    case "claim": {
      if (!timeValue(command.now) || !Number.isSafeInteger(command.now + job.policy.leaseMs)) {
        return reject("invalid-input");
      }
      if (job.status === "running" && command.now < job.expiresAt) return reject("busy");
      if (job.attempt >= job.policy.maxAttempts) {
        return { kind: "changed", state: { ...base, status: "failed", reason: "attempts-exhausted" } };
      }
      return {
        kind: "changed",
        state: { ...base, status: "running", attempt: job.attempt + 1, expiresAt: command.now + job.policy.leaseMs },
      };
    }
    case "complete":
      if (!timeValue(command.now) || !positiveInteger(command.attempt)) return reject("invalid-input");
      if (job.status !== "running" || command.attempt !== job.attempt) return reject("stale");
      if (command.now >= job.expiresAt) return reject("expired");
      return { kind: "changed", state: { ...base, status: "succeeded", result: command.result } };
    default: {
      const exhaustive: never = command;
      throw new Error(`Unsupported command: ${String(exhaustive)}`);
    }
  }
}

function positiveInteger(value: number): boolean {
  return Number.isSafeInteger(value) && value > 0;
}

function timeValue(value: number): boolean {
  return Number.isSafeInteger(value) && value >= 0;
}
