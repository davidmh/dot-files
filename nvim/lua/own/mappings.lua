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
  local function _2_()
    if enabled_3f then
      return "on"
    else
      return "off"
    end
  end
  return vim.notify(("Git blame line " .. _2_()), vim.log.levels.INFO, {title = "toggle", timeout = 1000})
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
local function get_git_root()
  return core["get-in"](vim, {"b", "gitsigns_status_dict", "root"})
end
local function _5_()
  return projects["find-files"](get_git_root(), opts("find files"))
end
vim.keymap.set("n", "<leader><leader>", _5_)
vim.keymap.set("n", "<leader>/b", grep_buffer_content, opts("find in open buffers"))
local function _6_()
  return t.live_grep({cwd = get_git_root()})
end
vim.keymap.set("n", "<leader>/p", _6_, opts("find in project"))
local function _7_()
  return t.grep_string({cwd = get_git_root()})
end
vim.keymap.set("n", "<leader>/w", _7_, opts("find word under cursor"))
vim.keymap.set("n", "<leader>s", ":botright split /tmp/scratch.fnl<cr>", opts("open scratch buffer"))
vim.keymap.set("n", "<leader>vp", browse_plugins, opts("vim plugins"))
vim.keymap.set("n", "<leader>vr", browse_runtime, opts("vim runtime"))
vim.keymap.set("n", "<leader>tb", toggle_blame_line, opts("toggle blame line"))
vim.keymap.set("n", "<leader>td", cmd("Trouble document_diagnostics"), opts("toggle document diagnostics"))
vim.keymap.set("n", "<leader>tw", cmd("Trouble workspace_diagnostics"), opts("toggle worspace diagnostics"))
local function _8_()
  return t.buffers()
end
vim.keymap.set("n", "<leader>bb", _8_, opts("list buffers"))
vim.keymap.set("n", "<leader>bk", cmd("bprevious <bar> bdelete! #"), opts("kill buffer"))
vim.keymap.set("n", "<leader>bo", cmd("BufOnly!"), opts("kill other buffers"))
vim.keymap.set("n", "<leader>ni", cmd("Neog index"), opts("neog index"))
local function _9_()
  return telescope_file_browser("~/Documents/neorg/")
end
vim.keymap.set("n", "<leader>nb", _9_, opts("neorg browse"))
vim.keymap.set("n", "<leader>nj", cmd("Neorg journal"), opts("neorg journal"))
vim.keymap.set("n", "<leader>nr", cmd("Neorg return"), opts("neorg return"))
local function _10_()
  return term_split(100)
end
vim.keymap.set({"n", "t"}, "<C-t>", _10_, opts("split term"))
local function _11_()
  return term_split(1)
end
vim.keymap.set({"n", "t"}, "<C-1>", _11_, opts("split term 1"))
local function _12_()
  return term_split(2)
end
vim.keymap.set({"n", "t"}, "<C-2>", _12_, opts("split term 2"))
local function _13_()
  return term_split(3)
end
vim.keymap.set({"n", "t"}, "<C-3>", _13_, opts("split term 3"))
local function _14_()
  return term_split(4)
end
vim.keymap.set({"n", "t"}, "<C-4>", _14_, opts("split term 4"))
local function _15_()
  return term_split(5)
end
vim.keymap.set({"n", "t"}, "<C-5>", _15_, opts("split term 5"))
local function _16_()
  return term_vsplit(100)
end
vim.keymap.set({"n", "t"}, "<M-\\>", _16_, opts("vertical split term"))
local function _17_()
  return term_tab(1)
end
vim.keymap.set({"n", "t"}, "<M-1>", _17_, opts("tab term 1"))
local function _18_()
  return term_tab(2)
end
vim.keymap.set({"n", "t"}, "<M-2>", _18_, opts("tab term 2"))
local function _19_()
  return term_tab(3)
end
vim.keymap.set({"n", "t"}, "<M-3>", _19_, opts("tab term 3"))
local function _20_()
  return term_tab(4)
end
vim.keymap.set({"n", "t"}, "<M-4>", _20_, opts("tab term 4"))
local function _21_()
  return term_tab(5)
end
vim.keymap.set({"n", "t"}, "<M-5>", _21_, opts("tab term 5"))
vim.keymap.set({"n", "t"}, "<M-t>", toggle_tmux, opts("tmux"))
local function _22_()
  return telescope_file_browser("~/.config/home-manager")
end
vim.keymap.set("n", "<localleader>c", _22_, opts("home manager config"))
vim.keymap.set("n", "<localleader>d", cmd("DBUIToggle"), opts("dadbod ui"))
vim.keymap.set("n", "<localleader>l", cmd("Lazy show"), opts("lazy ui"))
vim.keymap.set("n", "<localleader>m", cmd("Mason"), opts("mason"))
vim.keymap.set("n", "<localleader>no", cmd("Telescope notify"), opts("open notifications"))
local function _23_()
  return vim.notify.dismiss()
end
vim.keymap.set("n", "<localleader>nd", _23_, opts("dismiss notifications"))
local function _24_()
  return projects["select-project"]()
end
vim.keymap.set("n", "<localleader>p", _24_, opts("switch projects"))
vim.keymap.set("n", "L", cmd("LToggle"), opts("list toggle"))
vim.keymap.set("n", "Q", cmd("QToggle"), opts("quickfix toggle"))
vim.keymap.set("n", "<M-s>", cmd("write silent!"), opts("write file"))
vim.keymap.set("n", "z=", cmd("Telescope spell_suggest theme=get_cursor"), opts("suggest spelling"))
local function _25_()
  return vim.diagnostic.goto_prev(error_filter)
end
vim.keymap.set("n", "[d", _25_, opts("next diagnostic"))
local function _26_()
  return vim.diagnostic.goto_next(error_filter)
end
vim.keymap.set("n", "]d", _26_, opts("previous diagnostic"))
local function _27_()
  return vim.diagnostic.goto_prev(warning_filter)
end
vim.keymap.set("n", "[w", _27_, opts("next warning"))
local function _28_()
  return vim.diagnostic.goto_next(warning_filter)
end
vim.keymap.set("n", "]w", _28_, opts("previous warning"))
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
  local function _29_()
    return vim.lsp.buf.hover()
  end
  buf_map("K", _29_, "lsp: hover")
  local function _30_()
    return vim.lsp.buf.definition({reuse_win = true})
  end
  buf_map("gd", _30_, "lsp: go to definition")
  local function _31_()
    return vim.lsp.buf.references()
  end
  buf_map("<leader>lf", _31_, "lsp: find references")
  local function _32_()
    return vim.lsp.buf.implementation()
  end
  buf_map("<leader>li", _32_, "lsp: implementation")
  local function _33_()
    return vim.lsp.buf.signature_help()
  end
  buf_map("<leader>ls", _33_, "lsp: signature")
  local function _34_()
    return vim.lsp.buf.type_definition()
  end
  buf_map("<leader>lt", _34_, "lsp: type definition")
  local function _35_()
    return vim.lsp.buf.code_action()
  end
  buf_map("<leader>la", _35_, "lsp: code actions")
  local function _36_()
    return vim.lsp.buf.rename()
  end
  buf_map("<leader>lr", _36_, "lsp: rename")
  buf_map("<leader>lR", "<cmd>LspRestart<CR>", "lsp: restart")
  local function _37_()
    return vim.lsp.buf.code_action()
  end
  vim.keymap.set("v", "<leader>la", _37_, {buffer = true, desc = "lsp: code actions"})
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
