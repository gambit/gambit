;;;============================================================================

;;; File: "exception.sld"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Exception operations.

(define-library (exception)

  (namespace "##")

  (export

;; gambit

;;UNIMPLEMENTED abort
;;UNIMPLEMENTED cfun-conversion-exception-arguments
;;UNIMPLEMENTED cfun-conversion-exception-code
;;UNIMPLEMENTED cfun-conversion-exception-message
;;UNIMPLEMENTED cfun-conversion-exception-procedure
;;UNIMPLEMENTED cfun-conversion-exception?
;;UNIMPLEMENTED current-exception-handler
;;UNIMPLEMENTED datum-parsing-exception-kind
;;UNIMPLEMENTED datum-parsing-exception-parameters
;;UNIMPLEMENTED datum-parsing-exception-readenv
;;UNIMPLEMENTED datum-parsing-exception?
;;UNIMPLEMENTED divide-by-zero-exception-arguments
;;UNIMPLEMENTED divide-by-zero-exception-procedure
;;UNIMPLEMENTED divide-by-zero-exception?

error

;;UNIMPLEMENTED error-exception-message
;;UNIMPLEMENTED error-exception-parameters
;;UNIMPLEMENTED error-exception?
;;UNIMPLEMENTED error-object-irritants
;;UNIMPLEMENTED error-object-message
;;UNIMPLEMENTED error-object?
;;UNIMPLEMENTED expression-parsing-exception-kind
;;UNIMPLEMENTED expression-parsing-exception-parameters
;;UNIMPLEMENTED expression-parsing-exception-source
;;UNIMPLEMENTED expression-parsing-exception?
;;UNIMPLEMENTED file-exists-exception-arguments
;;UNIMPLEMENTED file-exists-exception-procedure
;;UNIMPLEMENTED file-exists-exception?
;;UNIMPLEMENTED fixnum-overflow-exception-arguments
;;UNIMPLEMENTED fixnum-overflow-exception-procedure
;;UNIMPLEMENTED fixnum-overflow-exception?
;;UNIMPLEMENTED heap-overflow-exception?
;;UNIMPLEMENTED invalid-hash-number-exception-arguments
;;UNIMPLEMENTED invalid-hash-number-exception-procedure
;;UNIMPLEMENTED invalid-hash-number-exception?
;;UNIMPLEMENTED invalid-utf8-encoding-exception-arguments
;;UNIMPLEMENTED invalid-utf8-encoding-exception-procedure
;;UNIMPLEMENTED invalid-utf8-encoding-exception?
;;UNIMPLEMENTED keyword-expected-exception-arguments
;;UNIMPLEMENTED keyword-expected-exception-procedure
;;UNIMPLEMENTED keyword-expected-exception?
;;UNIMPLEMENTED length-mismatch-exception-arg-num
;;UNIMPLEMENTED length-mismatch-exception-arguments
;;UNIMPLEMENTED length-mismatch-exception-procedure
;;UNIMPLEMENTED length-mismatch-exception?
;;UNIMPLEMENTED module-not-found-exception-arguments
;;UNIMPLEMENTED module-not-found-exception-procedure
;;UNIMPLEMENTED module-not-found-exception?
;;UNIMPLEMENTED multiple-c-return-exception?
;;UNIMPLEMENTED no-such-file-or-directory-exception-arguments
;;UNIMPLEMENTED no-such-file-or-directory-exception-procedure
;;UNIMPLEMENTED no-such-file-or-directory-exception?
;;UNIMPLEMENTED noncontinuable-exception-reason
;;UNIMPLEMENTED noncontinuable-exception?
;;UNIMPLEMENTED nonempty-input-port-character-buffer-exception-arguments
;;UNIMPLEMENTED nonempty-input-port-character-buffer-exception-procedure
;;UNIMPLEMENTED nonempty-input-port-character-buffer-exception?
;;UNIMPLEMENTED nonprocedure-operator-exception-arguments
;;UNIMPLEMENTED nonprocedure-operator-exception-code
;;UNIMPLEMENTED nonprocedure-operator-exception-operator
;;UNIMPLEMENTED nonprocedure-operator-exception-rte
;;UNIMPLEMENTED nonprocedure-operator-exception?
;;UNIMPLEMENTED number-of-arguments-limit-exception-arguments
;;UNIMPLEMENTED number-of-arguments-limit-exception-procedure
;;UNIMPLEMENTED number-of-arguments-limit-exception?
;;UNIMPLEMENTED os-exception-arguments
;;UNIMPLEMENTED os-exception-code
;;UNIMPLEMENTED os-exception-message
;;UNIMPLEMENTED os-exception-procedure
;;UNIMPLEMENTED os-exception?
;;UNIMPLEMENTED permission-denied-exception-arguments
;;UNIMPLEMENTED permission-denied-exception-procedure
;;UNIMPLEMENTED permission-denied-exception?
;;UNIMPLEMENTED primordial-exception-handler

r7rs-raise
r7rs-raise-continuable
r7rs-with-exception-handler
raise

;;UNIMPLEMENTED range-exception-arg-num
;;UNIMPLEMENTED range-exception-arguments
;;UNIMPLEMENTED range-exception-procedure
;;UNIMPLEMENTED range-exception?
;;UNIMPLEMENTED rpc-remote-error-exception-arguments
;;UNIMPLEMENTED rpc-remote-error-exception-message
;;UNIMPLEMENTED rpc-remote-error-exception-procedure
;;UNIMPLEMENTED rpc-remote-error-exception?
;;UNIMPLEMENTED scheduler-exception-reason
;;UNIMPLEMENTED scheduler-exception?
;;UNIMPLEMENTED sfun-conversion-exception-arguments
;;UNIMPLEMENTED sfun-conversion-exception-code
;;UNIMPLEMENTED sfun-conversion-exception-message
;;UNIMPLEMENTED sfun-conversion-exception-procedure
;;UNIMPLEMENTED sfun-conversion-exception?
;;UNIMPLEMENTED stack-overflow-exception?
;;UNIMPLEMENTED type-exception-arg-num
;;UNIMPLEMENTED type-exception-arguments
;;UNIMPLEMENTED type-exception-procedure
;;UNIMPLEMENTED type-exception-type-id
;;UNIMPLEMENTED type-exception?
;;UNIMPLEMENTED unbound-global-exception-code
;;UNIMPLEMENTED unbound-global-exception-rte
;;UNIMPLEMENTED unbound-global-exception-variable
;;UNIMPLEMENTED unbound-global-exception?
;;UNIMPLEMENTED unbound-key-exception-arguments
;;UNIMPLEMENTED unbound-key-exception-procedure
;;UNIMPLEMENTED unbound-key-exception?
;;UNIMPLEMENTED unbound-os-environment-variable-exception-arguments
;;UNIMPLEMENTED unbound-os-environment-variable-exception-procedure
;;UNIMPLEMENTED unbound-os-environment-variable-exception?
;;UNIMPLEMENTED unbound-serial-number-exception-arguments
;;UNIMPLEMENTED unbound-serial-number-exception-procedure
;;UNIMPLEMENTED unbound-serial-number-exception?
;;UNIMPLEMENTED uncaught-exception-arguments
;;UNIMPLEMENTED uncaught-exception-procedure
;;UNIMPLEMENTED uncaught-exception-reason
;;UNIMPLEMENTED uncaught-exception?
;;UNIMPLEMENTED unknown-keyword-argument-exception-arguments
;;UNIMPLEMENTED unknown-keyword-argument-exception-procedure
;;UNIMPLEMENTED unknown-keyword-argument-exception?
;;UNIMPLEMENTED unterminated-process-exception-arguments
;;UNIMPLEMENTED unterminated-process-exception-procedure
;;UNIMPLEMENTED unterminated-process-exception?

with-exception-catcher
with-exception-handler

;;UNIMPLEMENTED wrong-number-of-arguments-exception-arguments
;;UNIMPLEMENTED wrong-number-of-arguments-exception-procedure
;;UNIMPLEMENTED wrong-number-of-arguments-exception?
;;UNIMPLEMENTED wrong-number-of-values-exception-code
;;UNIMPLEMENTED wrong-number-of-values-exception-rte
;;UNIMPLEMENTED wrong-number-of-values-exception-vals
;;UNIMPLEMENTED wrong-number-of-values-exception?
;;UNIMPLEMENTED wrong-processor-c-return-exception?

))

;;;============================================================================
