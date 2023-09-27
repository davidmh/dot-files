(let [(ok? remix) (pcall require :remix)]
  (when ok? (remix.setup {})))
