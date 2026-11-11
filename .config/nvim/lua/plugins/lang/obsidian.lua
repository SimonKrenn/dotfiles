return {
  "obsidian-nvim/obsidian.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  version = "*",
  lazy = "true",
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
      {
        name = "work",
        path = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/work"),
      },
      {
        name = "vault",
        path = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/zettelkasten/"),
      },
    },
    completion = {
      blink = true,
    },
    picker = {
      name = "snacks.pick",
    },
  },
  keys = {
    {
      "<leader>nf",
      function()
        Snacks.picker.files({ cwd = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/") })
      end,
      desc = "[n]otes find files",
    },
    {
      "<leader>ng",
      function()
        Snacks.picker.grep({ cwd = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/") })
      end,
      desc = "[n]otes grep",
    },
  },
}
