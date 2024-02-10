return {
	--	"rebelot/kanagawa.nvim",
	--	 config = function()
	--      -- load the colorscheme here
	--      vim.cmd([[colorscheme kanagawa]])
	--    end
	-- oxocarbon theme
	'nyoom-engineering/oxocarbon.nvim',
	config = function()
		local oxocarbon = require("oxocarbon")
		vim.o.termguicolors = true
		vim.o.background = "dark"
		vim.cmd [[colorscheme oxocarbon]]
		vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = oxocarbon.blend, bg = oxocarbon.blend })
		vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = oxocarbon.base02, bg = oxocarbon.base02 })
		vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = oxocarbon.base05, bg = oxocarbon.base02 })
		vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = oxocarbon.base08, bg = oxocarbon.base02 })
		vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = oxocarbon.none, bg = oxocarbon.blend })
		vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = oxocarbon.base02, bg = oxocarbon.base12 })
		vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = oxocarbon.base02, bg = oxocarbon.base11 })
		vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = oxocarbon.blend, bg = oxocarbon.blend })
		vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = oxocarbon.none, bg = oxocarbon.base02 })
		vim.api.nvim_set_hl(0, "TelescopePreviewLine", { fg = oxocarbon.none, bg = oxocarbon.base01 })
		vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { fg = oxocarbon.base13, bg = oxocarbon.base02 })
		vim.api.nvim_set_hl(0, "NeoTreeNormal", { fg = oxocarbon.base13, bg = oxocarbon.base02 })
	end
}
