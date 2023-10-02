(fn starts-with [text prefix]
  (= (string.sub text 0 (length prefix))
     prefix))

{: starts-with}
