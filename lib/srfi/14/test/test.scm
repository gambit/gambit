;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 14, Character-set Library

(import (srfi 14))
(import (_test))

;;;============================================================================

;; The rest of this file is the file 14.scm found at
;;
;; https://github.com/srfi-explorations/srfi-test

;;;============================================================================

;; Copyright 2000 Olin Shivers
;; SPDX-License-Identifier: MIT

(test-begin "srfi-14")

(define (vowel? c) (member c '(#\a #\e #\i #\o #\u)))

(test-assert (not (char-set? 5)))

(test-assert (char-set? (char-set #\a #\e #\i #\o #\u)))

(test-assert (char-set=))

(test-assert (char-set= (char-set)))

(test-assert (char-set= (char-set #\a #\e #\i #\o #\u)
                        (string->char-set "ioeauaiii")))

(test-assert (not (char-set= (char-set #\e #\i #\o #\u)
                             (string->char-set "ioeauaiii"))))

(test-assert (char-set<=))

(test-assert (char-set<= (char-set)))

(test-assert (char-set<= (char-set #\a #\e #\i #\o #\u)
                         (string->char-set "ioeauaiii")))

(test-assert (char-set<= (char-set #\e #\i #\o #\u)
                         (string->char-set "ioeauaiii")))

(test-assert (<= 0 (char-set-hash char-set:graphic 100) 99))

(test-assert (= 4 (char-set-fold (lambda (c i) (+ i 1)) 0
                                 (char-set #\e #\i #\o #\u #\e #\e))))

(test-assert
    (char-set= (string->char-set "eiaou2468013579999")
               (char-set-unfold null? car cdr '(#\a #\e #\i #\o #\u #\u #\u)
                                (char-set-intersection
                                 char-set:digit char-set:ascii))))

(test-assert
    (char-set= (string->char-set "eiaou246801357999")
               (char-set-unfold! null? car cdr '(#\a #\e #\i #\o #\u)
                                 (string->char-set "0123456789"))))

(test-assert
    (not (char-set= (string->char-set "eiaou246801357")
                    (char-set-unfold! null? car cdr '(#\a #\e #\i #\o #\u)
                                      (string->char-set "0123456789")))))

(test-assert
    (let ((cs (string->char-set "0123456789")))
      (char-set-for-each (lambda (c) (set! cs (char-set-delete cs c)))
                         (string->char-set "02468000"))
      (char-set= cs (string->char-set "97531"))))

(test-assert
    (not (let ((cs (string->char-set "0123456789")))
           (char-set-for-each (lambda (c) (set! cs (char-set-delete cs c)))
                              (string->char-set "02468"))
           (char-set= cs (string->char-set "7531")))))

(test-assert
    (char-set= (char-set-map char-upcase (string->char-set "aeiou"))
               (string->char-set "IOUAEEEE")))

(test-assert
    (not (char-set= (char-set-map char-upcase (string->char-set "aeiou"))
                    (string->char-set "OUAEEEE"))))

(test-assert
    (char-set= (char-set-copy (string->char-set "aeiou"))
               (string->char-set "aeiou")))

(test-assert
    (char-set= (char-set #\x #\y) (string->char-set "xy")))

(test-assert
    (not (char-set= (char-set #\x #\y #\z) (string->char-set "xy"))))

(test-assert
    (char-set= (string->char-set "xy") (list->char-set '(#\x #\y))))

(test-assert
    (not (char-set= (string->char-set "axy") (list->char-set '(#\x #\y)))))

(test-assert
    (char-set= (string->char-set "xy12345")
               (list->char-set '(#\x #\y) (string->char-set "12345"))))

(test-assert
    (not (char-set= (string->char-set "y12345")
                    (list->char-set '(#\x #\y) (string->char-set "12345")))))

(test-assert
    (char-set= (string->char-set "xy12345")
               (list->char-set! '(#\x #\y) (string->char-set "12345"))))

(test-assert
    (not (char-set= (string->char-set "y12345")
                    (list->char-set! '(#\x #\y) (string->char-set "12345")))))

(test-assert
    (char-set= (string->char-set "aeiou12345")
               (char-set-filter vowel? char-set:ascii
                                (string->char-set "12345"))))

(test-assert
    (not (char-set= (string->char-set "aeou12345")
                    (char-set-filter vowel? char-set:ascii
                                     (string->char-set "12345")))))

(test-assert
    (char-set= (string->char-set "aeiou12345")
               (char-set-filter! vowel? char-set:ascii
                                 (string->char-set "12345"))))

(test-assert
    (not (char-set= (string->char-set "aeou12345")
                    (char-set-filter! vowel? char-set:ascii
                                      (string->char-set "12345")))))

(test-assert
    (char-set= (string->char-set "abcdef12345")
               (ucs-range->char-set 97 103 #t (string->char-set "12345"))))

(test-assert
    (not (char-set= (string->char-set "abcef12345")
                    (ucs-range->char-set 97 103 #t
                                         (string->char-set "12345")))))

(test-assert
    (char-set= (string->char-set "abcdef12345")
               (ucs-range->char-set! 97 103 #t (string->char-set "12345"))))

(test-assert
    (not (char-set= (string->char-set "abcef12345")
                    (ucs-range->char-set! 97 103 #t
                                          (string->char-set "12345")))))

(test-assert (char-set= (->char-set #\x)
                        (->char-set "x")
                        (->char-set (char-set #\x))))

(test-assert (not (char-set= (->char-set #\x)
                             (->char-set "y")
                             (->char-set (char-set #\x)))))

(test-assert
    (= 10 (char-set-size
           (char-set-intersection char-set:ascii char-set:digit))))

(test-assert (= 5 (char-set-count vowel? char-set:ascii)))

(test-assert (equal? '(#\x) (char-set->list (char-set #\x))))
(test-assert (not (equal? '(#\X) (char-set->list (char-set #\x)))))

(test-assert (equal? "x" (char-set->string (char-set #\x))))
(test-assert (not (equal? "X" (char-set->string (char-set #\x)))))

(test-assert (char-set-contains? (->char-set "xyz") #\x))
(test-assert (not (char-set-contains? (->char-set "xyz") #\a)))

(test-assert (char-set-every char-lower-case? (->char-set "abcd")))
(test-assert (not (char-set-every char-lower-case? (->char-set "abcD"))))
(test-assert (char-set-any char-lower-case? (->char-set "abcd")))
(test-assert (not (char-set-any char-lower-case? (->char-set "ABCD"))))

(test-assert
    (char-set=
     (->char-set "ABCD")
     (let ((cs (->char-set "abcd")))
       (let lp ((cur (char-set-cursor cs)) (ans '()))
         (if (end-of-char-set? cur) (list->char-set ans)
             (lp (char-set-cursor-next cs cur)
                 (cons (char-upcase (char-set-ref cs cur)) ans)))))))


(test-assert (char-set= (char-set-adjoin (->char-set "123") #\x #\a)
                        (->char-set "123xa")))

(test-assert (not (char-set= (char-set-adjoin (->char-set "123") #\x #\a)
                             (->char-set "123x"))))

(test-assert (char-set= (char-set-adjoin! (->char-set "123") #\x #\a)
                        (->char-set "123xa")))

(test-assert (not (char-set= (char-set-adjoin! (->char-set "123") #\x #\a)
                             (->char-set "123x"))))

(test-assert (char-set= (char-set-delete (->char-set "123") #\2 #\a #\2)
                        (->char-set "13")))

(test-assert (not (char-set= (char-set-delete (->char-set "123") #\2 #\a #\2)
                             (->char-set "13a"))))

(test-assert (char-set= (char-set-delete! (->char-set "123") #\2 #\a #\2)
                        (->char-set "13")))

(test-assert
    (not (char-set= (char-set-delete! (->char-set "123") #\2 #\a #\2)
                    (->char-set "13a"))))

(test-assert
    (char-set= (char-set-intersection char-set:hex-digit
                                      (char-set-complement char-set:digit))
               (->char-set "abcdefABCDEF")))

(test-assert (char-set= (char-set-intersection!
                         (char-set-complement! (->char-set "0123456789"))
                         char-set:hex-digit)
                        (->char-set "abcdefABCDEF")))

(test-assert (char-set= (char-set-union char-set:hex-digit
                                        (->char-set "abcdefghijkl"))
                        (->char-set "abcdefABCDEFghijkl0123456789")))

(test-assert (char-set= (char-set-union! (->char-set "abcdefghijkl")
                                         char-set:hex-digit)
                        (->char-set "abcdefABCDEFghijkl0123456789")))

(test-assert (char-set= (char-set-difference (->char-set "abcdefghijklmn")
                                             char-set:hex-digit)
                        (->char-set "ghijklmn")))

(test-assert (char-set= (char-set-difference! (->char-set "abcdefghijklmn")
                                              char-set:hex-digit)
                        (->char-set "ghijklmn")))

(test-assert (char-set= (char-set-xor (->char-set "0123456789")
                                      char-set:hex-digit)
                        (->char-set "abcdefABCDEF")))

(test-assert (char-set= (char-set-xor! (->char-set "0123456789")
                                       char-set:hex-digit)
                        (->char-set "abcdefABCDEF")))

(test-assert
    (call-with-values (lambda ()
                        (char-set-diff+intersection char-set:hex-digit
                                                    char-set:letter))
      (lambda (d i)
        (and (char-set= d (->char-set "0123456789"))
             (char-set= i (->char-set "abcdefABCDEF"))))))

(test-assert
    (call-with-values (lambda ()
                        (char-set-diff+intersection!
                         (char-set-copy char-set:hex-digit)
                         (char-set-copy char-set:letter)))
      (lambda (d i)
        (and (char-set= d (->char-set "0123456789"))
             (char-set= i (->char-set "abcdefABCDEF"))))))

(test-end "srfi-14")
