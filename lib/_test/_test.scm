;;;============================================================================

;;; File: "_test.scm"

;;; Copyright (c) 2013-2018 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##supply-module _test)

(##namespace ("_test#"))         ;; in _test#
(##include "~~lib/_prim#.scm")   ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm") ;; for macro-check-procedure,
                                 ;; macro-absent-obj, etc

(##include "_test#.scm")         ;; correctly map test ops

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;----------------------------------------------------------------------------

(define epsilon 0)

(define failed-check? #f)

;; at exit, verify if any checks failed
(let ((##exit-old ##exit))
  (set! ##exit
        (lambda rest
          (if (pair? rest)
              (##exit-old (car rest))
              (##exit-with-err-code-no-cleanup
               (if failed-check? 2 1))))))

(define (failed-check msg #!optional (actual-result (macro-absent-obj)))
  (println
   (call-with-output-string
    ""
    (lambda (port)
      (display msg port)
      (if (not (eq? actual-result (macro-absent-obj)))
          (begin
            (display " GOT " port)
            (write actual-result port))))))
  (set! failed-check? #t))

(define (check-exn-proc exn? thunk msg tail-exn?)
  (##continuation-capture
   (lambda (return)
     (with-exception-handler
      (lambda (e)
        (##continuation-capture
         (lambda (cont)
           (##continuation-graft
            return
            (lambda ()
              (let ((creator (##continuation-creator cont)))
                (cond ((not (exn? e))
                       (failed-check msg e))
                      ((and tail-exn?
                            (not (eq? creator call-thunk)))
                       (failed-check
                        msg
                        (list 'nontail-exception-raised-in creator))))))))))
      (lambda ()
        (failed-check msg (call-thunk thunk)))))))

(define call-thunk
  (let ()

    (declare (not inline)) ;; don't inline call-thunk so that continuation's
                           ;; creator of the call to thunk will be call-thunk

    (lambda (thunk)
      ;; make sure continuation of thunk has call-thunk as creator
      (##first-argument (thunk)))))

(define (check-=-proc n1 n2 tolerance msg)
  (if (or (not (number? n1))
          (not (number? n2))
          (< tolerance (magnitude (- n1 n2))))
      (failed-check msg n1)))

#;
(define (exit0-when-unimplemented-operation-os-exception thunk)
  (with-exception-catcher
   (lambda (e)
     (if (and (os-exception? e)
              (equal? (##os-err-code->string (os-exception-code e))
                      "Unimplemented operation"))
         (exit 0)
         (raise e)))
   thunk))

;;;============================================================================
