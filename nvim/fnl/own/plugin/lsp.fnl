(module own.plugin.lsp
  {autoload {nvim aniseed.nvim
             core aniseed.core
             config own.config
             util lspconfig.util
             cmp-lsp cmp_nvim_lsp
             json-schemas own.json-schemas
             lspconfig lspconfig
             configs lspconfig.configs
             kind lspkind
             mason mason
             mason-lspconfig mason-lspconfig
             navic nvim-navic
             wk which-key
             fidget fidget}})

(navic.setup {:depth_limit 4
              :depth_limit_indicator " [  ] "
              :click true
              :highlight true
              :icons config.navic-icons
              :separator "  "})
(kind.init)
(fidget.setup {:align {:bottom false}
               :text {:spinner :dots
                      :done :}
               :window {:blend 0
                        :border :none
                        :zindex 1}})
(mason.setup {:ui {:border config.border}})
(mason-lspconfig.setup {:ensure_installed [:clojure_lsp
                                           :cssls
                                           :jsonls
                                           :lua_ls
                                           :vtsls
                                           :eslint
                                           :denols
                                           :vimls]
                        :automatic_installation false})

(def- win-opts {:border config.border
                :max_width 100
                :separator true})
(tset vim.lsp.handlers "textDocument/hover"
      (vim.lsp.with vim.lsp.handlers.hover win-opts))
(tset vim.lsp.handlers "textDocument/signatureHelp"
      (vim.lsp.with vim.lsp.handlers.signature_help win-opts))

(vim.api.nvim_create_augroup :eslint-autofix {:clear true})

; https://github.com/neovim/nvim-lspconfig/blob/da7461b596d70fa47b50bf3a7acfaef94c47727d/lua/lspconfig/server_configurations/eslint.lua#L141-L145
(defn- set-eslint-autofix [bufnr]
  (vim.api.nvim_create_autocmd
       :BufWritePre
       {:command :EslintFixAll
        :group :eslint-autofix
        :buffer bufnr}))

(defn- on-attach [args]
  (local bufnr args.buf)
  (local client (vim.lsp.get_client_by_id args.data.client_id))
  (nvim.buf_set_option 0 :omnifunc :v:lua.vim.lsp.omnifunc)

  (local opts {:buffer true :silent true})

  ;; Mappings
  (vim.keymap.set :n :K vim.lsp.buf.hover opts)
  (vim.keymap.set :n :gd vim.lsp.buf.definition opts)

  (wk.register {:l {:name :LSP
                    :d [vim.lsp.buf.definition "go to definition"]
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
  (wk.register {:l {:name :LSP
                    :a [vim.lsp.buf.code_action "code actions"]}}
               {:prefix :<leader>
                :mode :v
                :buffer 0})

  (when (= client.name :eslint) (set-eslint-autofix bufnr))

  (when client.server_capabilities.documentSymbolProvider
    (navic.attach client bufnr)))

(def- git-root (util.root_pattern :.git))
(def- eslint-root (util.root_pattern :.eslintrc.js :.eslintrc.json))

(def- ts-root (util.root_pattern :package.json))
(def- deno-root (util.root_pattern :deno.json :deno.jsonc))

(def- client-capabilities (->> (vim.lsp.protocol.make_client_capabilities)
                               ; :kevinhwang91/nvim-ufo
                               (vim.tbl_deep_extend :keep {:textDocument {:foldingRange {:dynamicRegistration false
                                                                                         :lineFoldingOnly true}}})))

(def- base-settings {:capabilities (cmp-lsp.default_capabilities client-capabilities)
                     :init_options {:preferences {:includeCompletionsWithSnippetText true
                                                  :includeCompletionsForImportStatements true}}})

(def- server-configs {:vtsls {:root_dir ts-root
                              :settings {:typescript {:tsdk :./node_modules/typescript/lib
                                                      :tsserver {:pluginPaths [:.]}}}}
                      :jsonls {:settings {:json {:schemas (json-schemas.get-all)}}}
                      :lua_ls {:settings {:Lua {:completion :Replace
                                                :diagnostics {:globals [:vim
                                                                        :it
                                                                        :describe
                                                                        :before_each
                                                                        :after_each
                                                                        :pending]}
                                                :workspace {:checkThirdParty false}}}}
                      :eslint {:root_dir eslint-root}
                      :denols {:root_dir deno-root}
                      :cssls {:root_dir git-root}
                      :shellcheck {:root_dir git-root}})

(each [_ server-name (ipairs (mason-lspconfig.get_installed_servers))]
  (let [server-setup (core.get-in lspconfig [server-name :setup])]
    (server-setup (core.merge base-settings
                              (core.get server-configs server-name {})))))

;; grammarly is not installed through mason see:
;; https://github.com/znck/grammarly/issues/334
(lspconfig.grammarly.setup {:filetypes [:markdown :org :txt :gitcommit]})

(lspconfig.solargraph.setup {:root_dir git-root
                             :cmd [:bundle :exec :solargraph :stdio]})

(nvim.create_augroup :lsp-attach {:clear true})
(nvim.create_autocmd :LspAttach {:callback on-attach
                                 :group :lsp-attach})
