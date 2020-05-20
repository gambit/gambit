(include "#.scm")

(define (test n)
  (println (string-length (number->string (arithmetic-shift 1 n)))))

(test 101639) ;; did not cause the issue
(test 101652) ;; was triggering a problem in the reciprocal cache
