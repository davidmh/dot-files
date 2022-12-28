local execute = vim.api.nvim_command
local fn = vim.fn
local fmt = string.format

local pack_path = fn.stdpath("data") .. "/lazy"

--- Ensures a given github.com/USER/REPO is cloned in the lazy directory.
--- @param user string
--- @param repo string
--- @param cb function|nil
local function ensure(user, repo, cb)
  local install_path = fmt("%s/%s", pack_path, repo, repo)
  if fn.empty(fn.glob(install_path)) > 0 then
    execute(fmt(
      "!git clone --filter=blob:none --single-branch https://github.com/%s/%s %s",
      user,
      repo,
      install_path
    ))
  end
  vim.opt.runtimepath:prepend(install_path)
  if cb then
    cb()
  end
end

-- Speed up lua requires
-- ensure("lewis6991", "impatient.nvim", function()
--   require("impatient")
-- end)

-- Lazy.nvim as a plugin manager
ensure("folke", "lazy.nvim")

-- Aniseed compiles Fennel to Lua and loads it automatically.
ensure("Olical", "aniseed")

-- Enable Aniseed's automatic compilation and loading of Fennel source code.
vim.g["aniseed#env"] = {module = "own.init"} -- fnl/own/init.fnl
