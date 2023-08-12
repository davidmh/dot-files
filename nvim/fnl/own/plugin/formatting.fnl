(module own.plugin.formatting
  {autoload {nvim aniseed.nvim
             {: stylua} formatter.filetypes.lua
             {: terraformfmt} formatter.filetypes.terraform
             {: rustfmt} formatter.filetypes.rust
             formatter formatter
             util formatter.util}})

(defn- get-current-buffer-file-name []
  (util.escape_path (util.get_current_buffer_file_name)))

(defn- rubocop []
  {:exe :rubocop
   :args [:-a
          :--stdin (get-current-buffer-file-name)
          :--format :files
          :--stderr]
   :stdin true})

(defn- jq []
  {:command :jq
   :stdin true})

(formatter.setup {:logging true
                  :filetype {:json [jq]
                             :lua [stylua]
                             :ruby [rubocop]
                             :rust [rustfmt]
                             :terraform [terraformfmt]}})

(nvim.create_augroup :own-formatting {:clear true})
(nvim.create_autocmd :BufWritePost {:pattern :*
                                    :command :FormatWrite})
