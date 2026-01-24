return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
    ft = { "markdown", "mdx" },
  },
  {
    "davidmh/mdx.nvim",
    config = function()
      -- No setup required for mdx.nvim
    end,
    enabled = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && yarn install",
  },
}
