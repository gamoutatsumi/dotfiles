vim.o.completeopt = 'menuone,noselect,noinsert'
vim.cmd('set tagfunc=CocTagFunc')
vim.env.NVIM_COC_LOG_LEVEL = 'error'
vim.g.coc_global_extensions = {
  'coc-pairs',
  'coc-snippets',
  'coc-json',
  'coc-yaml',
  'coc-marketplace',
  -- 'coc-discord-neovim',
  'coc-markdownlint',
  'coc-rust-analyzer',
  'coc-go',
  'https://github.com/rodrigore/coc-tailwind-intellisense',
  'coc-stylelint',
  'coc-html',
  'coc-docker',
  'coc-vetur',
  'coc-pyright',
  'coc-deno',
  'coc-emoji',
  'coc-spell-checker',
  'coc-phpls',
  '@yaegassy/coc-nginx',
  'coc-eslint',
  'coc-clangd',
  'coc-vimlsp',
  'coc-toml',
  'coc-restclient'
}
vim.api.nvim_set_keymap( 'i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', { silent = true, expr = true })
vim.api.nvim_set_keymap( 'i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', { silent = true, expr = true })
vim.api.nvim_set_keymap( 'n', 'gd', '<cmd>vsp<CR><Plug>(coc-definition)', { silent = true })
vim.api.nvim_set_keymap( 'n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
vim.api.nvim_set_keymap( 'n', 'gi', '<Plug>(coc-implementation)', { silent = true })
vim.api.nvim_set_keymap( 'n', 'gr', '<Plug>(coc-references)', { silent = true })
vim.api.nvim_set_keymap( 'n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
vim.api.nvim_set_keymap( 'n', 'g]', '<Plug>(coc-diagnostic-next)', { silent = true })
vim.api.nvim_set_keymap( 'n', '<Leader>rn', '<Plug>(coc-rename)', { silent = true })
vim.api.nvim_set_keymap( 'n', 'K', '<cmd>lua ShowCocDocumentation()<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap( 'i', '<CR>', 'pumvisible() ? coc#_select_confirm() : "<C-g>u<CR><C-r>=coc#on_enter()<CR>"', { silent = true, noremap = true, expr = true })
vim.api.nvim_buf_set_keymap( 0, 'i', '<Esc>', 'pumvisible() ? "<C-e>" : "<Esc>"', { silent = true, nowait = true, expr = true })
function ShowCocDocumentation()
  if (vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0) then
    vim.cmd('execute "h ".expand("<cword>")')
  else
    vim.fn['CocAction']('doHover')
  end
end
vim.cmd('autocmd CursorHold * silent call CocActionAsync("highlight")')

function _G.SwitchCocTs()
  local path = #vim.fn.expand('%') == 0 and vim.cmd('pwd') or vim.fn.expand('%:p:h')
  local pwd = vim.cmd('pwd')
  if #(vim.fn.finddir('node_modules', path)) == 0 and #(vim.fn.finddir('node_modules', pwd)) == 0 then
    vim.fn['coc#config']('deno.enable', true)
    vim.fn['coc#config']('tsserver.enable', false)
    else
    vim.fn['coc#config']('deno.enable', false)
    vim.fn['coc#config']('tsserver.enable', true)
  end
end

vim.cmd('autocmd FileType typescript,typescript.tsx,typescriptreact,javascript ++once call v:lua.SwitchCocTs()')
