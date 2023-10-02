(import-macros {: nmap} :own.macros)
(local telescope (require :telescope))

(telescope.setup {:defaults {:layout_strategy :horizontal
                             :layout_config {:horizontal {:prompt_position :top
                                                          :preview_width 0.55
                                                          :results_width 0.8}
                                             :vertical {:mirror false}
                                             :width 0.87
                                             :height 0.80
                                             :preview_cutoff 120}
                             :sorting_strategy :ascending
                             :prompt_prefix "   "
                             :selection_caret " "
                             :set_env {:COLORTERM true}
                             :vimgrep_arguments [:ag :--nocolor :--vimgrep :--smart-case]
                             :results_title false}
                  :pickers {:buffers {:sort_mru true}}})

(nmap :<M-x> ::Telescope<CR> {:nowait true})
(nmap :<D-x> ::Telescope<CR> {:nowait true})
