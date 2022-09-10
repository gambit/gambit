(include "#.scm")

(check-same-behavior ("" "##" "~~lib/gambit/prim/exception#.scm")

;; Gambit

;;unimplemented;;abort
;;unimplemented;;cfun-conversion-exception-arguments
;;unimplemented;;cfun-conversion-exception-code
;;unimplemented;;cfun-conversion-exception-message
;;unimplemented;;cfun-conversion-exception-procedure
;;unimplemented;;cfun-conversion-exception?
;;unimplemented;;current-exception-handler
;;unimplemented;;datum-parsing-exception-kind
;;unimplemented;;datum-parsing-exception-parameters
;;unimplemented;;datum-parsing-exception-readenv
;;unimplemented;;datum-parsing-exception?
;;unimplemented;;divide-by-zero-exception-arguments
;;unimplemented;;divide-by-zero-exception-procedure
;;unimplemented;;divide-by-zero-exception?

(with-exception-catcher
 (lambda (e) 42)
 (lambda () (begin (error "boom!") 99)))

;;unimplemented;;error-exception-message
;;unimplemented;;error-exception-parameters
;;unimplemented;;error-exception?
;;unimplemented;;error-object-irritants
;;unimplemented;;error-object-message
;;unimplemented;;error-object?
;;unimplemented;;expression-parsing-exception-kind
;;unimplemented;;expression-parsing-exception-parameters
;;unimplemented;;expression-parsing-exception-source
;;unimplemented;;expression-parsing-exception?
;;unimplemented;;file-exists-exception-arguments
;;unimplemented;;file-exists-exception-procedure
;;unimplemented;;file-exists-exception?
;;unimplemented;;fixnum-overflow-exception-arguments
;;unimplemented;;fixnum-overflow-exception-procedure
;;unimplemented;;fixnum-overflow-exception?
;;unimplemented;;heap-overflow-exception?
;;unimplemented;;invalid-hash-number-exception-arguments
;;unimplemented;;invalid-hash-number-exception-procedure
;;unimplemented;;invalid-hash-number-exception?
;;unimplemented;;invalid-utf8-encoding-exception-arguments
;;unimplemented;;invalid-utf8-encoding-exception-procedure
;;unimplemented;;invalid-utf8-encoding-exception?
;;unimplemented;;keyword-expected-exception-arguments
;;unimplemented;;keyword-expected-exception-procedure
;;unimplemented;;keyword-expected-exception?
;;unimplemented;;length-mismatch-exception-arg-id
;;unimplemented;;length-mismatch-exception-arguments
;;unimplemented;;length-mismatch-exception-procedure
;;unimplemented;;length-mismatch-exception?
;;unimplemented;;module-not-found-exception-arguments
;;unimplemented;;module-not-found-exception-procedure
;;unimplemented;;module-not-found-exception?
;;unimplemented;;multiple-c-return-exception?
;;unimplemented;;no-such-file-or-directory-exception-arguments
;;unimplemented;;no-such-file-or-directory-exception-procedure
;;unimplemented;;no-such-file-or-directory-exception?
;;unimplemented;;noncontinuable-exception-reason
;;unimplemented;;noncontinuable-exception?
;;unimplemented;;nonempty-input-port-character-buffer-exception-arguments
;;unimplemented;;nonempty-input-port-character-buffer-exception-procedure
;;unimplemented;;nonempty-input-port-character-buffer-exception?
;;unimplemented;;nonprocedure-operator-exception-arguments
;;unimplemented;;nonprocedure-operator-exception-code
;;unimplemented;;nonprocedure-operator-exception-operator
;;unimplemented;;nonprocedure-operator-exception-rte
;;unimplemented;;nonprocedure-operator-exception?
;;unimplemented;;number-of-arguments-limit-exception-arguments
;;unimplemented;;number-of-arguments-limit-exception-procedure
;;unimplemented;;number-of-arguments-limit-exception?
;;unimplemented;;os-exception-arguments
;;unimplemented;;os-exception-code
;;unimplemented;;os-exception-message
;;unimplemented;;os-exception-procedure
;;unimplemented;;os-exception?
;;unimplemented;;permission-denied-exception-arguments
;;unimplemented;;permission-denied-exception-procedure
;;unimplemented;;permission-denied-exception?
;;unimplemented;;primordial-exception-handler

(##with-exception-catcher ##list (lambda () (r7rs-raise 123)))
(##with-exception-catcher ##list (lambda () (r7rs-raise-continuable 123)))
(r7rs-with-exception-handler ##list (lambda () (##cons 1 (##raise 123))))
(##with-exception-catcher ##list (lambda () (raise 123)))

;;unimplemented;;range-exception-arg-id
;;unimplemented;;range-exception-arguments
;;unimplemented;;range-exception-procedure
;;unimplemented;;range-exception?
;;unimplemented;;rpc-remote-error-exception-arguments
;;unimplemented;;rpc-remote-error-exception-message
;;unimplemented;;rpc-remote-error-exception-procedure
;;unimplemented;;rpc-remote-error-exception?
;;unimplemented;;scheduler-exception-reason
;;unimplemented;;scheduler-exception?
;;unimplemented;;sfun-conversion-exception-arguments
;;unimplemented;;sfun-conversion-exception-code
;;unimplemented;;sfun-conversion-exception-message
;;unimplemented;;sfun-conversion-exception-procedure
;;unimplemented;;sfun-conversion-exception?
;;unimplemented;;stack-overflow-exception?
;;unimplemented;;type-exception-arg-id
;;unimplemented;;type-exception-arguments
;;unimplemented;;type-exception-procedure
;;unimplemented;;type-exception-type-id
;;unimplemented;;type-exception?
;;unimplemented;;unbound-global-exception-code
;;unimplemented;;unbound-global-exception-rte
;;unimplemented;;unbound-global-exception-variable
;;unimplemented;;unbound-global-exception?
;;unimplemented;;unbound-key-exception-arguments
;;unimplemented;;unbound-key-exception-procedure
;;unimplemented;;unbound-key-exception?
;;unimplemented;;unbound-os-environment-variable-exception-arguments
;;unimplemented;;unbound-os-environment-variable-exception-procedure
;;unimplemented;;unbound-os-environment-variable-exception?
;;unimplemented;;unbound-serial-number-exception-arguments
;;unimplemented;;unbound-serial-number-exception-procedure
;;unimplemented;;unbound-serial-number-exception?
;;unimplemented;;uncaught-exception-arguments
;;unimplemented;;uncaught-exception-procedure
;;unimplemented;;uncaught-exception-reason
;;unimplemented;;uncaught-exception?
;;unimplemented;;unknown-keyword-argument-exception-arguments
;;unimplemented;;unknown-keyword-argument-exception-procedure
;;unimplemented;;unknown-keyword-argument-exception?
;;unimplemented;;unterminated-process-exception-arguments
;;unimplemented;;unterminated-process-exception-procedure
;;unimplemented;;unterminated-process-exception?

(with-exception-catcher ##list (lambda () (##raise 123)))

(with-exception-handler ##list (lambda () (##cons 1 (##raise 123))))

;;unimplemented;;with-exception-catcher
;;unimplemented;;with-exception-handler
;;unimplemented;;wrong-number-of-arguments-exception-arguments
;;unimplemented;;wrong-number-of-arguments-exception-procedure
;;unimplemented;;wrong-number-of-arguments-exception?
;;unimplemented;;wrong-number-of-values-exception-code
;;unimplemented;;wrong-number-of-values-exception-rte
;;unimplemented;;wrong-number-of-values-exception-vals
;;unimplemented;;wrong-number-of-values-exception?
;;unimplemented;;wrong-processor-c-return-exception?

)
