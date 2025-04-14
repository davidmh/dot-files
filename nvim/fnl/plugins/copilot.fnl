(import-macros {: use} :own.macros)

(use :zbirenbaum/copilot.lua {:event :InsertEnter
                              :opts {:suggestion {:enabled true
                                                  :auto_trigger true
                                                  :keymap {:next :<m-n>
                                                           :prev :<m-p>
                                                           :accept :<m-y>
                                                           :accept_word :<m-w>
                                                           :accept_line :<m-l>
                                                           :dismiss "<m-[>"}}
                                     :panel {:enabled true}
                                     :filetypes {:zsh #(let [path (vim.api.nvim_buf_get_name 0)]
                                                         (and
                                                          (= nil (string.match path ".*env.*"))
                                                          (not (vim.endswith path :.zprofile))
                                                          (not (vim.startswith path (.. vim.env.HOME "/.config")))))
                                                 :* true}}})
