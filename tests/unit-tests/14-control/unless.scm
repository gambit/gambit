(include "#.scm")

(test-equal 3 (unless #f 3))
(test-equal 4 (unless #f 3 4))
(test-equal (void) (unless #t 3))
(test-equal (void) (unless #t 3 4))
(test-equal 1 (unless (= 1 2) 1))
(test-equal (void) (unless (= 1 1) 1))
