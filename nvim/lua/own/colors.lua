-- [nfnl] fnl/own/colors.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local define = _local_1_.define
local M = define("own.colors")
local kanagawa_colors = autoload("kanagawa.colors")
M["get-colors"] = function()
  local _local_2_ = kanagawa_colors.setup()
  local palette = _local_2_.palette
  return {error = palette.autumnRed, warn = palette.autumnYellow, info = palette.autumnGreen, hint = palette.crystalBlue, modeNormal = "fg", modeInsert = palette.lotusGreen, modeVisual = palette.waveBlue1, modeVLine = palette.lotusTeal1, modeVBlock = palette.lotusTeal1, modeCommand = palette.sakuraPink, modeSelect = palette.oniViolet, modeSLine = palette.oniViolet, modeSBlock = palette.oniViolet, modeReplace = palette.sakuraPink, modeShellCmd = palette.waveRed, modeTerm = palette.lotusGreen, modeNormalTerm = "fg", git = palette.oniViolet}
end
return M
