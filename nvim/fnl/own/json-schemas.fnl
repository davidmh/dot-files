(module own.json-schemas
  {autoload {nvim aniseed.nvim
             core aniseed.core}
   require {Job plenary.job}})

(def- local-catalog-path
  (.. (vim.fn.stdpath :data) "/json-schema-catalog.json"))

(defn- notify-info [message]
  (vim.notify message :info {:title "JSON LSP Schemas"}))

(defn- notify-error [message]
  (vim.notify message :error {:title "JSON LSP Schemas"}))

(defn- on-start [] (notify-info "Fetching catalog"))
(defn- on-exit [job exit-code]
  (if (= exit-code 0)
    (notify-info "Catalog download complete")
    (notify-error (.. "Couldn't download catalog.\ncurl responded with exit code: " exit-code))))

(defn- download-catalog []
  (Job:new {:command :curl
            :args [:https://www.schemastore.org/api/json/catalog.json
                   :-o local-catalog-path]
            :on_start on-start
            :on_exit on-exit}))

(defn get-all []
  "List of JSON schemas, downloaded from schemastore.org.
  Useful to provide completion hints and hover messages in know json files."
  (or
    (-?> local-catalog-path
        (core.slurp true)
        (vim.fn.json_decode)
        (core.get :schemas []))
    (do
      (nvim.echo "Run refetch-catalog to get JSON schema hovers")
      [])))

(defn refetch-catalog []
  ; delete the existing catalog
  (vim.fn.system (.. "rm -f " local-catalog-path))
  ; fetch the catalog again
  (: (download-catalog) :sync))
