return {
  {
    "catppuccin/nvim",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto",
        transparent_background = true,
        background = { light = "latte", dark = "macchiato" },
      })
      -- vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "mcauley-penney/phobos-anomaly.nvim",
    priority = 1000,
  },
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
    opts = {
      transparent = true,
    },
    init = function()
      vim.cmd.colorscheme("one-hunter")
    end,
  },
}
