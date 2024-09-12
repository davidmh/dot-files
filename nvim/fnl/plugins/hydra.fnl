(import-macros {: use} :own.macros)

(local venn-hint "
     Arrow^^^^^^   Select region with <C-v>^^^^^^^^^^^^^^^^
     ^ ^ _K_ ^ ^   _b_: Surround with box ^ ^ ^ ^ ^ ^ ^ ^ ^
     _H_ ^ ^ _L_   _<C-h>_: ◄, _<C-j>_: ▼
     ^ ^ _J_ ^ ^   _<C-k>_: ▲, _<C-l>_: ►   _<C-c>_: exit  

")

(fn config []
  (local hydra (require :hydra))
  (hydra {:name "Draw utf-8 diagrams"
          :hint venn-hint
          :config {:color :pink
                   :invoke_on_body true
                   :on_enter #(set vim.wo.virtualedit :all)}
          :mode :n
          :body :<leader>ve
          :heads [[:<C-h> :xi<C-v>u25c4<Esc>]
                  [:<C-j> :xi<C-v>u25bc<Esc>]
                  [:<C-k> :xi<C-v>u25b2<Esc>]
                  [:<C-l> :xi<C-v>u25ba<Esc>]
                  [:H :<C-v>h:VBox<CR>]
                  [:J :<C-v>j:VBox<CR>]
                  [:K :<C-v>k:VBox<CR>]
                  [:L :<C-v>l:VBox<CR>]
                  [:b ::VBox<CR> {:mode :v}]
                  [:<C-c> nil {:exit true}]]}))

(use :nvimtools/hydra.nvim {: config
                            :dependencies [:jbyuki/venn.nvim]})
