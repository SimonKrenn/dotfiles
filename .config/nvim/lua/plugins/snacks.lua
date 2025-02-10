return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		statuscolumn = { enabled = true },
		dashboard = { enabled = true },
		explorer = {
			enabled = true
		},
		picker = {
			sources = {
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

				}
			}
		}
	},
	keys = {
		{ "<leader>lg", function() Snacks.lazygit() end,   desc = "Lazygit" },
		{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Gitbrowse" },
		{ "<c-/>",      function() Snacks.terminal() end,  desc = "Toggle Terminal" },
		{ "<leader>nf", function() Snacks.explorer() end,  desc = "Snacks Explorer" },
	}
}
