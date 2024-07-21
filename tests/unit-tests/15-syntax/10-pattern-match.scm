(include "#.scm")

(include "pattern-match.scm")

(check-true pattern-match-is-included)

(check-equal?
  (match (list 0 42 2) ((a b c) b))
  42)

(check-equal?
  (match (list 1 2 3) ((a b c ...) b))
  2)

(check-equal?
  (match (list 1 2 3) ((a b c ...) c))
  '(3))

