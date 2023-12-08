(local neorg (require :neorg))

(local options {:load {:core.defaults {}
                       :core.concealer {}
                       :core.completion {:config {:engine :nvim-cmp}}
                       :core.integrations.treesitter {:config {:configure_parsers true
                                                               :install_parsers true}}
                       :core.export {:config {:export_dir :/tmp/}}
                       :core.export.markdown {:config {:extension :.md}}
                       :core.dirman {:config {:workspaces {:notes "~/Documents/neorg"}}}
                       :core.mode {}}})

(if (~= vim.re nil)
  (tset options.load :core.ui.calendar {})
  (tset options.load :core.ui.calendar.views.monthly {})
  (tset options.load :core.tempus {}))

(neorg.setup options)
