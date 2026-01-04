return {
  {
    "catppuccin/nvim",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto",
        background = { light = "latte", dark = "macchiato" },
      })
      -- vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "mcauley-penney/phobos-anomaly.nvim",
    priority = 1000,
  },
  --- {
  --   dir = "~/workspace/eldritch-base.nvim",
  --   enabled = true,
  --   priority = 1000,
  --   opts = {
  --     italic_comments = false,
  --     transparent = false,
  --     plugin_support = {
  --       aerial = true,
  --       blink = true,
  --       edgy = true,
  --       gitsigns = true,
  --       lazy = true,
  --       lualine = true,
  --       mason = true,
  --     },
  --   },
  --   -- init = function()
  --   --   vim.cmd.colorscheme("eldritchbase")
  --   -- end,
  -- },
  {
    "nyoom-engineering/oxocarbon.nvim",
  },
  {
    "olivercederborg/poimandres.nvim",
  },
  {
    "Mofiqul/adwaita.nvim",
  },
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
  },
  {
    "ydkulks/cursor-dark.nvim",
  },
  {
    dir = "~/Workspace/onehunter.nvim",
    init = function()
      vim.cmd.colorscheme("one-hunter")
    end,
  },
}
