(include "#.scm")

(define bool #f)

(test-equal
 '(() () () ())
 (call-with-values (lambda () (unzip4 '())) list))

(test-equal
 '((1) (a) (x) (p))
 (call-with-values (lambda () (unzip4 '((1 a x p)))) list))

(test-equal
 '((1 3) (a b) (x y) (p q))
 (call-with-values (lambda () (unzip4 '((1 a x p) (3 b y q)))) list))

(test-error-tail type-exception? (unzip4 bool))
(test-error-tail type-exception? (unzip4 '((1 a x))))
(test-error-tail type-exception? (unzip4 '((1 a x p) (2 b y))))

(test-error-tail wrong-number-of-arguments-exception? (unzip4))
(test-error-tail wrong-number-of-arguments-exception? (unzip4 '() '()))
