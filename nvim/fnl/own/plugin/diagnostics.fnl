(module own.plugin.diagnostics
  {autoload {core aniseed.core
             nvim aniseed.nvim
             lint lint
             lint-selene lint.linters.selene
             lint-luacheck lint.linters.luacheck
             config own.config}
   require-macros [aniseed.macros.autocmds]})

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

(defn- get-source-name [diagnostic]
  (or diagnostic.source
      (-?> diagnostic.namespace
           (vim.diagnostic.get_namespace)
           (. :name))
      (.. "ns:" (tostring diagnostic.namespace))))

(defn- diagnostic-format [diagnostic]
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

(defn- str-ends-with [str ending]
  (or (= ending "")
      (= ending (string.sub str (- (length ending))))))

(defn- should-format [bufnr]
  (let [path (nvim.buf_get_name bufnr)
        ignore-fn #(str-ends-with path $1)
        ignore-matches (core.filter ignore-fn [:*.approved.json$
                                               :*.received.json$])]
    (core.empty? ignore-matches)))

(nvim.create_augroup :own-diagnostics {:clear true})

(set lint-selene.args (vim.list_extend [:--config (.. vim.env.HOME :/.config/home-manager/selene.toml)]
                                       lint-selene.args))

(set lint-luacheck.args (vim.list_extend [:--config (.. vim.env.HOME :/.config/home-manager/.luacheckrc)]
                                         lint-luacheck.args))

(set lint.linters_by_ft {:markdown [:cspell]
                         :lua [:luacheck :selene :cspell]
                         :ruby [:rubocop :cspell]
                         :sh [:shellcheck :cspell]
                         :javascript [:cspell]
                         :typescript [:cspell]
                         :typescriptreact [:cspell]
                         :python [:pylint :pycodestyle :pydocstyle]
                         :rust [:cspell]})

(nvim.create_autocmd [:BufEnter :BufWritePost] {:callback #(lint.try_lint)
                                                :group :own-diagnostics})
