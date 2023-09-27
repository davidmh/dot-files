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

(fn map [modes lhs rhs ?opt]
  (assert-compile (or (= (type modes) :string) (sequence? modes)) "mode must be string or list" modes)
  (assert-compile (= (type lhs) :string) "lhs must be string" lhs)
  (assert-compile (or (= nil ?opt) (table? ?opt)) "?opt must be a table" ?opt)
  `(let [opts# (collect [k# v# (pairs (or ,?opt {}))]
                 (values k# v#))]
     (when (= opts#.noremap nil)
       (set opts#.noremap true))
     (when (= opts#.silent nil)
       (set opts#.silent true))
     (vim.keymap.set ,modes ,lhs ,rhs opts#)))

{:autocmd autocmd
 :augroup augroup
 :map map}
