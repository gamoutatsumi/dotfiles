" hook_post_source {{{
call ddu#custom#alias('action', 'preview_ripgrep', 'preview')
call ddu#custom#load_config(expand(join([$BASE_DIR, 'ddu.ts'], '/')))
" }}}

" hook_add {{{
" ddu-source-lsp
function s:lsp_attach() abort
  nnoremap <silent><buffer> ;rf <Cmd>call ddu#start(#{ 
        \ sources: [#{ 
        \   name: 'lsp_references' ,
        \   params: #{
        \     includeDeclaration: v:false
        \   }
        \ }], 
        \ uiParams: #{
        \   ff: #{
        \     autoAction: #{ 
        \       name: 'preview' 
        \     } 
        \   } 
        \ } 
        \ })<CR>
  nnoremap <silent><buffer> ;d <Cmd>call ddu#start(#{
        \ sources: [#{ 
        \   name: 'lsp_diagnostic' 
        \ }], 
        \ uiParams: #{
        \   ff: #{
        \    autoAction: #{ name: 'preview' },
        \   },
        \ }
        \ })<CR>
  nnoremap <silent><buffer> gd <Cmd>call ddu#start(#{
        \ sync: v:true,
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
  nnoremap <silent><buffer> gD <Cmd>call ddu#start(#{
        \ sync: v:true,
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
  nnoremap <silent><buffer> gi <Cmd>call ddu#start(#{ 
        \ sync: v:true,
        \ sources: [#{ 
        \   name: 'lsp_definition', 
        \   params: #{
        \     method: 'text document/implementation'
        \   }
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
  nnoremap <silent><buffer> ;s <Cmd>call ddu#start(#{
        \ sources: [#{
        \   name: 'lsp_documentSymbol'
        \ }],
        \ uiParams: #{
        \   ff: #{
        \     autoAction: #{
        \       name: 'preview'
        \     },
        \   }
        \ }
        \ })<CR>
  nnoremap <silent><buffer> ;S <Cmd>call ddu#start(#{
        \ sources: [#{
        \   name: 'lsp_workspaceSymbol'
        \ }],
        \ uiParams: #{
        \   ff: #{
        \     autoAction: #{
        \       name: 'preview'
        \     },
        \   }
        \ }
        \ })<CR>
  nnoremap <silent><buffer> ;t <Cmd>call ddu#start(#{
        \ sources: [#{
        \   name: 'lsp_typeHierarchy',
        \   params: #{
        \     method: 'typeHierarchy/supertypes',
        \     autoExpandSingle: v:false,
        \   }
        \ }],
        \ uiParams: #{
        \   ff: #{
        \     autoAction: #{
        \       name: 'preview'
        \     }
        \   }
        \ }
        \ })<CR>
  nnoremap <silent><buffer> ;c <Cmd>call ddu#start(#{
        \ sources: [#{
        \   name: 'lsp_callHierarchy',
        \   params: #{
        \     method: 'callHierarchy/incomingCalls',
        \     autoExpandSingle: v:false,
        \   }
        \ }],
        \ uiParams: #{
        \   ff: #{
        \     autoAction: #{
        \       name: 'preview'
        \     }
        \   }
        \ }
        \ })<CR>
  nnoremap <silent><buffer> <Leader>a <Cmd>call ddu#start(#{
        \ sources: [#{
        \   name: 'lsp_codeAction',
        \ }],
        \ uiParams: #{
        \   ff: #{
        \     autoAction: #{
        \       name: 'preview'
        \     }
        \   }
        \ }
        \ })<CR>

endfunction
autocmd LspAttach * call s:lsp_attach()
" ddu-source-buffer
nnoremap <silent> ;b <Cmd>call ddu#start(#{ sources: [#{ name: 'buffer' }] })<CR>
" ddu-source-rg
function! s:ddu_find() abort
  call SearchlinePre()
  let word = input("search word: ")
  call ddu#start(#{
        \ sources: [#{
        \   name: 'rg',
        \   params: #{
        \     input: word, 
        \     inputType: 'migemo',
        \     args: ['--smart-case', '--json']
        \   }
        \ }],
        \ uiParams: #{
        \   ff: #{
        \     autoAction: #{ name: 'preview' },
        \   },
        \ }
        \ })
endfunction
nnoremap <silent> ;rg <Cmd>call <SID>ddu_find()<CR>
" ddu-source-mr
nnoremap <silent> mu <Cmd>call ddu#start(#{
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
nnoremap <silent> mw <Cmd>call ddu#start(#{
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
      \   name: 'file_external',
      \   params: #{
      \     cmd: ["git", "ls-files", "--exclude-standard", "-c", "-o"],
      \   },
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
command! DeinUpdate call ddu#start(#{
      \ sources: [#{
      \   name: 'dein_update',
      \   params: #{
      \     useGraphQL: v:true
      \   },
      \ }], 
      \ uiParams: #{
      \   ff: #{
      \    autoAction: #{ name: 'preview' },
      \   },
      \ }
      \ })
command! DeinUpdateAll call ddu#start(#{ 
      \ sources: [#{ 
      \   name: 'dein_update',
      \   params: #{
      \     useGraphQL: v:false
      \   }
      \ }],
      \ uiParams: #{
      \   ff: #{
      \    autoAction: #{ name: 'preview' },
      \   },
      \ }
      \ })
" ddu-source-git_diff
nnoremap <silent> ;gd <Cmd>call ddu#start(#{
      \ sources: [#{
      \   name: 'git_diff'
      \ }],
      \ uiParams: #{
      \   ff: #{
      \     autoAction: #{ name: 'preview' }
      \   }
      \ }
      \ })<CR>
" ddu-source-git
nnoremap <silent> ;gs <Cmd>call ddu#start(#{
      \ sources: [#{
      \   name: 'git_status'
      \ }],
      \ uiParams: #{
      \   ff: #{
      \     autoAction: #{ name: 'preview' }
      \   }
      \ }
      \ })<CR>    \ })
" dein.vim
command! Dein call ddu#start(#{
      \ sources: [#{
      \   name: 'dein',
      \ }],
      \ })
" }}}

" ddu-ff {{{
nnoremap <buffer> <CR> <Cmd>call ddu#ui#do_action("itemAction")<CR>
nnoremap <buffer> <Space> <Cmd>call ddu#ui#do_action("toggleSelectItem")<CR>
nnoremap <buffer> i <Cmd>call ddu#ui#do_action("openFilterWindow")<CR>
nnoremap <buffer> q <Cmd>call ddu#ui#do_action("quit")<CR>
nnoremap <buffer> p <Cmd>call ddu#ui#do_action("previewPath")<CR>
nnoremap <buffer> P <Cmd>call ddu#ui#do_action("toggleAutoAction")<CR>
nnoremap <buffer> a <Cmd>call ddu#ui#do_action("chooseAction")<CR>
nnoremap <buffer> l <Cmd>call ddu#ui#filer#do_action('expandItem')<CR>
nnoremap <buffer> h <Cmd>call ddu#ui#filer#do_action('collapseItem')<CR>
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
      \ #{
      \   mode: 'toggle'
      \ })<CR>
nnoremap <buffer> h
      \ <Cmd>call ddu#ui#filer#do_action('collapseItem')<CR>
nnoremap <buffer><silent> q
      \ <Cmd>call ddu#ui#filer#do_action('quit')<CR>
nnoremap <buffer><silent> <C-e>
      \ <Cmd>call ddu#ui#filer#do_action('quit')<CR>
'''
" }}}
