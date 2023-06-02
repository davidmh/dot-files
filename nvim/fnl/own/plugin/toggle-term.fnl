(module own.plugin.toggle-term
  {autoload {toggle-term toggleterm
             term-edit term-edit
             terminal toggleterm.terminal
             wk which-key}})

(def- term terminal.Terminal)

(toggle-term.setup {:shade_terminals false})
(term-edit.setup {:prompt_end " [ "})

(defn term-tab [id]
  (toggle-term.toggle_command "direction=tab dir=. size=0" id))

(defn term-split [id]
  (toggle-term.toggle_command "direction=horizontal dir=. size=0" id))

(defonce- state {:tmux-term nil})

(defn toggle-tmux []
  (if (= state.tmux-term nil)
     (tset state :tmux-term (term:new {:id 200
                                       :cmd "tmux -2 attach 2>/dev/null || tmux -2"
                                       :direction :tab
                                       :close_on_exit true
                                       :on_exit #(tset state :tmux-term nil)})))
  (state.tmux-term:toggle))

(wk.register {:<C-t> [#(term-split 100) :split]
              :<C-1> [#(term-split 1) :split-term-1]
              :<C-2> [#(term-split 2) :split-term-2]
              :<C-3> [#(term-split 3) :split-term-3]
              :<C-4> [#(term-split 4) :split-term-4]
              :<C-5> [#(term-split 5) :split-term-5]
              :<M-1> [#(term-tab 1) :tab-term-1]
              :<M-2> [#(term-tab 2) :tab-term-2]
              :<M-3> [#(term-tab 3) :tab-term-3]
              :<M-4> [#(term-tab 4) :tab-term-4]
              :<M-5> [#(term-tab 5) :tab-term-5]

              :<M-t> [toggle-tmux :tmux]}
             {:mode [:n :t]
              :nowait true})
