(import-macros {: tx} :own.macros)
(local {: custom-highlights} (require :own.highlights))
(local {: autoload} (require :nfnl.module))
(local catppuccin (autoload :catppuccin))

(tx :catppuccin/nvim {:name :catppuccin
                      :config #(let [flavor :frappe]
                                 (catppuccin.setup {:flavour flavor
                                                    :float {:solid true}
                                                    :term_colors true
                                                    :integrations {:which_key true}
                                                    :custom_highlights custom-highlights
                                                    :styles {:comments [:italic]}})
                                 (vim.cmd (table.concat [:Catppuccin flavor] " ")))})
