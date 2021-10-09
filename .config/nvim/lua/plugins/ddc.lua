api = vim.api

vim.fn["ddc#custom#patch_global"]("sources", {"nvim-lsp"})
vim.fn["ddc#custom#patch_global"]("sourceOptions", {
  _ = { matchers = { "matcher_head" }, sorters = {"sorter_rank"}},
  nvim-lsp = { mark = "lsp", forceCompeltionPattern = "\\.|:|->" }
})
vim.fn["ddc#custom#patch_global"]("sourceParams", {
  nvim-lsp= { kindLabels = { Class = "c" }}
})

api.nvim_set_keymap("i", "<TAB>", "pumvisible() ? '<C-n>' : (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\\s') ? '<TAB>' : ddc#manual_complete()", {silent = true, expr = true})
api.nvim_set_keymap("i", "<S-TAB>", "pumvisible() ? '<C-p>' : '<C-h>'", {silent = true, expr = true})
api.nvim_set_keymap("i", "<CR>", "pumvisible() ? '<C-y>' : '<CR>'", {silent = true, expr = true})

vim.cmd("LspStart")

vim.fn["ddc#enable"]()

vim.fn["ddc_nvim_lsp_doc#enable"]()
