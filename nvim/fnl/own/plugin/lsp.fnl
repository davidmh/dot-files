(module own.plugin.lsp
  {autoload {nvim aniseed.nvim
             core aniseed.core
             config own.config
             util lspconfig.util
             lua-dev lua-dev
             cmp-lsp cmp_nvim_lsp
             json-schemas own.json-schemas
             lspconfig lspconfig
             kind lspkind
             mason mason
             mason-lspconfig mason-lspconfig
             wk which-key
             fidget fidget}})

(kind.init)
(fidget.setup {:text {:spinner :dots_pulse :done :}
               :window {:blend 50}})
(mason.setup)
(mason-lspconfig.setup {:ensure_installed [:clojure_lsp
                                           :cssls
                                           :jsonls
                                           :solargraph
                                           :sumneko_lua
                                           :tsserver
                                           :eslint
                                           :vimls]
                        :automatic_installation true})

(do
  (def- win-opts {:border :rounded
                  :max_width 100
                  :separator true})
  (tset vim.lsp.handlers "textDocument/hover"
        (vim.lsp.with vim.lsp.handlers.hover win-opts))
  (tset vim.lsp.handlers "textDocument/signatureHelp"
        (vim.lsp.with vim.lsp.handlers.signature_help win-opts)))

; https://github.com/neovim/nvim-lspconfig/blob/da7461b596d70fa47b50bf3a7acfaef94c47727d/lua/lspconfig/server_configurations/eslint.lua#L141-L145
(defn- set-eslint-autofix [bufnr]
  (vim.api.nvim_create_autocmd
       :BufWritePre
       {:command :EslintFixAll
        :buffer bufnr
        :group (vim.api.nvim_create_augroup :eslint-autofix {:clear true})}))

(defn- on-attach [client bufnr]
  (nvim.buf_set_option 0 :omnifunc :v:lua.vim.lsp.omnifunc)

  (local opts {:buffer true :silent true})

  ;; Mappings
  (vim.keymap.set :n :K vim.lsp.buf.hover opts)
  (vim.keymap.set :n :gd vim.lsp.buf.definition opts)

  (wk.register {:l {:name :LSP
                    :f [vim.lsp.buf.references "find references"]
                    :i [vim.lsp.buf.implementation "go to implementation"]
                    :s [vim.lsp.buf.signature_help "signature"]
                    :t [vim.lsp.buf.type_definition "type definition"]
                    :a [vim.lsp.buf.code_action "code actions"]
                    :r [vim.lsp.buf.rename "rename"]
                    :F [vim.lsp.buf.format "format"]
                    :R [":LspRestart<CR>" "restart"]}}
               {:prefix :<leader>
                :buffer 0})

  (when (= client.name :eslint) (set-eslint-autofix bufnr)))

(def- git-root (util.root_pattern :.git))

(def- base-settings {:on_attach on-attach
                     :capabilities (cmp-lsp.update_capabilities (vim.lsp.protocol.make_client_capabilities))
                     :init_options {:preferences {:includeCompletionsWithSnippetText true
                                                  :includeCompletionsForImportStatements true}}})

(def- server-configs {:tsserver {:root_dir (util.root_pattern :package.json)
                                 :format {:enable false}}
                      :jsonls {:settings {:json {:schemas (json-schemas.get-all)}}}
                      :sumneko_lua {:settings {:Lua (core.get-in (lua-dev.setup) [:settings :Lua])}}
                      :solargraph {:root_dir git-root}
                      :eslint {:root_dir git-root}
                      :cssls {:root_dir git-root}})

(each [_ server-name (ipairs (mason-lspconfig.get_installed_servers))]
  (let [server-setup (core.get-in lspconfig [server-name :setup])]
    (server-setup (core.merge base-settings
                              (core.get server-configs server-name {})))))

; diagnostics

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
                        :virtual_text true
                        :signs true
                        :update_in_insert true
                        :severity_sort true
                        :float {:header "" :source true}})
