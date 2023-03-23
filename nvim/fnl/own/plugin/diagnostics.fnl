(module own.plugin.diagnostics
  {autoload {nvim aniseed.nvim
             null-ls null-ls
             u null-ls.utils
             config own.config}})

(def- git-root (u.root_pattern :.git))

(defn- python-cwd [{: bufname}]
  (let [python-root (u.root_pattern :venv/)]
    (python-root (vim.fn.expand bufname))))

(defn- cspell-cwd [{: bufname}]
  (let [cspell-root (u.root_pattern :cspell.json)]
    (cspell-root (vim.fn.expand bufname))))

(def- cspell-filetypes [:css
                        :gitcommit
                        :html
                        :javascript
                        :less
                        :markdown
                        :python
                        :ruby
                        :typescript
                        :typescriptreact])

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
(def- {: formatting
       : diagnostics
       : code_actions} null-ls.builtins)

(null-ls.setup
  {:sources [diagnostics.shellcheck
             diagnostics.pycodestyle
             diagnostics.pydocstyle
             diagnostics.rubocop
             (diagnostics.pylint.with  {:cwd python-cwd})
             (diagnostics.cspell.with {:cwd cspell-root
                                       :filetypes cspell-filetypes})

             code_actions.shellcheck
             (code_actions.cspell.with {:cwd cspell-root
                                        :filetypes cspell-filetypes})

             formatting.jq
             formatting.rubocop]})

