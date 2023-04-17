(module own.plugin.diagnostics
  {autoload {core aniseed.core
             nvim aniseed.nvim
             null-ls null-ls
             lists own.lists
             u null-ls.utils
             config own.config}
   require-macros [aniseed.macros.autocmds]})

(def- formatting null-ls.builtins.formatting)
(def- diagnostics null-ls.builtins.diagnostics)
(def- code_actions null-ls.builtins.code_actions)

(defn- root-pattern [pattern]
  (fn [{: bufname}]
    (let [root-fn (u.root_pattern pattern)]
      (root-fn (vim.fn.expand bufname)))))

(defn- with-root-file [& files]
  (fn [utils]
    (utils.root_has_file files)))

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

(defn- str-ends-with [str ending]
  (or (= ending "")
      (= ending (string.sub str (- (length ending))))))

(defn- should-format [bufnr]
  (let [path (nvim.buf_get_name bufnr)
        ignore-fn #(str-ends-with path $1)
        ignore-matches (core.filter ignore-fn [:*.approved.json$
                                               :*.received.json$])]
    (core.empty? ignore-matches)))

(defn- lsp-formatting [bufnr]
  (vim.lsp.buf.format {:filter #(= $1.name :null-ls)
                       :bufnr bufnr}))

(nvim.create_augroup :lsp-formatting {:clear true})

(defn- on-attach [client bufnr]
  (when (client.supports_method :textDocument/formatting)
        (should-format bufnr)
    (nvim.create_autocmd :BufWritePre {:buffer bufnr
                                       :callback #(lsp-formatting bufnr)
                                       :group :lsp-formatting})))

(null-ls.setup
  {:sources [diagnostics.shellcheck
             diagnostics.pycodestyle
             diagnostics.pydocstyle
             diagnostics.rubocop
             (diagnostics.luacheck.with {:cwd (root-pattern :.luacheckrc)
                                         :condition (with-root-file :.luacheckrc)})
             (diagnostics.selene.with {:cwd (root-pattern :selene.toml)
                                       :condition (with-root-file :selene.toml)})
             (diagnostics.pylint.with  {:cwd (root-pattern :venv/)})
             (diagnostics.cspell.with {:cwd (root-pattern :cspell.json)
                                       :prefer_local :./node_modules/.bin
                                       :filetypes cspell-filetypes
                                       :diagnostics_postprocess #(tset $1 :severity vim.diagnostic.severity.W)})

             code_actions.shellcheck
             (code_actions.cspell.with {:cwd (root-pattern :cspell.json)
                                        :filetypes cspell-filetypes})

             formatting.jq
             formatting.rubocop
             formatting.stylua]

   :on_attach on-attach})

