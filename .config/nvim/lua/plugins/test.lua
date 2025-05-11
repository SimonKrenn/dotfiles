return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter"
	},
	opts = {
		adapters = {}
	},
	status = {
		virtual_text = true,
	},
	output = {
		open_on_run = true,
	},
	quickfix = {
		open = function()
			require("trouble").open({ mode = "quickfix", focus = false })
		end
	},
}
