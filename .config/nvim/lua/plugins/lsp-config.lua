return {
	'neovim/nvim-lspconfig',
	event = 'VeryLazy',
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',

		{ 'j-hui/fidget.nvim', opts = {} },

		'folke/neodev.nvim'
	},
	setup = function()
		local function get_client(buf)
			return require("lazyvim.util").lsp.get_client({ name = eslint, bufnr = buf })[1]
		end
		local formatter = require("lazyvim.util").lsp.formatter({
			name = "eslint: lsp",
			primary = false,
			priority = 200,
			filter = "eslint"
		})


		if not pcall(require, "vim.lsp._dynamic") then
			formatter.name = "eslint: EslintFixAll"
			formatter.sources = function(buf)
				local client = get_client(buf)
				return client and { "eslint" } or {}
			end
			formatter.format = function(buf)
				local client = get_client(buf)
				if client then
					local diag = vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
					if #diag > 0 then
						vim.cmd("EslintFixAll")
					end
				end
			end
		end
		require("lazyvim.util").format.register(formatter)
	end,
	config = function()
		local servers = { 'eslint_d', 'eslint', 'lua_ls', "yamlls", "biome", "mdx_analyzer", "vtsls" }
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
		for _, lsp in ipairs(servers) do
			require('lspconfig')[lsp].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end
		require("lspconfig").mdx_analyzer.setup({
			cmd = { "mdx-analyzer", "--stdio" },
			filetypes = { "mdx" },
			root_dir = require("lspconfig.util").root_pattern(".git", "package.json"),
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
}
