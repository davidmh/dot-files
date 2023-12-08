(local catppuccin (require :catppuccin))
(local {: custom-highlights} (require :own.plugin.highlights))

(catppuccin.setup {:flavour :macchiato
                   :transparent_background false
                   :term_colors true
                   :integrations {:lsp_trouble true
                                  :telescope true
                                  :which_key true}
                   :custom_highlights custom-highlights})

(vim.cmd.colorscheme :catppuccin)
