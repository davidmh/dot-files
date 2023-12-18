(import-macros {: augroup : nmap : tmap} :own.macros)

; in normal mode
;
; resize faster
(nmap "<M-,>" :<C-W>5<)
(nmap :<M-.> :<C-W>5>)
(nmap :<M--> :<C-W>5-)
(nmap :<M-=> :<C-W>5+)
; move faster
(nmap :<C-k> :<C-W>k)
(nmap :<C-j> :<C-W>j)
(nmap :<C-h> :<C-W>h)
(nmap :<C-l> :<C-W>l)

; in terminal mode
;
; resize faster
(tmap "<M-,>" :<C-\><C-n><C-W>5<)
(tmap :<M-.> :<C-\><C-n><C-W>5>)
(tmap :<M--> :<C-\><C-n><C-W>5-)
(tmap :<M-=> :<C-\><C-n><C-W>5+)
; move faster
(tmap :<M-k> :<C-\><C-n><C-W>k)
(tmap :<M-j> :<C-\><C-n><C-W>j)
(tmap :<M-h> :<C-\><C-n><C-W>h)
(tmap :<M-l> :<C-\><C-n><C-W>l)

(augroup :auto-resize-windows [:VimResized {:pattern :* :command "wincmd ="}])
