(import-macros {: augroup} :own.macros)

(local core (require :nfnl.core))
(local config (require :nfnl.config))
(local compile (require :nfnl.compile))
(local catppuccin (require :catppuccin))
(local {: custom-highlights} (require :own.plugin.highlights))

(local root-dir (vim.fn.stdpath :config))
(local {: cfg} (config.find-and-load root-dir))

(catppuccin.setup {:flavour :macchiato
                   :transparent_background false
                   :term_colors true
                   :integrations {:lsp_trouble true
                                  :telescope true
                                  :which_key true}
                   :custom_highlights custom-highlights})

(vim.cmd.colorscheme :catppuccin)

(local home-manager-path (vim.fn.expand "~/.config/home-manager/"))
(local wezterm-config-path (.. home-manager-path "wezterm.lua"))
(local nvim-colorscheme-path (.. home-manager-path "nvim/fnl/own/plugin/colorscheme.fnl"))

(fn capitalize [text]
  (let [first-letter (text:sub 1 1)
        rest (text:sub 2)]
    (.. (first-letter:upper) rest)))

(fn symbolize [text]
  (.. :: text))

(fn get-wezterm-catppuccin-flavor []
  (let [(_ _ flavor) (-> wezterm-config-path
                        (core.slurp)
                        (string.lower)
                        (string.find "color_scheme = 'catppuccin (%w*)'"))]
    flavor))

(fn get-nvim-catppuccin-flavor []
  (let [(_ _ flavor) (-> nvim-colorscheme-path
                         (core.slurp)
                         (string.find ":flavour :(%w*)"))]
    flavor))

(fn update-colorscheme [new-flavor]
  (vim.cmd (.. "Catppuccin " new-flavor)))

; nfnl compiles the file on save, but when updating the colorscheme, this file
; may not be open, so we need to recompile it manually
(fn recompile-colorscheme []
  (compile.into-file {: cfg
                      : root-dir
                      :path nvim-colorscheme-path
                      :source (core.slurp nvim-colorscheme-path)}))

(fn update-file-content [path from to]
  (let [updated-content (-> path
                            (core.slurp)
                            (string.gsub from to))]
    (core.spit path updated-content)))

(fn on-wezterm-config-change []
  (let [new-flavor (get-wezterm-catppuccin-flavor)]
    (when (not= new-flavor catppuccin.flavour)
      (update-file-content nvim-colorscheme-path
                           (symbolize catppuccin.flavour)
                           (symbolize new-flavor))
      (recompile-colorscheme)
      (update-colorscheme new-flavor))))

(fn on-nvim-config-change []
  (let [(_ _ new-flavor) (-> (vim.fn.bufnr)
                             (vim.api.nvim_buf_get_lines 0 -1 false)
                             (table.concat)
                             (string.find ":flavour :(%w*)"))
        wezterm-flavor (get-wezterm-catppuccin-flavor)]
    (when (not= new-flavor wezterm-flavor)
      (update-file-content wezterm-config-path
                           (capitalize wezterm-flavor)
                           (capitalize new-flavor))
      (update-colorscheme new-flavor))))

(fn on-update-from-command []
  (let [new-flavor catppuccin.flavour
        wezterm-flavor (get-wezterm-catppuccin-flavor)
        nvim-flavor (get-nvim-catppuccin-flavor)]
    (when (not= new-flavor wezterm-flavor)
      (update-file-content wezterm-config-path
                           (capitalize wezterm-flavor)
                           (capitalize new-flavor)))
    (when (not= new-flavor nvim-flavor)
      (update-file-content nvim-colorscheme-path
                           (symbolize nvim-flavor)
                           (symbolize new-flavor))
      (recompile-colorscheme))))

(augroup :update-colorscheme [:BufWritePost {:pattern wezterm-config-path
                                             :callback on-wezterm-config-change}]
                             [:BufWritePost {:pattern nvim-colorscheme-path
                                             :callback on-nvim-config-change}]
                             [:ColorScheme  {:pattern :*
                                             :callback on-update-from-command}])
