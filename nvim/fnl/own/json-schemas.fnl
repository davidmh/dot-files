(local {: autoload} (require :nfnl.module))

(local core (autoload :nfnl.core))
(local Job (require :plenary.job))

(local local-catalog-path
  (.. (vim.fn.stdpath :data) "/json-schema-catalog.json"))

(fn on-exit [_ exit-code]
  (if (~= exit-code 0)
    (vim.notify (.. "Couldn't download catalog.\ncurl responded with exit code: " exit-code)
                :error
                {:title "JSON LSP Schemas"})))

(fn download-catalog []
  (Job:new {:command :curl
            :args [:https://www.schemastore.org/api/json/catalog.json
                   :-o local-catalog-path]
            :on_exit on-exit}))

; List of JSON schemas, downloaded from schemastore.org.
; Useful to provide completion hints and hover messages in know json files.
(fn get-all []
  (or
    (-?> local-catalog-path
        (core.slurp true)
        (vim.fn.json_decode)
        (core.get :schemas []))
    (do
      (vim.defer_fn #(vim.schedule #(: (download-catalog) :sync))
                    500)
      [])))

(fn refetch-catalog []
  ; delete the existing catalog
  (vim.fn.system (.. "rm -f " local-catalog-path))
  ; fetch the catalog again
  (: (download-catalog) :sync))

{: get-all
 : refetch-catalog}
