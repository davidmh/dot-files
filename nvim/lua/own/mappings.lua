-- [nfnl] Compiled from fnl/own/mappings.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local t = autoload("telescope.builtin")
local gitsigns = autoload("gitsigns")
local scratch = autoload("own.scratch")
local toggle_term = autoload("toggleterm")
local terminal = autoload("toggleterm.terminal")
local state = {["tmux-term"] = nil}
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
local function term_tab(id)
  return toggle_term.toggle_command("direction=tab dir=. size=0", id)
end
local function term_split(id)
  return toggle_term.toggle_command("direction=horizontal dir=. size=0", id)
end
local function term_vsplit(id)
  return toggle_term.toggle_command(("direction=vertical dir=. size=" .. (vim.o.columns / 2)), id)
end
local function toggle_tmux()
  local term = terminal.Terminal
  if (state["tmux-term"] == nil) then
    local function _3_()
      state["tmux-term"] = nil
      return nil
    end
    state["tmux-term"] = term:new({id = 200, cmd = "tmux -2 attach 2>/dev/null || tmux -2", direction = "tab", close_on_exit = true, on_exit = _3_})
  else
  end
  return (state["tmux-term"]):toggle()
end
local function opts(desc)
  return {silent = true, desc = desc}
end
vim.keymap.set("n", "<leader><leader>", find_files, opts("find files"))
vim.keymap.set("n", "<leader>/b", grep_buffer_content, opts("find in open buffers"))
local function _5_()
  return t.live_grep()
end
vim.keymap.set("n", "<leader>/p", _5_, opts("find in project"))
local function _6_()
  return t.grep_string()
end
vim.keymap.set("n", "<leader>/w", _6_, opts("find word under cursor"))
vim.keymap.set("n", "<leader>so", scratch.show, opts("open scratch buffer"))
vim.keymap.set("n", "<leader>sk", scratch.kill, opts("kill scratch buffer"))
vim.keymap.set("n", "<leader>vp", browse_plugins, opts("vim plugins"))
vim.keymap.set("n", "<leader>vr", browse_runtime, opts("vim runtime"))
vim.keymap.set("n", "<leader>tb", toggle_blame_line, opts("toggle blame line"))
vim.keymap.set("n", "<leader>td", cmd("Trouble document_diagnostics"), opts("toggle diagnostics"))
local function _7_()
  return t.buffers()
end
vim.keymap.set("n", "<leader>bb", _7_, opts("list buffers"))
vim.keymap.set("n", "<leader>bk", cmd("bprevious <bar> bdelete! #"), opts("kill buffer"))
vim.keymap.set("n", "<leader>bo", cmd("BufOnly!"), opts("kill other buffers"))
local function _8_()
  return telescope_file_browser("~/Documents/neorg/")
end
vim.keymap.set("n", "<leader>ob", _8_, opts("org browse"))
local function _9_()
  return term_split(100)
end
vim.keymap.set({"n", "t"}, "<C-t>", _9_, opts("split term"))
local function _10_()
  return term_split(1)
end
vim.keymap.set({"n", "t"}, "<C-1>", _10_, opts("split term 1"))
local function _11_()
  return term_split(2)
end
vim.keymap.set({"n", "t"}, "<C-2>", _11_, opts("split term 2"))
local function _12_()
  return term_split(3)
end
vim.keymap.set({"n", "t"}, "<C-3>", _12_, opts("split term 3"))
local function _13_()
  return term_split(4)
end
vim.keymap.set({"n", "t"}, "<C-4>", _13_, opts("split term 4"))
local function _14_()
  return term_split(5)
end
vim.keymap.set({"n", "t"}, "<C-5>", _14_, opts("split term 5"))
local function _15_()
  return term_vsplit(100)
end
vim.keymap.set({"n", "t"}, "<M-\\>", _15_, opts("vertical split term"))
local function _16_()
  return term_tab(1)
end
vim.keymap.set({"n", "t"}, "<M-1>", _16_, opts("tab term 1"))
local function _17_()
  return term_tab(2)
end
vim.keymap.set({"n", "t"}, "<M-2>", _17_, opts("tab term 2"))
local function _18_()
  return term_tab(3)
end
vim.keymap.set({"n", "t"}, "<M-3>", _18_, opts("tab term 3"))
local function _19_()
  return term_tab(4)
end
vim.keymap.set({"n", "t"}, "<M-4>", _19_, opts("tab term 4"))
local function _20_()
  return term_tab(5)
end
vim.keymap.set({"n", "t"}, "<M-5>", _20_, opts("tab term 5"))
vim.keymap.set({"n", "t"}, "<M-t>", toggle_tmux, opts("tmux"))
local function _21_()
  return telescope_file_browser("~/.config/home-manager")
end
vim.keymap.set("n", "<localleader>c", _21_, opts("home manager config"))
vim.keymap.set("n", "<localleader>d", cmd("DBUIToggle"), opts("dadbod ui"))
vim.keymap.set("n", "<localleader>ls", cmd("Lazy show"), opts("lazy show"))
vim.keymap.set("n", "<localleader>lc", cmd("Lazy clean"), opts("lazy clean"))
vim.keymap.set("n", "<localleader>lu", cmd("Lazy update"), opts("lazy update"))
vim.keymap.set("n", "<localleader>no", cmd("Telescope notify"), opts("open notifications"))
local function _22_()
  return vim.notify.dismiss()
end
vim.keymap.set("n", "<localleader>nd", _22_, opts("dismiss notifications"))
vim.keymap.set("n", "L", cmd("LToggle"), opts("list toggle"))
vim.keymap.set("n", "Q", cmd("QToggle"), opts("quickfix toggle"))
vim.keymap.set("n", "<M-s>", cmd("write silent!"), opts("write file"))
vim.keymap.set("n", "z=", cmd("Telescope spell_suggest theme=get_cursor"), opts("suggest spelling"))
local function _23_()
  return vim.diagnostic.goto_prev()
end
vim.keymap.set("n", "[d", _23_, opts("next diagnostic"))
local function _24_()
  return vim.diagnostic.goto_next()
end
vim.keymap.set("n", "]d", _24_, opts("previous diagnostic"))
for _, action in ipairs({"y", "d", "p", "c"}) do
  local Action = string.upper(action)
  vim.keymap.set("n", ("<leader>" .. action), ("\"+" .. action))
  vim.keymap.set("v", ("<leader>" .. action), ("\"+" .. action))
  vim.keymap.set("n", ("<leader>" .. Action), ("\"+" .. Action))
  vim.keymap.set("v", ("<leader>" .. Action), ("\"+" .. Action))
end
return nil
