return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ipl",
	opts = {},
	config = function()
		require("ibl").setup()
	end
}
