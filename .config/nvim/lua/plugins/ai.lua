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
					avante = {
						make_slash_commands = true
					}
				}
			})
		end
	},
	-- https://github.com/olimorris/codecompanion.nvim
	{
		"olimorris/codecompanion.nvim",
		enabled = false,
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
								default = "gemini-2.5-pro",
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
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			input = {
				provider = "snacks",
				provider_opts = {
					title = "Avante Input"
				}
			},
			provider = "copilot",
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub and hub:get_active_servers_prompt() or ""
			end,
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
		},
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim",   -- for input provider snacks
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						use_absolute_path = true,
					},
				},
			},
			{
				'MeanderingProgrammer/render-markdown.nvim',
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	{
		"NickvanDyke/opencode.nvim",
		dependencies = { "folke/snacks.nvim", },
		opts = {

		},
		keys = {
			{ '<leader>ot', function() require('opencode').toggle() end,                           desc = 'Toggle embedded opencode', },
			{ '<leader>oa', function() require('opencode').ask() end,                              desc = 'Ask opencode',                 mode = 'n', },
			{ '<leader>oa', function() require('opencode').ask('@selection: ') end,                desc = 'Ask opencode about selection', mode = 'v', },
			{ '<leader>op', function() require('opencode').select_prompt() end,                    desc = 'Select prompt',                mode = { 'n', 'v', }, },
			{ '<leader>on', function() require('opencode').command('session_new') end,             desc = 'New session', },
			{ '<leader>oy', function() require('opencode').command('messages_copy') end,           desc = 'Copy last message', },
			{ '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end,   desc = 'Scroll messages up', },
			{ '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', }, }
	},
}
