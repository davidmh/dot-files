-- [nfnl] Compiled from fnl/own/plugin/git.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local actions = autoload("telescope.actions")
local builtin = autoload("telescope.builtin")
local diff_view = autoload("diffview")
local git_signs = autoload("gitsigns")
local previewers = autoload("telescope.previewers")
local putils = autoload("telescope.previewers.utils")
local state = autoload("telescope.actions.state")
local str = autoload("nfnl.string")
local utils = autoload("telescope.utils")
local wk = autoload("which-key")
vim.g.fugitive_legacy_commands = false
vim.cmd("cabbrev git Git")
git_signs.setup({current_line_blame = false})
diff_view.setup({key_bindings = {disable_defaults = false}})
local function cmd(expression, description)
  return {("<cmd>" .. expression .. "<cr>"), description}
end
local function git_fixup(prompt_bufnr)
  local current_picker = state.get_current_picker(prompt_bufnr)
  local selection = state.get_selected_entry()
  local confirmation = vim.fn.input(("Fixup staged files into " .. selection.value .. "? [Y/n]"))
  if (string.lower(confirmation) == "y") then
    actions.close(prompt_bufnr)
    local cmd0 = {"git", "commit", "--fixup", selection.value}
    local output, ret = utils.get_os_command_output(cmd0, current_picker.cwd)
    local results
    if (ret == 0) then
      results = output
    else
      results = {"Nothing to fixup, have you staged your changes?"}
    end
    return vim.fn.setqflist(results, "r", {title = str.join(" ", cmd0)})
  else
    return nil
  end
end
local function view_commit(target)
  local function _4_(prompt_bufnr)
    local selection = state.get_selected_entry()
    actions.close(prompt_bufnr)
    return vim.cmd((target .. " " .. selection.value))
  end
  return _4_
end
local function yank_commit(propmt_bufnr)
  local selection = state.get_selected_entry()
  actions.close(propmt_bufnr)
  return vim.cmd(string.format("let @@='%s'", selection.value))
end
local function git_browse()
  return vim.cmd(("GBrowse " .. state.get_selected_entry().value))
end
local function git_commit_preview_fn(opts)
  local function _5_(_, entry)
    return entry.value
  end
  local function _6_(self, entry)
    putils.job_maker({"git", "--no-pager", "show", (entry.value .. "^!")}, self.state.bufnr, {value = entry.value, bufname = self.state.bufname, cwd = opts.cwd})
    return putils.regex_highlighter(self.state.bufnr, "git")
  end
  return previewers.new_buffer_previewer({get_buffer_by_name = _5_, define_preview = _6_})
end
local git_commit_preview = utils.make_default_callable(git_commit_preview_fn, {})
local function git_log_mappings(_, map)
  do end (actions.select_default):replace(view_commit("Gtabedit"))
  map("i", "<C-x>", view_commit("Gsplit"))
  map("n", "<C-x>", view_commit("Gsplit"))
  map("i", "<C-v>", view_commit("Gvsplit"))
  map("n", "<C-v>", view_commit("Gvsplit"))
  map("i", "<C-y>", yank_commit)
  map("n", "<C-y>", yank_commit)
  map("i", "<C-b>", git_browse)
  map("n", "<C-b>", git_browse)
  map("i", "<C-f>", git_fixup)
  map("n", "<C-f>", git_fixup)
  return true
end
local function git_log(opts)
  local opts0 = (opts or {})
  local limit = (opts0.limit or 3000)
  local command = {"git", "log", "--oneline", "--decorate", "-n", limit, "--follow", "--", (opts0.path or ".")}
  return builtin.git_commits({attach_mappings = git_log_mappings, previewer = git_commit_preview.new(opts0), git_command = command})
end
local function git_buffer_log()
  return git_log({path = vim.fn.expand("%")})
end
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
  local files
  local function _8_(_241)
    return not core["empty?"](_241)
  end
  files = vim.tbl_filter(_8_, core.rest(output))
  local next_commit = ("next: " .. core.first(vim.fn.systemlist({"git", "log", "-n", 1, "--oneline", (ref .. "^")})))
  local next_ref = core.second(str.split(next_commit, " "))
  table.insert(files, next_commit)
  local function _9_(_241)
    if (_241 == nil) then
      return
    else
    end
    if (_241 == next_commit) then
      return files_in_commit(next_ref)
    else
      return vim.cmd(("edit " .. _241))
    end
  end
  return vim.ui.select(files, {prompt = title}, _9_)
end
local function _12_()
  return files_in_commit("HEAD")
end
wk.register({g = {name = "git", s = cmd("Git", "git status"), c = cmd("Telescope git_branches", "checkout branch"), w = cmd("Gwrite", "write into the git tree"), r = cmd("Gread", "read from the git tree"), e = cmd("Gedit", "edit from the git tree"), b = cmd("Git blame", "blame"), d = {toggle_diff_view, "view diff"}, l = {git_log, "git log"}, L = {git_buffer_log, "current buffer's git log"}, B = cmd("'<,'>GBrowse", "open in remote service"), f = cmd("GFixup", "fixup staged changes"), ["<space>"] = {_12_, "files in HEAD"}, h = {name = "hunk", ["["] = cmd("Gitsigns prev_hunk", "prev"), ["]"] = cmd("Gitsigns next_hunk", "next"), s = cmd("Gitsigns stage_hunk", "stage"), u = cmd("Gitsigns undo_stage_hunk", "unstage"), r = cmd("Gitsigns reset_hunk", "reset"), p = cmd("Gitsigns preview_hunk", "preview"), b = {git_blame_line, "blame"}}}}, {prefix = "<leader>"})
local function copy_remote_url(opts)
  local _13_
  if (opts.range == 2) then
    _13_ = (opts.line1 .. "," .. opts.line2 .. "GBrowse!")
  else
    _13_ = "GBrowse!"
  end
  return vim.notify(core.get(vim.api.nvim_exec2(_13_, {output = true}), "output"), vim.log.levels.INFO, {title = "Copied to clipboard", icon = "\239\131\170"})
end
return vim.api.nvim_create_user_command("GCopy", copy_remote_url, {range = true, nargs = 0})
