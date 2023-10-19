(require :own.default-plugins)
(require :own.bootstrap)
(require :own.options)
(require :own.plugins)

(vim.schedule #(do
                (require :own.mappings)
                (require :own.window-mappings)
                (require :own.package)))
