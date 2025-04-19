(import-macros {: use} :own.macros)
(local core (require :nfnl.core))
(local {: autoload} (require :nfnl.module))
(local null-ls (autoload :null-ls))
(local u (autoload :null-ls.utils))
(local cspell (autoload :cspell))
(local cfg (autoload :own.config))
(local str (autoload :own.string))

(fn root-pattern [pattern]
  (fn [{: bufname}]
    (let [root-fn (u.root_pattern pattern)]
      (root-fn (vim.fn.expand bufname)))))

(fn with-root-file [& files]
  (fn [utils]
    (utils.root_has_file files)))

(local cspell-filetypes [:css
                         :clojure
                         :html
                         :javascript
                         :json
                         :less
                         :lua
                         :python
                         :ruby
                         :typescript
                         :typescriptreact
                         :yaml])

(fn get-source-name [diagnostic]
  (or diagnostic.source
      (-?> diagnostic.namespace
           (vim.diagnostic.get_namespace)
           (. :name))
     (.. "ns:" (tostring diagnostic.namespace))))

(fn diagnostic-format [diagnostic]
  (..
    (. cfg.icons diagnostic.severity)
    " [" (get-source-name diagnostic) "] "
    diagnostic.message))

(vim.diagnostic.config {:underline true
                        :signs false
                        :virtual_text false
                        :virtual_lines false
                        :update_in_insert false
                        :severity_sort true
                        :float {:format diagnostic-format
                                :header []}})

(vim.api.nvim_create_augroup :lsp-formatting {:clear true})

(fn on-attach [client bufnr]
  (when (client.supports_method :textDocument/formatting)
    (vim.api.nvim_create_autocmd :BufWritePre {:buffer bufnr
                                               :callback #(vim.lsp.buf.format {:bufnr bufnr})
                                               :group :lsp-formatting})))

(fn on_add_to_json [{: cspell_config_path}]
  (-> "jq -S '.words |= sort' ${path} > ${path}.tmp && mv ${path}.tmp ${path}"
      (str.format {:path cspell_config_path})
      (os.execute)))

(fn on_add_to_dictionary [{: dictionary_path}]
  (-> "sort ${path} -o ${path}"
      (str.format {:path dictionary_path})
      (os.execute)))

(local cspell-config {: on_add_to_json
                      : on_add_to_dictionary
                      :cspell_config_dirs ["~/.config/cspell"]})

(fn config []
  (local formatting null-ls.builtins.formatting)
  (local diagnostics null-ls.builtins.diagnostics)

  (null-ls.setup
    {:sources [(diagnostics.selene.with {:cwd (root-pattern :selene.toml)
                                         :condition (with-root-file :selene.toml)})

               (diagnostics.pylint.with {:cwd (root-pattern :requirements-dev.txt)
                                         :condition (with-root-file :venv/bin/pylint)
                                         :prefer_local :.venv/bin
                                         :args [:--from-stdin :$FILENAME :-f :json :-d "line-too-long,missing-function-docstring"]})

               (cspell.diagnostics.with {:cwd (root-pattern :cspell.json)
                                         :prefer_local :node_modules/.bin
                                         :filetypes cspell-filetypes
                                         :diagnostics_postprocess #(tset $1 :severity vim.diagnostic.severity.W)
                                         :config cspell-config})

               (cspell.code_actions.with {:cwd (root-pattern :cspell.json)
                                          :prefer_local :node_modules/.bin
                                          :filetypes cspell-filetypes
                                          :config cspell-config})

               (diagnostics.mypy.with {:command :uv
                                       :args (fn [params]
                                               (core.concat [:run :mypy] (diagnostics.mypy._opts.args params)))
                                       :prefer_local :.venv/bin})

               formatting.gofmt
               (diagnostics.sqlfluff.with {:extra_args [:--dialect :postgres]
                                           :prefer_local :.venv/bin})
               (formatting.sqlfluff.with {:extra_args [:--dialect :postgres]
                                          :prefer_local :.venv/bin})
               formatting.stylua
               formatting.terraform_fmt
               formatting.nixpkgs_fmt]

     :on_attach on-attach}))

(use :nvimtools/none-ls.nvim {:dependencies [:nvim-lua/plenary.nvim
                                             :davidmh/cspell.nvim]
                              : config})
