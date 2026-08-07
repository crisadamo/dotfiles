return {
  {
    "dapovich/anysphere.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("anysphere").setup({})
      vim.cmd.colorscheme("anysphere")
    end,
  },
}
