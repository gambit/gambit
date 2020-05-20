;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(import (_test))

(define-syntax macro-set-current-directory-to-this-source-file-directory
  (lambda (src)
    (let ((path (##source-path src)))
      (if path (current-directory (path-directory path)))
      #f)))

;; make error messages predictable
(macro-set-current-directory-to-this-source-file-directory)

(define (output-msg thunk) ;; for testing checks that fail
  (let ((save-test-all? _test#test-all?)
        (save-test-quiet? _test#test-quiet?)
        (save-test-verbose? _test#test-verbose?)
        (save-nb-passed-tests _test#nb-passed-tests)
        (save-nb-failed-tests _test#nb-failed-tests)
        (save-nb-skipped-tests _test#nb-skipped-tests)
        (save-context _test#context))
    (set! _test#test-all? #t)
    (set! _test#test-quiet? #f)
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
      (set! _test#nb-skipped-tests save-nb-skipped-tests)
      (set! _test#context save-context)
      msg)))


(test-assert (< 1 2))

(test-assert "testing that (< 1 2)" (< 1 2))

(test-assert (member 'b '(a b c)))

(test-equal "\"test.scm\"@53.36: FAILED (test-assert (< 2 1)) GOT #f\n"
            (output-msg (lambda () (test-assert (< 2 1)))))

(test-equal "\"test.scm\"@56.36: FAILED test-assert-fail GOT #f\n"
            (output-msg (lambda () (test-assert "test-assert-fail" (< 2 1)))))

(test-equal "\"test.scm\"@59.36: FAILED (test-assert (raise 'exception)) GOT exception\n"
            (output-msg (lambda () (test-assert (raise 'exception)))))


(test-equal "abc" "abc")

(test-equal "testing that \"abc\" is equal? to \"abc\"" "abc" "abc")

(test-equal "\"test.scm\"@67.36: FAILED (test-equal \"abc\" \"ab_\") GOT \"ab_\"\n"
            (output-msg (lambda () (test-equal "abc" "ab_"))))

(test-equal "\"test.scm\"@70.36: FAILED test-equal-fail GOT \"ab_\"\n"
            (output-msg (lambda () (test-equal "test-equal-fail" "abc" "ab_"))))

(test-equal "\"test.scm\"@73.36: FAILED (test-equal (raise 'exception) \"abc\") GOT exception\n"
            (output-msg (lambda () (test-equal (raise 'exception) "abc"))))

(test-equal "\"test.scm\"@76.36: FAILED (test-equal \"abc\" (raise 'exception)) GOT exception\n"
            (output-msg (lambda () (test-equal "abc" (raise 'exception)))))


(test-eqv 42 42)

(test-eqv "testing that 42 is eqv? to 42" 42 42)

(test-equal "\"test.scm\"@84.36: FAILED (test-eqv 42 13) GOT 13\n"
            (output-msg (lambda () (test-eqv 42 13))))

(test-equal "\"test.scm\"@87.36: FAILED test-eqv-fail GOT 13\n"
            (output-msg (lambda () (test-eqv "test-eqv-fail" 42 13))))

(test-equal "\"test.scm\"@90.36: FAILED (test-eqv 42 (raise 'exception)) GOT exception\n"
            (output-msg (lambda () (test-eqv 42 (raise 'exception)))))


(test-eq 'a 'a)

(test-eq "testing that 'a is eq? to 'a" 'a 'a)

(test-equal "\"test.scm\"@98.36: FAILED (test-eq 'a 'b) GOT b\n"
            (output-msg (lambda () (test-eq 'a 'b))))

(test-equal "\"test.scm\"@101.36: FAILED test-eq-fail GOT b\n"
            (output-msg (lambda () (test-eq "test-eq-fail" 'a 'b))))

(test-equal "\"test.scm\"@104.36: FAILED (test-eq (raise 'exception) 'a) GOT exception\n"
            (output-msg (lambda () (test-eq (raise 'exception) 'a))))

(test-equal "\"test.scm\"@107.36: FAILED (test-eq 'a (raise 'exception)) GOT exception\n"
            (output-msg (lambda () (test-eq 'a (raise 'exception)))))


(test-approximate 1.5 1.5 0)

(test-approximate 1.5 1.4995 0.001)

(test-approximate "testing that 1.5 is equal to 1.5" 1.5 1.4995 0.001)

(test-equal "\"test.scm\"@117.36: FAILED (test-approximate 1.5 2.5 .001) GOT 2.5\n"
            (output-msg (lambda () (test-approximate 1.5 2.5 0.001))))

(test-equal "\"test.scm\"@120.36: FAILED test-approximate-fail GOT 2.5\n"
            (output-msg (lambda () (test-approximate "test-approximate-fail" 1.5 2.5 0.001))))

(test-equal "\"test.scm\"@123.36: FAILED (test-approximate (raise 'exception) 1.5 .001) GOT exception\n"
            (output-msg (lambda () (test-approximate (raise 'exception) 1.5 0.001))))

(test-equal "\"test.scm\"@126.36: FAILED (test-approximate 1.5 (raise 'exception) .001) GOT exception\n"
            (output-msg (lambda () (test-approximate 1.5 (raise 'exception) 0.001))))


(test-error (+ 1 (raise 'exception)))

(test-error #t (+ 1 (raise 'exception)))

(test-error symbol? (+ 1 (raise 'exception)))

(test-error "testing that evaluation raises an exception" #t (+ 1 (raise 'exception)))

(test-error "testing that evaluation raises a symbol" symbol? (+ 1 (raise 'exception)))

(test-equal "\"test.scm\"@140.36: FAILED (test-error 42) GOT 42\n"
            (output-msg (lambda () (test-error 42))))

(test-equal "\"test.scm\"@143.36: FAILED (test-error #t 42) GOT 42\n"
            (output-msg (lambda () (test-error #t 42))))

(test-equal "\"test.scm\"@146.36: FAILED (test-error string? 42) GOT 42\n"
            (output-msg (lambda () (test-error string? 42))))

(test-equal "\"test.scm\"@149.36: FAILED (test-error string? (raise 'exception)) GOT exception\n"
            (output-msg (lambda () (test-error string? (raise 'exception)))))

(test-equal "\"test.scm\"@152.36: FAILED test-error-fail GOT 42\n"
            (output-msg (lambda () (test-error "test-error-fail" #t 42))))

(test-equal "\"test.scm\"@155.36: FAILED test-error-fail GOT exception\n"
            (output-msg (lambda () (test-error "test-error-fail" string? (raise 'exception)))))


(test-error-tail (raise 'exception))

(test-error-tail #t (raise 'exception))

(test-error-tail symbol? (raise 'exception))

(test-error-tail "testing that evaluation raises an exception in tail position" #t (raise 'exception))

(test-error-tail "testing that evaluation raises a symbol in tail position" symbol? (raise 'exception))

(test-equal "\"test.scm\"@169.36: FAILED (test-error-tail 42) GOT 42\n"
            (output-msg (lambda () (test-error-tail 42))))

(test-equal "\"test.scm\"@172.36: FAILED (test-error-tail #t 42) GOT 42\n"
            (output-msg (lambda () (test-error-tail #t 42))))

(test-equal "\"test.scm\"@175.36: FAILED (test-error-tail string? 42) GOT 42\n"
            (output-msg (lambda () (test-error-tail string? 42))))

(test-equal "\"test.scm\"@178.36: FAILED (test-error-tail string? (raise 'exception)) GOT exception\n"
            (output-msg (lambda () (test-error-tail string? (raise 'exception)))))

(test-equal "\"test.scm\"@181.36: FAILED test-error-tail-fail GOT 42\n"
            (output-msg (lambda () (test-error-tail "test-error-tail-fail" #t 42))))

(test-equal "\"test.scm\"@184.36: FAILED test-error-tail-fail GOT exception\n"
            (output-msg (lambda () (test-error "test-error-tail-fail" string? (raise 'exception)))))

(test-equal "\"test.scm\"@187.36: FAILED (test-error-tail (+ 1 (raise 'exception))) GOT (nontail-exception-raised-in #<procedure #2>)\n"
            (output-msg (lambda () (test-error-tail (+ 1 (raise 'exception))))))

(test-equal "\"test.scm\"@190.36: FAILED (test-error-tail #t (+ 1 (raise 'exception))) GOT (nontail-exception-raised-in #<procedure #3>)\n"
            (output-msg (lambda () (test-error-tail #t (+ 1 (raise 'exception))))))

(test-equal "\"test.scm\"@193.36: FAILED (test-error-tail symbol? (+ 1 (raise 'exception))) GOT (nontail-exception-raised-in #<procedure #4>)\n"
            (output-msg (lambda () (test-error-tail symbol? (+ 1 (raise 'exception))))))

(test-equal "\"test.scm\"@196.36: FAILED testing that evaluation raises an exception in tail position GOT (nontail-exception-raised-in #<procedure #5>)\n"
            (output-msg (lambda () (test-error-tail "testing that evaluation raises an exception in tail position" #t (+ 1 (raise 'exception))))))

(test-equal "\"test.scm\"@199.36: FAILED testing that evaluation raises a symbol in tail position GOT (nontail-exception-raised-in #<procedure #6>)\n"
            (output-msg (lambda () (test-error-tail "testing that evaluation raises a symbol in tail position" symbol? (+ 1 (raise 'exception))))))

(test-equal "testing test1\n"
            (output-msg (lambda ()
                          (test-begin "test1")
                          (test-end))))

(test-equal "testing test2\n"
            (output-msg (lambda ()
                          (test-begin "test2")
                          (test-end "test2"))))

(test-equal "testing test3\n| testing test4\n| testing test5\ntesting test6\n"
            (output-msg (lambda ()
                          (test-begin "test3")
                          (test-begin "test4")
                          (test-end)
                          (test-begin "test5")
                          (test-end)
                          (test-end)
                          (test-begin "test6")
                          (test-end))))

(test-equal "testing test7\n"
            (output-msg (lambda ()
                          (test-begin "test7" 0)
                          (test-end))))

(test-error (test-end))

(test-equal "testing test8\n\"test.scm\"@232.27: FAILED (test-equal \"\" (test-end \"other\")) GOT #<error-exception #7>\n"
            (output-msg (lambda ()
                          (test-begin "test8")
                          (test-equal "" (test-end "other")))))

(test-equal "testing test9\n"
            (output-msg (lambda ()
                          (test-group "test9" 11 22 33)
                          42)))

(test-equal "testing test10\n| testing test11\n| testing test12\n"
            (output-msg (lambda ()
                          (test-group "test10"
                           (test-group "test11" 11 22 33)
                           (test-group "test12" 44 55 66))
                          42)))

;;;============================================================================
