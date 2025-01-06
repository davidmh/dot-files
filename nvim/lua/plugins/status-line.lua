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
local push_right = {provider = "%="}
local function diagnostic(severity_code, color)
  local function _9_(_241)
    return (" " .. config.icons[severity_code] .. " " .. _241[severity_code])
  end
  local function _10_(_241)
    return (_241[severity_code] > 0)
  end
  return {provider = _9_, condition = _10_, hl = {fg = color}, event = "DiagnosticChanged"}
end
local function diagnostic_count(severity_code)
  return #vim.diagnostic.get(0, {severity = vim.diagnostic.severity[severity_code]})
end
local diagnostics_block
local function _11_()
  return conditions.has_diagnostics()
end
local function _12_(self)
  self["ERROR"] = diagnostic_count("ERROR")
  self["WARN"] = diagnostic_count("WARN")
  self["INFO"] = diagnostic_count("INFO")
  self["HINT"] = diagnostic_count("HINT")
  return nil
end
diagnostics_block = {diagnostic("ERROR", "red"), diagnostic("WARN", "yellow"), diagnostic("INFO", "fg"), diagnostic("HINT", "green"), empty_space, conditon = _11_, init = _12_, update = {"DiagnosticChanged", "BufEnter", "ColorScheme"}}
local git_block
local function _13_()
  return conditions.is_git_repo()
end
local function _14_(_241)
  local head = vim.b.gitsigns_status_dict["head"]
  local root = vim.b.gitsigns_status_dict["root"]
  local cwd_relative_path = string.gsub(string.gsub(vim.fn.getcwd(), vim.fn.fnamemodify(root, ":h"), ""), "^/", "")
  local status = vim.trim((vim.b.gitsigns_status or ""))
  _241["icon"] = "\239\144\152"
  _241["color"] = "rosewater"
  _241["content"] = table.concat({(" [" .. cwd_relative_path .. "]"), head, status}, " ")
  return nil
end
git_block = component({condition = _13_, init = _14_, hl = {bold = true}})
local plugin_updates
local function _15_(_241)
  local _let_16_ = vim.split(lazy_status.updates(), " ")
  local icon = _let_16_[1]
  local count = _let_16_[2]
  _241["icon"] = (" " .. icon)
  _241["content"] = (" " .. count)
  _241["color"] = "rosewater"
  return nil
end
local function _17_()
  return lazy_status.has_updates()
end
plugin_updates = {component({init = _15_, condition = _17_})}
local statusline = {vi_mode, push_right, diagnostics_block, git_block, plugin_updates, hl = {bg = "NONE"}}
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
