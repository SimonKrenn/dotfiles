return {
	{
		-- https://github.com/echasnovski/mini.pairs
		"echasnovski/mini.pairs"
	},
	{
		-- https://github.com/echasnovski/mini.surround
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
	},
	{
		--https://github.com/echasnovski/mini.comment
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
		},
	},
	{
		-- https://github.com/danymat/neogen
		"danymat/neogen",
		config = true,
	},
	{
		--https://github.com/ThePrimeagen/harpoon/tree/harpoon2
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		requires = { { 'nvim-lua/plenary.nvim' } },
		opts = {
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
			settings = {
				save_on_toggle = true,
			}
		},
		keys = function()
			local keys = {
				{
					'<leader>H',
					function()
						require('harpoon'):list():add()
					end,
					desc = "Harpoon File"
				},
				{
					'<leader>h',
					function()
						local harpoon = require('harpoon')
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Harpoon Quick Menu",
				},
			}
			for i = 1, 5 do
				table.insert(keys, {
					"<leader>" .. i,
					function()
						require("harpoon"):list():select(i)
					end,
					desc = "Harpoon to File " .. i,
				})
			end
			return keys
		end,
	},
	{
		--https://github.com/nvim-pack/nvim-spectre
		'nvim-pack/nvim-spectre',
		build = false,
		cmd = "Spectre",
		opts = { open_cmd = "noswapfile vnew" },
		keys = {
			{
				"<leader>sr",
				function()
					require("spectre").open()
				end,
				desc = "Replace in Files (Spectre)"
			}
		}
	},
	{
		--https://github.com/m4xshen/hardtime.nvim
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			enabled = false
		},
		event = "BufEnter"

	}
}
