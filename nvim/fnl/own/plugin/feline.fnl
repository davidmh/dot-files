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

(def- vi-mode-colors
  {:NORMAL colors.green
   :INSERT colors.red
   :VISUAL colors.magenta
   :OP colors.green
   :BLOCK colors.blue
   :REPLACE colors.purple
   :V-REPLACE colors.purple
   :ENTER colors.cyan
   :MORE colors.cyan
   :SELECT colors.orange
   :COMMAND colors.green
   :SHELL colors.green
   :TERM colors.green
   :NONE colors.yellow})

(defn- buffer-lsp-clients []
  (->> (vim.lsp.buf_get_clients)
       (core.filter (fn [client] (and
                                  (~= client nil)
                                  (~= client.name :copilot)
                                  (~= client.name :null-ls))))
       (core.map (fn [client] client.name))))

(def- pipe-separator {:hl {:bg :bg :fg :fg}
                      :str " | "})

(def- comp {:vi_mode {:provider (fn [] "")
                       :hl (fn []
                             {:name (vi-mode-utils.get_mode_highlight_name)
                              :fg (vi-mode-utils.get_mode_color)})
                       :left_sep " "
                       :right_sep " "}
             :file {:info {:hl {:bg :NONE
                                :fg colors.purple
                                :style "bold"}
                           :provider {:name :file_info
                                      :opts {:type :relative
                                             :file_readonly_icon " "
                                             :file_modified_icon "ﱐ"}}}
                    :encoding {:provider :file_encoding
                               :left_sep " "
                               :hl {:fg colors.purple
                                    :style :bold}}
                    :position {:provider :position
                               :left_sep " "
                               :hl {:fg colors.cyan}}}
             :line_percentage {:provider :line_percentage
                               :left_sep pipe-separator
                               :hl {:style :bold}}
             :scroll_bar {:provider :scroll_bar
                          :left_sep " "
                          :hl {:fg colors.blue
                               :style :bold}}
             :diagnostic {:err {:hl {:fg colors.red}
                                :icon (.. " " config.icons.error " ")
                                :provider :diagnostic_errors}
                          :warn {:hl {:fg colors.orange}
                                 :icon (.. " " config.icons.warning " ")
                                 :provider :diagnostic_warnings}
                          :info {:hl {:fg colors.blue}
                                 :icon (.. " " config.icons.info " ")
                                 :provider :diagnostic_info}
                          :hint {:hl {:fg colors.purple}
                                 :icon (.. " " config.icons.hint " ")
                                 :provider :diagnostic_hints}}
             :lsp {:provider (fn [] (->> (buffer-lsp-clients)
                                         (str.join " & ")))
                   :left_sep " "
                   :icon "  "
                   :enabled (fn [] (not (core.empty? (buffer-lsp-clients))))}
             :orgmode_clock {:provider (fn [] (orgmode.statusline))
                             :right_sep pipe-separator
                             :enabled (fn [] (not (core.empty? (orgmode.statusline))))}
             :git {:branch {:provider :git_branch
                            :icon " "
                            :left_sep " "
                            :hl {:fg colors.purple
                                 :style :bold}}
                   :add {:provider :git_diff_added
                         :hl {:fg colors.green}}
                   :change {:provider :git_diff_changed
                            :hl {:fg colors.orange}}
                   :remove {:provider :git_diff_removed
                            :hl {:fg colors.red}}}})

(def- components
  {:active [[comp.vi_mode
             comp.git.branch
             comp.git.add
             comp.git.change
             comp.git.remove]
            [comp.diagnostic.err
             comp.diagnostic.warn
             comp.diagnostic.hint
             comp.diagnostic.info
             comp.lsp
             ; comp.orgmode_clock
             comp.line_percentage
             comp.scroll_bar]]
   :inactive [[] []]})

(feline.setup {:colors {:bg colors.bg :fg colors.fg}
               :components components
               :vi_mode_colors vi-mode-colors})

(feline.winbar.setup {:components {:active [[] [comp.file.info]]
                                   :inactive [[] [comp.file.info]]}
                      :disable {:filetypes [:packer :fugitive :fugitiveblame :toggleterm]}})
