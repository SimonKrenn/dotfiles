return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  opts = {
    options = {
      theme = 'auto',
      icons_enabled = true,
      component_separators = '',
      section_separators = '',
    },
    sections = {
      lualine_a = {"branch"},
      lualine_b = {"filename"},
      lualine_c = {"diff"},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {'mode'},
    },
  },
}
