(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local tsc-utils (autoload :tsc.utils))

[(tx :davidmh/tsc.nvim {:opts {:auto_open_qflist true
                               :auto_focus_qflist true}
                        :branch :combined-prs})

 (tx :pmizio/typescript-tools.nvim {:dependencies [:nvim-lua/plenary.nvim]
                                    :opts {:settings {:expose_as_code_action [:add_missing_imports]}
                                           :root_markers [:tsconfig.json]
                                           :handlers {:textDocument/publishDiagnostics (fn [...]
                                                                                         (tsc-utils.text_document_published_diagnostics_handler ...))}}})]

