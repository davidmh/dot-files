(import-macros {: augroup} :own.macros)
(local config (require :nfnl.config))
(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local compile (autoload :nfnl.compile))
(local catppuccin (autoload :catppuccin))

(local nvim-root (vim.fn.expand "~/.config/home-manager/nvim"))
(local {: cfg} (config.find-and-load nvim-root))

(local nvim-colorscheme-path (vim.fn.expand "~/.config/home-manager/nvim/fnl/plugins/colorscheme.fnl"))

(fn symbolize [text]
  (.. :: text))

(fn get-nvim-catppuccin-flavor []
  (let [(_ _ flavor) (-> nvim-colorscheme-path
                         (core.slurp)
                         (string.find "flavor :(%w*)"))]
    flavor))

; nfnl compiles the file on save, but when updating the colorscheme, this file
; may not be open, so we need to recompile it manually
(fn recompile-colorscheme []
  (compile.into-file {: cfg
                      :root-dir nvim-root
                      :path nvim-colorscheme-path
                      :source (core.slurp nvim-colorscheme-path)}))

(fn update-file-content [path from to]
  (let [updated-content (-> path
                            (core.slurp)
                            (string.gsub from to))]
    (core.spit path updated-content)))

(fn on-update-from-command []
  (let [new-flavor catppuccin.flavour
        nvim-flavor (get-nvim-catppuccin-flavor)]
    (when (not= new-flavor nvim-flavor)
      (update-file-content nvim-colorscheme-path
                           (symbolize nvim-flavor)
                           (symbolize new-flavor))
      (recompile-colorscheme)))
  nil)

(augroup :sync-colorscheme [:ColorScheme {:pattern :*
                                          :desc "Persist the colorscheme when using the colorscheme command"
                                          :callback on-update-from-command}])
