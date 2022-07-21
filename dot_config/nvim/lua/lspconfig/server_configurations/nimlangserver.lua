local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nimlangserver' },
    filetypes = { 'nim' },
    root_dir = function (fname)
      return util.root_pattern '*.nimble'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    settings = {
      nim = {
        nimsuggestPath = "nimsuggest",
        timeout = 120000,
        projectMapping = {
          projectPath = "main.nim",
          fileRegex = ".*\\.nim"
        },
        autoRestart = true,
      }
    }
  },
  docs = {
    description = [[
      https://github.com/nim-lang/langserver
      Language server for Nim.
      ]],
  },
}
