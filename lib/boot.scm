
;; reset environment to support iterative syntax-case development
(namespace (""))
(eval '(namespace ("")))
(set! ##expand-source (lambda (src) src))

;; eval maintains its own namespace configuration associated with the
;; interaction-cte. the content of syntax-case-prelude.scm needs to be
;; evaluated so that $sc-put-cte definitions emitted by psyntax to
;; eval share the namespace context of syntax-case-prelude. this
;; allows definitions to access functions andmap, ormap, gensym? which
;; are in the sc# namespace.

(eval
 '(include "syntax-case-prelude.scm"))

(define psyntaxpp
  "psyntax73.pp")

(define psyntaxss
  "psyntax73.ss")

(define make-read-expander
  (lambda (expander)
    (lambda (input)

      ;; begin is prepended to simulate top-level expansion. this
      ;; practice bypasses the "invalid context for definition" error
      ;; that otherwise occurs without its presence.
      (let ((expansion (expander `(begin ,@(read-all input)))))
        (##desourcify expansion)))))

;;
;; eval the bootstrapping psyntax.pp
;;
(eval
 (call-with-input-file psyntaxpp
   (lambda (input)
     `(begin ,@(read-all input)))))

;; psyntax.pp ships with ctem and rtem assigned to '(E), which emits
;; visit content to eval, and not the expanded output. this is an odd
;; choice, considering that psyntax.pp itself appends the $sc-put-cte
;; definitions after the revisit content. psyntax.pp can thus not
;; bootstrap itself with its default settings!

;; to accomodate this, we bootstrap psyntax.ss with '(E) values of
;; ctem and rtem, and then use the resultant expander to re-expand
;; psyntax.ss with ctem and rtem with respective values of '(L C) and
;; '(L) to generate the final syntax-case.scm.

(eval
 (call-with-input-file psyntaxss
   (make-read-expander sc-expand)))

(define syntax-case
  "syntax-case.scm")

(call-with-output-file syntax-case
  (lambda (output)
    
    (define prelude "syntax-case-prelude.scm")
    (define postlude "syntax-case-postlude.scm")

    (define read-as-string
      (lambda (input)
        (read-line input #!eof)))
    
    (print port: output
           (call-with-input-file prelude
             read-as-string))
    
    (eval '(set! gensym-count 0))

    (output-port-readtable-set! output (readtable-sharing-allowed?-set (output-port-readtable output) 'serialize))

    (write
     (call-with-input-file psyntaxss
       (make-read-expander sc-compile-expand)) output)

    (print port: output
           (call-with-input-file postlude
             read-as-string))))

;;
;; reset the repl namespace
;;
(eval '(##namespace ("")))

(parameterize ((current-readtable (readtable-sharing-allowed?-set (current-readtable) 'serialize)))
    (load "syntax-case"))
