(import-macros {: augroup} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: find} (autoload :own.lists))
(local {: find-and-load} (autoload :nfnl.config))

(-> (require :own.fennel-lua-paths) (: :setup))

(fn find-window-id-by-path [path]
  (find #(-> $1
             (vim.api.nvim_win_get_buf)
             (vim.api.nvim_buf_get_name)
             (= path))
        (vim.api.nvim_list_wins)))

(fn find-compiled-lua-path [fennel-path]
  (local {: cfg} (find-and-load (vim.fn.stdpath :config)))
  (local find-lua-path (cfg [:fnl-path->lua-path]))
  (find-lua-path fennel-path))


(fn maybe-refresh-compiled-buffer-window []
  "Refresh the compiled lua file in the other window, if any"
  (local fnl-window-id (vim.fn.win_getid))
  (local lua-window-id (-> (vim.fn.expand :%:p)
                           (find-compiled-lua-path)
                           (find-window-id-by-path)))

  (when lua-window-id
    (vim.fn.win_gotoid lua-window-id)
    (vim.cmd "sleep! 10m")
    (vim.cmd "e!")
    (vim.fn.win_gotoid fnl-window-id)))

(augroup :fennel-refresh-compiled-buffer [:BufWritePost {:pattern :*.fnl
                                                         :callback maybe-refresh-compiled-buffer-window}])