return {
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				typescript = { "biome", "prettierd, prettier" },
				typescriptreact = { "biome", "prettierd", "prettier" },
				javascript = { "biome", "prettierd", "prettier" },
				javascriptreact = { "biome", "prettierd", "prettier" },
        lua = {'stylua'},
        yaml = {'yamlfix'}
			},
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	}
