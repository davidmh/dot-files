(import-macros {: tx} :own.macros)
(local {: get} (require :nfnl.core))
(local {: autoload} (require :nfnl.module))
(local confirm-quit (autoload :confirm-quit))

(local quit-messages ["Ya know, next time you come in here I'm gonna toast ya."
                      "Go ahead and leave. See if I care."
                      "Get outta here and go back to your boring programs."
                      "If I were your boss, I'd deathmatch ya in a minute!"
                      "You're lucky I don't smack you for thinking about leaving."
                      "Okay, look. We've both said a lot of things you're going to regret..."
                      "Where do you think you're going?, Because I don't think you're going where you think you're going."
                      "It's not too late for you to turn back."
                      "I'm not angry. Just go back to the editing area."
                      "Someday we'll remember this and laugh. and laugh. and laugh. Oh boy. Well. You may as well come on back."
                      "But if you leave who's gonna be bad at writing macros?"
                      "Huh, never pegged you for a quitter."])

(math.randomseed (os.time))

(fn quit-message []
  (local message (->> quit-messages
                      (length)
                      (math.random)
                      (get quit-messages)))
  (.. message "\nQuit?"))

[(tx :nvim-tree/nvim-web-devicons {:config true})

 (tx :yutkat/confirm-quit.nvim {:event :CmdLineEnter
                                :opts {:overwrite_q_command true
                                       :quit_message quit-message}
                                 :keys [(tx :ZZ
                                            #(do (vim.cmd :update)
                                                 (confirm-quit.confirm_quit))
                                            {:mode :n
                                             :desc "Save and quit"})
                                        (tx :ZQ
                                            #(confirm-quit.confirm_quit)
                                            {:mode :n
                                             :desc "Quit without saving"})]})]
