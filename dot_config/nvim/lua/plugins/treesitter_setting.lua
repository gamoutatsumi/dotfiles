local parser_install_dir = vim.fn.stdpath "data" .. "/treesitter"
vim.opt.runtimepath:append(parser_install_dir)
require 'nvim-treesitter.configs'.setup {
  -- Modules and its options go here
  ensure_installed = { 'org', ' lua', 'vim', 'toml', 'json', 'yaml', 'go', 'gomod', 'typescript', 'javascript', 'tsx' },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'org' },
  },
  auto_install = true,
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
      enable = true,
      keymaps = {
        smart_rename = "grr"
      }
    }
  },
  autotag = {
    enable = true
  },
  parser_install_dir = parser_install_dir,
  --[[ rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000
  } ]]
}
