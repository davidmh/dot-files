-- [nfnl] Compiled from fnl/plugins/incline.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = require("own.helpers")
local sanitize_path = _local_2_["sanitize-path"]
local _local_3_ = require("own.quickfix")
local quickfix_winbar_component = _local_3_["quickfix-winbar-component"]
local core = autoload("nfnl.core")
local helpers = autoload("incline.helpers")
local navic = autoload("nvim-navic")
local nvim_web_devicons = autoload("nvim-web-devicons")
local function file_name(bufnr)
  local file_name0 = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":.")
  local _4_
  if (file_name0 == "") then
    _4_ = "[no name]"
  else
    _4_ = sanitize_path(file_name0)
  end
  return (" " .. _4_)
end
local function modified_3f(bufnr)
  if core["get-in"](vim, {"bo", bufnr, "modified"}) then
    return " [+]"
  else
    return ""
  end
end
local function read_only_3f(bufnr)
  if (not core["get-in"](vim, {"bo", bufnr, "modifiable"}) or core["get-in"](vim, {"bo", bufnr, "readonly"})) then
    return " \239\128\163"
  else
    return ""
  end
end
local function render(props)
  local _8_ = {core["get-in"](vim, {"bo", props.buf, "ft"})}
  if (_8_[1] == "qf") then
    return quickfix_winbar_component()
  elseif true then
    local name = file_name(props.buf)
    local ext = vim.fn.fnamemodify(name, ":e")
    local icon, color = nvim_web_devicons.get_icon_color(name, ext, {default = true})
    local res
    local _9_
    if icon then
      _9_ = {" ", icon, " ", guibg = color, guifg = helpers.contrast_color(color)}
    else
      _9_ = ""
    end
    local _11_
    if core["get-in"](vim, {"bo", props.buf, "modified"}) then
      _11_ = "bold,italic"
    else
      _11_ = "bold"
    end
    res = {_9_, {name, gui = _11_}, modified_3f(props.buf), read_only_3f(props.buf)}
    if props.focused then
      for _, item in ipairs((navic.get_data(props.buf) or {})) do
        table.insert(res, {{" \239\132\133 ", group = "NavicSeparator"}, {item.icon, group = ("NavicIcons" .. item.type)}, {item.name, group = "NavicText"}})
      end
    else
    end
    table.insert(res, " ")
    return res
  else
    return nil
  end
end
return {"b0o/incline.nvim", event = "VeryLazy", opts = {window = {padding = 0, margin = {horizontal = 0, vertical = 0}}, ignore = {buftypes = {"prompt", "nofile"}, wintypes = {"unknown", "popup", "autocmd"}}, render = render}}
