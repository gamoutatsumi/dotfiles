" hook_add {{{
" Overwrite / and ?.
" nnoremap ? <Cmd>call searchx#start({ 'dir': 0 })<CR>
" nnoremap / <Cmd>call searchx#start({ 'dir': 1 })<CR>
" xnoremap ? <Cmd>call searchx#start({ 'dir': 0 })<CR>
" xnoremap / <Cmd>call searchx#start({ 'dir': 1 })<CR>
" " Move to next/prev match.
" nnoremap N <Cmd>call searchx#prev_dir()<CR>
" nnoremap n <Cmd>call searchx#next_dir()<CR>
" xnoremap N <Cmd>call searchx#prev_dir()<CR>
" xnoremap n <Cmd>call searchx#next_dir()<CR>

" Clear highlights
nnoremap <Esc><Esc> <Cmd>call searchx#clear()<CR>

let g:searchx = {}

" Auto jump if the recent input matches to any marker.
let g:searchx.auto_accept = v:true

" Marker characters.
let g:searchx.markers = split('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '.\zs')

let g:searchx.nohlsearch = {}
let g:searchx.nohlsearch.jump = v:true

function g:searchx.regex_converter(input) abort
  return '\v' .. escape(a:input, '/')
endfunction

function g:searchx.raw_converter(input) abort
  return '\V' .. a:input
endfunction

function g:searchx.kensaku_converter(input) abort
  if a:input !~# '\k'
    return '\V' .. a:input
  endif
  return kensaku#query(a:input)
endfunction

let g:searchx.convert = g:searchx.raw_converter
autocmd User SearchxEnter call SearchlinePre()

nnoremap ? <Cmd>call searchx#start({ 'dir': 0, 'convert': g:searchx.raw_converter })<CR>
nnoremap / <Cmd>call searchx#start({ 'dir': 1, 'convert': g:searchx.raw_converter })<CR>
xnoremap ? <Cmd>call searchx#start({ 'dir': 0, 'convert': g:searchx.raw_converter })<CR>
xnoremap / <Cmd>call searchx#start({ 'dir': 1, 'convert': g:searchx.raw_converter })<CR>

nnoremap <Leader>r? <Cmd>call searchx#start({ 'dir': 0, 'convert': g:searchx.regex_converter })<CR>
nnoremap <Leader>r/ <Cmd>call searchx#start({ 'dir': 1, 'convert': g:searchx.regex_converter })<CR>
xnoremap <Leader>r? <Cmd>call searchx#start({ 'dir': 0, 'convert': g:searchx.regex_converter })<CR>
xnoremap <Leader>r/ <Cmd>call searchx#start({ 'dir': 1, 'convert': g:searchx.regex_converter })<CR>

nnoremap <Leader>k? <Cmd>call searchx#start({ 'dir': 0, 'convert': g:searchx.kensaku_converter })<CR>
nnoremap <Leader>k/ <Cmd>call searchx#start({ 'dir': 1, 'convert': g:searchx.kensaku_converter })<CR>
xnoremap <Leader>k? <Cmd>call searchx#start({ 'dir': 0, 'convert': g:searchx.kensaku_converter })<CR>
xnoremap <Leader>k/ <Cmd>call searchx#start({ 'dir': 1, 'convert': g:searchx.kensaku_converter })<CR>

" Move to next/prev match.
nnoremap N <Cmd>call searchx#prev_dir()<CR>
nnoremap n <Cmd>call searchx#next_dir()<CR>
xnoremap N <Cmd>call searchx#prev_dir()<CR>
xnoremap n <Cmd>call searchx#next_dir()<CR>
" }}}
