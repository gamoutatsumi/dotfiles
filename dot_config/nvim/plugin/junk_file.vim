command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let l:junk_dir = $HOME . '/Repositories/github.com/gamoutatsumi/my-orgs/junk'. strftime('/%Y/%m/%d')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%H%M%S.'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction
