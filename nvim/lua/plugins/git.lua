-- [nfnl] Compiled from fnl/plugins/git.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = require("own.string")
local ends_with = _local_2_["ends-with"]
local fs = autoload("nfnl.fs")
local core = autoload("nfnl.core")
local diff_view = autoload("diffview")
local git_signs = autoload("gitsigns")
local str = autoload("nfnl.string")
vim.g.fugitive_legacy_commands = false
local function git_error(result)
  return vim.notify(result.stderr, vim.log.levels.ERROR, {icon = "\243\176\138\162", title = "git error"})
end
local function git(...)
  local process = vim.system({"git", ...}, {text = true})
  local result = process:wait()
  if (result.stderr == "") then
    return str.trim(result.stdout)
  else
    return git_error(result)
  end
end
local function git_remote_base_url()
  local remote = git("remote", "get-url", "origin")
  local base_url
  do
    local _4_ = str.split(remote, ":")
    if ((_G.type(_4_) == "table") and (_4_[1] == "git@github.com") and (nil ~= _4_[2])) then
      local path = _4_[2]
      base_url = ("https://github.com/" .. path)
    elseif ((_G.type(_4_) == "table") and (_4_[1] == "https")) then
      base_url = remote
    else
      base_url = nil
    end
  end
  return string.gsub(base_url, ".git$", "")
