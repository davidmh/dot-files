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

{: format}
