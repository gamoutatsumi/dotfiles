vim.filetype.add({
  extension = {
    tf = "terraform",
    service = "systemd",
    saty = "satysfi",
    satyh = "satysfi",
    ts = "typescript",
    txt = "text",
    astro = "astro",
  },
  filename = {
    ['.textlintrc'] = 'json',
    ['tsconfig.json'] = 'jsonc',
    ['.swcrc'] = 'json',
    ['.eslintignore'] = 'gitignore',
    ['xmobarrc'] = 'haskell',
    ['justfile'] = 'make',
    ['dot_zshrc'] = 'zsh'
  },
  pattern = {
    ['.swcrc*'] = 'json',
  },
})
