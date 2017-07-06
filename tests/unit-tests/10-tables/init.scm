(define t (make-table init: 66666))

(define obj-key '(1 2 3))

(println (table-ref t 42))
(println (table-ref t 'test))
(println (table-ref t obj-key))

(table-set! t 42 777)
(table-set! t 'test 888)
(table-set! t obj-key 999)

(println (table-ref t 42))
(println (table-ref t 'test))
(println (table-ref t obj-key))


(define t (make-table test: eq? init: 66666))

(println (table-ref t 42))
(println (table-ref t 'test))
(println (table-ref t obj-key))

(table-set! t 42 777)
(table-set! t 'test 888)
(table-set! t obj-key 999)

(println (table-ref t 42))
(println (table-ref t 'test))
(println (table-ref t obj-key))
