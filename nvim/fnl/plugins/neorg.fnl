(import-macros {: use} :own.macros)

(use :nvim-neorg/neorg {:build ":Neorg sync-parsers"
                        :dependencies [:nvim-lua/plenary.nvim
                                       :nvim-treesitter/nvim-treesitter
                                       (use :folke/zen-mode.nvim {:opts {:window {:width 100}}})]
                        :event :VeryLazy
                        :opts {:load {:core.defaults {}
                                      :core.concealer {}
                                      :core.completion {:config {:engine :nvim-cmp}}
                                      :core.integrations.treesitter {:config {:configure_parsers true
                                                                              :install_parsers true}}
                                      :core.journal {:config {:workspace :notes}}
                                      :core.export {:config {:export_dir :/tmp/}}
                                      :core.export.markdown {:config {:extension :.md}}
                                      :core.dirman {:config {:workspaces {:notes "~/Documents/neorg"}}}
                                      :core.mode {}
                                      :core.ui.calendar {}
                                      :core.ui.calendar.views.monthly {}
                                      :core.tempus {}
                                      :core.presenter {:config {:zen_mode :zen-mode}}}}})
