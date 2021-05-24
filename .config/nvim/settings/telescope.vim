nnoremap <leader><leader> <cmd>Telescope find_files<cr>
nnoremap <leader>lg <cmd>Telescope live_grep<cr>
nnoremap <leader>bb <cmd>Telescope buffers<cr>
nnoremap <leader>ht <cmd>Telescope help_tags<cr>

" git
nnoremap <leader>gc <cmd>Telescope git_branches<cr>
nnoremap <leader>gg <cmd>Telescope git_status<cr>

" Project search
nnoremap <leader>p/ :Telescope grep_string<CR>
vnoremap <leader>p/ :Telescope grep_string<CR>
