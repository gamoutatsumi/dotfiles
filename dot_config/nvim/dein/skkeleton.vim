" hook_source {{{
call skkeleton#initialize()
" }}}

" hook_add {{{
let g:skkeleton#mode = ''
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
let s:dictPath = dein#get('dict').path
function s:skkeleton_init_kanatable() abort
  call skkeleton#register_kanatable('rom', {
        \ "z\<Space>": ["\u3000", ''],
        \ "x-": ['―', ''],
        \ "<<": ['《', ''],
        \ ">>": ['》', ''],
        \ "(": ['（', ''],
        \ ")": ["）", ''],
        \ "z|": ['｜', ''],
        \ })
endfunction
augroup skkeleton-user
  autocmd!
  autocmd User skkeleton-initialize-pre call skkeleton#config(#{
        \   eggLikeNewline: v:true, 
        \   keepState: v:true,
        \   skkServerResEnc: has("mac") ? "euc-jp" : "utf-8",
        \   useSkkServer: v:true, skkServerHost: $SKK_SERVER_HOST != "" ? $SKK_SERVER_HOST : "127.0.0.1",
        \   globalDictionaries: [
        \     s:dictPath .. "/SKK-JISYO.L"
        \   ]
        \ })
  autocmd User skkeleton-initialize-post call s:skkeleton_init_kanatable()
  autocmd User skkeleton-mode-changed redrawstatus
augroup END
" }}}
