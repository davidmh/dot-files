-- [nfnl] Compiled from fnl/own/mappings.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local t = autoload("telescope.builtin")
local gitsigns = autoload("gitsigns")
local toggle_term = autoload("toggleterm")
local terminal = autoload("toggleterm.terminal")
local navic = autoload("nvim-navic")
local projects = autoload("own.projects")
local core = autoload("nfnl.core")
local snacks = autoload("snacks")
local error_filter = {severity = vim.diagnostic.severity.ERROR}
local warning_filter = {severity = vim.diagnostic.severity.WARNING}
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
  local _2_
  if enabled_3f then
    _2_ = "on"
  else
    _2_ = "off"
  end
  return vim.notify(("Git blame line " .. _2_), vim.log.levels.INFO, {title = "toggle", timeout = 1000})
end
local function term_tab(id)
  return toggle_term.toggle_command("direction=tab dir=. size=0", id)
end
local function term_split(id)
  return toggle_term.toggle_command("direction=horizontal dir=. size=0", id)
end
local function toggle_tmux()
  local term = terminal.Terminal
  if (state["tmux-term"] == nil) then
    local function _4_()
      state["tmux-term"] = nil
      return nil
    end
    state["tmux-term"] = term:new({id = 200, cmd = "tmux -2 attach 2>/dev/null || tmux -2", direction = "tab", close_on_exit = true, on_exit = _4_})
  else
  end
  return state["tmux-term"]:toggle()
end
local function toggle_zellij()
  local term = terminal.Terminal
  if (state["tmux-zellij"] == nil) then
    local function _6_()
      state["tmux-zellij"] = nil
      return nil
    end
    state["tmux-zellij"] = term:new({id = 200, cmd = "zellij attach || zellij", direction = "tab", close_on_exit = true, on_exit = _6_})
    return nil
  else
    return state["tmux-zellij"]:toggle()
  end
end
local function ctrl_t(id)
  if string.find(vim.fn.expand("%"), "zellij") then
    return vim.system({"zellij", "action", "switch-mode", "tab"})
  else
    return term_split(id)
  end
end
local function opts(desc)
  return {silent = true, desc = desc}
end
local function get_git_root()
  return core["get-in"](vim, {"b", "gitsigns_status_dict", "root"})
end
local function search_cword()
  vim.cmd("normal! yiw")
  vim.cmd("GrugFar")
  local function _9_()
    return vim.cmd("normal! p$")
  end
  return vim.schedule(_9_)
end
local function _10_()
  return projects["find-files"](get_git_root(), opts("find files"))
end
vim.keymap.set("n", "<leader><leader>", _10_)
vim.keymap.set("n", "<leader>/b", grep_buffer_content, opts("find in open buffers"))
vim.keymap.set("n", "<leader>/p", cmd("GrugFar"), opts("find in project"))
vim.keymap.set("n", "<leader>/w", search_cword, opts("find current word"))
vim.keymap.set("n", "<leader>s", ":botright split /tmp/scratch.fnl<cr>", opts("open scratch buffer"))
vim.keymap.set("n", "<leader>vp", browse_plugins, opts("vim plugins"))
vim.keymap.set("n", "<leader>vr", browse_runtime, opts("vim runtime"))
vim.keymap.set("n", "<leader>tb", toggle_blame_line, opts("toggle blame line"))
local function _11_()
  return t.buffers()
end
vim.keymap.set("n", "<leader>bb", _22_, opts("list buffers"))
local function _23_()
  return snacks.bufdelete.delete()
end
vim.keymap.set("n", "<leader>bk", _23_, opts("kill buffer"))
local function _24_()
  return snacks.bufdelete.other()
end
vim.keymap.set("n", "<leader>bo", _24_, opts("kill other buffers"))
vim.keymap.set("n", "<leader>ni", cmd("Neog index"), opts("neog index"))
local function _12_()
  return telescope_file_browser("~/Documents/neorg/")
