(module own.plugin.status-lines
  {autoload {nvim aniseed.nvim
             core aniseed.core
             str aniseed.string
             lists own.lists
             heirline heirline
             conditions heirline.conditions
             utils heirline.utils
             palettes catppuccin.palettes
             navic nvim-navic
             nvim-web-devicons nvim-web-devicons}})

(def- colors (palettes.get_palette))

(def- chrome-accent :mantle)

(defn- starts-with [text prefix]
  (= (string.sub text 0 (length prefix))
     prefix))

(def- subscript [:₀ :₁ :₂ :₃ :₄ :₅ :₆ :₇ :₈ :₉])
(def- digit-to-sub #(. subscript (+ $1 1)))
(defn- number-to-sub [num]
  (local result {:val ""})
  (let [num-str (tostring num)]
    (for [i 1 (length num-str)]
      (tset result :val
         (->> (string.sub num-str i i)
              (digit-to-sub)
              (.. result.val))))
    result.val))

(defn- container [components]
  (let [solid-background {:hl {:fg :fg :bg chrome-accent}}]
    [{:provider :
      :hl {:fg chrome-accent :bg :none}}
     (core.merge solid-background components)
     {:provider :
      :hl {:fg chrome-accent :bg :none}}]))

(def- vi-mode {:init #(tset $1 :mode (vim.fn.mode 1))
               :static {:mode_colors {:n    :fg
                                      :i    :green
                                      :v    :cyan
                                      :V    :cyan
                                      "\22" :cyan
                                      :c    :orange
                                      :s    :purple
                                      :S    :purple
                                      "\19" :purple
                                      :R    :orange
                                      :r    :orange
                                      :!    :red
                                      :t    :red}}
               :provider " "
               :hl #(-> {:fg (. $1.mode_colors $1.mode)
                         :bold true})
               :update {1 :ModeChanged
                        :pattern :*:*
                        :callback (vim.schedule_wrap #(vim.cmd :redrawstatus))}})

; (def- file-name-block-base {:init #(tset $1 :file-name (nvim.buf_get_name 0))
;                             :provider :%=})
(def- file-icon {:init #(let [file-name $1.file-name
                              ext (vim.fn.fnamemodify file-name ::e)
                              (icon color) (nvim-web-devicons.get_icon_color file-name ext {:default true})]
                          (tset $1 :icon icon)
                          (tset $1 :color color))
                 :provider #(and $1.icon (.. $1.icon " "))
                 :hl #(-> {:fg $1.color})})

(def- file-name {:provider #(let [file-name (vim.fn.fnamemodify (nvim.buf_get_name 0) ::.)]
                              (if (= file-name "")
                                "[no name]"
                                (if (conditions.width_percent_below (length file-name) 0.25)
                                  file-name
                                  (vim.fn.pathshorten
                                    (if (starts-with file-name vim.env.HOME)
                                      (.. "~" (string.sub file-name (+ (length vim.env.HOME) 1)))
                                      file-name)
                                    2))))
                 :hl #(when vim.bo.modified
                        {:fg :fg
                         :bold true
                         :force true})})

(def- modified? {:condition #(-> vim.bo.modified)
                 :provider " [+]"
                 :hl {:fg :green}})

(def- read-only? {:condition #(or (not vim.bo.modifiable) vim.bo.readonly)
                  :provider " "
                  :hl {:fg :orange}})

(def- file-flags [modified? read-only?])


(def- file-name-block (container {:init #(tset $1 :file-name (nvim.buf_get_name 0))
                                  1 file-icon
                                  2 file-name
                                  3 file-flags}))

(def- lsp-breadcrumb {:condition #(and (navic.is_available)
                                       (> (length (navic.get_location)) 0))
                      :hl {:fg :fg}
                      1 (container {:provider #(navic.get_location {:highlight true})})})

(def- lsp {:condition #(conditions.lsp_attached)
           :update [:LspAttach :LspDetach]
           :provider (fn []
                       (let [names (vim.tbl_map #(. $1 :name)
                                                (vim.lsp.get_active_clients {:bufnr 0}))]
                         (.. " [" (table.concat names " ") "]")))
           :hl {:fg :green
                :bold true}})

(def- dead-space {:provider "             "})
(def- push-right {:provider "%="})

(defn- diagnostic [severity-code color]
  {:provider #(.. " " (number-to-sub (. $1 severity-code) " "))
   :condition #(> (. $1 severity-code) 0)
   :hl {:fg color}})

(defn- diagnostic-count [severity-code]
  (length (vim.diagnostic.get 0 {:severity (. vim.diagnostic.severity severity-code)})))

(def- diagnostics-block {:conditon conditions.has_diagnostics
                         :init (fn [self]
                                 (tset self :ERROR (diagnostic-count :ERROR))
                                 (tset self :WARN (diagnostic-count :WARN))
                                 (tset self :INFO (diagnostic-count :INFO))
                                 (tset self :HINT (diagnostic-count :HINT)))
                         :update [:DiagnosticChanged :BufEnter]
                         1 (diagnostic :ERROR :red)
                         2 (diagnostic :WARN :yellow)
                         3 (diagnostic :INFO :fg)
                         4 (diagnostic :HINT :green)})

(defn- has-git-diff [kind]
  #(> (core.get-in $1 [:git kind] 0) 0))

(def- git-block {:condition conditions.is_git_repo
                 :init #(do (tset $1 :git vim.b.gitsigns_status_dict))
                 :hl {:bg chrome-accent}
                 1 (container [{:provider #(.. " " $1.git.head)}
                               {:provider #(.. " +" $1.git.added)
                                :condition (has-git-diff :added)}
                               {:provider #(.. " ±" $1.git.changed)
                                :condition (has-git-diff :changed)}
                               {:provider #(.. " −" $1.git.removed)
                                :condition (has-git-diff :removed)}])})

(def- line-number {:provider "%2{&nu ? (&rnu && v:relnum ? v:relnum : v:lnum) : ''}"
                   :condition #(-> vim.o.number)})

(def- fold {:provider #(let [line-num vim.v.lnum]
                        (if (> (vim.fn.foldlevel line-num)
                               (vim.fn.foldlevel (- line-num 1)))
                           (if (= (vim.fn.foldclosed line-num) -1)
                             " " " ")))})

; TODO: split gitsigns, breakpoints and diagnostics into separate columns
(def- signs {:provider :%s})

(def- statuscolumn [fold
                    push-right
                    line-number
                    signs])

(def- winbar [lsp-breadcrumb
              dead-space
              push-right
              file-name-block])

(def- statusline {:hl {:bg :NONE}
                  1 vi-mode
                  2 git-block
                  3 dead-space
                  4 push-right
                  5 diagnostics-block})

(defn- disable_winbar_cb [{: buf}]
  (conditions.buffer_matches {:buftype [:nofile :prompt :help :quickfix]
                              :filetype [:^git.* :fugitive :Trouble]}
                             buf))

(def- opts {: colors
            : disable_winbar_cb})

(heirline.setup {: winbar
                 : statuscolumn
                 : statusline
                 : opts})
