-- [nfnl] Compiled from fnl/plugins/status-line.fnl by https://github.com/Olical/nfnl, do not edit.
local lazy_status = require("lazy.status")
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local heirline = autoload("heirline")
local conditions = autoload("heirline.conditions")
local core = autoload("nfnl.core")
local palettes = autoload("catppuccin.palettes")
local config = autoload("own.config")
local empty_space = {provider = " "}
local function component(data)
  vim.validate({init = {data.init, "function"}})
  local function _2_(_241)
    return _241.icon
  end
  local function _3_(_241)
    return {fg = _241.color}
  end
  table.insert(data, {provider = _2_, hl = _3_})
  local function _4_(_241)
    return _241.content
  end
  table.insert(data, {provider = _4_, hl = {fg = "fg"}})
  table.insert(data, {hl = {bold = true}})
  return data
end
local mode_colors = {n = "fg", i = "green", v = "blue", V = "cyan", ["\22"] = "cyan", c = "orange", s = "purple", S = "purple", ["\19"] = "purple", R = "orange", r = "orange", ["!"] = "red", t = "green"}
local mode_label = {n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK", R = "REPLACE", r = "REPLACE", ["!"] = "SHELL", t = "TERMINAL", nt = "T-NORMAL"}
local vi_mode
local function _5_(_241)
  _241["mode"] = vim.fn.mode(1)
  return nil
end
local function _6_()
  return (vim.o.filetype ~= "starter")
end
local function _7_(_241)
  return (core.get(mode_label, _241.mode, _241.mode) .. " ")
end
local function _8_(_241)
  return {fg = mode_colors[_241.mode], bold = true}
end
vi_mode = {init = _5_, condition = _6_, provider = _7_, hl = _8_, update = {"ModeChanged", "ColorScheme"}}
local macro_rec
local function _9_()
  return ((vim.fn.reg_recording() ~= "") and (vim.o.cmdheight == 0))
end
local function _10_()
  return (" recording @" .. vim.fn.reg_recording())
end
macro_rec = {condition = _9_, provider = _10_, hl = {fg = "coral"}, update = {"RecordingEnter", "RecordingLeave", "ColorScheme"}}
local show_cmd
local function _11_()
  return (vim.o.cmdheight == 0)
end
local function _12_()
  vim.opt.showcmdloc = "statusline"
  return nil
end
show_cmd = {condition = _11_, init = _12_, provider = "%3.5(%S%)"}
local show_search
local function _13_()
  local and_14_ = (vim.o.cmdheight == 0) and (vim.v.hlsearch ~= 0)
  if and_14_ then
    local tmp_3_auto = vim.fn.searchcount()
    if (nil ~= tmp_3_auto) then
      local tmp_3_auto0 = tmp_3_auto.total
      if (nil ~= tmp_3_auto0) then
        and_14_ = (tmp_3_auto0 > 0)
      else
        and_14_ = nil
      end
    else
      and_14_ = nil
    end
  end
  return and_14_
end
local function _19_()
  local _let_20_ = vim.fn.searchcount()
  local current = _let_20_["current"]
  local total = _let_20_["total"]
  local direction
  if (vim.v.searchforward == 1) then
    direction = "\239\144\179"
  else
    direction = "\239\144\177"
  end
  local pattern = vim.fn.getreg("/")
  local counter = ("[" .. current .. "/" .. total .. "]")
  return (" " .. direction .. " " .. pattern .. " " .. counter)
end
show_search = {condition = _13_, provider = _19_}
local dead_space = {provider = "             "}
local push_right = {provider = "%="}
local function diagnostic(severity_code, color)
  local function _22_(_241)
    return (" " .. config.icons[severity_code] .. " " .. _241[severity_code])
  end
  local function _23_(_241)
    return (_241[severity_code] > 0)
  end
  return {provider = _22_, condition = _23_, hl = {fg = color}, event = "DiagnosticChanged"}
end
local function diagnostic_count(severity_code)
  return #vim.diagnostic.get(0, {severity = vim.diagnostic.severity[severity_code]})
end
local diagnostics_block
local function _24_()
  return conditions.has_diagnostics()
end
local function _25_(self)
  self["ERROR"] = diagnostic_count("ERROR")
  self["WARN"] = diagnostic_count("WARN")
  self["INFO"] = diagnostic_count("INFO")
  self["HINT"] = diagnostic_count("HINT")
  return nil
end
diagnostics_block = {diagnostic("ERROR", "red"), diagnostic("WARN", "yellow"), diagnostic("INFO", "fg"), diagnostic("HINT", "green"), empty_space, conditon = _24_, init = _25_, update = {"DiagnosticChanged", "BufEnter", "ColorScheme"}}
local git_block
local function _26_()
  return conditions.is_git_repo()
end
local function _27_(_241)
  local head = vim.b.gitsigns_status_dict["head"]
  local root = vim.b.gitsigns_status_dict["root"]
  local cwd_relative_path = string.gsub(string.gsub(vim.fn.getcwd(), vim.fn.fnamemodify(root, ":h"), ""), "^/", "")
  local status = vim.trim((vim.b.gitsigns_status or ""))
  _241["icon"] = "\239\144\152"
  _241["color"] = "rosewater"
  _241["content"] = table.concat({(" [" .. cwd_relative_path .. "]"), head, status}, " ")
  return nil
end
git_block = component({condition = _26_, init = _27_, hl = {bold = true}})
local plugin_updates
local function _28_(_241)
  local _let_29_ = vim.split(lazy_status.updates(), " ")
  local icon = _let_29_[1]
  local count = _let_29_[2]
  _241["icon"] = (" " .. icon)
  _241["content"] = (" " .. count)
  _241["color"] = "rosewater"
  return nil
end
local function _30_()
  return lazy_status.has_updates()
end
plugin_updates = {component({init = _28_, condition = _30_})}
local statusline = {vi_mode, macro_rec, dead_space, push_right, show_cmd, diagnostics_block, show_search, git_block, plugin_updates, hl = {bg = "NONE"}}
local function initialize_heirline()
  vim.o.showmode = false
  local opts = {colors = palettes.get_palette()}
  return heirline.setup({statusline = statusline, opts = opts})
end
--[[ (initialize-heirline) ]]
do
  local group = vim.api.nvim_create_augroup("update-heirline", {clear = true})
  vim.api.nvim_create_autocmd("ColorScheme", {pattern = "*", callback = initialize_heirline, group = group})
end
return {"rebelot/heirline.nvim", dependencies = {"nvim-tree/nvim-web-devicons", "catppuccin"}, event = "VeryLazy", config = initialize_heirline}
