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

			open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
			sources = {
				"filesystem",
				"git_status",
				"document_symbols",
				"buffers"
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
			},
			buffers = {
				follow_current_file = {
					enabled = true,  -- This will find and focus the file in the active buffer every time
					--              -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
				group_empty_dirs = true, -- when true, empty folders will be grouped together
				show_unloaded = true,
				window = {
					mappings = {
						["bd"] = "buffer_delete",
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						["oc"] = { "order_by_created", nowait = false },
						["od"] = { "order_by_diagnostics", nowait = false },
						["om"] = { "order_by_modified", nowait = false },
						["on"] = { "order_by_name", nowait = false },
						["os"] = { "order_by_size", nowait = false },
						["ot"] = { "order_by_type", nowait = false },
					}
				},
			}
		})
	end
}
