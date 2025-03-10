return {
	'tzachar/cmp-ai',
	enabled = false,
	config = function()
		local cmp_ai = require('cmp_ai.config')
		cmp_ai:setup({
			max_lines = 100,
			provider = 'Ollama',
			provider_options = {
				stream = true,
				model = 'deepseek-r1:14b',
				auto_unload = false,
			},
			notify = true,
			notify_callback = function(msg)
				vim.notify(msg)
			end,
			run_on_every_keystroke = false,
			ignored_file_types = {
				-- default is not to ignore
				-- uncomment to ignore in lua:
				-- lua = true
			},
		})
	end,
}
