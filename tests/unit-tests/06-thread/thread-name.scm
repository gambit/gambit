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

(check-equal? (thread-name t1) (void))
(check-equal? (thread-name t2) 't2)
(check-equal? (thread-name t3) 't3)
(check-equal? (thread-name t4) (void))
(check-equal? (thread-name t5) 't5)
(check-equal? (thread-name t6) 't6)
(check-equal? (thread-name t7) 't7)
(check-equal? (thread-name t8) 't8)

(check-tail-exn uninitialized-thread-exception? (lambda () (thread-name t10)))
(check-tail-exn uninitialized-thread-exception? (lambda () (thread-name t11)))
(check-tail-exn uninitialized-thread-exception? (lambda () (thread-name t12)))
(check-tail-exn uninitialized-thread-exception? (lambda () (thread-name t13)))

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

(check-equal? (thread-name t10) (void))
(check-equal? (thread-name t11) 't11)
(check-equal? (thread-name t12) 't12)

(check-tail-exn uninitialized-thread-exception? (lambda () (thread-name t13)))

(check-equal? (thread-join! (thread-start! t1)) 111)
(check-equal? (thread-join! (thread-start! t2)) 222)
(check-equal? (thread-join! (thread-start! t3)) 333)
(check-equal? (thread-join! (thread-start! t4)) 444)
(check-equal? (thread-join! (thread-start! t5)) 555)
(check-equal? (thread-join! (thread-start! t6)) 666)
(check-equal? (thread-join! (thread-start! t7)) 777)
(check-equal? (thread-join! (thread-start! t8)) 888)
(check-equal? (thread-join! (thread-start! t10)) 101010)
(check-equal? (thread-join! (thread-start! t11)) 111111)
(check-equal? (thread-join! (thread-start! t12)) 121212)

(check-equal? (thread-name t1) (void))
(check-equal? (thread-name t2) 't2)
(check-equal? (thread-name t3) 't3)
(check-equal? (thread-name t4) (void))
(check-equal? (thread-name t5) 't5)
(check-equal? (thread-name t6) 't6)
(check-equal? (thread-name t7) 't7)
(check-equal? (thread-name t8) 't8)
(check-equal? (thread-name t10) (void))
(check-equal? (thread-name t11) 't11)
(check-equal? (thread-name t12) 't12)

(check-tail-exn uninitialized-thread-exception? (lambda () (thread-name t13)))

(check-tail-exn type-exception? (lambda () (thread-name #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-name)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-name t1 #f)))
