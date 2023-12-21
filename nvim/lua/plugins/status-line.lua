-- [nfnl] Compiled from fnl/plugins/status-line.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local heirline = autoload("heirline")
local conditions = autoload("heirline.conditions")
local core = autoload("nfnl.core")
local palettes = autoload("catppuccin.palettes")
local navic = autoload("nvim-navic")
local nvim_web_devicons = autoload("nvim-web-devicons")
local config = autoload("own.config")
local neorg_mode = autoload("neorg.modules.core.mode.module")
local chrome_accent = "surface2"
local function container(components)
  local solid_background = {hl = {fg = "fg", bg = chrome_accent}}
  return {{provider = "\238\130\182", hl = {fg = chrome_accent, bg = "none"}}, core.merge(solid_background, components), {provider = "\238\130\180", hl = {fg = chrome_accent, bg = "none"}}}
end
local mode_colors = {n = "fg", i = "green", v = "blue", V = "cyan", ["\22"] = "cyan", c = "orange", s = "purple", S = "purple", ["\19"] = "purple", R = "orange", r = "orange", ["!"] = "red", t = "green"}
local mode_label = {n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK", R = "REPLACE", r = "REPLACE", ["!"] = "SHELL", t = "TERMINAL", nt = "T-NORMAL"}
local not_a_term
local function _2_()
  return ((vim.o.buftype ~= "terminal") and (vim.o.filetype ~= "toggleterm"))
end
not_a_term = _2_
local vi_mode
local function _3_(_241)
  _241["mode"] = vim.fn.mode(1)
  return nil
end
local function _4_(_241)
  return (core.get(mode_label, _241.mode, _241.mode) .. " ")
end
local function _5_(_241)
  return {fg = mode_colors[_241.mode], bold = true}
end
vi_mode = {init = _3_, provider = _4_, hl = _5_, update = {"ModeChanged", "ColorScheme"}}
local macro_rec
local function _6_()
  return ((vim.fn.reg_recording() ~= "") and (vim.o.cmdheight == 0))
end
local function _7_()
  return ("\239\145\132 \238\170\159 " .. vim.fn.reg_recording() .. " ")
end
macro_rec = {condition = _6_, update = {"RecordingEnter", "RecordingLeave", "ColorScheme"}, provider = _7_, hl = {fg = "red", bold = true}}
local show_cmd
local function _8_()
  return (vim.o.cmdheight == 0)
end
local function _9_()
  vim.opt.showcmdloc = "statusline"
  return nil
end
show_cmd = {condition = _8_, init = _9_, provider = "%3.5(%S%)"}
local show_search
local function _10_()
  local function _11_()
    local _12_ = vim.fn.searchcount()
    if (nil ~= _12_) then
      local _13_ = (_12_).total
      if (nil ~= _13_) then
        return (_13_ > 0)
      else
        return _13_
      end
    else
      return _12_
    end
  end
  return ((vim.o.cmdheight == 0) and (vim.v.hlsearch ~= 0) and _11_())
end
local function _16_()
  local _let_17_ = vim.fn.searchcount()
  local current = _let_17_["current"]
  local total = _let_17_["total"]
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
show_search = {condition = _10_, provider = _16_}
local neorg_mode0
local function _19_()
  return ("\238\152\179 " .. neorg_mode.public.get_mode())
end
local function _20_()
  return ((vim.bo.filetype == "norg") and (neorg_mode.public.get_mode() ~= "norg"))
end
neorg_mode0 = {container({provider = _19_}), condition = _20_}
local function sanitize_path(path, size)
  return vim.fn.pathshorten(string.gsub(string.gsub(path, vim.env.HOME, "~"), vim.env.REMIX_HOME, "remix"), (size or 2))
end
local file_icon
local function _21_(_241)
  local file_name = _241["file-name"]
  local ext = vim.fn.fnamemodify(file_name, ":e")
  local icon, color = nvim_web_devicons.get_icon_color(file_name, ext, {default = true})
  do end (_241)["icon"] = icon
  _241["color"] = color
  return nil
end
local function _22_(_241)
  return (_241.icon and (_241.icon .. " "))
end
local function _23_(_241)
  return {fg = _241.color}
end
file_icon = {init = _21_, provider = _22_, hl = _23_}
local file_name
local function _24_()
  local file_name0 = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
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
local function _27_()
  if vim.bo.modified then
    return {fg = "fg", bold = true, force = true}
  else
    return nil
  end
end
file_name = {provider = _24_, hl = _27_}
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
local file_flags = {modified_3f, read_only_3f}
local file_name_block
local function _31_(_241)
  _241["file-name"] = vim.api.nvim_buf_get_name(0)
  return nil
end
local function _32_()
  return ((vim.o.filetype ~= "fugitiveblame") and (vim.o.filetype ~= "qf") and not_a_term())
end
file_name_block = {container({file_icon, file_name, file_flags, init = _31_}), condition = _32_}
local function get_quickfix_title()
  return (vim.fn.getqflist({title = 1})).title
end
local function show_quickfix_title()
  return ((vim.o.filetype == "qf") and ("" ~= get_quickfix_title()))
end
local quickfix_title
local function _33_()
  return get_quickfix_title()
end
quickfix_title = {container({provider = _33_}), condition = show_quickfix_title}
local lsp_breadcrumb
local function _34_()
  return navic.get_location({highlight = true})
end
local function _35_()
  return (navic.is_available() and (#navic.get_location() > 0))
end
lsp_breadcrumb = {container({provider = _34_}), condition = _35_, update = {"CursorMoved", "ColorScheme"}, hl = {fg = "fg"}}
local dead_space = {provider = "             "}
local push_right = {provider = "%="}
local function diagnostic(severity_code, color)
  local function _36_(_241)
    return (" " .. config.icons[severity_code] .. " " .. (_241)[severity_code])
  end
  local function _37_(_241)
    return ((_241)[severity_code] > 0)
  end
  return {provider = _36_, condition = _37_, hl = {fg = color}}
end
local function diagnostic_count(severity_code)
  return #vim.diagnostic.get(0, {severity = vim.diagnostic.severity[severity_code]})
end
local diagnostics_block
local function _38_()
  return conditions.has_diagnostics()
end
local function _39_(self)
  self["ERROR"] = diagnostic_count("ERROR")
  do end (self)["WARN"] = diagnostic_count("WARN")
  do end (self)["INFO"] = diagnostic_count("INFO")
  do end (self)["HINT"] = diagnostic_count("HINT")
  return nil
end
diagnostics_block = {diagnostic("ERROR", "red"), diagnostic("WARN", "yellow"), diagnostic("INFO", "fg"), diagnostic("HINT", "green"), {provider = " "}, conditon = _38_, init = _39_, update = {"DiagnosticChanged", "BufEnter", "ColorScheme"}}
local function has_git_diff(kind)
  local function _40_(_241)
    return (core["get-in"](_241, {"git", kind}, 0) > 0)
  end
  return _40_
end
local git_block
local function _41_(_241)
  return ("\239\144\152 " .. _241.git.head)
end
local function _42_(_241)
  return (" +" .. _241.git.added)
end
local function _43_(_241)
  return (" \194\177" .. _241.git.changed)
end
local function _44_(_241)
  return (" \226\136\146" .. _241.git.removed)
end
local function _45_()
  return conditions.is_git_repo()
end
local function _46_(_241)
  _241["git"] = vim.b.gitsigns_status_dict
  return nil
end
git_block = {container({{provider = _41_}, {provider = _42_, condition = has_git_diff("added")}, {provider = _43_, condition = has_git_diff("changed")}, {provider = _44_, condition = has_git_diff("removed")}}), condition = _45_, init = _46_, hl = {bg = chrome_accent}}
local git_blame
local function _47_()
  return (vim.o.filetype == "fugitiveblame")
end
git_blame = {container({{provider = "git blame", hl = {bold = true}}}), condition = _47_}
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
term_title = {{container({{provider = _48_}, {provider = " \238\170\182 "}, {provider = _49_}})}, condition = _50_, init = _51_}
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
local statuscolumn = {fold, push_right, line_number, signs}
local winbar = {term_title, lsp_breadcrumb, quickfix_title, push_right, git_blame, file_name_block}
local statusline = {vi_mode, macro_rec, git_block, dead_space, push_right, show_cmd, diagnostics_block, show_search, neorg_mode0, hl = {bg = "NONE"}}
local disabled_winbar = {buftype = {"nofile", "prompt"}, filetype = {"^git.*"}}
local function initialize_heirline()
  vim.o.showmode = false
  nvim_web_devicons.set_icon({norg = {icon = "\238\152\179"}})
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
