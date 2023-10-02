(local core (require :nfnl.core))
(local null-ls (require :null-ls))
(local u (require :null-ls.utils))
(local cspell (require :cspell))
(local config (require :own.config))

(local formatting null-ls.builtins.formatting)
(local diagnostics null-ls.builtins.diagnostics)
(local code_actions null-ls.builtins.code_actions)

(fn root-pattern [pattern]
  (fn [{: bufname}]
    (let [root-fn (u.root_pattern pattern)]
      (root-fn (vim.fn.expand bufname)))))

(fn with-root-file [& files]
  (fn [utils]
    (utils.root_has_file files)))

(local cspell-filetypes [:css
                         :gitcommit
                         :clojure
                         :html
                         :javascript
                         :json
                         :less
                         :lua
                         :markdown
                         :python
                         :ruby
                         :typescript
                         :typescriptreact
                         :yaml])

(comment
  ; TODO: render gitsigns and diagnostic icons side to side
  (vim.fn.sign_define :DiagnosticSignError
                      {:text :● :texthl :DiagnosticSignError})
  (vim.fn.sign_define :DiagnosticSignWarn
                      {:text :● :texthl :DiagnosticSignWarn})
  (vim.fn.sign_define :DiagnosticSignInfo
                      {:text :● :texthl :DiagnosticSignInfo})
  (vim.fn.sign_define :DiagnosticSignHint
                      {:text :● :texthl :DiagnosticSignHint}))

(fn get-source-name [diagnostic]
  (or diagnostic.source
      (-?> diagnostic.namespace
           (vim.diagnostic.get_namespace)
           (. :name))
      (.. "ns:" (tostring diagnostic.namespace))))

(fn diagnostic-format [diagnostic]
  (..
    (. config.icons diagnostic.severity)
    " [" (get-source-name diagnostic) "] "
    diagnostic.message))

(vim.diagnostic.config {:underline true
                        :signs false
                        :virtual_text false
                        :update_in_insert false
                        :severity_sort true
                        :float {:header ""
                                :border config.border
                                :format diagnostic-format}})

(fn str-ends-with [str ending]
  (or (= ending "")
      (= ending (string.sub str (- (length ending))))))

(fn should-format [bufnr]
  (let [path (vim.api.nvim_buf_get_name bufnr)
        ignore-fn #(str-ends-with path $1)
        ignore-matches (core.filter ignore-fn [:*.approved.json$
                                               :*.received.json$])]
    (core.empty? ignore-matches)))

(fn lsp-formatting [bufnr]
  (vim.lsp.buf.format {:filter #(= $1.name :null-ls)
                       :bufnr bufnr}))

(vim.api.nvim_create_augroup :lsp-formatting {:clear true})

(fn on-attach [client bufnr]
  (when (client.supports_method :textDocument/formatting)
        (should-format bufnr)
    (vim.api.nvim_create_autocmd :BufWritePre {:buffer bufnr
                                               :callback #(lsp-formatting bufnr)
                                               :group :lsp-formatting})))

(null-ls.setup
  {:sources [diagnostics.shellcheck
             ; diagnostics.pycodestyle
             ; diagnostics.pydocstyle
             (diagnostics.rubocop.with {:cwd (root-pattern :.rubocop.yml)})
                                        ; :command :bundle
                                        ; :args (core.concat [:exec :rubocop] diagnostics.rubocop._opts.args)})
             (diagnostics.luacheck.with {:cwd (root-pattern :.luacheckrc)
                                         :condition (with-root-file :.luacheckrc)})
             (diagnostics.selene.with {:cwd (root-pattern :selene.toml)
                                       :condition (with-root-file :selene.toml)})
             ; (diagnostics.pylint.with  {:cwd (root-pattern :venv/)})
             (cspell.diagnostics.with {:cwd (root-pattern :cspell.json)
                                       :prefer_local :./node_modules/.bin
                                       :filetypes cspell-filetypes
                                       :diagnostics_postprocess #(tset $1 :severity vim.diagnostic.severity.W)})

             code_actions.shellcheck
             (cspell.code_actions.with {:cwd (root-pattern :cspell.json)
                                        :filetypes cspell-filetypes})

             formatting.jq
             (formatting.rubocop.with {:cwd (root-pattern :.rubocop.yml)})
                                       ; :command :bundle
                                       ; :args (core.concat [:exec :rubocop] diagnostics.rubocop._opts.args)})
             ; formatting.stylua
             formatting.terraform_fmt
             formatting.rustfmt]

   :on_attach on-attach})
