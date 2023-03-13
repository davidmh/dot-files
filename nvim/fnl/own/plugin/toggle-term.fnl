(module own.plugin.toggle-term
  {autoload {toggle-term toggleterm
             term-edit term-edit}})

(toggle-term.setup {:shade_terminals false})
(term-edit.setup {:prompt_end " [ "})
