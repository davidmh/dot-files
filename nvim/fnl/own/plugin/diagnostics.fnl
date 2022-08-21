(module own.plugin.diagnostics
  {autoload {nvim aniseed.nvim
             null-ls null-ls
             u null-ls.utils
             config own.config}})

(def- git-root (u.root_pattern :.git))
(defn- project-root [params]
  (git-root (vim.fn.expand params.bufname)))

(vim.fn.sign_define :DiagnosticSignError {:texthl :LspDiagnosticsError
                                          :icon config.icons.error
                                          :numhl :LspDiagnosticsError})
(vim.fn.sign_define :DiagnosticSignWarn {:texthl :LspDiagnosticsWarning
                                         :icon config.icons.warning
                                         :numhl :LspDiagnosticsWarn})
(vim.fn.sign_define :DiagnosticSignHint {:texthl :LspDiagnosticsHint
                                         :icon config.icons.hint
                                         :numhl :LspDiagnosticsHint})
(vim.fn.sign_define :DiagnosticSignInfo {:texthl :Error
                                         :icon config.icons.info
                                         :numhl :LspDiagnosticsInfo})

(vim.diagnostic.config {:underline true
                        :virtual_text false
                        :signs true
                        :update_in_insert true
                        :severity_sort true
                        :float {:header "" :source true}})

(null-ls.setup
 {:sources [null-ls.builtins.formatting.jq
            null-ls.builtins.diagnostics.shellcheck
            (null-ls.builtins.formatting.rubocop.with {:cwd project-root})
            (null-ls.builtins.diagnostics.rubocop.with {:cwd project-root
                                                         :command :bundle
                                                         :args [:exec :rubocop :-f :json :--stdin :$FILENAME]})]})

(nvim.create_augroup :own-diagnostics {:clear true})

(nvim.create_autocmd [:BufRead :BufNewFile]
                     {:group :own-diagnostics
                      :pattern :*_spec.lua
                      :callback (fn []
                                  (vim.keymap.set :n :<localleader>r :<Plug>PlenaryTestFile {:buffer 0}))})
