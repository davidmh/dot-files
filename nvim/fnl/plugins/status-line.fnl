(import-macros {: augroup : tx} :own.macros)
(local {: autoload} (require :nfnl.module))

(local heirline (autoload :heirline))
(local conditions (autoload :heirline.conditions))
(local config (autoload :own.config))
(local colors (autoload :own.colors))
(local mode (autoload :own.mode))

(local empty-space {:provider " "})

(fn component [data]
  (vim.validate :init data.init :function)
  (table.insert data {:provider #(-> $1.icon) :hl #(-> {:fg $1.color})})
  (table.insert data {:provider #(-> $1.content) :hl {:fg :fg}})
  (table.insert data {:hl {:bold true}})
  data)

(local vi-mode {:provider #(.. " " (mode.get-label) " ")
                :hl #(-> {:fg (mode.get-color)
                          :bold true})
                :update [:ModeChanged :ColorScheme]})

(local push-right {:provider "%="})

(fn diagnostic [severity-code]
  {:provider #(.. " " (. config.icons severity-code) " " (. $1 severity-code))
   :condition #(> (. $1 severity-code) 0)
   :hl {:fg (string.lower severity-code)}
   :event :DiagnosticChanged})

(fn diagnostic-count [severity-code]
  (length (vim.diagnostic.get 0 {:severity (. vim.diagnostic.severity severity-code)})))

(local diagnostics-block (tx (diagnostic :ERROR)
                             (diagnostic :WARN)
                             (diagnostic :INFO)
                             (diagnostic :HINT)
                             empty-space
                             {:condition #(conditions.has_diagnostics)
                              :init #(do
                                       (set $1.ERROR (diagnostic-count :ERROR))
                                       (set $1.WARN (diagnostic-count :WARN))
                                       (set $1.INFO (diagnostic-count :INFO))
                                       (set $1.HINT (diagnostic-count :HINT)))
                              :update [:DiagnosticChanged :BufEnter :ColorScheme]}))

(local git-block (component {:condition #(conditions.is_git_repo)
                             :init #(do (local {: head : root} vim.b.gitsigns_status_dict)
                                        (local cwd-relative-path (-> (vim.fn.getcwd)
                                                                     (string.gsub (vim.fn.fnamemodify root ":h") "")
                                                                     (string.gsub "^/" "")))
                                        (local status (vim.trim (or vim.b.gitsigns_status "")))
                                        (set $1.icon "")
                                        (set $1.color :git)
                                        (set $1.content (table.concat [(.. " [" cwd-relative-path "]") head status] " ")))
                             :hl {:bold true}}))

(local statusline [vi-mode
                   push-right
                   diagnostics-block
                   git-block
                   empty-space])

(fn initialize-heirline []
  (set vim.o.showmode false)

  (local opts {:colors (colors.get-colors)})

  (heirline.setup {: statusline
                   : opts}))

(comment (initialize-heirline))

(augroup :update-heirline [:ColorScheme {:pattern :*
                                         :callback initialize-heirline}])

(tx :rebelot/heirline.nvim {:dependencies [:nvim-tree/nvim-web-devicons]
                            :event :VeryLazy
                            :config initialize-heirline})
