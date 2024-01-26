-- [nfnl] Compiled from fnl/plugins/status-line.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = require("own.helpers")
local sanitize_path = _local_2_["sanitize-path"]
local heirline = autoload("heirline")
local conditions = autoload("heirline.conditions")
local core = autoload("nfnl.core")
local palettes = autoload("catppuccin.palettes")
local navic = autoload("nvim-navic")
local nvim_web_devicons = autoload("nvim-web-devicons")
local config = autoload("own.config")
local neorg_mode = autoload("neorg.modules.core.mode.module")
local chrome_accent = "surface2"
local solid_background = {hl = {fg = "fg", bg = chrome_accent}}
local pill
local function _3_()
  return {bg = "none", fg = "surface1"}
end
local function _4_(_241)
  return (_241.icon .. " ")
end
local function _5_(_241)
  return {fg = _241.color, bg = "surface1"}
end
local function _6_(_241)
  return _241.content
end
local function _7_(_241)
  return not core["empty?"](vim.trim(_241.content))
end
local function _8_(_241)
  return {fg = (_241["content-bg-color"] or chrome_accent), bg = "none"}
end
pill = {{provider = "\238\130\182", hl = _3_}, {provider = _4_, hl = _5_}, {provider = _6_, condition = _7_, hl = {fg = "fg", bg = chrome_accent}}, {provider = "\238\130\180", hl = _8_}}
local function container(components)
  local solid_background0 = {hl = {fg = "fg", bg = chrome_accent}}
  return {{provider = "\238\130\182", hl = {fg = chrome_accent, bg = "none"}}, core.merge(solid_background0, components), {provider = "\238\130\180", hl = {fg = chrome_accent, bg = "none"}}}
