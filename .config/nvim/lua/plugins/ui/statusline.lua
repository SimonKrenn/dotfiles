return {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  opts = {
    options = {
      theme = "auto",
      icons_enabled = true,
      component_separators = "",
      section_separators = "",
    },
    sections = {
      lualine_a = { "branch" },
      lualine_b = { "filename" },
      lualine_c = { { "diff", symbols = { added = "", modified = "", removed = "" } } },
      lualine_x = {
        { "diagnostics", symbols = { error = "", warn = "", info = "", hint = "h" } },
      },
      lualine_y = { "progress" },
      lualine_z = { "mode" },
    },
  },
}
