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
	-- https://github.com/ravitemer/mcphub.nvim
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "npm install -g mcp-hub@latest",
		config = function()
			require("mcphub").setup({
				port = 34021,
				config = vim.fn.expand("~/mcpservers.json"),
				extensions = {
					codecompanion = {
						-- Show the mcp tool result in the chat buffer
						show_result_in_chat = true,
						make_vars = true,     -- make chat #variables from MCP server resources
						make_slash_commands = true, -- make /slash_commands from MCP server prompts
					},
				}
			})
		end
	},
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
						adapater = "copilot",
						tools = {
							["mcp"] = {
								-- calling it in a function would prevent mcphub from being loaded before it's needed
								callback = function() return require("mcphub.extensions.codecompanion") end,
								description = "Call tools and resources from the MCP Servers",
							}
						}
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
