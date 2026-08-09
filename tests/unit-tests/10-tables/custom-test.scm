(include "#.scm")

(define (=mod10? a b) (= (modulo a 10) (modulo b 10)))
(for-each
 (lambda (t)
   
   (table-set! t 2 "A")
   
   (table-set! t 5 "B")
   
   (table-set! t 12 "C")
   
   (test-equal "C" (table-ref t 102))
   
   (test-equal "B" (table-ref t 55))
   
   (test-approximate 2 (table-length t) 1e-12)
   
   (test-equal "not-found" (table-ref t 77777 "not-found")))
 
 (list (make-table test: =mod10?)
       (make-table test: =mod10? weak-keys: #t)
       (make-table test: =mod10? weak-values: #t)
       (make-table test: =mod10? weak-keys: #t weak-values: #t)))
