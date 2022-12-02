(module own.plugin.notify
  {autoload {nvim aniseed.nvim
             telescope telescope
             notify notify
             wk which-key}})

(notify.setup {:timeout 2500
               :minimum_width 30
               :top_down false
               :fps 60})

(set vim.notify notify)

(defn- dismiss-notifications []
  (notify.dismiss))

(wk.register {:n {:name :notifications
                  :o ["<cmd>Telescope notify<cr>" :open]
                  :d [dismiss-notifications :dismiss]}}
             {:prefix :<localleader>})

(telescope.load_extension :notify)
