(local core :nfnl.core)

(fn find [pred xs]
  (vim.validate {:pred [pred :function]
                 :xs [xs :table]})
  (each [i x (ipairs xs)]
    (if (pred x i) (lua "return x"))))

(fn find-right [pred xs]
  (vim.validate {:pred [pred :function]
                 :xs [xs :table]})
  (for [i 1 (- (core.count xs) 1)]
    (let [x (. xs i)]
      (if (pred x i) (lua "return x")))))

(fn not-empty [x] (and (~= x nil) (~= x "")))

(fn join [xs sep]
  (vim.validate {:t [xs :table]
                 :s [sep :string]})
  (table.concat (vim.tbl_filter not-empty xs) sep))

{: find
 : find-right
 : join}
