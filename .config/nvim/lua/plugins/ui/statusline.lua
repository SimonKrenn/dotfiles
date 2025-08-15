return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  opts = {
    theme = 'auto',
    icons_enabled = true,
    component_separators = '|',
    section_separators = '|',
    sections = {
      lualine_a = {"branch", 'diff'},
      lualine_b = {"filename"},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {'mode'},
    },
  },
}
