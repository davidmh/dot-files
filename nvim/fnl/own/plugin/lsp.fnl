(local {: autoload} (require :nfnl.module))

(local core (autoload :nfnl.core))
(local config (autoload :own.config))
(local util (autoload :lspconfig.util))
(local cmp-lsp (autoload :cmp_nvim_lsp))
(local json-schemas (autoload :own.json-schemas))
(local lspconfig (autoload :lspconfig))
(local kind (autoload :lspkind))
(local mason-lspconfig (autoload :mason-lspconfig))
(local navic (autoload :nvim-navic))
(local fidget (autoload :fidget))
(local typescript-tools (autoload :typescript-tools))

(typescript-tools.setup {})

(navic.setup {:depth_limit 4
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
              :icons config.navic-icons
              :safe_output false
              :separator "  "})
(kind.init)
(fidget.setup {:progress {:display {:done_icon :}}
               :notification {:window {:align :top
                                       :winblend 0
                                       :border :none
                                       :y_padding 2
                                       :zindex 1}}})
(mason-lspconfig.setup {:ensure_installed [:clojure_lsp
                                           :cssls
                                           :jsonls
                                           :lua_ls
                                           :eslint]
                        :automatic_installation false})

(local win-opts {:border config.border
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
                             :cmd [:bundle :exec :solargraph :stdio]})
