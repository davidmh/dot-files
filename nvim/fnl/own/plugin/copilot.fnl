(local {: autoload} (require :nfnl.module))
(local copilot (require :copilot))
(local str (autoload :own.string))

(copilot.setup {:suggestion {:enabled true
                             :auto_trigger true
                             :keymap {:next :<m-n>
                                      :prev :<m-p>
                                      :accept :<m-y>
                                      :accept_word :<m-w>
                                      :accept_line :<m-l>
                                      :dismiss "<m-[>"}}
                :panel {:enabled true}
                :filetypes {:clojure true
                            :javascript true
                            :typescript true
                            :typescriptreact true
                            :toggleterm true
                            :fennel true
                            :less true
                            :lua true
                            :nix true
                            :python true
                            :ruby true
                            :rust true
                            :zsh #(let [path (vim.api.nvim_buf_get_name 0)]
                                    (and
                                     (= nil (string.match path ".*env.*"))
                                     (not (str.ends-with path :.zprofile))))
                            :sh true
                            :sql true
                            :* false}})
