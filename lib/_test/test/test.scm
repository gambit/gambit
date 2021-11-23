;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(import (_test))
(import (rename (only (_test) test-equal test-msg) (test-equal _test-equal) (test-msg _test-msg)))

(define-syntax macro-set-current-directory-to-this-source-file-directory
  (lambda (src)
    (current-directory (path-directory (##source-path src)))
    #f))

;; make error messages predictable
(macro-set-current-directory-to-this-source-file-directory)

(define-syntax test-test-msg
  (lambda (src)
    (##deconstruct-call
     src
     3
     (lambda (expected expr)
       (##sourcify-deep
        `(_test-equal ,expected (_test-msg (lambda () ,expr)))
        src)))))







(test-assert (< 1 2))

(test-assert "testing that (< 1 2)" (< 1 2))

(test-assert (member 'b '(a b c)))

(test-test-msg "\"test.scm\"@43.16: FAILED (test-assert (< 2 1)) GOT #f\n"
               (test-assert (< 2 1)))

(test-test-msg "\"test.scm\"@46.16: FAILED test-assert-fail GOT #f\n"
               (test-assert "test-assert-fail" (< 2 1)))

(test-test-msg "\"test.scm\"@49.16: FAILED (test-assert (raise 'exception)) GOT exception\n"
               (test-assert (raise 'exception)))


(test-equal "abc" "abc")

(test-equal "testing that \"abc\" is equal? to \"abc\"" "abc" "abc")

(test-test-msg "\"test.scm\"@57.16: FAILED (test-equal \"abc\" \"ab_\") GOT \"ab_\"\n"
               (test-equal "abc" "ab_"))

(test-test-msg "\"test.scm\"@60.16: FAILED test-equal-fail GOT \"ab_\"\n"
               (test-equal "test-equal-fail" "abc" "ab_"))

(test-test-msg "\"test.scm\"@63.16: FAILED (test-equal (raise 'exception) \"abc\") GOT exception\n"
               (test-equal (raise 'exception) "abc"))

(test-test-msg "\"test.scm\"@66.16: FAILED (test-equal \"abc\" (raise 'exception)) GOT exception\n"
               (test-equal "abc" (raise 'exception)))


(test-eqv 42 42)

(test-eqv "testing that 42 is eqv? to 42" 42 42)

(test-test-msg "\"test.scm\"@74.16: FAILED (test-eqv 42 13) GOT 13\n"
               (test-eqv 42 13))

(test-test-msg "\"test.scm\"@77.16: FAILED test-eqv-fail GOT 13\n"
               (test-eqv "test-eqv-fail" 42 13))

(test-test-msg "\"test.scm\"@80.16: FAILED (test-eqv 42 (raise 'exception)) GOT exception\n"
               (test-eqv 42 (raise 'exception)))


(test-eq 'a 'a)

(test-eq "testing that 'a is eq? to 'a" 'a 'a)

(test-test-msg "\"test.scm\"@88.16: FAILED (test-eq 'a 'b) GOT b\n"
               (test-eq 'a 'b))

(test-test-msg "\"test.scm\"@91.16: FAILED test-eq-fail GOT b\n"
               (test-eq "test-eq-fail" 'a 'b))

(test-test-msg "\"test.scm\"@94.16: FAILED (test-eq (raise 'exception) 'a) GOT exception\n"
               (test-eq (raise 'exception) 'a))

(test-test-msg "\"test.scm\"@97.16: FAILED (test-eq 'a (raise 'exception)) GOT exception\n"
               (test-eq 'a (raise 'exception)))


(test-approximate 1.5 1.5 0)

(test-approximate 1.5 1.4995 0.001)

(test-approximate "testing that 1.5 is equal to 1.5" 1.5 1.4995 0.001)

(test-test-msg "\"test.scm\"@107.16: FAILED (test-approximate 1.5 2.5 .001) GOT 2.5\n"
               (test-approximate 1.5 2.5 0.001))

(test-test-msg "\"test.scm\"@110.16: FAILED test-approximate-fail GOT 2.5\n"
               (test-approximate "test-approximate-fail" 1.5 2.5 0.001))

(test-test-msg "\"test.scm\"@113.16: FAILED (test-approximate (raise 'exception) 1.5 .001) GOT exception\n"
               (test-approximate (raise 'exception) 1.5 0.001))

(test-test-msg "\"test.scm\"@116.16: FAILED (test-approximate 1.5 (raise 'exception) .001) GOT exception\n"
               (test-approximate 1.5 (raise 'exception) 0.001))


(test-error (+ 1 (raise 'exception)))

(test-error #t (+ 1 (raise 'exception)))

(test-error symbol? (+ 1 (raise 'exception)))

(test-error "testing that evaluation raises an exception" #t (+ 1 (raise 'exception)))

(test-error "testing that evaluation raises a symbol" symbol? (+ 1 (raise 'exception)))

(test-test-msg "\"test.scm\"@130.16: FAILED (test-error 42) GOT 42\n"
               (test-error 42))

(test-test-msg "\"test.scm\"@133.16: FAILED (test-error #t 42) GOT 42\n"
               (test-error #t 42))

(test-test-msg "\"test.scm\"@136.16: FAILED (test-error string? 42) GOT 42\n"
               (test-error string? 42))

(test-test-msg "\"test.scm\"@139.16: FAILED (test-error string? (raise 'exception)) GOT exception\n"
               (test-error string? (raise 'exception)))

(test-test-msg "\"test.scm\"@142.16: FAILED test-error-fail GOT 42\n"
               (test-error "test-error-fail" #t 42))

(test-test-msg "\"test.scm\"@145.16: FAILED test-error-fail GOT exception\n"
               (test-error "test-error-fail" string? (raise 'exception)))


(test-error-tail (raise 'exception))

(test-error-tail #t (raise 'exception))

(test-error-tail symbol? (raise 'exception))

(test-error-tail "testing that evaluation raises an exception in tail position" #t (raise 'exception))

(test-error-tail "testing that evaluation raises a symbol in tail position" symbol? (raise 'exception))

(test-test-msg "\"test.scm\"@159.16: FAILED (test-error-tail 42) GOT 42\n"
               (test-error-tail 42))

(test-test-msg "\"test.scm\"@162.16: FAILED (test-error-tail #t 42) GOT 42\n"
               (test-error-tail #t 42))

(test-test-msg "\"test.scm\"@165.16: FAILED (test-error-tail string? 42) GOT 42\n"
               (test-error-tail string? 42))

(test-test-msg "\"test.scm\"@168.16: FAILED (test-error-tail string? (raise 'exception)) GOT exception\n"
               (test-error-tail string? (raise 'exception)))

(test-test-msg "\"test.scm\"@171.16: FAILED test-error-tail-fail GOT 42\n"
               (test-error-tail "test-error-tail-fail" #t 42))

(test-test-msg "\"test.scm\"@174.16: FAILED test-error-tail-fail GOT exception\n"
               (test-error-tail "test-error-tail-fail" string? (raise 'exception)))

(test-test-msg "\"test.scm\"@177.16: FAILED (test-error-tail (+ 1 (raise 'exception))) GOT (nontail-exception-raised-in #<procedure #2>)\n"
               (test-error-tail (+ 1 (raise 'exception))))

(test-test-msg "\"test.scm\"@180.16: FAILED (test-error-tail #t (+ 1 (raise 'exception))) GOT (nontail-exception-raised-in #<procedure #3>)\n"
               (test-error-tail #t (+ 1 (raise 'exception))))

(test-test-msg "\"test.scm\"@183.16: FAILED (test-error-tail symbol? (+ 1 (raise 'exception))) GOT (nontail-exception-raised-in #<procedure #4>)\n"
               (test-error-tail symbol? (+ 1 (raise 'exception))))

(test-test-msg "\"test.scm\"@186.16: FAILED testing that evaluation raises an exception in tail position GOT (nontail-exception-raised-in #<procedure #5>)\n"
               (test-error-tail "testing that evaluation raises an exception in tail position" #t (+ 1 (raise 'exception))))

(test-test-msg "\"test.scm\"@189.16: FAILED testing that evaluation raises a symbol in tail position GOT (nontail-exception-raised-in #<procedure #6>)\n"
               (test-error-tail "testing that evaluation raises a symbol in tail position" symbol? (+ 1 (raise 'exception))))

(test-test-msg "testing test1\n"
               (begin
                 (test-begin "test1")
                 (test-end)))

(test-test-msg "testing test2\n"
               (begin
                 (test-begin "test2")
                 (test-end "test2")))

(test-test-msg "testing test3\n| testing test4\n| testing test5\ntesting test6\n"
               (begin
                 (test-begin "test3")
                 (test-begin "test4")
                 (test-end)
                 (test-begin "test5")
                 (test-end)
                 (test-end)
                 (test-begin "test6")
                 (test-end)))

(test-test-msg "testing test7\n"
               (begin
                 (test-begin "test7" 0)
                 (test-end)))

(test-error (test-end))

(test-test-msg "testing test8\n\"test.scm\"@222.18: FAILED (test-equal \"\" (test-end \"other\")) GOT #<error-exception #7>\n"
               (begin
                 (test-begin "test8")
                 (test-equal "" (test-end "other"))))

(test-test-msg "testing test9\n"
               (begin
                 (test-group "test9" 11 22 33)
                 42))

(test-test-msg "testing test10\n| testing test11\n| testing test12\n"
               (begin
                 (test-group "test10"
                  (test-group "test11" 11 22 33)
                  (test-group "test12" 44 55 66))
                 42))

;;;============================================================================
