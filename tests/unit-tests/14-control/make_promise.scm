(include "#.scm")

(define pr (make-promise 7))
(test-assert (promise? pr))
(test-equal 7 (force pr))
(test-equal 7 (force pr))

(define pr2 (make-promise pr))
(test-eq pr pr2)

(test-eq #f (promise? 1))
(test-error-tail wrong-number-of-arguments-exception? (make-promise))
(test-error-tail wrong-number-of-arguments-exception? (make-promise 1 2))
