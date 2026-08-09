(include "#.scm")

(define tg (make-thread-group))

(define t1 (make-thread (lambda () 111)))

(define t2 (make-thread (lambda () 222) 't2))

(define t3 (make-thread (lambda () 333) 't3 tg))

(define t4 (make-root-thread (lambda () 444)))

(define t5 (make-root-thread (lambda () 555) 't5))

(define t6 (make-root-thread (lambda () 666) 't6 tg))

(define t7 (make-root-thread (lambda () 777) 't7 tg (current-input-port)))

(define t8
  (make-root-thread
   (lambda () 888)
   't8
   tg
   (current-input-port)
   (current-output-port)))

(define-type-of-thread mythread)

(define t10 (make-mythread))
;; create some uninitialized threads
(define t11 (make-mythread))
(define t12 (make-mythread))
(define t13 (make-mythread))

(test-equal (void) (thread-specific t1))
(test-equal (void) (thread-specific t2))
(test-equal (void) (thread-specific t3))
(test-equal (void) (thread-specific t4))
(test-equal (void) (thread-specific t5))
(test-equal (void) (thread-specific t6))
(test-equal (void) (thread-specific t7))
(test-equal (void) (thread-specific t8))
(test-equal (void) (thread-specific t10))
(test-equal (void) (thread-specific t11))
(test-equal (void) (thread-specific t12))
(test-equal (void) (thread-specific t13))

(test-equal (void) (thread-specific-set! t1 111))
(test-equal (void) (thread-specific-set! t2 222))
(test-equal (void) (thread-specific-set! t3 333))
(test-equal (void) (thread-specific-set! t4 444))
(test-equal (void) (thread-specific-set! t5 555))
(test-equal (void) (thread-specific-set! t6 666))
(test-equal (void) (thread-specific-set! t7 777))
(test-equal (void) (thread-specific-set! t8 888))
(test-equal (void) (thread-specific-set! t10 101010))
(test-equal (void) (thread-specific-set! t11 111111))
(test-equal (void) (thread-specific-set! t12 121212))
(test-equal (void) (thread-specific-set! t13 131313))

(test-equal 111 (thread-specific t1))
(test-equal 222 (thread-specific t2))
(test-equal 333 (thread-specific t3))
(test-equal 444 (thread-specific t4))
(test-equal 555 (thread-specific t5))
(test-equal 666 (thread-specific t6))
(test-equal 777 (thread-specific t7))
(test-equal 888 (thread-specific t8))
(test-equal 101010 (thread-specific t10))
(test-equal 111111 (thread-specific t11))
(test-equal 121212 (thread-specific t12))
(test-equal 131313 (thread-specific t13))

(test-eq t10 (thread-init! t10 (lambda () 101010)))

(test-eq t11 (thread-init! t11 (lambda () 111111) 't11))

(test-eq t12 (thread-init! t12 (lambda () 121212) 't12 tg))

(test-equal 101010 (thread-specific t10))
(test-equal 111111 (thread-specific t11))
(test-equal 121212 (thread-specific t12))

(test-eq 111 (thread-join! (thread-start! t1)))
(test-eq 222 (thread-join! (thread-start! t2)))
(test-eq 333 (thread-join! (thread-start! t3)))
(test-eq 444 (thread-join! (thread-start! t4)))
(test-eq 555 (thread-join! (thread-start! t5)))
(test-eq 666 (thread-join! (thread-start! t6)))
(test-eq 777 (thread-join! (thread-start! t7)))
(test-eq 888 (thread-join! (thread-start! t8)))
(test-eq 101010 (thread-join! (thread-start! t10)))
(test-eq 111111 (thread-join! (thread-start! t11)))
(test-eq 121212 (thread-join! (thread-start! t12)))

(test-equal 111 (thread-specific t1))
(test-equal 222 (thread-specific t2))
(test-equal 333 (thread-specific t3))
(test-equal 444 (thread-specific t4))
(test-equal 555 (thread-specific t5))
(test-equal 666 (thread-specific t6))
(test-equal 777 (thread-specific t7))
(test-equal 888 (thread-specific t8))
(test-equal 101010 (thread-specific t10))
(test-equal 111111 (thread-specific t11))
(test-equal 121212 (thread-specific t12))
(test-equal 131313 (thread-specific t13))

(test-error-tail type-exception? (thread-specific #f))
(test-error-tail type-exception? (thread-specific-set! #f #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-specific))
(test-error-tail wrong-number-of-arguments-exception? (thread-specific t1 #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-specific-set!))
(test-error-tail
 wrong-number-of-arguments-exception?
 (thread-specific-set! t1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (thread-specific-set! t1 #f #f))
