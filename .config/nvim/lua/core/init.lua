local api = vim.api

vim.cmd('augroup MyAutoCmd')
vim.cmd('autocmd!')
vim.cmd('augroup END')

vim.cmd('filetype off')
vim.cmd('syntax off')

if vim.fn.exists('g:nvui') == 1 then
  require('core.nvui')
end

vim.g.mapleader = " "

local vars = {
  python_host_prog = '/usr/bin/python2',
  python3_host_prog = '/usr/bin/python3',
  loaded_matchparen = 1,
  vimsyn_embed = 1,
  loaded_python_provider = 0,
  loaded_perl_provider = 0,
  loaded_ruby_provider = 0,
  loaded_rrhelper = 1,
  loaded_vimball = 1,
  loaded_vimballPlugin = 1,
  loaded_getscript = 1,
  loaded_getscriptPlugin = 1,
  loaded_logipat = 1,
  loaded_man = 1,
}

for var, val in pairs(vars) do
  api.nvim_set_var(var, val)
end

require('core.options')
require('plugins.dein')
require('core.keys')

vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

vim.cmd('command! ToggleNum set rnu!')

vim.notify = function (msg) return nil end
