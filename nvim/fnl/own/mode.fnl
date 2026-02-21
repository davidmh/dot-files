(local {: define} (require :nfnl.module))

(local M (define :own.mode))

(local mode-label {:n    :NORMAL
                   :i    :INSERT
                   :v    :VISUAL
                   :V    :V-LINE
                   "\22" :V-BLOCK
                   :c    :COMMAND
                   :s    :SELECT
                   :S    :S-LINE
                   "\19" :S-BLOCK
                   :R    :REPLACE
                   :r    :REPLACE
                   :!    :SHELL
                   :t    :TERMINAL
                   :nt   :T-NORMAL})

(local mode-colors {:n    :fg
                    :i    :lotusGreen
                    :v    :blue
                    :V    :lotusTeal1
                    "\22" :lotusTeal1
                    :c    :sakuraPink
                    :s    :purple
                    :S    :purple
                    "\19" :purple
                    :R    :sakuraPink
                    :r    :sakuraPink
                    :!    :red
                    :t    :lotusGreen
                    :nt   :fg})

(fn M.get-color []
  (local mode (vim.fn.mode 1))
  (. mode-colors mode))

(fn M.get-label []
  (local mode (vim.fn.mode 1))
  (or
    (. mode-label mode)
    mode))

M
