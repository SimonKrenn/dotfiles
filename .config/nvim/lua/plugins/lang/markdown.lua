return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
    ft = { "markdown", "mdx" },
  },
  {
    "davidmh/mdx.nvim",
    config = true,
    enabled = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
