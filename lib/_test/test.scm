;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2013-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(import _test)

(define-syntax macro-set-current-directory-to-this-source-file-directory
  (lambda (src)
    (let ((path (##source-path src)))
      (if path (current-directory (path-directory path)))
      #f)))

;; make error messages predictable
(macro-set-current-directory-to-this-source-file-directory)

(define (failure-msg thunk) ;; for testing checks that fail
  (let ((save-test-all? _test#test-all?)
        (save-test-quiet? _test#test-quiet?)
        (save-test-verbose? _test#test-verbose?)
        (save-nb-passed-tests _test#nb-passed-tests)
        (save-nb-failed-tests _test#nb-failed-tests))
    (set! _test#test-all? #t)
    (set! _test#test-quiet? #t)
    (set! _test#test-verbose? #t)
    (let ((msg (call-with-output-string ;; capture failure message
                ""
                (lambda (port)
                  (parameterize ((_test#redirect-test-output-port port))
                    (thunk))))))
      (set! _test#test-all? save-test-all?)
      (set! _test#test-quiet? save-test-quiet?)
      (set! _test#test-verbose? save-test-verbose?)
      (set! _test#nb-passed-tests save-nb-passed-tests)
      (set! _test#nb-failed-tests save-nb-failed-tests)
      msg)))
    
(check-equal? "abc" "abc")
(check-equal? "abc" "abc" "testing that \"abc\" is equal to \"abc\"")
(check-equal? (failure-msg (lambda () (check-equal? "ab_" "abc")))
              "\"test.scm\"@43.39: FAILED (check-equal? \"ab_\" \"abc\") GOT \"ab_\"\n")

(check-not-equal? "ab_" "abc")
(check-not-equal? "ab_" "abc" "testing that \"ab_\" is not equal to \"abc\"")
(check-equal? (failure-msg (lambda () (check-not-equal? "abc" "abc")))
              "\"test.scm\"@48.39: FAILED (check-not-equal? \"abc\" \"abc\") GOT \"abc\"\n")

(check-eqv? 42 42)
(check-eqv? 42 42 "testing that 42 is equal to 42")
(check-equal? (failure-msg (lambda () (check-eqv? 13 42)))
              "\"test.scm\"@53.39: FAILED (check-eqv? 13 42) GOT 13\n")

(check-not-eqv? 13 42)
(check-not-eqv? 13 42 "testing that 13 is not equal to 42")
(check-equal? (failure-msg (lambda () (check-not-eqv? 42 42)))
              "\"test.scm\"@58.39: FAILED (check-not-eqv? 42 42) GOT 42\n")

(check-eq? 'a 'a)
(check-eq? 'a 'a "testing that 'a is equal to 'a")
(check-equal? (failure-msg (lambda () (check-eq? 'b 'a)))
              "\"test.scm\"@63.39: FAILED (check-eq? 'b 'a) GOT b\n")

(check-not-eq? 'b 'a)
(check-not-eq? 'b 'a "testing that 'b is not equal to 'a")
(check-equal? (failure-msg (lambda () (check-not-eq? 'a 'a)))
              "\"test.scm\"@68.39: FAILED (check-not-eq? 'a 'a) GOT a\n")

(check-= 1.5 1.5)
(check-= 1.4995 1.5 0.001)
(check-= 1.4995 1.5 0.001 "testing that 1.5 is equal to 1.5")
(check-equal? (failure-msg (lambda () (check-= 1.5 2.5)))
              "\"test.scm\"@74.39: FAILED (check-= 1.5 2.5) GOT 1.5\n")
(check-equal? (failure-msg (lambda () (check-= 1.49 1.5 0.001)))
              "\"test.scm\"@76.39: FAILED (check-= 1.49 1.5 .001) GOT 1.49\n")

(check-true #t)
(check-true #t "testing that #t is true")
(check-equal? (failure-msg (lambda () (check-true 123)))
              "\"test.scm\"@81.39: FAILED (check-true 123) GOT 123\n")

(check-false #f)
(check-false #f "testing that #f is false")
(check-equal? (failure-msg (lambda () (check-false 123)))
              "\"test.scm\"@86.39: FAILED (check-false 123) GOT 123\n")

(check-not-false 123)
(check-not-false 123 "testing that 123 is not false")
(check-equal? (failure-msg (lambda () (check-not-false #f)))
              "\"test.scm\"@91.39: FAILED (check-not-false #f) GOT #f\n")

(check-exn divide-by-zero-exception?
           (lambda () (/ 1 0)))
(check-exn divide-by-zero-exception?
           (lambda () (/ 1 0))
           "testing that (/ 1 0) raises a divide-by-zero exception")
(check-equal? (failure-msg (lambda () (check-exn pair?
                                                 (lambda () (/ 1 0)))))
              "\"test.scm\"@99.39: FAILED (check-exn pair? (lambda () (/ 1 0))) GOT #<divide-by-zero-exception #2>\n")
(check-equal? (failure-msg (lambda () (check-exn divide-by-zero-exception?
                                                 (lambda () (/ 1 2)))))
              "\"test.scm\"@102.39: FAILED (check-exn divide-by-zero-exception? (lambda () (/ 1 2))) GOT 1/2\n")

(check-tail-exn divide-by-zero-exception?
                (lambda () (/ 1 0)))
(check-tail-exn divide-by-zero-exception?
                (lambda () (/ 1 0))
                "testing that (/ 1 0) raises a divide-by-zero exception in tail position")
(check-equal? (failure-msg (lambda () (check-tail-exn pair?
                                                      (lambda () (/ 1 0)))))
              "\"test.scm\"@111.39: FAILED (check-tail-exn pair? (lambda () (/ 1 0))) GOT #<divide-by-zero-exception #3>\n")
(check-equal? (failure-msg (lambda () (check-tail-exn divide-by-zero-exception?
                                                      (lambda () (/ 1 2)))))
              "\"test.scm\"@114.39: FAILED (check-tail-exn divide-by-zero-exception? (lambda () (/ 1 2))) GOT 1/2\n")

;;;============================================================================
