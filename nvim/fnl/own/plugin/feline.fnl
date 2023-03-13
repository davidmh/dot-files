(module own.plugin.feline
  {autoload {core aniseed.core
             str aniseed.string
             config own.config
             feline feline
             git-provider feline.providers.git
             catppuccin catppuccin.palettes
             web-dev-icons nvim-web-devicons}})

(web-dev-icons.set_icon {:fnl {:icon :}})

(def- glyphs [:₀ :₁ :₂ :₃ :₄ :₅ :₆ :₇ :₈ :₉])
(def- digit-to-glyph #(. glyphs (+ $1 1)))

(fn number-to-glyph [num]
  (local result {:val ""})
  (let [num-str (tostring num)]
    (for [i 1 (length num-str)]
      (tset result :val
         (->> (string.sub num-str i i)
              (digit-to-glyph)
              (.. result.val))))
    result.val))

(defn- get-diagnostic-count [severity-code]
  (length (vim.diagnostic.get 0 {:severity severity-code})))

(defn- diagnostic [severity-code color]
  {:hl {:fg color}
   :enabled #(> (get-diagnostic-count severity-code) 0)
   :provider #(.. " " (number-to-glyph (get-diagnostic-count severity-code) " "))})

(def- file-info {:provider {:name :file_info
                            :opts {:type :relative
                                   :file_readonly_icon " "
                                   :file_modified_icon :ﱐ}}
                 :hl {:style :bold}})

(def- git-branch {:provider :git_branch
                  :hl {:style :bold}})
(def- git-add {:provider :git_diff_added
               :hl {:fg :fg}
               :icon " +"})
(def- git-change {:provider :git_diff_changed
                  :hl {:fg :fg}
                  :icon " ±"})
(def- git-remove {:provider :git_diff_removed
                  :hl {:fg :fg}
                  :icon " −"})

(defn get-theme []
  (let [colors (catppuccin.get_palette)]
    (vim.tbl_extend :force colors {:fg colors.subtext0
                                   :bg :NONE})))

(feline.setup {:components {:active [[git-branch
                                      git-add
                                      git-change
                                      git-remove]
                                     [(diagnostic :ERROR :red)
                                      (diagnostic :WARN :yellow)
                                      (diagnostic :INFO :fg)
                                      (diagnostic :HINT :teal)]]
                             :inactive [[] []]}
               :theme (get-theme)})

(feline.winbar.setup {:components {:active [[] [file-info]]
                                   :inactive [[] [file-info]]}
                      :disable {:filetypes [:packer :fugitive :fugitiveblame :toggleterm]}})
