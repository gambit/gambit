(include "#.scm")

(define (=mod10? a b) (= (modulo a 10)
                         (modulo b 10)))
(for-each
 (lambda (t)

   (table-set! t 2 "A")

   (table-set! t 5 "B")

   (table-set! t 12 "C")

   (check-equal? (table-ref t 102) "C")

   (check-equal? (table-ref t 55) "B")

   (check-= (table-length t) 2)

   (check-equal? (table-ref t 77777 "not-found") "not-found"))

 (list (make-table test: =mod10?)
       (make-table test: =mod10? weak-keys: #t)
       (make-table test: =mod10? weak-values: #t)
       (make-table test: =mod10? weak-keys: #t weak-values: #t)))
