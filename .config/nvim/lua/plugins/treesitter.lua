return {
	-- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	event = 'VeryLazy',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	build = ':TSUpdate',
	opts = {
		-- Add languages to be installed here that you want installed for treesitter
		ensure_installed = { 'lua', 'typescript', 'vimdoc', 'html', "java", "yaml", "jsdoc", "tsdoc", "javascript", "json", "jsonc", "toml", "bash", "fish", "typescriptreact" },
		highlight = { enable = true, },
		additional_vim_regex_highlighting = false,
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = '<c-space>',
				node_incremental = '<c-space>',
				scope_incremental = '<c-s>',
				node_decremental = '<c-backspace>',
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					['aa'] = '@parameter.outer',
					['ia'] = '@parameter.inner',
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					[')f'] = '@function.outer',
					[')c'] = '@class.outer',
				},
				goto_next_end = {
					[')F'] = '@function.outer',
					[')C'] = '@class.outer',
				},
				goto_previous_start = {
					['(f'] = '@function.outer',
					['(c'] = '@class.outer',
				},
				goto_previous_end = {
					['(F'] = '@function.outer',
					['(C'] = '@class.outer',
				},
			},
			swap = {
				enable = true,
				swap_next = {
					['<leader>a'] = '@parameter.inner',
				},
				swap_previous = {
					['<leader>A'] = '@parameter.inner',
				},
			},
		},
	}
}
