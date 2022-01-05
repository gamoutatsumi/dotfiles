vim.filetype.add({
  extension = {
    tf = "terraform",
    service = "systemd",
  },
  filename = {
    ['.textlintrc'] = 'json',
    ['tsconfig.json'] = 'jsonc',
    ['.swcrc'] = 'json',
  },
  pattern = {
    ['.swcrc*'] = 'json',
  },
})

