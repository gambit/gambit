(include "#.scm")

;; Extra forms the coverage walker must expand without crashing.

(test-equal
 3
 (do ((i 0 (+ i 1)) (s 0 (+ s i)))
     ((> i 2) s)))

(test-equal
 7
 (parameterize () 7))

(test-equal
 11
 (guard (exc ((string? exc) 99)
             (else 11))
   (+ 5 6)))

(test-equal
 88
 (guard (exc ((string? exc) 88)
             (else 11))
   (raise "boom")))

(test-equal
 6
 (receive (a b) (values 2 4)
   (+ a b)))

(test-equal
 42
 (force (delay (* 6 7))))

(test-equal
 1
 (when #t 1))

(test-equal
 2
 (unless #f 2))

(test-equal
 3
 ((case-lambda ((a b) (+ a b))) 1 2))

(test-equal
 3
 (let-values (((a b) (values 1 2)))
   (+ a b)))
