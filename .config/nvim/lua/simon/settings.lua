vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.wo.number = true
vim.opt.splitkeep = "screen"

vim.o.statuscolumn = "%s %l %r"
vim.wo.relativenumber = true
vim.wo.number = true

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
