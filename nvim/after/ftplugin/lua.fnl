(-> (require :own.fennel-lua-paths) (: :setup))

(when (vim.startswith (vim.fn.expand :%:p)
                      (.. vim.env.HOME "/.config/home-manager/nvim"))
  (set vim.bo.readonly true))
