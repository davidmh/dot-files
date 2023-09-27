(import-macros {: map} :own.macros)

(local oil (require :oil))

(oil.setup {:view_options {:show_hidden true}})

(map :n :- #(do (vim.cmd :split)
                (oil.open)))
(map :n :\ #(do (vim.cmd :vsplit)
                (oil.open)))
