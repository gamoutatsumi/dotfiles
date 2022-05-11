local util = require('lspconfig/util')
local lspconfig = require('lspconfig')
local lsp_installer = require('nvim-lsp-installer')
local schema_catalog = require('plugins/schema-catalog')
local schemas = schema_catalog.schemas

local node_root_dir = util.root_pattern("package.json", "node_modules")
local buf_name = vim.api.nvim_buf_get_name(0) == '' and vim.fn.getcwd() or vim.api.nvim_buf_get_name(0)
local current_buf = vim.api.nvim_get_current_buf()
local is_node_repo = node_root_dir(buf_name, current_buf) ~= nil

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(_, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<Leader>f', vim.lsp.buf.formatting, opts)
end

lsp_installer.setup {}

for _, server in ipairs(lsp_installer.get_installed_servers()) do
  local opts = {}
  opts.on_attach = on_attach
  opts.capabilities = capabilities
  opts.autostart = true
  if server.name == "tsserver" then
    opts.autostart = is_node_repo
    opts.init_options = require("nvim-lsp-ts-utils").init_options
    opts.on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      local ts_utils = require("nvim-lsp-ts-utils")
      ts_utils.setup({
        debug = false,
        disable_commands = false,
        enable_import_on_completion = false,
        import_all_timeout = 5000,
        import_all_priorities = {
          same_file = 1,
          local_files = 2,
          buffer_content = 3,
          buffers = 4,
        },
        import_all_scan_buffers = 100,
        import_all_select_source = false,
        filter_out_diagnostics_by_severity = {},
        filter_out_diagnostics_by_code = {},
        auto_inlay_hints = false,
        inlay_hints_highlight = "Comment",
        update_imports_on_move = false,
        require_confirmation_on_move = false,
        watch_dir = nil,
      })
      ts_utils.setup_client(client)
    end
  elseif server.name == "eslintls" then
    opts.on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = true
      on_attach(client, bufnr)
    end
    opts.autostart = true
    opts.root_dir = util.root_pattern(".eslintrc")
  elseif server.name == "tailwindcss" then
    opts.root_dir = util.root_pattern("tailwind.config.js")
    opts.autostart = false
  elseif server.name == 'jsonls' then
    opts.filetypes = { 'json', 'jsonc' }
    opts.settings = {
      json = {
        schemas = schemas
      }
    }
    opts.init_options = {
      provideFormatter = true,
    }
  elseif server.name == 'sumneko_lua' then
    opts.on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = true
      on_attach(client, bufnr)
    end
    opts.init_options = {
      provideFormatter = true,
    }
    opts.settings = {
      Lua = {
        runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
        diagnostics = {
          enable = true,
          globals = { 'vim' },
        },
      },
    }
  end
  lspconfig[server.name].setup(opts)
end

if (vim.fn.executable("deno")) then
  require 'lspconfig'.denols.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    autostart = not (is_node_repo),
    init_options = {
      lint = true,
      unstable = true,
    }
  }
end

if vim.fn.executable("haskell-language-server-wrapper") then
  require 'lspconfig'.hls.setup {
    on_attach = on_attach,
    autostart = true,
    capabilities = capabilities
  }
end

if vim.fn.executable("satysfi-language-server") then
  require 'lspconfig'['satysfi-ls'].setup {
    on_attach = on_attach,
    autostart = true,
    capabilties = capabilities
  }
end
