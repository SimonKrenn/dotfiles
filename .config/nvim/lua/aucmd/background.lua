vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    local plugin = require("lazy.core.config").plugins["neovim-ayu"]
    require("lazy.core.loader").reload(plugin)
  end,
})
