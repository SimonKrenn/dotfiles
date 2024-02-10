-- Fuzzy Finder (files, lsp, etc)
return {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            -- NOTE: If you are having trouble with this installation,
            --       refer to the README for telescope-fzf-native for more instructions.
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
    },
    opts = {
        defaults = {
            mappings = {
                    i = {},
            },
            preview = {
                treesitter = false,
            }
        },
        pickers = {
            find_files = {
                hidden = true,
            },
        },
        extensions = {
            file_browser = {
                theme = "ivy",
                hijack_netrw = true,
            }
        }
    },
    config = function(_, opts)
        local actions = require('telescope.actions')
        opts.defaults.mappings.i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-Up>'] = actions.cycle_history_prev,
            ['<C-Down>'] = actions.cycle_history_next,
        }
        require('telescope').setup(opts)
        require('telescope').load_extension "file_browser"
        pcall(require('telescope').load_extension, 'fzf')
    end
}

