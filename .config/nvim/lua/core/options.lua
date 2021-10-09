local opts = {
  splitright = true,
  splitbelow = true,
  hlsearch = true,
  mouse = 'a',
  whichwrap = 'b,s,h,l,<,>,[,]',
  ignorecase = true,
  smartcase = true,
  pumheight = 10,
  lazyredraw = true,
  showcmd = false,
  guicursor = vim.o.guicursor..',a:blinkon0',
  encoding = 'utf-8',
  fileencoding = 'utf-8',
  fileencodings = 'utf-8,iso-2022-jp,cp932,sjis,euc-jp',
  undodir = vim.env.XDG_DATA_HOME..'/nvim/backup',
  termguicolors = true,
  foldlevelstart = 99,
  hidden = true,
  sessionoptions = "buffers,curdir,tabpages,winsize",
  signcolumn = 'yes',
  number = true,
  relativenumber = true,
  foldmethod = 'marker',
  autoindent = true,
  smartindent = true,
  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  undofile = true,
  matchpairs = vim.bo.matchpairs .. ',「:」,『:』,（:）,【:】,《:》,〈:〉,［:］,‘:’,“:”',
  clipboard = 'unnamedplus',
  pumblend = 15,
  cursorline = true
}

for opt, val in pairs(opts) do
  vim.opt[opt] = val
end
