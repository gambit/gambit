(include "#.scm")

(test-equal 2 (when #t 1 2))
(test-equal 1 (when #t 1))
(test-equal (void) (when #f 1))
(test-equal (void) (when #f 1 2))
(test-equal 1 (when (= 1 1) 1))
(test-equal (void) (when (= 1 2) 1))
