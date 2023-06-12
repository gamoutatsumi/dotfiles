" hook_add {{{
let g:fern#disable_drawer_hover_popup=1
let g:fern#drawer_width=30
let g:fern#renderer="nerdfont"
let g:fern#renderer#nerdfont#padding='  '
let g:fern#renderer#nerdfont#indent_markers=1
let g:fern#disable_default_mappings=1
let g:fern#hide_cursor=0
let g:fern#default_hidden=1
let g:fern_disable_startup_warnings=1
nnoremap <silent> <C-e> <cmd>Fern . -drawer -reveal=%:p -toggle<CR>
nnoremap <silent> <Plug>(fern-close-drawer) <cmd>FernDo close -drawer -stay<CR>
" }}}

" fern {{{
nmap <buffer><silent><nowait> <Plug>(fern-action-open-and-close) <Plug>(fern-action-open:select)<Plug>(fern-close-drawer)
nmap <buffer><silent><nowait><expr> <Plug>(fern-expand-or-collapse) fern#smart#leaf("<Plug>(fern-action-collapse)", "<Plug>(fern-action-expand)", "<Plug>(fern-action-collapse)")
nmap <buffer><silent><nowait><expr> <Plug>(fern-open-or-expand) fern#smart#leaf("<Plug>(fern-action-open-and-close)", "<Plug>(fern-action-expand)")
nmap <buffer><silent><nowait> a <Plug>(fern-choice)
nmap <buffer><silent><nowait> t <Plug>(fern-expand-or-collapse)
nmap <buffer><silent><nowait> <CR> <Plug>(fern-open-or-expand)
nmap <buffer><silent><nowait> o <Plug>(fern-action-open-and-close)
nmap <buffer><silent><nowait> l <Plug>(fern-action-expand)
nmap <buffer><silent><nowait> h <Plug>(fern-action-collapse)
nmap <buffer><silent><nowait> x <Plug>(fern-action-mark:toggle)
vmap <buffer><silent><nowait> x <Plug>(fern-action-mark:toggle)
nmap <buffer><silent><nowait> N <Plug>(fern-action-new-file)
nmap <buffer><silent><nowait> K <Plug>(fern-action-new-dir)
nmap <buffer><silent><nowait> d <Plug>(fern-action-trash)
nmap <buffer><silent><nowait> r <Plug>(fern-action-rename)
nmap <buffer><silent><nowait> c <Plug>(fern-action-copy)
nmap <buffer><silent><nowait> m <Plug>(fern-action-move)
nmap <buffer><silent><nowait> ! <Plug>(fern-action-hidden-toggle)
nmap <buffer><silent><nowait> <C-g> <Plug>(fern-action-debug)
nmap <buffer><silent><nowait> ? <Plug>(fern-action-help)
nmap <buffer><silent><nowait> <C-c> <Plug>(fern-action-cancel)
nmap <buffer><silent><nowait> . <Plug>(fern-action-repeat)
nmap <buffer><silent><nowait> R <Plug>(fern-action-redraw)
nmap <buffer><silent><nowait> q <cmd>quit<CR>
nmap <buffer><silent><nowait> Q <cmd>bwipe!<CR>
setlocal nonu
setlocal signcolumn=no
setlocal nornu
call glyph_palette#apply()
" }}}
