(module own.plugin.remix)

(let [(ok? remix) (pcall require :remix)]
  (when ok? (remix.setup {})))
