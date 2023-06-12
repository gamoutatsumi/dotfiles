" hook_add {{{
let g:quickrun_config = {
\ 'tsc': {
\   'command': 'tsc',
\   'exec': ['yarn run --silent %C --project . --noEmit --incremental --tsBuildInfoFile .git/.tsbuildinfo 2>/dev/null'],
\   'outputter': 'quickfix',
\   'outputter/quickfix/errorformat': '%+A %#%f %#(%l\,%c): %m,%C%m',
\ }
\ }
" }}}
