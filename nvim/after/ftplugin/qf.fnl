(import-macros {: nmap} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: get-largest-window-id} (autoload :own.helpers))

(fn on-alternative-open [direction]
  #(let [{: bufnr
          : lnum
          : col} (. (vim.fn.getqflist) (vim.fn.line :.))]
      (vim.fn.win_gotoid (get-largest-window-id))
      (vim.cmd (.. direction " " (vim.api.nvim_buf_get_name bufnr)))
      (vim.fn.cursor lnum col)))

(local opts {:buffer 0 :silent true :nowait true})

; open in a new vertical split
(nmap :<c-v> (on-alternative-open :vsplit) opts)

; open in a new horizontal split
(nmap :<c-x> (on-alternative-open :split) opts)

; older quickfix list
(nmap :< ":silent colder<cr>" opts)

; newer quickfix list
(nmap :> ":silent cnewer<cr>" opts)
