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
             nvim-web-devicons nvim-web-devicons
             config own.config}})

(def- chrome-accent :crust)

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

(def- mode-colors {:n    :fg
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

(def- not-a-term #(and
                   (not= vim.o.buftype :terminal)
                   (not= vim.o.filetype :toggleterm)))

(def- vi-mode {:init #(tset $1 :mode (vim.fn.mode 1))
               :condition not-a-term
               :provider " "
               :hl #(-> {:fg (. mode-colors $1.mode)
                         :bold true})
               :update [:ModeChanged :ColorScheme]})

(def- macro-rec {:condition #(and (not= (vim.fn.reg_recording) "")
                                  (= vim.o.cmdheight 0))
                 :update [:RecordingEnter :RecordingLeave :ColorScheme]
                 :provider #(.. " [ 壘 -> " (vim.fn.reg_recording) " ] ")
                 :hl {:fg :red :bold true}})

(def- show-cmd {:condition #(= vim.o.cmdheight 0)
                 :init #(set vim.opt.showcmdloc :statusline)
                 :provider "%3.5(%S%)"})

(def- show-search {:condition #(and (= vim.o.cmdheight 0)
                                    (not= vim.v.hlsearch 0)
                                    (-> (vim.fn.searchcount) (. :total) (> 0)))
                   :provider #(let [{: current : total} (vim.fn.searchcount)
                                    direction (if (= vim.v.searchforward 1) : :)
                                    pattern (vim.fn.getreg "/")
                                    counter (.. "[" current :/ total "]")]
                                (.. " " direction " " pattern " " counter))})

(def- clock [(container [{:provider #(vim.fn.strftime "%H:%M")}])])

(defn- sanitize-path [path size]
  (-> path
      (string.gsub vim.env.HOME "~")
      (string.gsub vim.env.REMIX_HOME "remix")
      (vim.fn.pathshorten (or size 2))))

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
                                  (sanitize-path file-name))))
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


(def- file-name-block {:condition #(and (~= vim.o.filetype :fugitiveblame) (not-a-term))
                       1 (container {:init #(tset $1 :file-name (nvim.buf_get_name 0))
                                     1 file-icon
                                     2 file-name
                                     3 file-flags})})

(def- lsp-breadcrumb {:condition #(and (navic.is_available)
                                       (> (length (navic.get_location)) 0))
                      :update [:CursorMoved :ColorScheme]
                      :hl {:fg :fg}
                      1 (container {:provider #(navic.get_location {:highlight true})})})

(def- lsp {:condition #(conditions.lsp_attached)
           :update [:LspAttach :LspDetach :ColorScheme]
           :provider (fn []
                       (let [names (vim.tbl_map #(. $1 :name)
                                                (vim.lsp.get_active_clients {:bufnr 0}))]
                         (.. " [" (table.concat names " ") "]")))
           :hl {:fg :green
                :bold true}})

(def- dead-space {:provider "             "})
(def- push-right {:provider "%="})

(defn- diagnostic [severity-code color]
  {:provider #(.. " " (. config.icons severity-code) " " (. $1 severity-code))
   :condition #(> (. $1 severity-code) 0)
   :hl {:fg color}})

(defn- diagnostic-count [severity-code]
  (length (vim.diagnostic.get 0 {:severity (. vim.diagnostic.severity severity-code)})))

(def- diagnostics-block {:conditon #(conditions.has_diagnostics)
                         :init (fn [self]
                                 (tset self :ERROR (diagnostic-count :ERROR))
                                 (tset self :WARN (diagnostic-count :WARN))
                                 (tset self :INFO (diagnostic-count :INFO))
                                 (tset self :HINT (diagnostic-count :HINT)))
                         :update [:DiagnosticChanged :BufEnter :ColorScheme]
                         1 (diagnostic :ERROR :red)
                         2 (diagnostic :WARN :yellow)
                         3 (diagnostic :INFO :fg)
                         4 (diagnostic :HINT :green)
                         5 {:provider " "}})

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

(def- git-blame {:condition #(= vim.o.filetype :fugitiveblame)
                 1 (container [{:provider "git blame"
                                :hl {:bold true}}])})

(def- term-title {:condition #(not= nil vim.b.term_title)
                  :init #(let [title (-> vim.b.term_title
                                         (string.gsub "term://" "")
                                         (string.gsub ";#toggleterm#%d*" ""))
                               parts (vim.split title "//%d*:")]
                           (tset $1 :path (core.first parts))
                           (tset $1 :command (core.last parts)))
                  1 [(container [{:provider #(sanitize-path $1.path)}
                                 {:provider "  "}
                                 {:provider #(sanitize-path $1.command 3)}])]})

(def- line-number {:provider " %2{&nu ? (&rnu && v:relnum ? v:relnum : v:lnum) : ''} "
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

(def- winbar [term-title
              lsp-breadcrumb
              dead-space
              push-right
              git-blame
              file-name-block])

(def- statusline {:hl {:bg :NONE}
                  1 vi-mode
                  2 macro-rec
                  3 git-block
                  4 dead-space
                  5 push-right
                  6 show-cmd
                  7 diagnostics-block
                  8 show-search
                  9 clock})

(def- disabled-winbar {:buftype [:nofile :prompt :quickfix]
                       :filetype [:^git.* :Trouble]})

(defn- initialize-heirline []
  (local opts {:colors (palettes.get_palette)
               :disable_winbar_cb #(conditions.buffer_matches disabled-winbar $1.buf)})

  (heirline.setup {: winbar
                   : statuscolumn
                   : statusline
                   : opts}))

(initialize-heirline)

(nvim.create_augroup :update-heirline {:clear true})
(nvim.create_autocmd :ColorScheme {:pattern :*
                                   :callback initialize-heirline
                                   :group :update-heirline})
