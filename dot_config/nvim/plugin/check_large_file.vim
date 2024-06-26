autocmd BufReadPre * call s:check_large_file()

function! s:check_large_file() abort
  let max_file_size = 500 * 1000
  let fsize = getfsize(@%)
  let line_num = line('$')

  if fsize > max_file_size
    if input(printf('"%s" is too large file.(%s lines, %s byte) Continue? [y/N]', @%, line_num, fsize)) !~? '^y\%[es]$'
      bwipeout
      return
    else
      syntax off
      TSDisable hightlight
    endif
  endif
endfunction
