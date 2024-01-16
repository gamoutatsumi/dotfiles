syntax off

let $BASE_DIR = has('nvim') ? stdpath('config') : join([$XDG_CONFIG_HOME, 'vim'], '/')

augroup MyAutoCmd
autocmd!
augroup END

let g:mapleader = ' '

lua vim.loader.enable()

execute 'source' $"{'<sfile>'->expand()->fnamemodify(':h')}/plugins/dpp.vim"

command! ToggleNum set rnu!
command! InlayHintToggle lua vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
