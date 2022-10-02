(module own.plugin.notifier)

(let [(ok? notifier) (pcall require :notifier)]
  (when ok? (notifier.setup {:components [:nvim :lsp]
                             :notify {:clear_time 3000}})))
