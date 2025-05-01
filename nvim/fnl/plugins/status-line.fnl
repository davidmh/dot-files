(import-macros {: augroup : use} :own.macros)
(local lazy-status (require :lazy.status))
(local {: autoload} (require :nfnl.module))

(local heirline (autoload :heirline))
(local conditions (autoload :heirline.conditions))
(local palettes (autoload :catppuccin.palettes))
(local config (autoload :own.config))
(local mode (autoload :own.mode))

(local empty-space {:provider " "})

(fn component [data]
  (vim.validate {:init [data.init :function]})
  (table.insert data {:provider #(-> $1.icon) :hl #(-> {:fg $1.color})})
  (table.insert data {:provider #(-> $1.content) :hl {:fg :fg}})
  (table.insert data {:hl {:bold true}})
  data)

(local vi-mode {:condition #(and
                              (not= vim.o.filetype :toggleterm)
                              (not= vim.o.filetype :starter))
                :provider #(.. " " (mode.get-label) " ")
                :hl #(-> {:fg (mode.get-color)
                          :bold true})
                :update [:ModeChanged :ColorScheme]})

(local push-right {:provider "%="})

(fn diagnostic [severity-code color]
  {:provider #(.. " " (. config.icons severity-code) " " (. $1 severity-code))
   :condition #(> (. $1 severity-code) 0)
   :hl {:fg color}
   :event :DiagnosticChanged})

(fn diagnostic-count [severity-code]
  (length (vim.diagnostic.get 0 {:severity (. vim.diagnostic.severity severity-code)})))

(local diagnostics-block (use (diagnostic :ERROR :red)
                              (diagnostic :WARN :yellow)
                              (diagnostic :INFO :fg)
                              (diagnostic :HINT :green)
                              empty-space
                              {:conditon #(conditions.has_diagnostics)
                               :init (fn [self]
                                       (tset self :ERROR (diagnostic-count :ERROR))
                                       (tset self :WARN (diagnostic-count :WARN))
                                       (tset self :INFO (diagnostic-count :INFO))
                                       (tset self :HINT (diagnostic-count :HINT)))
                               :update [:DiagnosticChanged :BufEnter :ColorScheme]}))

(local git-block (component {:condition #(conditions.is_git_repo)
                             :init #(do (local {: head : root} vim.b.gitsigns_status_dict)
                                        (local cwd-relative-path (-> (vim.fn.getcwd)
                                                                     (string.gsub (vim.fn.fnamemodify root ":h") "")
                                                                     (string.gsub "^/" "")))
                                        (local status (vim.trim (or vim.b.gitsigns_status "")))
                                        (tset $1 :icon :)
                                        (tset $1 :color :rosewater)
                                        (tset $1 :content (table.concat [(.. " [" cwd-relative-path "]") head status] " ")))
                             :hl {:bold true}}))

(local plugin-updates [(component {:init #(let [[icon count] (-> (lazy-status.updates)
                                                                 (vim.split " "))]
                                            (tset $1 :icon (.. " " icon))
                                            (tset $1 :content (.. " " count))
                                            (tset $1 :color :rosewater))
                                   :condition #(lazy-status.has_updates)})])

(local statusline (use vi-mode
                       push-right
                       diagnostics-block
                       git-block
                       plugin-updates
                       empty-space
                       {:hl {:bg :NONE}}))

(fn initialize-heirline []
  (set vim.o.showmode false)

  (local opts {:colors (palettes.get_palette)})

  (heirline.setup {: statusline
                   : opts}))

(comment (initialize-heirline))

(augroup :update-heirline [:ColorScheme {:pattern :*
                                         :callback initialize-heirline}])

(use :rebelot/heirline.nvim {:dependencies [:nvim-tree/nvim-web-devicons
                                            :catppuccin]
                             :event :VeryLazy
                             :config initialize-heirline})
