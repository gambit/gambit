;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 48, Intermediate Format Strings

(import (srfi 48))
(import (_test))

(define-syntax test-start
  (syntax-rules ()
    ((test-start name)
     #f)))

(define-syntax test-end
  (syntax-rules ()
    ((test-end)
     #f)))

(define-syntax test-section
  (syntax-rules ()
    ((test-section name)
     #f)))

(define-syntax expect
  (syntax-rules ()
    ((expect expected result)
     (test-equal expected result))
    ((expect expected result test)
     (test-assert #t (test expected result)))))

;;;============================================================================

;; The rest of this file is the file test-0001-Gambit.scm found at
;;
;; https://github.com/scheme-requests-for-implementation/srfi-48/blob/master/test

;;;============================================================================

;;
;; srfi-48 format test for Gambit
;;

(define (x->number x)
  (cond
   ((number? x) x)
   ((string? x) (string->number x))
   (else (error "x->number error"))))

(define (nearly=? a b)
  (let* ((a1 (x->number a))
         (b1 (x->number b))
         (e1 (abs (- a1 b1))))
    ;(format #t "(a1 = ~s, b1 = ~s, e1 = ~s)~%" a1 b1 e1)
    (< e1 1.0e-10)))

(define pi 3.141592653589793)

(test-start "srfi-48 format test")

(test-section "original")
(expect (format "test ~s" 'me) (format #f "test ~a" "me"))
(expect  "  .333" (format "~6,3F" 1/3)) ;;; "  .333" OK
(expect "  12" (format "~4F" 12))
(expect "  12.346" (format "~8,3F" 12.3456))
(expect "123.346" (format "~6,3F" 123.3456))
(expect "123.346" (format "~4,3F" 123.3456))
(expect "0.000+1.949i" (format "~8,3F" (sqrt -3.8)))
(expect " 32.00" (format "~6,2F" 32))
(expect "    32" (format "~6F" 32))
;(expect "   32." (format "~6F" 32.)) ;; "  32.0" OK
(expect "   32." (format "~6F" 32.))
;; NB: (not (and (exact? 32.) (integer? 32.)))
(expect "  3.2e46" (format "~8F" 32e45))
(expect " 3.2e-44" (format "~8F" 32e-45))
(expect "  3.2e21" (format "~8F" 32e20))
;;(expect "   3.2e6" (format "~8F" 32e5)) ;; ok.  converted in input to 3200000.0
;(expect "   3200." (format "~8F" 32e2)) ;; "  3200.0" OK
(expect "   3200." (format "~8F" 32e2))
(expect " 3.20e11" (format "~8,2F" 32e10))
(expect "      1.2345" (format "~12F" 1.2345))
(expect "        1.23" (format "~12,2F" 1.2345))
(expect "       1.234" (format "~12,3F" 1.2345))
(expect "        0.000+1.949i" (format "~20,3F" (sqrt -3.8)))
(expect "0.000+1.949i" (format "~8,3F" (sqrt -3.8)))
(expect " 3.46e11" (format "~8,2F" 3.4567e11))
; (expect "#1=(a b c . #1#)"
;         (format "~w" (let ( (c '(a b c)) ) (set-cdr! (cddr c) c) c)))
(expect "
"
        (format "~A~A~&" (list->string (list #\newline)) ""))
(expect "a new test"
        (format "~a ~? ~a" 'a "~s" '(new) 'test))
(expect "a new test, yes!"
        (format "~a ~?, ~a!" 'a "~s ~a" '(new test) 'yes))
(expect " 3.46e20"   (format "~8,2F" 3.4567e20))
(expect " 3.46e21"   (format "~8,2F" 3.4567e21))
(expect " 3.46e22"   (format "~8,2F" 3.4567e22))
(expect " 3.46e23"   (format "~8,2F" 3.4567e23))
(expect "   3.e24"   (format "~8,0F" 3.4567e24))
(expect "  3.5e24"   (format "~8,1F" 3.4567e24))
(expect " 3.46e24"   (format "~8,2F" 3.4567e24))
(expect "3.457e24"   (format "~8,3F" 3.4567e24))
(expect "   4.e24"   (format "~8,0F" 3.5567e24))
(expect "  3.6e24"   (format "~8,1F" 3.5567e24))
(expect " 3.56e24"   (format "~8,2F" 3.5567e24))
(expect "    -3.e-4" (format "~10,0F" -3e-4))
(expect "   -3.0e-4" (format "~10,1F" -3e-4))
(expect "  -3.00e-4" (format "~10,2F" -3e-4))
(expect " -3.000e-4" (format "~10,3F" -3e-4))
(expect "-3.0000e-4" (format "~10,4F" -3e-4))
(expect "-3.00000e-4" (format "~10,5F" -3e-4))
(expect "     1.020" (format "~10,3F" 1.02))
(expect "     1.025" (format "~10,3F" 1.025))
(expect "     1.026" (format "~10,3F" 1.0256))
(expect "     1.002" (format "~10,3F" 1.002))
(expect "     1.002" (format "~10,3F" 1.0025))
(expect "     1.003" (format "~10,3F" 1.00256))


(test-section "examples")
(expect "     .33"   (format "~8,2F" 1/3))
(expect "    32"     (format "~6F" 32))
(expect "   32.00"   (format "~8,2F" 32))
(expect "4321.00"    (format "~1,2F" 4321))
(expect "0.00+1.97i" (format "~1,2F" (sqrt -3.9)))
(expect "3200000."   (format "~8F" 32e5))
;(expect "   3.2e6"   (format "~8F" 32e5))
(expect "<string>"   (format "~h") (lambda (e r) (string? r)))
(expect "Hello, World!" (format "Hello, ~a" "World!"))
(expect "Error, list is too short: (one \"two\" 3)" (format "Error, list is too short: ~s" '(one "two" 3)))
(expect "test me"    (format "test me"))
(expect "this is a \"test\"" (format "~a ~s ~a ~s" 'this 'is "a" "test"))
(expect "#d32 #x20 #o40 #b100000\n" (with-output-to-string (lambda () (format #t "#d~d #x~x #o~o #b~b~%" 32 32 32 32)))) ;; **** MODIFIED to prevent output
(with-output-to-string (lambda () (expect #!void (format #t "#d~d #x~x #o~o #b~b~%" 32 32 32 32)))) ;; **** MODIFIED to prevent output
(expect "a new test" (format "~a ~? ~a" 'a "~s" '(new) 'test))
(expect "\n1\n2\n3\n" (format #f "~&1~&~&2~&~&~&3~%"))
(expect "3  2 2  3 \n" (format #f "~a ~? ~a ~%" 3 " ~s ~s " '(2 2) 3))
;; incorrect mutation of literal list in example
;(expect "#1=(a b c . #1#)" (format "~w" (let ( (c '(a b c)) ) (set-cdr! (cddr c) c) c)))
;(expect "#0=(a b c . #0#)" (format "~w" (let ( (c (list 'a 'b 'c)) ) (set-cdr! (cddr c) c) c)))
(expect "   32.00"   (format "~8,2F" 32))
(expect "0.000+1.949i" (format "~8,3F" (sqrt -3.8)))
;(expect " 3.45e11"   (format "~8,2F" 3.4567e11))
(expect " 3.46e11"   (format "~8,2F" 3.4567e11))
(expect "  .333"     (format "~6,3F" 1/3))
(expect "  12"       (format "~4F" 12))
(expect " 123.346"   (format "~8,3F" 123.3456))
(expect "123.346"    (format "~6,3F" 123.3456))
(expect "123.346"    (format "~2,3F" 123.3456))
(expect "     foo"   (format "~8,3F" "foo"))
(expect "\n"         (format "~a~a~&" (list->string (list #\newline)) ""))


(test-section "~F normal")
(expect "0"          (format "~F"    0))
(expect "1"          (format "~F"    1))
(expect "123"        (format "~F"  123))
(expect ".456"       (format "~F"    0.456))
(expect "123.456"    (format "~F"  123.456))
(expect "-1"         (format "~F"   -1))
(expect "-123"       (format "~F" -123))
(expect "-.456"      (format "~F"   -0.456))
(expect "-123.456"   (format "~F" -123.456))


(test-section "~F width")
(expect "123"        (format "~0F"  123))
(expect "123"        (format "~1F"  123))
(expect "123"        (format "~2F"  123))
(expect "123"        (format "~3F"  123))
(expect " 123"       (format "~4F"  123))
(expect "  123"      (format "~5F"  123))
(expect "-123"       (format "~3F" -123))
(expect "-123"       (format "~4F" -123))
(expect " -123"      (format "~5F" -123))
(expect "  -123"     (format "~6F" -123))


(test-section "~F digits")
(expect "123."       (format "~1,0F"   123))
(expect "123.0"      (format "~1,1F"   123))
(expect "123.00"     (format "~1,2F"   123))
(expect ".12"        (format "~1,2F"   0.123))
(expect ".123"       (format "~1,3F"   0.123))
(expect ".1230"      (format "~1,4F"   0.123))
(expect "-123."      (format "~1,0F"  -123))
(expect "-123.0"     (format "~1,1F"  -123))
(expect "-123.00"    (format "~1,2F"  -123))
(expect "-.12"       (format "~1,2F"  -0.123))
(expect "-.123"      (format "~1,3F"  -0.123))
(expect "-.1230"     (format "~1,4F"  -0.123))


(test-section "~F rounding (banker's rounding)")
(expect "123."       (format "~1,0F"   123.456))
(expect "123.5"      (format "~1,1F"   123.456))
(expect "123.46"     (format "~1,2F"   123.456))
(expect "-123."      (format "~1,0F"  -123.456))
(expect "-123.5"     (format "~1,1F"  -123.456))
(expect "-123.46"    (format "~1,2F"  -123.456))
(expect "123.0"      (format "~1,1F"   123.05))
(expect "123.2"      (format "~1,1F"   123.15))
(expect "124.0"      (format "~1,1F"   123.95))
(expect "-123.0"     (format "~1,1F"  -123.05))
(expect "-123.2"     (format "~1,1F"  -123.15))
(expect "-124.0"     (format "~1,1F"  -123.95))
(expect "1000.00"    (format "~1,2F"   999.995))
(expect "-1000.00"   (format "~1,2F"  -999.995))
(expect "1."         (format "~1,0F"   1.49))
(expect "2."         (format "~1,0F"   1.5))
(expect "2."         (format "~1,0F"   1.51))
(expect "2."         (format "~1,0F"   2.49))
(expect "2."         (format "~1,0F"   2.5))
(expect "3."         (format "~1,0F"   2.51))


(test-section "~F misc")
(expect "+inf.0"     (format "~F" +inf.0))
(expect "-inf.0"     (format "~F" -inf.0))
(expect "+nan.0"     (format "~F" +nan.0))
(expect "0."         (format "~F" 0.0))
(expect "-0."        (format "~F" -0.0))
(expect "+inf.0"     (format "~1F" +inf.0))
(expect "-inf.0"     (format "~1F" -inf.0))
(expect "+nan.0"     (format "~1F" +nan.0))
(expect "0."         (format "~1F" 0.0))
(expect "-0."        (format "~1F" -0.0))
(expect "+inf.0"     (format "~1,0F" +inf.0))
(expect "-inf.0"     (format "~1,0F" -inf.0))
(expect "+nan.0"     (format "~1,0F" +nan.0))
(expect "0."         (format "~1,0F" 0.0))
(expect "-0."        (format "~1,0F" -0.0))
(expect "+inf.0"     (format "~1,1F" +inf.0))
(expect "-inf.0"     (format "~1,1F" -inf.0))
(expect "+nan.0"     (format "~1,1F" +nan.0))
(expect "0.0"        (format "~1,1F" 0.0))
(expect "-0.0"       (format "~1,1F" -0.0))
(expect "31.41592653589793" (format "~F" (* pi 10)))
(expect ".33333"     (format "~1,5F"  1/3))
(expect "-.33333"    (format "~1,5F" -1/3))
(expect ".142857142857"  (format "~1,12F"  1/7))
(expect "299999999.999999999" (format "~F" 299999999999999999/1000000000) nearly=?)
(expect "1.797693e308"   (format "~F"     1.797693e308))
(expect "1.797693e308"   (format "~1F"    1.797693e308))
(expect "2.e308"         (format "~1,0F"  1.797693e308))
(expect "1.8e308"        (format "~1,1F"  1.797693e308))
(expect "-1.797693e308"  (format "~F"    -1.797693e308))
(expect "-1.797693e308"  (format "~1F"   -1.797693e308))
(expect "-2.e308"        (format "~1,0F" -1.797693e308))
(expect "-1.8e308"       (format "~1,1F" -1.797693e308))
(expect "2.225074e-308"  (format "~F"  2.225074e-308))
(expect "5.02"       (format "~1,2F" 5.015))
(expect "6.00"       (format "~1,2F" 5.999))
(expect "123."       (format "~1,0F" 123.00))
(expect ".1"         (format "~F" .1))
(expect "1"          (format "~1f" 1)) ; lower case f
(expect "1.e100"     (format "~1,0F" 1e100))
(expect "1."         (format "~1,0F" 1))
(expect "0."         (format "~1,0F" .1))
(expect "0.0"        (format "~1,1F" .01))


;(test-section "~F error")
;(expect "<error>" (guard (e (else "<error>")) (format "~-1F" 1)))
;(expect "<error>" (guard (e (else "<error>")) (format "~1,-1F" 1)))


(test-section "from mailing list 2004-05-27")
(expect "1.230e20"   (format "~0,3F" 1.23e20))
(expect "1.230e-20"  (format "~0,3F" 1.23e-20))


(test-section "from mailing list 2004-06-11")
(expect "3.457e15"   (format "~8,3F" 3.4569e15))
(expect "   3.457"   (format "~8,3F" 3.4569))
(expect " 3.46e15"   (format "~8,2F" 3.456e15))
(expect "    3.46"   (format "~8,2F" 3.456))


(test-section "from mailing list 2005-06-03")
(expect "    -3.e-4" (format "~10,0F" -3e-4))
(expect "   -3.0e-4" (format "~10,1F" -3e-4))
(expect "  -3.00e-4" (format "~10,2F" -3e-4))
(expect " -3.000e-4" (format "~10,3F" -3e-4))
(expect "-3.0000e-4" (format "~10,4F" -3e-4))
(expect " 3.0000e-5" (format "~10,4F"  3e-5))


(test-section "from mailing list 2005-06-07")
(expect "     1.020" (format "~10,3F" 1.02))
(expect "     1.025" (format "~10,3F" 1.025))
(expect "     1.026" (format "~10,3F" 1.0256))
(expect "     1.002" (format "~10,3F" 1.002))
(expect "     1.002" (format "~10,3F" 1.0025))
(expect "     1.003" (format "~10,3F" 1.00256))


(test-section "from mailing list 2005-06-07")
(expect "1.000012"   (format "~8,6F" 1.00001234))


(test-section "from mailing list 2005-07-02")
(expect "abc\ndef\nghi\n" (format "abc~%~&def~&ghi~%"))
(expect "\ndef\nghi\n" (format "~&def~&ghi~%"))


(test-section "from mailing list 2017-10-11")
(expect "   1.00"    (format "~7,2F" .997554209949891))
(expect "   1.00"    (format "~7,2F" .99755))
(expect "   1.00"    (format "~7,2F" .9975))
(expect "   1.00"    (format "~7,2F" .997))
(expect "    .99"    (format "~7,2F" .99))


(test-section "from mailing list 2017-10-13")
(expect "  18.00"    (format "~7,2F" 18.0000000000008))
(expect "    -15."   (format "~8,0F" -14.99995999999362))

(test-end)

;;;============================================================================
