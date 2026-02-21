-- [nfnl] plugin/mappings.fnl
local _local_1_ = require("own.helpers")
local get_terminal_job_id = _local_1_["get-terminal-job-id"]
local _local_2_ = require("nfnl.module")
local autoload = _local_2_.autoload
local git = autoload("own.git")
local gitsigns = autoload("gitsigns")
local projects = autoload("own.projects")
local core = autoload("nfnl.core")
local snacks = autoload("snacks")
local notifications = autoload("own.notifications")
local error_filter = {severity = vim.diagnostic.severity.ERROR}
local other_filter = {severity = {vim.diagnostic.severity.WARN, vim.diagnostic.severity.INFO, vim.diagnostic.severity.HINT}}
local project_root_patterns = {".envrc", ".rspec", "Cargo.toml", "yarn.lock", "pyproject.toml", "lazy-lock.json", ".git"}
local function cmd(expression)
  return ("<cmd>" .. expression .. "<cr>")
end
local function grep_buffer_content()
  return snacks.picker.grep_buffers({title = "Find in open buffers"})
end
local function browse_plugins()
  return snacks.picker.files({rtp = true, title = "plugins"})
end
local function toggle_blame_line()
  local enabled_3f = gitsigns.toggle_current_line_blame()
  local _3_
  if enabled_3f then
    _3_ = "on"
  else
    _3_ = "off"
  end
  return vim.notify(("Git blame line " .. _3_), vim.log.levels.INFO, {title = "toggle", timeout = 1000})
end
local function toggle_quickfix()
  local function _6_(_5_)
    local bufnr = _5_.bufnr
    return (core["get-in"](vim.bo, {bufnr, "filetype"}, "") == "qf")
  end
  if core.some(_6_, vim.fn.getwininfo()) then
    return vim.cmd.cclose()
  else
    return vim.cmd.copen()
  end
end
local function toggle_zellij()
  return snacks.terminal.toggle("direnv exec . zellij attach || direnv exec . zellij", {win = {position = "float"}})
end
local function ctrl_t()
  if string.find(vim.fn.expand("%"), "zellij") then
    return vim.system({"zellij", "action", "switch-mode", "tab"})
  else
    local term = snacks.terminal.toggle("direnv exec . zsh", {cwd = vim.fs.root(vim.fn.expand("%:p"), project_root_patterns)})
    return core["assoc-in"](vim.b, {term.buf, "term_title"}, "scratch term")
  end
end
local function opts(desc)
  return {silent = true, desc = desc}
end
local function get_git_root()
  return core["get-in"](vim, {"b", "gitsigns_status_dict", "root"})
end
local function _9_()
  return projects["find-files"](get_git_root())
end
vim.keymap.set("n", "<leader><leader>", _9_, opts("find files"))
vim.keymap.set("n", "<leader>/", "<ignore>", {desc = "find"})
vim.keymap.set("n", "<leader>/b", grep_buffer_content, opts("find in open buffers"))
local function _10_()
  return snacks.picker.grep({dirs = {get_git_root()}})
end
vim.keymap.set("n", "<leader>/p", _10_, opts("find in project"))
local function _11_()
  return snacks.picker.grep_word({dirs = {get_git_root()}})
end
vim.keymap.set("n", "<leader>/w", _11_, opts("find current word"))
vim.keymap.set("n", "<leader>s", ":botright split ~/.config/nvim/scratch.fnl<cr>", opts("open scratch buffer"))
vim.keymap.set("n", "<leader>vp", browse_plugins, opts("vim plugins"))
vim.keymap.set("n", "<leader>t", "<ignore>", {desc = "toggle"})
vim.keymap.set("n", "<leader>tb", toggle_blame_line, opts("blame line"))
vim.keymap.set("n", "<leader>b", "<ignore>", {desc = "buffer"})
local function _12_()
  return snacks.picker.buffers({layout = {preset = "ivy_split"}})
end
vim.keymap.set("n", "<leader>bb", _12_, opts("list buffers"))
local function _13_()
  return snacks.bufdelete.delete()
end
vim.keymap.set("n", "<leader>bk", _13_, opts("kill buffer"))
local function _14_()
  return snacks.bufdelete.other()
end
vim.keymap.set("n", "<leader>bo", _14_, opts("kill other buffers"))
local function _15_()
  return ctrl_t()
end
vim.keymap.set({"n", "t"}, "<C-t>", _15_, opts("split term"))
vim.keymap.set({"n", "t"}, "<M-z>", toggle_zellij, opts("zellij"))
local function send_line_to_terminal()
  local job_id = get_terminal_job_id()
  if job_id then
    return vim.api.nvim_chan_send(job_id, (vim.api.nvim_get_current_line() .. "\n"))
  else
    return vim.print("There are no open terminals")
  end
end
vim.keymap.set("n", "<localleader>s", "<ignore>", {desc = "send to term"})
vim.keymap.set("n", "<localleader>sl", send_line_to_terminal, {desc = "line"})
local function _17_()
  return snacks.picker.files({dirs = {"~/.config/home-manager", "~/.config/nixos"}, title = "config"})
