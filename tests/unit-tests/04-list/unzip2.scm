(include "#.scm")

(define bool #f)

(test-equal
 '(() ())
 (call-with-values (lambda () (unzip2 '())) list))

(test-equal
 '((1) (a))
 (call-with-values (lambda () (unzip2 '((1 a)))) list))

(test-equal
 '((1 3) (a b))
 (call-with-values (lambda () (unzip2 '((1 a) (3 b)))) list))

(test-equal
 '((11 22 33) (x y z))
 (call-with-values (lambda () (unzip2 '((11 x) (22 y) (33 z)))) list))

(test-error-tail type-exception? (unzip2 bool))
(test-error-tail type-exception? (unzip2 11))
(test-error-tail type-exception? (unzip2 '(11 . 22)))
(test-error-tail type-exception? (unzip2 '((1))))
(test-error-tail type-exception? (unzip2 '((1 a) (2))))

(test-error-tail wrong-number-of-arguments-exception? (unzip2))
(test-error-tail wrong-number-of-arguments-exception? (unzip2 '() '()))
