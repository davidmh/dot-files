(module own.plugin.toggle-term
  {autoload {toggle-term toggleterm
             term-edit term-edit
             wk which-key}})

(toggle-term.setup {:shade_terminals false})
(term-edit.setup {:prompt_end " [ "})

(defn term-tab [id]
  (toggle-term.toggle_command "direction=tab dir=. size=0" id))

(defn term-split [id]
  (toggle-term.toggle_command "direction=horizontal dir=. size=0" id))

(wk.register {:<C-t> [#(term-split 100) :split]
              :<C-1> [#(term-split 1) :split-term-1]
              :<C-2> [#(term-split 2) :split-term-2]
              :<C-3> [#(term-split 3) :split-term-3]
              :<C-4> [#(term-split 4) :split-term-4]
              :<C-5> [#(term-split 5) :split-term-5]

              :<M-t> [#(term-tab 200) :tab]
              :<M-1> [#(term-tab 1) :tab-term-1]
              :<M-2> [#(term-tab 2) :tab-term-2]
              :<M-3> [#(term-tab 3) :tab-term-3]
              :<M-4> [#(term-tab 4) :tab-term-4]
              :<M-5> [#(term-tab 5) :tab-term-5]}
             {:mode [:n :t]
              :nowait true})
