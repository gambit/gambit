;;;============================================================================

;;; File: "_test.scm"

;;; Copyright (c) 2013-2019 by Marc Feeley, All Rights Reserved.

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

(define test-all? #f) ;; default is to stop at first failure
(define test-quiet? #f) ;; default is to display summary of tests run
(define test-verbose? #f) ;; default is to not display passed tests
(define epsilon 0) ;; default tolerance for check-= numerical check

(define nb-passed-tests 0) ;; number of tests that passed
(define nb-failed-tests 0) ;; number of tests that failed

(define redirect-test-output-port (##make-parameter #f))

(define (test-output-port)
  (or (redirect-test-output-port)
      (##repl-output-port)))

;; at exit, verify if any checks failed
(let ((##exit-old ##exit))
  (set! ##exit
        (lambda rest

          (set! ##exit ##exit-old) ;; in case there's another call to exit

          (if (not test-quiet?)
              (let ((output-port (test-output-port)))

                (define (plural n thing)
                  (display n output-port)
                  (display thing output-port)
                  (if (fx> n 1)
                      (display "s" output-port)))

                (display "*** " output-port)
                (if (fx= nb-failed-tests 0)
                    (display "all tests passed" output-port)
                    (begin
                      (plural nb-failed-tests " test")
                      (display " failed" output-port)))
                (if (or test-all? (fx= nb-failed-tests 0))
                    (display " out of a total of " output-port)
                    (display " after " output-port))
                (plural (fx+ nb-failed-tests nb-passed-tests) " test")
                (display "\n" output-port)))

          (if (pair? rest)
              (##exit (car rest))
              (##exit-with-err-code-no-cleanup
               (if (fx> nb-failed-tests 0) 2 1))))))

(define (passed-test passed-msg #!optional (actual-result (macro-absent-obj)))
  (set! nb-passed-tests (fx+ nb-passed-tests 1))
  (if test-verbose?
      (display
       (call-with-output-string
         ""
         (lambda (port)
           (display passed-msg port)
           (newline port)))
       (test-output-port))))

(define (failed-test failed-msg #!optional (actual-result (macro-absent-obj)))
  (set! nb-failed-tests (fx+ nb-failed-tests 1))
  (display
   (call-with-output-string
    ""
    (lambda (port)
      (display failed-msg port)
      (if (not (eq? actual-result (macro-absent-obj)))
          (begin
            (display " GOT " port)
            (write actual-result port)))
      (newline port)))
   (test-output-port))
  (if (not test-all?)
      (##exit)))

(define (check-exn-proc exn? thunk passed-msg failed-msg tail-exn?)
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
                       (failed-test failed-msg e))
                      ((and tail-exn?
                            (not (eq? creator call-thunk)))
                       (failed-test
                        failed-msg
                        (list 'nontail-exception-raised-in creator)))
                      (else
                       (passed-test passed-msg)))))))))
      (lambda ()
        (failed-test failed-msg (call-thunk thunk)))))))

(define call-thunk
  (let ()

    (declare (not inline)) ;; don't inline call-thunk so that continuation's
                           ;; creator of the call to thunk will be call-thunk

    (lambda (thunk)
      ;; make sure continuation of thunk has call-thunk as creator
      (##first-argument (thunk)))))

(define (check-=-proc n1 n2 tolerance passed-msg failed-msg)
  (if (or (not (number? n1))
          (not (number? n2))
          (< tolerance (magnitude (- n1 n2))))
      (failed-test failed-msg n1)
      (passed-test passed-msg n1)))

(define (test-all?-set! val)
  (set! test-all? val))

(define (test-quiet?-set! val)
  (set! test-quiet? val))

(define (test-verbose?-set! val)
  (set! test-verbose? val))

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
