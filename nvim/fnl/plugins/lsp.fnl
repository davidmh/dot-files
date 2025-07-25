(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local cfg (autoload :own.config))
(local qf (autoload :own.quickfix))
(local cmp-lsp (autoload :cmp_nvim_lsp))
(local schema-store (autoload :schemastore))

(fn executable? [path]
  (if (= (vim.fn.executable path) 1)
    path
    nil))

(fn get-python-path [workspace]
  (or
    (executable? (.. workspace :/.devenv/state/venv/bin/python))
    (executable? (.. workspace :/.venv/bin/python))
    (executable? (.. workspace :/venv/bin/python))
    (vim.fn.exepath :python3)
    (vim.fn.exepath :python)
    :python))


(fn lsp-config []
  (local git-root [:.git])
  (local python-root [:uv.lock :venv/bin/python])
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

                         :jedi_language_server {:on_new_config (fn [config root]
                                                                 (local python-path (get-python-path root))
                                                                 (tset config :settings {:workspace {:environmentPath python-path}}))
                                                :root_markers python-root}

                         :ruff {:init_options {:settings {:lint {:enable true
                                                                 :preview true}}}}
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

 (tx  :pmizio/typescript-tools.nvim {:dependencies [:nvim-lua/plenary.nvim]
                                     :opts {:settings {:expose_as_code_action [:add_missing_imports]}
                                            :root_markers [:tsconfig.json]}})

 (tx  :j-hui/fidget.nvim {:event :LspAttach
                          :opts {:notification {:window {:align :top
                                                         :y_padding 2
                                                         :winblend 0}}}})

 (tx  :SmiteshP/nvim-navic {:opts {:depth_limit 4
                                   :depth_limit_indicator " [  ] "
                                   :click true
                                   :highlight true
                                   :icons cfg.navic-icons
                                   :safe_output false
                                   :separator "  "}})

 (tx  :dnlhc/glance.nvim {:cmd :Glance
                          :opts {:mappings {:list {:<m-p> qf.glance/enter-preview
                                                   :<c-q> qf.glance/enter-quickfix
                                                   :<c-n> qf.glance/next-result
                                                   :<c-p> qf.glance/previous-result
                                                   :<c-v> qf.glance/vertical-split
                                                   :<c-x> qf.glance/horizontal-split}
                                            :preview {:<m-l> qf.glance/enter-list
                                                      :<c-q> qf.glance/enter-quickfix
                                                      :<c-n> qf.glance/next-result
                                                      :<c-p> qf.glance/previous-result
                                                      :<c-v> qf.glance/vertical-split
                                                      :<c-x> qf.glance/horizontal-split}}
                                  :hooks {:before_open (fn [results open-preview jump-to-result]
                                                         (match (length results)
                                                           0 (vim.notify "No results found")
                                                           1 (do
                                                               (jump-to-result (core.first results))
                                                               (vim.cmd {:cmd :normal}
                                                                        :args [:zz]
                                                                        :bang true))
                                                           _ (open-preview results)))}}})]
