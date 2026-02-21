-- [nfnl] fnl/plugins/status-line.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local heirline = autoload("heirline")
local conditions = autoload("heirline.conditions")
local config = autoload("own.config")
local mode = autoload("own.mode")
local empty_space = {provider = " "}
local function component(data)
  vim.validate("init", data.init, "function")
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
local vi_mode
local function _5_()
  return (" " .. mode["get-label"]() .. " ")
end
local function _6_()
  return {fg = mode["get-color"](), bold = true}
end
vi_mode = {provider = _5_, hl = _6_, update = {"ModeChanged", "ColorScheme"}}
local push_right = {provider = "%="}
local function diagnostic(severity_code, color)
  local function _7_(_241)
    return (" " .. config.icons[severity_code] .. " " .. _241[severity_code])
  end
  local function _8_(_241)
    return (_241[severity_code] > 0)
  end
  return {provider = _7_, condition = _8_, hl = {fg = color}, event = "DiagnosticChanged"}
end
local function diagnostic_count(severity_code)
  return #vim.diagnostic.get(0, {severity = vim.diagnostic.severity[severity_code]})
end
local diagnostics_block
local function _9_()
  return conditions.has_diagnostics()
end
local function _10_(_241)
  _241.ERROR = diagnostic_count("ERROR")
  _241.WARN = diagnostic_count("WARN")
  _241.INFO = diagnostic_count("INFO")
  _241.HINT = diagnostic_count("HINT")
  return nil
end
diagnostics_block = {diagnostic("ERROR", "autumnRed"), diagnostic("WARN", "autumnYellow"), diagnostic("INFO", "autumnGreen"), diagnostic("HINT", "crystalBlue"), empty_space, condition = _9_, init = _10_, update = {"DiagnosticChanged", "BufEnter", "ColorScheme"}}
local git_block
local function _11_()
  return conditions.is_git_repo()
end
local function _12_(_241)
  local head = vim.b.gitsigns_status_dict.head
  local root = vim.b.gitsigns_status_dict.root
  local cwd_relative_path = string.gsub(string.gsub(vim.fn.getcwd(), vim.fn.fnamemodify(root, ":h"), ""), "^/", "")
  local status = vim.trim((vim.b.gitsigns_status or ""))
  _241.icon = "\239\144\152"
  _241.color = "oniViolet"
  _241.content = table.concat({(" [" .. cwd_relative_path .. "]"), head, status}, " ")
  return nil
end
git_block = component({condition = _11_, init = _12_, hl = {bold = true}})
local statusline = {vi_mode, push_right, diagnostics_block, git_block, empty_space}
local function initialize_heirline()
  vim.o.showmode = false
  local opts = {colors = require("kanagawa.colors"):setup().palette}
  return heirline.setup({statusline = statusline, opts = opts})
end
--[[ (initialize-heirline) (augroup "update-heirline" ["ColorScheme" {:callback initialize-heirline :pattern "*"}]) ]]
return {"rebelot/heirline.nvim", dependencies = {"nvim-tree/nvim-web-devicons"}, event = "VeryLazy", config = initialize_heirline}
