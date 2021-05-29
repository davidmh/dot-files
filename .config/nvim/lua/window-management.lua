local function nnoremap(keys, expr)
  vim.api.nvim_set_keymap('n', keys, expr, { noremap = true, silent = true })
end
local function tnoremap(keys, expr)
  vim.api.nvim_set_keymap('t', keys, expr, { noremap = true, silent = true })
end

-- in normal mode
--
-- resize faster
nnoremap('<A-,>', '<C-W>5<')
nnoremap('<A-.>', '<C-W>5>')
nnoremap('<A-->', '<C-W>5-')
nnoremap('<A-=>', '<C-W>5+')
-- move faster
nnoremap('<A-up>'  , '<C-W>k')
nnoremap('<A-down>', '<C-W>j')
nnoremap('<A-left>', '<C-W>h')
nnoremap('<A-right>', '<C-W>l')

-- in terminal mode
--
-- resize faster
tnoremap('<A-,>', '<C-\\><C-n>C-W>5<a')
tnoremap('<A-.>', '<C-\\><C-n>C-W>5>a')
tnoremap('<A-->', '<C-\\><C-n>C-W>5-a')
tnoremap('<A-=>', '<C-\\><C-n>C-W>5+a')
-- move faster
tnoremap('<A-up>', '<C-\\><C-n>C-W>k')
tnoremap('<A-down>', '<C-\\><C-n>C-W>j')
tnoremap('<A-left>', '<C-\\><C-n>C-W>h')
tnoremap('<A-right>', '<C-\\><C-n>C-W>l')
