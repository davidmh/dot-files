(import-macros {: use} :own.macros)

(set vim.opt.completeopt [:menuone :menuone :noselect :popup])

(use :Saghen/blink.cmp {:dependencies [:kristijanhusak/vim-dadbod-completion]
                        :version "v0.*"
                        :opts {:appearance {:nerd_font_variant :mono}
                               :completion {:menu {:draw {:components {:kind_icon {:text (fn [ctx] (.. " " ctx.kind_icon " "))}
                                                                       :label {:text (fn [ctx] (.. ctx.label " "))}}
                                                          :padding 0}}}
                               :sources {:completion {:enabled_providers [:lsp :path :snippets :buffer :dadbod]}
                                         :providers {:dadbod {:name :Dadbod
                                                              :module :vim_dadbod_completion.blink}}}}})
