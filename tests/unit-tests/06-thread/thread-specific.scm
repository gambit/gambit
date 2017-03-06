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

(check-equal? (thread-specific t1) (void))
(check-equal? (thread-specific t2) (void))
(check-equal? (thread-specific t3) (void))
(check-equal? (thread-specific t4) (void))
(check-equal? (thread-specific t5) (void))
(check-equal? (thread-specific t6) (void))
(check-equal? (thread-specific t7) (void))
(check-equal? (thread-specific t8) (void))
(check-equal? (thread-specific t10) (void))
(check-equal? (thread-specific t11) (void))
(check-equal? (thread-specific t12) (void))
(check-equal? (thread-specific t13) (void))

(check-equal? (thread-specific-set! t1 111) (void))
(check-equal? (thread-specific-set! t2 222) (void))
(check-equal? (thread-specific-set! t3 333) (void))
(check-equal? (thread-specific-set! t4 444) (void))
(check-equal? (thread-specific-set! t5 555) (void))
(check-equal? (thread-specific-set! t6 666) (void))
(check-equal? (thread-specific-set! t7 777) (void))
(check-equal? (thread-specific-set! t8 888) (void))
(check-equal? (thread-specific-set! t10 101010) (void))
(check-equal? (thread-specific-set! t11 111111) (void))
(check-equal? (thread-specific-set! t12 121212) (void))
(check-equal? (thread-specific-set! t13 131313) (void))

(check-equal? (thread-specific t1) 111)
(check-equal? (thread-specific t2) 222)
(check-equal? (thread-specific t3) 333)
(check-equal? (thread-specific t4) 444)
(check-equal? (thread-specific t5) 555)
(check-equal? (thread-specific t6) 666)
(check-equal? (thread-specific t7) 777)
(check-equal? (thread-specific t8) 888)
(check-equal? (thread-specific t10) 101010)
(check-equal? (thread-specific t11) 111111)
(check-equal? (thread-specific t12) 121212)
(check-equal? (thread-specific t13) 131313)

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

(check-equal? (thread-specific t10) 101010)
(check-equal? (thread-specific t11) 111111)
(check-equal? (thread-specific t12) 121212)

(check-eq? (thread-join! (thread-start! t1)) 111)
(check-eq? (thread-join! (thread-start! t2)) 222)
(check-eq? (thread-join! (thread-start! t3)) 333)
(check-eq? (thread-join! (thread-start! t4)) 444)
(check-eq? (thread-join! (thread-start! t5)) 555)
(check-eq? (thread-join! (thread-start! t6)) 666)
(check-eq? (thread-join! (thread-start! t7)) 777)
(check-eq? (thread-join! (thread-start! t8)) 888)
(check-eq? (thread-join! (thread-start! t10)) 101010)
(check-eq? (thread-join! (thread-start! t11)) 111111)
(check-eq? (thread-join! (thread-start! t12)) 121212)

(check-equal? (thread-specific t1) 111)
(check-equal? (thread-specific t2) 222)
(check-equal? (thread-specific t3) 333)
(check-equal? (thread-specific t4) 444)
(check-equal? (thread-specific t5) 555)
(check-equal? (thread-specific t6) 666)
(check-equal? (thread-specific t7) 777)
(check-equal? (thread-specific t8) 888)
(check-equal? (thread-specific t10) 101010)
(check-equal? (thread-specific t11) 111111)
(check-equal? (thread-specific t12) 121212)
(check-equal? (thread-specific t13) 131313)

(check-tail-exn type-exception? (lambda () (thread-specific #f)))
(check-tail-exn type-exception? (lambda () (thread-specific-set! #f #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-specific)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-specific t1 #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-specific-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-specific-set! t1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-specific-set! t1 #f #f)))
