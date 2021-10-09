autocmd VimEnter * nested if @% == 'justfile' | set filetype=make | endif
