(declare (extended-bindings) (not constant-fold) (not safe))

(println (##string->symbol "string"))
(println (##string->symbol (##symbol->string 'symbol)))
(println (##symbol->string (##string->symbol "string")))
(println (##symbol->string 'symbol))

(println (##symbol? (##string->symbol "string")))
