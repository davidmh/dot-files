(import-macros {: tx} :own.macros)

(local git-filetypes [:git :fugitive :fugitiveblame :NeogitStatus :NeogitCommitPopup])

(fn get-cwd []
  (local buf-name (vim.api.nvim_buf_get_name 0))
  (if (or (vim.tbl_contains git-filetypes vim.o.ft)
          (vim.tbl_contains git-filetypes (vim.fs.basename buf-name)))
      (vim.fs.root (vim.uv.cwd) ".git")
      (if (vim.uv.fs_stat buf-name)
          (vim.fs.dirname buf-name))))

(tx :davidmh/direnv.nvim {:branch :custom-setup
                          :opts {:async true
                                 :get_cwd get-cwd}})
