;;; DIVREC -- Benchmark which divides by 2 using lists of n ()'s.
 
(define (create-n n)
  (do ((n n (- n 1))
       (a '() (cons '() a)))
      ((= n 0) a)))
 
(define *ll* (create-n 200))

(define (recursive-div2 l)
  (cond ((null? l) '())
        (else (cons (car l) (recursive-div2 (cddr l))))))
  
(define (main . args)
  (run-benchmark
    "divrec"
    divrec-iters
    (lambda (result)
      (equal? result
              '(() () () () () () () () () () () () () () () () () () () ()
                () () () () () () () () () () () () () () () () () () () ()
                () () () () () () () () () () () () () () () () () () () ()
                () () () () () () () () () () () () () () () () () () () ()
                () () () () () () () () () () () () () () () () () () () ())))
    (lambda (l) (lambda () (recursive-div2 l)))
    *ll*))
