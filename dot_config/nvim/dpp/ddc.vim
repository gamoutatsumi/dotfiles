" hook_add {{{ 
function! s:commandlinePre() abort
  cmap <silent><expr> <Tab>   pum#visible() ? '<Cmd>call pum#map#insert_relative(+1, "loop")<CR>' : '<Cmd>call ddc#map#manual_complete()<CR><Cmd>call pum#map#insert_relative(+1)<CR>'
  cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1, 'loop')<CR>
  cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
  cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
  call cmdline#enable()

  autocmd User DDCCmdlineLeave ++once call s:commandlinePost()

  " Enable command line completion for the buffer
  call ddc#enable_cmdline_completion()
endfunction

function! SearchlinePre() abort
  cnoremap <Tab>   <Cmd>call pum#map#insert_relative(+1, 'loop')<CR>
  cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1, 'loop')<CR>
  cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
  cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
  cmap <silent><expr> <CR>   pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'

  call cmdline#enable()

  autocmd User DDCCmdlineLeave ++once call s:commandlinePost()

  " Enable command line completion for the buffer
  call ddc#enable_cmdline_completion()
endfunction

autocmd User SearchxEnter call SearchlinePre()

function! s:commandlinePost() abort
  silent! cunmap <Tab>
  silent! cunmap <S-Tab>
  silent! cunmap <C-e>
  silent! cunmap <CR>
  silent! cunmap <C-y>
endfunction
nnoremap :       <Cmd>call <SID>commandlinePre()<CR>:

call join([$BASE_DIR, 'ddc.ts'], '/')->expand()->ddc#custom#load_config()
call ddc#enable(#{context_filetype: "treesitter"})
" pum.vim
imap <silent><expr> <TAB> pum#visible() ? '<Cmd>call pum#map#insert_relative(+1, "loop")<CR>' : denippet#jumpable(1) ? '<Plug>(denippet-jump-next)' : '<TAB>'
imap <silent><expr> <C-n> pum#visible() ? '<Cmd>call pum#map#select_relative(+1, "loop")<CR>' : '<Cmd>call ddc#map#manual_complete()<CR><Cmd>call pum#map#select_relative(+1, "loop")<CR>'
smap <silent><expr> <TAB> denippet#jumpable(1) ? '<Plug>(denippet-jump-next)' : '<TAB>'
imap <silent><expr> <S-TAB> pum#visible() ? '<Cmd>call pum#map#insert_relative(-1, "loop")<CR>' : denippet#jumpable(-1) ? '<Plug>(denippet-jump-prev)' : '<S-TAB>'
imap <silent><expr> <C-p> pum#visible() ? '<Cmd>call pum#map#select_relative(-1, "loop")<CR>' : '<Cmd>call ddc#map#manual_complete()<CR><Cmd>call pum#map#select_relative(-1, "loop")<CR>'
smap <silent><expr> <S-TAB> denippet#jumpable(-1) ? '<Plug>(denippet-jump-prev)' : '<S-TAB>'
imap <silent><expr> <CR>   pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
" }}}
" hook_post_update {{{
call ddc#set_static_import_path()
" }}}
