-- [nfnl] Compiled from fnl/plugins/gemini.fnl by https://github.com/Olical/nfnl, do not edit.
return {"gera2ld/ai.nvim", dependencies = {"nvim-lua/plenary.nvim"}, cmd = {"GeminiDefineCword", "GeminiDefine", "GeminiTranslate", "GeminiImprove"}, opts = {api_key = vim.env.GEMINI_API_KEY, locale = "en", alternate_locale = "es"}}
