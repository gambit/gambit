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

(test-assert (eq? #t (flonum? (thread-priority-boost t1))))
(test-assert (eq? #t (flonum? (thread-priority-boost t2))))
(test-assert (eq? #t (flonum? (thread-priority-boost t3))))
(test-assert (eq? #t (flonum? (thread-priority-boost t4))))
(test-assert (eq? #t (flonum? (thread-priority-boost t5))))
(test-assert (eq? #t (flonum? (thread-priority-boost t6))))
(test-assert (eq? #t (flonum? (thread-priority-boost t7))))
(test-assert (eq? #t (flonum? (thread-priority-boost t8))))

(test-error-tail uninitialized-thread-exception? (thread-priority-boost t10))
(test-error-tail uninitialized-thread-exception? (thread-priority-boost t11))
(test-error-tail uninitialized-thread-exception? (thread-priority-boost t12))
(test-error-tail uninitialized-thread-exception? (thread-priority-boost t13))

(test-eq t10 (thread-init! t10 (lambda () 101010)))

(test-eq t11 (thread-init! t11 (lambda () 111111) 't11))

(test-eq t12 (thread-init! t12 (lambda () 121212) 't12 tg))

(test-assert (eq? #t (flonum? (thread-priority-boost t10))))
(test-assert (eq? #t (flonum? (thread-priority-boost t11))))
(test-assert (eq? #t (flonum? (thread-priority-boost t12))))

(test-error-tail uninitialized-thread-exception? (thread-priority-boost t13))

(test-equal (void) (thread-priority-boost-set! t1 0.01))
(test-equal (void) (thread-priority-boost-set! t2 0.01))
(test-equal (void) (thread-priority-boost-set! t3 0.01))
(test-equal (void) (thread-priority-boost-set! t4 0.01))
(test-equal (void) (thread-priority-boost-set! t5 0.01))
(test-equal (void) (thread-priority-boost-set! t6 0.01))
(test-equal (void) (thread-priority-boost-set! t7 0.01))
(test-equal (void) (thread-priority-boost-set! t8 0.01))
(test-equal (void) (thread-priority-boost-set! t10 0.01))
(test-equal (void) (thread-priority-boost-set! t11 0.01))
(test-equal (void) (thread-priority-boost-set! t12 0.01))

(test-error-tail uninitialized-thread-exception? (thread-priority-boost-set! t13 0.01))

(test-equal 0.01 (thread-priority-boost t1))
(test-equal 0.01 (thread-priority-boost t2))
(test-equal 0.01 (thread-priority-boost t3))
(test-equal 0.01 (thread-priority-boost t4))
(test-equal 0.01 (thread-priority-boost t5))
(test-equal 0.01 (thread-priority-boost t6))
(test-equal 0.01 (thread-priority-boost t7))
(test-equal 0.01 (thread-priority-boost t8))
(test-equal 0.01 (thread-priority-boost t10))
(test-equal 0.01 (thread-priority-boost t11))
(test-equal 0.01 (thread-priority-boost t12))

(test-error-tail uninitialized-thread-exception? (thread-priority-boost t13))

;; zero boost is allowed; integers are converted to inexact
(test-equal (void) (thread-priority-boost-set! t1 0))
(test-equal 0. (thread-priority-boost t1))

(test-error-tail type-exception? (thread-priority-boost #f))

(test-error-tail type-exception? (thread-priority-boost-set! #f 0.01))
(test-error-tail type-exception? (thread-priority-boost-set! t1 #f))

(test-error-tail range-exception? (thread-priority-boost-set! t1 -0.01))

(test-error-tail wrong-number-of-arguments-exception? (thread-priority-boost))
(test-error-tail wrong-number-of-arguments-exception? (thread-priority-boost t1 #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-priority-boost-set!))
(test-error-tail wrong-number-of-arguments-exception? (thread-priority-boost-set! t1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (thread-priority-boost-set! t1 0.01 #f))
