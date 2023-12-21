(import-macros {: use} :own.macros)

(use :nvim-neorg/neorg {:build ":Neorg sync-parsers"
                        :dependencies [:nvim-lua/plenary.nvim
                                       :nvim-treesitter/nvim-treesitter]
                        :ft :norg
                        :mod :neorg
                        :opts {:load {:core.defaults {}
                                             :core.concealer {}
                                             :core.completion {:config {:engine :nvim-cmp}}
                                             :core.integrations.treesitter {:config {:configure_parsers true
                                                                                     :install_parsers true}}
                                             :core.export {:config {:export_dir :/tmp/}}
                                             :core.export.markdown {:config {:extension :.md}}
                                             :core.dirman {:config {:workspaces {:notes "~/Documents/neorg"}}}
                                             :core.mode {}}}
                        :config (fn [_ opts]
                                  (if (~= vim.re nil)
                                     (tset opts.load :core.ui.calendar {})
                                     (tset opts.load :core.ui.calendar.views.monthly {})
                                     (tset opts.load :core.tempus {})))})
