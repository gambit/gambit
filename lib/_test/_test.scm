;;;============================================================================

;;; File: "_test.scm"

;;; Copyright (c) 2013-2020 by Marc Feeley, All Rights Reserved.

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

(define (failed-test failed-msg #!optional (actual-result absent))
  (set! nb-failed-tests (fx+ nb-failed-tests 1))
  (display
   (call-with-output-string
    ""
    (lambda (port)
      (display failed-msg port)
      (if (not (eq? actual-result absent))
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
      (failed-test failed-msg n2)
      (passed-test passed-msg n2)))

(define (test-predicate-proc test-name
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

     (define (failed actual-result)
       (failed-test (message #f) actual-result))

     (let ((expression-value
            (with-exception-handler
                (lambda (exn)
                  (##continuation-graft return failed exn))
              expression-thunk)))
       (if (eq? positive? (not (predicate expression-value)))
           (failed expression-value)
           (passed expression-value))))))

(define (test-relation-proc test-name
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

     (define (failed actual-result)
       (failed-test (message #f) actual-result))

     (let* ((expected-value
             (with-exception-handler
                 (lambda (exn)
                   (##continuation-graft return failed exn))
               expected-thunk))
            (test-expr-value
             (with-exception-handler
                 (lambda (exn)
                   (##continuation-graft return failed exn))
               test-expr-thunk)))
       (if (eq? positive? (relation expected-value test-expr-value))
           (passed test-expr-value)
           (failed test-expr-value))))))

(define (test-approximate-proc test-name
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

     (define (failed actual-result)
       (failed-test (message #f) actual-result))

     (define (approximately= x y)
       (and (>= x (- y error))
            (<= x (+ y error))))

     (let* ((expected-value
             (with-exception-handler
                 (lambda (exn)
                   (##continuation-graft return failed exn))
               expected-thunk))
            (test-expr-value
             (with-exception-handler
                 (lambda (exn)
                   (##continuation-graft return failed exn))
               test-expr-thunk)))
       (if (eq? positive?
                (and (number? expected-value)
                     (number? test-expr-value)
                     (approximately= (real-part expected-value)
                                     (real-part test-expr-value))
                     (approximately= (imag-part expected-value)
                                     (imag-part test-expr-value))))
           (passed test-expr-value)
           (failed test-expr-value))))))

(define (test-error-proc test-name
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

     (define (failed actual-result)
       (failed-test (message #f) actual-result))

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
                       (failed exn))
                      ((and tail?
                            (not (eq? creator call-thunk)))
                       (failed (list 'nontail-exception-raised-in creator)))
                      (else
                       (passed absent)))))))))
      (lambda ()
        (failed (call-thunk test-expr-thunk)))))))

(define (test-begin-proc suite-name count)
  (if (not test-quiet?)
      (let ((output-port (test-output-port)))
        (display (string-append (test-indent) "testing " suite-name "\n")
                 output-port)))
  (set! context (cons suite-name context)))

(define (test-end-proc suite-name)
  (if (pair? context)
      (if (or (not suite-name) (equal? (car context) suite-name))
          (set! context (cdr context))
          (error "test-end with unmatched suite-name, should be"
                 (car context)))
      (error "test-end without matching test-begin")))

(define (test-indent)
  (let ((n (length context)))
    (append-strings (map (lambda (x) "| ") (iota n)))))

(define (test-group-proc suite-name body-thunk)
  (test-begin-proc suite-name #f)
  (body-thunk)
  (test-end-proc suite-name))





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
