(fn find [pred xs]
  (vim.validate {:pred [pred :function]
                 :xs [xs :table]})
  (each [i x (ipairs xs)]
    (if (pred x i) (lua "return x"))))

(fn find-right [pred xs]
  (vim.validate {:pred [pred :function]
                 :xs [xs :table]})
  (for [i 1 (- (length xs) 1)]
    (let [x (. xs i)]
      (if (pred x i) (lua "return x")))))

(fn find-index [pred xs]
  (vim.validate {:pred [pred :function]
                 :xs [xs :table]})
  (each [i x (ipairs xs)]
    (if (pred x i) (lua "return i"))))

(fn not-empty [x] (and (~= x nil) (~= x "")))

(fn join [xs sep]
  (vim.validate {:t [xs :table]
                 :s [sep :string]})
  (table.concat (vim.tbl_filter not-empty xs) sep))

(fn take [n xs]
  (vim.validate {:n [n :number]
                 :xs [xs :table]})
  (vim.list_slice xs 1 n))

(fn min-by [f xs]
  (vim.validate {:f [f :function]
                 :xs [xs :table]})
  (var min math.huge)
  (var min-x nil)
  (each [_ x (ipairs xs)]
    (local v (f x))
    (if (< v min)
       (do (set min v)
           (set min-x x))))
  min-x)

(fn max-by [f xs]
  (vim.validate {:f [f :function]
                 :xs [xs :table]})
  (var max (- math.huge))
  (var max-x nil)
  (each [_ x (ipairs xs)]
    (local v (f x))
    (if (> v max)
       (do (set max v)
           (set max-x x))))
  max-x)

{: find
 : find-right
 : find-index
 : min-by
 : max-by
 : join
 : take}
