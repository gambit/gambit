(include "#.scm")

(define-type-of-thread mythread)

(define num (expt 11 10001))

(define (waste-time n)
  (if (> n 0)
      (begin
        (integer-sqrt num)
        ;; waste some time
        (waste-time (- n 1)))))

(define var #f)

(define t1 (make-mythread))

(define t2
  (make-thread
   (lambda ()
     (parameterize ((current-user-interrupt-handler
                     (lambda () (set! var (+ var 1)))))
       (set! var 0)
       (waste-time 200)
       (set! var (+ var 10))))))

(test-error-tail inactive-thread-exception? (thread-interrupt! t1))

(test-error-tail inactive-thread-exception? (thread-interrupt! t2))

(thread-start! t2)

(let loop () (or var (loop)))

(test-eq t2 (thread-interrupt! t2 current-thread))

(define save var)

(waste-time 100)

(thread-interrupt! t2)

(waste-time 200)

(let loop () (if (<= var save) (loop)))

(test-equal 11 var)

(test-error-tail type-exception? (thread-interrupt! #f))
(test-error-tail type-exception? (thread-interrupt! #f list))
(test-error-tail type-exception? (thread-interrupt! t1 #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-interrupt!))
(test-error-tail
 wrong-number-of-arguments-exception?
 (thread-interrupt! t1 list #f))
