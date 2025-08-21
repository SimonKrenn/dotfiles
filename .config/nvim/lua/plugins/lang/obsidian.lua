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
        path = "/Users/int004977/Library/Mobile Documents/iCloud~md~obsidian/Documents/work",
      },
    },
    completion = {
      blink = true,
    },
  },
  keys = {
    {
      "<leader>nf",
      function()
        Snacks.picker.files({ cwd = "/Users/int004977/Library/Mobile Documents/iCloud~md~obsidian/Documents/work" })
      end,
      desc = "[n]otes find files",
    },
    {
      "<leader>ng",
      function()
        Snacks.picker.grep({ cwd = "/Users/int004977/Library/Mobile Documents/iCloud~md~obsidian/Documents/work" })
      end,
      desc = "[n]otes grep",
    },
  },
}
