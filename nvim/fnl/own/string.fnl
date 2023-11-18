(fn starts-with [text prefix]
  (= (string.sub text 0 (length prefix))
     prefix))

(fn ends-with [str suffix]
  (or (= suffix "")
      (= suffix (string.sub str (- (length suffix))))))

{: starts-with
 : ends-with}
