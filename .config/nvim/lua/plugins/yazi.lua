return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim"
	},
	keys = {
		{ "<leader>gy", "<cmd>Yazi<CR>", desc = "toggle yazi" }
	},
}
