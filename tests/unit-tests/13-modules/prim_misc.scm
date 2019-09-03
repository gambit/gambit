(include "#.scm")

(check-same-behavior ("" "##" "~~lib/_prim-misc#.scm")

;; R4RS

(apply ##list (##list 1 2 3)) (apply ##list 1 2 3 (##list 4 5 6))

(call-with-current-continuation (lambda (k) (k 123))) (call-with-current-continuation (lambda (k a) (k (##list a))) 1) (call-with-current-continuation (lambda (k a b) (k (##list a b))) 1 2)

(eq? #t #t)

(equal? '(1 2 3) '(1 2 3))

(eqv? 123 123)

;;unimplemented;;load

(procedure? ##list)

;;unimplemented;;transcript-off
;;unimplemented;;transcript-on

;; R5RS

(call-with-values (lambda () (##values 1 2)) ##list)

(dynamic-wind (lambda () 1) (lambda () 2) (lambda () 3))

(eval 123)

;;unimplemented;;(interaction-environment)
;;unimplemented;;(null-environment)
;;unimplemented;;(scheme-report-environment)

(##call-with-values (lambda () (values)) ##list) (##call-with-values (lambda () (values 1)) ##list) (##call-with-values (lambda () (values 1 2)) ##list)

;; R7RS

;;unimplemented;;features
;;unimplemented;;make-parameter
;;unimplemented;;make-promise
;;unimplemented;;promise?

;; Gambit

;;unimplemented;;break
;;unimplemented;;call/cc
;;unimplemented;;compile-file
;;unimplemented;;compile-file-to-target

(continuation-capture (lambda (k) (##cons 42 (continuation-graft k (lambda () 123)))))
(continuation-capture (lambda (k a) (##cons 42 (continuation-graft k ##list a))) 1)
(continuation-capture (lambda (k a b) (##cons 42 (continuation-graft k ##list a b))) 1 2)
(continuation-capture (lambda (k a b c) (##cons 42 (continuation-graft k ##list a b c))) 1 2 3)
(continuation-capture (lambda (k a b c d) (##cons 42 (continuation-graft k ##list a b c d))) 1 2 3 4)

(continuation-capture (lambda (k) (##cons 42 (continuation-return k 123))))
(##call-with-values (lambda () (continuation-capture (lambda (k a) (##cons 42 (continuation-return k a))) 1)) ##list)
(##call-with-values (lambda () (continuation-capture (lambda (k a b) (##cons 42 (continuation-return k a b))) 1 2)) ##list)
(##call-with-values (lambda () (continuation-capture (lambda (k a b c) (##cons 42 (continuation-return k a b c))) 1 2 3)) ##list)
(##call-with-values (lambda () (continuation-capture (lambda (k a b c d) (##cons 42 (continuation-return k a b c d))) 1 2 3 4)) ##list)

(continuation? (##continuation-capture (lambda (k) k)))

;;unimplemented;;display-continuation-backtrace
;;unimplemented;;display-continuation-dynamic-environment
;;unimplemented;;display-continuation-environment
;;unimplemented;;display-dynamic-environment?
;;unimplemented;;display-environment-set!
;;unimplemented;;display-exception
;;unimplemented;;display-exception-in-context
;;unimplemented;;display-procedure-environment
;;unimplemented;;eq?-hash
;;unimplemented;;equal?-hash
;;unimplemented;;eqv?-hash
;;unimplemented;;gc-report-set!
;;unimplemented;;generate-proper-tail-calls
;;unimplemented;;help
;;unimplemented;;help-browser
;;unimplemented;;identity
;;unimplemented;;link-flat
;;unimplemented;;link-incremental
;;unimplemented;;main
;;unimplemented;;object->serial-number
;;unimplemented;;repl-display-environment?
;;unimplemented;;repl-input-port
;;unimplemented;;repl-output-port
;;unimplemented;;repl-result-history-max-length-set!
;;unimplemented;;repl-result-history-ref
;;unimplemented;;serial-number->object
;;unimplemented;;step
;;unimplemented;;step-level-set!
;;unimplemented;;touch
;;unimplemented;;trace
;;unimplemented;;unbreak
;;unimplemented;;untrace

(void)

)