end
vim.keymap.set("n", "<localleader>c", _17_, opts("config"))
vim.keymap.set("n", "<localleader>l", cmd("Lazy show"), opts("lazy ui"))
vim.keymap.set("n", "<localleader>n", "<ignore>", {desc = "notifications"})
local function _18_()
  return notifications.open()
end
vim.keymap.set("n", "<localleader>no", _18_, opts("open notifications"))
local function _19_()
  return notifications.discard()
end
vim.keymap.set("n", "<localleader>nd", _19_, opts("dismiss notifications"))
local function _20_()
  return projects["select-project"]()
end
vim.keymap.set("n", "<localleader>p", _20_, opts("switch projects"))
vim.keymap.set("n", "Q", toggle_quickfix, opts("quickfix toggle"))
local function _21_()
  return snacks.picker.spelling()
end
vim.keymap.set("n", "z=", _21_, opts("suggest spelling"))
local function _22_()
  return vim.diagnostic.jump(core.merge({float = true, count = -1}, error_filter))
end
vim.keymap.set("n", "[d", _22_, opts("next diagnostic"))
local function _23_()
  return vim.diagnostic.jump(core.merge({float = true, count = 1}, error_filter))
end
vim.keymap.set("n", "]d", _23_, opts("previous diagnostic"))
local function _24_()
  return vim.diagnostic.jump(core.merge({float = true, count = -1}, other_filter))
end
vim.keymap.set("n", "[w", _24_, opts("next warning"))
local function _25_()
  return vim.diagnostic.jump(core.merge({float = true, count = 1}, other_filter))
end
vim.keymap.set("n", "]w", _25_, opts("previous warning"))
local function buf_map(keymap, callback, desc)
  return vim.keymap.set("n", keymap, callback, {buffer = true, silent = true, desc = desc})
end
local function lsp_mappings()
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", {scope = "local", buf = 0})
  local function _26_()
    return vim.lsp.buf.hover({max_width = 130, max_height = 20, wrap = false})
  end
  buf_map("K", _26_, "lsp: hover")
  buf_map("gd", cmd("Glance definitions"), "lsp: go to definition")
  buf_map("<leader>l", "<ignore>", "lsp")
  buf_map("<leader>lf", cmd("Glance references"), "lsp: find references")
  buf_map("<leader>li", cmd("Glance implementations"), "lsp: implementation")
  buf_map("<leader>lt", cmd("Glance type_definitions"), "lsp: type definition")
  local function _27_()
    return vim.diagnostic.setqflist(error_filter)
  end
  buf_map("<leader>le", _27_, "lsp: errors")
  local function _28_()
    return vim.lsp.buf.code_action()
  end
  buf_map("<leader>la", _28_, "lsp: code actions")
  local function _29_()
    return vim.lsp.buf.rename()
  end
  buf_map("<leader>lr", _29_, "lsp: rename")
  local function _30_()
    return snacks.picker.lsp_symbols()
  end
  buf_map("<leader>ls", _30_, "lsp: symbols")
  buf_map("<leader>lI", "<cmd>checkhealth vim.lsp<CR>", "lsp: info")
  buf_map("<leader>lR", "<cmd>lsp restart<CR>", "lsp: restart")
  buf_map("<leader>lE", "<cmd>lsp enable<CR>", "lsp: enable")
  buf_map("<leader>lD", "<cmd>lsp disable<CR>", "lsp: disable")
  local function _31_()
    return vim.cmd(("tabnew" .. " " .. vim.lsp.log.get_filename()))
  end
  buf_map("<leader>lL", _31_, "lsp: log")
  local function _32_()
    return vim.lsp.buf.code_action()
  end
  return vim.keymap.set("v", "<leader>la", _32_, {buffer = true, desc = "lsp: code actions"})
end
do
  local group = vim.api.nvim_create_augroup("lsp-attach", {clear = true})
  vim.api.nvim_create_autocmd("LspAttach", {callback = lsp_mappings, group = group})
end
vim.keymap.set("n", "<leader>g", "<ignore>", {desc = "git"})
vim.keymap.set("n", "<leader>gg", cmd("Neogit"), {desc = "status"})
vim.keymap.set("n", "<leader>gc", cmd("Neogit commit"), {desc = "commit"})
local function _33_()
  return git.write()
end
vim.keymap.set("n", "<leader>gw", _33_, {desc = "write"})
vim.keymap.set("n", "<leader>gr", cmd("Gread"), {desc = "read"})
vim.keymap.set("n", "<leader>gR", cmd("Neogit rebase"), {desc = "rebase"})
vim.keymap.set("n", "<leader>gb", cmd("Git blame"), {desc = "blame"})
vim.keymap.set("n", "<leader>g-", cmd("Neogit branch"), {desc = "branch"})
vim.keymap.set("n", "<leader>gd", cmd("CodeDiff"), {desc = "diff"})
local function _34_()
  return snacks.picker.git_log({confirm = git["view-in-fugitive"]})
