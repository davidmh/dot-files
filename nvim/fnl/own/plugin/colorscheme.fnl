(module own.plugin.colorscheme
  {autoload {core aniseed.core
             nvim aniseed.nvim
             catppuccin catppuccin
             palette catppuccin.palettes
             notify notify
             {: custom-highlights } own.plugin.highlights}})

(catppuccin.setup {:flavour :mocha
                   :transparent_background false
                   :term_colors true
                   :integrations {:lsp_trouble true
                                  :telescope true
                                  :which_key true}
                   :custom_highlights custom-highlights})

(vim.cmd.colorscheme :catppuccin)

(def- home-manager-path (vim.fn.expand "~/.config/home-manager/"))
(def- wezterm-config-path (.. home-manager-path "wezterm.lua"))
(def- nvim-colorscheme-path (.. home-manager-path "nvim/fnl/own/plugin/colorscheme.fnl"))

(defn- capitalize [text]
  (let [first-letter (text:sub 1 1)
        rest (text:sub 2)]
    (.. (first-letter:upper) rest)))

(defn- symbolize [text]
  (.. :: text))

(defn- get-wezterm-catppuccin-flavor []
  (let [(_ _ flavor) (-> wezterm-config-path
                        (core.slurp)
                        (string.lower)
                        (string.find "color_scheme = 'catppuccin (%w*)'"))]
    flavor))

(defn- get-nvim-catppuccin-flavor []
  (let [(_ _ flavor) (-> nvim-colorscheme-path
                         (core.slurp)
                         (string.find ":flavour :(%w*)"))]
    flavor))

(defn- update-colorscheme [new-flavor]
  (vim.cmd (.. "Catppuccin " new-flavor)))

(defn- update-file-content [path from to]
  (let [updated-content (-> path
                            (core.slurp)
                            (string.gsub from to))]
    (core.spit path updated-content)))

(defn- on-wezterm-config-change []
  (let [new-flavor (get-wezterm-catppuccin-flavor)]
    (when (not= new-flavor catppuccin.flavour)
      (update-file-content nvim-colorscheme-path
                           (symbolize catppuccin.flavour)
                           (symbolize new-flavor))
      (update-colorscheme new-flavor))))

(defn- on-nvim-config-change []
  (let [(_ _ new-flavor) (-> (vim.fn.bufnr)
                             (nvim.buf_get_lines 0 -1 false)
                             (table.concat)
                             (string.find ":flavour :(%w*)"))
        wezterm-flavor (get-wezterm-catppuccin-flavor)]
    (when (not= new-flavor wezterm-flavor)
      (update-file-content wezterm-config-path
                           (capitalize wezterm-flavor)
                           (capitalize new-flavor))
      (update-colorscheme new-flavor))))

(defn- on-update-from-command []
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
                           (symbolize new-flavor)))))

(nvim.create_augroup :update-colorscheme {:clear true})

(nvim.create_autocmd :BufWritePost {:pattern wezterm-config-path
                                    :callback on-wezterm-config-change
                                    :group :update-colorscheme})

(nvim.create_autocmd :BufWritePost {:pattern nvim-colorscheme-path
                                    :callback on-nvim-config-change
                                    :group :update-colorscheme})

(nvim.create_autocmd :ColorScheme {:pattern :*
                                   :callback on-update-from-command
                                   :group :update-colorscheme})
