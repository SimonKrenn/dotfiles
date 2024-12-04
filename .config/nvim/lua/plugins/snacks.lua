return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		statuscolumn = { enabled = true },
		dashboard = { enabled = true },
	},
	keys = {
		{ "<leader>lg", function() Snacks.lazygit() end,   desc = "Lazygit" },
		{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Gitbrowse" },
		{ "<c-/>",      function() Snacks.terminal() end,  desc = "Toggle Terminal" },
	}
}
