local util = require 'lspconfig/util'
local configs = require("lspconfig/configs")
local lsp_installer = require 'nvim-lsp-installer'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

lsp_installer.on_server_ready(function(server)
  local opts = {}
  opts.on_attach = on_attach
  opts.capabilities = capabilities
  if server.name == "tsserver" then
    opts.root_dir = util.root_pattern("package.json")
    opts.autostart = true
  elseif server.name == "eslintls" then
    opts.on_attach = function (client, bufnr)
      client.resolved_capabilities.document_formatting = true
      on_attach(client, bufnr)
    end
    opts.root_dir = util.root_pattern(".eslintrc")
    opts.autostart = false
  elseif server.name == "tailwindcss" then
    opts.root_dir = util.root_pattern("tailwind.config.js")
    opts.autostart = false
  else
    opts.autostart = true
  end
  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

vim.cmd[[ autocmd FileType typescript,typescriptreact command! -nargs=* TSOrganizeImports lua require'nvim-lsp-installer.extras.tsserver'.organize_imports(<f-args>) ]]

if (vim.fn.executable("deno")) then
  require'lspconfig'.denols.setup{
    on_attach = on_attach,
    root_dir = util.root_pattern(".git"),
    capabilities = capabilities,
  }
end

if (vim.fn.executable("haskell-language-server-wrapper")) then
  require'lspconfig'.hls.setup{
    on_attach = on_attach,
    autostart = true,
    capabilities = capabilities
  }
end
