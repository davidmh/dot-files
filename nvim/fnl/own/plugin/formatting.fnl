(local {: stylua} (require :formatter.filetypes.lua))
(local {: terraformfmt} (require :formatter.filetypes.terraform))
(local {: rustfmt} (require :formatter.filetypes.rust))
(local formatter (require :formatter))
(local util (require :formatter.util))

(fn get-current-buffer-file-name []
  (util.escape_path (util.get_current_buffer_file_name)))

(fn rubocop []
  {:exe :rubocop
   :args [:-a
          :--stdin (get-current-buffer-file-name)
          :--format :files
          :--stderr]
   :stdin true})

(fn jq []
  {:command :jq
   :stdin true})

(formatter.setup {:logging true
                  :filetype {:json [jq]
                             :lua [stylua]
                             :ruby [rubocop]
                             :rust [rustfmt]
                             :terraform [terraformfmt]}})

(vim.api.nvim_create_augroup :own-formatting {:clear true})
(vim.api.nvim_create_autocmd :BufWritePost {:pattern :*
                                            :command :FormatWrite})
