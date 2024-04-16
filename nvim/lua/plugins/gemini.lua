-- [nfnl] Compiled from fnl/plugins/gemini.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local ai = autoload("ai")
local function get_code(opts)
  return table.concat(vim.api.nvim_buf_get_lines(0, (opts.line1 - 1), opts.line2, false), "\n")
end
local function explain_diagnostic(opts)
  local diagnostic = vim.diagnostic.get_next()
  if not diagnostic then
    vim.notify("Nothing to explain under the cursor")
    return
  else
  end
  local prompt = ("Explain the \"" .. diagnostic.source .. "\" diagnostic: " .. diagnostic.message .. "\n\nFor the following code:\n\n" .. "```" .. vim.bo.filetype .. "\n" .. get_code(opts) .. "\n```\n\n" .. "Wrap the explanation text to a 100 characters per line.")
  return ai.handle("freeStyle", prompt)
end
local function explain_code(opts)
  local prompt = ("Explain the following code block:\n\n" .. "```" .. vim.bo.filetype .. "\n" .. get_code(opts) .. "\n```\n\n" .. "Wrap the explanation text to a 100 characters per line.")
  return ai.handle("freeStyle", prompt)
end
local function config()
  ai.setup({gemini = {api_key = vim.env.GEMINI_API_KEY}, result_popup_gets_focus = true, locale = "en"})
  vim.api.nvim_create_user_command("ExplainDiagnostic", explain_diagnostic, {range = 2, desc = "Explain diagnostic under the cursor/selection"})
  return vim.api.nvim_create_user_command("ExplainCode", explain_code, {range = 2, desc = "Explain code under the cursor/selection"})
end
return {"gera2ld/ai.nvim", dependencies = {"nvim-lua/plenary.nvim"}, cmd = {"GeminiAsk", "GeminiDefineCword", "GeminiDefine", "GeminiTranslate", "GeminiImprove", "ExplainCode", "ExplainDiagnostic"}, config = config}
