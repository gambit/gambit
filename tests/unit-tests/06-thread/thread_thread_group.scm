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

(test-eq (thread-thread-group (current-thread)) (thread-thread-group t1))
(test-eq (thread-thread-group (current-thread)) (thread-thread-group t2))
(test-eq tg (thread-thread-group t3))
(test-eq (thread-thread-group (current-thread)) (thread-thread-group t4))
(test-eq (thread-thread-group (current-thread)) (thread-thread-group t5))
(test-eq tg (thread-thread-group t6))
(test-eq tg (thread-thread-group t7))
(test-eq tg (thread-thread-group t8))

(test-error-tail uninitialized-thread-exception? (thread-thread-group t10))
(test-error-tail uninitialized-thread-exception? (thread-thread-group t11))
(test-error-tail uninitialized-thread-exception? (thread-thread-group t12))
(test-error-tail uninitialized-thread-exception? (thread-thread-group t13))

(test-eq t10 (thread-init! t10 (lambda () 101010)))

(test-eq t11 (thread-init! t11 (lambda () 111111) 't11))

(test-eq t12 (thread-init! t12 (lambda () 121212) 't12 tg))

(test-eq (thread-thread-group (current-thread)) (thread-thread-group t10))
(test-eq (thread-thread-group (current-thread)) (thread-thread-group t11))
(test-eq tg (thread-thread-group t12))

(test-error-tail uninitialized-thread-exception? (thread-thread-group t13))

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

(test-eq (thread-thread-group (current-thread)) (thread-thread-group t1))
(test-eq (thread-thread-group (current-thread)) (thread-thread-group t2))
(test-eq tg (thread-thread-group t3))
(test-eq (thread-thread-group (current-thread)) (thread-thread-group t4))
(test-eq (thread-thread-group (current-thread)) (thread-thread-group t5))
(test-eq tg (thread-thread-group t6))
(test-eq tg (thread-thread-group t7))
(test-eq tg (thread-thread-group t8))
(test-eq (thread-thread-group (current-thread)) (thread-thread-group t10))
(test-eq (thread-thread-group (current-thread)) (thread-thread-group t11))
(test-eq tg (thread-thread-group t12))

(test-error-tail uninitialized-thread-exception? (thread-thread-group t13))

(test-error-tail type-exception? (thread-thread-group #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-thread-group))
(test-error-tail
 wrong-number-of-arguments-exception?
 (thread-thread-group t1 #f))
