(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local cfg (autoload :own.config))
(local util (autoload :lspconfig.util))
(local cmp-lsp (autoload :cmp_nvim_lsp))
(local schema-store (autoload :schemastore))
(local lspconfig (autoload :lspconfig))
(local mason (autoload :mason))
(local mason-registry (autoload :mason-registry))
(local glance (autoload :glance))

;; mason
(fn on-linter-install [pkg]
  (vim.defer_fn #(vim.notify (.. pkg.name " installed")
                             vim.log.levels.INFO
                             {:title :mason.nvim})
                100))

(fn executable? [path]
  (if (= (vim.fn.executable path) 1)
    path
    nil))

(fn get-python-path [workspace]
  (or
    (executable? (.. workspace :/.venv/bin/python))
    (executable? (.. workspace :/venv/bin/python))
    (vim.fn.exepath :python3)
    (vim.fn.exepath :python)
    :python))


;; The mason-lspconfig plugin allows you to define a list of LSP servers
;; to install automatically, this is meant to replicate that functionality
;; for linters and formatters.
(local ensure-linters [:luacheck :stylua])

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
  (local git-root (util.root_pattern :.git))
  (local deno-root (util.root_pattern :deno.json :deno.jsonc))
  (local python-root (util.root_pattern :uv.lock :venv/bin/python))
  (local client-capabilities (vim.lsp.protocol.make_client_capabilities))
  (local base-settings {:capabilities (cmp-lsp.default_capabilities client-capabilities)
                        :init_options {:preferences {:includeCompletionsWithSnippetText true
                                                     :includeCompletionsForImportStatements true}}})

  (local server-configs {:jsonls {:settings {:json {:schemas (schema-store.json.schemas)
                                                    :validate {:enable true}}}}
                         :lua_ls {:settings {:Lua {:completion {:callSnippet :Replace}
                                                   :diagnostics {:globals [:vim]}
                                                   :format {:enable false}
                                                   :workspace {:checkThirdParty false}}}}
                         :eslint {:root_dir git-root}
                         :fennel_language_server {:single_file_support true
                                                  :root_dir (lspconfig.util.root_pattern :fnl)
                                                  :settings {:fennel {:diagnostics {:globals [:vim :jit :comment :love]}
                                                                      :workspace {:library (vim.api.nvim_list_runtime_paths)}}}}
                         :jedi_language_server {:on_new_config (fn [config root]
                                                                 (local python-path (get-python-path root))
                                                                 (tset config :settings {:workspace {:environmentPath python-path}}))
                                                :root_dir python-root}
                         :ruff {:init_options {:settings {:lint {:enable true
                                                                 :preview true}}}}
                         :harper_ls {:settings {:harper-ls {:codeActions {:forceStable true}}}}
                                     ;:filetypes [:markdown :gitcommit :text]}
                         :gopls {}
                         :typos_lsp {}
                         :cssls {:root_dir git-root}
                         :bashls {:root_dir git-root}
                         :solargraph {:root_dir git-root
                                      :cmd [:bundle :exec :solargraph :stdio]}
                         :denols {:root_dir deno-root}})

  (each [_ server-name (ipairs (core.keys server-configs))]
    (let [server-setup (core.get-in lspconfig [server-name :setup])
          server-config (core.get server-configs server-name {})]
      (if (= server-name :gopls)
          (server-setup server-config)
          (server-setup (core.merge base-settings server-config)))))
  nil)

(fn enter-quickfix [] (glance.actions.quickfix))
(fn enter-preview [] (glance.actions.enter_win :preview))
(fn enter-list [] (glance.actions.enter_win :list))
(fn next-result [] (glance.actions.next_location))
(fn previous-result [] (glance.actions.previous_location))
(fn vertical-split [] (glance.actions.jump_vsplit))
(fn horizontal-split [] (glance.actions.jump_split))

[(tx :folke/lazydev.nvim {:ft :lua
                          :opts {:library [{:path "${3rd}/luv/library" :words [:vim%.uv]}
                                           :nvim-dap-ui]}})

 (tx :williamboman/mason.nvim {:config mason-config})

 (tx :williamboman/mason-lspconfig.nvim {:dependencies [:williamboman/mason.nvim]
                                         :opts {:automatic_enable false
                                                :ensure_installed [:bashls
                                                                   :clojure_lsp
                                                                   :cssls
                                                                   :jdtls
                                                                   :jedi_language_server
                                                                   :ruff
                                                                   :jsonls
                                                                   :lua_ls
                                                                   :eslint
                                                                   :fennel_language_server
                                                                   :harper_ls
                                                                   :typos_lsp]}})

 (tx  :neovim/nvim-lspconfig {:dependencies [:williamboman/mason.nvim
                                             :williamboman/mason-lspconfig.nvim
                                             :b0o/SchemaStore.nvim
                                             :folke/lazydev.nvim]
                              :config lsp-config})

 (tx  :pmizio/typescript-tools.nvim {:dependencies [:neovim/nvim-lspconfig
                                                    :nvim-lua/plenary.nvim]
                                     :opts {:settings {:expose_as_code_action [:add_missing_imports]}
                                            :root_dir (fn [file-name]
                                                        (local deno-root (util.root_pattern :deno.json :deno.jsonc))
                                                        (local ts-root (util.root_pattern :tsconfig.json))
                                                        (and (= (deno-root file-name) nil)
                                                             (ts-root file-name)))}})

 (tx  :j-hui/fidget.nvim {:dependencies [:neovim/nvim-lspconfig]
                          :event :LspAttach
                          :opts {:notification {:window {:align :top
                                                         :y_padding 2
                                                         :winblend 0}}}})

 (tx  :SmiteshP/nvim-navic {:opts {:depth_limit 4
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
                                           :williamboman/mason-lspconfig.nvim]})

 (tx  :dnlhc/glance.nvim {:cmd :Glance
                          :config {:mappings {:list {:<m-p> enter-preview
                                                     :<c-q> enter-quickfix
                                                     :<c-n> next-result
                                                     :<c-p> previous-result
                                                     :<c-v> vertical-split
                                                     :<c-x> horizontal-split}
                                              :preview {:<m-l> enter-list
                                                        :<c-q> enter-quickfix
                                                        :<c-n> next-result
                                                        :<c-p> previous-result
                                                        :<c-v> vertical-split
                                                        :<c-x> horizontal-split}}
                                    :hooks {:before_open (fn [results open-preview jump-to-result]
                                                           (match (length results)
                                                             0 (vim.notify "No results found")
                                                             1 (do
                                                                 (jump-to-result (core.first results))
                                                                 (vim.cmd {:cmd :normal}
                                                                          :args [:zz]
                                                                          :bang true))
                                                             _ (open-preview results)))}}})]
