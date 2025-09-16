return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    left = {
      {
        title = "Snacks Explorer",
        ft = "snacks_picker_list",
        filter = function(buf, win)
          return vim.b[buf]
            and vim.b[buf].snacks_source == "explorer"
            and vim.api.nvim_win_get_config(win).relative == ""
        end,
        open = function()
          Snacks.explorer()
        end,
        pinned = true,
        size = { width = 35 },
      },
    },
  },
  keys = {
    {
      "<leader>ue",
      function()
        require("edgy").toggle()
      end,
      desc = "Edgy Toggle",
    },
    {
      "<leader>uE",
      function()
        require("edgy").select()
      end,
      desc = "Edgy Select Window",
    },
  },
}
