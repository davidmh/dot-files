(import-macros {: use} :own.macros)

(local {: get} (require :nfnl.core))
(local {: autoload} (require :nfnl.module))
(local commands (autoload :neo-tree.sources.common.commands))

(fn git/stage-unstage [state]
  "
  Stage or unstage the file under the cursor depending on its current status.

  Equivatent to fugitive's mapping for the - key in the fugitive buffer.
  "

  (local path (get (state.tree:get_node) :path))
  (local status (get state.git_status_lookup path))

  (when (or (string.match status :?)
            (= status " M"))
    (commands.git_add_file state)
    (lua :return))

  (when (or (string.match status :A)
            (string.match status :M))
    (commands.git_unstage_file state)
    (lua :return))

  (vim.notify (.. "unhandled status: " status)
              vim.log.levels.DEBUG
              {:icon :
               :title "custom neo-tree commands"}))

[(use :s1n7ax/nvim-window-picker {:event :VeryLazy
                                  :config true})
 (use :nvim-neo-tree/neo-tree.nvim
      {:branch :v3.x
       :dependencies [:nvim-lua/plenary.nvim
                      :kyazdani42/nvim-web-devicons
                      :MunifTanjim/nui.nvim
                      :s1n7ax/nvim-window-picker]
       :opts {:hide_hidden false
              :window {:mappings {:- (use git/stage-unstage {:desc :stage/unstage})
                                  :X (use :git_revert_file {:desc :revert})}}}})]
