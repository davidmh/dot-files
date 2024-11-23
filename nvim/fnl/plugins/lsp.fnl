(import-macros {: use : autocmd} :own.macros)
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
(local ensure-linters [:cspell :luacheck :stylua])

(fn mason-config []
  (mason.setup {:ui {:border cfg.border}})
  (mason-registry:on :package:install:success on-linter-install)

  (vim.defer_fn
    #(each [_ name (ipairs ensure-linters)]
       (let [pkg (mason-registry.get_package name)]
         (when (not (pkg:is_installed))
           (pkg:install))))
    100))

(fn ruby-lsps []
  (lspconfig.solargraph.setup {:root_dir (util.root_pattern :.git)
                               :cmd [:bundle :exec :solargraph :stdio]})

  ; format on save with rubocop through solargraph
  (autocmd :BufWritePre {:pattern :*.rb
                         :callback #(vim.lsp.buf.format)}))

(fn lsp-config []
  (local git-root (util.root_pattern :.git))
  (local deno-root (util.root_pattern :deno.json :deno.jsonc))
  (local ts-root (util.root_pattern :tsconfig.json))
  (local tailwind-root (util.root_pattern :tailwind.config.ts))

  (local client-capabilities (vim.lsp.protocol.make_client_capabilities))

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
                         ;:grammarly {:filetypes [:markdown :norg :txt :gitcommit]}
                         :fennel_language_server {:single_file_support true
                                                  :root_dir (lspconfig.util.root_pattern :fnl)
                                                  :settings {:fennel {:diagnostics {:globals [:vim :jit :comment]}
                                                                      :workspace {:library (vim.api.nvim_list_runtime_paths)}}}}
                         :cssls {:root_dir git-root}
                         :shellcheck {:root_dir git-root}
                         :tailwindcss {:root_dir tailwind-root}})

  (each [_ server-name (ipairs (mason-lspconfig.get_installed_servers))]
    (let [server-setup (core.get-in lspconfig [server-name :setup])
          server-config (core.get server-configs server-name {})]
      (if (= server-name :gopls)
          (server-setup server-config
            (server-setup (core.merge base-settings server-config))))))

  (ruby-lsps)
  (lspconfig.denols.setup {:root_dir deno-root})
  nil)

[(use :folke/lazydev.nvim {:ft :lua
                           :opts {:library [:luvit-meta/library]}
                           :config true})
 (use :Bilal2453/luvit-meta {:lazy true})

 (use :williamboman/mason.nvim {:config mason-config})

 (use :williamboman/mason-lspconfig.nvim {:dependencies [:williamboman/mason.nvim]
                                          :opts {:ensure_installed [:bashls
                                                                    :clojure_lsp
                                                                    :cssls
                                                                    :jedi_language_server
                                                                    :jsonls
                                                                    :lua_ls
                                                                    :eslint
                                                                    :fennel_language_server]}
                                                                    ;:tailwindcss]}
                                          :config true})

 (use :neovim/nvim-lspconfig {:dependencies [:williamboman/mason.nvim
                                             :williamboman/mason-lspconfig.nvim
                                             :hrsh7th/cmp-nvim-lsp
                                             :b0o/SchemaStore.nvim]
                              :config lsp-config})

 (use :pmizio/typescript-tools.nvim {:dependencies [:neovim/nvim-lspconfig
                                                    :nvim-lua/plenary.nvim]
                                     :opts {:settings {:expose_as_code_action [:add_missing_imports]}
                                            :root_dir (fn [file-name]
                                                        (local deno-root (util.root_pattern :deno.json :deno.jsonc))
                                                        (local ts-root (util.root_pattern :tsconfig.json))
                                                        (and (= (deno-root file-name) nil)
                                                             (ts-root file-name)))}})

 (use :j-hui/fidget.nvim {:dependencies [:neovim/nvim-lspconfig]
                          :event :LspAttach
                          :opts {:notification {:window {:align :top
                                                         :y_padding 2}}}})

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
                            :config true
                            :dependencies [:williamboman/mason.nvim
                                           :williamboman/mason-lspconfig.nvim]})]
