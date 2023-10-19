-- [nfnl] Compiled from fnl/own/plugin/toggle-term.fnl by https://github.com/Olical/nfnl, do not edit.
local toggle_term = require("toggleterm")
local term_edit = require("term-edit")
local terminal = require("toggleterm.terminal")
local term = terminal.Terminal
toggle_term.setup({shade_terminals = false})
term_edit.setup({prompt_end = " [ "})
local function term_tab(id)
  return toggle_term.toggle_command("direction=tab dir=. size=0", id)
end
local function term_split(id)
  return toggle_term.toggle_command("direction=horizontal dir=. size=0", id)
end
local function term_vsplit(id)
  return toggle_term.toggle_command(("direction=vertical dir=. size=" .. (vim.o.columns / 2)), id)
end
local state = {["tmux-term"] = nil}
local function toggle_tmux()
  if (state["tmux-term"] == nil) then
    local function _1_()
      state["tmux-term"] = nil
      return nil
    end
    state["tmux-term"] = term:new({id = 200, cmd = "tmux -2 attach 2>/dev/null || tmux -2", direction = "tab", close_on_exit = true, on_exit = _1_})
  else
  end
  return (state["tmux-term"]):toggle()
end
local function ntmap(keymap, callback, desc)
  return vim.keymap.set({"n", "t"}, keymap, callback, {nowait = true, desc = desc})
end
local function _3_()
  return term_split(100)
end
ntmap("<C-t>", _3_, "split")
local function _4_()
  return term_split(1)
end
ntmap("<C-1>", _4_, "split-term-1")
local function _5_()
  return term_split(2)
end
ntmap("<C-2>", _5_, "split-term-2")
local function _6_()
  return term_split(3)
end
ntmap("<C-3>", _6_, "split-term-3")
local function _7_()
  return term_split(4)
end
ntmap("<C-4>", _7_, "split-term-4")
local function _8_()
  return term_split(5)
end
ntmap("<C-5>", _8_, "split-term-5")
local function _9_()
  return term_vsplit(100)
end
ntmap("<M-\\>", _9_, "split")
local function _10_()
  return term_tab(1)
end
ntmap("<M-1>", _10_, "tab-term-1")
local function _11_()
  return term_tab(2)
end
ntmap("<M-2>", _11_, "tab-term-2")
local function _12_()
  return term_tab(3)
end
ntmap("<M-3>", _12_, "tab-term-3")
local function _13_()
  return term_tab(4)
end
ntmap("<M-4>", _13_, "tab-term-4")
local function _14_()
  return term_tab(5)
end
ntmap("<M-5>", _14_, "tab-term-5")
return ntmap("<M-t>", toggle_tmux, "tmux")
