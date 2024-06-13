(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local ai (autoload :ai))

(fn get-code [opts]
  (-> 0
    (vim.api.nvim_buf_get_lines (- opts.line1 1) opts.line2 false)
    (table.concat "\n")))

(fn explain-diagnostic [opts]
  ; get the diagnostic under the cursor
  (local diagnostic (vim.diagnostic.get_next {:severity vim.diagnostic.severity.ERROR}))

  (when (not diagnostic)
    (vim.notify "Nothing to explain under the cursor")
    (lua :return))

  (local prompt (.. "Explain the \"" diagnostic.source "\" diagnostic: " diagnostic.message
                    "\n\nFor the following code:\n\n"
                    "```" vim.bo.filetype "\n" (get-code opts) "\n```\n\n"
                    "Wrap the explanation text to a 100 characters per line."))

  (ai.handle :freeStyle prompt))

(fn explain-code [opts]
  (local prompt (.. "Explain the following code block:\n\n"
                    "```" vim.bo.filetype "\n" (get-code opts) "\n```\n\n"
                    "Wrap the explanation text to a 100 characters per line."))

  (ai.handle :freeStyle prompt))

(fn config []
  (ai.setup {:gemini {:api_key vim.env.GEMINI_API_KEY}
             :result_popup_gets_focus true})

  (vim.api.nvim_create_user_command :ExplainDiagnostic
                                    explain-diagnostic
                                    {:range 2
                                     :desc "Explain diagnostic under the cursor/selection"})

  (vim.api.nvim_create_user_command :ExplainCode
                                    explain-code
                                    {:range 2
                                     :desc "Explain code under the cursor/selection"}))

(use :gera2ld/ai.nvim {:dependencies [:nvim-lua/plenary.nvim]
                       :cmd [:AIAsk
                             :AIDefineCword
                             :AIDefine
                             :AITranslate
                             :AIImprove
                             :ExplainCode
                             :ExplainDiagnostic]
                       : config})
