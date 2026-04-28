local function reload_onehunter()
  if vim.g.colors_name ~= "onehunter" then
    return
  end

  package.loaded["one-hunter"] = nil
  package.loaded["one-hunter.colorscheme"] = nil

  pcall(vim.cmd.colorscheme, "one-hunter")
end

local onehunter_background = vim.api.nvim_create_augroup("onehunter_background", { clear = true })

vim.api.nvim_create_autocmd("OptionSet", {
  group = onehunter_background,
  pattern = "background",
  callback = function()
    vim.schedule(reload_onehunter)
  end,
})
