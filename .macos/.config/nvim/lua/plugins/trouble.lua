return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "TroubleToggle", "Trouble" },
	keys = {
		{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics" },
		{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
		{ "<leader>xL", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List" },
		{ "leader>xQ",  "<cmd>TroubleToggle quickfix<cr>",              desc = " Quickfix List" }
	}
}
