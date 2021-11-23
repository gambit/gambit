(import (srfi 31))
(import (_test))

(test-equal 0 (car (force (cdr (rec endless (cons 0 (delay endless)))))))

(test-equal 0 ((rec (to-zero k)
                 (if (zero? k)
                     0
                     (to-zero (- k 1))))
               7))
