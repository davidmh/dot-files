-- [nfnl] Compiled from fnl/own/plugin/which-key.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local str = autoload("nfnl.string")
local core = autoload("nfnl.core")
local config = autoload("own.config")
local wk = autoload("which-key")
local t = autoload("telescope.builtin")
local gitsigns = autoload("gitsigns")
local scratch = autoload("own.scratch")
vim.o.timeoutlen = 2500
wk.setup({plugins = {spelling = {enabled = false}, presets = {operators = true, motions = true, text_objects = true, windows = true, nav = true, z = true}}, window = {border = config.border, margin = {2, 30, 2, 30}, winblend = 10}})
local function cmd(expression, description)
  return {("<cmd>" .. expression .. "<cr>"), description}
end
local function grep_buffer_content()
  return t.live_grep({prompt_title = "Find in open buffers", grep_open_files = true})
end
local function telescope_file_browser(path)
  return t.find_files({depth = 4, cwd = path})
end
local function browse_plugins()
  return telescope_file_browser((vim.fn.stdpath("data") .. "/lazy"))
end
local function browse_runtime()
  return telescope_file_browser(vim.fn.expand("$VIMRUNTIME/lua"))
end
local function set_font_size(func)
  local font = str.split(vim.o.guifont, ":h")
  vim.o.guifont = (core.first(font) .. ":h" .. func(core.last(font)))
  return nil
end
local function toggle_blame_line()
  local enabled_3f = gitsigns.toggle_current_line_blame()
  local function _2_()
    if enabled_3f then
      return "on"
    else
      return "off"
    end
  end
  return vim.notify(("Git blame line " .. _2_()), vim.log.levels.INFO, {title = "toggle", timeout = 1000})
end
local function find_files()
  return t.find_files({find_command = {"fd", "--hidden", "--type", "f", "--exclude", ".git"}})
end
local function _3_()
  return telescope_file_browser("~/Documents/org/")
end
wk.register({f = {telescope_file_browser, "file browser"}, ["<leader>"] = {find_files, "find files"}, ["/"] = {name = "search", b = {grep_buffer_content, "in open buffers"}, p = {t.live_grep, "in project"}, w = {t.grep_string, "word under cursor"}}, s = {name = "scratch", o = {scratch.show, "open"}, k = {scratch.kill, "kill"}}, vp = {browse_plugins, "vim plugins"}, vr = {browse_runtime, "vim runtime"}, t = {name = "toggle", b = {toggle_blame_line, "git blame"}, d = cmd("TroubleToggle document_diagnostics", "diagnostics")}, b = {name = "buffer", b = cmd("Telescope buffers", "buffer list"), k = cmd("bprevious <bar> bdelete! #", "kill buffer"), o = cmd("BufOnly!", "kill other buffers")}, r = {name = "runner", F = cmd("VtrFlushCommand", "flush"), a = cmd("VtrAttachToPane", "attach"), c = cmd("VtrSendCommandToRunner", "command"), f = cmd("VtrSendFile", "file"), k = cmd("VtrKillRunner", "kill"), o = cmd("VtrOpenRunner", "open"), s = {name = "send"}, l = cmd("VtrSendLinesToRunner", "lines")}, o = {name = "orgmode", a = "agenda", b = {_3_, "browse"}, c = "capture"}, w = {name = "window", z = cmd("tabnew %", "zoom")}}, {prefix = "<leader>"})
local function _4_()
  return telescope_file_browser("~/.config/home-manager")
end
local function _5_()
  return vim.notify.dismiss()
end
wk.register({c = {_4_, "config"}, d = cmd("DBUIToggle", "db"), l = {name = "lazy", l = cmd("Lazy show", "show"), i = cmd("Lazy install", "install"), c = cmd("Lazy clean", "clean"), u = cmd("Lazy update", "update"), p = cmd("Lazy profile", "profile"), s = cmd("Lazy sync", "sync")}, n = {name = "notifications", o = cmd("Telescope notify", "open"), d = {_5_, "dismiss"}}}, {prefix = "<localleader>"})
local function _6_()
  return set_font_size(core.inc)
end
local function _7_()
  return set_font_size(core.dec)
end
wk.register({L = cmd("LToggle", "list toggle"), Q = cmd("QToggle", "quickfix toggle"), ["<M-s>"] = cmd("write", "silent! write"), ["z="] = cmd("Telescope spell_suggest theme=get_cursor", "suggest spelling"), ["<D-=>"] = {_6_, "increase font size"}, ["<D-->"] = {_7_, "increase font size"}, ["[d"] = cmd("lua vim.diagnostic.goto_prev()", "next diagnostic"), ["]d"] = cmd("lua vim.diagnostic.goto_next()", "prev diagnostic")})
local shared_actions = {y = {name = "yank", dir = "into"}, x = {name = "delete", dir = "into"}, p = {name = "paste", dir = "from"}, c = {name = "change", dir = "into"}}
local function os_clipboard_cmd(action, name, direction)
  return {("\"+" .. action), (name .. " " .. direction .. " the OS clipboard")}
end
local os_mappings = {}
for action, data in pairs(shared_actions) do
  local Action = string.upper(action)
  do end (os_mappings)[action] = os_clipboard_cmd(action, data.name, data.dir)
  do end (os_mappings)[Action] = os_clipboard_cmd(Action, string.upper(data.name), data.dir)
end
return wk.register(os_mappings, {prefix = "<leader>", mode = {"n", "v"}})
