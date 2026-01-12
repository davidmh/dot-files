(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local bm (autoload :tsc.better-messages))

(fn translate-diagnostic [diagnostic]
  "
  tsc.nvim has a neat feature to rephrase TS errors, but by default it only
  displays those translated errors in the quickfix list, we use the handler
  callbacks in typescript-tools to translate the diagnostics as they show on a
  buffer.
  "
  (set diagnostic.message (bm.translate (.. "TS" diagnostic.code ": " diagnostic.message)))
  diagnostic)

(fn published-diagnostics [err res ctx config]
  (set res.diagnostics (vim.tbl_map translate-diagnostic res.diagnostics))

  (vim.lsp.diagnostic.on_publish_diagnostics err res ctx config))

[(tx :dmmulroy/tsc.nvim {:opts {:auto_open_qflist true
                                :auto_focus_qflist true}})

 (tx :pmizio/typescript-tools.nvim {:dependencies [:nvim-lua/plenary.nvim]
                                    :opts {:settings {:expose_as_code_action [:add_missing_imports]}
                                           :root_markers [:tsconfig.json]
                                           :handlers {:textDocument/publishDiagnostics published-diagnostics}}})]

