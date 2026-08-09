(include "#.scm")

(test-equal '#() (vector-sort (lambda (x y) (< (car x) (car y))) '#()))

(test-equal
 '#((11 5) (22 2) (22 4) (33 1) (33 6) (55 3) (55 7))
 (vector-sort
  (lambda (x y) (< (car x) (car y)))
  '#((33 1) (22 2) (55 3) (22 4) (11 5) (33 6) (55 7))))

(test-equal
 '#((33 1) (22 2) (11 5) (22 4) (33 6) (55 3) (55 7))
 (vector-sort
  (lambda (x y) (< (car x) (car y)))
  '#((33 1) (22 2) (55 3) (22 4) (11 5) (33 6) (55 7))
  2))

(test-equal
 '#((33 1) (22 2) (11 5) (22 4) (55 3) (33 6) (55 7))
 (vector-sort
  (lambda (x y) (< (car x) (car y)))
  '#((33 1) (22 2) (55 3) (22 4) (11 5) (33 6) (55 7))
  2
  5))

(test-equal
 '#((33 1) (22 2) (55 3) (22 4) (11 5) (33 6) (55 7))
 (vector-sort
  (lambda (x y) (< (car x) (car y)))
  '#((33 1) (22 2) (55 3) (22 4) (11 5) (33 6) (55 7))
  2
  2))

(test-error-tail wrong-number-of-arguments-exception? (vector-sort))
(test-error-tail wrong-number-of-arguments-exception? (vector-sort <))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-sort < '#() 0 0 #f))

(test-error-tail type-exception? (vector-sort #f '#()))
(test-error-tail type-exception? (vector-sort < #f))
(test-error-tail type-exception? (vector-sort < '#() #f))
(test-error-tail type-exception? (vector-sort < '#() 0 #f))

(test-error-tail range-exception? (vector-sort < '#(3 1 2) -1))
(test-error-tail range-exception? (vector-sort < '#(3 1 2) 0 4))
(test-error-tail range-exception? (vector-sort < '#(3 1 2) 2 1))
