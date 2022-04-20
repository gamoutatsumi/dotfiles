syntax off

if has('nvim')
  let g:did_load_filetypes = 0
  let g:do_filetype_lua = 1
endif
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
let g:loaded_matchparen = 1
let g:vimsyn_embed = 1
let g:loaded_python_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_rrhelper = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_logipat = 1
let g:loaded_man = 1
let g:did_install_default_menus = 1
let g:did_install_syntax_menu = 1
let g:skip_loading_mswin = 1
let g:loaded_2html_plugin = 1
let g:loaded_matchit = 1
let g:loaded_netrwPlugin = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_shada_plugin = 1
let g:loaded_gzip = 1
let g:did_indent_on = 1

augroup MyAutoCmd
autocmd!
augroup END

if exists('g:nvui')
  runtime init/core/nvui.vim
endif

let g:mapleader = ' '

runtime init/core/opts.vim
runtime init/plugins/dein.vim
runtime init/core/keys.vim

syntax on

command! ToggleNum set rnu!
