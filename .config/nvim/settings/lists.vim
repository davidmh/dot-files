let g:lt_location_list_toggle_map = 'L'
let g:lt_quickfix_list_toggle_map = 'Q'

augroup quickfix-settings
  au!
  " auto-adjust window height to a max of N lines
  au FileType qf call s:adjust_qf_window(1,  20)
  " open the quickfix window if the command includes *grep*
  au QuickFixCmdPost *grep* copen
augroup END

function! s:adjust_qf_window(minheight, ...)
    exe max([min([line("$"), (a:0 >= 1) ? a:1 : a:minheight]), a:minheight]) . "wincmd _"
endfunction
