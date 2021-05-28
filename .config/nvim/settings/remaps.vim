" Window management
  " resize faster
  nnoremap <M-,> <C-W>5<
  nnoremap <M-.> <C-W>5>
  nnoremap <M--> <C-W>5-
  nnoremap <M-=> <C-W>5+
  " from a terminal
  tnoremap <M-,> <C-\><C-n><C-W>5<a
  tnoremap <M-.> <C-\><C-n><C-W>5>a
  tnoremap <M--> <C-\><C-n><C-W>5-a
  tnoremap <M-=> <C-\><C-n><C-W>5+a

  " move faster
  nnoremap <M-up> <C-W>k
  nnoremap <M-down> <C-W>j
  nnoremap <M-left> <C-W>h
  nnoremap <M-right> <C-W>l
  " from a terminal
  tnoremap <M-up>    <C-\><C-n><C-W>k
  tnoremap <M-down>  <C-\><C-n><C-W>j
  tnoremap <M-left>  <C-\><C-n><C-W>h
  tnoremap <M-right> <C-\><C-n><C-W>l

" Buffer management
  " Open buffers
  nnoremap <leader>bb :Buffers<CR>
  let g:fzf_buffers_jump = 1

" toggle statusline
  nnoremap <silent> <M-l> :call ToggleStatus()<CR>
  function! ToggleStatus()
    if &laststatus == 0
      set laststatus=2
    else
      set laststatus=0
    end
  endfunction
