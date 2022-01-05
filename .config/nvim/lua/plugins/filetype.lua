vim.filetype.add({
  extension = {
    tf = "terraform",
    service = "systemd",
  },
  literal = {
    ['.textlintrc'] = 'json',
    ['tsconfig.json'] = 'jsonc',
    ['.swcrc'] = 'json',
  },
  complex = {
    ['.swcrc*'] = 'json',
  },
  shebang = {
    bash = 'sh',
  }
})

