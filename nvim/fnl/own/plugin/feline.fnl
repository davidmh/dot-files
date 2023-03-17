(module own.plugin.feline
  {autoload {core aniseed.core
             str aniseed.string
             lists own.lists
             config own.config
             feline feline
             git-provider feline.providers.git
             catppuccin catppuccin.palettes
             neotest neotest
             utils null-ls.utils
             web-dev-icons nvim-web-devicons}})

(web-dev-icons.set_icon {:fnl {:icon :}})

(def- git-root (utils.root_pattern :.git))
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

(defn- get-diagnostic-count [severity-code]
  (length (vim.diagnostic.get 0 {:severity severity-code})))

(defn- diagnostic [severity-code color]
  {:hl {:fg color}
   :enabled #(> (get-diagnostic-count severity-code) 0)
   :provider #(.. " " (number-to-sub (get-diagnostic-count severity-code) " "))})

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

(def- venv {:provider #(let [root (.. (git-root vim.env.VIRTUAL_ENV) :/)
                             workspace (. (str.split vim.env.VIRTUAL_ENV root) 2)]
                         (.. "(" workspace ") "))
            :enabled #(not (core.empty? vim.env.VIRTUAL_ENV))})

(defn- status [obj name icon]
  (let [count (. obj name)]
    (if (> count 0)
      (.. " " icon " " (number-to-sub count))
      "")))

(defn- format-status [counts adapter-name]
  (.. (-> adapter-name
          (str.split ::) (. 1)
          (str.split :-) (. 2))
      (status counts :running :)
      (status counts :skipped :)
      (status counts :passed :)
      (status counts :failed :)
      ; (status counts :total :)
      " "))

(defn- starts-with [prefix str]
  (= prefix (string.sub str 1 (string.len prefix))))

(defn- get-adapter-id []
  (-?>> (neotest.state.adapter_ids)
        (lists.find #(starts-with (-> $1 (str.split ::) (. 2))
                                  (vim.fn.expand :%:p)))))

(defn- neotest-provider []
  (let [adapter (get-adapter-id)
        adapter-name (-?> adapter
                          (str.split ::)
                          (. 1))]
    (-?> adapter
         (neotest.state.status_counts)
         (format-status adapter-name))))

(def- neotest-status {:provider neotest-provider
                      :icon " ﭧ "
                      :enabled #(-> (get-adapter-id)
                                    (~= nil))})

(defn get-theme []
  (let [colors (catppuccin.get_palette)]
    (vim.tbl_extend :force colors {:fg colors.subtext0
                                   :bg :NONE})))

(feline.setup {:components {:active [[venv
                                      git-branch
                                      git-add
                                      git-change
                                      git-remove
                                      neotest-status]
                                     [(diagnostic :ERROR :red)
                                      (diagnostic :WARN :yellow)
                                      (diagnostic :INFO :fg)
                                      (diagnostic :HINT :teal)]]
                             :inactive [[] []]}
               :theme (get-theme)})

(feline.winbar.setup {:components {:active [[] [file-info]]
                                   :inactive [[] [file-info]]}
                      :disable {:filetypes [:packer :fugitive :fugitiveblame :toggleterm]}})
