return {
	{
		--https://github.com/dmmulroy/ts-error-translator.nvim
		'dmmulroy/ts-error-translator.nvim',
		ft = { "typescript", "typescriptreact" },
		config = function()
			require("ts-error-translator").setup()
		end
	}
}
