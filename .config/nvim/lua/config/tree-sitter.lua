require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "<tab>",
        node_decremental = "<s-tab>",
        scope_incremental = "<leader><tab>",
      }
    },
    ensure_installed = {'ruby', 'typescript', 'tsx', 'python', 'html', 'json'}
}
