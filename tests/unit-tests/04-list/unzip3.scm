(include "#.scm")

(define bool #f)

(test-equal
 '(() () ())
 (call-with-values (lambda () (unzip3 '())) list))

(test-equal
 '((1) (a) (x))
 (call-with-values (lambda () (unzip3 '((1 a x)))) list))

(test-equal
 '((1 3) (a b) (x y))
 (call-with-values (lambda () (unzip3 '((1 a x) (3 b y)))) list))

(test-error-tail type-exception? (unzip3 bool))
(test-error-tail type-exception? (unzip3 '((1 a))))
(test-error-tail type-exception? (unzip3 '((1 a x) (2 b))))

(test-error-tail wrong-number-of-arguments-exception? (unzip3))
(test-error-tail wrong-number-of-arguments-exception? (unzip3 '() '()))
