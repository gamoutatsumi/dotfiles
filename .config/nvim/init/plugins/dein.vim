let s:dein_dir = expand('~/.local/share/nvim/dein')
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'

let g:dein#install_github_api_token = $DEIN_GITHUB_TOKEN

let s:rc_dir = expand('~/.config/nvim')

let s:dein_toml = s:rc_dir .. '/dein.toml'
let s:lazy_toml = s:rc_dir .. '/dein_lazy.toml'
let s:ddc_toml = s:rc_dir .. '/ddc.toml'
let s:denops_toml = s:rc_dir .. '/denops.toml'
let s:vim_lsp_toml = s:rc_dir .. '/vim_lsp.toml'
let s:nvim_lsp_toml = s:rc_dir .. '/nvim_lsp.toml'
let s:nvim_toml = s:rc_dir .. '/neovim.toml'
let s:ts_toml = s:rc_dir .. '/treesitter.toml'
let s:ddu_toml = s:rc_dir .. '/ddu.toml'

if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' .. s:dein_repo_dir)
endif
execute 'set runtimepath+=' .. s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#load_toml(s:dein_toml, { 'lazy': 0 })
  call dein#load_toml(s:lazy_toml, { 'lazy': 1 })
  call dein#load_toml(s:ddc_toml, { 'lazy': 1 })
  call dein#load_toml(s:denops_toml, { 'lazy': 1 })
  call dein#load_toml(s:ts_toml, { 'lazy': 0 })
  call dein#load_toml(s:nvim_toml, { 'lazy': 0 })
  call dein#load_toml(s:nvim_lsp_toml, { 'lazy': 1 })
  call dein#load_toml(s:ddu_toml, { 'lazy': 1 })
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call execute(map(s:removed_plugins, 'delete(v:val, "rf")'))
  call dein#recache_runtimepath()
endif

autocmd VimEnter * call dein#call_hook('post_source')
command DeinUpdate call dein#check_update(v:true)
