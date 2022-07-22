(module own.plugin.lsp
  {autoload {nvim aniseed.nvim
             a aniseed.core
             l own.lists
             installer nvim-lsp-installer
             servers nvim-lsp-installer.servers
             config lspconfig
             util lspconfig.util
             lua-dev lua-dev
             cmp-lsp cmp_nvim_lsp
             json-schemas own.json-schemas
             kind lspkind
             fidget fidget
             wk which-key}})

(kind.init {})
(fidget.setup {:text {:spinner :dots_pulse :done :}
               :window {:blend 50}})

; The virtual text is a bit noisy, I prefer displaying the diagnostic on-demand
(vim.diagnostic.config {:virtual_text false})

(vim.cmd "autocmd ColorScheme * highlight NormalFloat guibg=#1f2335")
(vim.cmd "autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335")

(def- required-servers [:clojure_lsp
                        :cssls
                        :jsonls
                        ; :solargraph
                        :sumneko_lua
                        :tsserver
                        :denols
                        :vimls])

(do
  (def- win-opts {:border :rounded
                  :max_width 100
                  :separator true})
  (tset vim.lsp.handlers "textDocument/hover"
        (vim.lsp.with vim.lsp.handlers.hover win-opts))
  (tset vim.lsp.handlers "textDocument/signatureHelp"
        (vim.lsp.with vim.lsp.handlers.signature_help win-opts)))

(defn- on-attach [client bufnr]
  ;; let null-ls handle the formatting
  (tset client.server_capabilities :document_formatting false)
  (tset client.server_capabilities :document_range_formatting false)

  (nvim.buf_set_option bufnr :omnifunc :v:lua.vim.lsp.omnifunc)

  (if (= client.name :denols)
    (nvim.ex.autocmd :BufWritePost :*.ts "silent !deno fmt %"))

  (local opts {:buffer true :silent true})

  ;; Mappings
  (vim.keymap.set :n :K vim.lsp.buf.hover opts)
  (vim.keymap.set :n :gd vim.lsp.buf.definition opts)

  (wk.register {:l {:name :LSP
                    :f [vim.lsp.buf.references "find references"]
                    :i [vim.lsp.buf.implementation "go to implementation"]
                    :s [vim.lsp.buf.signature_help "signature"]
                    :t [vim.lsp.buf.type_definition "type definition"]
                    :a [vim.lsp.buf.code_action "code actions"]
                    :r [vim.lsp.buf.rename "rename"]
                    :R [":LspRestart<CR>" "restart"]}}
               {:prefix :<leader>
                :buffer 0}))

(def- base-settings {:on_attach on-attach
                     :capabilities (cmp-lsp.update_capabilities (vim.lsp.protocol.make_client_capabilities))
                     :init_options {:preferences {:includeCompletionsWithSnippetText true
                                                  :includeCompletionsForImportStatements true}}})

(def- server-settings {:stylelint_lsp {:filetypes [:css :less :scss]}
                       :jsonls {:settings {:json {:schemas (json-schemas.get-all)}}}
                       :tsserver {:root_dir (util.root_pattern :package.json)
                                  :format {:enable false}}
                       :denols {:root_dir (util.root_pattern :deno.json :deno.jsonc)}
                       :sumneko_lua {:settings {:Lua (a.get-in (lua-dev.setup) [:settings :Lua])}}
                       :rubocop {:root_dir (util.root_pattern ".git")}})

(installer.on_server_ready
  (fn [server]
    (server:setup (a.merge base-settings (a.get server-settings server.name {})))))

; ensure default servers
(each [_ server-name (ipairs required-servers)]
  (let [(available server) (servers.get_server server-name)]
    (when (and available (not (server:is_installed)))
      (installer.install server-name))))
