(module own.plugin.toggle-term
  {autoload {toggle-term toggleterm
             term-edit term-edit}})

(toggle-term.setup {:shade_terminals false})
(term-edit.setup {:prompt_end " [ "})

; toggle a terminal buffer in a vertical split
(vim.keymap.set [:n :t]
                :<C-t>
                #(toggle-term.toggle_command "direction=horizontal dir=. size=0" 100)
                {:nowait true})

; toggle a terminal buffer in a tab
(vim.keymap.set [:n :t]
                :<M-t>
                #(toggle-term.toggle_command "direction=tab dir=. size=0" 200)
                {:nowait true})
