-- lua_add {{{
local utils = require "rc.utils"
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
  group = vim.api.nvim_create_augroup("setup-triggerCharacters", {}),
  callback = function()
    local chars = vim
        .iter(vim.lsp.get_active_clients({ bufnr = 0 }))
        :filter(function(client)
          return client.server_capabilities.completionProvider
        end)
        :map(function(client)
          return client.server_capabilities.completionProvider.triggerCharacters or {}
        end)
        :fold({}, function(acc, triggerCharacters)
          return vim.list_extend(acc, triggerCharacters)
        end) --[[@as string[] ]]
    chars = utils.deduplicate(chars)
    for i = #chars, 1, -1 do
      if chars[i]:find("^%s$") then
        table.remove(chars, i)
      end
    end
    table.insert(chars, 1, "[a-zA-Z]")
    local regex = "(?:" .. table.concat(chars, "|\\") .. ")"
    vim.fn["ddc#custom#patch_buffer"]("sourceOptions", {
      ["nvim-lsp"] = {
        forceCompletionPattern = regex,
      },
    })
  end,
})
-- }}}
