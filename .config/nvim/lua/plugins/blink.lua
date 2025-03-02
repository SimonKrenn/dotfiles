return {
	'saghen/blink.cmp',
	dependencies = { 'rafamadriz/friendly-snippets', "giuxtaposition/blink-cmp-copilot" },
	version = '*',
	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- See the full "keymap" documentation for information on defining your own keymap.
		keymap = { preset = 'default' },

		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = 'mono'
		},

		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot', "minuet" },
			providers = {
				copilot = {
					name = 'copilot',
					module = "blink-cmp-copilot",
					async = true,
				},
				minuet = {
					name = "minuet",
					module = "minuet.blink",
				}
			}
		},
	},
	opts_extend = { "sources.default" }
}
