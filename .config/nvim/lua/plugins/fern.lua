vim.g['fern#drawer_width'] = 30
vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#renderer#nerdfont#padding'] = '  '
vim.g['fern#disable_default_mappings'] = 1
vim.g['fern#hide_cursor'] = 1
vim.g['fern#default_hidden'] = 1
vim.api.nvim_set_keymap('n', '<C-e>', '<cmd>Fern . -drawer -reveal=% -toggle<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<Plug>(fern-close-drawer)', ':<C-u>FernDo close -drawer -stay<CR>', { silent = true, noremap = true })
function FernSettings()
  vim.api.nvim_buf_set_keymap(0, 'n', '<Plug>(fern-action-open-and-close)', '<Plug>(fern-action-open:select)<Plug>(fern-close-drawer)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '<Plug>(fern-expand-or-collapse)', 'fern#smart#leaf("<Plug>(fern-action-collapse)", "<Plug>(fern-action-expand)", "<Plug>(fern-action-collapse)")', { silent = true, nowait = true, expr = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '<Plug>(fern-open-or-expand)', 'fern#smart#leaf("<Plug>(fern-action-open-and-close)", "<Plug>(fern-action-expand)")', { expr = true, silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'a', '<Plug>(fern-choice)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 't', '<Plug>(fern-expand-or-collapse)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<Plug>(fern-open-or-expand)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'o', '<Plug>(fern-action-open-and-close)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'l', '<Plug>(fern-action-expand)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'h', '<Plug>(fern-action-collapse)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'x', '<Plug>(fern-action-mark:toggle)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'v', 'x', '<Plug>(fern-action-mark:toggle)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'N', '<Plug>(fern-action-new-file)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<Plug>(fern-action-new-dir)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'd', '<Plug>(fern-action-trash)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'r', '<Plug>(fern-action-rename)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'c', '<Plug>(fern-action-copy)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'm', '<Plug>(fern-action-move)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '!', '<Plug>(fern-action-hidden-toggle)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-g>', '<Plug>(fern-action-debug)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '?', '<Plug>(fern-action-help)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-c>', '<Plug>(fern-action-cancel)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', '.', '<Plug>(fern-action-repeat)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'R', '<Plug>(fern-action-redraw)', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>quit<CR>', { silent = true, nowait = true })
  vim.api.nvim_buf_set_keymap(0, 'n', 'Q', '<cmd>bwipe!<CR>', { silent = true, nowait = true, noremap = true })
  vim.wo.number = false
  vim.wo.signcolumn = 'no'
  vim.wo.relativenumber = false
end
vim.cmd('autocmd FileType fern lua FernSettings()')
vim.cmd('autocmd FileType fern call glyph_palette#apply()')
