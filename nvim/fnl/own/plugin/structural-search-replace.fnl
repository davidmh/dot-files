(module own.plugin.structural-search-replace
  {autoload {ssr ssr}})

(ssr.setup {:keymaps {:close :q
                      :next_match :n
                      :prev_match :N
                      :replace_confirm :<cr>
                      :replace_all :<leader><cr>}})

(vim.keymap.set [:n :v] :<leader>sr #(ssr.open))
