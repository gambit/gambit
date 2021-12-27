;;;============================================================================

;;; File: "misc-gambit#.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Miscellaneous operations added by Gambit.

(##namespace ("##"

apropos

(break unimplemented#break)
(call/cc unimplemented#call/cc)

compilation-target

(not-in-compilation-context-exception-arguments unimplemented#not-in-compilation-context-exception-arguments)
(not-in-compilation-context-exception-procedure unimplemented#not-in-compilation-context-exception-procedure)
(not-in-compilation-context-exception? unimplemented#not-in-compilation-context-exception?)

(compile-file unimplemented#compile-file)
(compile-file-to-target unimplemented#compile-file-to-target)

continuation-capture
continuation-graft
continuation-return
continuation?

(datum->syntax unimplemented#datum->syntax)

dead-end
define-module-alias

(display-continuation-backtrace unimplemented#display-continuation-backtrace)
(display-continuation-dynamic-environment unimplemented#display-continuation-dynamic-environment)
(display-continuation-environment unimplemented#display-continuation-environment)
(display-dynamic-environment? unimplemented#display-dynamic-environment?)
(display-environment-set! unimplemented#display-environment-set!)
(display-exception unimplemented#display-exception)
(display-exception-in-context unimplemented#display-exception-in-context)
(display-procedure-environment unimplemented#display-procedure-environment)

eq?-hash
equal?-hash
eqv?-hash

(gc-report-set! unimplemented#gc-report-set!)
(generate-proper-tail-calls unimplemented#generate-proper-tail-calls)
(help unimplemented#help)
(help-browser unimplemented#help-browser)

identity

(link-flat unimplemented#link-flat)
(link-incremental unimplemented#link-incremental)
(main unimplemented#main)
(object->serial-number unimplemented#object->serial-number)

poll-point

(repl-display-environment? unimplemented#repl-display-environment?)

repl-error-port
repl-input-port
repl-output-port

(repl-result-history-max-length-set! unimplemented#repl-result-history-max-length-set!)
(repl-result-history-ref unimplemented#repl-result-history-ref)
(serial-number->object unimplemented#serial-number->object)
(step unimplemented#step)
(step-level-set! unimplemented#step-level-set!)
(syntax->datum unimplemented#syntax->datum)
(syntax->list unimplemented#syntax->list)
(syntax->vector unimplemented#syntax->vector)
(touch unimplemented#touch)
(trace unimplemented#trace)
(unbreak unimplemented#unbreak)
(untrace unimplemented#untrace)

void

))

;;;============================================================================
