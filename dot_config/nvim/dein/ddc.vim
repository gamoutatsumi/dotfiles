" hook_add {{{ 
function! CommandlinePre() abort
    cnoremap <Tab>   <Cmd>call pum#map#insert_relative(+1)<CR>
    cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
    cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
    cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>

    autocmd User DDCCmdlineLeave ++once call CommandlinePost()

    " Enable command line completion for the buffer
    call ddc#enable_cmdline_completion()
endfunction
function! CommandlinePost() abort
    silent! cunmap <Tab>
    silent! cunmap <S-Tab>
    silent! cunmap <C-e>
    silent! cunmap <CR>
endfunction
nnoremap :       <Cmd>call CommandlinePre()<CR>:
" }}}

" hook_post_source {{{
" pum.vim
imap <silent><expr> <TAB> pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<TAB>'
imap <silent><expr> <C-n> pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<Cmd>call ddc#map#manual_complete()<CR><Cmd>call pum#map#select_relative(+1)<CR>'
smap <silent><expr> <TAB> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<TAB>'
imap <silent><expr> <S-TAB> pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-TAB>'
imap <silent><expr> <C-p> pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<Cmd>call ddc#map#manual_complete()<CR><Cmd>call pum#map#select_relative(-1)<CR>'
smap <silent><expr> <S-TAB> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-TAB>'
imap <silent><expr> <CR>   pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'

" ddc.vim
lua require("ddc_nvim_lsp_setup").setup()
call ddc#custom#load_config(expand(join([$BASE_DIR, 'ddc.ts'], '/')))
call ddc#custom#patch_global('sourceParams', #{
      \   nvim-lsp: #{
      \     snippetEngine: denops#callback#register({
      \           body -> vsnip#anonymous(body)
      \     }),
      \   }
      \ })
call ddc#enable()
" }}}
