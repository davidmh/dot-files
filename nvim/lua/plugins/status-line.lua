-- [nfnl] Compiled from fnl/plugins/status-line.fnl by https://github.com/Olical/nfnl, do not edit.
local lazy_status = require("lazy.status")
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = require("own.helpers")
local sanitize_path = _local_2_["sanitize-path"]
local _local_3_ = require("own.quickfix")
local show_quickfix_title_3f = _local_3_["show-quickfix-title?"]
local get_quickfix_title = _local_3_["get-quickfix-title"]
local quickfix_history_status_component = _local_3_["quickfix-history-status-component"]
local heirline = autoload("heirline")
local conditions = autoload("heirline.conditions")
local core = autoload("nfnl.core")
local palettes = autoload("catppuccin.palettes")
local nvim_web_devicons = autoload("nvim-web-devicons")
local config = autoload("own.config")
local navic = autoload("nvim-navic")
local empty_space = {provider = " "}
local function component(data)
  vim.validate({init = {data.init, "function"}})
  local function _4_(_241)
    return _241.icon
  end
  local function _5_(_241)
    return {fg = _241.color}
  end
  table.insert(data, {provider = _4_, hl = _5_})
  local function _6_(_241)
    return _241.content
  end
  table.insert(data, {provider = _6_, hl = {fg = "fg"}})
  table.insert(data, {hl = {bold = true}})
  return data
