(include "#.scm")

(check-same-behavior ("" "##" "~~lib/gambit/prim/keyword#.scm")

;; Gambit

(keyword->string 'a:)
(keyword-hash 'a:)
(keyword? 'a:) (keyword? "a") (keyword? 123)
(string->keyword "a")
(keyword->string (string->uninterned-keyword "a"))
(uninterned-keyword? 'a:) (uninterned-keyword? (string->uninterned-keyword "a"))

)
