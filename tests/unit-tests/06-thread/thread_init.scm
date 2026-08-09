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

(test-eq t10 (thread-init! t10 (lambda () 101010)))

(test-eq t11 (thread-init! t11 (lambda () 111111) 't11))

(test-eq t12 (thread-init! t12 (lambda () 121212) 't12 tg))

(test-equal 111 (thread-join! (thread-start! t1)))
(test-equal 222 (thread-join! (thread-start! t2)))
(test-equal 333 (thread-join! (thread-start! t3)))
(test-equal 444 (thread-join! (thread-start! t4)))
(test-equal 555 (thread-join! (thread-start! t5)))
(test-equal 666 (thread-join! (thread-start! t6)))
(test-equal 777 (thread-join! (thread-start! t7)))
(test-equal 888 (thread-join! (thread-start! t8)))
(test-equal 101010 (thread-join! (thread-start! t10)))
(test-equal 111111 (thread-join! (thread-start! t11)))
(test-equal 121212 (thread-join! (thread-start! t12)))

(test-error-tail initialized-thread-exception? (thread-init! t1 list))
(test-error-tail initialized-thread-exception? (thread-init! t2 list))
(test-error-tail initialized-thread-exception? (thread-init! t3 list))
(test-error-tail initialized-thread-exception? (thread-init! t4 list))
(test-error-tail initialized-thread-exception? (thread-init! t5 list))
(test-error-tail initialized-thread-exception? (thread-init! t6 list))
(test-error-tail initialized-thread-exception? (thread-init! t7 list))
(test-error-tail initialized-thread-exception? (thread-init! t8 list))
(test-error-tail initialized-thread-exception? (thread-init! t10 list))
(test-error-tail initialized-thread-exception? (thread-init! t11 list))
(test-error-tail initialized-thread-exception? (thread-init! t12 list))

(test-error-tail type-exception? (thread-init! #f list))
(test-error-tail type-exception? (thread-init! t1 #f))
(test-error-tail type-exception? (thread-init! t1 list #f #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-init!))
(test-error-tail wrong-number-of-arguments-exception? (thread-init! t1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (thread-init! t1 list #f tg #f))
