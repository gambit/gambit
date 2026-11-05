(include "#.scm")

(define bool #f)

(test-equal '() (zip '()))
(test-equal '((1) (2) (3)) (zip '(1 2 3)))
(test-equal '() (zip '() '()))
(test-equal '((1 a) (2 b)) (zip '(1 2) '(a b)))
(test-equal '((1 a) (2 b)) (zip '(1 2 3) '(a b)))
(test-equal '((1 a x) (2 b y)) (zip '(1 2) '(a b) '(x y)))
(test-equal '((11 x) (22 y) (33 z)) (zip '(11 22 33) '(x y z)))

(test-error-tail type-exception? (zip bool))
(test-error-tail type-exception? (zip 11))
(test-error-tail type-exception? (zip '(11 . 22)))
(test-error-tail type-exception? (zip '(1 2) bool))
(test-error-tail type-exception? (zip '(1 2) '(a . b)))

(test-error-tail wrong-number-of-arguments-exception? (zip))
