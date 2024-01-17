(local {: border} (require :own.config))
(require :own.default-plugins)
(require :own.bootstrap)
(require :own.options)

(local lazy (require :lazy))

(lazy.setup :plugins {:dev {:path (.. vim.env.HOME :/Projects)
                            :fallback true}
                      :ui {:border border}})

(vim.schedule #(do
                (require :own.mappings)
                (require :own.package)
                (require :own.projects)))
