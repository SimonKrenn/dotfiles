vim.loader.enable()

require("config.lazy")
require("config.settings")
require("config.keymap")
require("config.autocmds")

if not vim.g.vscode then
	require("mason").setup()
	require("mason-lspconfig").setup()
	require("mini.pairs").setup()
end
