return {
	-- LSP Configuration & Plugins
	'neovim/nvim-lspconfig',
	event = 'VeryLazy',
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',

		-- Useful status updates for LSP
		{ 'j-hui/fidget.nvim', opts = {} },

		-- Additional lua configuration
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
		local servers = { 'tsserver', 'eslintd', 'eslint', 'lua_ls', 'angularls' }
		require('mason').setup({})
		require('mason-lspconfig').setup({
			ensure_installed = servers
		})

		-- LSP settings.
		--  This function gets run when an LSP connects to a particular buffer.
		local on_attach = function(_, bufnr)
			-- NOTE: Remember that lua is a real programming language, and as such it is possible
			-- to define small helper and utility functions so you don't have to repeat yourself
			-- many times.
			--
			-- In this case, we create a function that lets us more easily define mappings specific
			-- for LSP related items. It sets the mode, buffer and description for us each time.
			local nmap = function(keys, func, desc)
				if desc then
					desc = 'LSP: ' .. desc
				end

				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
			end

			nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
			nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

			nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
			nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
			nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
			nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
			nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
			nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

			-- See `:help K` for why this keymap
			nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
			-- TODO find a workaround for this
			--nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

			-- Lesser used LSP functionality
			nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
			nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
			nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
			nmap('<leader>wl', function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, '[W]orkspace [L]ist Folders')

			-- Create a command `:Format` local to the LSP buffer
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

		require('lspconfig').lua_ls.setup {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT)
						version = 'LuaJIT',
						-- Setup your lua path
						path = runtime_path,
					},
					diagnostics = {
						globals = { 'vim' },
					},
					workspace = { library = vim.api.nvim_get_runtime_file('', true) },
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = { enable = false },
				},
			},
		}
	end
}
