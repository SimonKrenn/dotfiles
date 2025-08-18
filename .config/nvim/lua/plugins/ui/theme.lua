return {
  {

    "mcauley-penney/phobos-anomaly.nvim",
    enabled = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("phobos-anomaly")
    end,
  },
  {
    dir = "~/workspace/eldritch-base.nvim",
    enabled = true,
    init = function()
      vim.cmd.colorscheme("eldritchbase")
    end,
  },
}
