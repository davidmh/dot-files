-- [nfnl] Compiled from fnl/own/highlights.fnl by https://github.com/Olical/nfnl, do not edit.
local function custom_highlights(color)
  return {Comment = {style = {"italic", "bold"}}, Pmenu = {bg = color.crust}, WinSeparator = {fg = color.overlay0, bg = "none"}, FloatBorder = {link = "NormalFloat"}, TreesitterContext = {link = "Normal"}, NotifyINFOIcon = {fg = color.mauve}, NotifyINFOTitle = {fg = color.mauve}, NotifyINFOBorder = {fg = color.mantle, bg = color.mantle}, NotifyBackground = {bg = color.mantle}, NotifyINFOBody = {bg = color.mantle}, NotifyWARNBody = {bg = color.mantle}, NotifyERRORBody = {bg = color.mantle}, NotifyDEBUGBody = {bg = color.mantle}, NotifyTRACEBody = {bg = color.mantle}, NotifyWARNBorder = {fg = color.mantle, bg = color.mantle}, NotifyERRORBorder = {fg = color.mantle, bg = color.mantle}, NotifyDEBUGBorder = {fg = color.mantle, bg = color.mantle}, NotifyTRACEBorder = {fg = color.mantle, bg = color.mantle}, CmpItemKindSnippet = {fg = color.crust, bg = color.mauve}, CmpItemKindKeyword = {fg = color.crust, bg = color.red}, CmpItemKindText = {fg = color.crust, bg = color.teal}, CmpItemKindMethod = {fg = color.crust, bg = color.blue}, CmpItemKindConstructor = {fg = color.crust, bg = color.blue}, CmpItemKindFunction = {fg = color.crust, bg = color.blue}, CmpItemKindFolder = {fg = color.crust, bg = color.blue}, CmpItemKindModule = {fg = color.crust, bg = color.blue}, CmpItemKindConstant = {fg = color.crust, bg = color.peach}, CmpItemKindField = {fg = color.crust, bg = color.green}, CmpItemKindProperty = {fg = color.crust, bg = color.green}, CmpItemKindEnum = {fg = color.crust, bg = color.green}, CmpItemKindUnit = {fg = color.crust, bg = color.green}, CmpItemKindClass = {fg = color.crust, bg = color.yellow}, CmpItemKindVariable = {fg = color.crust, bg = color.flamingo}, CmpItemKindFile = {fg = color.crust, bg = color.blue}, CmpItemKindInterface = {fg = color.crust, bg = color.yellow}, CmpItemKindColor = {fg = color.crust, bg = color.red}, CmpItemKindReference = {fg = color.crust, bg = color.red}, CmpItemKindEnumMember = {fg = color.crust, bg = color.red}, CmpItemKindStruct = {fg = color.crust, bg = color.blue}, CmpItemKindValue = {fg = color.crust, bg = color.peach}, CmpItemKindEvent = {fg = color.crust, bg = color.blue}, CmpItemKindOperator = {fg = color.crust, bg = color.blue}, CmpItemKindTypeParameter = {fg = color.crust, bg = color.blue}, NavicIconsFile = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsModule = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsNamespace = {bg = "NONE", fg = color.green, bold = true}, NavicIconsPackage = {bg = "NONE", fg = color.maroon, bold = true}, NavicIconsClass = {bg = "NONE", fg = color.peach, bold = true}, NavicIconsMethod = {bg = "NONE", fg = color.lavender, bold = true}, NavicIconsProperty = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsField = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsConstructor = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsEnum = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsInterface = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsFunction = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsVariable = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsConstant = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsString = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsNumber = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsBoolean = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsArray = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsObject = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsKey = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsNull = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsEnumMember = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsStruct = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsEvent = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsOperator = {bg = "NONE", fg = color.blue, bold = true}, NavicIconsTypeParameter = {bg = "NONE", fg = color.blue, bold = true}, NavicText = {fg = color.text, bg = "NONE", bold = true}, NavicSeparator = {fg = color.blue, bg = "NONE", bold = true}}
end
return {["custom-highlights"] = custom_highlights}
