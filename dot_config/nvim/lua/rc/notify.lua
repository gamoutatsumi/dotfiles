return function(message)
  vim.fn["denops#notify"]("notify", "notify", { message })
end
