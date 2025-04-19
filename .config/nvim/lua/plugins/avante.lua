return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	enabled = false,
	version = false,
	opts = {
		provider = "ollama",
		ollama = {
			endpoint = "http://127.0.0.1:11434",
			model = "gemma3:27b"
		}
	},
	build = "make",
}
