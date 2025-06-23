if not vim.g.vscode then
	return {}
end

local enabled = {
	-- "snacks.nvim",
	"nvim-treesitter",
	"lazy.nvim"
}


local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
	return vim.tbl_contains(enabled, plugin.name)
end


local function notify(cmd)
	return string.format("<cmd>call VSCodeNotify('%s')<CR>", cmd)
end

local function v_notify(cmd)
	return string.format("<cmd>call VSCodeNotifyVisual('%s', 1)<CR>", cmd)
end

vim.g.snacks_animate = false


vim.keymap.set("n", "<leader><space>", notify('workbench.action.quickOpen'))
vim.keymap.set("n", "<leader>nf", notify('workbench.action.toggleSidebarVisibility'))
vim.keymap.set("n", "<leader>fg", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
vim.keymap.set("n", "<leader>ss", [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])


-- undo/redo
vim.keymap.set("n", "u", notify('undo'))
vim.keymap.set("n", "<C-r>", notify('redo'))

-- lsp stuff
vim.keymap.set("n", "gr", notify('editor.action.referenceSearch.trigger'))

return {
	-- {
	-- 	-- "snacks.nvim",
	-- 	-- opts = {
	-- 	-- 	bigfile = { enabled = false },
	-- 	-- 	hashboard = { enabled = false },
	-- 	-- 	indent = { enabled = false },
	-- 	-- 	input = { enabled = false },
	-- 	-- 	notifier = { enabled = false },
	-- 	-- 	picker = { enabled = false },
	-- 	-- 	quickfile = { enabled = false },
	-- 	-- 	scroll = { enabled = false },
	-- 	-- 	statuscolumn = { enabled = false },
	-- 	-- 	keymap = { enabled = false }
	-- 	-- },
	-- },
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { highlight = { enable = false } },
	},
}
