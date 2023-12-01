-- lua_add {{{
require 'treesitter-context'.setup {
  line_numbers = false,
  mode = "topline",
  max_lines = 2,
}
vim.keymap.set('n', '[x', function() require('treesitter-context').go_to_context() end,
  { silent = true, desc = 'nvim-ts-context' })
-- }}}
