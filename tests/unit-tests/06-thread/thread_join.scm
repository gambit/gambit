(include "#.scm")

(define-type-of-thread mythread)

(define num (expt 11 10001))

(define keep-wasting-time #t)

(define (waste-time n)
  (if (and (> n 0) keep-wasting-time)
      (begin
        (integer-sqrt num)
        ;; waste some time
        (waste-time (- n 1)))))

(define var 0)

(define t1 (make-mythread))

(define t2
  (make-thread
   (lambda ()
     (waste-time 200000)
     ;; equivalent of ~5 minutes if not stopped
     (set! var 1)
     2)))

(test-error-tail uninitialized-thread-exception? (thread-join! t1))

(thread-start! t2)

(test-error-tail join-timeout-exception? (thread-join! t2 -1))
(test-error-tail join-timeout-exception? (thread-join! t2 .001))

(test-equal 123 (thread-join! t2 -1 123))
(test-equal 123 (thread-join! t2 .001 123))

(set! keep-wasting-time #f)
;; stop the thread

(test-equal 2 (thread-join! t2))
(test-equal 2 (thread-join! t2))
(test-equal 2 (thread-join! t2 #f))
(test-equal 2 (thread-join! t2 -1))
(test-equal 2 (thread-join! t2 .001))
(test-equal 2 (thread-join! t2 -1 123))
(test-equal 2 (thread-join! t2 .001 123))

(test-equal 1 var)

(test-error-tail type-exception? (thread-join! #f))
(test-error-tail type-exception? (thread-join! t2 'allo))

(test-error-tail wrong-number-of-arguments-exception? (thread-join!))
(test-error-tail
 wrong-number-of-arguments-exception?
 (thread-join! #f #f #f #f))
