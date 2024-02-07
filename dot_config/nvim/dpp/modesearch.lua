-- lua_add {{{
vim.keymap.set("n", "/", '', {
  silent = true,
  expr = true,
  callback = function()
   require("modesearch").keymap.prompt.show("rawstr") 
  end
})

vim.api.nvim_set_keymap("x", "/", '', {
  expr = true,
  silent = true,
  callback = function()
    return require("modesearch").keymap.prompt.show "rawstr"
  end
})

vim.api.nvim_set_keymap("o", "/", '', {
  expr = true,
  silent = true,
  callback = function()
    return require("modesearch").keymap.prompt.show "rawstr"
  end
})

vim.api.nvim_set_keymap("c", "<C-x>", '', {
  expr = true,
  callback = function()
    return require("modesearch").keymap.mode.cycle { "rawstr", "migemo", "regexp" }
  end,
})

require("modesearch").setup {
  modes = {
    rawstr = {
      prompt = "[rawstr]/",
      converter = function(query)
        local case_handler = (function()
          if query:find "%u" ~= nil then
            return [[\C]]
          else
            return [[\c]]
          end
        end)()
        return case_handler .. [[\V]] .. vim.fn.escape(query, [[/\]])
      end,
    },
    regexp = {
      prompt = "[regexp]/",
      converter = function(query)
        return [[\c\v]] .. vim.fn.escape(query, [[/]])
      end,
    },
    migemo = {
      prompt = "[migemo]/",
      converter = function(query)
        return [[\c\v]] .. vim.fn["kensaku#query"](query)
      end,
    },
  },
}
-- }}}
