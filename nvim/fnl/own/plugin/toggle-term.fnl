(module own.plugin.toggle-term
  {autoload {toggle-term toggleterm}})

(toggle-term.setup {:shade_terminals false})

(vim.keymap.set [:n :t]
                :<C-t>
                #(toggle-term.toggle 1)
                {:nowait true})
