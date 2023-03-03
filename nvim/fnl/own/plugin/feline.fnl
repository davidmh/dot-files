(module own.plugin.feline
  {autoload {nvim aniseed.nvim
             core aniseed.core
             config own.config
             feline feline
             lsp feline.providers.lsp
             catppuccin catppuccin.palettes}})

(def- severity-enum vim.diagnostic.severity)

(defn- get-severity [severity-code]
  (core.get vim.diagnostic.severity severity-code))

(defn- needs-leading-space? [previous-severities]
  (core.reduce
    #(or $1 (lsp.diagnostics_exist (get-severity $2)))
    false
    previous-severities))

(defn- diagnostic [severity-code previous-severities]
  (let [previous-severities (or previous-severities [])
        severity (get-severity severity-code)
        icon (core.get config.icons severity-code)
        count (lsp.get_diagnostics_count severity)]
    (if (> count 0)
      (..
        (if (needs-leading-space? previous-severities) " " "")
        icon
        " "
        count)
      "")))

(def- comp {:file_info {:hl {:style :bold :bg :NONE}
                        :provider {:name :file_info
                                   :opts {:type :relative
                                          :file_readonly_icon " "
                                          :file_modified_icon :ﱐ}}}
             :diagnostic {:err {:hl {:fg :red :bg :NONE}
                                :provider #(diagnostic :ERROR)}
                          :warn {:hl {:fg :yellow :bg :NONE}
                                 :provider #(diagnostic :WARN [:ERROR])}
                          :info {:hl {:fg :blue :bg :NONE}
                                 :provider #(diagnostic :INFO [:ERROR :WARN])}
                          :hint {:hl {:fg :fg :bg :NONE}
                                 :provider #(diagnostic :HINT [:ERROR :WARN :INFO])}}
             :git {:branch {:provider :git_branch
                            :hl {:style :bold :bg :NONE}}
                   :add {:provider :git_diff_added
                         :hl {:fg :green :bg :NONE}}
                   :change {:provider :git_diff_changed
                            :hl {:fg :teal :bg :NONE}}
                   :remove {:provider :git_diff_removed
                            :hl {:fg :red :bg :NONE}}}})

(def- components
  {:active [[comp.git.branch
             comp.git.add
             comp.git.change
             comp.git.remove]
            []
            [comp.diagnostic.err
             comp.diagnostic.warn
             comp.diagnostic.info
             comp.diagnostic.hint]]
   :inactive [[] []]})

(defn get-theme []
  (let [colors (catppuccin.get_palette)]
    (core.merge colors {:fg colors.subtext0
                        :bg colors.crust})))

(feline.setup {:components components
               :theme (get-theme)})

(feline.winbar.setup {:components {:active [[] [comp.file_info]]
                                   :inactive [[] [comp.file_info]]}
                      :disable {:filetypes [:packer :fugitive :fugitiveblame :toggleterm]}})
