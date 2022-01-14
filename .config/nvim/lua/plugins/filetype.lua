vim.filetype.add({
  extension = {
    tf = "terraform",
    service = "systemd",
  },
  filename = {
    ['.textlintrc'] = 'json',
    ['tsconfig.json'] = 'jsonc',
    ['.swcrc'] = 'json',
    ['.eslintignore'] = 'gitignore',
    ['xmobarrc'] = 'haskell',
    ['justfile'] = 'make'
  },
  pattern = {
    ['.swcrc*'] = 'json',
  },
})

