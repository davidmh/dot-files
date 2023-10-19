-- [nfnl] Compiled from fnl/own/plugin/tree-sitter.fnl by https://github.com/Olical/nfnl, do not edit.
local config = require("nvim-treesitter.configs")
local Comment = require("Comment")
local hook = require("ts_context_commentstring.integrations.comment_nvim")
local additional_vim_regex_highlighting = {}
local ensure_installed = {"bash", "fennel", "gitattributes", "git_config", "graphql", "hcl", "html", "json", "json5", "lua", "luadoc", "make", "markdown", "markdown_inline", "nix", "python", "query", "regex", "ruby", "rust", "sql", "terraform", "tsx", "typescript", "vim", "vimdoc", "yaml"}
do
  local ok_3f, org_mode = pcall(require, "orgmode")
  if ok_3f then
    org_mode.setup_ts_grammar()
    table.insert(ensure_installed, "org")
    table.insert(additional_vim_regex_highlighting, "org")
  else
  end
end
config.setup({highlight = {enable = true}, indent = {enable = true}, incremental_selection = {enable = true, additional_vim_regex_highlighting = additional_vim_regex_highlighting, keymaps = {init_selection = "gnn", node_incremental = "<tab>", node_decremental = "<s-tab>", scope_incremental = "<leader><tab>"}}, textobjects = {select = {enable = true, lookahead = true, keymaps = {aa = "@parameter.outer", ia = "@parameter.inner", af = "@function.outer", ["if"] = "@function.inner", ac = "@class.outer", ic = "@class.inner"}}, move = {enable = true, set_jumps = true, goto_next_start = {["]]"] = "@function.outer"}, goto_next_end = {["]["] = "@function.outer"}, goto_previous_start = {["[["] = "@function.outer"}, go_to_previous_end = {["[]"] = "@function.outer"}}}, ensure_installed = ensure_installed, table_of_contents = {enable = true}, context_commentstring = {enable = true, enable_autocmd = false}})
return Comment.setup({pre_hook = hook.create_pre_hook()})
