(import-macros {: augroup : autocmd} :own.macros)
(local {: autoload} (require :nfnl.module))
(local projects (autoload :own.projects))
(local navic (autoload :nvim-navic))

(fn on-lsp-attach [args]
  (local client (vim.lsp.get_client_by_id args.data.client_id))

  (when (vim.tbl_contains [:eslint
                           :nil_ls
                           :solargraph
                           :terraformls
                           :air
                           :ruff
                           :rust-analyzer
                           :stylua3p_ls]
                          client.name)
    (autocmd :BufWritePre {:group :own.autocommands
                             :buffer args.buf
                             :callback #(vim.lsp.buf.format {:id client.id})}))

  (when client.server_capabilities.documentSymbolProvider
    (navic.attach client args.buf)))

(fn disable-backup-options []
  (set vim.opt_local.backup false)
  (set vim.opt_local.writebackup false)
  (set vim.opt_local.swapfile false)
  (set vim.opt_local.shada "")
  (set vim.opt_local.undofile false)
  (set vim.opt_local.shelltemp false)
  (set vim.opt_local.history 0)
  (set vim.opt_local.modeline false)
  (print "pass: backup options disabled"))

(augroup :own.autocommands
         [:User {:pattern :RooterChDir
                 :callback #(projects.add)}]
         [:LspAttach {:callback on-lsp-attach}]
         [:BufEnter {:callback disable-backup-options
                     :pattern ["/tmp/pass.?*/?*.txt"
                               "/private/var/?*/pass.?*/?*.txt"]}])
