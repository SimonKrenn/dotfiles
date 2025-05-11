return {
	-- https://github.com/MeanderingProgrammer/render-markdown.nvim
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		opts = {},
		ft = { "markdown", "codecompanion" }
	},
	--https://github.com/iamcco/markdown-preview.nvim
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	--https://github.com/davidmh/mdx.nvim
	{
		"davidmh/mdx.nvim",
		config = true,
		enabled = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	}
}
