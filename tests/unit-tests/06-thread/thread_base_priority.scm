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

(test-assert (eq? #t (flonum? (thread-base-priority t1))))
(test-assert (eq? #t (flonum? (thread-base-priority t2))))
(test-assert (eq? #t (flonum? (thread-base-priority t3))))
(test-assert (eq? #t (flonum? (thread-base-priority t4))))
(test-assert (eq? #t (flonum? (thread-base-priority t5))))
(test-assert (eq? #t (flonum? (thread-base-priority t6))))
(test-assert (eq? #t (flonum? (thread-base-priority t7))))
(test-assert (eq? #t (flonum? (thread-base-priority t8))))

(test-equal 0. (thread-base-priority t1))
(test-equal 0. (thread-base-priority t2))
(test-equal 0. (thread-base-priority t3))
(test-equal 0. (thread-base-priority t4))
(test-equal 0. (thread-base-priority t5))
(test-equal 0. (thread-base-priority t6))
(test-equal 0. (thread-base-priority t7))
(test-equal 0. (thread-base-priority t8))

(test-error-tail uninitialized-thread-exception? (thread-base-priority t10))
(test-error-tail uninitialized-thread-exception? (thread-base-priority t11))
(test-error-tail uninitialized-thread-exception? (thread-base-priority t12))
(test-error-tail uninitialized-thread-exception? (thread-base-priority t13))

(test-eq t10 (thread-init! t10 (lambda () 101010)))

(test-eq t11 (thread-init! t11 (lambda () 111111) 't11))

(test-eq t12 (thread-init! t12 (lambda () 121212) 't12 tg))

(test-assert (eq? #t (flonum? (thread-base-priority t10))))
(test-assert (eq? #t (flonum? (thread-base-priority t11))))
(test-assert (eq? #t (flonum? (thread-base-priority t12))))

(test-error-tail uninitialized-thread-exception? (thread-base-priority t13))

(test-equal (void) (thread-base-priority-set! t1 1.5))
(test-equal (void) (thread-base-priority-set! t2 1.5))
(test-equal (void) (thread-base-priority-set! t3 1.5))
(test-equal (void) (thread-base-priority-set! t4 1.5))
(test-equal (void) (thread-base-priority-set! t5 1.5))
(test-equal (void) (thread-base-priority-set! t6 1.5))
(test-equal (void) (thread-base-priority-set! t7 1.5))
(test-equal (void) (thread-base-priority-set! t8 1.5))
(test-equal (void) (thread-base-priority-set! t10 1.5))
(test-equal (void) (thread-base-priority-set! t11 1.5))
(test-equal (void) (thread-base-priority-set! t12 1.5))

(test-error-tail uninitialized-thread-exception? (thread-base-priority-set! t13 1.5))

(test-equal 1.5 (thread-base-priority t1))
(test-equal 1.5 (thread-base-priority t2))
(test-equal 1.5 (thread-base-priority t3))
(test-equal 1.5 (thread-base-priority t4))
(test-equal 1.5 (thread-base-priority t5))
(test-equal 1.5 (thread-base-priority t6))
(test-equal 1.5 (thread-base-priority t7))
(test-equal 1.5 (thread-base-priority t8))
(test-equal 1.5 (thread-base-priority t10))
(test-equal 1.5 (thread-base-priority t11))
(test-equal 1.5 (thread-base-priority t12))

(test-error-tail uninitialized-thread-exception? (thread-base-priority t13))

;; integers are accepted and converted to inexact
(test-equal (void) (thread-base-priority-set! t1 2))
(test-equal 2. (thread-base-priority t1))

;; negative base priority is allowed
(test-equal (void) (thread-base-priority-set! t1 -0.5))
(test-equal -0.5 (thread-base-priority t1))

(test-error-tail type-exception? (thread-base-priority #f))

(test-error-tail type-exception? (thread-base-priority-set! #f 1.5))
(test-error-tail type-exception? (thread-base-priority-set! t1 #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-base-priority))
(test-error-tail wrong-number-of-arguments-exception? (thread-base-priority t1 #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-base-priority-set!))
(test-error-tail wrong-number-of-arguments-exception? (thread-base-priority-set! t1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (thread-base-priority-set! t1 1.5 #f))
