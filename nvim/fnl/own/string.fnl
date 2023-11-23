(fn starts-with [text prefix]
  (= (string.sub text 0 (length prefix))
     prefix))

(fn ends-with [str suffix]
  (or (= suffix "")
      (= suffix (string.sub str (- (length suffix))))))

(fn format [str tbl]
  "
  Formats a string using a table of substitutions.

  Example:
  (format \"Hello, ${name}!\" {:name \"world\"}) => \"Hello, world!\"
  "
  (str:gsub "$%b{}"
            (fn [param]
              (or (. tbl (string.sub param 3 -2))
                  param))))

{: starts-with
 : ends-with
 : format}
