(module own.plugin.diagnostics
  {autoload {nvim aniseed.nvim
             null-ls null-ls
             u null-ls.utils
             config own.config}})

(def- git-root (u.root_pattern :.git))

(defn- project-root [params]
  (git-root (vim.fn.expand params.bufname)))

(defn- python-cwd [params]
  (let [python-root (u.root_pattern :venv/)]
    (python-root (vim.fn.expand params.bufname))))

(vim.fn.sign_define :DiagnosticSignError {:text config.icons.error
                                          :texthl :DiagnosticSignError})
(vim.fn.sign_define :DiagnosticSignWarn {:text config.icons.warn
                                         :texthl :DiagnosticSignWarn})
(vim.fn.sign_define :DiagnosticSignInfo {:text config.icons.info
                                         :texthl :DiagnosticSignInfo})
(vim.fn.sign_define :DiagnosticSignHint {:text config.icons.hint
                                         :texthl :DiagnosticSignHint})

(vim.diagnostic.config {:underline true
                        :signs true
                        :virtual_text false
                        :update_in_insert false
                        :severity_sort true
                        :float {:header "" :border :single}})

(null-ls.setup
 {:sources [null-ls.builtins.formatting.jq
            null-ls.builtins.diagnostics.shellcheck
            null-ls.builtins.diagnostics.pycodestyle
            null-ls.builtins.diagnostics.pydocstyle
            (null-ls.builtins.diagnostics.pylint.with {:cwd python-cwd})
            (null-ls.builtins.formatting.rubocop.with {:cwd project-root})
            (null-ls.builtins.diagnostics.rubocop.with {:cwd project-root
                                                        :command :bundle
                                                        :args [:exec :rubocop :-f :json :--stdin :$FILENAME]})]})

(nvim.create_augroup :own-diagnostics {:clear true})

(nvim.create_autocmd [:BufRead :BufNewFile]
                     {:group :own-diagnostics
                      :pattern :*_spec.lua
                      :callback (fn []
                                  (vim.keymap.set :n :<localleader>t :<Plug>PlenaryTestFile {:buffer 0}))})
