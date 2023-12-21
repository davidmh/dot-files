-- [nfnl] Compiled from fnl/plugins/neovide.fnl by https://github.com/Olical/nfnl, do not edit.
local function get_font_size()
  return tonumber(string.match(vim.o.guifont, "h(%d+)$"))
end
local function set_font_size(n)
  vim.o["guifont"] = string.gsub(vim.o.guifont, "h%d+", string.format("h%d", (n + get_font_size())))
  return nil
end
if vim.g.neovide then
  vim.g.neovide_padding_top = 25
  vim.g.neovide_padding_bottom = 25
  vim.g.neovide_padding_right = 25
  vim.g.neovide_padding_left = 25
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.g.neovide_remember_window_size = true
  local function _1_()
    return set_font_size(1)
  end
  vim.keymap.set("n", "<D-=>", _1_)
  local function _2_()
    return set_font_size(-1)
  end
  vim.keymap.set("n", "<D-->", _2_)
else
end
return {}
