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

(test-assert (eq? #t (flonum? (thread-quantum t1))))
(test-assert (eq? #t (flonum? (thread-quantum t2))))
(test-assert (eq? #t (flonum? (thread-quantum t3))))
(test-assert (eq? #t (flonum? (thread-quantum t4))))
(test-assert (eq? #t (flonum? (thread-quantum t5))))
(test-assert (eq? #t (flonum? (thread-quantum t6))))
(test-assert (eq? #t (flonum? (thread-quantum t7))))
(test-assert (eq? #t (flonum? (thread-quantum t8))))

(test-error-tail uninitialized-thread-exception? (thread-quantum t10))
(test-error-tail uninitialized-thread-exception? (thread-quantum t11))
(test-error-tail uninitialized-thread-exception? (thread-quantum t12))
(test-error-tail uninitialized-thread-exception? (thread-quantum t13))

(test-eq t10 (thread-init! t10 (lambda () 101010)))

(test-eq t11 (thread-init! t11 (lambda () 111111) 't11))

(test-eq t12 (thread-init! t12 (lambda () 121212) 't12 tg))

(test-assert (eq? #t (flonum? (thread-quantum t10))))
(test-assert (eq? #t (flonum? (thread-quantum t11))))
(test-assert (eq? #t (flonum? (thread-quantum t12))))

(test-error-tail uninitialized-thread-exception? (thread-quantum t13))

(test-equal (void) (thread-quantum-set! t1 1.5))
(test-equal (void) (thread-quantum-set! t2 1.5))
(test-equal (void) (thread-quantum-set! t3 1.5))
(test-equal (void) (thread-quantum-set! t4 1.5))
(test-equal (void) (thread-quantum-set! t5 1.5))
(test-equal (void) (thread-quantum-set! t6 1.5))
(test-equal (void) (thread-quantum-set! t7 1.5))
(test-equal (void) (thread-quantum-set! t8 1.5))
(test-equal (void) (thread-quantum-set! t10 1.5))
(test-equal (void) (thread-quantum-set! t11 1.5))
(test-equal (void) (thread-quantum-set! t12 1.5))

(test-error-tail uninitialized-thread-exception? (thread-quantum-set! t13 1.5))

(test-equal 1.5 (thread-quantum t1))
(test-equal 1.5 (thread-quantum t2))
(test-equal 1.5 (thread-quantum t3))
(test-equal 1.5 (thread-quantum t4))
(test-equal 1.5 (thread-quantum t5))
(test-equal 1.5 (thread-quantum t6))
(test-equal 1.5 (thread-quantum t7))
(test-equal 1.5 (thread-quantum t8))
(test-equal 1.5 (thread-quantum t10))
(test-equal 1.5 (thread-quantum t11))
(test-equal 1.5 (thread-quantum t12))

(test-error-tail uninitialized-thread-exception? (thread-quantum t13))

(test-error-tail type-exception? (thread-quantum #f))

(test-error-tail type-exception? (thread-quantum-set! #f 1.5))
(test-error-tail type-exception? (thread-quantum-set! t1 #f))

(test-error-tail range-exception? (thread-quantum-set! t1 -1.5))

(test-error-tail wrong-number-of-arguments-exception? (thread-quantum))
(test-error-tail wrong-number-of-arguments-exception? (thread-quantum t1 #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-quantum-set!))
(test-error-tail wrong-number-of-arguments-exception? (thread-quantum-set! t1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (thread-quantum-set! t1 1.5 #f))
