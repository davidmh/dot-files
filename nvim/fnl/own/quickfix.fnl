(import-macros {: use : nmap} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: get-largest-window-id} (autoload :own.helpers))

(fn on-alternative-open [direction]
  #(let [{: bufnr
          : lnum
          : col} (. (vim.fn.getqflist) (vim.fn.line :.))]
      (vim.fn.win_gotoid (get-largest-window-id))
      (vim.cmd (.. direction " " (vim.api.nvim_buf_get_name bufnr)))
      (vim.fn.cursor lnum col)))

(local previous-qf-stack-entry-key "<")
(local next-qf-stack-entry-key ">")

(fn set-quickfix-mappings []
  "Mappings to navigate the quickfix history stack and open quickfix items in splits."

  (local opts {:buffer 0 :silent true :nowait true})

  ; open in a new vertical split
  (nmap :<c-v> (on-alternative-open :vsplit) opts)

  ; open in a new horizontal split
  (nmap :<c-x> (on-alternative-open :split) opts)

  ; older quickfix list
  (nmap previous-qf-stack-entry-key ":silent colder<cr>" opts)

  ; newer quickfix list
  (nmap next-qf-stack-entry-key ":silent cnewer<cr>" opts))

(fn get-quickfix-title []
  (-> (vim.fn.getqflist {:title 1}) (. :title)))

(fn get-quickfix-history-size []
  (-> (vim.fn.getqflist {:nr :$}) (. :nr)))

(fn get-quickfix-current-index []
  (-> (vim.fn.getqflist {:nr 0}) (. :nr)))

(fn show-quickfix-title? []
  (and
    (= vim.o.filetype :qf)
    (~= "" (get-quickfix-title))))

(local quickfix-history-status-component
       (use {:provider (.. " " previous-qf-stack-entry-key " ")
             :hl #(-> {:fg (if (> (get-quickfix-current-index) 1)
                               :lavender
                               :surface1)})}
            {:provider #(.. (get-quickfix-current-index) "/" (get-quickfix-history-size))
             :hl {:fg :lavender}}
            {:provider (.. " " next-qf-stack-entry-key " ")
             :hl #(-> {:fg (if (< (get-quickfix-current-index) (get-quickfix-history-size))
                             :lavender
                             :surface1)})}
            {:condition #(and (show-quickfix-title?)
                              (> (get-quickfix-history-size) 1))}))

{: set-quickfix-mappings
 : get-quickfix-title
 : show-quickfix-title?
 : quickfix-history-status-component}
