local api = vim.api

vim.cmd('syntax off')

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
  did_install_default_menus = 1,
  did_install_syntax_menu = 1,
  skip_loading_mswin = 1,
  loaded_2html_plugin = 1,
  loaded_matchit = 1,
  loaded_netrwPlugin = 1,
  loaded_spellfile_plugin = 1,
  loaded_zipPlugin = 1,
  loaded_tarPlugin = 1,
  loaded_shada_plugin = 1,
  loaded_gzip = 1,
  did_indent_on = 1,
  did_load_filetypes = 1
}

for var, val in pairs(vars) do
  api.nvim_set_var(var, val)
end

vim.cmd('augroup MyAutoCmd')
vim.cmd('autocmd!')
vim.cmd('augroup END')

if vim.fn.exists('g:nvui') == 1 then
  require('core.nvui')
end

vim.g.mapleader = " "

require('core.options')
require('plugins.dein')
require('core.keys')

vim.cmd('command! ToggleNum set rnu!')

vim.notify = function (msg) return nil end
