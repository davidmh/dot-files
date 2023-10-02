(import-macros {: nmap} :own.macros)

(local core (require :nfnl.core))

(local messages
  ["Ya know, next time you come in here I'm gonna toast ya."
   "Go ahead and leave. See if I care."
   "Are you sure you want to quit this great editor?"
   "Get outta here and go back to your boring programs."
   "If I were your boss, I'd deathmatch ya in a minute!"
   "You're lucky I don't smack you for thinking about leaving."
   "Okay, look. We've both said a lot of things you're going to regret..."
   "Uh oh. Somebody cut the cake. I told them to wait for you, but they did it anyway. There is still some left, though, if you hurry back."
   "Where do you think you're going?, Because I don't think you're going where you think you're going."
   "It's not too late for you to turn back."
   "I'm not angry. Just go back to the editing area."
   "Someday we'll remember this and laugh. and laugh. and laugh. Oh boy. Well. You may as well come on back."
   "Nobody can quit vim, nobody!"
   "You can checkout anytime you like, but you can never leave *cheesy guitar solo*"
   "But if you leave who's gonna be bad at writing macros?"
   "Huh, never pegged you for a quitter."])

(fn get-message []
  (math.randomseed (os.time))
  (. messages (math.random (core.count messages))))

(fn confirm [should-write]
  (if should-write
    (if vim.o.modifiable
      (vim.cmd :write)
      (if (= (vim.fn.expand :%:t) "")
        (do
          (vim.notify "Can't save a file without a name." :error {:title "hold up!"})
          (lua :return))))
    ; When we try to quit without saving, we cleanup the last message because
    ; it's not relevant to the confirmation prompt
    (vim.cmd "echo ''"))

  (if (and (= (vim.fn.winnr :$) 1) (= (vim.fn.tabpagenr :$) 1))
    (do
      (if (= 1 (vim.fn.confirm (get-message) "Quit? &Yes\n&No" 2))
        (vim.cmd :quit)))
    (vim.cmd :quit)))

(nmap :ZZ #(confirm true))
(nmap :ZQ #(confirm false))
