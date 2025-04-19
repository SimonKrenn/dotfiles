return {
	-- https://github.com/zbirenbaum/copilot.lua
	{
		'zbirenbaum/copilot.lua',
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			}
			)
		end
	},
	-- https://github.com/giuxtaposition/blink-cmp-copilot
	{ "giuxtaposition/blink-cmp-copilot", },
	-- https://github.com/olimorris/codecompanion.nvim
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("codecompanion").setup({
				strategies = {
					chat = {
						adapater = "copilot"
					},
					inline = {
						adapter = "copilot",
					},
					agent = {
						adapter = "copilot",
					},
				},
			})
		end
	}
}
