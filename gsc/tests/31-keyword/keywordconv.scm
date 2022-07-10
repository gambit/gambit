(declare (extended-bindings) (not constant-fold) (not safe))

(println (##string->keyword "string"))
(println (##string->keyword (##keyword->string? keyword:)))
(println (##keyword->string? (##string->keyword "string")))
(println (##keyword->string? keyword:))

(println (##keyword? (##string->keyword "string")))
