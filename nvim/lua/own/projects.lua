-- [nfnl] Compiled from fnl/own/projects.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.core")
local concat = _local_1_["concat"]
local kv_pairs = _local_1_["kv-pairs"]
local merge = _local_1_["merge"]
local reduce = _local_1_["reduce"]
local spit = _local_1_["spit"]
local slurp = _local_1_["slurp"]
local _local_2_ = require("nfnl.module")
local autoload = _local_2_["autoload"]
local _local_3_ = require("own.helpers")
local sanitize_path = _local_3_["sanitize-path"]
local t = autoload("telescope.builtin")
local projects_path = (vim.fn.stdpath("state") .. "/projects.json")
local function _4_()
  if (vim.fn.filereadable(projects_path) == 0) then
    return spit(projects_path, "{}")
  else
    return nil
  end
end
vim.schedule(_4_)
local function get_projects()
  return vim.json.decode(slurp(projects_path))
end
local function add_project(project_path)
  local projects = get_projects()
  local name = vim.fn.fnamemodify(project_path, ":t")
  local project = {name = name, timestamp = os.time(), visible = true}
  return spit(projects_path, vim.json.encode(merge({[project_path] = project}, projects)))
end
local function find_files(cwd)
  return t.find_files({cwd = (cwd or vim.fn.getcwd()), find_command = {"fd", "--hidden", "--type", "f", "--exclude", ".git"}})
end
local function format_project(path, name)
  local function _6_()
    return find_files(path)
  end
  return {name = (name .. " -> " .. sanitize_path(path, 3)), action = _6_, section = "Recent Projects"}
end
local function sort_projects(projects)
  local function _11_(_7_, _9_)
    local _arg_8_ = _7_
    local _ = _arg_8_[1]
    local a = _arg_8_[2]
    local _arg_10_ = _9_
    local _0 = _arg_10_[1]
    local b = _arg_10_[2]
    return (a.timestamp > b.timestamp)
  end
  table.sort(projects, _11_)
  return projects
end
local function recent_projects()
  local function _14_(acc, _12_)
    local _arg_13_ = _12_
    local path = _arg_13_[1]
    local project = _arg_13_[2]
    if project.visible then
      return concat(acc, {format_project(path, project.name)})
    else
      return acc
    end
  end
  return reduce(_14_, {}, sort_projects(kv_pairs(get_projects())))
end
local function _16_()
  return add_project(vim.fn.getcwd())
end
vim.api.nvim_create_autocmd("User", {pattern = "RooterChDir", callback = _16_})
return {["get-projects"] = get_projects, ["find-files"] = find_files, ["recent-projects"] = recent_projects}
