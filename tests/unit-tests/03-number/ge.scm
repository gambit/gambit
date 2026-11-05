(include "#.scm")

(test-eq #t (##>=))
(test-eq #t (##>= 1))
(test-eq #f (##>= 1 2))
(test-eq #t (##>= 2 1))
(test-eq #t (##>= 5 4 3.))
(test-eq #t (##>= 5. 2))
(test-eq #f (##>= 5. 2 3.))

(test-eq #t (>=))
(test-eq #t (>= 1))
(test-eq #f (>= 1 2))
(test-eq #t (>= 2 1))
(test-eq #t (>= 5 4 3.))
(test-eq #t (>= 5. 2))
(test-eq #f (>= 5. 2 3.))

(test-error-tail type-exception? (>= #\c))
(test-error-tail type-exception? (>= +i))

