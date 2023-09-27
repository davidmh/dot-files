(local telescope (require :telescope))
(local notify (require :notify))

(notify.setup {:timeout 2500
               :minimum_width 30
               :top_down false
               :fps 60})

(set vim.notify notify)

(telescope.load_extension :notify)
