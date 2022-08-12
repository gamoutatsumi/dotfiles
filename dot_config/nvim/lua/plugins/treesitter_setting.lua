require 'nvim-treesitter.configs'.setup {
  -- Modules and its options go here
  ensure_installed = { 'org' },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'org' },
  },
  auto_install = true,
  incremental_selection = { enable = true },
  textobjects = { enable = true },
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
  }
  --[[ rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000
  } ]]
}
