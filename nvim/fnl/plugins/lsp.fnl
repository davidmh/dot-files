(import-macros {: use : autocmd} :own.macros)
(local {: autoload} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local cfg (autoload :own.config))
(local util (autoload :lspconfig.util))
(local cmp (autoload :blink.cmp))
(local schema-store (autoload :schemastore))
(local lspconfig (autoload :lspconfig))
(local mason (autoload :mason))
(local mason-registry (autoload :mason-registry))
(local mason-lspconfig (autoload :mason-lspconfig))
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
  (local tailwind-root (util.root_pattern :tailwind.config.ts))

  (local base-settings {:capabilities (cmp.get_lsp_capabilities)
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
                         :fennel_language_server {:single_file_support true
                                                  :root_dir (lspconfig.util.root_pattern :fnl)
                                                  :settings {:fennel {:diagnostics {:globals [:vim :jit :comment :love]}
                                                                      :workspace {:library (vim.api.nvim_list_runtime_paths)
                                                                                  :checkThirdParty false}}}}
                         :jedi_language_server {:on_new_config (fn [config root]
                                                                 (local python-path (get-python-path root))
                                                                 (tset config :settings {:workspace {:environmentPath python-path}}))}
                         :harper_ls {:settings {:harper-ls {:codeActions {:forceStable true}}}}
                                     ;:filetypes [:markdown :gitcommit :text]}
                         :cssls {:root_dir git-root}
                         :shellcheck {:root_dir git-root}
                         :tailwindcss {:root_dir tailwind-root}})

  (each [_ server-name (ipairs (mason-lspconfig.get_installed_servers))]
    (let [server-setup (core.get-in lspconfig [server-name :setup])
          server-config (core.get server-configs server-name {})]
      (if (= server-name :gopls)
          (server-setup server-config)
          (server-setup (core.merge base-settings server-config)))))

  (ruby-lsps)
  (lspconfig.denols.setup {:root_dir deno-root})
  nil)

(fn glance-config []
  (local enter-quickfix #(glance.actions.quickfix))
  (local enter-preview #(glance.actions.enter_win :preview))
  (local enter-list #(glance.actions.enter_win :list))
  (local next-result #(glance.actions.next_location))
  (local previous-result #(glance.actions.previous_location))
  (local vertical-split #(glance.actions.jump_vsplit))
  (local horizontal-split #(glance.actions.jump_split))

  (glance.setup {:mappings {:list {:<m-p> enter-preview
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
                                          (if (= (length results) 1)
                                              (do
                                                (jump-to-result (core.first results))
                                                (vim.cmd {:cmd :normal
                                                          :args [:zz]
                                                          :bang true}))
                                              (open-preview results)))}}))

[(use :folke/lazydev.nvim {:ft :lua
                           :opts {:library [{:path "${3rd}/luv/library" :words [:vim%.uv]}]}})

 (use :williamboman/mason.nvim {:config mason-config})

 (use :williamboman/mason-lspconfig.nvim {:dependencies [:williamboman/mason.nvim]
                                          :opts {:ensure_installed [:bashls
                                                                    :clojure_lsp
                                                                    :cssls
                                                                    :jdtls
                                                                    :jedi_language_server
                                                                    :jsonls
                                                                    :lua_ls
                                                                    :eslint
                                                                    :fennel_language_server
                                                                    :harper_ls
                                                                    :tailwindcss]}
                                          :config true})

 (use :neovim/nvim-lspconfig {:dependencies [:williamboman/mason.nvim
                                             :williamboman/mason-lspconfig.nvim
                                             :Saghen/blink.cmp
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
                                           :williamboman/mason-lspconfig.nvim]})
 (use :dnlhc/glance.nvim {:cmd :Glance
                          :config glance-config})]

