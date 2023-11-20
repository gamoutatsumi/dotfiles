const s:dpp_dir = stdpath('data') .. '/dpp'

function InitPlugin(plugin)
  let dir = s:dpp_dir .. '/repos/github.com/' .. a:plugin
  if !(dir->isdirectory())
    execute '!git clone https://github.com/' .. a:plugin dir
  endif

  execute 'set runtimepath^='
        \ .. dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfunction

call InitPlugin('Shougo/dpp.vim')
call InitPlugin('Shougo/dpp-ext-lazy')

if dpp#min#load_state(s:dpp_dir)
  echohl WarningMsg | echomsg 'dpp load_state() is failed' | echohl NONE
  for s:plugin in [
        \   'Shougo/dpp-ext-installer',
        \   'Shougo/dpp-ext-local',
        \   'Shougo/dpp-ext-toml',
        \   'Shougo/dpp-ext-packspec',
        \   'Shougo/dpp-protocol-git',
        \   'vim-denops/denops.vim',
        \ ]
    call InitPlugin(s:plugin)
  endfor
  runtime! plugin/denops.vim
  augroup MyAutoCmd
    autocmd User DenopsReady call dpp#make_state(s:dpp_dir, stdpath('config') .. '/dpp.ts')
    autocmd User Dpp:makeStatePost
          \ echohl WarningMsg | echomsg 'dpp make_state() is done' | echohl NONE
  augroup END
else
  augroup MyAutoCmd
    autocmd BufWritePost *.lua,*.vim,*.toml,*.ts,vimrc,.vimrc call dpp#check_files() | call dpp#make_state()
  augroup END
endif

command DppUpdate call dpp#async_ext_action('installer', 'checkNotUpdated')
command DppUpdateAll call dpp#async_ext_action('installer', 'update')
command DppInstall call dpp#async_ext_action('installer', 'install')
