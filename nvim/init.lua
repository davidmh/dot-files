local execute = vim.api.nvim_command
local fn = vim.fn
local fmt = string.format

local pack_path = fn.stdpath("data") .. "/site/pack"

--- Ensures a given github.com/USER/REPO is cloned in the pack/packer/start directory.
--- @param user string
--- @param repo string
local function ensure(user, repo)
  local install_path = fmt("%s/packer/start/%s", pack_path, repo, repo)
  if fn.empty(fn.glob(install_path)) > 0 then
    execute(fmt("!git clone https://github.com/%s/%s %s", user, repo, install_path))
    execute(fmt("packadd %s", repo))
  end
end

-- Speed up lua requires
ensure("lewis6991", "impatient.nvim")
require("impatient")

-- Packer as a plugin manager
ensure("wbthomason", "packer.nvim")

-- Aniseed compiles Fennel to Lua and loads it automatically.
ensure("Olical", "aniseed")

-- Enable Aniseed's automatic compilation and loading of Fennel source code.
vim.g["aniseed#env"] = {module = "own.init"} -- fnl/own/init.fnl
