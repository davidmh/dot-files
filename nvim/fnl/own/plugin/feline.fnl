(module own.plugin.feline
  {autoload {nvim aniseed.nvim
             core aniseed.core
             str aniseed.string
             config own.config
             feline feline
             lsp feline.providers.lsp
             file feline.providers.file
             git-provider feline.providers.git
             catppuccin catppuccin.palettes}})

(set nvim.o.termguicolors true)

(defn- buffer-lsp-clients []
  (->> (vim.lsp.buf_get_clients)
       (core.filter (fn [client] (and
                                  (~= client nil)
                                  (~= client.name :null-ls))))
       (core.map (fn [client] client.name))))

(def- pipe-separator {:str " | "
                      :hl {:fg :fg}})

(def- space-separator {:str " "})

(def- comp {:file {:info {:hl {:style :bold}
                          :provider {:name :file_info
                                     :opts {:type :relative
                                            :file_readonly_icon " "
                                            :file_modified_icon "ﱐ"}}}
                   :encoding {:provider :file_encoding
                              :left_sep space-separator
                              :hl {:style :bold}}
                   :position {:provider :position}}
             :line_percentage {:provider :line_percentage
                               :hl {:style :bold}}
             :scroll_bar {:provider :scroll_bar
                          :left_sep space-separator
                          :hl {:style :bold}}
             :diagnostic {:err {:hl {:fg :red
                                     :bg :crust}
                                :icon (.. " " config.icons.error " ")
                                :provider :diagnostic_errors}
                          :warn {:hl {:fg :orange
                                      :bg :crust}
                                 :icon (.. " " config.icons.warning " ")
                                 :provider :diagnostic_warnings}
                          :info {:hl {:fg :blue
                                      :bg :crust}
                                 :icon (.. " " config.icons.info " ")
                                 :provider :diagnostic_info}
                          :hint {:hl {:fg :fg
                                      :bg :crust}
                                 :icon (.. " " config.icons.hint " ")
                                 :provider :diagnostic_hints}}
             :lsp {:provider #(->> (buffer-lsp-clients) (str.join " · "))
                   :left_sep space-separator
                   :right_sep pipe-separator
                   ; :icon "  "
                   :enabled #(not (core.empty? (buffer-lsp-clients)))}
             :git {:branch {:provider :git_branch
                            :left_sep space-separator
                            :hl {:style :bold}}
                   :add {:provider :git_diff_added
                         :hl {:fg :green
                              :bg :crust}}
                   :change {:provider :git_diff_changed
                            :hl {:fg :teal
                                 :bg :crust}}
                   :remove {:provider :git_diff_removed
                            :hl {:fg :red
                                 :bg :crust}}}})

(def- has-diagnostics {:enabled #(lsp.diagnostics_exist)})
(def- is-git-repo {:enabled #(git-provider.git_info_exists)})

(defn- round-left [condition]
  (vim.tbl_extend
    :error
    {:provider (fn [] :) :hl {:bg :none :fg :bg}}
    (or condition {})))

(defn- round-right [condition]
  (vim.tbl_extend
    :error
    {:provider (fn [] :) :hl {:bg :NONE :fg :bg}}
    (or condition {})))

(def- components
  {:active [[(round-left is-git-repo)
             comp.git.branch
             comp.git.add
             comp.git.change
             comp.git.remove
             (round-right is-git-repo)]
            []
            [(round-left has-diagnostics)
             comp.diagnostic.err
             comp.diagnostic.warn
             comp.diagnostic.hint
             comp.diagnostic.info
             (round-right has-diagnostics)]]
   :inactive [[] []]})

(defn get-theme []
  (let [colors (catppuccin.get_palette)]
    (core.merge colors {:fg colors.subtext0
                        :bg colors.crust})))

(feline.setup {:components components
               :theme (get-theme)})

(feline.winbar.setup {:components {:active [[] [(round-left) comp.file.info (round-right)]]
                                   :inactive [[] [(round-left) comp.file.info (round-right)]]}
                      :disable {:filetypes [:packer :fugitive :fugitiveblame :toggleterm]}})
