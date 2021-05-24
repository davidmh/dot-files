augroup remix-config
  autocmd!
  autocmd BufRead,BufNewFile $REMIX_HOME/*
        \ cabbrev <buffer> client Dispatch -dir=client/ |
        \ cabbrev <buffer> core Dispatch -dir=core/
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
