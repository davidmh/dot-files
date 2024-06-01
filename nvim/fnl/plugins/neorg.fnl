(import-macros {: use} :own.macros)

[(use :vhyrro/luarocks.nvim {:ft :norg
                             :config true})
 (use :nvim-neorg/neorg {:dependencies [:vhyrro/luarocks.nvim]
                         :ft :norg
                         :cmd :Neorg
                         :version :*
                         :opts {:load {:core.defaults {}
                                       :core.concealer {}
                                       :core.integrations.treesitter {:config {:configure_parsers true
                                                                               :install_parsers true}}
                                       :core.journal {:config {:workspace :notes}}
                                       :core.export {:config {:export_dir :/tmp/}}
                                       :core.export.markdown {:config {:extension :.md}}
                                       :core.dirman {:config {:workspaces {:notes "~/Documents/neorg"}}}
                                       :core.mode {}
                                       :core.ui.calendar {}}}})]
