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

(local mode-colors {:n    :modeNormal
                    :i    :modeInsert
                    :v    :modeVisual
                    :V    :modeVLine
                    "\22" :modeVBlock
                    :c    :modeCommand
                    :s    :modeSelect
                    :S    :modeSLine
                    "\19" :modeSBlock
                    :R    :modeReplace
                    :r    :modeReplace
                    :!    :modeShellCmd
                    :t    :modeTerm
                    :nt   :modeNormalTerm})

(fn M.get-color []
  (local mode (vim.fn.mode 1))
  (. mode-colors mode))

(fn M.get-label []
  (local mode (vim.fn.mode 1))
  (or
    (. mode-label mode)
    mode))

M
