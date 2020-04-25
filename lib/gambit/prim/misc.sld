;;;============================================================================

;;; File: "misc.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Miscellaneous operations.

(define-library (misc)

  (namespace "##")

  (export

;; r4rs

apply
call-with-current-continuation
eq?
equal?
eqv?
;;UNIMPLEMENTED load
procedure?
;;UNIMPLEMENTED transcript-off
;;UNIMPLEMENTED transcript-on

;; r5rs

call-with-values
dynamic-wind
eval
;;UNIMPLEMENTED interaction-environment
;;UNIMPLEMENTED null-environment
;;UNIMPLEMENTED scheme-report-environment
values

;; r7rs

;;UNIMPLEMENTED features
;;UNIMPLEMENTED make-parameter
;;UNIMPLEMENTED make-promise
;;UNIMPLEMENTED promise?

;; gambit

;;UNIMPLEMENTED break
;;UNIMPLEMENTED call/cc
;;UNIMPLEMENTED compile-file
;;UNIMPLEMENTED compile-file-to-target

continuation-capture
continuation-graft
continuation-return
continuation?

;;UNIMPLEMENTED display-continuation-backtrace
;;UNIMPLEMENTED display-continuation-dynamic-environment
;;UNIMPLEMENTED display-continuation-environment
;;UNIMPLEMENTED display-dynamic-environment?
;;UNIMPLEMENTED display-environment-set!
;;UNIMPLEMENTED display-exception
;;UNIMPLEMENTED display-exception-in-context
;;UNIMPLEMENTED display-procedure-environment

eq?-hash
equal?-hash
eqv?-hash

;;UNIMPLEMENTED gc-report-set!
;;UNIMPLEMENTED generate-proper-tail-calls
;;UNIMPLEMENTED help
;;UNIMPLEMENTED help-browser

identity

;;UNIMPLEMENTED link-flat
;;UNIMPLEMENTED link-incremental
;;UNIMPLEMENTED main
;;UNIMPLEMENTED object->serial-number
;;UNIMPLEMENTED repl-display-environment?
;;UNIMPLEMENTED repl-input-port
;;UNIMPLEMENTED repl-output-port
;;UNIMPLEMENTED repl-result-history-max-length-set!
;;UNIMPLEMENTED repl-result-history-ref
;;UNIMPLEMENTED serial-number->object
;;UNIMPLEMENTED step
;;UNIMPLEMENTED step-level-set!
;;UNIMPLEMENTED touch
;;UNIMPLEMENTED trace
;;UNIMPLEMENTED unbreak
;;UNIMPLEMENTED untrace

void

))

;;;============================================================================
