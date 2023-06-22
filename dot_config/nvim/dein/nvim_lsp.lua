-- lua_post_source {{{
local util = require("lspconfig/util")
local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local schema_catalog = require("plugins/schema-catalog")
local schemas = schema_catalog.schemas
local saga = require("lspsaga")
local null_ls = require("null-ls")

local node_root_dir = util.root_pattern("package.json")
local buf_name = vim.api.nvim_buf_get_name(0) == "" and vim.fn.getcwd() or vim.api.nvim_buf_get_name(0)
local current_buf = vim.api.nvim_get_current_buf()
local is_node_repo = node_root_dir(buf_name, current_buf) ~= nil

require("neodev").setup({})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.offsetEncoding = { 'utf-16' }

local function setInlayHintHL()
  local has_hl, hl = pcall(vim.api.nvim_get_hl, 0, { name = 'LspInlayHint' })
  if has_hl and (hl['fg'] or hl['bg']) then
    return
  end

  hl = vim.api.nvim_get_hl(0, { name = 'Comment' })
  local foreground = string.format('#%06x', hl['fg'] or 0)
  if #foreground < 3 then
    foreground = ''
  end

  hl = vim.api.nvim_get_hl(0, { name = 'CursorLine' })
  local background = string.format('#%06x', hl['bg'] or 0)
  if #background < 3 then
    background = ''
  end

  vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = foreground, bg = background })
end

local on_attach = function(client, bufnr)
  saga.setup({})

  local function format()
    local formatOpts = {
      filter = function(formatterClient)
        return formatterClient.name ~= "tsserver"
      end,
    }
    vim.lsp.buf.format(formatOpts)
  end
  client.server_capabilities.semanticTokensProvider = nil
  local opts = { noremap = true, silent = true, buffer = bufnr }
  -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<Leader>rn", "<Cmd>Lspsaga rename<CR>", opts)
  vim.keymap.set({ "n", "v" }, "<Leader>a", "<Cmd>Lspsaga code_action<CR>", opts)
  -- vim.keymap.set("n", "grf", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<Leader>e", "<Cmd>Lspsaga show_line_diagnostics<CR>", opts)
  vim.keymap.set("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
  vim.keymap.set("n", "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
  vim.keymap.set("n", "<Leader>f", format, opts)
  -- vim.keymap.set("n", "<Leader>ot", "<Cmd>Lspsaga outline<CR>", opts)
  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.buf.inlay_hint(bufnr, true)
    setInlayHintHL()
    vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.inlay_hint(bufnr, false)
      end,
    })
    vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.inlay_hint(bufnr, true)
      end,
    })
  end
end

mason.setup()
mason_lspconfig.setup({})

for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
  local opts = {}
  opts.on_attach = on_attach
  opts.capabilities = capabilities
  opts.autostart = true
  if server == "tsserver" then
    goto continue
  elseif server == "vtsls" then
    goto continue
  elseif server == "gopls" then
    opts.on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.document_formatting = false
    end
    opts.settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableypes = true
        }
      }
    }
  elseif server == "tailwindcss" then
    opts.root_dir = util.root_pattern("tailwind.config.cjs", "tailwind.config.js", "tailwind.config.ts")
    opts.autostart = true
  elseif server == "jsonls" then
    opts.filetypes = { "json", "jsonc" }
    opts.settings = {
      json = {
        schemas = schemas,
      },
    }
    opts.init_options = {
      provideFormatter = true,
    }
  elseif server == "lua_ls" then
    opts.on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
      on_attach(client, bufnr)
    end
    opts.init_options = {
      provideFormatter = false,
    }
    opts.settings = {
      Lua = {
        runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        diagnostics = {
          enable = true,
          globals = { "vim" },
        },
        completion = {
          callSnippet = "Replace",
        },
        hint = {
          enable = true
        }
      },
    }
  elseif server == "yamlls" then
    opts.settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.3-standalone-strict/all.json"] = "/*.k8s.yaml",
        },
      },
    }
  end
  lspconfig[server].setup(opts)
  ::continue::
end

if vim.fn.executable("deno") then
  lspconfig.denols.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    autostart = not is_node_repo,
    init_options = {
      suggest = {
        completeFunctionCalls = true
      },
      lint = true,
      unstable = true,
      editor = {
        inlayHints = {
          enabled = true
        }
      },
      inlayHints = {
        parameterNames = {
          enabled = "all"
        },
        variableTypes = {
          enabled = true
        },
        propertyDeclarationTypes = {
          enabled = true
        },
        functionLikeReturnTypes = {
          enabled = true
        },
        enumMemberValues = {
          enabled = true
        },
        parameterTypes = {
          enabled = true
        }
      }
    },
  })
end

if vim.fn.executable("haskell-language-server-wrapper") then
  lspconfig.hls.setup({
    on_attach = on_attach,
    autostart = true,
    capabilities = capabilities,
  })
end

if vim.fn.executable("satysfi-language-server") then
  lspconfig["satysfi-ls"].setup({
    on_attach = on_attach,
    autostart = true,
    capabilities = capabilities,
  })
end

local null_ls_sources = {}

if vim.fn.executable("typescript-language-server") > 0 then
  require("typescript").setup({
    disable_commands = false,
    debug = false,
    go_to_source_definition = {
      fallback = true,
    },
    server = {
      autostart = is_node_repo,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.server_capabilities.document_formatting = false
      end,
      settings = {
        javascript = {
          format = {
            enable = false,
          },
        },
        typescript = {
          format = {
            enable = false,
          },
          tsserver = {
            useSyntaxServer = false,
          },
        },
      },
    },
  })
  table.insert(null_ls_sources, require("typescript.extensions.null-ls.code-actions"))
end

if vim.fn.executable("vtsls") > 0 then
  lspconfig.vtsls.setup({
    autostart = is_node_repo,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.document_formatting = false
    end,
    settings = {
      typescript = {
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          parameterNames = {
            enabled = "all"
          },
          variableTypes = {
            enabled = true
          },
          propertyDeclarationTypes = {
            enabled = true
          },
          functionLikeReturnTypes = {
            enabled = true
          },
          enumMemberValues = {
            enabled = true
          },
          parameterTypes = {
            enabled = true
          }
        }
      }
    }
  })
end

require("mason-null-ls").setup({
  ensure_installed = nil,
  automatic_setup = true,
})

require("mason-null-ls").setup({
  handlers = {
    function()
    end,
    eslint_d = function(source_name, methods)
      for i = 1, #methods do
        null_ls.register(null_ls.builtins[methods[i]][source_name].with({
          extra_filetypes = {
            "markdownreact",
            "astro",
          },
          condition = function()
            return is_node_repo
          end,
        }))
      end
    end,
    prettierd = function(source_name, methods)
      for i = 1, #methods do
        null_ls.register(null_ls.builtins[methods[i]][source_name].with({
          extra_filetypes = {
            "astro",
          },
          condition = function()
            return is_node_repo
          end,
        }))
      end
    end,
    cspell = function(source_name, methods)
      for i = 1, #methods do
        null_ls.register(null_ls.builtins[methods[i]][source_name].with({
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity["WARN"]
          end,
          extra_args = { "--config", vim.fn.expand("~/.config/cspell/cspell.yaml") },
        }))
      end
    end,
  }
})
null_ls.setup({
  sources = null_ls_sources,
  on_attach = on_attach,
})

require("go").setup({
  filstruct = "gopls",
  dap_debug = true,
  dap_debug_gui = true,
  lsp_inlay_hints = { enable = false }
})
-- }}}
