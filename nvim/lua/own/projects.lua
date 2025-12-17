-- [nfnl] fnl/own/projects.fnl
local _local_1_ = require("nfnl.core")
local concat = _local_1_.concat
local kv_pairs = _local_1_["kv-pairs"]
local first = _local_1_.first
local map = _local_1_.map
local merge = _local_1_.merge
local reduce = _local_1_.reduce
local spit = _local_1_.spit
local slurp = _local_1_.slurp
local _local_2_ = require("own.lists")
local take = _local_2_.take
local _local_3_ = require("nfnl.module")
local autoload = _local_3_.autoload
local define = _local_3_.define
local _local_4_ = require("own.helpers")
local sanitize_path = _local_4_["sanitize-path"]
local snacks = autoload("snacks")
local M = define("own.projects")
local projects_path = (vim.fn.stdpath("state") .. "/projects.json")
local function _5_()
  if (vim.fn.filereadable(projects_path) == 0) then
    return spit(projects_path, "{}")
  else
    return nil
  end
end
vim.schedule(_5_)
local function get_projects()
  return vim.json.decode(slurp(projects_path))
end
M.add = function()
  local path = vim.fn.getcwd()
  if string.match(path, ":") then
    return
  else
  end
  local git_root = vim.fs.root(path, {".git"})
  if (git_root == nil) then
    return
  else
  end
  local projects = get_projects()
  local name = vim.fn.fnamemodify(git_root, ":t")
  local project = {name = name, timestamp = os.time(), visible = true}
  return spit(projects_path, vim.json.encode(merge(projects, {[git_root] = project})))
end
M["find-files"] = function(cwd)
  return snacks.picker.files({dirs = {(cwd or vim.fn.getcwd())}})
end
local function format_project(path, name)
  local function _9_()
    return M["find-files"](path)
  end
  return {name = (name .. " -> " .. sanitize_path(path, 3)), action = _9_, section = "Recent Projects"}
end
local function sort_projects(projects)
  local function _12_(_10_, _11_)
    local _ = _10_[1]
    local a = _10_[2]
    local _0 = _11_[1]
    local b = _11_[2]
    return (a.timestamp > b.timestamp)
  end
  table.sort(projects, _12_)
  return projects
end
M["recent-projects"] = function(limit)
  local function _14_(acc, _13_)
    local path = _13_[1]
    local project = _13_[2]
    if project.visible then
      return concat(acc, {format_project(path, project.name)})
    else
      return acc
    end
  end
  return reduce(_14_, {}, take((limit or 30), sort_projects(kv_pairs(get_projects()))))
end
local function pick_project(choice)
  if choice then
    return choice.action()
  else
    return nil
  end
end
M["select-project"] = function()
  local function _18_(_17_)
    local name = _17_.name
    return name
  end
  return vim.ui.select(M["recent-projects"](), {prompt = "switch to a project", format_item = _18_}, pick_project)
end
M["project-list"] = function()
  return map(first, sort_projects(kv_pairs(get_projects())))
end
return M
