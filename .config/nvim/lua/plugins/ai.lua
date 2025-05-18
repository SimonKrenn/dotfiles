return {
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
		keys = {
			{ "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "[C]odecompanion [C]hat" },
		},
		opts = {
			opts = {
				log_level = "TRACE",
			},
			display = {
				chat = {
					show_settings = false
				},
			},
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "gemini-2.5-pro", -- this model seems to not be able to use the @editor, probably because it's reasoning aloud
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "copilot",
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
			}
		},
	},
}
