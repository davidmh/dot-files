(module own.plugin.ssr
  {autoload {ssr ssr}})

(vim.schedule
  #(do
     (ssr.setup {:keymaps {:close :q
                           :next_match :n
                           :prev_match :N
                           :replace_confirm :<cr>
                           :replace_all :<leader><cr>}})

     (vim.keymap.set [:n :v] :<leader>sr #(ssr.open) {:buffer true :silent true})

      ; jumpstart the replace by copying the search pattern into the replace line
     (defn- on-edit []
       ; G   -> go to the last line
       ; 2k  -> move two lines up, to be right before the REPLACE virtual text
       ; Vgg -> select all the lines before the current line
       ; 2j  -> deselect the first two lines with the stats and START virtual text
       ; y   -> copy the selection as the search pattern
       ; G   -> go to the last line
       ; V   -> select the empty line
       ; p   -> replace it with the copied search pattern
       (vim.cmd "normal G2kVgg2jyGVp"))

     (vim.api.nvim_create_augroup :custom-ssr {:clear true})
     (vim.api.nvim_create_autocmd :FileType {:callback #(vim.keymap.set [:n] :<C-e> on-edit)
                                             :pattern :ssr
                                             :group :custom-ssr})))
