(module own.plugin.context
  {autoload {context treesitter-context}
   require-macros [aniseed.macros.autocmds]})

(context.setup {:enable false
                :max_lines 5
                :line_numbers true
                :separator :ˆ})

(def- test-patterns [:*-test.ts
                     :*-test.tsx
                     :*.test.ts
                     :*.test.tsx
                     :*_spec.rb
                     :*.approved.json
                     :*.received.json])

(augroup :auto-context
  [:BufEnter {:pattern test-patterns
              :command :TSContextEnable}]
  [:BufLeave {:pattern test-patterns
              :command :TSContextDisable}])
