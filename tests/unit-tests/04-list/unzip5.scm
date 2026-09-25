(include "#.scm")

(define bool #f)

(test-equal
 '(() () () () ())
 (call-with-values (lambda () (unzip5 '())) list))

(test-equal
 '((1) (a) (x) (p) (k))
 (call-with-values (lambda () (unzip5 '((1 a x p k)))) list))

(test-equal
 '((1 3) (a b) (x y) (p q) (k m))
 (call-with-values (lambda () (unzip5 '((1 a x p k) (3 b y q m)))) list))

(test-error-tail type-exception? (unzip5 bool))
(test-error-tail type-exception? (unzip5 '((1 a x p))))
(test-error-tail type-exception? (unzip5 '((1 a x p k) (2 b y q))))

(test-error-tail wrong-number-of-arguments-exception? (unzip5))
(test-error-tail wrong-number-of-arguments-exception? (unzip5 '() '()))
