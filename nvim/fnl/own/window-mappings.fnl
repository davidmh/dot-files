(import-macros {: map} :own.macros)

; in normal mode
;
; resize faster
(map :n "<M-,>" :<C-W>5<)
(map :n :<M-.> :<C-W>5>)
(map :n :<M--> :<C-W>5-)
(map :n :<M-=> :<C-W>5+)

; in terminal mode
;
; resize faster
(map :t "<M-,>" :<C-\><C-n><C-W>5<)
(map :t :<M-.> :<C-\><C-n><C-W>5>)
(map :t :<M--> :<C-\><C-n><C-W>5-)
(map :t :<M-=> :<C-\><C-n><C-W>5+)
; move faster
(map :t :<M-k> :<C-\><C-n><C-W>k)
(map :t :<M-j> :<C-\><C-n><C-W>j)
(map :t :<M-h> :<C-\><C-n><C-W>h)
(map :t :<M-l> :<C-\><C-n><C-W>l)