end
vim.keymap.set("n", "<leader>nb", _12_, opts("neorg browse"))
vim.keymap.set("n", "<leader>nj", cmd("Neorg journal"), opts("neorg journal"))
vim.keymap.set("n", "<leader>nr", cmd("Neorg return"), opts("neorg return"))
local function _13_()
  return ctrl_t(100)
end
vim.keymap.set({"n", "t"}, "<C-t>", _13_, opts("split term"))
local function _14_()
  return term_split(1)
end
vim.keymap.set({"n", "t"}, "<C-1>", _14_, opts("split term 1"))
local function _15_()
  return term_split(2)
end
vim.keymap.set({"n", "t"}, "<C-2>", _15_, opts("split term 2"))
local function _16_()
  return term_split(3)
end
vim.keymap.set({"n", "t"}, "<C-3>", _16_, opts("split term 3"))
local function _17_()
  return term_split(4)
end
vim.keymap.set({"n", "t"}, "<C-4>", _17_, opts("split term 4"))
local function _18_()
  return term_split(5)
end
vim.keymap.set({"n", "t"}, "<C-5>", _18_, opts("split term 5"))
local function _19_()
  return term_tab(1)
end
vim.keymap.set({"n", "t"}, "<M-1>", _19_, opts("tab term 1"))
local function _20_()
  return term_tab(2)
end
vim.keymap.set({"n", "t"}, "<M-2>", _20_, opts("tab term 2"))
local function _21_()
  return term_tab(3)
end
vim.keymap.set({"n", "t"}, "<M-3>", _21_, opts("tab term 3"))
local function _22_()
  return term_tab(4)
end
vim.keymap.set({"n", "t"}, "<M-4>", _22_, opts("tab term 4"))
local function _23_()
  return term_tab(5)
end
vim.keymap.set({"n", "t"}, "<M-5>", _23_, opts("tab term 5"))
vim.keymap.set({"n", "t"}, "<M-t>", toggle_tmux, opts("tmux"))
vim.keymap.set({"n", "t"}, "<M-z>", toggle_zellij, opts("zellij"))
local function _24_()
  return telescope_file_browser("~/.config/home-manager")
end
vim.keymap.set("n", "<localleader>c", _24_, opts("home manager config"))
vim.keymap.set("n", "<localleader>d", cmd("DBUIToggle"), opts("dadbod ui"))
vim.keymap.set("n", "<localleader>l", cmd("Lazy show"), opts("lazy ui"))
vim.keymap.set("n", "<localleader>m", cmd("Mason"), opts("mason"))
vim.keymap.set("n", "<localleader>no", cmd("Telescope notify"), opts("open notifications"))
local function _25_()
  return vim.notify.dismiss()
end
vim.keymap.set("n", "<localleader>nd", _25_, opts("dismiss notifications"))
local function _26_()
  return projects["select-project"]()
end
vim.keymap.set("n", "<localleader>p", _26_, opts("switch projects"))
vim.keymap.set("n", "L", cmd("LToggle"), opts("list toggle"))
vim.keymap.set("n", "Q", cmd("QToggle"), opts("quickfix toggle"))
vim.keymap.set("n", "<M-s>", cmd("silent! write"), opts("write file"))
vim.keymap.set("n", "z=", cmd("Telescope spell_suggest theme=get_cursor"), opts("suggest spelling"))
local function _27_()
  return vim.diagnostic.goto_prev(error_filter)
end
vim.keymap.set("n", "[d", _27_, opts("next diagnostic"))
local function _28_()
  return vim.diagnostic.goto_next(error_filter)
end
vim.keymap.set("n", "]d", _28_, opts("previous diagnostic"))
local function _29_()
  return vim.diagnostic.goto_prev(warning_filter)
end
vim.keymap.set("n", "[w", _29_, opts("next warning"))
local function _30_()
  return vim.diagnostic.goto_next(warning_filter)
