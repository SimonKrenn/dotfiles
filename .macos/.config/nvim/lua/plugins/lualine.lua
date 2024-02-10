-- Fancier status line
return {
	'nvim-lualine/lualine.nvim',
	opts = {
		icons_enabled = false,
		component_separators = '|',
		section_separators = '',
	},
	extensions = {
		'neo-tree'
	}
}
