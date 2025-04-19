local keymap = vim.keymap.set
local opts = { silent = true }
-- window nav--
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-s>", "<Cmd>w<CR>", opts)

--Plugins--
-- --Telescope--
-- keymap('n', '<leader>ff', require('telescope.builtin').find_files, { desc = "[F]ind [F]iles" })
-- keymap('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = "[F]ind current [W]ord" })
-- keymap('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = "[F]ind [G]rep" })
-- keymap('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
-- keymap("n", "<leader>fl", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
-- keymap('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
-- keymap('n', '<leader>/', function()
-- 	-- You can pass additional configuration to telescope to change theme, layout, etc.
-- 	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
-- 		winblend = 10,
-- 		previewer = false,
-- 	})
-- end, { desc = '[/] Fuzzily search in current buffer]' })
-- keymap('n', '<leader>fm', require('telescope.builtin').marks, { desc = "[F]ind [M]arks" })
-- keymap('n', '<leader>tp', require('telescope.builtin').builtin, { desc = "[T]elescope [P]ickers" })

keymap('t', '<esc>', '<C-\\><C-n>', { silent = true })
keymap('n', '<leader>df', vim.diagnostic.open_float, { desc = 'open diagnostic as a float' })
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
