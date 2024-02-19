-- [nfnl] Compiled from fnl/plugins/treesitter.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local configs = autoload("nvim-treesitter.configs")
local Comment = autoload("Comment")
local hook = autoload("ts_context_commentstring.integrations.comment_nvim")
local commentstring = autoload("ts_context_commentstring")
local function config()
  vim.g.skip_ts_context_commentstring_module = true
  commentstring.setup({highlight = true})
  Comment.setup({pre_hook = hook.create_pre_hook()})
  local additional_vim_regex_highlighting = {}
  local ensure_installed = {"bash", "clojure", "diff", "dockerfile", "fennel", "gitattributes", "git_config", "graphql", "go", "gomod", "hcl", "html", "json", "json5", "lua", "luadoc", "make", "markdown", "markdown_inline", "nix", "python", "query", "regex", "ruby", "rust", "sql", "terraform", "tsx", "typescript", "vim", "vimdoc", "yaml"}
  return configs.setup({highlight = {enable = true}, indent = {enable = true}, incremental_selection = {enable = true, additional_vim_regex_highlighting = additional_vim_regex_highlighting, keymaps = {init_selection = "gnn", node_incremental = "<tab>", node_decremental = "<s-tab>", scope_incremental = "<leader><tab>"}}, textobjects = {select = {enable = true, lookahead = true, keymaps = {aa = "@parameter.outer", ia = "@parameter.inner", af = "@function.outer", ["if"] = "@function.inner", ac = "@class.outer", ic = "@class.inner", al = "@loop.outer", il = "@loop.inner"}}}, ensure_installed = ensure_installed, table_of_contents = {enable = true}})
end
return {{"nvim-treesitter/nvim-treesitter", dependencies = {"nvim-treesitter/nvim-treesitter-textobjects", "JoosepAlviste/nvim-ts-context-commentstring", "numToStr/Comment.nvim"}, build = ":TSUpdate", config = config}, {"davidmh/mdx.nvim", dependencies = {"nvim-treesitter/nvim-treesitter"}, config = true}}
