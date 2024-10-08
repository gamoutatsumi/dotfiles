-- lua_add {{{
local util = require("lspconfig/util")
local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local schemas = require("schemastore")

local buf_name = vim.api.nvim_buf_get_name(0) == "" and vim.fn.getcwd() or vim.api.nvim_buf_get_name(0)
local is_node_repo = util.find_node_modules_ancestor(buf_name) ~= nil
local is_deno_repo = util.search_ancestors(buf_name, function(path)
  if util.path.is_file(util.path.join(path, 'deno.json')) then
    return path
  end
end
) ~= nil

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

require("ddc_source_lsp_setup").setup()

local on_attach = function(client, bufnr)
  local function format()
    local formatOpts = {
      filter = function(formatterClient)
        return formatterClient.name ~= "tsserver"
      end,
    }
    vim.lsp.buf.format(formatOpts)
  end
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local function jumpNext()
    vim.diagnostic.jump({ count = 1, float = true })
  end

  local function jumpPrev()
    vim.diagnostic.jump({ count = -1, float = true })
  end

  vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", jumpPrev, opts)
  vim.keymap.set("n", "]d", jumpNext, opts)
  vim.keymap.set("n", "<Leader>f", format, opts)
  require("lsp_signature").on_attach({
    bind = true,
    handler_opts = {
      border = "rounded"
    }
  }, bufnr)
  if client.supports_method("textDocument/inlayHint") or client.name == "sourcekit" then
    setInlayHintHL()
    vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
      buffer = bufnr,
      callback = function()
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
      end,
    })
    vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
      buffer = bufnr,
      callback = function()
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end,
    })
    local timer = vim.uv.new_timer()
    timer:start(100, 0, vim.schedule_wrap(function()
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end))
  end
end

mason.setup()
mason_lspconfig.setup({})

for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
  local opts = {}
  opts.on_attach = on_attach
  opts.autostart = true
  if server == "tsserver" then
    goto continue
  elseif server == "vtsls" then
    opts.autostart = is_node_repo
    opts.on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.document_formatting = false
    end
    opts.settings = {
      javascript = {
        preferGoToSourceDefinition = true,
        suggest = {
          autoImports = false
        }
      },
      typescript = {
        preferGoToSourceDefinition = true,
        suggest = {
          completeFunctionCalls = true,
          autoImports = false
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
        schemas = schemas.json.schemas(),
      },
    }
    opts.init_options = {
      provideFormatter = true,
    }
  elseif server == "fennel_language_server" then
    opts.settings = {
      fennel = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_list_runtime_paths()
        },
      },
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
        },
        workspace = {
          library = vim.api.nvim_list_runtime_paths()
        },
      },
    }
  elseif server == "yamlls" then
    opts.settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.3-standalone-strict/all.json"] =
          "/*.k8s.yaml",
        },
      },
    }
  elseif server == "efm" then
    opts.autostart = not is_deno_repo
    opts.cmd = { "efm-langserver", "-q" }
    opts.init_options = {
      documentFormatting = true,
      completion = false,
      rangeFormatting = true,
      hover = false,
      documentSymbol = true,
      codeAction = true,
    }
  elseif server == "pyright" then
    opts.settings = {
      python = {
        venvPath = ".",
        pythonPath = ".venv/bin/python",
        analysis = {
          extraPaths = { "." }
        }
      }
    }
  end
  lspconfig[server].setup(opts)
  ::continue::
end

if vim.fn.executable("deno") then
  lspconfig.denols.setup({
    on_attach = on_attach,
    autostart = not is_node_repo,
    provideFormatter = true,
    settings = {
      typescript = {
        suggest = {
          completeFunctionCalls = true,
          autoImports = false,
          imports = {
            hosts = {
              ["https://deno.land"] = true,
              ["https://x.nest.land"] = false
            },
          },
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
    }
  })
end

if vim.fn.executable("haskell-language-server-wrapper") then
  lspconfig.hls.setup({
    on_attach = on_attach,
    autostart = true,
  })
end

if vim.fn.executable("satysfi-language-server") then
  lspconfig["satysfi-ls"].setup({
    on_attach = on_attach,
    autostart = true,
  })
end

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
end

if vim.fn.executable("sourcekit-lsp") > 0 then
  lspconfig.sourcekit.setup({
    on_attach = on_attach,
    autostart = true,
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true
        },
      },
    },
    cmd = { "xcrun", "sourcekit-lsp", "-Xswiftc", "-sdk", "-Xswiftc", vim.fn.trim(vim.fn.system("xcrun --show-sdk-path --sdk iphonesimulator")), "-Xswiftc", "-target", "-Xswiftc", "arm64-apple-ios17.5-simulator" },
  })
end

require("go").setup({
  filstruct = "gopls",
  dap_debug = true,
  dap_debug_gui = true,
  lsp_inlay_hints = { enable = false }
})
-- }}}
