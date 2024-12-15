(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: sanitize-path} (require :own.helpers))
(local {: quickfix-winbar-component} (require :own.quickfix))
(local core (autoload :nfnl.core))
(local helpers (autoload :incline.helpers))
(local navic (autoload :nvim-navic))
(local nvim-web-devicons (autoload :nvim-web-devicons))
(local palette (autoload :catppuccin.palettes))

(fn file-name [bufnr]
  (let [file-name (vim.fn.fnamemodify (vim.api.nvim_buf_get_name bufnr) ::.)]
    (.. " "
        (if (= file-name "")
          "[no name]"
          (sanitize-path file-name)))))

(fn modified? [bufnr]
  (if (core.get-in vim [:bo bufnr :modified])
    " [+]" ""))

(fn read-only? [bufnr]
  (if (or (not (core.get-in vim [:bo bufnr :modifiable]))
          (core.get-in vim [:bo bufnr :readonly]))
     " " ""))

(fn terminal-component [colors]
  [(use "  " {:guibg colors.lavender :guifg colors.surface1})
   (use " terminal " {:guifg colors.white})])

(fn help-component [colors props]
  (let [name (vim.fn.fnamemodify (vim.api.nvim_buf_get_name props.buf) ::t)]
    [(use "  " {:guibg colors.lavender :guifg colors.surface1})
     (use (.. " " name " ") {:guifg colors.white})]))

(fn file-component [props]
  (let [name (file-name props.buf)
             ext (vim.fn.fnamemodify name ::e)
             (icon color) (nvim-web-devicons.get_icon_color name ext {:default true})
             res [(if icon
                      (use " " icon " " {:guibg color :guifg (helpers.contrast_color color)})
                      "")
                  (use name {:gui (if (core.get-in vim [:bo props.buf :modified])
                                      "bold,italic"
                                      :bold)})
                  (modified? props.buf)
                  (read-only? props.buf)]]
    (if props.focused
        (each [_ item (ipairs (or (navic.get_data props.buf) []))]
          (table.insert res [(use "  " {:group :NavicSeparator})
                             (use item.icon {:group (.. :NavicIcons item.type)})
                             (use item.name {:group :NavicText})])))
    (table.insert res " ")
    res))

(fn render [props]
  (local colors (palette.get_palette))
  (match [(core.get-in vim [:bo props.buf :ft])]
    [:qf] (quickfix-winbar-component colors)
    [:toggleterm] (terminal-component colors)
    [:terminal] (terminal-component colors)
    [:help] (help-component colors props)
    [] (file-component props)))

(use :b0o/incline.nvim {:event :VeryLazy
                        :opts {:window {:padding 0
                                        :margin {:horizontal 0
                                                 :vertical 0}}
                               :ignore {:unlisted_buffers false
                                        :buftypes [:prompt :nofile]
                                        :wintypes [:unknown :popup :autocmd]}
                               : render}})
