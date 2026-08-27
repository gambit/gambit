(include "#.scm")

;; Most of these tests come from the Chibi Scheme tests for SRFI-14.

(define (vowel? c) (member c '(#\a #\e #\i #\o #\u)))

(test-eq #f (char-set? 5))

(test-assert (char-set? (char-set #\a #\e #\i #\o #\u)))

(test-assert (char-set=))
(test-assert (char-set= (char-set)))

(test-equal char-set= (char-set #\a #\e #\i #\o #\u)
            (string->char-set "ioeauaiii"))

(test-eq #f (char-set= (char-set #\e #\i #\o #\u)
                       (string->char-set "ioeauaiii")))

(test-assert (char-set<=))
(test-assert (char-set<= (char-set)))

(test-assert (char-set<= (char-set #\a #\e #\i #\o #\u)
                         (string->char-set "ioeauaiii")))

(test-assert (char-set<= (char-set #\e #\i #\o #\u)
                         (string->char-set "ioeauaiii")))

(test-assert (<= 0 (char-set-hash char-set:graphic 100) 99))

(test-equal 4 (char-set-fold (lambda (c i) (+ i 1)) 0
                             (char-set #\e #\i #\o #\u #\e #\e)))

(test-equal char-set= (string->char-set "eiaou2468013579999")
            (char-set-unfold null? car cdr
                             '(#\a #\e #\i #\o #\u #\u #\u)
                             (char-set-intersection char-set:ascii
                                                    char-set:digit)))

(test-equal char-set= (string->char-set "eiaou246801357999")
            (char-set-unfold! null? car cdr '(#\a #\e #\i #\o #\u)
                              (string->char-set "0123456789")))

(test-eq #f (char-set= (string->char-set "eiaou246801357")
                       (char-set-unfold! null? car cdr
                                         '(#\a #\e #\i #\o #\u)
                                         (string->char-set "0123456789"))))

(let ((cs (string->char-set "0123456789")))
  (char-set-for-each (lambda (c) (set! cs (char-set-delete cs c)))
                     (string->char-set "02468000"))
  (test-equal char-set= cs (string->char-set "97531")))

(test-eq #f (let ((cs (string->char-set "0123456789")))
              (char-set-for-each (lambda (c) (set! cs (char-set-delete cs c)))
                                 (string->char-set "02468"))
              (char-set= cs (string->char-set "7531"))))

(test-equal char-set= (string->char-set "IOUAEEEE")
            (char-set-map char-upcase (string->char-set "aeiou")))

(test-eq #f (char-set= (char-set-map char-upcase (string->char-set "aeiou"))
                       (string->char-set "OUAEEEE")))

(test-equal char-set= (string->char-set "aeiou")
            (char-set-copy (string->char-set "aeiou")))

(test-equal char-set= (string->char-set "xy") (char-set #\x #\y))
(test-eq #f (char-set= (char-set #\x #\y #\z) (string->char-set "xy")))

(test-equal char-set= (string->char-set "xy") (list->char-set '(#\x #\y)))
(test-eq #f (char-set= (string->char-set "axy")
                       (list->char-set '(#\x #\y))))

(test-equal char-set= (string->char-set "xy12345")
            (list->char-set '(#\x #\y) (string->char-set "12345")))
(test-eq #f (char-set= (string->char-set "y12345")
                       (list->char-set '(#\x #\y)
                                       (string->char-set "12345"))))

(test-equal char-set= (string->char-set "xy12345")
            (list->char-set! '(#\x #\y) (string->char-set "12345")))
(test-eq #f (char-set= (string->char-set "y12345")
                       (list->char-set! '(#\x #\y)
                                        (string->char-set "12345"))))

(test-equal char-set= (string->char-set "aeiou12345")
            (char-set-filter vowel?
                             char-set:ascii
                             (string->char-set "12345")))
(test-eq #f (char-set= (string->char-set "aeou12345")
                       (char-set-filter vowel?
                                        char-set:ascii
                                        (string->char-set "12345"))))

(test-equal char-set= (string->char-set "aeiou12345")
            (char-set-filter! vowel?
                              char-set:ascii
                              (string->char-set "12345")))
(test-eq #f (char-set= (string->char-set "aeou12345")
                       (char-set-filter! vowel?
                                         char-set:ascii
                                         (string->char-set "12345"))))

(test-equal char-set= (string->char-set "abcdef12345")
            (ucs-range->char-set 97 103 #t (string->char-set "12345")))
(test-eq #f (char-set=
             (string->char-set "abcef12345")
             (ucs-range->char-set 97 103 #t (string->char-set "12345"))))

(test-equal char-set= (string->char-set "abcdef12345")
            (ucs-range->char-set! 97 103 #t (string->char-set "12345")))
(test-eq #f (char-set=
             (string->char-set "abcef12345")
             (ucs-range->char-set! 97 103 #t (string->char-set "12345"))))

(test-assert (char-set= (->char-set #\x)
                        (->char-set "x")
                        (->char-set (char-set #\x))))

(test-eq #f (char-set= (->char-set #\x)
                       (->char-set "y")
                       (->char-set (char-set #\x))))

(test-equal 10 (char-set-size
                (char-set-intersection char-set:ascii char-set:digit)))
(test-equal 10 (char-set-size
                (char-set-intersection char-set:digit char-set:ascii)))

(test-equal 5 (char-set-count vowel? char-set:ascii))

(test-equal '(#\x) (char-set->list (char-set #\x)))
(test-eq #f (equal? '(#\X) (char-set->list (char-set #\x))))

(test-equal "x" (char-set->string (char-set #\x)))
(test-eq #f (equal? "X" (char-set->string (char-set #\x))))

(test-assert (char-set-contains? (->char-set "xyz") #\x))
(test-eq #f (char-set-contains? (->char-set "xyz") #\a))

(test-assert (char-set-every char-lower-case? (->char-set "abcd")))
(test-eq #f (char-set-every char-lower-case? (->char-set "abcD")))
(test-assert (char-set-any char-lower-case? (->char-set "abcd")))
(test-eq #f (char-set-any char-lower-case? (->char-set "ABCD")))

(test-equal char-set= (->char-set "ABCD")
            (let ((cs (->char-set "abcd")))
              (let lp ((cur (char-set-cursor cs)) (ans '()))
                (if (end-of-char-set? cur) (list->char-set ans)
                    (lp (char-set-cursor-next cs cur)
                        (cons (char-upcase (char-set-ref cs cur)) ans))))))


(test-equal char-set= (->char-set "123xa")
            (char-set-adjoin (->char-set "123") #\x #\a))
(test-eq #f (char-set= (char-set-adjoin (->char-set "123") #\x #\a)
                       (->char-set "123x")))
(test-equal char-set= (->char-set "123xa")
            (char-set-adjoin! (->char-set "123") #\x #\a))
(test-eq #f (char-set= (char-set-adjoin! (->char-set "123") #\x #\a)
                       (->char-set "123x")))

(test-equal char-set= (->char-set "13")
            (char-set-delete (->char-set "123") #\2 #\a #\2))
(test-eq #f (char-set= (char-set-delete (->char-set "123") #\2 #\a #\2)
                       (->char-set "13a")))
(test-equal char-set= (->char-set "13")
            (char-set-delete! (->char-set "123") #\2 #\a #\2))
(test-eq #f (char-set= (char-set-delete! (->char-set "123") #\2 #\a #\2)
                       (->char-set "13a")))

(test-equal char-set= (->char-set "abcdefABCDEF")
            (char-set-intersection char-set:hex-digit
                                   (char-set-complement char-set:digit)))
(test-equal char-set= (->char-set "abcdefABCDEF")
            (char-set-intersection!
             (char-set-complement! (->char-set "0123456789"))
             char-set:hex-digit))

(test-equal char-set= (->char-set "abcdefABCDEFghijkl0123456789")
            (char-set-union char-set:hex-digit
                               (->char-set "abcdefghijkl")))
(test-equal char-set= (->char-set "abcdefABCDEFghijkl0123456789")
            (char-set-union! (->char-set "abcdefghijkl")
                                char-set:hex-digit))

(test-equal char-set= (->char-set "ghijklmn")
            (char-set-difference (->char-set "abcdefghijklmn")
                                    char-set:hex-digit))
(test-equal char-set= (->char-set "ghijklmn")
            (char-set-difference! (->char-set "abcdefghijklmn")
                                  char-set:hex-digit))

(test-equal char-set= (->char-set "abcdefABCDEF")
            (char-set-xor (->char-set "0123456789")
                          char-set:hex-digit))
(test-equal char-set= (->char-set "abcdefABCDEF")
            (char-set-xor! (->char-set "0123456789")
                           char-set:hex-digit))

(test-assert
    (call-with-values
        (lambda ()
          (char-set-diff+intersection char-set:hex-digit
                                      char-set:letter))
      (lambda (d i)
        (and (char-set= d (->char-set "0123456789"))
             (char-set= i (->char-set "abcdefABCDEF"))))))

(test-assert
    (call-with-values
        (lambda ()
          (char-set-diff+intersection! (char-set-copy char-set:hex-digit)
                                   (char-set-copy char-set:letter)))
      (lambda (d i)
        (and (char-set= d (->char-set "0123456789"))
             (char-set= i (->char-set "abcdefABCDEF"))))))
