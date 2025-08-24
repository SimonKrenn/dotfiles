return {
  {
    "mcauley-penney/phobos-anomaly.nvim",
    priority = 1000,
  },
  {
    dir = "~/workspace/eldritch-base.nvim",
    enabled = true,
    priority = 1000,
    opts = {
      italic_comments = false,
      transparent = false,
      plugin_support = {
        aerial = true,
        blink = true,
        edgy = true,
        gitsigns = true,
        lazy = true,
        lualine = true,
        mason = true,
      },
    },
    init = function()
      vim.cmd.colorscheme("eldritchbase")
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
  },
}
