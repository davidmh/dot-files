(module own.plugin.feline
  {autoload {nvim aniseed.nvim
             core aniseed.core
             str aniseed.string
             config own.config
             feline feline
             lsp feline.providers.lsp
             file feline.providers.file
             catppuccin catppuccin.palettes
             vi-mode-utils feline.providers.vi_mode}})

(set nvim.o.termguicolors true)

(def- colors (catppuccin.get_palette))

(defn- buffer-lsp-clients []
  (->> (vim.lsp.buf_get_clients)
       (core.filter (fn [client] (and
                                  (~= client nil)
                                  (~= client.name :copilot)
                                  (~= client.name :null-ls))))
       (core.map (fn [client] client.name))))

(def- pipe-separator {:hl {:bg colors.crust :fg colors.subtext0}
                      :str " | "})

(def- space-separator {:hl {:bg colors.crust :fg :fg}
                       :str " "})

(def- round-left {:provider (fn [] :)
                  :hl {:bg :NONE :fg colors.crust}})
(def- round-right {:provider (fn [] :)
                   :hl {:bg :NONE :fg colors.crust}})

(def- comp {:vi_mode {:provider (fn [] "  ")
                      :hl (fn []
                            {:name (vi-mode-utils.get_mode_highlight_name)
                             :fg (vi-mode-utils.get_mode_color)
                             :bg colors.crust})}
             :file {:info {:hl {:fg colors.purple
                                :bg colors.crust
                                :style "bold"}
                           :provider {:name :file_info
                                      :opts {:type :relative
                                             :file_readonly_icon " "
                                             :file_modified_icon "ﱐ"}}}
                    :encoding {:provider :file_encoding
                               :left_sep space-separator
                               :hl {:fg colors.purple
                                    :bg colors.crust
                                    :style :bold}}
                    :position {:provider :position
                               :left_sep space-separator
                               :hl {:fg colors.cyan
                                    :bg colors.crust}}}
             :line_percentage {:provider :line_percentage
                               :hl {:style :bold
                                    :fg colors.subtext0
                                    :bg colors.crust}}
             :scroll_bar {:provider :scroll_bar
                          :left_sep space-separator
                          :hl {:fg colors.blue
                               :bg colors.crust
                               :style :bold}}
             :diagnostic {:err {:hl {:fg colors.red
                                     :bg colors.crust}
                                :icon (.. " " config.icons.error " ")
                                :provider :diagnostic_errors}
                          :warn {:hl {:fg colors.orange
                                      :bg colors.crust}
                                 :icon (.. " " config.icons.warning " ")
                                 :provider :diagnostic_warnings}
                          :info {:hl {:fg colors.blue
                                      :bg colors.crust}
                                 :icon (.. " " config.icons.info " ")
                                 :provider :diagnostic_info}
                          :hint {:hl {:fg colors.purple
                                      :bg colors.crust}
                                 :icon (.. " " config.icons.hint " ")
                                 :provider :diagnostic_hints}}
             :lsp {:provider (fn [] (->> (buffer-lsp-clients)
                                         (str.join " & ")))
                   :hl {:bg colors.crust
                        :fg colors.subtext0}
                   :left_sep space-separator
                   :right_sep pipe-separator
                   :icon "  "
                   :enabled (fn [] (not (core.empty? (buffer-lsp-clients))))}
             :orgmode_clock {:provider (fn [] (orgmode.statusline))
                             :enabled (fn [] (not (core.empty? (orgmode.statusline))))
                             :right_sep pipe-separator
                             :hl {:bg colors.crust
                                  :fg colors.subtext0}}
             :git {:branch {:provider :git_branch
                            :left_sep space-separator
                            :hl {:bg colors.crust
                                 :fg colors.subtext0
                                 :style :bold}}
                   :add {:provider :git_diff_added
                         :hl {:fg colors.green
                              :bg colors.crust}}
                   :change {:provider :git_diff_changed
                            :hl {:fg colors.teal
                                 :bg colors.crust}}
                   :remove {:provider :git_diff_removed
                            :hl {:fg colors.red
                                 :bg colors.crust}}}})

(def- components
  {:active [[round-left
             comp.vi_mode
             comp.git.branch
             comp.git.add
             comp.git.change
             comp.git.remove]
            [comp.diagnostic.err
             comp.diagnostic.warn
             comp.diagnostic.hint
             comp.diagnostic.info
             comp.lsp
             comp.orgmode_clock
             comp.line_percentage
             comp.scroll_bar
             round-right]]
   :inactive [[] []]})

(feline.setup {:components components
               :theme {:fg (. colors :subtext0)
                       :bg (. colors :crust)}})
(feline.winbar.setup {:components {:active [[] [round-left comp.file.info round-right]]
                                   :inactive [[] [round-left comp.file.info round-right]]}
                      :disable {:filetypes [:packer :fugitive :fugitiveblame :toggleterm]}})
