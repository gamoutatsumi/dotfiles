" hook_add {{{
function s:ddu_start(opts) abort
  let l:opts = extend(#{
      \ input: 'Pattern: '->input(),
      \ }, a:opts)
  call ddu#start(l:opts)
endfunction
" ddu-source-lsp
function s:lsp_attach() abort
  nnoremap <silent><buffer> ;rf <Cmd>call <SID>ddu_start(#{ 
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
  nnoremap <silent><buffer> ;d <Cmd>call <SID>ddu_start(#{
        \ sources: [#{ 
        \   name: 'lsp_diagnostic' 
        \ }], 
        \ uiParams: #{
        \   ff: #{
        \    autoAction: #{ name: 'preview' },
        \   },
        \ }
        \ })<CR>
  nnoremap <silent><buffer> gd <Cmd>call <SID>ddu_start(#{
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
  nnoremap <silent><buffer> gD <Cmd>call <SID>ddu_start(#{
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
  nnoremap <silent><buffer> gi <Cmd>call <SID>ddu_start(#{ 
        \ sync: v:true,
        \ sources: [#{ 
        \   name: 'lsp_definition', 
        \   params: #{
        \     method: 'textDocument/implementation'
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
  nnoremap <silent><buffer> gt <Cmd>call <SID>ddu_start(#{ 
        \ sync: v:true,
        \ sources: [#{ 
        \   name: 'lsp_definition', 
        \   params: #{
        \     method: 'textDocument/typeDefinition'
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
  nnoremap <silent><buffer> ;s <Cmd>call <SID>ddu_start(#{
        \ sources: [#{
        \   name: 'lsp_documentSymbol'
        \ }],
        \ uiParams: #{
        \   ff: #{
        \     autoAction: #{
        \       name: 'preview'
        \     },
        \     displayTree: v:true,
        \   }
        \ }
        \ })<CR>
  nnoremap <silent><buffer> ;S <Cmd>call <SID>ddu_start(#{
        \ sources: [#{
        \   name: 'lsp_workspaceSymbol'
        \ }],
        \ uiParams: #{
        \   ff: #{
        \     autoAction: #{
        \       name: 'preview'
        \     },
        \     displayTree: v:true,
        \   }
        \ }
        \ })<CR>
  nnoremap <silent><buffer> ;t <Cmd>call <SID>ddu_start(#{
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
  nnoremap <silent><buffer> ;c <Cmd>call <SID>ddu_start(#{
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
  nnoremap <silent><buffer> <Leader>a <Cmd>call <SID>ddu_start(#{
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
nnoremap <silent> ;b <Cmd>call <SID>ddu_start(#{ sources: [#{ name: 'buffer' }] })<CR>
" ddu-source-rg
function! s:ddu_find() abort
  call SearchlinePre()
  let word = input("search word: ")
  if word == ""
    return
  endif
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
nnoremap <silent> mu <Cmd>call <SID>ddu_start(#{
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
nnoremap <silent> mw <Cmd>call <SID>ddu_start(#{
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
nnoremap <silent> ;f <Cmd>call <SID>ddu_start(#{
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
nnoremap <silent> ;h <Cmd>call <SID>ddu_start(#{
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
" ddu-source-git_diff
nnoremap <silent> ;gd <Cmd>call <SID>ddu_start(#{
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
nnoremap <silent> ;gs <Cmd>call <SID>ddu_start(#{
      \ sources: [#{
      \   name: 'git_status',
    	\   options: #{
    	\     path: expand('%:p'),
    	\   },
      \ }],
      \ uiParams: #{
      \   ff: #{
      \     autoAction: #{ name: 'preview' }
      \   }
      \ }
      \ })<CR>    \ })
command -nargs=1 Capture call <SID>ddu_start(#{
      \ sources: [#{
      \   name: 'output',
      \   params: #{
      \     command: <q-args>
      \   }
      \ }]
      \})

command Dpp call <SID>ddu_start(#{
      \ sources: [#{
      \   name: 'dpp',
      \ }]
      \})

cnoremap <C-c> <Home>Capture <CR>
" }}}
" hook_source {{{
call ddu#custom#alias('action', 'preview_ripgrep', 'preview')
call join([$BASE_DIR, 'ddu.ts'], '/')->expand()->ddu#custom#load_config()
" }}}
" hook_post_update {{{
call ddu#set_static_import_path()
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
" }}}
