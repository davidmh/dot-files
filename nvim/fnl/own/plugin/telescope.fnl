(module own.plugin.telescope
  {autoload {nvim aniseed.nvim
             telescope telescope}})

(telescope.setup {:defaults {:layout_strategy :horizontal
                             :layout_config {:horizontal {:prompt_position :top
                                                          :preview_width 0.55
                                                          :results_width 0.8}
                                             :vertical {:mirror false}
                                             :width 0.87
                                             :height 0.80
                                             :preview_cutoff 120}
                             :sorting_strategy :ascending
                             :prompt_prefix " "
                             :selection_caret "❯ "
                             :set_env {:COLORTERM true}
                             :vimgrep_arguments [:ag :--nocolor :--vimgrep :--smart-case]}
                  :pickers {:buffers {:sort_mru true}}})

(telescope.load_extension :notify)
(vim.keymap.set :n :<M-x> ::Telescope<CR> {:nowait true})
(vim.keymap.set :n :<D-x> ::Telescope<CR> {:nowait true})
