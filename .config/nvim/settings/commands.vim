command! Gfixup FloatermNew --height=30 --width=0.9 --title=GFixup git fixup
command! Diagnostics CocDiagnostics

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
command! TSAutoFix execute 'CocCommand tsserver.executeAutofix'
command! Scratch topleft split ~/vimwiki/Scratch.md | normal G$

let g:fzf_commands_expect = 'alt-enter'
