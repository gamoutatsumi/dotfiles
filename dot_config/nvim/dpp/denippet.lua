-- lua_source {{{
local path = vim.fs.joinpath(vim.fn.stdpath("config"), "vsnip")
for file in vim.fs.dir(vim.fs.joinpath(vim.fn.stdpath("config"), "vsnip")) do
  local filetype = vim.fn.split(vim.fs.basename(file), "\\.")[1]
  if filetype == "global" then
    filetype = "*"
  end
  vim.fn["denippet#load"](vim.fs.joinpath(path, file), { filetype })
end
-- }}}
