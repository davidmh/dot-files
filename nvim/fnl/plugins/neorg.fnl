(import-macros {: use} :own.macros)

(use :nvim-neorg/neorg {:version :*
                        :lazy false
                        :opts {:load {:core.defaults {}
                                      :core.concealer {}
                                      :core.integrations.treesitter {:config {:configure_parsers true
                                                                              :install_parsers true}}
                                      :core.journal {:config {:workspace :notes}}
                                      :core.export {:config {:export_dir :/tmp/}}
                                      :core.export.markdown {:config {:extension :.md}}
                                      :core.dirman {:config {:workspaces {:notes "~/Documents/neorg"
                                                                          :remix "~/Documents/neorg/remix"}}}
                                      :core.ui.calendar {}}}})
