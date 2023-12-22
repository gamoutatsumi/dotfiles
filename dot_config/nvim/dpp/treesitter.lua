-- lua_add {{{
local parser_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "treesitter")
vim.opt.runtimepath:prepend(parser_install_dir)
require("nvim-treesitter.configs").setup({
  -- Modules and its options go here
  ensure_installed = {
    "org",
    "lua",
    "vim",
    "vimdoc",
    "toml",
    "json",
    "yaml",
    "go",
    "gomod",
    "typescript",
    "javascript",
    "tsx",
    "markdown",
    "markdown_inline",
    "proto",
    "regex",
    "bash"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "org" },
  },
  auto_install = false,
  incremental_selection = { enable = true },
  textobjects = {
    enable = true,
    lookahead = true,
    keymaps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
    },
  },
  indent = { enable = true },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = false,
    },
  },
  autotag = {
    enable = true,
  },
  parser_install_dir = parser_install_dir,
  sync_install = false,
  ignore_install = {}
})
-- }}}
