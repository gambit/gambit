(include "#.scm")

(test-equal
 (vector-cumulate + 0 '#(3 1 4 1 5 9 2 5 6))
 '#(3 4 8 9 14 23 25 30 36))

(test-error-tail type-exception? (vector-cumulate 4 4 'a))
(test-error-tail type-exception? (vector-cumulate values 'a 'a))

(test-error-tail wrong-number-of-arguments-exception? (vector-cumulate))
(test-error-tail wrong-number-of-arguments-exception? (vector-cumulate values))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-cumulate values 'a '#(1 2 3) 3))
