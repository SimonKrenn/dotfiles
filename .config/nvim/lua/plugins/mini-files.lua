return {
	"echasnovski/mini.files",
	opts = {
		windows = {
			preview = true,
			width_focus = 30,
			with_preview = 30,
		},
		options = {
			use_as_default_explorer = true
		},
	},
	keys = {
		{
			"<leader>mf",
			function()
				require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
			end,
			desc = "Open mini.files (currDir)"
		}
	},
	config = function(_, opts)
		require("mini.files").setup(opts)
	end
}
