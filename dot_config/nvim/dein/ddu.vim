" hook_post_source {{{
call ddu#custom#load_config(expand(join([$BASE_DIR, 'ddu.ts'], '/')))
" }}}

" ddu-ff {{{
nnoremap <buffer> <CR> <Cmd>call ddu#ui#do_action("itemAction")<CR>
nnoremap <buffer> <Space> <Cmd>call ddu#ui#do_action("toggleSelectItem")<CR>
nnoremap <buffer> i <Cmd>call ddu#ui#do_action("openFilterWindow")<CR>
nnoremap <buffer> q <Cmd>call ddu#ui#do_action("quit")<CR>
nnoremap <buffer> p <Cmd>call ddu#ui#do_action("previewPath")<CR>
nnoremap <buffer> P <Cmd>call ddu#ui#do_action("preview")<CR>
nnoremap <buffer> a <Cmd>call ddu#ui#do_action("chooseAction")<CR>
setlocal cursorline
" }}}

" ddu-ff-filter {{{
inoremap <buffer> <CR> <Cmd>call ddu#ui#do_action("closeFilterWindow")<CR>
nnoremap <buffer> <CR> <Cmd>call ddu#ui#do_action("closeFilterWindow")<CR>
" }}}

" ddu-filer {{{
nnoremap <buffer><silent> <CR>
      \ <Cmd>call ddu#ui#filer#do_action('itemAction')<CR>
nnoremap <buffer><silent> <Space>
      \ <Cmd>call ddu#ui#filer#do_action('toggleSelectItem')<CR>
nnoremap <buffer> l
      \ <Cmd>call ddu#ui#filer#do_action('expandItem',
      \ {'mode': 'toggle'})<CR>
nnoremap <buffer> h
      \ <Cmd>call ddu#ui#filer#do_action('collapseItem')<CR>
nnoremap <buffer><silent> q
      \ <Cmd>call ddu#ui#filer#do_action('quit')<CR>
nnoremap <buffer><silent> <C-e>
      \ <Cmd>call ddu#ui#filer#do_action('quit')<CR>
'''
" }}}
