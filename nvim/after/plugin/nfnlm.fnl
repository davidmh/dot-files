; register fennel macro extensions as their own filetype
(vim.filetype.add {:extension {:fnlm :fnlm}})

; use the fennel parser as the tree-sitter syntax for that new filetype
(vim.treesitter.language.register :fennel :fnlm)
