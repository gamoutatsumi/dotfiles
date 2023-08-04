-- lua_add {{{
require('barbar').setup({
  icons = {
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = {
        enabled = true
      },
      [vim.diagnostic.severity.WARN] = {
        enabled = true
      }
    }
  }
})
-- }}}
