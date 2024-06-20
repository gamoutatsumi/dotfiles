-- lua_add {{{
require('gitsigns').setup {
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000
  },
  signs_staged_enable = false,
  on_attach = function(bufnr)
    local gs = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.nav_hunk("next") end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.nav_hunk("prev") end)
      return '<Ignore>'
    end, { expr = true })

    map('n', ']g', '<Cmd>Gitsigns stage_hunk<CR>')
    map('n', '[g', '<Cmd>Gitsigns undo_stage_hunk<CR>')
  end
}
-- }}}