end
local function git_url()
  local repo_root = git("rev-parse", "--show-toplevel")
  local absolute_path = vim.fn.expand("%:p")
  local relative_path = string.sub(absolute_path, (2 + #repo_root))
  local commit = git("rev-parse", "HEAD")
  return (git_remote_base_url() .. "/blob/" .. commit .. "/" .. relative_path)
end
local function gitsigns_commit_url(path)
  local remote_url = git_remote_base_url()
  local parts = str.split(path, "/")
  local commit = core.last(parts)
  return (remote_url .. "/commit/" .. commit)
end
local function neogit_commit_url()
  local commit = core.second(str.split(vim.fn.getline(1), " "))
  return (git_remote_base_url() .. "/commit/" .. commit)
end
local function git_url_with_range(opts)
  if (opts.range == 2) then
    return (git_url() .. "#L" .. opts.line1 .. "-L" .. opts.line2)
  else
    return git_url()
  end
end
local function cmd(expression)
  return ("<cmd>" .. expression .. "<cr>")
end
local function copy_remote_url(opts)
  local url = git_url_with_range(opts)
  vim.fn.setreg("+", url)
  return vim.notify(url, vim.log.levels.INFO, {title = "Copied to clipboard", icon = "\239\131\170"})
end
local function open_git_url(opts)
  local path = vim.fn.expand("%:p")
  local function _8_()
    local _7_ = {vim.bo.ft}
    if (_7_[1] == "git") then
      return gitsigns_commit_url(path)
    elseif (_7_[1] == "NeogitCommitView") then
      return neogit_commit_url()
    elseif true then
      return git_url_with_range(opts)
    else
      return nil
    end
  end
  return vim.ui.open(_8_())
end
vim.api.nvim_create_user_command("GCopy", copy_remote_url, {range = true, nargs = 0})
vim.api.nvim_create_user_command("GBrowse", open_git_url, {range = true, nargs = 0})
local function git_blame_line()
  return git_signs.blame_line(true)
end
local function toggle_diff_view()
  local buffer_prefix = core.first(str.split(vim.api.nvim_buf_get_name(0), ":"))
  if (buffer_prefix == "diffview") then
    return diff_view.close()
  else
    return diff_view.open()
  end
end
local function files_in_commit(ref)
  local output = vim.fn.systemlist({"git", "show", "--name-only", "--oneline", ref})
  local title = core.first(output)
  local git_root = (core["get-in"](vim.b, {"gitsigns_status_dict", "root"}) or vim.trim(vim.fn.system("git rev-parse --show-toplevel")))
  local files
  local function _11_(_241)
    return not core["empty?"](_241)
  end
  files = vim.tbl_filter(_11_, core.rest(output))
  local next_commit = ("next: " .. core.first(vim.fn.systemlist({"git", "log", "-n", 1, "--oneline", (ref .. "^")})))
  local next_ref = core.second(str.split(next_commit, " "))
  table.insert(files, next_commit)
  local function _12_(_241)
    if (_241 == nil) then
      return
    else
    end
    if (_241 == next_commit) then
      return files_in_commit(next_ref)
    else
      return vim.cmd(("edit " .. git_root .. "/" .. _241))
    end
  end
  return vim.ui.select(files, {prompt = title}, _12_)
end
local function gmap(keymap, callback, desc)
  return vim.keymap.set("n", ("<leader>g" .. keymap), callback, {desc = desc, nowait = true})
end
local function git_write()
  local current_file = vim.fn.expand("%:p")
  vim.cmd("write")
  git("add", "--", current_file)
  if ends_with(current_file, ".fnl") then
    local function _15_()
      local lua_file = fs["fnl-path->lua-path"](current_file)
      if (vim.fn.filereadable(lua_file) == 1) then
        return git("add", "--", lua_file)
      else
        return nil
      end
    end
    return vim.schedule(_15_)
  else
    return nil
  end
end
local function git_read()
  local current_file = vim.fn.expand("%")
  local content = git("show", ("HEAD:./" .. current_file))
  return vim.api.nvim_buf_set_lines(0, 0, -1, true, str.split(content, "\n"))
end
local function config()
  gmap("g", cmd("Neogit"), "git status")
  gmap("c", cmd("Neogit commit"), "git commit")
  gmap("w", git_write, "write into the git tree")
  gmap("r", git_read, "read from the git tree")
  gmap("b", cmd("Gitsigns blame"), "git blame")
  gmap("-", cmd("Neogit branch"), "git branch")
  gmap("d", toggle_diff_view, "toggle git diff")
  gmap("l", cmd("Neogit log"), "git log")
  gmap("L", cmd("NeogitLogCurrent"), "current buffer's git log")
  local function _18_()
    return files_in_commit("HEAD")
  end
  gmap("<space>", _18_, "files in git HEAD")
  gmap("f", cmd("Neogit fetch", "git fetch"))
  gmap("p", cmd("Neogit pull", "git pull"))
  gmap("B", cmd("GBrowse"), "browse")
  gmap("hs", cmd("Gitsigns stage_hunk"), "stage git hunk")
  gmap("hu", cmd("Gitsigns undo_stage_hunk"), "unstage git hunk")
  gmap("hr", cmd("Gitsigns reset_hunk"), "reset git hunk")
  gmap("hp", cmd("Gitsigns preview_hunk"), "preview git hunk")
  gmap("hb", git_blame_line, "blame current git hunk")
  vim.keymap.set("v", "<leader>gl", cmd("'<,'>GBrowse"), {desc = "open selection in the remote service", nowait = true, silent = true})
  vim.keymap.set("v", "<leader>gl", cmd("'<,'>NeogitLogCurrent"), {desc = "current's selection git log", nowait = true, silent = true})
  vim.keymap.set("n", "[h", cmd("Gitsigns prev_hunk"), {desc = "previous git hunk", nowait = true, silent = true})
  return vim.keymap.set("n", "]h", cmd("Gitsigns next_hunk"), {desc = "next git hunk", nowait = true, silent = true})
end
return {{"lewis6991/gitsigns.nvim", opts = {current_line_blame = true, signcolumn = true}, config = true}, {"sindrets/diffview.nvim", opts = {key_bindings = {disable_defaults = false}}, config = true}, {"tpope/vim-git", dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "lewis6991/gitsigns.nvim"}, event = "VeryLazy", config = config}, {"NeogitOrg/neogit", dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim"}, opts = {disable_hint = true, fetch_after_checkout = true, graph_style = "unicode", notification_icon = "\238\156\130", recent_commit_count = 15, remember_settings = false}, cmd = {"Neogit", "NeogitLogCurrent"}}}
