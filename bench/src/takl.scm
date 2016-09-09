;;; TAKL -- The TAKeuchi function using lists as counters.
 
(define (listn n)
  (if (= n 0)
    '()
    (cons n (listn (- n 1)))))
 
(define l18 (listn 18))
(define l12 (listn 12))
(define  l6 (listn 6))
 
(define (mas x y z)
  (if (not (shorterp y x))
      z
      (mas (mas (cdr x) y z)
           (mas (cdr y) z x)
           (mas (cdr z) x y))))
 
(define (shorterp x y)
  (and (not (null? y))
       (or (null? x)
           (shorterp (cdr x)
                     (cdr y)))))
 
(define (main . args)
  (run-benchmark
    "takl"
    takl-iters
    (lambda (result) (equal? result '(7 6 5 4 3 2 1)))
    (lambda (x y z) (lambda () (mas x y z)))
    l18
    l12
    l6))
