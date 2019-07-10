;;;============================================================================

;;; File: "gambit/test/test-test.scm"

;;; Copyright (c) 2013-2018 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##import gambit/test)

(define (failure-msg thunk) ;; for testing checks that fail
  (let* ((save gambit/test#failed-check?)
         (msg (with-output-to-string "" thunk))) ;; capture failure message
    (set! gambit/test#failed-check? save) ;; don't count this as a failure
    msg))
    
(check-equal? "abc" "abc")
(check-equal? "abc" "abc" "testing that \"abc\" is equal to \"abc\"")
(check-equal? (failure-msg (lambda () (check-equal? "ab_" "abc")))
              "\"test-test.scm\"@19.39: FAILED (check-equal? \"ab_\" \"abc\") GOT \"ab_\"\n")

(check-not-equal? "ab_" "abc")
(check-not-equal? "ab_" "abc" "testing that \"ab_\" is not equal to \"abc\"")
(check-equal? (failure-msg (lambda () (check-not-equal? "abc" "abc")))
              "\"test-test.scm\"@24.39: FAILED (check-not-equal? \"abc\" \"abc\") GOT \"abc\"\n")

(check-eqv? 42 42)
(check-eqv? 42 42 "testing that 42 is equal to 42")
(check-equal? (failure-msg (lambda () (check-eqv? 13 42)))
              "\"test-test.scm\"@29.39: FAILED (check-eqv? 13 42) GOT 13\n")

(check-not-eqv? 13 42)
(check-not-eqv? 13 42 "testing that 13 is not equal to 42")
(check-equal? (failure-msg (lambda () (check-not-eqv? 42 42)))
              "\"test-test.scm\"@34.39: FAILED (check-not-eqv? 42 42) GOT 42\n")

(check-eq? 'a 'a)
(check-eq? 'a 'a "testing that 'a is equal to 'a")
(check-equal? (failure-msg (lambda () (check-eq? 'b 'a)))
              "\"test-test.scm\"@39.39: FAILED (check-eq? 'b 'a) GOT b\n")

(check-not-eq? 'b 'a)
(check-not-eq? 'b 'a "testing that 'b is not equal to 'a")
(check-equal? (failure-msg (lambda () (check-not-eq? 'a 'a)))
              "\"test-test.scm\"@44.39: FAILED (check-not-eq? 'a 'a) GOT a\n")

(check-= 1.5 1.5)
(check-= 1.5 1.5 0.001)
(check-= 1.5 1.5 0.001 "testing that 1.5 is equal to 1.5")
(check-equal? (failure-msg (lambda () (check-= 1.5 2.5)))
              "\"test-test.scm\"@50.39: FAILED (check-= 1.5 2.5) GOT 1.5\n")

(check-true #t)
(check-true #t "testing that #t is true")
(check-equal? (failure-msg (lambda () (check-true 123)))
              "\"test-test.scm\"@55.39: FAILED (check-true 123) GOT 123\n")

(check-false #f)
(check-false #f "testing that #f is false")
(check-equal? (failure-msg (lambda () (check-false 123)))
              "\"test-test.scm\"@60.39: FAILED (check-false 123) GOT 123\n")

(check-not-false 123)
(check-not-false 123 "testing that 123 is not false")
(check-equal? (failure-msg (lambda () (check-not-false #f)))
              "\"test-test.scm\"@65.39: FAILED (check-not-false #f) GOT #f\n")

(check-exn divide-by-zero-exception?
           (lambda () (/ 1 0)))
(check-exn divide-by-zero-exception?
           (lambda () (/ 1 0))
           "testing that (/ 1 0) raises a divide-by-zero exception")
(check-equal? (failure-msg (lambda () (check-exn pair?
                                                 (lambda () (/ 1 0)))))
              "\"test-test.scm\"@73.39: FAILED (check-exn pair? (lambda () (/ 1 0))) GOT #<divide-by-zero-exception #2>\n")
(check-equal? (failure-msg (lambda () (check-exn divide-by-zero-exception?
                                                 (lambda () (/ 1 2)))))
              "\"test-test.scm\"@76.39: FAILED (check-exn divide-by-zero-exception? (lambda () (/ 1 2))) GOT 1/2\n")

(check-tail-exn divide-by-zero-exception?
                (lambda () (/ 1 0)))
(check-tail-exn divide-by-zero-exception?
                (lambda () (/ 1 0))
                "testing that (/ 1 0) raises a divide-by-zero exception in tail position")
(check-equal? (failure-msg (lambda () (check-tail-exn pair?
                                                      (lambda () (/ 1 0)))))
              "\"test-test.scm\"@85.39: FAILED (check-tail-exn pair? (lambda () (/ 1 0))) GOT #<divide-by-zero-exception #3>\n")
(check-equal? (failure-msg (lambda () (check-tail-exn divide-by-zero-exception?
                                                      (lambda () (/ 1 2)))))
              "\"test-test.scm\"@88.39: FAILED (check-tail-exn divide-by-zero-exception? (lambda () (/ 1 2))) GOT 1/2\n")

;;;============================================================================
