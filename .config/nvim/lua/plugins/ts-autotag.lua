return {
	"windwp/nvim-ts-autotag",
	opts = {
		enable_close = true,
		enable_rename = true,
	},
	config = function()
		require("nvim-ts-autotag").setup()
	end
}
