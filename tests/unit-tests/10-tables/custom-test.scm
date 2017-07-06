(define t (make-table test: (lambda (a b) (= (modulo a 10)
                                             (modulo b 10)))))

(table-set! t 2 "A")

(table-set! t 5 "B")

(table-set! t 12 "C")

(println (table-ref t 102))

(println (table-ref t 55))

(println (table-length t))

(println (table-ref t 77777 77777))
