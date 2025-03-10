return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {},
	config = function()
		require('typescript-tools').setup {
			-- local nvim_lsp = require("neovim/nvim-lspconfig"),
			single_file_support = false,
			root_dir = require("lspconfig").util.root_pattern '.git',
		}
	end,
}
