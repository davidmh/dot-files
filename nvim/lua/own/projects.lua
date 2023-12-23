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
local Path = autoload("plenary.path")
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
  local exists_3f = Path:new(project_path):is_dir()
  if exists_3f then
    local projects = get_projects()
    local name = vim.fn.fnamemodify(project_path, ":t")
    local project = {name = name, timestamp = os.time(), visible = true}
    return spit(projects_path, vim.json.encode(merge({[project_path] = project}, projects)))
  else
    return vim.notify(("Project " .. project_path .. " does not exist"))
  end
end
local function find_files(cwd)
  return t.find_files({cwd = (cwd or vim.fn.getcwd()), find_command = {"fd", "--hidden", "--type", "f", "--exclude", ".git"}})
end
local function format_project(path, name)
  local function _7_()
    return find_files(path)
  end
  return {name = (name .. " -> " .. sanitize_path(path, 3)), action = _7_, section = "Recent Projects"}
end
local function sort_projects(projects)
  local function _12_(_8_, _10_)
    local _arg_9_ = _8_
    local _ = _arg_9_[1]
    local a = _arg_9_[2]
    local _arg_11_ = _10_
    local _0 = _arg_11_[1]
    local b = _arg_11_[2]
    return (a.timestamp > b.timestamp)
  end
  table.sort(projects, _12_)
  return projects
end
local function recent_projects()
  local function _15_(acc, _13_)
    local _arg_14_ = _13_
    local path = _arg_14_[1]
    local project = _arg_14_[2]
    if project.visible then
      return concat(acc, {format_project(path, project.name)})
    else
      return acc
    end
  end
  return reduce(_15_, {}, sort_projects(kv_pairs(get_projects())))
end
local function pick_project(choice)
  if choice then
    return choice.action()
  else
    return nil
  end
end
local function select_project()
  local function _20_(_18_)
    local _arg_19_ = _18_
    local name = _arg_19_["name"]
    return name
  end
  return vim.ui.select(recent_projects(), {prompt = "switch to a project", format_item = _20_}, pick_project)
end
local function _21_()
  return add_project(vim.fn.getcwd())
end
vim.api.nvim_create_autocmd("User", {pattern = "RooterChDir", callback = _21_})
return {["find-files"] = find_files, ["recent-projects"] = recent_projects, ["select-project"] = select_project}
