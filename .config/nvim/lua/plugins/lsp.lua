local util = require('lspconfig/util')
local configs = require('lspconfig/configs')
local lsp_installer = require('nvim-lsp-installer')
local schema_catalog = require('plugins/schema-catalog')
local schemas = schema_catalog.schemas

local node_root_dir = util.root_pattern("package.json", "node_modules")
local buf_name = vim.api.nvim_buf_get_name(0) == '' and vim.fn.getcwd() or vim.api.nvim_buf_get_name(0)
local current_buf = vim.api.nvim_get_current_buf()
local is_node_repo = node_root_dir(buf_name, current_buf) ~= nil

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
  buf_set_keymap('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

lsp_installer.on_server_ready(function(server)
  local opts = {}
  opts.on_attach = on_attach
  opts.capabilities = capabilities
  opts.autostart = true
  if server.name == "tsserver" then
    opts.autostart = is_node_repo
  elseif server.name == "eslintls" then
    opts.on_attach = function (client, bufnr)
      client.resolved_capabilities.document_formatting = true
      on_attach(client, bufnr)
    end
    opts.autostart = true
    opts.root_dir = util.root_pattern(".eslintrc")
  elseif server.name == "tailwindcss" then
    opts.root_dir = util.root_pattern("tailwind.config.js")
    opts.autostart = false
  elseif server.name == 'jsonls' then
    opts.filetypes = {'json', 'jsonc'}
    opts.settings = {
      json = {
        schemas = schemas
      }
    }
    opts.init_options = {
      provideFormatter = true,
    }
  end
  server:setup(opts)
end)

if (vim.fn.executable("deno")) then
  require'lspconfig'.denols.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    autostart = not(is_node_repo),
    init_options = {
      lint = true,
      unstable = true,
    }
  }
end

if (vim.fn.executable("haskell-language-server-wrapper")) then
  require'lspconfig'.hls.setup{
    on_attach = on_attach,
    autostart = true,
    capabilities = capabilities
  }
end
