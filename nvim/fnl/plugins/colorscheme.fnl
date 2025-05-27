(import-macros {: tx} :own.macros)
(local {: custom-highlights} (require :own.highlights))
(local {: autoload} (require :nfnl.module))
(local catppuccin (autoload :catppuccin))

(tx :catppuccin/nvim {:name :catppuccin
                      :config #(let [flavor :frappe]
                                 (catppuccin.setup {:flavour flavor
                                                    :transparent_background false
                                                    :term_colors true
                                                    :integrations {:which_key true}
                                                    :custom_highlights custom-highlights})
                                 (vim.cmd (table.concat [:Catppuccin flavor] " ")))})
