(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local cfg (autoload :own.config))
(local util (autoload :lspconfig.util))
(local cmp-lsp (autoload :cmp_nvim_lsp))
(local json-schemas (autoload :own.json-schemas))
(local lspconfig (autoload :lspconfig))
(local kind (autoload :lspkind))
(local mason (autoload :mason))
(local mason-registry (autoload :mason-registry))
(local mason-lspconfig (autoload :mason-lspconfig))
(local navic (autoload :nvim-navic))
(local typescript-tools (autoload :typescript-tools))

;; mason
(fn on-linter-install [pkg]
  (vim.defer_fn #(vim.notify (.. pkg.name " installed")
                             vim.log.levels.INFO
                             {:title :mason.nvim})
                100))

;; The mason-lspconfig plugin allows you to define a list of LSP servers
;; to install automatically, this is meant to replicate that functionality
;; for linters and formatters.
(local ensure-linters [:cspell :luacheck :selene])

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
  (typescript-tools.setup {})
  (kind.init)

  (comment
    (local win-opts {:border cfg.border
                     :max_width 100
                     :separator true})
    (tset vim.lsp.handlers "textDocument/hover"
          (vim.lsp.with vim.lsp.handlers.hover win-opts))
    (tset vim.lsp.handlers "textDocument/signatureHelp"
          (vim.lsp.with vim.lsp.handlers.signature_help win-opts)))

  (local git-root (util.root_pattern :.git))

  (local client-capabilities (->> (vim.lsp.protocol.make_client_capabilities)
                                  ; :kevinhwang91/nvim-ufo
                                  (vim.tbl_deep_extend :keep {:textDocument {:foldingRange {:dynamicRegistration false
                                                                                            :lineFoldingOnly true}}})))

  (local base-settings {:capabilities (cmp-lsp.default_capabilities client-capabilities)
                        :init_options {:preferences {:includeCompletionsWithSnippetText true
                                                     :includeCompletionsForImportStatements true}}})

  (local server-configs {:jsonls {:settings {:json {:schemas (json-schemas.get-all)}}}
                         :lua_ls {:settings {:Lua {:completion :Replace
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
    (let [server-setup (core.get-in lspconfig [server-name :setup])]
      (server-setup (core.merge base-settings
                                (core.get server-configs server-name {})))))

  (lspconfig.solargraph.setup {:root_dir git-root
                               :cmd [:bundle :exec :solargraph :stdio]}))

[(use :folke/neodev.nvim {:opts {:library {:types true}}
                          :config true})

 (use :williamboman/mason.nvim {:config mason-config
                                :lazy false})

 (use :williamboman/mason-lspconfig.nvim {:lazy false
                                          :opts {:ensure_installed [:clojure_lsp
                                                                    :cssls
                                                                    :jsonls
                                                                    :lua_ls
                                                                    :eslint
                                                                    :fennel_language_server]}
                                          :config true})

 (use :SmiteshP/nvim-navic {:opts {:depth_limit 4
                                   :depth_limit_indicator " [  ] "
                                   :click true
                                   :highlight true
                                   :format_text (fn [text]
                                                  (if (or (text:match "^it%(")
                                                          (text:match "^describe%("))
                                                    (-> text
                                                      (: :gsub "^it%('" "it ")
                                                      (: :gsub "^describe%('" "describe ")
                                                      (: :gsub "'%) callback$" ""))
                                                    (-> text
                                                      (: :gsub " callback$" ""))))
                                   :icons cfg.navic-icons
                                   :safe_output false
                                   :separator "  "}
                            :config true})

 (use :neovim/nvim-lspconfig {:dependencies [:williamboman/mason.nvim
                                             :williamboman/mason-lspconfig.nvim
                                             :onsails/lspkind-nvim
                                             :hrsh7th/cmp-nvim-lsp
                                             :SmiteshP/nvim-navic
                                             :pmizio/typescript-tools.nvim]
                              :config lsp-config
                              :event :VeryLazy})]
