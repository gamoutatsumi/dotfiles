local api = vim.api

--[[ api.nvim_set_keymap('n', 'y', '"+y', { noremap = true })
api.nvim_set_keymap('v', 'y', '"+y', { noremap = true })
api.nvim_set_keymap('n', 'd', '"+d', { noremap = true })
api.nvim_set_keymap('v', 'd', '"+d', { noremap = true })
api.nvim_set_keymap('n', 'p', '"+p', { noremap = true }) ]]
api.nvim_set_keymap('n', 'x', '"_x', { noremap = true })
api.nvim_set_keymap('n', '<CR>', '<cmd>call append(".", "")<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', 'j', 'gj', { noremap = true })
api.nvim_set_keymap('n', 'k', 'gk', { noremap = true })
api.nvim_set_keymap('n', 'i', 'len(getline(".")) ? "i" : "cc"', { noremap = true, expr = true })
api.nvim_set_keymap('n', 'A', 'len(getline(".")) ? "A" : "cc"', { noremap = true, expr = true })
api.nvim_set_keymap('n', 'Y', '"+y$', { noremap = true })
api.nvim_set_keymap('n', 'Y', '"+y$', { noremap = true })
api.nvim_set_keymap('n', '0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { noremap = true, expr = true })
api.nvim_set_keymap('n', '<Leader>w', '<Cmd>update<CR>', { noremap = true })
api.nvim_set_keymap('n', '<Leader>q', '<Cmd>quit<CR>', { noremap = true })
api.nvim_set_keymap('n', '<Leader>Q', '<Cmd>quit!<CR>', { noremap = true })
