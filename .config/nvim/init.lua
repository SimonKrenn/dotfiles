vim.loader.enable()

require("config.lazy")

require("mason").setup()
require("mason-lspconfig").setup()
require("mini.pairs").setup()
require("config.settings")
require("config.keymap")
require("config.autocmds")
