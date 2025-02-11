return {
	"folke/which-key.nvim",
	enabled = true,
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		preset = 'helix'
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
	end
}