end
vim.keymap.set("n", "]w", _30_, opts("previous warning"))
vim.api.nvim_create_augroup("eslint-autofix", {clear = true})
local function set_eslint_autofix(bufnr)
  return vim.api.nvim_create_autocmd("BufWritePre", {command = "EslintFixAll", group = "eslint-autofix", buffer = bufnr})
end
local function buf_map(keymap, callback, desc)
  return vim.keymap.set("n", keymap, callback, {buffer = true, silent = true, desc = desc})
end
local function on_attach(args)
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")
  local function _31_()
    return vim.lsp.buf.hover()
  end
  buf_map("K", _31_, "lsp: hover")
  local function _32_()
    return vim.lsp.buf.definition({reuse_win = true})
  end
  buf_map("gd", _32_, "lsp: go to definition")
  local function _33_()
    return vim.lsp.buf.references()
  end
  buf_map("<leader>lf", _33_, "lsp: find references")
  local function _34_()
    return vim.lsp.buf.implementation()
  end
  buf_map("<leader>li", _34_, "lsp: implementation")
  local function _35_()
    return vim.lsp.buf.signature_help()
  end
  buf_map("<leader>ls", _35_, "lsp: signature")
  local function _36_()
    return vim.lsp.buf.type_definition()
  end
  buf_map("<leader>lt", _36_, "lsp: type definition")
  local function _37_()
    return vim.lsp.buf.code_action()
  end
  buf_map("<leader>la", _37_, "lsp: code actions")
  local function _38_()
    return vim.lsp.buf.rename()
  end
  buf_map("<leader>lr", _38_, "lsp: rename")
  buf_map("<leader>lR", "<cmd>LspRestart<CR>", "lsp: restart")
  local function _39_()
    return vim.lsp.buf.code_action()
  end
  vim.keymap.set("v", "<leader>la", _39_, {buffer = true, desc = "lsp: code actions"})
  if (client.name == "eslint") then
    set_eslint_autofix(bufnr)
  else
  end
  if client.server_capabilities.documentSymbolProvider then
    return navic.attach(client, bufnr)
  else
    return nil
  end
end
do
  local group = vim.api.nvim_create_augroup("lsp-attach", {clear = true})
  vim.api.nvim_create_autocmd("LspAttach", {callback = on_attach, group = group})
end
vim.keymap.set("n", "<localleader>x", ":Telescope<CR>", {nowait = true, silent = true})
vim.keymap.set("n", "<localleader>h", ":Telescope help_tags<CR>", {nowait = true, silent = true})
vim.keymap.set("n", "<localleader>k", ":Telescope keymaps<CR>", {nowait = true, silent = true})
vim.keymap.set("n", "<localleader>o", ":Telescope oldfiles<CR>", {nowait = true, silent = true})
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
vim.keymap.set("t", "<M-k>", "<C-\\><C-n><C-W>k")
vim.keymap.set("t", "<M-j>", "<C-\\><C-n><C-W>j")
vim.keymap.set("t", "<M-h>", "<C-\\><C-n><C-W>h")
vim.keymap.set("t", "<M-l>", "<C-\\><C-n><C-W>l")
do
  local group = vim.api.nvim_create_augroup("auto-resize-windows", {clear = true})
  vim.api.nvim_create_autocmd("VimResized", {pattern = "*", command = "wincmd =", group = group})
end
for _, action in ipairs({"y", "d", "p", "c"}) do
  local Action = string.upper(action)
  vim.keymap.set("n", ("<leader>" .. action), ("\"+" .. action))
  vim.keymap.set("v", ("<leader>" .. action), ("\"+" .. action))
  vim.keymap.set("n", ("<leader>" .. Action), ("\"+" .. Action))
  vim.keymap.set("v", ("<leader>" .. Action), ("\"+" .. Action))
end
return nil
