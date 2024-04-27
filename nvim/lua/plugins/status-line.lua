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
local neorg_mode = autoload("neorg.modules.core.mode.module")
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
local not_a_term
local function _7_()
  return ((vim.o.buftype ~= "terminal") and (vim.o.filetype ~= "toggleterm"))
end
not_a_term = _7_
local vi_mode
local function _8_(_241)
  _241["mode"] = vim.fn.mode(1)
  return nil
end
local function _9_()
  return (vim.o.filetype ~= "starter")
end
local function _10_(_241)
  return (core.get(mode_label, _241.mode, _241.mode) .. " ")
end
local function _11_(_241)
  return {fg = mode_colors[_241.mode], bold = true}
end
vi_mode = {init = _8_, condition = _9_, provider = _10_, hl = _11_, update = {"ModeChanged", "ColorScheme"}}
local macro_rec
local function _12_()
  return ((vim.fn.reg_recording() ~= "") and (vim.o.cmdheight == 0))
end
local function _13_()
  return (" recording @" .. vim.fn.reg_recording())
end
macro_rec = {condition = _12_, provider = _13_, hl = {fg = "coral"}, update = {"RecordingEnter", "RecordingLeave", "ColorScheme"}}
local show_cmd
local function _14_()
  return (vim.o.cmdheight == 0)
end
local function _15_()
  vim.opt.showcmdloc = "statusline"
  return nil
end
show_cmd = {condition = _14_, init = _15_, provider = "%3.5(%S%)"}
local show_search
local function _16_()
  local function _17_()
    local _18_ = vim.fn.searchcount()
    if (nil ~= _18_) then
      local _19_ = (_18_).total
      if (nil ~= _19_) then
        return (_19_ > 0)
      else
        return _19_
      end
    else
      return _18_
    end
  end
  return ((vim.o.cmdheight == 0) and (vim.v.hlsearch ~= 0) and _17_())
end
local function _22_()
  local _let_23_ = vim.fn.searchcount()
  local current = _let_23_["current"]
  local total = _let_23_["total"]
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
show_search = {condition = _16_, provider = _22_}
local neorg_mode0
local function _25_(_241)
  _241["icon"] = " \238\152\179 "
  _241["color"] = "purple"
  _241["content"] = (neorg_mode.public.get_mode() .. " ")
  return nil
end
local function _26_()
  return (vim.o.filetype == "norg")
end
neorg_mode0 = component({init = _25_, condition = _26_})
local function file_name()
  local file_name0 = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local function _28_()
    if (file_name0 == "") then
      return "[no name]"
    else
      if conditions.width_percent_below(#file_name0, 0.25) then
        return file_name0
      else
        return sanitize_path(file_name0)
      end
    end
  end
  return (" " .. _28_())
end
local modified_3f
local function _29_()
  return vim.bo.modified
end
modified_3f = {condition = _29_, provider = " [+]", hl = {fg = "green"}}
local read_only_3f
local function _30_()
  return (not vim.bo.modifiable or vim.bo.readonly)
end
read_only_3f = {condition = _30_, provider = " \239\128\163", hl = {fg = "orange"}}
local file
local function _31_(_241)
  local name = file_name()
  local ext = vim.fn.fnamemodify(name, ":e")
  local icon, color = nvim_web_devicons.get_icon_color(name, ext, {default = true})
  do end (_241)["icon"] = icon
  _241["color"] = color
  _241["content"] = name
  return nil
end
file = component({init = _31_})
local file_flags = {modified_3f, read_only_3f}
local file_name_block
local function _32_()
  return ((vim.o.filetype ~= "fugitiveblame") and (vim.o.filetype ~= "qf") and not_a_term())
end
local function _33_(_241)
  _241["file-name"] = vim.api.nvim_buf_get_name(0)
  return nil
end
file_name_block = {file, file_flags, {condition = _32_, init = _33_}}
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
    return (" " .. config.icons[severity_code] .. " " .. (_241)[severity_code])
  end
  local function _36_(_241)
    return ((_241)[severity_code] > 0)
  end
  return {provider = _35_, condition = _36_, hl = {fg = color}}
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
  do end (self)["WARN"] = diagnostic_count("WARN")
  do end (self)["INFO"] = diagnostic_count("INFO")
  do end (self)["HINT"] = diagnostic_count("HINT")
  return nil
end
diagnostics_block = {diagnostic("ERROR", "red"), diagnostic("WARN", "yellow"), diagnostic("INFO", "fg"), diagnostic("HINT", "green"), empty_space, conditon = _37_, init = _38_, update = {"DiagnosticChanged", "BufEnter", "ColorScheme"}}
local git_block
local function _39_()
  return conditions.is_git_repo()
end
local function _40_(_241)
  local _local_41_ = vim.b.gitsigns_status_dict
  local head = _local_41_["head"]
  local status = vim.trim((vim.b.gitsigns_status or ""))
  do end (_241)["icon"] = "\239\144\152"
  _241["color"] = "rosewater"
  _241["content"] = (" " .. head .. " " .. status)
  return nil
end
git_block = {empty_space, component({condition = _39_, init = _40_, hl = {bold = true}})}
local git_blame
local function _42_(_241)
  _241["icon"] = "\238\156\130 "
  _241["color"] = "red"
  _241["content"] = "git blame"
  return nil
end
local function _43_()
  return (vim.o.filetype == "fugitiveblame")
end
git_blame = component({init = _42_, condition = _43_, hl = {bold = true}})
local lsp_breadcrumb
local function _44_()
  return navic.get_location({highlight = true})
end
local function _45_()
  return (navic.is_available() and (#navic.get_location() > 0))
end
lsp_breadcrumb = {provider = _44_, condition = _45_, hl = {bg = "NONE", bold = true}, update = {"CursorMoved", "ColorScheme"}}
local line_number
local function _46_()
  return vim.o.number
end
line_number = {provider = " %2{&nu ? (&rnu && v:relnum ? v:relnum : v:lnum) : ''} ", condition = _46_}
local fold
local function _47_()
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
fold = {provider = _47_}
local signs = {provider = "%s"}
local plugin_updates
local function _50_(_241)
  local _let_51_ = vim.split(lazy_status.updates(), " ")
  local icon = _let_51_[1]
  local count = _let_51_[2]
  _241["icon"] = icon
  _241["content"] = (" " .. count)
  do end (_241)["color"] = "rosewater"
  return nil
end
local function _52_()
  return lazy_status.has_updates()
end
plugin_updates = {empty_space, component({init = _50_, condition = _52_})}
local statuscolumn = {fold, push_right, signs, line_number}
local winbar = {lsp_breadcrumb, quickfix_title, push_right, quickfix_history_status_component, git_blame, file_name_block}
local statusline = {vi_mode, macro_rec, dead_space, push_right, show_cmd, diagnostics_block, show_search, neorg_mode0, git_block, plugin_updates, hl = {bg = "NONE"}}
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
return {"rebelot/heirline.nvim", dependencies = {"nvim-tree/nvim-web-devicons", "catppuccin"}, config = initialize_heirline}
