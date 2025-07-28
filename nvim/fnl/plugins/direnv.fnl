(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local direnv-opts (autoload :direnv-nvim.opts))

(local git-filetypes [:git :fugitive :fugitiveblame :NeogitStatus])

(fn get-basename []
  (vim.fs.basename (vim.api.nvim_buf_get_name 0)))

(fn get-cwd []
  (if (or (vim.tbl_contains git-filetypes vim.o.ft)
          (vim.tbl_contains git-filetypes (get-basename)))
      (vim.fs.root (vim.uv.cwd) ".git")
      (direnv-opts.buffer_setup.get_cwd)))

(tx :davidmh/direnv.nvim {:branch :custom-setup
                          :opts {:async true
                                 :type :custom
                                 :custom_setup {:get_cwd get-cwd}}})
