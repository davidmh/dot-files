-- [nfnl] fnl/plugins/incline.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
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
    return " \239\145\153"
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
local function terminal_component(term_title)
  return {{"\238\158\149 ", guibg = "fg", guifg = "black"}, {(" " .. term_title .. " "), guifg = "fg"}}
end
local function help_component(props)
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
  return {{"\239\131\189 ", guibg = "purple"}, {(" " .. name .. " "), guifg = "white"}}
end
local function file_component(props)
  local name = file_name(props.buf)
  local ext = vim.fn.fnamemodify(name, ":e")
  local icon, color = nvim_web_devicons.get_icon_color(name, ext, {default = true})
  local res
  local _8_
  if icon then
    _8_ = {icon, " ", guibg = color, guifg = helpers.contrast_color(color)}
  else
    _8_ = ""
  end
  local _10_
  if core["get-in"](vim, {"bo", props.buf, "modified"}) then
    _10_ = "italic"
  else
    _10_ = ""
  end
  res = {_8_, {name, gui = _10_}, modified_3f(props.buf), read_only_3f(props.buf)}
  for _, item in ipairs((navic.get_data(props.buf) or {})) do
    table.insert(res, {{" \239\132\133 ", group = "NavicSeparator"}, {item.icon, group = ("NavicIcons" .. item.type)}, {item.name, group = "NavicText"}})
  end
  table.insert(res, " ")
  return res
end
local function render(props)
  local term_title = vim.b[props.buf].term_title
  if term_title then
    return terminal_component(term_title)
  else
    local case_12_ = {core["get-in"](vim, {"bo", props.buf, "ft"})}
    if (case_12_[1] == "qf") then
      return quickfix_winbar_component()
    elseif (case_12_[1] == "help") then
      return help_component(props)
    elseif (case_12_[1] == "fugitiveblame") then
      return {}
    elseif true then
      return file_component(props)
    else
      return nil
    end
  end
end
return {"b0o/incline.nvim", opts = {window = {padding = 0, margin = {horizontal = 0, vertical = 0}}, ignore = {buftypes = {"prompt", "nofile"}, wintypes = {"unknown", "popup", "autocmd"}, unlisted_buffers = false}, render = render}}
