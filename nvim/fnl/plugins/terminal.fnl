(import-macros {: tx} :own.macros)

(tx :chomosuke/term-edit.nvim {:event :TermOpen
                               :version :1.*
                               :opts {:prompt_end "❯ "}})
