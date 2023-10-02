;; [nfnl-macro]

(fn autocmd [event opt]
  (assert-compile (or (= (type event) :string)
                      (= (type event) :table))
                  "event must be string or a table" event)
  `(vim.api.nvim_create_autocmd
    ,event ,opt))

(fn augroup [name ...]
  (var cmds `(do))
  (var group (sym :group))
  (each [_ v (ipairs [...])]
    (let [(event opt) (unpack v)]
      (tset opt :group group)
      (table.insert cmds (autocmd event opt))))
  (table.insert cmds 'nil)
  `(let [,group
         (vim.api.nvim_create_augroup ,name {:clear true})]
     ,cmds))

(fn map [mode from to opts]
  `(vim.keymap.set ,mode ,from ,to ,opts))

(fn nmap [from to opts]
  `(vim.keymap.set :n ,from ,to ,opts))

(fn vmap [from to opts]
  `(vim.keymap.set :v ,from ,to ,opts))

(fn tmap [from to opts]
  `(vim.keymap.set :t ,from ,to ,opts))

{: autocmd
 : augroup
 : map
 : nmap
 : vmap
 : tmap}
