(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: sanitize-path} (require :own.helpers))
(local {: quickfix-winbar-component} (require :own.quickfix))
(local core (autoload :nfnl.core))
(local helpers (autoload :incline.helpers))
(local navic (autoload :nvim-navic))
(local nvim-web-devicons (autoload :nvim-web-devicons))
(local palette (autoload :catppuccin.palettes))
(local mode (autoload :own.mode))

(fn file-name [bufnr]
  (let [file-name (vim.fn.fnamemodify (vim.api.nvim_buf_get_name bufnr) ::.)]
    (.. " "
        (if (= file-name "")
          "[no name]"
          (sanitize-path file-name)))))

(fn modified? [bufnr]
  (if (core.get-in vim [:bo bufnr :modified])
    " " ""))

(fn read-only? [bufnr]
  (if (or (not (core.get-in vim [:bo bufnr :modifiable]))
          (core.get-in vim [:bo bufnr :readonly]))
     " " ""))

(fn terminal-component [term-title colors]
  (local term-color (mode.get-color))

  [(tx "  " {:guibg term-color :guifg colors.surface1})
   (tx (.. " " term-title " ") {:guifg colors.text})])

(fn help-component [colors props]
  (let [name (vim.fn.fnamemodify (vim.api.nvim_buf_get_name props.buf) ::t)]
    [(tx "  " {:guibg colors.lavender :guifg colors.surface1})
     (tx (.. " " name " ") {:guifg colors.white})]))

(fn file-component [props]
  (let [name (file-name props.buf)
        ext (vim.fn.fnamemodify name ::e)
        (icon color) (nvim-web-devicons.get_icon_color name ext {:default true})
        res [(if icon
                 (tx " " icon " " {:guibg color :guifg (helpers.contrast_color color)})
                 "")
             (tx name {:gui (if (core.get-in vim [:bo props.buf :modified])
                                :italic
                                "")})
             (modified? props.buf)
             (read-only? props.buf)]]
    (each [_ item (ipairs (or (navic.get_data props.buf) []))]
        (table.insert res [(tx "  " {:group :NavicSeparator})
                           (tx item.icon {:group (.. :NavicIcons item.type)})
                           (tx item.name {:group :NavicText})]))
    (table.insert res " ")
    res))

(fn render [props]
  (local colors (palette.get_palette))
  (local term-title (. (. vim.b props.buf) :term_title))
  (if term-title
    (terminal-component term-title colors)
    (match [(core.get-in vim [:bo props.buf :ft])]
      [:qf] (quickfix-winbar-component colors)
      [:help] (help-component colors props)
      [:fugitiveblame] []
      [] (file-component props))))

(tx :b0o/incline.nvim {:opts {:window {:padding 0
                                       :margin {:horizontal 0
                                                :vertical 0}}
                              :hide {:cursorline true}
                              :ignore {:unlisted_buffers false
                                       :buftypes [:prompt :nofile]
                                       :wintypes [:unknown :popup :autocmd]}
                              : render}})
