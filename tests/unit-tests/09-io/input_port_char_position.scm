(include "#.scm")

;; input-port-char-position is only exercised outside test-* forms in
;; prim_port.scm. A string port is enough for the coverage walker.
(test-eqv 1 (call-with-input-string "x" (lambda (p) (read-char p) (input-port-char-position p))))
(test-error-tail type-exception? (input-port-char-position 1))
(test-error-tail wrong-number-of-arguments-exception? (input-port-char-position))
(test-error-tail wrong-number-of-arguments-exception? (input-port-char-position (current-input-port) 0))
