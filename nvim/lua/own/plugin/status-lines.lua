-- [nfnl] Compiled from fnl/own/plugin/status-lines.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local heirline = require("heirline")
local conditions = autoload("heirline.conditions")
local core = autoload("nfnl.core")
local palettes = autoload("catppuccin.palettes")
local navic = autoload("nvim-navic")
local nvim_web_devicons = autoload("nvim-web-devicons")
local config = autoload("own.config")
local chrome_accent = "surface2"
local function container(components)
  local solid_background = {hl = {fg = "fg", bg = chrome_accent}}
  return {{provider = "\238\130\182", hl = {fg = chrome_accent, bg = "none"}}, core.merge(solid_background, components), {provider = "\238\130\180", hl = {fg = chrome_accent, bg = "none"}}}
end
local mode_colors = {n = "fg", i = "green", v = "blue", V = "cyan", ["\22"] = "cyan", c = "orange", s = "purple", S = "purple", ["\19"] = "purple", R = "orange", r = "orange", ["!"] = "red", t = "green"}
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
  return {fg = mode_colors[_241.mode], bold = true}
end
vi_mode = {init = _3_, condition = not_a_term, provider = "\238\174\180 ", hl = _4_, update = {"ModeChanged", "ColorScheme"}}
local macro_rec
local function _5_()
  return ((vim.fn.reg_recording() ~= "") and (vim.o.cmdheight == 0))
end
local function _6_()
  return (" [ \239\165\138 -> " .. vim.fn.reg_recording() .. " ] ")
end
macro_rec = {condition = _5_, update = {"RecordingEnter", "RecordingLeave", "ColorScheme"}, provider = _6_, hl = {fg = "red", bold = true}}
local show_cmd
local function _7_()
  return (vim.o.cmdheight == 0)
end
local function _8_()
  vim.opt.showcmdloc = "statusline"
  return nil
end
show_cmd = {condition = _7_, init = _8_, provider = "%3.5(%S%)"}
local show_search
local function _9_()
  local function _10_()
    local _11_ = vim.fn.searchcount()
    if (nil ~= _11_) then
      local _12_ = (_11_).total
      if (nil ~= _12_) then
        return (_12_ > 0)
      else
        return _12_
      end
    else
      return _11_
    end
  end
  return ((vim.o.cmdheight == 0) and (vim.v.hlsearch ~= 0) and _10_())
end
local function _15_()
  local _let_16_ = vim.fn.searchcount()
  local current = _let_16_["current"]
  local total = _let_16_["total"]
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
show_search = {condition = _9_, provider = _15_}
local function sanitize_path(path, size)
  return vim.fn.pathshorten(string.gsub(string.gsub(path, vim.env.HOME, "~"), vim.env.REMIX_HOME, "remix"), (size or 2))
end
local file_icon
local function _18_(_241)
  local file_name = _241["file-name"]
  local ext = vim.fn.fnamemodify(file_name, ":e")
  local icon, color = nvim_web_devicons.get_icon_color(file_name, ext, {default = true})
  do end (_241)["icon"] = icon
  _241["color"] = color
  return nil
end
local function _19_(_241)
  return (_241.icon and (_241.icon .. " "))
end
local function _20_(_241)
  return {fg = _241.color}
end
file_icon = {init = _18_, provider = _19_, hl = _20_}
local file_name
local function _21_()
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
local function _24_()
  if vim.bo.modified then
    return {fg = "fg", bold = true, force = true}
  else
    return nil
  end
end
file_name = {provider = _21_, hl = _24_}
local modified_3f
local function _26_()
  return vim.bo.modified
end
modified_3f = {condition = _26_, provider = " [+]", hl = {fg = "green"}}
local read_only_3f
local function _27_()
  return (not vim.bo.modifiable or vim.bo.readonly)
end
read_only_3f = {condition = _27_, provider = " \239\128\163", hl = {fg = "orange"}}
local file_flags = {modified_3f, read_only_3f}
local file_name_block
local function _28_(_241)
  _241["file-name"] = vim.api.nvim_buf_get_name(0)
  return nil
end
local function _29_()
  return ((vim.o.filetype ~= "fugitiveblame") and (vim.o.filetype ~= "qf") and not_a_term())
end
file_name_block = {container({file_icon, file_name, file_flags, init = _28_}), condition = _29_}
local quickfix_title
local function _30_()
  return ((vim.fn.getqflist({title = 1})).title or " - ")
end
local function _31_()
  return (vim.o.filetype == "qf")
end
quickfix_title = {container({provider = _30_}), condition = _31_}
local lsp_breadcrumb
local function _32_()
  return navic.get_location({highlight = true})
