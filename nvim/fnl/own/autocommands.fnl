(import-macros {: augroup : autocmd} :own.macros)
(local {: autoload} (require :nfnl.module))
(local projects (autoload :own.projects))
(local navic (autoload :nvim-navic))

(fn on-lsp-attach [args]
  (local client (vim.lsp.get_client_by_id args.data.client_id))

  (when (= client.name :eslint)
    (autocmd :BufWritePre {:group :own.autocommands
                           :buffer args.buf
                           :command :LspEslintFixAll}))

  (when (vim.tbl_contains [:nil_ls :solargraph :terraformls :air]
                          client.name)
    (autocmd :BufWritePre {:group :own.autocommands
                           :buffer args.buf
                           :callback #(vim.lsp.buf.format {:id client.id})}))

  (when client.server_capabilities.documentSymbolProvider
    (navic.attach client args.buf)))

(augroup :own.autocommands
         [:User {:pattern :RooterChDir
                 :callback #(projects.add)}]
         [:LspAttach {:callback on-lsp-attach}])
