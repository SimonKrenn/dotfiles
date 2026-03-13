return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  lazy = false,
  opts = {
    layout = {
      prompt_position = "top",
      flex = {
        wrap = "bottom",
      },
    },
  },
  keys = {
    {
      "<leader>ff",
      function()
        require("fff").find_files()
      end,
      desc = "[f]ind [f]iles",
    },
    {
      "<leader>fg",
      function()
        require("fff").live_grep()
      end,
      desc = "[f]ind [g]rep",
    },
  },
}
