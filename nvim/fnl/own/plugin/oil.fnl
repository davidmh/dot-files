(import-macros {: nmap} :own.macros)

(local oil (require :oil))

(oil.setup {:view_options {:show_hidden true}})

(nmap :- #(do (vim.cmd :split)
              (oil.open)))
(nmap :\ #(do (vim.cmd :vsplit)
              (oil.open)))
