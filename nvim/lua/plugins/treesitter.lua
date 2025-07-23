-- [nfnl] fnl/plugins/treesitter.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local configs = autoload("nvim-treesitter.configs")
local parsers = autoload("nvim-treesitter.parsers")
local function config()
  --[[ (vim.filetype.add {:extension {:wikitext "wikitext"}}) (local parser-configs (parsers.get_parser_configs)) (tset parser-configs "wikitext" {:filetype "wikitext" :install_info {:branch "main" :files ["src/parser.c"] :url "https://github.com/GhentCDH/tree-sitter-wikitext"}}) ]]
  local additional_vim_regex_highlighting = {}
  local ensure_installed = {"bash", "clojure", "diff", "dockerfile", "fennel", "gitattributes", "git_config", "graphql", "go", "gomod", "hcl", "html", "json", "json5", "lua", "luadoc", "make", "markdown", "markdown_inline", "nix", "python", "query", "regex", "ruby", "rust", "sql", "swift", "terraform", "tsx", "typescript", "vim", "vimdoc", "yaml"}
  return configs.setup({highlight = {enable = true}, indent = {enable = true}, incremental_selection = {enable = true, additional_vim_regex_highlighting = additional_vim_regex_highlighting, keymaps = {init_selection = "gnn", node_incremental = "<tab>", node_decremental = "<s-tab>", scope_incremental = "<leader><tab>"}}, textobjects = {select = {enable = true, lookahead = true, keymaps = {aa = "@parameter.outer", ia = "@parameter.inner", af = "@function.outer", ["if"] = "@function.inner", ac = "@class.outer", ic = "@class.inner", al = "@loop.outer", il = "@loop.inner"}}}, ensure_installed = ensure_installed, table_of_contents = {enable = true}})
end
return {{"nvim-treesitter/nvim-treesitter-textobjects", name = "nvim-treesitter-textobjects"}, {"nvim-treesitter/nvim-treesitter", dependencies = {"nvim-treesitter-textobjects"}, build = ":TSUpdate", config = config}, {"davidmh/mdx.nvim", dependencies = {"nvim-treesitter/nvim-treesitter"}, event = "BufRead *.mdx", config = true}}
