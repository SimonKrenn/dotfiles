local o, opt, wo = vim.o, vim.opt, vim.wo

o.clipboard = 'unnamedplus'

opt.tabstop = 2
opt.shiftwidth = 2

vim.wo.number = true

opt.fillchars = {
  eob = ' '
}

o.splitright = true
o.splitbelow = true
o.splitkeep = 'screen'

o.termguicolors = true
o.winborder = 'rounded'

vim.cmd([[let &t_Cs = "\e[4:3m"]]) -- undercurl
vim.cmd([[let &t_Ce = "\e[4:0m"]]) -- underscore

-- enables spell check
opt.spell = true
opt.spelllang = { "en_us" }
