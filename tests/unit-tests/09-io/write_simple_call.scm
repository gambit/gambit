(include "#.scm")

;; write-simple/write-shared are passed as values in write_shared.scm, so the
;; coverage walker never records them as calls. Call them here.
(test-equal "(1 2 3)"
  (call-with-output-string (lambda (p) (write-simple '(1 2 3) p))))
(test-equal "(1 2 3)"
  (call-with-output-string (lambda (p) (write-shared '(1 2 3) p))))
(test-assert (output-port? (current-error-port)))
(test-eqv 1 (call-with-port (open-input-string "1") read))
(test-error-tail type-exception? (write-simple 1 1))
(test-error-tail type-exception? (write-shared 1 1))
(test-error-tail type-exception? (call-with-port 1 read))