end
local mode_colors = {n = "fg", i = "green", v = "blue", V = "cyan", ["\22"] = "cyan", c = "orange", s = "purple", S = "purple", ["\19"] = "purple", R = "orange", r = "orange", ["!"] = "red", t = "green"}
local mode_label = {n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK", R = "REPLACE", r = "REPLACE", ["!"] = "SHELL", t = "TERMINAL", nt = "T-NORMAL"}
local vi_mode
local function _7_(_241)
  _241["mode"] = vim.fn.mode(1)
  return nil
end
local function _8_()
  return (vim.o.filetype ~= "starter")
end
local function _9_(_241)
  return (core.get(mode_label, _241.mode, _241.mode) .. " ")
end
local function _10_(_241)
  return {fg = mode_colors[_241.mode], bold = true}
end
vi_mode = {init = _7_, condition = _8_, provider = _9_, hl = _10_, update = {"ModeChanged", "ColorScheme"}}
local macro_rec
local function _11_()
  return ((vim.fn.reg_recording() ~= "") and (vim.o.cmdheight == 0))
end
local function _12_()
  return (" recording @" .. vim.fn.reg_recording())
end
macro_rec = {condition = _11_, provider = _12_, hl = {fg = "coral"}, update = {"RecordingEnter", "RecordingLeave", "ColorScheme"}}
local show_cmd
local function _13_()
  return (vim.o.cmdheight == 0)
end
local function _14_()
  vim.opt.showcmdloc = "statusline"
  return nil
end
show_cmd = {condition = _13_, init = _14_, provider = "%3.5(%S%)"}
local show_search
local function _15_()
  local and_16_ = (vim.o.cmdheight == 0) and (vim.v.hlsearch ~= 0)
  if and_16_ then
    local tmp_3_auto = vim.fn.searchcount()
    if (nil ~= tmp_3_auto) then
      local tmp_3_auto0 = tmp_3_auto.total
      if (nil ~= tmp_3_auto0) then
        and_16_ = (tmp_3_auto0 > 0)
      else
        and_16_ = nil
      end
    else
      and_16_ = nil
    end
  end
  return and_16_
end
local function _21_()
  local _let_22_ = vim.fn.searchcount()
  local current = _let_22_["current"]
  local total = _let_22_["total"]
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
show_search = {condition = _15_, provider = _21_}
local function file_name()
  local file_name0 = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local _24_
  if (file_name0 == "") then
    _24_ = "[no name]"
  else
    if conditions.width_percent_below(#file_name0, 0.25) then
      _24_ = file_name0
    else
      _24_ = sanitize_path(file_name0)
    end
  end
  return (" " .. _24_)
end
local modified_3f
local function _27_()
  return vim.bo.modified
end
modified_3f = {condition = _27_, provider = " [+]", hl = {fg = "green"}}
local read_only_3f
local function _28_()
  return (not vim.bo.modifiable or vim.bo.readonly)
end
read_only_3f = {condition = _28_, provider = " \239\128\163", hl = {fg = "orange"}}
local file
local function _29_(_241)
  local name = file_name()
  local ext = vim.fn.fnamemodify(name, ":e")
  local icon, color = nvim_web_devicons.get_icon_color(name, ext, {default = true})
  _241["icon"] = icon
  _241["color"] = color
  _241["content"] = name
  return nil
end
file = component({init = _29_})
local file_flags = {modified_3f, read_only_3f}
local file_name_block
local function _30_()
  local _31_ = {vim.o.filetype, vim.o.buftype}
  if (_31_[1] == "fugitiveblame") then
    return false
  elseif (_31_[1] == "fugitive") then
    return false
  elseif (_31_[1] == "qf") then
    return false
  elseif (_31_[1] == "toggleterm") then
    return false
  elseif (true and (_31_[2] == "terminal")) then
    local _ = _31_[1]
    return false
  elseif true then
    local _ = _31_
    return true
  else
    return nil
  end
end
local function _33_(_241)
  _241["file-name"] = vim.api.nvim_buf_get_name(0)
  return nil
end
file_name_block = {file, file_flags, condition = _30_, init = _33_, hl = {bold = true}}
local quickfix_title
local function _34_(_241)
  _241["icon"] = "\239\145\145"
  _241["color"] = "lavender"
  _241["content"] = (" " .. get_quickfix_title())
  return nil
end
quickfix_title = component({condition = show_quickfix_title_3f, hl = {fg = "crust"}, init = _34_})
local dead_space = {provider = "             "}
local push_right = {provider = "%="}
local function diagnostic(severity_code, color)
  local function _35_(_241)
    return (" " .. config.icons[severity_code] .. " " .. _241[severity_code])
  end
  local function _36_(_241)
    return (_241[severity_code] > 0)
  end
  return {provider = _35_, condition = _36_, hl = {fg = color}, event = "DiagnosticChanged"}
end
local function diagnostic_count(severity_code)
  return #vim.diagnostic.get(0, {severity = vim.diagnostic.severity[severity_code]})
end
local diagnostics_block
local function _37_()
  return conditions.has_diagnostics()
end
local function _38_(self)
  self["ERROR"] = diagnostic_count("ERROR")
  self["WARN"] = diagnostic_count("WARN")
  self["INFO"] = diagnostic_count("INFO")
  self["HINT"] = diagnostic_count("HINT")
  return nil
end
diagnostics_block = {diagnostic("ERROR", "red"), diagnostic("WARN", "yellow"), diagnostic("INFO", "fg"), diagnostic("HINT", "green"), empty_space, conditon = _37_, init = _38_, update = {"DiagnosticChanged", "BufEnter", "ColorScheme"}}
local git_block
local function _39_()
  return conditions.is_git_repo()
end
local function _40_(_241)
  local head = vim.b.gitsigns_status_dict["head"]
  local root = vim.b.gitsigns_status_dict["root"]
  local cwd_relative_path = string.gsub(string.gsub(vim.fn.getcwd(), vim.fn.fnamemodify(root, ":h"), ""), "^/", "")
  local status = vim.trim((vim.b.gitsigns_status or ""))
  _241["icon"] = "\239\144\152"
  _241["color"] = "rosewater"
  _241["content"] = table.concat({(" [" .. cwd_relative_path .. "]"), head, status}, " ")
  return nil
end
git_block = component({condition = _39_, init = _40_, hl = {bold = true}})
local git_blame
local function _41_(_241)
  _241["icon"] = "\238\156\130 "
  _241["color"] = "red"
  _241["content"] = "git blame"
  return nil
end
local function _42_()
  return (vim.o.filetype == "fugitiveblame")
end
git_blame = component({init = _41_, condition = _42_, hl = {bold = true}})
local lsp_breadcrumb
local function _43_()
  return navic.get_location({highlight = true})
end
local function _44_()
  return (navic.is_available() and (#navic.get_location() > 0))
end
lsp_breadcrumb = {provider = _43_, condition = _44_, hl = {bg = "NONE", bold = true}, update = {"CursorMoved", "ColorScheme"}}
local line_number
local function _45_()
  return vim.o.number
end
line_number = {provider = " %2{&nu ? (&rnu && v:relnum ? v:relnum : v:lnum) : ''} ", condition = _45_}
local fold
local function _46_()
  local line_num = vim.v.lnum
  if (vim.fn.foldlevel(line_num) > vim.fn.foldlevel((line_num - 1))) then
    if (vim.fn.foldclosed(line_num) == -1) then
      return "\239\145\188 "
    else
      return "\239\145\160 "
    end
  else
    return nil
  end
end
fold = {provider = _46_}
local signs
local function _49_()
  return (vim.o.filetype ~= "NeogitStatus")
end
signs = {provider = "%s", condition = _49_}
local plugin_updates
local function _50_(_241)
  local _let_51_ = vim.split(lazy_status.updates(), " ")
  local icon = _let_51_[1]
  local count = _let_51_[2]
  _241["icon"] = (" " .. icon)
  _241["content"] = (" " .. count)
  _241["color"] = "rosewater"
  return nil
end
local function _52_()
  return lazy_status.has_updates()
end
plugin_updates = {component({init = _50_, condition = _52_})}
local statuscolumn = {fold, push_right, signs, line_number}
local winbar = {lsp_breadcrumb, quickfix_title, push_right, quickfix_history_status_component, git_blame, file_name_block}
local statusline = {vi_mode, macro_rec, dead_space, push_right, show_cmd, diagnostics_block, show_search, git_block, plugin_updates, hl = {bg = "NONE"}}
local disabled_winbar = {buftype = {"nofile", "prompt", "terminal"}, filetype = {"^git.*"}}
local function initialize_heirline()
  vim.o.showmode = false
  local opts
  local function _53_(_241)
    return conditions.buffer_matches(disabled_winbar, _241.buf)
  end
  opts = {colors = palettes.get_palette(), disable_winbar_cb = _53_}
  return heirline.setup({winbar = winbar, statuscolumn = statuscolumn, statusline = statusline, opts = opts})
end
--[[ (initialize-heirline) ]]
do
  local group = vim.api.nvim_create_augroup("update-heirline", {clear = true})
  vim.api.nvim_create_autocmd("ColorScheme", {pattern = "*", callback = initialize_heirline, group = group})
end
return {"rebelot/heirline.nvim", dependencies = {"nvim-tree/nvim-web-devicons", "catppuccin"}, event = "VeryLazy", config = initialize_heirline}
