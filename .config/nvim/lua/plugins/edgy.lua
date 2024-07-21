return {
	"folke/edgy.nvim",
	enabled = true,
	event = "VeryLazy",
	init = function()
		vim.opt.laststatus = 3
		vim.opt.splitkeep = "screen"
	end,
	keys = {
		-- stylua: ignore
		{ "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
	},
	opts = {
		bottom = {
			-- toggleterm / lazyterm at the bottom with a height of 40% of the screen
			{
				ft = "toggleterm",
				size = { height = 0.25 },
				-- exclude floating windows
				filter = function(buf, win)
					return vim.api.nvim_win_get_config(win).relative == ""
				end,
			},
			"Trouble",
			{ ft = "qf", title = "QuickFix" },
			{
				ft = "help",
				size = { height = 20 },
				-- only show help buffers
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
		},
		left = {
			-- Neo-tree filesystem always takes half the screen height
			{
				title = "Neo-Tree",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "filesystem"
				end,
				size = { height = 0.5 },
			},
			{
				title = "Neo-Tree Git",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "git_status"
				end,
				pinned = true,
				open = "Neotree position=right git_status",
			},
			{
				title = "Neo-Tree Buffers",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "buffers"
				end,
				pinned = true,
				open = "Neotree position=top buffers",
			},
			{
				ft = "Outline",
				pinned = true,
				open = "Outline"
			},
		},
	},
}
