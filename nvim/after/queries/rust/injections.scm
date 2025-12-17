;; extends

((macro_invocation
   (identifier) @id
   (token_tree) @injection.content)
 (#eq? @id "run_fun")
 (#set! injection.language "bash")
 (#set! injection.include-children))
