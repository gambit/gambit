(include "#.scm")

(define f
  (case-lambda
   (() 0)
   ((x) x)
   ((x y) (+ x y))
   (rest (apply + rest))))

(test-equal 0 (f))
(test-equal 7 (f 7))
(test-equal 10 (f 4 6))
(test-equal 10 (f 1 2 3 4))
(test-equal 3 ((case-lambda ((a b) (+ a b))) 1 2))

(define g
  (case-lambda
   ((x) 'one)
   ((x y) 'two)))

(test-equal 'one (g 1))
(test-equal 'two (g 1 2))
(test-error-tail wrong-number-of-arguments-exception? (g))
(test-error-tail wrong-number-of-arguments-exception? (g 1 2 3))
(test-error-tail wrong-number-of-arguments-exception?
                 ((case-lambda ((a) a))))
(test-error-tail wrong-number-of-arguments-exception?
                 ((case-lambda ((a) a)) 1 2))
