-- [nfnl] Compiled from fnl/own/package.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local str = autoload("nfnl.string")
local function get_package_paths(current_file)
  local paths = {}
  for dir in vim.fs.parents(current_file) do
    if (vim.fn.filereadable((dir .. "/package.json")) == 1) then
      table.insert(paths, (dir .. "/package.json"))
      if (dir == "./") then
        return paths
      else
      end
    else
    end
  end
  return paths
end
local function parse_package(package_path)
  return vim.fn.json_decode(vim.fn.readfile(package_path, ""))
end
local function parse_scripts(package_path)
  local yarn_dir = string.gsub(string.gsub(package_path, vim.fn.getcwd(), ""), "package.json", "")
  local keys = core.keys(core.get(parse_package(package_path), "scripts"))
  local function _4_(key)
    return (yarn_dir .. " | " .. key)
  end
  return vim.tbl_map(_4_, keys)
end
local function format_script(script)
  local parts = str.split(script, " | ")
  local dir = core.first(parts)
  local cmd = core.second(parts)
  return ("[" .. dir .. "] " .. cmd)
end
local function run_script(script)
  if script then
    local parts = str.split(script, " | ")
    local dir = core.first(parts)
    local cmd = core.second(parts)
    return vim.cmd(("Dispatch -dir=" .. dir .. " yarn run " .. cmd))
  else
    return nil
  end
end
local function yarn_select()
  local package_paths = get_package_paths(vim.fn.expand("%:p"))
  local scripts = vim.tbl_map(parse_scripts, package_paths)
  local all = core.reduce(core.concat, {}, scripts)
  return vim.ui.select(all, {prompt = "yarn scripts", format_item = format_script}, run_script)
end
local function setup_package_command()
  local has_paths = core.first(get_package_paths(vim.fn.expand("%:p")))
  if has_paths then
    return vim.keymap.set("n", "<localleader>y", yarn_select, {desc = "yarn", buffer = 0})
  else
    return nil
  end
end
local group = vim.api.nvim_create_augroup("package-command", {clear = true})
vim.api.nvim_create_autocmd({"BufEnter", "BufNew"}, {pattern = "*", callback = setup_package_command, group = group})
return nil
