(local {: starts-with} (require :own.string))

(-> (require :own.fennel-lua-paths) (: :setup))

(when (starts-with (vim.fn.expand :%:p)
                   (.. vim.env.HOME "/.config/home-manager/nvim"))
  (set vim.bo.readonly true))
