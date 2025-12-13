return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
  keys = {
    {
      "<leader>fy",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "[f]ind [y]azi",
    },
    {
      "<leader>fcd",
      mode = { "n", "v" },
      "<cmd>Yazi cwd<cr>",
      desc = "[f]ind [c]urrent [d]irectory",
    },
  },
  opts = {
    open_for_directories = true,
  },
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,
}
