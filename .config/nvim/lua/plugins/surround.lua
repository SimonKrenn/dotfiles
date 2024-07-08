return {
	"echasnovski/mini.surround",
	keys = function(_, keys)
		local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
		local opts = require("lazy.core.plugin").values(plugin, "opts", false)
		local mappings = {
			{ opts.mappings.add,            desc = "Add surrounding",                     mode = { "n", "v" } },
			{ opts.mappings.delete,         desc = "Delete surrounding" },
			{ opts.mappings.find,           desc = "Find surrounding" },
			{ opts.mappings.find_left,      desc = "Find left surrounding" },
			{ opts.mappings.highlight,      desc = "highlight surrounding " },
			{ opts.mappings.replace,        desc = "replace surrounding " },
			{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
		}
		mappings = vim.tbl_filter(function(m)
			return m[1] and #m[1] > 0
		end, mappings)
		return vim.list_extend(mappings, keys)
	end,
	opts = {
		mappings = {
			add = "gsa",
			delete = "gsd",
			find = "gsf",
			find_left = "gsF",
			highlight = "gsh",
			replace = "gsr",
			update_n_lines = "gsn",
		},
	},
}
