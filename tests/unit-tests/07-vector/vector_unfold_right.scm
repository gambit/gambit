(include "#.scm")

(test-equal '#() (vector-unfold-right values 0))

(test-equal
 (vector-unfold-right (lambda (i x) (values (cons i x) (+ x 1))) 5 0)
 '#((0 . 4) (1 . 3) (2 . 2) (3 . 1) (4 . 0)))

(test-equal
 (let ((vec '#(0 1 2 3 4)))
   (vector-unfold-right
    (lambda (i x) (values (vector-ref vec x) (+ x 1)))
    (vector-length vec)
    0))
 '#(4 3 2 1 0))

(test-error-tail type-exception? (vector-unfold-right 4 4))
(test-error-tail type-exception? (vector-unfold-right values 'a))

(test-error-tail range-exception? (vector-unfold-right values -1))

(test-error-tail wrong-number-of-arguments-exception? (vector-unfold-right))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-unfold-right values))
