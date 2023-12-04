vim.treesitter.start = (function(wrapped)
  return function(bufnr, lang)
    if lang == nil then
      return
    end
    wrapped(bufnr, lang)
  end
end)(vim.treesitter.start)
