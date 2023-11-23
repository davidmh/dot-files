(import-macros {: augroup : nmap : vmap} :own.macros)
(local {: autoload} (require :nfnl.module))

(local core (autoload :nfnl.core))
(local config (autoload :own.config))
(local util (autoload :lspconfig.util))
(local cmp-lsp (autoload :cmp_nvim_lsp))
(local json-schemas (autoload :own.json-schemas))
(local lspconfig (autoload :lspconfig))
(local kind (autoload :lspkind))
(local mason (autoload :mason))
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
                                           ; :vtsls
                                           :eslint
                                           :denols
                                           :vimls]
                        :automatic_installation false})

(local win-opts {:border config.border
                 :max_width 100
                 :separator true})
(tset vim.lsp.handlers "textDocument/hover"
      (vim.lsp.with vim.lsp.handlers.hover win-opts))
(tset vim.lsp.handlers "textDocument/signatureHelp"
      (vim.lsp.with vim.lsp.handlers.signature_help win-opts))

(vim.api.nvim_create_augroup :eslint-autofix {:clear true})

; https://github.com/neovim/nvim-lspconfig/blob/da7461b596d70fa47b50bf3a7acfaef94c47727d/lua/lspconfig/server_configurations/eslint.lua#L141-L145
(fn set-eslint-autofix [bufnr]
  (vim.api.nvim_create_autocmd
       :BufWritePre
       {:command :EslintFixAll
        :group :eslint-autofix
        :buffer bufnr}))

(fn buf-map [keymap callback desc]
  (nmap keymap callback {:buffer true
                         :silent true
                         :desc desc}))

(fn on-attach [args]
  (local bufnr args.buf)
  (local client (vim.lsp.get_client_by_id args.data.client_id))
  (vim.api.nvim_buf_set_option 0 :omnifunc :v:lua.vim.lsp.omnifunc)

  ;; Mappings
  (buf-map :K vim.lsp.buf.hover "lsp: hover")
  (buf-map :gd vim.lsp.buf.definition "lsp: go to definition")

  (buf-map :<leader>ld vim.lsp.buf.declaration "lsp: go to declaration")
  (buf-map :<leader>lf vim.lsp.buf.references "lsp: find references")
  (buf-map :<leader>li vim.lsp.buf.implementation "lsp: go to implementation")
  (buf-map :<leader>ls vim.lsp.buf.signature_help "lsp: signature")
  (buf-map :<leader>lt vim.lsp.buf.type_definition "lsp: type definition")
  (buf-map :<leader>la vim.lsp.buf.code_action "lsp: code actions")
  (buf-map :<leader>lr vim.lsp.buf.rename "lsp: rename")
  (buf-map :<leader>lR :<cmd>LspRestart<CR> "lsp: restart")

  (vmap :<leader>la #(vim.lsp.buf.code_action) {:buffer true
                                                :desc "lsp: code actions"})

  (when (= client.name :eslint) (set-eslint-autofix bufnr))

  (when client.server_capabilities.documentSymbolProvider
    (navic.attach client bufnr)))

(local git-root (util.root_pattern :.git))

(local ts-root (util.root_pattern :package.json))
(local deno-root (util.root_pattern :deno.json :deno.jsonc))

(local client-capabilities (->> (vim.lsp.protocol.make_client_capabilities)
                                ; :kevinhwang91/nvim-ufo
                                (vim.tbl_deep_extend :keep {:textDocument {:foldingRange {:dynamicRegistration false
                                                                                          :lineFoldingOnly true}}})))

(local base-settings {:capabilities (cmp-lsp.default_capabilities client-capabilities)
                      :init_options {:preferences {:includeCompletionsWithSnippetText true
                                                   :includeCompletionsForImportStatements true}}})

(local server-configs {:vtsls {:root_dir ts-root
                               :settings {:typescript {:tsdk :./node_modules/typescript/lib}}}
                                                       ; :tsserver {:pluginPaths [:.]}}}}
                       :jsonls {:settings {:json {:schemas (json-schemas.get-all)}}}
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
                       :fennel_language_server {:single_file_support true
                                                :root_dir (lspconfig.util.root_pattern :fnl)
                                                :settings {:fennel {:diagnostics {:globals [:vim :jit :comment]}
                                                                    :workspace {:library (vim.api.nvim_list_runtime_paths)}}}}
                       :denols {:root_dir deno-root}
                       :cssls {:root_dir git-root}
                       :shellcheck {:root_dir git-root}})

(each [_ server-name (ipairs (mason-lspconfig.get_installed_servers))]
  (let [server-setup (core.get-in lspconfig [server-name :setup])]
    (server-setup (core.merge base-settings
                              (core.get server-configs server-name {})))))

;; grammarly is not installed through mason see:
;; https://github.com/znck/grammarly/issues/334
(lspconfig.grammarly.setup {:filetypes [:markdown :norg :txt :gitcommit]})

(lspconfig.ruby_ls.setup {:root_dir git-root
                          :cmd [:bundle :exec :ruby-lsp]})

; (lspconfig.postgres_lsp.setup {:root_dir git-root})

(augroup :lsp-attach [:LspAttach {:callback on-attach}])
