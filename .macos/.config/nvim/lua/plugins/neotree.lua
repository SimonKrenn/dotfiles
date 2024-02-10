return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
		require("neo-tree").setup({
			sources = {
				"filesystem",
				"git_status",
				"document_symbols"
			},
			close_if_last_window = true,
			popup_border_style = "rounded",
			follow_current_file = {
				enabled = true
			},
			filesystem = {
				follow_current_file = true,
				hijack_netrw_behavior = "open_default"
			},
			git_status = {
				window = {
					position = "float",
				},
			},
			document_symbols = {
				window = {
					position = "right"
				}
			}
		})
	end
}
