local keymap = vim.keymap.set
local opts = { silent = true }
-- window nav--
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-s>", "<Cmd>w<CR>", opts)

keymap('t', '<esc>', '<C-\\><C-n>', { silent = true })
keymap('n', '<leader>df', vim.diagnostic.open_float, { desc = 'open diagnostic as a float' })


vim.g.copilot_no_tab_map = true
