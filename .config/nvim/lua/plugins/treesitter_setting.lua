require'nvim-treesitter.configs'.setup {
  -- Modules and its options go here
  ensure_installed = { 'python', 'lua', 'typescript', 'tsx', 'yaml', 'json', 'rust', 'html', 'go', 'bash', 'css', 'vue', 'c', 'regex', 'cpp', 'graphql', 'php', 'gomod', 'hcl', 'javascript' },
  highlight = { enable = true },
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
  }
  --[[ rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000
  } ]]
}
