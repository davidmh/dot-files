(import-macros {: autocmd} :own.macros)
(local {: autoload} (require :nfnl.module))
(local projects (autoload :own.projects))

; format on save with rubocop through solargraph

(autocmd :BufWritePre {:pattern :*.rb
                       :callback #(vim.lsp.buf.format)})

(autocmd :User {:pattern :RooterChDir
                :callback #(projects.add)})

