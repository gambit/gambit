(include "#.scm")

;; Vector ports are only called outside test-* forms in prim_port.scm.
;; The competing extra files cover u8vector memory ports, not these names.
(test-eq 'a (call-with-input-vector '#(a b) read))
(test-assert (vector? (call-with-output-vector (lambda (p) (write 'x p)))))
(test-assert (input-port? (open-input-vector '#(a))))
(test-assert (output-port? (open-output-vector)))
(test-error-tail type-exception? (call-with-input-vector 1 read))
(test-error-tail type-exception? (open-input-vector 1))
(test-error-tail type-exception? (get-output-vector 1))
(test-error-tail wrong-number-of-arguments-exception? (call-with-input-vector))
(test-error-tail wrong-number-of-arguments-exception? (open-output-vector '#() 1))
