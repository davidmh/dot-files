(local flatten (require :flatten))

(local diff-mode #(vim.tbl_contains (or $1 []) :-d))

(flatten.setup {:window {:open :smart}
                :callbacks {:should_block diff-mode}
                :nest_if_no_args true})
