;;;============================================================================

;;; File: "_prim-exception-gambit#.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Exception operations in Gambit.

(##namespace ("##"

(abort abort#unimplemented)
(cfun-conversion-exception-arguments cfun-conversion-exception-arguments#unimplemented)
(cfun-conversion-exception-code cfun-conversion-exception-code#unimplemented)
(cfun-conversion-exception-message cfun-conversion-exception-message#unimplemented)
(cfun-conversion-exception-procedure cfun-conversion-exception-procedure#unimplemented)
(cfun-conversion-exception? cfun-conversion-exception?#unimplemented)
(current-exception-handler current-exception-handler#unimplemented)
(datum-parsing-exception-kind datum-parsing-exception-kind#unimplemented)
(datum-parsing-exception-parameters datum-parsing-exception-parameters#unimplemented)
(datum-parsing-exception-readenv datum-parsing-exception-readenv#unimplemented)
(datum-parsing-exception? datum-parsing-exception?#unimplemented)
(divide-by-zero-exception-arguments divide-by-zero-exception-arguments#unimplemented)
(divide-by-zero-exception-procedure divide-by-zero-exception-procedure#unimplemented)
(divide-by-zero-exception? divide-by-zero-exception?#unimplemented)

error

(error-exception-message error-exception-message#unimplemented)
(error-exception-parameters error-exception-parameters#unimplemented)
(error-exception? error-exception?#unimplemented)
(error-object-irritants error-object-irritants#unimplemented)
(error-object-message error-object-message#unimplemented)
(error-object? error-object?#unimplemented)
(expression-parsing-exception-kind expression-parsing-exception-kind#unimplemented)
(expression-parsing-exception-parameters expression-parsing-exception-parameters#unimplemented)
(expression-parsing-exception-source expression-parsing-exception-source#unimplemented)
(expression-parsing-exception? expression-parsing-exception?#unimplemented)
(file-exists-exception-arguments file-exists-exception-arguments#unimplemented)
(file-exists-exception-procedure file-exists-exception-procedure#unimplemented)
(file-exists-exception? file-exists-exception?#unimplemented)
(fixnum-overflow-exception-arguments fixnum-overflow-exception-arguments#unimplemented)
(fixnum-overflow-exception-procedure fixnum-overflow-exception-procedure#unimplemented)
(fixnum-overflow-exception? fixnum-overflow-exception?#unimplemented)
(heap-overflow-exception? heap-overflow-exception?#unimplemented)
(invalid-hash-number-exception-arguments invalid-hash-number-exception-arguments#unimplemented)
(invalid-hash-number-exception-procedure invalid-hash-number-exception-procedure#unimplemented)
(invalid-hash-number-exception? invalid-hash-number-exception?#unimplemented)
(invalid-utf8-encoding-exception-arguments invalid-utf8-encoding-exception-arguments#unimplemented)
(invalid-utf8-encoding-exception-procedure invalid-utf8-encoding-exception-procedure#unimplemented)
(invalid-utf8-encoding-exception? invalid-utf8-encoding-exception?#unimplemented)
(keyword-expected-exception-arguments keyword-expected-exception-arguments#unimplemented)
(keyword-expected-exception-procedure keyword-expected-exception-procedure#unimplemented)
(keyword-expected-exception? keyword-expected-exception?#unimplemented)
(length-mismatch-exception-arg-num length-mismatch-exception-arg-num#unimplemented)
(length-mismatch-exception-arguments length-mismatch-exception-arguments#unimplemented)
(length-mismatch-exception-procedure length-mismatch-exception-procedure#unimplemented)
(length-mismatch-exception? length-mismatch-exception?#unimplemented)
(module-not-found-exception-arguments module-not-found-exception-arguments#unimplemented)
(module-not-found-exception-procedure module-not-found-exception-procedure#unimplemented)
(module-not-found-exception? module-not-found-exception?#unimplemented)
(multiple-c-return-exception? multiple-c-return-exception?#unimplemented)
(no-such-file-or-directory-exception-arguments no-such-file-or-directory-exception-arguments#unimplemented)
(no-such-file-or-directory-exception-procedure no-such-file-or-directory-exception-procedure#unimplemented)
(no-such-file-or-directory-exception? no-such-file-or-directory-exception?#unimplemented)
(noncontinuable-exception-reason noncontinuable-exception-reason#unimplemented)
(noncontinuable-exception? noncontinuable-exception?#unimplemented)
(nonempty-input-port-character-buffer-exception-arguments nonempty-input-port-character-buffer-exception-arguments#unimplemented)
(nonempty-input-port-character-buffer-exception-procedure nonempty-input-port-character-buffer-exception-procedure#unimplemented)
(nonempty-input-port-character-buffer-exception? nonempty-input-port-character-buffer-exception?#unimplemented)
(nonprocedure-operator-exception-arguments nonprocedure-operator-exception-arguments#unimplemented)
(nonprocedure-operator-exception-code nonprocedure-operator-exception-code#unimplemented)
(nonprocedure-operator-exception-operator nonprocedure-operator-exception-operator#unimplemented)
(nonprocedure-operator-exception-rte nonprocedure-operator-exception-rte#unimplemented)
(nonprocedure-operator-exception? nonprocedure-operator-exception?#unimplemented)
(number-of-arguments-limit-exception-arguments number-of-arguments-limit-exception-arguments#unimplemented)
(number-of-arguments-limit-exception-procedure number-of-arguments-limit-exception-procedure#unimplemented)
(number-of-arguments-limit-exception? number-of-arguments-limit-exception?#unimplemented)
(os-exception-arguments os-exception-arguments#unimplemented)
(os-exception-code os-exception-code#unimplemented)
(os-exception-message os-exception-message#unimplemented)
(os-exception-procedure os-exception-procedure#unimplemented)
(os-exception? os-exception?#unimplemented)
(primordial-exception-handler primordial-exception-handler#unimplemented)

raise

(range-exception-arg-num range-exception-arg-num#unimplemented)
(range-exception-arguments range-exception-arguments#unimplemented)
(range-exception-procedure range-exception-procedure#unimplemented)
(range-exception? range-exception?#unimplemented)
(rpc-remote-error-exception-arguments rpc-remote-error-exception-arguments#unimplemented)
(rpc-remote-error-exception-message rpc-remote-error-exception-message#unimplemented)
(rpc-remote-error-exception-procedure rpc-remote-error-exception-procedure#unimplemented)
(rpc-remote-error-exception? rpc-remote-error-exception?#unimplemented)
(scheduler-exception-reason scheduler-exception-reason#unimplemented)
(scheduler-exception? scheduler-exception?#unimplemented)
(sfun-conversion-exception-arguments sfun-conversion-exception-arguments#unimplemented)
(sfun-conversion-exception-code sfun-conversion-exception-code#unimplemented)
(sfun-conversion-exception-message sfun-conversion-exception-message#unimplemented)
(sfun-conversion-exception-procedure sfun-conversion-exception-procedure#unimplemented)
(sfun-conversion-exception? sfun-conversion-exception?#unimplemented)
(stack-overflow-exception? stack-overflow-exception?#unimplemented)
(type-exception-arg-num type-exception-arg-num#unimplemented)
(type-exception-arguments type-exception-arguments#unimplemented)
(type-exception-procedure type-exception-procedure#unimplemented)
(type-exception-type-id type-exception-type-id#unimplemented)
(type-exception? type-exception?#unimplemented)
(unbound-global-exception-code unbound-global-exception-code#unimplemented)
(unbound-global-exception-rte unbound-global-exception-rte#unimplemented)
(unbound-global-exception-variable unbound-global-exception-variable#unimplemented)
(unbound-global-exception? unbound-global-exception?#unimplemented)
(unbound-key-exception-arguments unbound-key-exception-arguments#unimplemented)
(unbound-key-exception-procedure unbound-key-exception-procedure#unimplemented)
(unbound-key-exception? unbound-key-exception?#unimplemented)
(unbound-os-environment-variable-exception-arguments unbound-os-environment-variable-exception-arguments#unimplemented)
(unbound-os-environment-variable-exception-procedure unbound-os-environment-variable-exception-procedure#unimplemented)
(unbound-os-environment-variable-exception? unbound-os-environment-variable-exception?#unimplemented)
(unbound-serial-number-exception-arguments unbound-serial-number-exception-arguments#unimplemented)
(unbound-serial-number-exception-procedure unbound-serial-number-exception-procedure#unimplemented)
(unbound-serial-number-exception? unbound-serial-number-exception?#unimplemented)
(uncaught-exception-arguments uncaught-exception-arguments#unimplemented)
(uncaught-exception-procedure uncaught-exception-procedure#unimplemented)
(uncaught-exception-reason uncaught-exception-reason#unimplemented)
(uncaught-exception? uncaught-exception?#unimplemented)
(unknown-keyword-argument-exception-arguments unknown-keyword-argument-exception-arguments#unimplemented)
(unknown-keyword-argument-exception-procedure unknown-keyword-argument-exception-procedure#unimplemented)
(unknown-keyword-argument-exception? unknown-keyword-argument-exception?#unimplemented)
(unterminated-process-exception-arguments unterminated-process-exception-arguments#unimplemented)
(unterminated-process-exception-procedure unterminated-process-exception-procedure#unimplemented)
(unterminated-process-exception? unterminated-process-exception?#unimplemented)

with-exception-catcher
with-exception-handler

(wrong-number-of-arguments-exception-arguments wrong-number-of-arguments-exception-arguments#unimplemented)
(wrong-number-of-arguments-exception-procedure wrong-number-of-arguments-exception-procedure#unimplemented)
(wrong-number-of-arguments-exception? wrong-number-of-arguments-exception?#unimplemented)
(wrong-number-of-values-exception-code wrong-number-of-values-exception-code#unimplemented)
(wrong-number-of-values-exception-rte wrong-number-of-values-exception-rte#unimplemented)
(wrong-number-of-values-exception-vals wrong-number-of-values-exception-vals#unimplemented)
(wrong-number-of-values-exception? wrong-number-of-values-exception?#unimplemented)
(wrong-processor-c-return-exception? wrong-processor-c-return-exception?#unimplemented)

))

;;;============================================================================