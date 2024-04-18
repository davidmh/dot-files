(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local cfg (autoload :own.config))
(local util (autoload :lspconfig.util))
(local cmp-lsp (autoload :cmp_nvim_lsp))
(local schema-store (autoload :schemastore))
(local lspconfig (autoload :lspconfig))
(local mason (autoload :mason))
(local mason-registry (autoload :mason-registry))
(local mason-lspconfig (autoload :mason-lspconfig))

;; mason
(fn on-linter-install [pkg]
  (vim.defer_fn #(vim.notify (.. pkg.name " installed")
                             vim.log.levels.INFO
                             {:title :mason.nvim})
                100))

;; The mason-lspconfig plugin allows you to define a list of LSP servers
;; to install automatically, this is meant to replicate that functionality
;; for linters and formatters.
(local ensure-linters [:cspell :luacheck :selene :stylua])

(fn mason-config []
  (mason.setup {:ui {:border cfg.border}})
  (mason-registry:on :package:install:success on-linter-install)

  (vim.defer_fn
    #(each [_ name (ipairs ensure-linters)]
       (let [pkg (mason-registry.get_package name)]
         (when (not (pkg:is_installed))
           (pkg:install))))
    100))

(fn lsp-config []
  (local win-opts {:border cfg.border
                   :max_width 100
                   :separator true})
  (tset vim.lsp.handlers "textDocument/hover"
        (vim.lsp.with vim.lsp.handlers.hover win-opts))
  (tset vim.lsp.handlers "textDocument/signatureHelp"
        (vim.lsp.with vim.lsp.handlers.signature_help win-opts))

  (local git-root (util.root_pattern :.git))

  (local client-capabilities (->> (vim.lsp.protocol.make_client_capabilities)
                                  ; :kevinhwang91/nvim-ufo
                                  (vim.tbl_deep_extend :keep {:textDocument {:foldingRange {:dynamicRegistration false
                                                                                            :lineFoldingOnly true}}})))

  (local base-settings {:capabilities (cmp-lsp.default_capabilities client-capabilities)
                        :init_options {:preferences {:includeCompletionsWithSnippetText true
                                                     :includeCompletionsForImportStatements true}}})

  (local server-configs {:jsonls {:settings {:json {:schemas (schema-store.json.schemas)
                                                    :validate {:enable true}}}}
                         :lua_ls {:settings {:Lua {:completion {:callSnippet :Replace}
                                                   :diagnostics {:globals [:vim
                                                                           :it
                                                                           :describe
                                                                           :before_each
                                                                           :after_each
                                                                           :pending]}
                                                   :format {:enable false}
                                                   :workspace {:checkThirdParty false}}}}
                         :eslint {:root_dir git-root}
                         :grammarly {:filetypes [:markdown :norg :txt :gitcommit]}
                         :fennel_language_server {:single_file_support true
                                                  :root_dir (lspconfig.util.root_pattern :fnl)
                                                  :settings {:fennel {:diagnostics {:globals [:vim :jit :comment]}
                                                                      :workspace {:library (vim.api.nvim_list_runtime_paths)}}}}
                         :cssls {:root_dir git-root}
                         :shellcheck {:root_dir git-root}})

  (each [_ server-name (ipairs (mason-lspconfig.get_installed_servers))]
    (let [server-setup (core.get-in lspconfig [server-name :setup])
          server-config (core.get server-configs server-name {})]
      (if (= server-name :gopls)
          (server-setup server-config)
          (server-setup (core.merge base-settings server-config))))))

[(use :folke/neodev.nvim {:opts {:library {:types true}}
                          :config true})

 (use :williamboman/mason.nvim {:config mason-config})

 (use :williamboman/mason-lspconfig.nvim {:dependencies [:williamboman/mason.nvim]
                                          :opts {:ensure_installed [:bashls
                                                                    :clojure_lsp
                                                                    :cssls
                                                                    :jsonls
                                                                    :lua_ls
                                                                    :eslint
                                                                    :rust_analyzer
                                                                    :solargraph
                                                                    :fennel_language_server]}
                                          :config true})

 (use :neovim/nvim-lspconfig {:dependencies [:williamboman/mason.nvim
                                             :williamboman/mason-lspconfig.nvim
                                             :folke/neodev.nvim
                                             :hrsh7th/cmp-nvim-lsp
                                             :b0o/SchemaStore.nvim]
                              :config lsp-config})

 (use :pmizio/typescript-tools.nvim {:dependencies :neovim/nvim-lspconfig
                                     :config true})]
