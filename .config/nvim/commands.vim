command! Kittyrc tabedit $HOME/.config/kitty/kitty.conf
command! Tmuxrc tabedit $HOME/.tmux.conf
command! Vimrc call v:lua.telescope_file_browser("~/.config/nvim")
command! Zshrc tabedit $HOME/.zshrc

augroup custom-settings
  au!

  " Remove the background from the current colorscheme to fallback to the
  " colorscheme in the terminal
  au ColorScheme *
        \ hi Normal     ctermbg=NONE guibg=NONE |
        \ hi LineNr     ctermbg=NONE guibg=NONE |
        \ hi SignColumn ctermbg=NONE guibg=NONE |
        \ hi Comment cterm=italic gui=italic guifg=DarkGray |
        \ hi clear CursorLine |
        \ hi CursorLine gui=underline cterm=underline ctermfg=None guifg=None

  " Add missing extension/ft association
  au BufRead,BufNew *.exs,*.ex
        \ set filetype=elixir |
        \ setlocal makeprg=elixirc\ %
  au BufRead,BufNew *_test.exs
        \ set filetype=elixir |
        \ setlocal makeprg=mix\ test\ %

  " Quickfix
  " auto-adjust window height to a max of N lines
  au FileType qf call s:adjust_qf_window(1,  20)
  " open if the command includes *grep*
  au QuickFixCmdPost *grep* copen
augroup END

function! s:adjust_qf_window(minheight, ...)
    exe max([min([line("$"), (a:0 >= 1) ? a:1 : a:minheight]), a:minheight]) . "wincmd _"
endfunction

" Remix config
augroup remix-config
  autocmd!
  autocmd BufRead,BufNewFile $REMIX_HOME/*
        \ cabbrev <buffer> Client Dispatch -dir=client/ |
        \ cabbrev <buffer> Core Dispatch -dir=core/
augroup END

command! RemixApprovals
      \ FloatermNew
      \ --title=[\ remix\ approvals\ ]
      \ --width=1.0
      \ --height=1.0
      \ cd $REMIX_HOME/core/ && approvals verify -d 'nvim -d'

command! RemixConsole
      \ FloatermNew
      \ --title=[\ remix\ rails\ console\ ]
      \ --width=0.7
      \ --height=0.7
      \ cd $REMIX_HOME/core/ && bin/rails c

command! RemixReadOnlyProdDB
      \ FloatermNew
      \ --title=[\ PROD\ READ-ONLY\ remix\ core\ db\ ]
      \ --width=0.7
      \ --height=0.7
      \ read-only-core

command! RemixDeploy
      \ FloatermNew
      \ --title=[\ remix\ deploy\ ]
      \ --width=1.0
      \ --height=1.0
      \ cd $REMIX_HOME && yarn deploy
