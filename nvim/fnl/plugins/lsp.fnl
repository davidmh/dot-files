(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local cfg (autoload :own.config))
(local cmp-lsp (autoload :cmp_nvim_lsp))

(fn lsp-config []
  (local git-root [:.git])
  (local python-root [:uv.lock])
  (local client-capabilities (vim.lsp.protocol.make_client_capabilities))
  (vim.lsp.config :* {:capabilities (cmp-lsp.default_capabilities client-capabilities)
                      :init_options {:preferences {:includeCompletionsWithSnippetText true
                                                   :includeCompletionsForImportStatements true}}})

  (local server-configs {:lua_ls {:settings {:Lua {:completion {:callSnippet :Replace}
                                                   :diagnostics {:globals [:vim]}
                                                   :format {:enable false}
                                                   :workspace {:checkThirdParty false}}}}
                         :eslint {:root_markers git-root}

                         :fennel_ls {}

                         :jedi_language_server {:root_markers python-root}

                         :jsonls {}

                         :ruff {:init_options {:settings {:lint {:enable true
                                                                 :preview true}}}}

                         :harper_ls {:settings {:harper-ls {:codeActions {:forceStable true}}}
                                     :filetypes (vim.tbl_filter
                                                  #(not (vim.tbl_contains [:typescript :typescriptreact] $1))
                                                  vim.lsp.config.harper_ls.filetypes)}
                         :gopls {}
                         :tflint {}
                         :terraformls {}
                         :typos_lsp {}
                         :yamlls {}
                         :stylua3p_ls {}
                         :sqls {}
                         :nil_ls {:settings {:nil {:formatting {:command [:nixpkgs-fmt]}}}}
                         :air {}
                         :cssls {:root_markers git-root}
                         :bashls {:root_markers git-root}
                         :solargraph {:root_markers git-root
                                      :cmd [:direnv :exec :. :bundle :exec :solargraph :stdio]}})

  (local server-names (core.keys server-configs))

  (each [name config (pairs server-configs)]
    (tset vim.lsp.config name config))

  (vim.lsp.set_log_level vim.log.levels.OFF)

  (vim.lsp.enable server-names)

  nil)

[(tx :folke/lazydev.nvim {:ft :lua
                          :opts {:library [{:path "${3rd}/luv/library" :words [:vim%.uv]}
                                           :nvim-dap-ui]}})

 (tx  :neovim/nvim-lspconfig {:dependencies [:folke/lazydev.nvim]
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
