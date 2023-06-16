" hook_post_source {{{
call ddu#custom#load_config(expand(join([$BASE_DIR, 'ddu.ts'], '/')))
" }}}

" hook_add {{{
" ddu-source-lsp
nnoremap <silent> grf <Cmd>call ddu#start(#{ 
      \ sources: [#{ 
      \   name: 'lsp_references' 
      \ }], 
      \ uiParams: #{
      \   ff: #{
      \     autoAction: #{ 
      \       name: 'preview' 
      \     } 
      \   } 
      \ } 
      \ })<CR>
nnoremap <silent> ;d <Cmd>call ddu#start(#{
      \ sources: [#{ 
      \   name: 'lsp_diagnostic' 
      \ }], 
      \ uiParams: #{
      \   ff: #{
      \    autoAction: #{ name: 'preview' },
      \   },
      \ }
      \ })<CR>
nnoremap <silent> gd <Cmd>call ddu#start(#{
      \ sources: [#{ 
      \   name: 'lsp_definition',
      \   params: #{
      \     method: 'textDocument/definition' 
      \   } 
      \ }],
      \ uiParams: #{
      \   ff: #{
      \    autoAction: #{
      \     name: 'preview' 
      \    },
      \    immediateAction: 'open',
      \   },
      \ }
      \ })<CR>
nnoremap <silent> gD <Cmd>call ddu#start(#{
      \ sources: [#{ 
      \   name: 'lsp_definition', 
      \   params: #{
      \     method: 'textDocument/declaration' 
      \   } 
      \ }],
      \ uiParams: #{
      \   ff: #{
      \    autoAction: #{ 
      \     name: 'preview'
      \    },
      \    immediateAction: 'open',
      \   },
      \ }
      \ })<CR>
nnoremap <silent> gi <Cmd>call ddu#start(#{ 
      \ sources: [#{ 
      \   name: 'lsp_implementation', 
      \ }],
      \ uiParams: #{
      \  ff: #{
      \   autoAction: #{
      \     name: 'preview' 
      \   },
      \   immediateAction: 'open',
      \   },
      \ }
      \ })<CR>
" ddu-source-buffer
nnoremap <silent> ;b <Cmd>call ddu#start(#{ sources: [#{ name: 'buffer' }] })<CR>
" ddu-source-rg
function! s:ddu_find() abort
  let word = input("search word: ")
  call ddu#start(#{
        \ sources: [#{
        \   name: 'rg',
        \   params: #{
        \     input: word, 
        \     inputType: 'migemo',
        \     args: ['--ignore-case', '--json']
        \   }
        \ }],
        \ uiParams: #{
        \   ff: #{
        \     autoAction: #{ name: 'preview' },
        \   },
        \ }
        \ })
endfunction
nnoremap <silent> ;g <Cmd>call <SID>ddu_find()<CR>
" ddu-source-mr
nnoremap <silent> ;mu <Cmd>call ddu#start(#{
      \ sources: [#{
      \   name: 'mr', params: #{
      \     kind: 'mru', 
      \     current: v:true 
      \   } 
      \ }], 
      \ uiParams: #{
      \   ff: #{
      \    autoAction: #{
      \     name: 'preview' 
      \    },
      \   },
      \ }
      \ })<CR>
nnoremap <silent> ;mw <Cmd>call ddu#start(#{
      \ sources: [#{
      \   name: 'mr',
      \   params: #{
      \     kind: 'mrw', 
      \     current: v:true 
      \   }
      \ }], 
      \ uiParams: #{
      \   ff: #{
      \    autoAction: #{ 
      \     name: 'preview' 
      \    },
      \   },
      \ }
      \ })<CR>
" ddu-source-file_external
nnoremap <silent> ;f <Cmd>call ddu#start(#{
      \ sources: [#{
      \   name: 'file_external'
      \ }],
      \ uiParams: #{
      \   ff: #{
      \    autoAction: #{
      \      name: 'preview'
      \    },
      \   },
      \ }
      \ })<CR>
" ddu-source-help
nnoremap <silent> ;h <Cmd>call ddu#start(#{
      \ sources: [#{
      \   name: 'help'
      \ }],
      \ uiParams: #{
      \   ff: #{
      \     autoAction: #{
      \       name: 'preview' 
      \     },
      \   },
      \ }
      \ })<CR>
" ddu-source-dein_update
command DeinUpdate call ddu#start(#{
      \ sources: [#{
      \   name: 'dein_update' 
      \ }], 
      \ uiParams: #{
      \   ff: #{
      \    autoAction: #{ name: 'preview' },
      \   },
      \ }
      \ })
command DeinUpdateAll call ddu#start(#{ 
      \ sources: [#{ 
      \   name: 'dein_update' 
      \ }],
      \ uiParams: #{
      \   ff: #{
      \    autoAction: #{ name: 'preview' },
      \   },
      \ },
      \ sourceParams: #{ 
      \   dein_update: #{
      \     useGraphQL: v:false 
      \   },
      \ },
      \ })
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
inoremap <buffer> <CR> <Cmd>call ddu#ui#do_action("closeFilterWindow")<CR><Esc>
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
