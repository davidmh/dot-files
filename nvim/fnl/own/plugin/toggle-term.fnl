(import-macros {: map} :own.macros)
(local toggle-term (require :toggleterm))
(local term-edit (require :term-edit))
(local terminal (require :toggleterm.terminal))

(local term terminal.Terminal)

(toggle-term.setup {:shade_terminals false})
(term-edit.setup {:prompt_end " [ "})

(fn term-tab [id]
  (toggle-term.toggle_command "direction=tab dir=. size=0" id))

(fn term-split [id]
  (toggle-term.toggle_command "direction=horizontal dir=. size=0" id))

(fn term-vsplit [id]
  (toggle-term.toggle_command (.. "direction=vertical dir=. size=" (/ vim.o.columns 2)) id))

(local state {:tmux-term nil})

(fn toggle-tmux []
  (if (= state.tmux-term nil)
     (tset state :tmux-term (term:new {:id 200
                                       :cmd "tmux -2 attach 2>/dev/null || tmux -2"
                                       :direction :tab
                                       :close_on_exit true
                                       :on_exit #(tset state :tmux-term nil)})))
  (state.tmux-term:toggle))

(fn ntmap [keymap callback desc]
  (map [:n :t] keymap callback {:nowait true
                                :desc desc}))

(ntmap :<C-t> #(term-split 100) :split)
(ntmap :<C-1> #(term-split 1) :split-term-1)
(ntmap :<C-2> #(term-split 2) :split-term-2)
(ntmap :<C-3> #(term-split 3) :split-term-3)
(ntmap :<C-4> #(term-split 4) :split-term-4)
(ntmap :<C-5> #(term-split 5) :split-term-5)
(ntmap :<M-\> #(term-vsplit 100) :split)
(ntmap :<M-1> #(term-tab 1) :tab-term-1)
(ntmap :<M-2> #(term-tab 2) :tab-term-2)
(ntmap :<M-3> #(term-tab 3) :tab-term-3)
(ntmap :<M-4> #(term-tab 4) :tab-term-4)
(ntmap :<M-5> #(term-tab 5) :tab-term-5)
(ntmap :<M-t> toggle-tmux :tmux)
