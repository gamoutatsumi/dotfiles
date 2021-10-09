local server = {
  host = '127.0.0.1',
  port = 1178
}
local large_dictionary = {
  path = "/usr/share/skk/SKK-JISYO.L",
  sorted = 1,
  encoding = 'euc-jp',
}
vim.api.nvim_set_var('eskk#server', server)
vim.api.nvim_set_var('eskk#large_dictionary', large_dictionary)
vim.api.nvim_set_var('eskk#enable_completion', 0)
vim.api.nvim_set_var('eskk#tab_select_completion', 1)
vim.api.nvim_set_var('eskk#keep_state', 1)
vim.api.nvim_set_var('eskk#fix_extra_okuri', 1)
vim.api.nvim_set_var('eskk#ignore_continuous_sticky', 0)
vim.cmd('autocmd User eskk-initialize-pre call v:lua.PreInitEskk()')
vim.cmd('autocmd User eskk-enable-pre call v:lua.PreEnableEskk()')
vim.cmd('autocmd User eskk-disable-post call v:lua.PostDisableEskk()')
function _G.PreInitEskk()
  vim.cmd('EskkUnmap -type=sticky')
  vim.cmd('EskkMap -type=sticky Q')
  vim.cmd('EskkUnmap -type=backspace-key')
  vim.api.nvim_exec(
  [[
  let t = eskk#table#new('rom_to_hira*', "rom_to_hira")
  call t.add_map('z,', '―')
  call t.add_map('z ', '　')
  call t.add_map('z|', '｜')
  call t.add_map('<<', '《')
  call t.add_map('>>', '》')
  call t.add_map('(', '（')
  call t.add_map(')', '）')
  call eskk#register_mode_table('hira', t)
  let t = eskk#table#new('rom_to_kata*', "rom_to_kata")
  call t.add_map('z,', '―')
  call t.add_map('z ', '　')
  call t.add_map('z|', '｜')
  call t.add_map('<<', '《')
  call t.add_map('>>', '》')
  call t.add_map('(', '（')
  call t.add_map(')', '）')
  call eskk#register_mode_table('kata', t)
  ]],
  false)
end
function _G.PreEnableEskk()
  vim.api.nvim_set_keymap('i', '<Space>', 'pumvisible() ? "<C-n>" : "<Space>"', { silent = true, expr = true })
end
function _G.PostDisableEskk()
  vim.api.nvim_del_keymap('i', '<Space>')
end
