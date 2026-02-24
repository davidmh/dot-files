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
M["get-highlights"] = function(_3_)
  local theme = _3_.theme
  local syn = theme.syn
  local bg = theme.ui.bg_dim
  local fg = theme.ui.bg
  local cmp_fg = theme.ui.fg_reverse
  return {WinSeparator = {fg = theme.ui.bg_search}, StatusLine = {bg = "none"}, SnacksNotifierInfo = {bg = bg}, SnacksNotifierWarn = {bg = bg}, SnacksNotifierError = {bg = bg}, SnacksNotifierDebug = {bg = bg}, SnacksNotifierTrace = {bg = bg}, SnacksNotifierBorderInfo = {fg = fg, bg = bg}, SnacksNotifierBorderWarn = {fg = fg, bg = bg}, SnacksNotifierBorderError = {fg = fg, bg = bg}, SnacksNotifierBorderDebug = {fg = fg, bg = bg}, SnacksNotifierBorderTrace = {fg = fg, bg = bg}, CmpItemKindSnippetIcon = {fg = cmp_fg, bg = syn.statement}, CmpItemKindKeywordIcon = {fg = cmp_fg, bg = syn.keyword}, CmpItemKindTextIcon = {fg = cmp_fg, bg = syn.comment}, CmpItemKindMethodIcon = {fg = cmp_fg, bg = syn.fun}, CmpItemKindConstructorIcon = {fg = cmp_fg, bg = syn.statement}, CmpItemKindFunctionIcon = {fg = cmp_fg, bg = syn.fun}, CmpItemKindFolderIcon = {fg = cmp_fg, bg = syn.punct}, CmpItemKindModuleIcon = {fg = cmp_fg, bg = syn.type}, CmpItemKindConstantIcon = {fg = cmp_fg, bg = syn.constant}, CmpItemKindFieldIcon = {fg = cmp_fg, bg = syn.identifier}, CmpItemKindPropertyIcon = {fg = cmp_fg, bg = syn.identifier}, CmpItemKindEnumIcon = {fg = cmp_fg, bg = syn.constant}, CmpItemKindUnitIcon = {fg = cmp_fg, bg = syn.string}, CmpItemKindClassIcon = {fg = cmp_fg, bg = syn.operator}, CmpItemKindVariableIcon = {fg = cmp_fg, bg = syn.keyword}, CmpItemKindFileIcon = {fg = cmp_fg, bg = syn.punct}, CmpItemKindInterfaceIcon = {fg = cmp_fg, bg = syn.identifier}, CmpItemKindColorIcon = {fg = cmp_fg, bg = syn.special2}, CmpItemKindReferenceIcon = {fg = cmp_fg, bg = syn.special2}, CmpItemKindEnumMemberIcon = {fg = cmp_fg, bg = syn.special2}, CmpItemKindStructIcon = {fg = cmp_fg, bg = syn.parameter}, CmpItemKindValueIcon = {fg = cmp_fg, bg = syn.number}, CmpItemKindEventIcon = {fg = cmp_fg, bg = syn.parameter}, CmpItemKindOperatorIcon = {fg = cmp_fg, bg = syn.parameter}, CmpItemKindTypeParameterIcon = {fg = cmp_fg, bg = syn.parameter}}
end
return M
