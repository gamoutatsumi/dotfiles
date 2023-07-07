-- lua_post_source {{{
require("noice").setup {
  override = {
    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    ["vim.lsp.util.stylize_markdown"] = true,
  }
}
-- }}}
