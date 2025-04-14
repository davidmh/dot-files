;; extends

;; Matches:
;;
;; db.run("SELECT * FROM users WHERE id = 1")
;;
;; db.run(%[
;;  SELECT * FROM users
;;  WHERE id = 1
;; ])
;;
(call
  receiver: (identifier) @_obj
  method: (identifier) @_method
  arguments: (argument_list
               (string
                 (string_content) @injection.content))
  (#eq? @_obj "db")
  (#eq? @_method "run")
  (#set! injection.language "sql"))
