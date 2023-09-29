-- [nfnl] Compiled from fnl/own/default-plugins.fnl by https://github.com/Olical/nfnl, do not edit.
local default_plugins = {"2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper", "spellfile_plugin", "vimball", "vimballPlugin", "tutor", "rplugin", "syntax", "synmenu", "optwin", "compiler", "bugreport", "ftplugin"}
for _, plugin in pairs(default_plugins) do
  vim.g[("loaded_" .. plugin)] = 1
end
return nil
