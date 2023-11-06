" hook_add {{{
let g:barbar_auto_setup = v:false
nnoremap <silent> <C-s> <Cmd>BufferPick<CR>
nnoremap <silent> <S-TAB> <Cmd>BufferPrevious<CR>
nnoremap <silent> <TAB> <Cmd>BufferNext<CR>
nnoremap <silent> <A-1> :BufferGoto 1<CR>
nnoremap <silent> <A-2> :BufferGoto 2<CR>
nnoremap <silent> <A-3> :BufferGoto 3<CR>
nnoremap <silent> <A-4> :BufferGoto 4<CR>
nnoremap <silent> <A-5> :BufferGoto 5<CR>
nnoremap <silent> <A-6> :BufferGoto 6<CR>
nnoremap <silent> <A-7> :BufferGoto 7<CR>
nnoremap <silent> <A-8> :BufferGoto 8<CR>
nnoremap <silent> <A-9> :BufferLast<CR>
lua << EOF
require('barbar').setup({
  icons = {
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = {
        enabled = true
      },
      [vim.diagnostic.severity.WARN] = {
        enabled = true
      }
    }
  }
})
EOF
" }}}
