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
