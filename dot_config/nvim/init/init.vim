syntax off

let $BASE_DIR = join([$XDG_CONFIG_HOME, $NVIM_APPNAME ?? 'nvim'], '/')

augroup MyAutoCmd
autocmd!
augroup END

let g:mapleader = ' '

lua vim.loader.enable()

execute 'source' $"{'<sfile>'->expand()->fnamemodify(':h')}/plugins/dpp.vim"

command! ToggleNum set rnu!
command! InlayHintToggle lua vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
