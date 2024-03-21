set splitright
set splitbelow
set hlsearch
set mouse=a
set whichwrap=b,s,h,l,<,>,[,]
set ignorecase
set smartcase
set pumheight=10
set noshowcmd
set guicursor+=a:blinkon0
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set undodir=$XDG_DATA_HOME/nvim/undo
set termguicolors
set foldlevelstart=99
set hidden
set sessionoptions=buffers,curdir,tabpages,winsize
set signcolumn=yes
set number
set relativenumber
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set undofile
set matchpairs+=「:」,『:』,（:）,【:】,《:》,〈:〉,［:］,‘:’,“:”
set clipboard=unnamed,unnamedplus
set pumblend=15
set winblend=15
set noshowmode
set noincsearch
set updatetime=100
set directory=/tmp/nvim/swap
set isfname-==
set iskeyword-=_
set iskeyword+=@
set omnifunc=
set laststatus=3
set cmdheight=0
set shortmess+=Ic
set diffopt=internal,filler,algorithm:histogram,indent-heuristic
let &grepprg="rg --vimgrep --smart-case --follow"
set history=100
lua << EOF
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
EOF
