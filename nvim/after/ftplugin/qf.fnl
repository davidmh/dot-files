(import-macros {: autocmd} :own.macros)
(local {: set-quickfix-mappings} (require :own.quickfix))

(set vim.wo.number true)
(set-quickfix-mappings)

(set vim.g.qf_bufnr (vim.api.nvim_get_current_buf))

; one-time cleanup
(autocmd :WinClosed {:buffer vim.g.qf_bufnr
                     :callback #(or
                                  (set vim.g.qf_bufnr nil)
                                  true)})
