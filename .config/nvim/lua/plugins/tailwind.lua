return {
	"luckasRanarison/tailwind-tools.nvim",
	name = "tailwind-tools",
	build = ":UpdateRemotePlugins",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim", -- optional
		"neovim/nvim-lspconfig",   -- optional
	},
	opts = {
		server = {
			settings = {
				experimental = {
					classRegex = {
						"tw`([^`]*)",
						'tw="([^"]*)',
						'tw={"([^"}]*)',
						"tw\\.\\w+`([^`]*)",
						"tv\\(\\{([\\s\\S]*?)\\}\\)", "(['\"`])(.*?)\\1",
						"tw\\(.*?\\)`([^`]*)",
						{ "clsx\\(([^)]*)\\)",       "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						{ "classnames\\(([^)]*)\\)", "'([^']*)'" },
						{ "cva\\(([^)]*)\\)",        "[\"'`]([^\"'`]*).*?[\"'`]" },
						{ "cn\\(([^)]*)\\)",         "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						{ "tv\\(([^)]*)\\)",         "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						{ "variants\\(([^)]*)\\)",   "(?:'|\"|`)([^']*)(?:'|\"|`)" }
					},
				},
			},
		},
	} -- your configuration
}
