(local {: autoload
        : define} (require :nfnl.module))
(local palettes (autoload :catppuccin.palettes))

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

(local mode-colors {:n    :text
                    :i    :green
                    :v    :sky
                    :V    :teal
                    "\22" :teal
                    :c    :flamingo
                    :s    :mauve
                    :S    :mauve
                    "\19" :mauve
                    :R    :flamingo
                    :r    :flamingo
                    :!    :red
                    :t    :green
                    :nt   :text})

(fn M.get-color []
  (local palette (palettes.get_palette))
  (local mode (vim.fn.mode 1))
  (local color-name (. mode-colors mode))

  (. palette color-name))

(fn M.get-label []
  (local mode (vim.fn.mode 1))
  (. mode-label mode))

M
