(define (=mod10? a b) (= (modulo a 10)
                         (modulo b 10)))
(for-each
 (lambda (t)

   (table-set! t 2 "A")

   (table-set! t 5 "B")

   (table-set! t 12 "C")

   (println (table-ref t 102))

   (println (table-ref t 55))

   (println (table-length t))

   (println (table-ref t 77777 77777)))

 (list (make-table test: =mod10?)
       (make-table test: =mod10? weak-keys: #t)
       (make-table test: =mod10? weak-values: #t)
       (make-table test: =mod10? weak-keys: #t weak-values: #t)))
