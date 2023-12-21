(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local mini-starter (autoload :mini.starter))
(local projects (autoload :own.projects))

(local config #(mini-starter.setup {:header ""
                                    :items [(projects.recent-projects)
                                            (mini-starter.sections.recent_files 10 false true)
                                            (mini-starter.sections.builtin_actions)]
                                    :footer ""}))

(use :echasnovski/mini.starter {:version :*
                                :event :VimEnter
                                :config config
                                :keys [(use :<localleader>s #(mini-starter.open) {:desc "Open Starter"})]})
