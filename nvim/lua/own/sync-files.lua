-- [nfnl] fnl/own/sync-files.fnl
local config = require("nfnl.config")
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local compile = autoload("nfnl.compile")
local catppuccin = autoload("catppuccin")
local nvim_root = vim.fn.expand("~/.config/home-manager/nvim")
local _local_2_ = config["find-and-load"](nvim_root)
local cfg = _local_2_["cfg"]
local nvim_colorscheme_path = vim.fn.expand("~/.config/home-manager/nvim/fnl/plugins/colorscheme.fnl")
local function symbolize(text)
  return (":" .. text)
end
local function get_nvim_catppuccin_flavor()
  local _, _0, flavor = string.find(core.slurp(nvim_colorscheme_path), "flavor :(%w*)")
  return flavor
end
local function recompile_colorscheme()
  return compile["into-file"]({cfg = cfg, ["root-dir"] = nvim_root, path = nvim_colorscheme_path, source = core.slurp(nvim_colorscheme_path)})
end
local function update_file_content(path, from, to)
  local updated_content = string.gsub(core.slurp(path), from, to)
  return core.spit(path, updated_content)
end
local function on_update_from_command()
  do
    local new_flavor = catppuccin.flavour
    local nvim_flavor = get_nvim_catppuccin_flavor()
    if (new_flavor ~= nvim_flavor) then
      update_file_content(nvim_colorscheme_path, symbolize(nvim_flavor), symbolize(new_flavor))
      recompile_colorscheme()
    else
    end
  end
  return nil
end
local group = vim.api.nvim_create_augroup("sync-colorscheme", {clear = true})
vim.api.nvim_create_autocmd("ColorScheme", {pattern = "*", desc = "Persist the colorscheme when using the colorscheme command", callback = on_update_from_command, group = group})
return nil
