(include "#.scm")

(define tg (make-thread-group))

(define t1 (make-thread (lambda () 111)))

(define t2 (make-thread (lambda () 222)
                        't2))

(define t3 (make-thread (lambda () 333)
                        't3
                        tg))

(define t4 (make-root-thread (lambda () 444)))

(define t5 (make-root-thread (lambda () 555)
                             't5))

(define t6 (make-root-thread (lambda () 666)
                             't6
                             tg))

(define t7 (make-root-thread (lambda () 777)
                             't7
                             tg
                             (current-input-port)))

(define t8 (make-root-thread (lambda () 888)
                             't8
                             tg
                             (current-input-port)
                             (current-output-port)))

(define-type-of-thread mythread)

(define t10 (make-mythread)) ;; create some uninitialized threads
(define t11 (make-mythread))
(define t12 (make-mythread))
(define t13 (make-mythread))

(check-true (flonum? (thread-quantum t1)))
(check-true (flonum? (thread-quantum t2)))
(check-true (flonum? (thread-quantum t3)))
(check-true (flonum? (thread-quantum t4)))
(check-true (flonum? (thread-quantum t5)))
(check-true (flonum? (thread-quantum t6)))
(check-true (flonum? (thread-quantum t7)))
(check-true (flonum? (thread-quantum t8)))

(check-tail-exn uninitialized-thread-exception? (lambda () (thread-quantum t10)))
(check-tail-exn uninitialized-thread-exception? (lambda () (thread-quantum t11)))
(check-tail-exn uninitialized-thread-exception? (lambda () (thread-quantum t12)))
(check-tail-exn uninitialized-thread-exception? (lambda () (thread-quantum t13)))

(check-eq? (thread-init! t10
                         (lambda () 101010))
           t10)

(check-eq? (thread-init! t11
                         (lambda () 111111)
                         't11)
           t11)

(check-eq? (thread-init! t12
                         (lambda () 121212)
                         't12
                         tg)
           t12)

(check-true (flonum? (thread-quantum t10)))
(check-true (flonum? (thread-quantum t11)))
(check-true (flonum? (thread-quantum t12)))

(check-tail-exn uninitialized-thread-exception? (lambda () (thread-quantum t13)))

(check-equal? (thread-quantum-set! t1 1.5) (void))
(check-equal? (thread-quantum-set! t2 1.5) (void))
(check-equal? (thread-quantum-set! t3 1.5) (void))
(check-equal? (thread-quantum-set! t4 1.5) (void))
(check-equal? (thread-quantum-set! t5 1.5) (void))
(check-equal? (thread-quantum-set! t6 1.5) (void))
(check-equal? (thread-quantum-set! t7 1.5) (void))
(check-equal? (thread-quantum-set! t8 1.5) (void))
(check-equal? (thread-quantum-set! t10 1.5) (void))
(check-equal? (thread-quantum-set! t11 1.5) (void))
(check-equal? (thread-quantum-set! t12 1.5) (void))

(check-tail-exn uninitialized-thread-exception? (lambda () (thread-quantum-set! t13 1.5)))

(check-equal? (thread-quantum t1) 1.5)
(check-equal? (thread-quantum t2) 1.5)
(check-equal? (thread-quantum t3) 1.5)
(check-equal? (thread-quantum t4) 1.5)
(check-equal? (thread-quantum t5) 1.5)
(check-equal? (thread-quantum t6) 1.5)
(check-equal? (thread-quantum t7) 1.5)
(check-equal? (thread-quantum t8) 1.5)
(check-equal? (thread-quantum t10) 1.5)
(check-equal? (thread-quantum t11) 1.5)
(check-equal? (thread-quantum t12) 1.5)

(check-tail-exn uninitialized-thread-exception? (lambda () (thread-quantum t13)))

(check-tail-exn type-exception? (lambda () (thread-quantum #f)))

(check-tail-exn type-exception? (lambda () (thread-quantum-set! #f 1.5)))
(check-tail-exn type-exception? (lambda () (thread-quantum-set! t1 #f)))

(check-tail-exn range-exception? (lambda () (thread-quantum-set! t1 -1.5)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-quantum)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-quantum t1 #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-quantum-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-quantum-set! t1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-quantum-set! t1 1.5 #f)))