end
vim.keymap.set("n", "<leader>gl", _34_, {desc = "log"})
local function _35_()
  return snacks.picker.git_log_file({confirm = git["view-in-fugitive"]})
end
vim.keymap.set("n", "<leader>gL", _35_, {desc = "log file"})
local function _36_()
  return git["files-in-commit"]("HEAD")
end
vim.keymap.set("n", "<leader>g<space>", _36_, {desc = "files in git HEAD"})
vim.keymap.set("n", "<leader>gf", cmd("Neogit fetch"), {desc = "fetch"})
vim.keymap.set("n", "<leader>gp", cmd("Neogit pull"), {desc = "pull"})
vim.keymap.set("n", "<leader>gB", cmd("GBrowse"), {desc = "browse"})
vim.keymap.set("n", "<leader>gh", "<ignore>", {desc = "hunk"})
vim.keymap.set("n", "<leader>ghs", cmd("Gitsigns stage_hunk"), {desc = "stage"})
vim.keymap.set("n", "<leader>ghu", cmd("Gitsigns undo_stage_hunk"), {desc = "unstage"})
vim.keymap.set("n", "<leader>ghr", cmd("Gitsigns reset_hunk"), {desc = "reset"})
vim.keymap.set("n", "<leader>ghp", cmd("Gitsigns preview_hunk"), {desc = "preview"})
local function _37_()
  return gitsigns.blame_line({full = true})
end
vim.keymap.set("n", "<leader>ghb", _37_, {desc = "blame"})
vim.keymap.set("v", "<leader>gl", cmd("'<,'>GBrowse"), {desc = "current's selection git browse", nowait = true, silent = true})
vim.keymap.set("v", "<leader>gl", cmd("'<,'>NeogitLogCurrent"), {desc = "current's selection git log", nowait = true, silent = true})
vim.keymap.set("n", "[h", cmd("Gitsigns prev_hunk"), {desc = "previous git hunk", nowait = true, silent = true})
vim.keymap.set("n", "]h", cmd("Gitsigns next_hunk"), {desc = "next git hunk", nowait = true, silent = true})
local function _38_()
  return snacks.picker.commands({layout = {preset = "vscode"}})
end
vim.keymap.set("n", "<M-x>", _38_, {nowait = true, silent = true})
local function _39_()
  return snacks.picker.help({layout = {preset = "top"}})
end
vim.keymap.set("n", "<M-h>", _39_, {nowait = true, silent = true})
local function _40_()
  return snacks.picker.keymaps({global = false})
end
vim.keymap.set("n", "<M-k>", _40_, {nowait = true, silent = true})
local function _41_()
  return snacks.picker.recent()
end
vim.keymap.set("n", "<M-o>", _41_, {nowait = true, silent = true})
local function _42_()
  return snacks.picker()
end
vim.keymap.set("n", "<M-s>", _42_, {nowait = true, silent = true})
local function _43_()
  return snacks.picker.explorer({auto_close = true, hidden = true})
end
vim.keymap.set("n", "<leader>ff", _43_, {desc = "file explorer"})
vim.keymap.set("n", "<M-,>", "<C-W>5<")
vim.keymap.set("n", "<M-.>", "<C-W>5>")
vim.keymap.set("n", "<M-->", "<C-W>5-")
vim.keymap.set("n", "<M-=>", "<C-W>5+")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-j>", "<C-W>j")
vim.keymap.set("n", "<C-h>", "<C-W>h")
vim.keymap.set("n", "<C-l>", "<C-W>l")
vim.keymap.set("t", "<M-,>", "<C-\\><C-n><C-W>5<")
vim.keymap.set("t", "<M-.>", "<C-\\><C-n><C-W>5>")
vim.keymap.set("t", "<M-->", "<C-\\><C-n><C-W>5-")
vim.keymap.set("t", "<M-=>", "<C-\\><C-n><C-W>5+")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-W>k")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-W>j")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-W>h")
do
  local group = vim.api.nvim_create_augroup("auto-resize-windows", {clear = true})
  vim.api.nvim_create_autocmd("VimResized", {pattern = "*", command = "wincmd =", group = group})
end
local action_name = {y = "yank", Y = "yank line", d = "delete", D = "delete line", p = "put", P = "put before", c = "change", C = "change line"}
for _, action in ipairs({"y", "d", "p", "c"}) do
  local Action = string.upper(action)
  local desc = action_name[action]
  local Desc = action_name[Action]
  vim.keymap.set("n", ("<leader>" .. action), ("\"+" .. action), {desc = desc})
  vim.keymap.set("v", ("<leader>" .. action), ("\"+" .. action), {desc = desc})
  vim.keymap.set("n", ("<leader>" .. Action), ("\"+" .. Action), {desc = Desc})
  vim.keymap.set("v", ("<leader>" .. Action), ("\"+" .. Action), {desc = Desc})
end
return nil
