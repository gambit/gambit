(include "#.scm")


(test-equal
 5
 (vector-fold
  (lambda (len str) (max (string-length str) len))
  0
  '#("a b c" "ab" "" "cde")))

(test-equal '(d c b a) (vector-fold xcons '() '#(a b c d)))
(test-equal
 3
 (vector-fold
  (lambda (counter n) (if (even? n) (+ counter 1) counter))
  0
  '#(0 1 2 3 4)))

(test-error-tail type-exception? (vector-fold 4 4 '#()))
(test-error-tail type-exception? (vector-fold xcons 4 '()))
(test-error-tail type-exception? (vector-fold xcons 4 '#() '()))

(test-error-tail wrong-number-of-arguments-exception? (vector-fold))
(test-error-tail wrong-number-of-arguments-exception? (vector-fold xcons))
(test-error-tail wrong-number-of-arguments-exception? (vector-fold xcons 0))

(set! ##allow-length-mismatch? #f)
(test-error-tail
 length-mismatch-exception?
 (vector-fold + 0 '#(1) '#(1 2) '#(1)))
