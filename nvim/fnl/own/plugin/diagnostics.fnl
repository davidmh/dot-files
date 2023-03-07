(module own.plugin.diagnostics
  {autoload {nvim aniseed.nvim
             null-ls null-ls
             u null-ls.utils
             config own.config}})

(local {: formatting : diagnostics} null-ls.builtins)

(def- git-root (u.root_pattern :.git))

(defn- project-root [{: bufname}]
  (git-root (vim.fn.expand bufname)))

(defn- python-cwd [{: bufname}]
  (let [python-root (u.root_pattern :venv/)]
    (python-root (vim.fn.expand bufname))))

(vim.fn.sign_define :DiagnosticSignError
                    {:text :● :texthl :DiagnosticSignError})
(vim.fn.sign_define :DiagnosticSignWarn
                    {:text :● :texthl :DiagnosticSignWarn})
(vim.fn.sign_define :DiagnosticSignInfo
                    {:text :● :texthl :DiagnosticSignInfo})
(vim.fn.sign_define :DiagnosticSignHint
                    {:text :● :texthl :DiagnosticSignHint})

(defn- diagnostic-format [diagnostic]
  (..
    (. config.icons diagnostic.severity)
    "  [" diagnostic.source "] "
    diagnostic.message))

(vim.diagnostic.config {:underline true
                        :signs true
                        :virtual_text false
                        :update_in_insert false
                        :severity_sort true
                        :float {:header ""
                                :border :single
                                :format diagnostic-format}})

(null-ls.setup
  {:sources [formatting.jq
             diagnostics.shellcheck
             diagnostics.pycodestyle
             diagnostics.pydocstyle
             (diagnostics.pylint.with {:cwd python-cwd})
             (formatting.rubocop.with {:cwd project-root})
             (diagnostics.rubocop.with {:cwd project-root
                                        :command :bundle
                                        :args [:exec :rubocop :-f :json :--stdin :$FILENAME]})]})

(nvim.create_augroup :own-diagnostics {:clear true})

(nvim.create_autocmd [:BufRead :BufNewFile]
                     {:group :own-diagnostics
                      :pattern :*_spec.lua
                      :callback (fn []
                                  (vim.keymap.set :n :<localleader>t :<Plug>PlenaryTestFile {:buffer 0}))})
