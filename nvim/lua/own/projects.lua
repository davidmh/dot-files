-- [nfnl] Compiled from fnl/own/projects.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.core")
local concat = _local_1_["concat"]
local kv_pairs = _local_1_["kv-pairs"]
local merge = _local_1_["merge"]
local reduce = _local_1_["reduce"]
local spit = _local_1_["spit"]
local slurp = _local_1_["slurp"]
local _local_2_ = require("own.lists")
local take = _local_2_["take"]
local _local_3_ = require("nfnl.module")
local autoload = _local_3_["autoload"]
local _local_4_ = require("own.helpers")
local sanitize_path = _local_4_["sanitize-path"]
local t = autoload("telescope.builtin")
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
local function add_project(project_path)
  if string.match(project_path, ":") then
    return
  else
  end
  local projects = get_projects()
  local name = vim.fn.fnamemodify(project_path, ":t")
  local project = {name = name, timestamp = os.time(), visible = true}
  return spit(projects_path, vim.json.encode(merge(projects, {[project_path] = project})))
end
local function find_files(cwd)
  return t.find_files({cwd = (cwd or vim.fn.getcwd()), find_command = {"fd", "--hidden", "--type", "f", "--exclude", ".git"}})
end
local function format_project(path, name)
  local function _8_()
    return find_files(path)
  end
  return {name = (name .. " -> " .. sanitize_path(path, 3)), action = _8_, section = "Recent Projects"}
end
local function sort_projects(projects)
  local function _11_(_9_, _10_)
    local _ = _9_[1]
    local a = _9_[2]
    local _0 = _10_[1]
    local b = _10_[2]
    return (a.timestamp > b.timestamp)
  end
  table.sort(projects, _11_)
  return projects
end
local function recent_projects(limit)
  local function _13_(acc, _12_)
    local path = _12_[1]
    local project = _12_[2]
    if project.visible then
      return concat(acc, {format_project(path, project.name)})
    else
      return acc
    end
  end
  return reduce(_13_, {}, take((limit or 30), sort_projects(kv_pairs(get_projects()))))
end
local function pick_project(choice)
  if choice then
    return choice.action()
  else
    return nil
  end
end
local function select_project()
  local function _17_(_16_)
    local name = _16_["name"]
    return name
  end
  return vim.ui.select(recent_projects(), {prompt = "switch to a project", format_item = _17_}, pick_project)
end
local function _18_()
  return add_project(vim.fn.getcwd())
end
vim.api.nvim_create_autocmd("User", {pattern = "RooterChDir", callback = _18_})
return {["find-files"] = find_files, ["recent-projects"] = recent_projects, ["select-project"] = select_project}
