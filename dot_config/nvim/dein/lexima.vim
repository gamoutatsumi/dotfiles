" hook_post_source {{{
let g:lexima_map_escape = '<Plug>(lexima-escape)'
let g:lexima_no_default_rules = v:true
let g:lexima_accept_pum_with_enter = 0
call lexima#set_default_rules()
inoremap <silent><expr> <CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : lexima#expand('<LT>CR>', 'i')
imap <silent><expr> <Esc> pum#visible() ? '<Cmd>call pum#map#cancel()<CR>' : '<Plug>(lexima-escape)'
" }}}
