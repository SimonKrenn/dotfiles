return {
	'milanglacier/minuet-ai.nvim',
	config = function()
		require('minuet').setup {
			debug = false,
			notify = false,
			provider = 'openai_fim_compatible',
			context_window = 512,
			provider_options = {
				openai_fim_compatible = {
					api_key = 'TERM',
					name = 'Ollama',
					end_point = 'http://localhost:11434/v1/completions',
					model = 'deepseek-coder-v2:16b',
				},
			}, }
	end,
}
