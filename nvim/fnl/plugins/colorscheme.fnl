(import-macros {: use} :own.macros)
(local {: custom-highlights} (require :own.highlights))
(local {: autoload} (require :nfnl.module))
(local catppuccin (autoload :catppuccin))

(use :catppuccin/nvim {:name :catppuccin
                       :config (fn []
                                 (catppuccin.setup {:flavour :macchiato
                                                    :transparent_background false
                                                    :term_colors true
                                                    :integrations {:lsp_trouble true
                                                                   :telescope true
                                                                   :which_key true}
                                                    :custom_highlights custom-highlights})
                                 (vim.cmd.colorscheme :catppuccin-macchiato))})
