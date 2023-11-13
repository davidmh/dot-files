; extends

; highlight devenv's enterShell and processes as bash
(binding
  attrpath: (attrpath (identifier) @_path)
  expression: [(string_expression
                 ((string_fragment) @injection.content (#set! injection.language "bash")))
               (indented_string_expression
                 ((string_fragment) @injection.content (#set! injection.language "bash")))]
  (#match? @_path "(^(enterShell|processes)|exec$)"))
