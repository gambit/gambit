(include "#.scm")

(test-assert (procedure? apropos))
(test-assert
 (string? (call-with-output-string (lambda (port) (apropos "identity" port)))))
(test-assert
 (string? (call-with-output-string (lambda (port) (apropos "$_!*%" port)))))

(test-error-tail wrong-number-of-arguments-exception? (apropos 1 2 3))
