(include "#.scm")

(define bool #f)

(test-equal '() (unzip1 '()))
(test-equal '(1) (unzip1 '((1))))
(test-equal '(1 3) (unzip1 '((1 a) (3 b))))
(test-equal '(11 22 33) (unzip1 '((11) (22) (33))))
(test-equal '(a b c) (unzip1 '((a 1) (b 2) (c 3))))

(test-error-tail type-exception? (unzip1 bool))
(test-error-tail type-exception? (unzip1 11))
(test-error-tail type-exception? (unzip1 '(11 . 22)))
(test-error-tail type-exception? (unzip1 '((1) ())))

(test-error-tail wrong-number-of-arguments-exception? (unzip1))
(test-error-tail wrong-number-of-arguments-exception? (unzip1 '() '()))
