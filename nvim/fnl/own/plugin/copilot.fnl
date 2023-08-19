(module own.plugin.copilot
  {autoload {nvim aniseed.nvim
             copilot copilot
             copilot-panel copilot.panel}})

(copilot.setup {:suggestion {:enabled true
                             :auto_trigger true
                             :keymap {:next :<m-n>
                                      :prev :<m-p>
                                      :accept :<m-y>
                                      :accept_word :<m-w>
                                      :accept_line :<m-l>
                                      :dismiss "<m-[>"}}
                :panel {:enabled true}
                :filetypes {:javascript true
                            :typescript true
                            :typescriptreact true
                            :fennel true
                            :lua true
                            :ruby true
                            :rust true
                            :zsh #(= nil (string.match (nvim.buf_get_name 0) ".*env.*"))
                            :* false}})
