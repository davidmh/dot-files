; Not extending to ignore the current textobjects from nvim-treesitter-textobjects
; which are broken at the moment, see: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/pull/570

; todo: capture @function.inner
((list
  . (symbol) @keyword.function
  . (symbol) @_fn_name
  . (sequence (_)* @parameter.inner)) @function.outer
 (#any-of? @keyword.function "fn" "lambda" "λ"))

; anonymous functions
(reader_macro "#"
  (list) @function.inner) @function.outer
