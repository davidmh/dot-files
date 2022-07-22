(module own.plugin.colorscheme
  {autoload {catppuccin catppuccin
             palette catppuccin.palettes}})

(set vim.g.catppuccin_flavour :frappe)
(catppuccin.setup {:transparent_background false
                   :term_colors true
                   :integrations {:lsp_trouble true
                                  :telescope true
                                  :which_key true}})

(vim.cmd "colorscheme catppuccin")

(def- color (palette.get_palette))

; catppuccin introduced this awesome update for telescope, but some people
; didn't like it, so I'm doing it here
; Revert: https://github.com/catppuccin/nvim/pull/191
; Original: https://github.com/catppuccin/nvim/pull/138

(vim.api.nvim_set_hl 0 :TelescopePromptPrefix { :bg color.crust})
(vim.api.nvim_set_hl 0 :TelescopePromptNormal { :bg color.crust})
(vim.api.nvim_set_hl 0 :TelescopeResultsNormal { :bg color.mantle})
(vim.api.nvim_set_hl 0 :TelescopePreviewNormal { :bg color.crust})
(vim.api.nvim_set_hl 0 :TelescopePromptBorder { :bg color.crust :fg color.crust})
(vim.api.nvim_set_hl 0 :TelescopeResultsBorder { :bg color.mantle :fg color.crust})
(vim.api.nvim_set_hl 0 :TelescopePreviewBorder { :bg color.crust :fg color.crust})
(vim.api.nvim_set_hl 0 :TelescopePromptTitle { :fg color.crust})
(vim.api.nvim_set_hl 0 :TelescopeResultsTitle { :fg color.text})
(vim.api.nvim_set_hl 0 :TelescopePreviewTitle { :fg color.crust})
