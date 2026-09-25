(include "#.scm")

(test-assert (procedure? pp))

(test-equal
 "1\n"
 (call-with-output-string (lambda (p) (pp 1 p))))

(test-equal
 "123\n"
 (call-with-output-string (lambda (p) (pp 123 p))))

(test-equal
 "sym\n"
 (call-with-output-string (lambda (p) (pp 'sym p))))

(test-equal
 "\"hello\\nworld\"\n"
 (call-with-output-string (lambda (p) (pp "hello\nworld" p))))

(test-equal
 "(1 2 . 3)\n"
 (call-with-output-string (lambda (p) (pp '(1 2 . 3) p))))

(test-error-tail type-exception? (pp 1 #f))
(test-error-tail wrong-number-of-arguments-exception? (pp))
