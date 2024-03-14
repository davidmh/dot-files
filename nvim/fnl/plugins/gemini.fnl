(import-macros {: use} :own.macros)

(use :gera2ld/ai.nvim {:dependencies [:nvim-lua/plenary.nvim]
                       :cmd [:GeminiAsk
                             :GeminiDefineCword
                             :GeminiDefine
                             :GeminiTranslate
                             :GeminiImprove]
                       :opts {:api_key vim.env.GEMINI_API_KEY
                              :locale :en
                              :alternate_locale :es}})
