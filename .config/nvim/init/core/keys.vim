nnoremap x "_x
nnoremap <silent> <CR> <Cmd>call append('.', '')<CR>
nnoremap j gj
nnoremap k gk
nnoremap <expr> i len(getline('.')) ? 'i' : 'cc'
nnoremap <expr> A len(getline('.')) ? 'A' : 'cc'
nnoremap Y y$
nnoremap <expr> 0 getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'
nnoremap <Leader>w <Cmd>update<CR>
nnoremap <Leader>q <Cmd>confirm quit<CR>
