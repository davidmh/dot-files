-- [nfnl] Compiled from fnl/own/lazy.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local config = autoload("own.config")
local core = autoload("nfnl.core")
local lazy = autoload("lazy")
local function load_module(name)
  local ok_3f, val_or_err = pcall(require, ("own.plugin." .. name))
  if not ok_3f then
    return print(("Plugin config error: " .. val_or_err))
  else
    return nil
  end
end
local function _3_(...)
  local pkgs = {...}
  local plugins = {}
  for i = 1, core.count(pkgs), 2 do
    local name = pkgs[i]
    local opts = pkgs[(i + 1)]
    local mod = opts.mod
    local plugin = core.merge({name}, opts)
    if mod then
      plugin["mod"] = nil
      local function _4_()
        return load_module(mod)
      end
      plugin["config"] = _4_
    else
    end
    if opts.dir then
      table.remove(plugin, 1)
    else
    end
    table.insert(plugins, plugin)
  end
  return lazy.setup(plugins, {install = {colorscheme = {"catppuccin"}}, dev = {path = (vim.env.HOME .. "/Projects"), fallback = true}, ui = {border = config.border, icons = {lazy = "\239\166\177"}}})
end
return _3_
