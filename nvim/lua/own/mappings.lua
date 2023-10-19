-- [nfnl] Compiled from fnl/own/mappings.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local t = autoload("telescope.builtin")
local gitsigns = autoload("gitsigns")
local scratch = autoload("own.scratch")
local function cmd(expression)
  return ("<cmd>" .. expression .. "<cr>")
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
local function opts(desc)
  return {silent = true, nowait = true, desc = desc}
end
vim.keymap.set("n", "<leader><leader>", find_files, opts("find files"))
vim.keymap.set("n", "<leader>/b", grep_buffer_content, opts("find in open buffers"))
local function _3_()
  return t.live_grep()
end
vim.keymap.set("n", "<leader>/p", _3_, opts("find in project"))
local function _4_()
  return t.grep_string()
end
vim.keymap.set("n", "<leader>/w", _4_, opts("find word under cursor"))
vim.keymap.set("n", "<leader>so", scratch.show, opts("open scratch buffer"))
vim.keymap.set("n", "<leader>sk", scratch.kill, opts("kill scratch buffer"))
vim.keymap.set("n", "<leader>vp", browse_plugins, opts("vim plugins"))
vim.keymap.set("n", "<leader>vr", browse_runtime, opts("vim runtime"))
vim.keymap.set("n", "<leader>tb", toggle_blame_line, opts("toggle blame line"))
vim.keymap.set("n", "<leader>td", cmd("Trouble document_diagnostics"), opts("toggle diagnostics"))
local function _5_()
  return t.buffers()
end
vim.keymap.set("n", "<leader>bb", _5_, opts("list buffers"))
vim.keymap.set("n", "<leader>bk", cmd("bprevious <bar> bdelete! #"), opts("kill buffer"))
vim.keymap.set("n", "<leader>bo", cmd("BufOnly!"), opts("kill other buffers"))
local function _6_()
  return telescope_file_browser("~/Documents/org/")
end
vim.keymap.set("n", "<leader>ob", _6_, opts("org browse"))
local function _7_()
  return telescope_file_browser("~/.config/home-manager")
end
vim.keymap.set("n", "<localleader>c", _7_, opts("home manager config"))
vim.keymap.set("n", "<localleader>d", cmd("DBUIToggle"), opts("dadbod ui"))
vim.keymap.set("n", "<localleader>ls", cmd("Lazy show"), opts("lazy show"))
vim.keymap.set("n", "<localleader>lc", cmd("Lazy clean"), opts("lazy clean"))
vim.keymap.set("n", "<localleader>lu", cmd("Lazy update"), opts("lazy update"))
vim.keymap.set("n", "<localleader>no", cmd("Telescope notify"), opts("open notifications"))
local function _8_()
  return vim.notify.dismiss()
end
vim.keymap.set("n", "<localleader>nd", _8_, opts("dismiss notifications"))
vim.keymap.set("n", "L", cmd("LToggle"), opts("list toggle"))
vim.keymap.set("n", "Q", cmd("QToggle"), opts("quickfix toggle"))
vim.keymap.set("n", "<M-s>", cmd("write silent!"), opts("write file"))
vim.keymap.set("n", "z=", cmd("Telescope spell_suggest theme=get_cursor"), opts("suggest spelling"))
local function _9_()
  return vim.diagnostic.goto_prev()
end
vim.keymap.set("n", "[d", _9_, opts("next diagnostic"))
local function _10_()
  return vim.diagnostic.goto_next()
end
vim.keymap.set("n", "]d", _10_, opts("previous diagnostic"))
for _, action in ipairs({"y", "x", "p", "c"}) do
  local Action = string.upper(action)
  vim.keymap.set("n", ("<leader>" .. action), ("\"+" .. action))
  vim.keymap.set("v", ("<leader>" .. action), ("\"+" .. action))
  vim.keymap.set("n", ("<leader>" .. Action), ("\"+" .. Action))
  vim.keymap.set("v", ("<leader>" .. Action), ("\"+" .. Action))
end
return nil
