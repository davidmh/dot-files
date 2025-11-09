-- [nfnl] fnl/own/git.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local define = _local_1_["define"]
local fs = autoload("nfnl.fs")
local core = autoload("nfnl.core")
local str = autoload("nfnl.string")
local M = define("own.git")
M["git-error"] = function(result)
  return vim.notify(result.stderr, vim.log.levels.ERROR, {icon = "\243\176\138\162", title = "git error"})
end
M.git = function(...)
  local process = vim.system({"git", ...}, {text = true})
  local result = process:wait()
  if (result.stderr == "") then
    return str.trim(result.stdout)
  else
    return M["git-error"](result)
  end
end
M["git-remote-base-url"] = function()
  local remote = M.git("remote", "get-url", "origin")
  local base_url
  do
    local case_3_ = str.split(remote, ":")
    if ((_G.type(case_3_) == "table") and (case_3_[1] == "git@github.com") and (nil ~= case_3_[2])) then
      local path = case_3_[2]
      base_url = ("https://github.com/" .. path)
    elseif ((_G.type(case_3_) == "table") and (case_3_[1] == "https")) then
      base_url = remote
    else
      base_url = nil
    end
  end
  return string.gsub(base_url, ".git$", "")
end
M["git-url"] = function()
  local repo_root = M.git("rev-parse", "--show-toplevel")
  local absolute_path = vim.fn.expand("%:p")
  local relative_path = string.sub(absolute_path, (2 + #repo_root))
  local commit = M.git("rev-parse", "HEAD")
  return (M["git-remote-base-url"]() .. "/blob/" .. commit .. "/" .. relative_path)
end
M["git-url-with-range"] = function(opts)
  if (opts.range == 2) then
    return (M["git-url"]() .. "#L" .. opts.line1 .. "-L" .. opts.line2)
  else
    return M["git-url"]()
  end
end
M.write = function()
  local current_file = vim.fn.expand("%:p")
  vim.cmd("write")
  M.git("add", "--", current_file)
  if vim.endswith(current_file, ".fnl") then
    local function _6_()
      local lua_file = fs["fnl-path->lua-path"](current_file)
      if (vim.fn.filereadable(lua_file) == 1) then
        return M.git("add", "--", lua_file)
      else
        return nil
      end
    end
    return vim.schedule(_6_)
  else
    return nil
  end
end
M["files-in-commit"] = function(ref)
  local output = vim.fn.systemlist({"git", "show", "--name-only", "--diff-filter", "d", "--oneline", ref})
  local title = core.first(output)
  local git_root = (core["get-in"](vim.b, {"gitsigns_status_dict", "root"}) or vim.trim(vim.fn.system("git rev-parse --show-toplevel")))
  local files
  local function _9_(_241)
    return not core["empty?"](_241)
  end
  files = vim.tbl_filter(_9_, core.rest(output))
  local next_commit = ("next: " .. core.first(vim.fn.systemlist({"git", "log", "-n", 1, "--oneline", (ref .. "^")})))
  local next_ref = core.second(str.split(next_commit, " "))
  table.insert(files, next_commit)
  local function _10_(_241)
    if (_241 == nil) then
      return
    else
    end
    if (_241 == next_commit) then
      return M["files-in-commit"](next_ref)
    else
      return vim.cmd(("edit " .. git_root .. "/" .. _241))
    end
  end
  return vim.ui.select(files, {prompt = title}, _10_)
end
M["copy-remote-url"] = function(opts)
  local url = M["git-url-with-range"]((opts or {}))
  vim.fn.setreg("+", url)
  return vim.notify(url, vim.log.levels.INFO, {title = "Copied to clipboard", icon = "\239\131\170"})
end
M["view-in-fugitive"] = function(picker, item)
  picker:close()
  if item then
    local function _13_()
      return vim.cmd(("Gtabedit " .. item.commit))
    end
    return vim.schedule(_13_)
  else
    return nil
  end
end
return M
