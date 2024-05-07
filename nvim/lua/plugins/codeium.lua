-- [nfnl] Compiled from fnl/plugins/codeium.fnl by https://github.com/Olical/nfnl, do not edit.
local function config()
  vim.g.codeium_filetypes = {zsh = false}
  local function _1_()
    return vim.fn["codeium#CycleCompletions"](1)
  end
  vim.keymap.set("i", "<M-n>", _1_)
  local function _2_()
    return vim.fn["codeium#CycleCompletions"](-1)
  end
  vim.keymap.set("i", "<M-p>", _2_)
  local function _3_()
    return vim.fn["codeium#Clear"]()
  end
  return vim.keymap.set("i", "<M-x>", _3_)
end
return {"Exafunction/codeium.vim", event = "BufEnter", dependencies = {"nvim-lua/plenary.nvim"}, config = config}