end
local mode_colors = {n = "fg", i = "green", v = "blue", V = "cyan", ["\22"] = "cyan", c = "orange", s = "purple", S = "purple", ["\19"] = "purple", R = "orange", r = "orange", ["!"] = "red", t = "green"}
local mode_label = {n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK", R = "REPLACE", r = "REPLACE", ["!"] = "SHELL", t = "TERMINAL", nt = "T-NORMAL"}
local not_a_term
local function _9_()
  return ((vim.o.buftype ~= "terminal") and (vim.o.filetype ~= "toggleterm"))
end
not_a_term = _9_
local vi_mode
local function _10_(_241)
  _241["mode"] = vim.fn.mode(1)
  return nil
end
local function _11_()
  return (vim.o.filetype ~= "starter")
end
local function _12_(_241)
  return (core.get(mode_label, _241.mode, _241.mode) .. " ")
end
local function _13_(_241)
  return {fg = mode_colors[_241.mode], bold = true}
end
vi_mode = {init = _10_, condition = _11_, provider = _12_, hl = _13_, update = {"ModeChanged", "ColorScheme"}}
local macro_rec
local function _14_()
  return ((vim.fn.reg_recording() ~= "") and (vim.o.cmdheight == 0))
end
local function _15_(_241)
  local macro_key = vim.fn.reg_recording()
  do end (_241)["icon"] = "macro"
  _241["color"] = "coral"
  _241["content"] = (" " .. macro_key)
  return nil
end
macro_rec = {pill, condition = _14_, init = _15_, update = {"RecordingEnter", "RecordingLeave", "ColorScheme"}}
local show_cmd
local function _16_()
  return (vim.o.cmdheight == 0)
end
local function _17_()
  vim.opt.showcmdloc = "statusline"
  return nil
end
show_cmd = {condition = _16_, init = _17_, provider = "%3.5(%S%)"}
local show_search
local function _18_()
  local function _19_()
    local _20_ = vim.fn.searchcount()
    if (nil ~= _20_) then
      local _21_ = (_20_).total
      if (nil ~= _21_) then
        return (_21_ > 0)
      else
        return _21_
      end
    else
      return _20_
    end
  end
  return ((vim.o.cmdheight == 0) and (vim.v.hlsearch ~= 0) and _19_())
end
local function _24_()
  local _let_25_ = vim.fn.searchcount()
  local current = _let_25_["current"]
  local total = _let_25_["total"]
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
show_search = {condition = _18_, provider = _24_}
local neorg_mode0
local function _27_()
  return ((vim.bo.filetype == "norg") and (neorg_mode.public.get_mode() ~= "norg"))
end
local function _28_(_241)
  _241["icon"] = "\238\152\179"
  _241["color"] = "purple"
  _241["content"] = (" " .. neorg_mode.public.get_mode())
  return nil
end
neorg_mode0 = {pill, condition = _27_, init = _28_}
local function file_name()
  local file_name0 = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local function _30_()
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
  return (" " .. _30_())
end
local modified_3f
local function _31_()
  return vim.bo.modified
end
modified_3f = {condition = _31_, provider = " [+]", hl = {fg = "green"}}
local read_only_3f
local function _32_()
  return (not vim.bo.modifiable or vim.bo.readonly)
end
read_only_3f = {condition = _32_, provider = " \239\128\163", hl = {fg = "orange"}}
local file
local function _33_(_241)
  local name = file_name()
  local ext = vim.fn.fnamemodify(name, ":e")
  local icon, color = nvim_web_devicons.get_icon_color(name, ext, {default = true})
  do end (_241)["icon"] = icon
  _241["color"] = color
  _241["content"] = name
  return nil
end
file = {pill, init = _33_}
local file_flags = {modified_3f, read_only_3f}
local file_name_block
local function _34_()
  return ((vim.o.filetype ~= "fugitiveblame") and (vim.o.filetype ~= "qf") and not_a_term())
end
local function _35_(_241)
  _241["file-name"] = vim.api.nvim_buf_get_name(0)
  return nil
end
file_name_block = {file, file_flags, condition = _34_, init = _35_}
local function get_quickfix_title()
  return (vim.fn.getqflist({title = 1})).title
end
local function show_quickfix_title()
  return ((vim.o.filetype == "qf") and ("" ~= get_quickfix_title()))
end
local quickfix_title
local function _36_(_241)
  _241["icon"] = "\239\145\145"
  _241["color"] = "lavender"
  _241["content"] = (" " .. get_quickfix_title())
  return nil
end
quickfix_title = {pill, condition = show_quickfix_title, hl = {fg = "crust"}, init = _36_}
local lsp_breadcrumb
local function _37_()
  return navic.get_location({highlight = true})
end
local function _38_()
  return (navic.is_available() and (#navic.get_location() > 0))
end
lsp_breadcrumb = {container({provider = _37_}), condition = _38_, update = {"CursorMoved", "ColorScheme"}, hl = {fg = "fg"}}
local dead_space = {provider = "             "}
local push_right = {provider = "%="}
local function diagnostic(severity_code, color)
  local function _39_(_241)
    return (" " .. config.icons[severity_code] .. " " .. (_241)[severity_code])
  end
  local function _40_(_241)
    return ((_241)[severity_code] > 0)
  end
  return {provider = _39_, condition = _40_, hl = {fg = color}}
end
local function diagnostic_count(severity_code)
  return #vim.diagnostic.get(0, {severity = vim.diagnostic.severity[severity_code]})
end
local diagnostics_block
local function _41_()
  return conditions.has_diagnostics()
end
local function _42_(self)
  self["ERROR"] = diagnostic_count("ERROR")
  do end (self)["WARN"] = diagnostic_count("WARN")
  do end (self)["INFO"] = diagnostic_count("INFO")
  do end (self)["HINT"] = diagnostic_count("HINT")
  return nil
end
diagnostics_block = {diagnostic("ERROR", "red"), diagnostic("WARN", "yellow"), diagnostic("INFO", "fg"), diagnostic("HINT", "green"), {provider = " "}, conditon = _41_, init = _42_, update = {"DiagnosticChanged", "BufEnter", "ColorScheme"}}
local git_block
local function _43_()
  return conditions.is_git_repo()
end
local function _44_(_241)
  local _local_45_ = vim.b.gitsigns_status_dict
  local head = _local_45_["head"]
  local status = vim.trim((vim.b.gitsigns_status or ""))
  do end (_241)["icon"] = "\239\144\152"
  _241["color"] = "rosewater"
  _241["content"] = (" " .. head .. " " .. status)
  return nil
end
git_block = {{provider = " "}, {pill, condition = _43_, init = _44_, hl = {bg = chrome_accent, bold = true}}}
local git_blame
local function _46_(_241)
  _241["icon"] = "\238\156\130"
  _241["color"] = "red"
  _241["content"] = "git blame"
  return nil
end
local function _47_()
  return (vim.o.filetype == "fugitiveblame")
end
git_blame = {pill, init = _46_, condition = _47_, hl = {bold = true}}
local term_title
local function _48_(_241)
  return sanitize_path(_241.path)
end
local function _49_(_241)
  return sanitize_path(_241.command, 3)
end
local function _50_()
  return (nil ~= vim.b.term_title)
end
local function _51_(_241)
  local title = string.gsub(string.gsub(vim.b.term_title, "term://", ""), ";#toggleterm#%d*", "")
  local parts = vim.split(title, "//%d*:")
  do end (_241)["path"] = core.first(parts)
  do end (_241)["command"] = core.last(parts)
  return nil
end
term_title = {container({{provider = _48_}, {provider = " \238\170\182 "}, {provider = _49_}}), condition = _50_, init = _51_}
local line_number
local function _52_()
  return vim.o.number
end
line_number = {provider = " %2{&nu ? (&rnu && v:relnum ? v:relnum : v:lnum) : ''} ", condition = _52_}
local fold
local function _53_()
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
fold = {provider = _53_}
local signs = {provider = "%s"}
local statuscolumn = {fold, push_right, signs, line_number}
local winbar = {term_title, lsp_breadcrumb, quickfix_title, push_right, git_blame, file_name_block}
local statusline = {vi_mode, macro_rec, dead_space, push_right, show_cmd, diagnostics_block, show_search, neorg_mode0, git_block, hl = {bg = "NONE"}}
local disabled_winbar = {buftype = {"nofile", "prompt"}, filetype = {"^git.*"}}
local function initialize_heirline()
  vim.o.showmode = false
  local opts
  local function _56_(_241)
    return conditions.buffer_matches(disabled_winbar, _241.buf)
  end
  opts = {colors = palettes.get_palette(), disable_winbar_cb = _56_}
  return heirline.setup({winbar = winbar, statuscolumn = statuscolumn, statusline = statusline, opts = opts})
end
do
  local group = vim.api.nvim_create_augroup("update-heirline", {clear = true})
  vim.api.nvim_create_autocmd("ColorScheme", {pattern = "*", callback = initialize_heirline, group = group})
end
return {"rebelot/heirline.nvim", dependencies = {"nvim-tree/nvim-web-devicons", "catppuccin"}, config = initialize_heirline}
