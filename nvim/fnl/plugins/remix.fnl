(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local actions (autoload :remix.actions))

(tx :remix {:dir (.. vim.env.REMIX_HOME :/.nvim)
            :keys [(tx :<localleader>r #(actions.select) {:mode :n})]
            :name :remix
            :opts {}})
