;;;============================================================================

;;; File: "_test.scm"

;;; Copyright (c) 2013-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##supply-module _test)

(##namespace ("_test#"))                  ;; in _test#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-procedure,
                                          ;; macro-absent-obj, etc

(##include "_test#.scm")                  ;; correctly map test ops

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;----------------------------------------------------------------------------

(define test-all? #f) ;; default is to stop at first failure
(define test-quiet? #f) ;; default is to display summary of tests run
(define test-verbose? #f) ;; default is to not display passed tests

(define nb-passed-tests 0)  ;; number of tests that passed
(define nb-failed-tests 0)  ;; number of tests that failed
(define nb-skipped-tests 0) ;; number of tests that were skipped

(define context '()) ;; testing context

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
                (plural (fx+ nb-failed-tests nb-passed-tests)
                        (if (fx= nb-skipped-tests 0)
                            " test"
                            " executed test"))
                (if (not (fx= nb-skipped-tests 0))
                    (begin
                      (display " and " output-port)
                      (plural nb-skipped-tests " skipped test")))
                (display "\n" output-port)))

          (if (pair? rest)
              (##exit (car rest))
              (##exit-with-err-code-no-cleanup
               (if (fx> nb-failed-tests 0) 2 1))))))

(define (absent) #f)

(define (passed-test passed-msg #!optional (actual-result absent))
  (set! nb-passed-tests (fx+ nb-passed-tests 1))
  (if test-verbose?
      (display
       (call-with-output-string
         ""
         (lambda (port)
           (display passed-msg port)
           (newline port)))
       (test-output-port))))

(define (failed-test failed-msg #!optional (actual-result absent) (exception-cont #f))
  (set! nb-failed-tests (fx+ nb-failed-tests 1))
  (display
   (call-with-output-string
    ""
    (lambda (port)
      (display failed-msg port)
      (if (not (eq? actual-result absent))
          (begin
            (display " GOT " port)
            (if exception-cont
                (let ()
                  (namespace ("" display-exception-in-context))
                  (display-exception-in-context actual-result exception-cont port))
                (begin
                  (write actual-result port)
                  (newline port))))
          (newline port))))
   (test-output-port))
  (if (not test-all?)
      (##exit)))

(define call-thunk
  (let ()

    (declare (not inline)) ;; don't inline call-thunk so that continuation's
                           ;; creator of the call to thunk will be call-thunk

    (lambda (thunk)
      ;; make sure continuation of thunk has call-thunk as creator
      (##first-argument (thunk)))))

(define (%test-predicate test-name
                         expression-thunk
                         positive?
                         predicate
                         test-location
                         test-source)
  (##continuation-capture
   (lambda (return)

     (define (message passed?)
       (string-append (or test-location "")
                      (if passed? "PASSED " "FAILED ")
                      (if (string? test-name) test-name test-source)))

     (define (passed actual-result)
       (passed-test (message #t) actual-result))

     (define (failed actual-result cont)
       (failed-test (message #f) actual-result cont))

     (let ((expression-value
            (with-exception-handler
                (lambda (exn)
                  (##continuation-capture
                   (lambda (cont)
                     (##continuation-graft return failed exn cont))))
              expression-thunk)))
       (if (eq? positive? (not (predicate expression-value)))
           (failed expression-value #f)
           (passed expression-value))))))

(define (%test-relation test-name
                        expected-thunk
                        test-expr-thunk
                        positive?
                        relation
                        test-location
                        test-source)
  (##continuation-capture
   (lambda (return)

     (define (message passed?)
       (string-append (or test-location "")
                      (if passed? "PASSED " "FAILED ")
                      (if (string? test-name) test-name test-source)))

     (define (passed actual-result)
       (passed-test (message #t) actual-result))

     (define (failed actual-result cont)
       (failed-test (message #f) actual-result cont))

     (let* ((expected-value
             (with-exception-handler
                 (lambda (exn)
                   (##continuation-capture
                    (lambda (cont)
                      (##continuation-graft return failed exn cont))))
               expected-thunk))
            (test-expr-value
             (with-exception-handler
                 (lambda (exn)
                   (##continuation-capture
                    (lambda (cont)
                      (##continuation-graft return failed exn cont))))
               test-expr-thunk)))
       (if (eq? positive? (relation expected-value test-expr-value))
           (passed test-expr-value)
           (failed test-expr-value #f))))))

(define (%test-approximate test-name
                           expected-thunk
                           test-expr-thunk
                           error
                           positive?
                           test-location
                           test-source)
  (##continuation-capture
   (lambda (return)

     (define (message passed?)
       (string-append (or test-location "")
                      (if passed? "PASSED " "FAILED ")
                      (if (string? test-name) test-name test-source)))

     (define (passed actual-result)
       (passed-test (message #t) actual-result))

     (define (failed actual-result cont)
       (failed-test (message #f) actual-result cont))

     (define (approximately= x y)
       (and (>= x (- y error))
            (<= x (+ y error))))

     (let* ((expected-value
             (with-exception-handler
                 (lambda (exn)
                   (##continuation-capture
                    (lambda (cont)
                      (##continuation-graft return failed exn cont))))
               expected-thunk))
            (test-expr-value
             (with-exception-handler
                 (lambda (exn)
                   (##continuation-capture
                    (lambda (cont)
                      (##continuation-graft return failed exn cont))))
               test-expr-thunk)))
       (if (eq? positive?
                (and (number? expected-value)
                     (number? test-expr-value)
                     (approximately= (real-part expected-value)
                                     (real-part test-expr-value))
                     (approximately= (imag-part expected-value)
                                     (imag-part test-expr-value))))
           (passed test-expr-value)
           (failed test-expr-value #f))))))

(define (%test-error test-name
                     error-type?
                     test-expr-thunk
                     tail?
                     test-location
                     test-source)
  (##continuation-capture
   (lambda (return)

     (define (message passed?)
       (string-append (or test-location "")
                      (if passed? "PASSED " "FAILED ")
                      (if (string? test-name) test-name test-source)))

     (define (passed actual-result)
       (passed-test (message #t) actual-result))

     (define (failed actual-result cont)
       (failed-test (message #f) actual-result cont))

     (with-exception-handler
      (lambda (exn)
        (##continuation-capture
         (lambda (cont)
           (##continuation-graft
            return
            (lambda ()
              (let ((creator (##continuation-creator cont)))
                (cond ((and (not (boolean? error-type?))
                            (not (error-type? exn)))
                       (failed exn cont))
                      ((and tail?
                            (not (eq? creator call-thunk)))
                       (failed (list 'nontail-exception-raised-in creator) #f))
                      (else
                       (passed absent)))))))))
      (lambda ()
        (failed (call-thunk test-expr-thunk) #f))))))

(define (%test-begin suite-name count)
  (if (not test-quiet?)
      (let ((output-port (test-output-port)))
        (display (string-append (test-indent) "testing " suite-name "\n")
                 output-port)))
  (set! context (cons suite-name context)))

(define (%test-end suite-name)
  (if (pair? context)
      (if (or (not suite-name) (equal? (car context) suite-name))
          (set! context (cdr context))
          (error "test-end with unmatched suite-name, should be"
                 (car context)))
      (error "test-end without matching test-begin")))

(define (test-indent)
  (let ((n (length context)))
    (string-concatenate (map (lambda (x) "| ") (iota n)))))

(define (%test-group suite-name body-thunk)
  (%test-begin suite-name #f)
  (body-thunk)
  (%test-end suite-name))

(define (test-msg thunk) ;; for testing checks that fail
  (let ((save-test-all? test-all?)
        (save-test-quiet? test-quiet?)
        (save-test-verbose? test-verbose?)
        (save-nb-passed-tests nb-passed-tests)
        (save-nb-failed-tests nb-failed-tests)
        (save-nb-skipped-tests nb-skipped-tests)
        (save-context context))
    (set! test-all? #t)
    (set! test-quiet? #f)
    (set! test-verbose? #t)
    (let ((msg
           (call-with-output-string ;; capture test output messages
             ""
             (lambda (port)
               (parameterize ((redirect-test-output-port port))
                 (thunk))))))
      (set! test-all? save-test-all?)
      (set! test-quiet? save-test-quiet?)
      (set! test-verbose? save-test-verbose?)
      (set! nb-passed-tests save-nb-passed-tests)
      (set! nb-failed-tests save-nb-failed-tests)
      (set! nb-skipped-tests save-nb-skipped-tests)
      (set! context save-context)
      msg)))

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
