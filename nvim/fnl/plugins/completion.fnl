(import-macros {: use} :own.macros)

(set vim.opt.completeopt [:menuone :menuone :noselect :popup])

(use :Saghen/blink.cmp {:dependencies [:kristijanhusak/vim-dadbod-completion]
                        :version "v0.*"
                        :opts {:appearance {:nerd_font_variant :normal}
                               :completion {:menu {:draw {:components {:kind_icon {:text (fn [ctx] (.. " " ctx.kind_icon " "))}
                                                                       :label {:text (fn [ctx] (.. ctx.label " "))}}
                                                          :padding 0}}}
                               :sources {:default [:lazydev :lsp :path :snippets :buffer :dadbod]
                                         :cmdline []
                                         :providers {:dadbod {:name :Dadbod
                                                              :module :vim_dadbod_completion.blink}
                                                     :lazydev {:name :LazyDev
                                                               :module :lazydev.integrations.blink
                                                               :score_offset 100}}}}})
