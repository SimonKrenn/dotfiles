local o, opt, wo, g = vim.o, vim.opt, vim.wo, vim.g

o.clipboard = "unnamedplus"
g.mapleader = " "
g.maplocalleader = "\\"

opt.tabstop = 2
opt.shiftwidth = 2

wo.number = true

opt.fillchars = {
  eob = " ",
}

o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"
opt.laststatus = 3

o.termguicolors = true
o.winborder = "rounded"

vim.cmd([[let &t_Cs = "\e[4:3m"]]) -- undercurl
vim.cmd([[let &t_Ce = "\e[4:0m"]]) -- underscore

-- enables spell check
opt.spell = true
opt.spelllang = { "en_us" }
