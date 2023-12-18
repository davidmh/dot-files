-- [nfnl] Compiled from fnl/own/plugin/mason.fnl by https://github.com/Olical/nfnl, do not edit.
local config = require("own.config")
local mason = require("mason")
local mason_registry = require("mason-registry")
mason.setup({ui = {border = config.border}})
local function on_install(pkg)
  local function _1_()
    return vim.notify((pkg.name .. " installed"), vim.log.levels.INFO, {title = "mason.nvim"})
  end
  return vim.defer_fn(_1_, 100)
end
mason_registry:on("package:install:success", on_install)
local ensure_installed = {"cspell", "luacheck", "selene"}
local function _2_()
  for _, name in ipairs(ensure_installed) do
    local pkg = mason_registry.get_package(name)
    if not pkg:is_installed() then
      pkg:install()
    else
    end
  end
  return nil
end
return vim.defer_fn(_2_, 100)