end
local function _33_()
  return (navic.is_available() and (#navic.get_location() > 0))
end
lsp_breadcrumb = {container({provider = _32_}), condition = _33_, update = {"CursorMoved", "ColorScheme"}, hl = {fg = "fg"}}
local dead_space = {provider = "             "}
local push_right = {provider = "%="}
local function diagnostic(severity_code, color)
  local function _34_(_241)
    return (" " .. config.icons[severity_code] .. " " .. (_241)[severity_code])
  end
  local function _35_(_241)
    return ((_241)[severity_code] > 0)
  end
  return {provider = _34_, condition = _35_, hl = {fg = color}}
end
local function diagnostic_count(severity_code)
  return #vim.diagnostic.get(0, {severity = vim.diagnostic.severity[severity_code]})
end
local diagnostics_block
local function _36_()
  return conditions.has_diagnostics()
end
local function _37_(self)
  self["ERROR"] = diagnostic_count("ERROR")
  do end (self)["WARN"] = diagnostic_count("WARN")
  do end (self)["INFO"] = diagnostic_count("INFO")
  do end (self)["HINT"] = diagnostic_count("HINT")
  return nil
end
diagnostics_block = {diagnostic("ERROR", "red"), diagnostic("WARN", "yellow"), diagnostic("INFO", "fg"), diagnostic("HINT", "green"), {provider = " "}, conditon = _36_, init = _37_, update = {"DiagnosticChanged", "BufEnter", "ColorScheme"}}
local function has_git_diff(kind)
  local function _38_(_241)
    return (core["get-in"](_241, {"git", kind}, 0) > 0)
  end
  return _38_
end
local git_block
local function _39_(_241)
  return ("\239\144\152 " .. _241.git.head)
end
local function _40_(_241)
  return (" +" .. _241.git.added)
end
local function _41_(_241)
  return (" \194\177" .. _241.git.changed)
end
local function _42_(_241)
  return (" \226\136\146" .. _241.git.removed)
end
local function _43_(_241)
  _241["git"] = vim.b.gitsigns_status_dict
  return nil
end
git_block = {container({{provider = _39_}, {provider = _40_, condition = has_git_diff("added")}, {provider = _41_, condition = has_git_diff("changed")}, {provider = _42_, condition = has_git_diff("removed")}}), condition = conditions.is_git_repo, init = _43_, hl = {bg = chrome_accent}}
local git_blame
local function _44_()
  return (vim.o.filetype == "fugitiveblame")
end
git_blame = {container({{provider = "git blame", hl = {bold = true}}}), condition = _44_}
local term_title
local function _45_(_241)
  return sanitize_path(_241.path)
end
local function _46_(_241)
  return sanitize_path(_241.command, 3)
end
local function _47_()
  return (nil ~= vim.b.term_title)
end
local function _48_(_241)
  local title = string.gsub(string.gsub(vim.b.term_title, "term://", ""), ";#toggleterm#%d*", "")
  local parts = vim.split(title, "//%d*:")
  do end (_241)["path"] = core.first(parts)
  do end (_241)["command"] = core.last(parts)
  return nil
end
term_title = {{container({{provider = _45_}, {provider = " \238\170\182 "}, {provider = _46_}})}, condition = _47_, init = _48_}
local line_number
local function _49_()
  return vim.o.number
end
line_number = {provider = " %2{&nu ? (&rnu && v:relnum ? v:relnum : v:lnum) : ''} ", condition = _49_}
local fold
local function _50_()
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
fold = {provider = _50_}
local signs = {provider = "%s"}
local statuscolumn = {fold, push_right, line_number, signs}
local winbar = {term_title, lsp_breadcrumb, quickfix_title, push_right, git_blame, file_name_block}
local statusline = {vi_mode, macro_rec, git_block, dead_space, push_right, show_cmd, diagnostics_block, show_search, hl = {bg = "NONE"}}
local disabled_winbar = {buftype = {"nofile", "prompt"}, filetype = {"^git.*", "Trouble"}}
local function initialize_heirline()
  local opts
  local function _53_(_241)
    return conditions.buffer_matches(disabled_winbar, _241.buf)
  end
  opts = {colors = palettes.get_palette(), disable_winbar_cb = _53_}
  return heirline.setup({winbar = winbar, statuscolumn = statuscolumn, statusline = statusline, opts = opts})
end
initialize_heirline()
local group = vim.api.nvim_create_augroup("update-heirline", {clear = true})
vim.api.nvim_create_autocmd("ColorScheme", {pattern = "*", callback = initialize_heirline, group = group})
return nil
