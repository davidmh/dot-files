(module own.window-mappins)

; in normal mode
;
; resize faster
(vim.keymap.set :n "<M-,>" :<C-W>5< {})
(vim.keymap.set :n :<M-.> :<C-W>5> {})
(vim.keymap.set :n :<M--> :<C-W>5- {})
(vim.keymap.set :n :<M-=> :<C-W>5+ {})

; in terminal mode
;
; resize faster
(vim.keymap.set :t "<M-,>" :<C-\><C-n><C-W>5< {})
(vim.keymap.set :t :<M-.> :<C-\><C-n><C-W>5> {})
(vim.keymap.set :t :<M--> :<C-\><C-n><C-W>5- {})
(vim.keymap.set :t :<M-=> :<C-\><C-n><C-W>5+ {})
; move faster
(vim.keymap.set :t :<M-k> :<C-\><C-n><C-W>k {})
(vim.keymap.set :t :<M-j> :<C-\><C-n><C-W>j {})
(vim.keymap.set :t :<M-h> :<C-\><C-n><C-W>h {})
(vim.keymap.set :t :<M-l> :<C-\><C-n><C-W>l {})
