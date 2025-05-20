return {
	-- https://github.com/MunifTanjim/nui.nvim
	{
		"MunifTanjim/nui.nvim", lazy = true
	},
	-- https://github.com/folke/noice.nvim
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true,    -- use a classic bottom cmdline for search
					command_palette = true,  -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false,      -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false,  -- add a border to hover docs and signature
				},
			})
		end
	},
	-- https://github.com/stevearc/dressing.nvim
	{
		'stevearc/dressing.nvim',
	},
	--https://github.com/folke/trouble.nvim
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		}
	},
	-- https://github.com/folke/edgy.nvim
	{
		"folke/edgy.nvim",
		enabled = true,
		event = "VeryLazy",
		init = function()
			vim.opt.laststatus = 3
			vim.opt.splitkeep = "screen"
		end,
		keys = {
			-- stylua: ignore
			{ "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
			{ "<leader>ue", function() require("edgy").toggle() end, desc = "Edgy Toggle" }
		},
		opts = {
			animate = {
				enabled = false
			},
			bottom = {
				"Trouble",
				{
					ft = "qf",
					title = "QuickFix",
					size = {
						height = 30
					}
				},
				{
					ft = "help",
					size = { height = 20 },
					-- only show help buffers
					filter = function(buf)
						return vim.bo[buf].buftype == "help"
					end,
				},
				{ ft = "spectre_panel", size = { height = 0.4 } },
			},
			right = {
				{
					ft = "codecompanion",
					title = "codecompanion",
					size = {
						width = 60
					}
				}
			}
		},
	},
	-- https://github.com/nvim-lualine/lualine.nvim
	{
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
					},
					{
						'codecompanion'
					}
				}
			}
		},
		extensions = {
			'neo-tree'
		},
	},
	{
		-- https://github.com/akinsho/bufferline.nvim
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		opts = {
			options = {
				mode = "tabs",
				seperator_style = "slant"
			}
		},
	},
	-- https://github.com/folke/which-key.nvim
	{
		"folke/which-key.nvim",
		enabled = true,
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			preset = 'helix'
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
		end
	},
	-- https://github.com/brenoprata10/nvim-highlight-colors
	{
		'brenoprata10/nvim-highlight-colors',
		opts = {
			enable_tailwind = true,
			render = "virtual"
		},
	},
	--https://github.com/folke/snacks.nvim
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			statuscolumn = {
				left = { "mark", "sign" }, -- priority of signs on the left (high to low)
				right = { "fold", "git" }, -- priority of signs on the right (high to low)
				folds = {
					open = true,         -- show open fold icons
					git_hl = false,      -- use Git Signs hl for fold icons
				},
				git = {
					-- patterns to match Git signs
					patterns = { "GitSign", "MiniDiffSign" },
				},
				refresh = 50, -- refresh at most every 50ms

			},
			dashboard = { enabled = true },
			indent = { enabled = true },
			toggle = { enabled = true },
			scope = { enabled = true },
			notifier = { enabled = true, top_down = false },
			explorer = {
				enabled = true
			},
			picker = {
				sources = {
					files = {
						hidden = true,
						ignored = false
					},
					grep = {
						hidden = true,
						ignored = false,
					},
					explorer = {
						finder = "explorer",
						sort = { fields = { "sort" } },
						hidden = true,
						tree = true,
						supports_live = true,
						follow_file = true,
						auto_close = true,
						jump = { close = false },
						layout = { preset = "ivy_split", preview = "left" },
						formatters = { file = { filename_only = true } },
						matcher = { sort_empty = false, fuzzy = false },
						config = function(opts)
							return require("snacks.picker.source.explorer").setup(opts)
						end,
					},
					projects = {
						dev = { "~/Workspace" }
					}
				}
			}
		},
		keys = {
			{ "<leader>lg",       function() Snacks.lazygit() end,                              desc = "Lazygit" },
			{ "<leader>gB",       function() Snacks.gitbrowse() end,                            desc = "Gitbrowse" },
			{ "<c-/>",            function() Snacks.terminal() end,                             desc = "Toggle Terminal" },
			{ "<leader>nf",       function() Snacks.explorer() end,                             desc = "Snacks Explorer" },
			{ "<leader>ff",       function() Snacks.picker.files() end,                         desc = "File Picker" },
			{ "<leader>gs",       function() Snacks.picker.git_status() end,                    desc = "Git Status" },
			{ "<leader>sh",       function() Snacks.picker.highlights() end,                    desc = "Highlights" },
			{ "<leader>fg",       function() Snacks.picker.grep() end,                          desc = "Grep Picker" },
			{ "<leader><leader>", function() Snacks.picker.smart() end,                         desc = "Smart Picker" },
			{ "<leader>sp",       function() Snacks.picker() end,                               desc = "All Pickers" },
			{ "<leader>fb",       function() Snacks.picker.buffers() end,                       desc = "Buffers" },
			{ "gd",               function() Snacks.picker.lsp_definitions() end,               desc = "LSP: Definitions" },
			{ "gr",               function() Snacks.picker.lsp_references() end,                desc = "LSP: References" },
			{ "gI",               function() Snacks.picker.lsp_implementations() end,           desc = "LSP: Implementations" },
			{ "D",                function() Snacks.picker.lsp_type_definition() end,           desc = "LSP: Type Definition" },
			{ "ds",               function() Snacks.picker.lsp_document_symbols() end,          desc = "LSP: Document Symbols" },
			{ "ws",               function() Snacks.picker.lsp_dynamic_workspace_symbols() end, desc = "LSP: Workspace Symbols" },
		}
	},
	{
		--https://github.com/mikavilpas/yazi.nvim
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		dependencies = {
			"folke/snacks.nvim"
		},
		keys = {
			{ "<leader>gy", "<cmd>Yazi<CR>", desc = "toggle yazi" }
		},
	},
}
