(import-macros {: tx} :own.macros)
(local core (require :nfnl.core))
(local {: autoload} (require :nfnl.module))
(local null-ls (autoload :null-ls))
(local u (autoload :null-ls.utils))
(local cfg (autoload :own.config))

(fn root-pattern [pattern]
  (fn [{: bufname}]
    (let [root-fn (u.root_pattern pattern)]
      (root-fn (vim.fn.expand bufname)))))

(fn with-root-file [& files]
  (fn [utils]
    (utils.root_has_file files)))

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

(tx :nvimtools/none-ls.nvim {:dependencies [:nvim-lua/plenary.nvim]
                             : config})
