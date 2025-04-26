vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.wo.number = true
vim.opt.splitkeep = "screen"

vim.o.statuscolumn = "%s %l %r"
vim.wo.relativenumber = true
vim.wo.number = true

vim.o.foldcolumn = '1'   -- '0' is not bad
vim.o.foldlevel = 99     -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)


vim.filetype.add({
	extension = {
		mdx = 'mdx'
	}
})

-- undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Enable spell check
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
