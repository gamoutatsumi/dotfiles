local null_ls = require("null-ls")
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.prettier.with {
      only_local = "node_modules/.bin",
    },
    null_ls.builtins.formatting.goimports.with {
      condition = function()
        return vim.fn.executable('goimports') > 0
      end
    },
    null_ls.builtins.diagnostics.cspell.with {
      diagnostics_postprocess = function(diagnostic)
        diagnostic.severity = vim.diagnostic.severity["WARN"]
      end,
      condition = function()
        return vim.fn.executable('cspell') > 0
      end,
      extra_args = { '--config', vim.fn.expand('~/.config/cspell/cspell.yaml') }
    },
    null_ls.builtins.formatting.shfmt.with {
      condition = function()
        return vim.fn.executable('shfmt') > 0
      end
    },
    null_ls.builtins.formatting.stylua.with {
      condition = function()
        return vim.fn.executable('stylua') > 0
      end
    }
  },
}
