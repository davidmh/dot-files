(import-macros {: tx} :own.macros)
(local core (require :nfnl.core))
(local {: autoload} (require :nfnl.module))
(local glance (autoload :glance))

(local mappings {:<c-q> #(glance.actions.quickfix)
                 :<c-n> #(glance.actions.next_location)
                 :<c-p> #(glance.actions.previous_location)
                 :<c-v> #(glance.actions.jump_vsplit)
                 :<c-x> #(glance.actions.jump_split)})

(tx :dnlhc/glance.nvim {:cmd :Glance
                        :opts {:mappings {:list mappings
                                          :preview mappings}
                               :hooks {:before_open (fn [results open-preview jump-to-result]
                                                      (match (length results)
                                                        0 (vim.notify "No results found")
                                                        1 (do
                                                            (jump-to-result (core.first results))
                                                            (vim.cmd {:cmd :normal
                                                                      :args [:zz]
                                                                      :bang true}))
                                                        _ (open-preview results)))}}})
