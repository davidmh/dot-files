-- [nfnl] fnl/own/default-plugins.fnl
local default_plugins = {"2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "matchit", "tar", "tarPlugin", "rrhelper", "spellfile_plugin", "vimball", "vimballPlugin", "tutor", "rplugin", "syntax", "synmenu", "optwin", "compiler", "bugreport", "ftplugin"}
for _, plugin in pairs(default_plugins) do
  vim.g[("loaded_" .. plugin)] = 1
end
return nil
