vim.loader.enable()

require("simon.lazy")

require("mason").setup()
require("mason-lspconfig").setup()
require("mini.pairs").setup()
require("simon.settings")
require("simon.keymap")
require("simon.bubble-line")
