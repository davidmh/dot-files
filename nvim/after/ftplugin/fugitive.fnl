(local padding 2)
(local buffer-line-count (+ (vim.fn.line "$") padding))
(local minimum-window-height 10)

; Adjust the window height to fit the buffer content or an arbitrary minimum
(vim.api.nvim_win_set_height 0 (-> (vim.fn.winheight 0)
                                   (math.min buffer-line-count)
                                   (math.max minimum-window-height)))
