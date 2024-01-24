const s:dpp_dir = stdpath('data') .. '/dpp'

function InitPlugin(plugin)
  let s:dir = s:dpp_dir .. '/repos/github.com/' .. a:plugin
  if !(s:dir->isdirectory())
    execute '!git clone --filter=blob:none https://github.com/' .. a:plugin s:dir
  endif

  execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfunction

function DppMakeState()
  call denops#server#wait_async({ -> dpp#make_state(s:dpp_dir, stdpath('config') .. '/dpp.ts' )})
endfunction

function InitFennel()
  let s:version = '1.3.1'
  let s:dir = s:dpp_dir .. '/repos/github.com/bakpakin/Fennel_' .. s:version
  if !(s:dir->isdirectory())
    execute '!git clone --filter=blob:none -b ' .. s:version .. ' https://github.com/bakpakin/Fennel ' .. s:dir
  endif

  call mkdir(s:dir .. '/nvim/lua', 'p')
  execute 'cd ' .. s:dir
  execute '!make LUA="nvim -ll" fennel.lua'
  execute '!mv fennel.lua nvim/lua/fennel.lua'
  execute 'set runtimepath^='
        \ .. (s:dir .. '/nvim')->fnamemodify(':p')->substitute('[/\\]$', '', '')
endfunction

call InitPlugin('Shougo/dpp.vim')
call InitPlugin('Shougo/dpp-ext-lazy')
call InitPlugin('tani/vim-artemis')

if dpp#min#load_state(s:dpp_dir)
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
        \ | call DppMakeState()
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
