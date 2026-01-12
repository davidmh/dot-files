-- [nfnl] fnl/own/config.fnl
local severity = vim.diagnostic.severity
local icons = {ERROR = "\238\170\135", WARN = "\238\169\172", INFO = "\238\169\180", HINT = "\238\173\130"}
icons[severity.ERROR] = icons.ERROR
icons[severity.WARN] = icons.WARN
icons[severity.HINT] = icons.HINT
icons[severity.INFO] = icons.INFO
return {icons = icons, ["navic-icons"] = {File = "\238\169\187 ", Module = "\238\170\139 ", Namespace = "\238\170\139 ", Package = "\238\172\169 ", Class = "\238\173\155 ", Method = "\238\170\140 ", Property = "\238\173\165 ", Field = "\238\173\159 ", Constructor = "\238\170\140 ", Enum = "\238\170\149 ", Interface = "\238\173\161 ", Function = "\238\170\140 ", Variable = "\238\170\136 ", Constant = "\238\173\157 ", String = "\238\174\141 ", Number = "\238\170\144 ", Boolean = "\238\170\143 ", Array = "\238\170\138 ", Object = "\238\170\139 ", Key = "\238\170\147 ", Null = "\238\170\143 ", EnumMember = "\238\173\158 ", Struct = "\238\170\145 ", Event = "\238\170\134 ", Operator = "\238\173\164 ", TypeParameter = "\238\170\146 "}, separator = "\226\150\140", border = "rounded"}
