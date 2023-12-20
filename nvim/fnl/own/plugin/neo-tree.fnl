(local core (require :nfnl.core))
(local neo-tree (require :neo-tree))
(local commands (require :neo-tree.sources.common.commands))

(fn git/stage-unstage [state]
  "
  Stage or unstage the file under the cursor depending on its current status.

  Equivatent to fugitive's mapping for the - key in the fugitive buffer.
  "

  (local path (core.get (state.tree:get_node) :path))
  (local status (core.get state.git_status_lookup path))

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

(neo-tree.setup {:hide_hidden false
                 :window {:mappings {:- {1 git/stage-unstage :desc :stage/unstage}
                                     :X {1 :git_revert_file :desc :revert}}}})
