(module own.plugin.colorscheme
  {autoload {catppuccin catppuccin
             palette catppuccin.palettes}})

(set vim.g.catppuccin_flavour :macchiato)
(catppuccin.setup {:transparent_background false
                   :term_colors true
                   :integrations {:lsp_trouble true
                                  :telescope true
                                  :which_key true}})

(vim.cmd.colorscheme :catppuccin)

(defn- set-hl [name colors]
  (vim.api.nvim_set_hl 0 name colors))

(let [color (palette.get_palette)
      accent color.blue]
  (set-hl :TelescopeBorder {:fg color.crust :bg color.crust})
  (set-hl :TelescopePromptBorder {:fg color.crust :bg color.crust})
  (set-hl :TelescopePromptNormal {:bg color.crust})
  (set-hl :TelescopePromptPrefix {:fg accent :bg color.crust})
  (set-hl :TelescopeNormal {:bg color.crust})
  (set-hl :TelescopePreviewTitle {:fg color.crust :bg color.crust})
  (set-hl :TelescopePromptTitle {:fg color.crust :bg accent})
  (set-hl :TelescopeResultsNormal { :bg color.mantle})
  (set-hl :TelescopeResultsBorder {:fg color.mantle :bg color.mantle})
  (set-hl :TelescopeSelection {:bg color.crust :fg accent})
  (set-hl :TelescopeSelectionCaret  {:fg accent})
  (set-hl :TelescopeResultsDiffAdd {:fg color.green})
  (set-hl :TelescopeResultsDiffChange {:fg color.yellow})
  (set-hl :TelescopeResultsDiffDelete {:fg color.red}))
