(import-macros {: augroup : use} :own.macros)
(local lazy-status (require :lazy.status))
(local {: autoload} (require :nfnl.module))

(local heirline (autoload :heirline))
(local conditions (autoload :heirline.conditions))
(local core (autoload :nfnl.core))
(local palettes (autoload :catppuccin.palettes))
(local config (autoload :own.config))

(local empty-space {:provider " "})

(fn component [data]
  (vim.validate {:init [data.init :function]})
  (table.insert data {:provider #(-> $1.icon) :hl #(-> {:fg $1.color})})
  (table.insert data {:provider #(-> $1.content) :hl {:fg :fg}})
  (table.insert data {:hl {:bold true}})
  data)

(local mode-colors {:n    :fg
                    :i    :green
                    :v    :blue
                    :V    :cyan
                    "\22" :cyan
                    :c    :orange
                    :s    :purple
                    :S    :purple
                    "\19" :purple
                    :R    :orange
                    :r    :orange
                    :!    :red
                    :t    :green})

(local mode-label {:n    :NORMAL
                   :i    :INSERT
                   :v    :VISUAL
                   :V    :V-LINE
                   "\22" :V-BLOCK
                   :c    :COMMAND
                   :s    :SELECT
                   :S    :S-LINE
                   "\19" :S-BLOCK
                   :R    :REPLACE
                   :r    :REPLACE
                   :!    :SHELL
                   :t    :TERMINAL
                   :nt   :T-NORMAL})

(local vi-mode {:init #(tset $1 :mode (vim.fn.mode 1))
                :condition #(not= vim.o.filetype :starter)
                :provider #(.. (core.get mode-label $1.mode $1.mode) " ")
                :hl #(-> {:fg (. mode-colors $1.mode)
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
