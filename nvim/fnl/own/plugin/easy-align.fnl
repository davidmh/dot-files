(module own.plugin.easy-align
  {autoload {nvim aniseed.nvim}})

(nvim.set_keymap :x :ga "<Plug>(EasyAlign)" {})
(nvim.set_keymap :n :ga "<Plug>(EasyAlign)" {})
