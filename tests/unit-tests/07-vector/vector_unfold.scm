(include "#.scm")

(test-equal '#() (vector-unfold values 0))

(test-equal
 '#(1 2 3 5 8 13 21 34 55 89)
 (vector-unfold (lambda (k i j) (values j j (+ i j))) 10 1 1))

(test-equal '#(0 1 2 3 4 5 6 7 8 9) (vector-unfold values 10))

(let ((v '#(0 2 4 6 8)))
  (test-equal '#(0 2 4) (vector-unfold (lambda (i) (vector-ref v i)) 3)))

(test-error-tail type-exception? (vector-unfold 4 4))
(test-error-tail type-exception? (vector-unfold values 'a))

(test-error-tail range-exception? (vector-unfold values -1))

(test-error-tail wrong-number-of-arguments-exception? (vector-unfold))
(test-error-tail wrong-number-of-arguments-exception? (vector-unfold values))
