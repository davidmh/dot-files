(import-macros {: use : nmap} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: get-largest-window-id} (autoload :own.helpers))
(local palette (autoload :catppuccin.palettes))

(fn on-alternative-open [direction]
  #(let [{: bufnr
          : lnum
          : col} (. (vim.fn.getqflist) (vim.fn.line :.))]
      (vim.fn.win_gotoid (get-largest-window-id))
      (vim.cmd (.. direction " " (vim.api.nvim_buf_get_name bufnr)))
      (vim.fn.cursor lnum col)))

(local qf-older-key "<")
(local qf-newer-key ">")

(fn get-quickfix-history-size []
  (-> (vim.fn.getqflist {:nr :$}) (. :nr)))

(fn get-quickfix-current-index []
  (-> (vim.fn.getqflist {:nr 0}) (. :nr)))

(fn has-older-qf-stack-entry? []
  (> (get-quickfix-current-index) 1))

(fn has-newer-qf-stack-entry? []
  (< (get-quickfix-current-index) (get-quickfix-history-size)))

(fn qf-older-fn []
  ":colder without the error message when there is no older quickfix list."
  (if (has-older-qf-stack-entry?)
    (vim.api.nvim_command "silent colder")))

(fn qf-newer-fn []
  ":cnewer without the error message when there is no newer quickfix list."
  (if (has-newer-qf-stack-entry?)
    (vim.api.nvim_command "silent cnewer")))

(fn set-quickfix-mappings []
  "Mappings to navigate the quickfix history stack and open quickfix items in splits."

  (local opts {:buffer 0 :silent true :nowait true})

  ; open in a new vertical split
  (nmap :<c-v> (on-alternative-open :vsplit) opts)

  ; open in a new horizontal split
  (nmap :<c-x> (on-alternative-open :split) opts)

  ; older quickfix list
  (nmap qf-older-key qf-older-fn opts)

  ; newer quickfix list
  (nmap qf-newer-key qf-newer-fn opts))

(fn get-quickfix-title []
  (local title (-> (vim.fn.getqflist {:title 1}) (. :title)))
  (if (= title "")
    "quickfix list"
    title)
  )

(fn quickfix-title [colors]
  [(use "  " {:guibg colors.lavender :guifg :black})
   (.. " " (get-quickfix-title) " ")])

(fn quickfix-history-nav [colors]
  (if (> (get-quickfix-history-size) 1)
     [(use (.. " " qf-older-key " ")
           {:guifg (if (has-older-qf-stack-entry?)
                       colors.lavender
                       colors.surface1)})
      (use (.. (get-quickfix-current-index) "/" (get-quickfix-history-size))
           {:guifg :lavender})
      (use (.. " " qf-newer-key " ")
           {:guifg (if (has-newer-qf-stack-entry?)
                       colors.lavender
                       colors.surface1)})]
     ""))

(fn quickfix-winbar-component []
  (local colors (palette.get_palette))
  [(quickfix-title colors)
   (quickfix-history-nav colors)])

{: set-quickfix-mappings
 : quickfix-winbar-component}
