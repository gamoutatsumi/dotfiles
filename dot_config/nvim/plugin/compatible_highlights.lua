local function apply_compatible_highlights()
  for _, hls in ipairs {
    { old = "@parameter", new = "@variable.parameter" },
    { old = "@field", new = "@variable.member" },
    { old = "@namespace", new = "@module" },
    { old = "@float", new = "@number.float" },
    { old = "@symbol", new = "@string.special.symbol" },
    { old = "@string.regex", new = "@string.regexp" },
    { old = "@text.strong", new = "@markup.strong" },
    { old = "@text.italic", new = "@markup.italic" },
    { old = "@text.link", new = "@markup.link" },
    { old = "@text.strikethrough", new = "@markup.strikethrough" },
    { old = "@text.title", new = "@markup.heading" },
    { old = "@text.literal", new = "@markup.raw" },
    { old = "@text.reference", new = "@markup.link" },
    { old = "@text.uri", new = "@markup.link.url" },
    { old = "@string.special", new = "@markup.link.label" },
    { old = "@punctuation.special", new = "@markup.list" },
    { old = "@method", new = "@function.method" },
    { old = "@method.call", new = "@function.method.call" },
    { old = "@text.todo", new = "@comment.todo" },
    { old = "@text.warning", new = "@comment.warning" },
    { old = "@text.note", new = "@comment.hint" },
    { old = "@text.danger", new = "@comment.info" },
    { old = "@text.diff.add", new = "@diff.plus" },
    { old = "@text.diff.delete", new = "@diff.minus" },
    { old = "@text.diff.change", new = "@diff.delta" },
    { old = "@text.uri", new = "@string.special.url" },
    { old = "@preproc", new = "@keyword.directive" },
    { old = "@define", new = "@keyword.directive" },
    { old = "@storageclass", new = "@keyword.storage" },
    { old = "@conditional", new = "@keyword.conditional" },
    { old = "@debug", new = "@keyword.debug" },
    { old = "@exception", new = "@keyword.exception" },
    { old = "@include", new = "@keyword.import" },
    { old = "@repeat", new = "@keyword.repeat" },
  } do
    vim.api.nvim_set_hl(0, hls.new, { default = true, link = hls.old })
  end
end
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = "*",
  callback = apply_compatible_highlights,
})
