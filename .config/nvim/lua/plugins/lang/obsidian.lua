return {
  "obsidian-nvim/obsidian.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  version = "*",
  lazy = "true",
  ft = "markdown",
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
      {
        name = "work",
        paht = "~/vaults/work",
      },
    },
    completion = {
      blink = true,
    },
  },
}
