(include "#.scm")

(check-same-behavior ("" "##" "~~lib/_prim-symbol#.scm")

;; R4RS

(string->symbol "a")
(symbol->string 'a)
(symbol? 'a) (symbol? "a") (symbol? 123)

;; R7RS

(symbol=?) (symbol=? 'a) (symbol=? 'a 'a) (symbol=? 'a 'b) (symbol=? 'a 'a 'a)

;; Gambit

(symbol? (gensym)) (symbol? (gensym 'a))
(symbol->string (string->uninterned-symbol "a"))
(symbol-hash 'a)
(uninterned-symbol? 'a) (uninterned-symbol? (string->uninterned-symbol "a"))

)
