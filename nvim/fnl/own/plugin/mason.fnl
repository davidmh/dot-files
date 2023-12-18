(local config (require :own.config))
(local mason (require :mason))
(local mason-registry (require :mason-registry))

(mason.setup {:ui {:border config.border}})

(fn on-install [pkg]
  (vim.defer_fn #(vim.notify (.. pkg.name " installed")
                             vim.log.levels.INFO
                             {:title :mason.nvim})
                100))

(mason-registry:on :package:install:success on-install)

;; The mason-lspconfig plugin allows you to define a list of LSP servers
;; to install automatically, this is meant to replicate that functionality
;; for linters and formatters.
(local ensure-installed [:cspell :luacheck :selene])

(vim.defer_fn
  #(each [_ name (ipairs ensure-installed)]
     (let [pkg (mason-registry.get_package name)]
       (when (not (pkg:is_installed))
         (pkg:install))))
  100)
