syntax off

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
let g:loaded_matchparen = 1
let vimsyn_embed = 1
let loaded_python_provider = 0
let loaded_perl_provider = 0
let loaded_ruby_provider = 0
let loaded_rrhelper = 1
let loaded_vimball = 1
let loaded_vimballPlugin = 1
let loaded_getscript = 1
let loaded_getscriptPlugin = 1
let loaded_logipat = 1
let loaded_man = 1
let did_install_default_menus = 1
let did_install_syntax_menu = 1
let skip_loading_mswin = 1
let loaded_2html_plugin = 1
let loaded_matchit = 1
let loaded_netrwPlugin = 1
let loaded_spellfile_plugin = 1
let loaded_zipPlugin = 1
let loaded_tarPlugin = 1
let loaded_shada_plugin = 1
let loaded_gzip = 1
let did_indent_on = 1
let did_load_filetypes = 1

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

command! ToggleNum set rnu!

if has('nvim')
  lua vim.notify = function (msg) return nil end
endif
