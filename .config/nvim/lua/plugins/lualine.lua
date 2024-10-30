-- Fancier status line
return {
	'nvim-lualine/lualine.nvim',
	opts = {
		theme = 'auto',
		icons_enabled = false,
		component_separators = '|',
		section_separators = '',
		sections = {
			lualine_c = {
				{
					'filename',
					path = 1,
				}
			}
		}
	},
	extensions = {
		'neo-tree'
	},
}
