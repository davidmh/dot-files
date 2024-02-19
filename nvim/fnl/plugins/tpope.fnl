(import-macros {: use} :own.macros)

[(use :tpope/vim-projectionist {:keys [(use :<leader>aa :<cmd>A<cr> {:desc "in current buffer"})
                                       (use :<leader>av :<cmd>AV<cr> {:desc "in vertical split"})
                                       (use :<leader>as :<cmd>AS<cr> {:desc "in horizontal split"})]
                                :event :VeryLazy})
 :tpope/vim-dispatch
 :radenling/vim-dispatch-neovim
 :tpope/vim-eunuch
 :tpope/vim-repeat
 :tpope/vim-scriptease
 :tpope/vim-surround
 :tpope/vim-unimpaired
 :tpope/vim-projectionist]
