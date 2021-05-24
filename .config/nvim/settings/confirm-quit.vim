" Some messages are from Doom, some from Portal and some custom ones.
let s:messages = [
            \ "Ya know, next time you come in here I'm gonna toast ya.",
            \ "Go ahead and leave. See if I care.",
            \ "Are you sure you want to quit this great editor?",
            \ "Get outta here and go back to your boring programs.",
            \ "If I were your boss, I'd deathmatch ya in a minute!",
            \ "You're lucky I don't smack you for thinking about leaving.",
            \ "Okay, look. We've both said a lot of things you're going to regret...",
            \ "Uh oh. Somebody cut the cake. I told them to wait for you, but they did it anyway. There is still some left, though, if you hurry back.",
            \ "Where do you think you're going?, Because I don't think you're going where you think you're going.",
            \ "It's not too late for you to turn back.",
            \ "I'm not angry. Just go back to the editing area.",
            \ "Someday we'll remember this and laugh. and laugh. and laugh. Oh boy. Well. You may as well come on back.",
            \ "Nobody can quit vim, nobody!",
            \ "You can checkout anytime you like, but you can never leave *cheesy guitar solo*",
            \ "But if you leave who's gonna be bad at writing macros?",
            \ "Huh, never pegged you for a quitter."
            \ ]

function! s:confirm_quit(write) abort
    if (a:write)
        if &modifiable
            write
        elseif (expand('%:t')=="")
            echoerr "Can't save a file with no name."
            return
        endif
    else
        " When we try to quit without saving, we cleanup the last message
        " because it's not relevant to the confirmation prompt
        echo ''
    endif
    if (winnr('$')==1 && tabpagenr('$')==1)
      let limit = len(s:messages) - 1
        let index = system('shuf -i 0-'.limit.' -n 1')
        if (confirm(s:messages[index], "Quit? &Yes\n&No", 2)==1)
            quit
        endif
    else
        quit
    endif
endfunction

nnoremap <silent> ZQ :call <SID>confirm_quit(0)<CR>
nnoremap <silent> ZZ :call <SID>confirm_quit(1)<CR>
