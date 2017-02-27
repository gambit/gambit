(include "#.scm")

(define m1 (make-mutex))
(define m2 (make-mutex))

(check-eq? (mutex-state m1) 'not-abandoned)

(check-equal? (mutex-lock! m1) #t)

(check-eq? (mutex-state m1) (current-thread))

(check-equal? (mutex-lock! m1 0) #f)

(check-eq? (mutex-state m2) 'not-abandoned)

(check-equal? (mutex-lock! m2 #f (current-thread)) #t)

(check-eq? (mutex-state m2) (current-thread))

(check-equal? (mutex-lock! m2 -1) #f)
(check-equal? (mutex-lock! m2 0.01) #f)

(check-tail-exn type-exception? (lambda () (mutex-lock! #f)))
(check-tail-exn type-exception? (lambda () (mutex-lock! m1 'foo)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (mutex-lock!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (mutex-lock! #f #f #f #f)))
