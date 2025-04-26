return {
	{
		'neovim/nvim-lspconfig',
		event = 'VeryLazy',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- { 'j-hui/fidget.nvim', opts = {} },

			'folke/neodev.nvim'
		},
		config = function()
			local servers = { 'eslint', 'lua_ls', "yamlls", "biome", "vtsls" }
			require('mason').setup({})
			require('mason-lspconfig').setup({
				ensure_installed = servers
			})

			local on_attach = function(_, bufnr)
				local nmap = function(keys, func, desc)
					if desc then
						desc = 'LSP: ' .. desc
					end

					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
				end

				nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
				nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
				nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

				nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
				nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
				nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
				nmap('<leader>wl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, '[W]orkspace [L]ist Folders')

				vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
					if vim.lsp.buf.format then
						vim.lsp.buf.format()
					elseif vim.lsp.buf.formatting then
						vim.lsp.buf.formatting()
					end
				end, { desc = 'Format current buffer with LSP' })
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true
			}

			for _, lsp in ipairs(servers) do
				require('lspconfig')[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			require("lspconfig").mdx_analyzer.setup({
				filetypes = { "markdown.mdx", "mdx" },
				capabilities = capabilities,
				root_dir = require('lspconfig.util').root_pattern('.git'),
			})

			require('lspconfig').lua_ls.setup {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = 'LuaJIT',
							path = runtime_path,
						},
						diagnostics = {
							globals = { 'vim' },
						},
						workspace = { library = vim.api.nvim_get_runtime_file('', true) },
						telemetry = { enable = false },
					},
				},
			}
		end
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } }
	},
	{
		"williamboman/mason-lspconfig.nvim"
	}
}
