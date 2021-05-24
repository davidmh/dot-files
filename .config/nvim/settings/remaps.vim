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
  " buffer kill
  nnoremap <leader>bk :bprevious <bar> bdelete #<CR>
  " Close all other buffers
  nnoremap <leader>bo :BufOnly<CR>

" toggle statusline
  nnoremap <silent> <M-l> :call ToggleStatus()<CR>
  function! ToggleStatus()
    if &laststatus == 0
      set laststatus=2
    else
      set laststatus=0
    end
  endfunction

" share the clipboard with the OS
  let s:actions = ['y', 'x', 'p', 'c']
  let s:modes = ['n', 'v']
  for action in s:actions
      let Action = toupper(action)
      for mode_target in s:modes
          exec printf('%snoremap <leader>%s "+%s', mode_target, action, action)
          exec printf('%snoremap <leader>%s "+%s', mode_target, Action, Action)
      endfor
  endfor

" git
  " open the latest committed version of the current file
  nnoremap <leader>ge :Gedit<cr>
  " git blame for the current file
  nnoremap <leader>gb :Git blame<cr>
  " how git diff on the current changes
  nnoremap <leader>gd :Gdiff<cr>
  " show git status
  nnoremap <leader>gs :Git<cr>
  " git log viewer
  nnoremap <leader>gl :FloatermNew --height=0.9 --width=0.9 --title=tig tig<CR>
  " git log viewer for the current file
  " nnoremap <leader>gL :GV!<CR>
  nnoremap <leader>gL :FloatermNew --height=0.9 --width=0.9 --title=tig tig -- %<CR>
  " stage/unstage
  nnoremap <leader>gw :Gwrite<cr>
  nnoremap <leader>gr :Gread<cr>
  " open file/selection in github
  nnoremap <leader>go :Gbrowse<CR>
  vnoremap <leader>go :'<,'>Gbrowse<CR>
  " commit as a fixuo
  nnoremap <leader>gf :GFixup<CR>
  nnoremap <leader>gS :GSquash<CR>

" Other
  nmap <silent> <M-x> :CocCommand<CR>
  " nmap <silent> <M-x> <cmd>Telescope commands<cr>
  nnoremap <leader>hh :History<CR>

" tmux runner

" vi: foldmethod=indent
