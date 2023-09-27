(local {: autoload} (require :nfnl.module))

(local core (autoload :nfnl.core))
(local Job (require :plenary.job))

(local local-catalog-path
  (.. (vim.fn.stdpath :data) "/json-schema-catalog.json"))

(fn notify-info [message]
  (vim.notify message :info {:title "JSON LSP Schemas"}))

(fn notify-error [message]
  (vim.notify message :error {:title "JSON LSP Schemas"}))

(fn on-start [] (notify-info "Fetching catalog"))
(fn on-exit [job exit-code]
  (if (= exit-code 0)
    (notify-info "Catalog download complete")
    (notify-error (.. "Couldn't download catalog.\ncurl responded with exit code: " exit-code))))

(fn download-catalog []
  (Job:new {:command :curl
            :args [:https://www.schemastore.org/api/json/catalog.json
                   :-o local-catalog-path]
            :on_start on-start
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
      (print "Run refetch-catalog to get JSON schema hovers")
      [])))

(fn refetch-catalog []
  ; delete the existing catalog
  (vim.fn.system (.. "rm -f " local-catalog-path))
  ; fetch the catalog again
  (: (download-catalog) :sync))

{: get-all
 : refetch-catalog}
