(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local cfg (autoload :own.config))
(local cmp-lsp (autoload :cmp_nvim_lsp))
(local schema-store (autoload :schemastore))

(fn lsp-config []
  (local git-root [:.git])
  (local python-root [:uv.lock])
  (local client-capabilities (vim.lsp.protocol.make_client_capabilities))
  (vim.lsp.config :* {:capabilities (cmp-lsp.default_capabilities client-capabilities)
                      :init_options {:preferences {:includeCompletionsWithSnippetText true
                                                   :includeCompletionsForImportStatements true}}})

  (local server-configs {:jsonls {:settings {:json {:schemas (schema-store.json.schemas)
                                                    :validate {:enable true}}}}
                         :lua_ls {:settings {:Lua {:completion {:callSnippet :Replace}
                                                   :diagnostics {:globals [:vim]}
                                                   :format {:enable false}
                                                   :workspace {:checkThirdParty false}}}}
                         :eslint {:root_markers git-root}

                         :fennel_ls {:settings {:fennel-ls {:extra-globals :vim
                                                            :macro-path (.. (vim.fn.stdpath :config) :/fnl/own/macros.fnl)}}}

                         :jedi_language_server {:root_markers python-root}

                         :ruff {:init_options {:settings {:lint {:enable true
                                                                 :preview true}}}}

                         :vtsls {}

                         :harper_ls {:settings {:harper-ls {:codeActions {:forceStable true}}}}
                         :gopls {}
                         :tflint {}
                         :terraformls {}
                         :typos_lsp {}
                         :yamlls {}
                         :nil_ls {:settings {:nil {:formatting {:command [:nixpkgs-fmt]}}}}
                         :air {}
                         :cssls {:root_markers git-root}
                         :bashls {:root_markers git-root}
                         :solargraph {}})

  (local server-names (core.keys server-configs))

  (each [name config (pairs server-configs)]
    (tset vim.lsp.config name config))

  (vim.lsp.enable server-names)

  nil)

[(tx :folke/lazydev.nvim {:ft :lua
                          :opts {:library [{:path "${3rd}/luv/library" :words [:vim%.uv]}
                                           :nvim-dap-ui]}})

 (tx  :neovim/nvim-lspconfig {:dependencies [:b0o/SchemaStore.nvim
                                             :folke/lazydev.nvim]
                              :config lsp-config})

 (tx  :j-hui/fidget.nvim {:event :LspAttach
                          :opts {:notification {:window {:align :top
                                                         :border :none
                                                         :y_padding 2}}}})

 (tx  :SmiteshP/nvim-navic {:opts {:depth_limit 4
                                   :depth_limit_indicator " [  ] "
                                   :click true
                                   :highlight true
                                   :icons cfg.navic-icons
                                   :safe_output false
                                   :separator "  "}})]
