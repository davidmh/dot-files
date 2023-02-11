(module own.plugin.oil
  {autoload {oil oil}})

(oil.setup {:view_options {:show_hidden true}})

(vim.keymap.set :n :- #(do (vim.cmd :split)
                           (oil.open)))
(vim.keymap.set :n :\ #(do (vim.cmd :vsplit)
                           (oil.open)))
