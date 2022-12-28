(module own.plugin.notify
  {autoload {nvim aniseed.nvim
             telescope telescope
             notify notify}})

(notify.setup {:timeout 2500
               :minimum_width 30
               :top_down false
               :fps 60})

(set vim.notify notify)

(telescope.load_extension :notify)
