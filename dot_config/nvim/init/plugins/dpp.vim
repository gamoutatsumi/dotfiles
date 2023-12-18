const s:dpp_dir = stdpath('data') .. '/dpp'

function InitPlugin(plugin)
  let dir = s:dpp_dir .. '/repos/github.com/' .. a:plugin
  if !(dir->isdirectory())
    execute '!git clone https://github.com/' .. a:plugin dir
  endif

  execute 'set runtimepath^='
        \ .. dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfunction

function InitFennel()
  let dir = s:dpp_dir .. '/repos/github.com/bakpakin/Fennel'
  if !(dir->isdirectory())
    execute '!git clone https://github.com/bakpakin/Fennel ' .. dir
  endif

  echomsg dir
  call mkdir(dir .. '/nvim/lua', 'p')
  execute 'cd ' .. dir
  execute '!make LUA="nvim -ll" fennel.lua'
  execute '!mv fennel.lua nvim/lua/fennel.lua'
  execute 'set runtimepath^='
        \ .. (dir .. '/nvim')->fnamemodify(':p')->substitute('[/\\]$', '', '')
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
  if has('nvim')
    call InitFennel()
    runtime! plugin/denops.vim
  endif
  autocmd MyAutoCmd User DenopsReady 
        \ : echohl WarningMsg 
        \ | echomsg 'dpp load_state() is failed'
        \ | echohl NONE
        \ | call dpp#make_state(s:dpp_dir, stdpath('config') .. '/dpp.ts')
        \ | call dpp#min#load_state(s:dpp_dir)
else
  autocmd MyAutoCmd BufWritePost ~/.local/share/chezmoi/dot_config/nvim/**/*
        \ call dpp#check_files()
endif
autocmd MyAutoCmd User Dpp:makeStatePost
      \ : echohl WarningMsg
      \ | echomsg 'dpp make_state() is done'
      \ | echohl NONE

command DppUpdate call dpp#async_ext_action('installer', 'checkNotUpdated')
command DppUpdateAll call dpp#async_ext_action('installer', 'update')
command DppInstall call dpp#async_ext_action('installer', 'install')
