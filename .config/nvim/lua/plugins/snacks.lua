return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		statuscolumn = { enabled = true },
		dashboard = { enabled = true },
		indent = { enabled = true },
		toggle = { enabled = true },
		explorer = {
			enabled = true
		},
		picker = {
			sources = {
				files = {
					hidden = true,
					ignored = true
				},
				grep = {
					hidden = true,
					ignored = true,
				},
				explorer = {
					finder = "explorer",
					sort = { fields = { "sort" } },
					hidden = true,
					tree = true,
					supports_live = true,
					follow_file = true,
					focus = "list",
					auto_close = true,
					jump = { close = false },
					layout = { preset = "ivy_split", preview = "left" },
					formatters = { file = { filename_only = true } },
					matcher = { sort_empty = true },
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
		{ "<leader>lg",       function() Snacks.lazygit() end,      desc = "Lazygit" },
		{ "<leader>gB",       function() Snacks.gitbrowse() end,    desc = "Gitbrowse" },
		{ "<c-/>",            function() Snacks.terminal() end,     desc = "Toggle Terminal" },
		{ "<leader>nf",       function() Snacks.explorer() end,     desc = "Snacks Explorer" },
		{ "<leader>ff",       function() Snacks.picker.files() end, desc = "File Picker" },
		{ "<leader>fg",       function() Snacks.picker.grep() end,  desc = "Grep Picker" },
		{ "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart Picker" },
		{ "<leader>sp",       function() Snacks.picker() end,       desc = "All Pickers" },
		{ "gd",	function() Snacks.picker.lsp_definitions() end, desc = "LSP: Definitions" },
		{ "gr", function() Snacks.picker.lsp_references() end, desc = "LSP: References"},
		{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "LSP: Implementations"},
		{ "D", function() Snacks.picker.lsp_type_definition() end, desc = "LSP: Type Definition"},
		{"ds", function() Snacks.picker.lsp_document_symbols() end, desc = "LSP: Document Symbols"},
		{"ws", function() Snacks.picker.lsp_dynamic_workspace_symbols() end, desc = "LSP: Workspace Symbols"},
	}
}
