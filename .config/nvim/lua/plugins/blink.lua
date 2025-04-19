return {
	'saghen/blink.cmp',
	dependencies = { 'rafamadriz/friendly-snippets', "giuxtaposition/blink-cmp-copilot" },
	version = '*',
	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- See the full "keymap" documentation for information on defining your own keymap.
		keymap = { preset = 'super-tab' },

		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts sp		acing to ensure icons are aligned
			nerd_font_variant = 'mono',
			kind_icons = {
				Text = '󰉿',
				Method = '󰊕',
				Function = '󰊕',
				Constructor = '󰒓',

				Field = '󰜢',
				Variable = '󰆦',
				Property = '󰖷',

				Class = '󱡠',
				Interface = '󱡠',
				Struct = '󱡠',
				Module = '󰅩',

				Unit = '󰪚',
				Value = '󰦨',
				Enum = '󰦨',
				EnumMember = '󰦨',

				Keyword = '󰻾',
				Constant = '󰏿',

				Snippet = '󱄽',
				Color = '󰏘',
				File = '󰈔',
				Reference = '󰬲',
				Folder = '󰉋',
				Event = '󱐋',
				Operator = '󰪚',
				TypeParameter = '󰬛',
				Ollama = '󰳆',
			},
		},

		completion = {
			menu = {
				draw = {
					treesitter = { "lsp" },
					columns = { { "label", "label_description", }, { "kind_icon", "source_name" } },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = true,
				show_with_menu = false
			},

		},
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer', "codecompanion" },
		},
	},
	opts_extend = { "sources.default" }
}
