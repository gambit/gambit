;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 13, String Libraries

(import (srfi 13))
(import (_test))

(import (srfi 14))

;; A few gauche constructs used by the tests.

(define (written obj)
  (with-output-to-string (lambda () (write obj))))

(define (call-with-false-on-error thunk)
  (with-exception-catcher
   (lambda (e)
     #f)
   thunk))

;;;============================================================================

;; The rest of this file is the file 13.scm found at
;;
;; https://github.com/srfi-explorations/srfi-test

;;;============================================================================

;; Copyright 2001, 2002, 2011, 2012 Shiro Kawai
;; SPDX-License-Identifier: MIT

(define (fill text)
  (let* ((len (string-length text))
         (max-text-len 60)
         (last-col 70)
         (text (if (> len max-text-len)
                   (begin
                     (set! len max-text-len)
                     (substring text 0 max-text-len))
                   text)))
    (string-append text (make-string (- last-col len) #\.))))

(test-begin "srfi-13")

(test-equal "string-null?" #f (string-null? "abc"))
(test-equal "string-null?" #t (string-null? ""))
(test-equal "string-every" #t (string-every #\a ""))
(test-equal "string-every" #t (string-every #\a "aaaa"))
(test-equal "string-every" #f (string-every #\a "aaba"))
(test-equal "string-every" #t (string-every char-set:lower-case "aaba"))
(test-equal "string-every" #f (string-every char-set:lower-case "aAba"))
(test-equal "string-every" #t (string-every char-set:lower-case ""))
(test-equal "string-every"
  #t (string-every (lambda (x) (char-ci=? x #\a)) "aAaA"))
(test-equal "string-every"
  #f (string-every (lambda (x) (char-ci=? x #\a)) "aAbA"))
(test-equal "string-every" (char->integer #\A)
       (string-every (lambda (x) (char->integer x)) "aAbA"))
(test-equal "string-every" #t
       (string-every (lambda (x) (error "hoge")) ""))
(test-equal "string-any" #t (string-any #\a "aaaa"))
(test-equal "string-any" #f (string-any #\a "Abcd"))
(test-equal "string-any" #f (string-any #\a ""))
(test-equal "string-any" #t (string-any char-set:lower-case "ABcD"))
(test-equal "string-any" #f (string-any char-set:lower-case "ABCD"))
(test-equal "string-any" #f (string-any char-set:lower-case ""))
(test-equal "string-any"
  #t (string-any (lambda (x) (char-ci=? x #\a)) "CAaA"))
(test-equal "string-any"
  #f (string-any (lambda (x) (char-ci=? x #\a)) "ZBRC"))
(test-equal "string-any" #f (string-any (lambda (x) (char-ci=? x #\a)) ""))
(test-equal "string-any" (char->integer #\a)
       (string-any (lambda (x) (char->integer x)) "aAbA"))
(test-equal "string-tabulate" "0123456789"
       (string-tabulate (lambda (code)
                          (integer->char (+ code (char->integer #\0))))
                        10))
(test-equal "string-tabulate" ""
       (string-tabulate (lambda (code)
                          (integer->char (+ code (char->integer #\0))))
                        0))
(test-equal "reverse-list->string" "cBa"
       (reverse-list->string '(#\a #\B #\c)))
(test-equal "reverse-list->string" ""
       (reverse-list->string '()))
; string-join : Gauche builtin.
(test-equal "substring/shared" "cde" (substring/shared "abcde" 2))
(test-equal "substring/shared" "cd"  (substring/shared "abcde" 2 4))
(test-equal "string-copy!" "abCDEfg"
       (let ((x (string-copy "abcdefg")))
         (string-copy! x 2 "CDE")
         x))
(test-equal "string-copy!" "abCDEfg"
       (let ((x (string-copy "abcdefg")))
         (string-copy! x 2 "ZABCDE" 3)
         x))
(test-equal "string-copy!" "abCDEfg"
       (let ((x (string-copy "abcdefg")))
         (string-copy! x 2 "ZABCDEFG" 3 6)
         x))

;; From Guile.  Thanks to Mark H Weaver.
(test-equal "string-copy!: overlapping src and dest, moving right"
      "aabce"
      (let ((str (string-copy "abcde")))
        (string-copy! str 1 str 0 3) str))

(test-equal "string-copy!: overlapping src and dest, moving left"
      "bcdde"
      (let ((str (string-copy "abcde")))
        (string-copy! str 0 str 1 4) str))

(test-equal "string-take" "Pete S"  (string-take "Pete Szilagyi" 6))
(test-equal "string-take" ""        (string-take "Pete Szilagyi" 0))
(test-equal "string-take" "Pete Szilagyi" (string-take "Pete Szilagyi" 13))
(test-equal "string-drop" "zilagyi" (string-drop "Pete Szilagyi" 6))
(test-equal "string-drop" "Pete Szilagyi" (string-drop "Pete Szilagyi" 0))
(test-equal "string-drop" ""        (string-drop "Pete Szilagyi" 13))

(test-equal "string-take-right" "rules" (string-take-right "Beta rules" 5))
(test-equal "string-take-right" ""      (string-take-right "Beta rules" 0))
(test-equal "string-take-right"
  "Beta rules" (string-take-right "Beta rules" 10))
(test-equal "string-drop-right"
  "Beta " (string-drop-right "Beta rules" 5))
(test-equal "string-drop-right"
  "Beta rules" (string-drop-right "Beta rules" 0))
(test-equal "string-drop-right"
  "" (string-drop-right "Beta rules" 10))

(test-equal "string-pad" "  325" (string-pad "325" 5))
(test-equal "string-pad" "71325" (string-pad "71325" 5))
(test-equal "string-pad" "71325" (string-pad "8871325" 5))
(test-equal "string-pad" "~~325" (string-pad "325" 5 #\~))
(test-equal "string-pad" "~~~25" (string-pad "325" 5 #\~ 1))
(test-equal "string-pad" "~~~~2" (string-pad "325" 5 #\~ 1 2))
(test-equal "string-pad-right" "325  " (string-pad-right "325" 5))
(test-equal "string-pad-right" "71325" (string-pad-right "71325" 5))
(test-equal "string-pad-right" "88713" (string-pad-right "8871325" 5))
(test-equal "string-pad-right" "325~~" (string-pad-right "325" 5 #\~))
(test-equal "string-pad-right" "25~~~" (string-pad-right "325" 5 #\~ 1))
(test-equal "string-pad-right" "2~~~~" (string-pad-right "325" 5 #\~ 1 2))

(test-equal "string-trim"  "a b c d  \n"
       (string-trim "  \t  a b c d  \n"))
(test-equal "string-trim"  "\t  a b c d  \n"
       (string-trim "  \t  a b c d  \n" #\space))
(test-equal "string-trim"  "a b c d  \n"
       (string-trim "4358948a b c d  \n" char-set:digit))

(test-equal "string-trim-right"  "  \t  a b c d"
       (string-trim-right "  \t  a b c d  \n"))
(test-equal "string-trim-right"  "  \t  a b c d  "
       (string-trim-right "  \t  a b c d  \n" (char-set #\newline)))
(test-equal "string-trim-right"  "349853a b c d"
       (string-trim-right "349853a b c d03490" char-set:digit))

(test-equal "string-trim-both"  "a b c d"
       (string-trim-both "  \t  a b c d  \n"))
(test-equal "string-trim-both"  "  \t  a b c d  "
       (string-trim-both "  \t  a b c d  \n" (char-set #\newline)))
(test-equal "string-trim-both"  "a b c d"
       (string-trim-both "349853a b c d03490" char-set:digit))

;; string-fill - in string.scm

(test-equal "string-compare" 5
       (string-compare "The cat in the hat" "abcdefgh"
                       values values values
                       4 6 2 4))
(test-equal "string-compare-ci" 5
       (string-compare-ci "The cat in the hat" "ABCDEFGH"
                          values values values
                          4 6 2 4))

;; TODO: bunch of string= families

(test-equal "string-prefix-length" 5
       (string-prefix-length "cancaNCAM" "cancancan"))
(test-equal "string-prefix-length-ci" 8
       (string-prefix-length-ci "cancaNCAM" "cancancan"))
(test-equal "string-suffix-length" 2
       (string-suffix-length "CanCan" "cankancan"))
(test-equal "string-suffix-length-ci" 5
       (string-suffix-length-ci "CanCan" "cankancan"))

(test-equal "string-prefix?" #t    (string-prefix? "abcd" "abcdefg"))
(test-equal "string-prefix?" #f    (string-prefix? "abcf" "abcdefg"))
(test-equal "string-prefix-ci?" #t (string-prefix-ci? "abcd" "aBCDEfg"))
(test-equal "string-prefix-ci?" #f (string-prefix-ci? "abcf" "aBCDEfg"))
(test-equal "string-suffix?" #t    (string-suffix? "defg" "abcdefg"))
(test-equal "string-suffix?" #f    (string-suffix? "aefg" "abcdefg"))
(test-equal "string-suffix-ci?" #t (string-suffix-ci? "defg" "aBCDEfg"))
(test-equal "string-suffix-ci?" #f (string-suffix-ci? "aefg" "aBCDEfg"))

(test-equal "string-index #1" 4
       (string-index "abcd:efgh:ijkl" #\:))
(test-equal "string-index #2" 4
       (string-index "abcd:efgh;ijkl" (char-set-complement char-set:letter)))
(test-equal "string-index #3" #f
       (string-index "abcd:efgh;ijkl" char-set:digit))
(test-equal "string-index #4" 9
       (string-index "abcd:efgh:ijkl" #\: 5))
(test-equal "string-index-right #1" 4
       (string-index-right "abcd:efgh;ijkl" #\:))
(test-equal "string-index-right #2"
  9 (string-index-right "abcd:efgh;ijkl"
                        (char-set-complement char-set:letter)))
(test-equal "string-index-right #3" #f
       (string-index-right "abcd:efgh;ijkl" char-set:digit))
(test-equal "string-index-right #4"
  4 (string-index-right "abcd:efgh;ijkl"
                        (char-set-complement char-set:letter) 2 5))

(test-equal "string-count #1" 2
       (string-count "abc def\tghi jkl" #\space))
(test-equal "string-count #2" 3
       (string-count "abc def\tghi jkl" char-set:whitespace))
(test-equal "string-count #3" 2
       (string-count "abc def\tghi jkl" char-set:whitespace 4))
(test-equal "string-count #4" 1
       (string-count "abc def\tghi jkl" char-set:whitespace 4 9))
(test-equal "string-contains" 3
       (string-contains "Ma mere l'oye" "mer"))
(test-equal "string-contains" #f
       (string-contains "Ma mere l'oye" "Mer"))
(test-equal "string-contains-ci" 3
       (string-contains-ci "Ma mere l'oye" "Mer"))
(test-equal "string-contains-ci" #f
       (string-contains-ci "Ma mere l'oye" "Meer"))

(test-equal "string-titlecase" "--Capitalize This Sentence."
       (string-titlecase "--capitalize tHIS sentence."))
(test-equal "string-titlecase" "3Com Makes Routers."
       (string-titlecase "3com makes routers."))
(test-equal "string-titlecase!" "alSo Whatever"
       (let ((s (string-copy "also whatever")))
         (string-titlecase! s 2 9)
         s))

(test-equal "string-upcase" "SPEAK LOUDLY"
       (string-upcase "speak loudly"))
(test-equal "string-upcase" "PEAK"
       (string-upcase "speak loudly" 1 5))
(test-equal "string-upcase!" "sPEAK loudly"
       (let ((s (string-copy "speak loudly")))
         (string-upcase! s 1 5)
         s))

(test-equal "string-downcase" "speak softly"
       (string-downcase "SPEAK SOFTLY"))
(test-equal "string-downcase" "peak"
       (string-downcase "SPEAK SOFTLY" 1 5))
(test-equal "string-downcase!" "Speak SOFTLY"
       (let ((s (string-copy "SPEAK SOFTLY")))
         (string-downcase! s 1 5)
         s))

(test-equal "string-reverse" "nomel on nolem on"
       (string-reverse "no melon no lemon"))
(test-equal "string-reverse" "nomel on"
       (string-reverse "no melon no lemon" 9))
(test-equal "string-reverse" "on"
       (string-reverse "no melon no lemon" 9 11))
(test-equal "string-reverse!" "nomel on nolem on"
       (let ((s (string-copy "no melon no lemon")))
         (string-reverse! s) s))
(test-equal "string-reverse!" "no melon nomel on"
       (let ((s (string-copy "no melon no lemon")))
         (string-reverse! s 9) s))
(test-equal "string-reverse!" "no melon on lemon"
       (let ((s (string-copy "no melon no lemon")))
         (string-reverse! s 9 11) s))

(test-equal "string-append" #f
       (let ((s "test")) (eq? s (string-append s))))
(test-equal "string-concatenate" #f
       (let ((s "test")) (eq? s (string-concatenate (list s)))))
(test-equal "string-concatenate"
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  (string-concatenate
   '("A" "B" "C" "D" "E" "F" "G" "H"
     "I" "J" "K" "L" "M" "N" "O" "P"
     "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
     "a" "b" "c" "d" "e" "f" "g" "h"
     "i" "j" "k" "l" "m" "n" "o" "p"
     "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")))
(test-equal "string-concatenate/shared"
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  (string-concatenate/shared
   '("A" "B" "C" "D" "E" "F" "G" "H"
     "I" "J" "K" "L" "M" "N" "O" "P"
     "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
     "a" "b" "c" "d" "e" "f" "g" "h"
     "i" "j" "k" "l" "m" "n" "o" "p"
     "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")))
(test-equal "string-concatenate-reverse"
  "zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA"
  (string-concatenate-reverse
   '("A" "B" "C" "D" "E" "F" "G" "H"
     "I" "J" "K" "L" "M" "N" "O" "P"
     "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
     "a" "b" "c" "d" "e" "f" "g" "h"
     "i" "j" "k" "l" "m" "n" "o" "p"
     "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")))
(test-equal "string-concatenate-reverse" #f
       (let ((s "test"))
         (eq? s (string-concatenate-reverse (list s)))))
(test-equal "string-concatenate-reverse/shared"
  "zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA"
  (string-concatenate-reverse/shared
   '("A" "B" "C" "D" "E" "F" "G" "H"
     "I" "J" "K" "L" "M" "N" "O" "P"
     "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
     "a" "b" "c" "d" "e" "f" "g" "h"
     "i" "j" "k" "l" "m" "n" "o" "p"
     "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")))

(test-equal "string-map" "svool"
       (string-map (lambda (c)
                     (integer->char (- 219 (char->integer c))))
                   "hello"))
(test-equal "string-map" "vool"
       (string-map (lambda (c)
                     (integer->char (- 219 (char->integer c))))
                   "hello" 1))
(test-equal "string-map" "vo"
       (string-map (lambda (c)
                     (integer->char (- 219 (char->integer c))))
                   "hello" 1 3))
(test-equal "string-map!" "svool"
       (let ((s (string-copy "hello")))
         (string-map! (lambda (c)
                        (integer->char (- 219 (char->integer c))))
                      s)
         s))
(test-equal "string-map!" "hvool"
       (let ((s (string-copy "hello")))
         (string-map! (lambda (c)
                        (integer->char (- 219 (char->integer c))))
                      s 1)
         s))
(test-equal "string-map!" "hvolo"
       (let ((s (string-copy "hello")))
         (string-map! (lambda (c)
                        (integer->char (- 219 (char->integer c))))
                      s 1 3)
         s))

(test-equal "string-fold" '(#\o #\l #\l #\e #\h . #t)
       (string-fold cons #t "hello"))
(test-equal "string-fold" '(#\l #\e . #t)
       (string-fold cons #t "hello" 1 3))
(test-equal "string-fold-right" '(#\h #\e #\l #\l #\o . #t)
       (string-fold-right cons #t "hello"))
(test-equal "string-fold-right" '(#\e #\l . #t)
       (string-fold-right cons #t "hello" 1 3))

(test-equal "string-unfold" "hello"
       (string-unfold null? car cdr '(#\h #\e #\l #\l #\o)))
(test-equal "string-unfold" "hi hello"
       (string-unfold null? car cdr '(#\h #\e #\l #\l #\o) "hi "))
(test-equal "string-unfold" "hi hello ho"
       (string-unfold null? car cdr
                      '(#\h #\e #\l #\l #\o) "hi "
                      (lambda (x) " ho")))

(test-equal "string-unfold-right" "olleh"
       (string-unfold-right null? car cdr '(#\h #\e #\l #\l #\o)))
(test-equal "string-unfold-right" "olleh hi"
       (string-unfold-right null? car cdr '(#\h #\e #\l #\l #\o) " hi"))
(test-equal "string-unfold-right" "ho olleh hi"
       (string-unfold-right null? car cdr
                            '(#\h #\e #\l #\l #\o) " hi"
                            (lambda (x) "ho ")))

(test-equal "string-for-each" "CLtL"
       (let ((out (open-output-string))
             (prev #f))
         (string-for-each (lambda (c)
                            (if (or (not prev)
                                    (char-whitespace? prev))
                                (write-char c out))
                            (set! prev c))
                          "Common Lisp, the Language")

         (get-output-string out)))
(test-equal "string-for-each" "oLtL"
       (let ((out (open-output-string))
             (prev #f))
         (string-for-each (lambda (c)
                            (if (or (not prev)
                                    (char-whitespace? prev))
                                (write-char c out))
                            (set! prev c))
                          "Common Lisp, the Language" 1)
         (get-output-string out)))
(test-equal "string-for-each" "oL"
       (let ((out (open-output-string))
             (prev #f))
         (string-for-each (lambda (c)
                            (if (or (not prev)
                                    (char-whitespace? prev))
                                (write-char c out))
                            (set! prev c))
                          "Common Lisp, the Language" 1 10)
         (get-output-string out)))
(test-equal "string-for-each-index" '(4 3 2 1 0)
       (let ((r '()))
         (string-for-each-index (lambda (i) (set! r (cons i r))) "hello")
         r))
(test-equal "string-for-each-index" '(4 3 2 1)
       (let ((r '()))
         (string-for-each-index (lambda (i) (set! r (cons i r))) "hello" 1)
         r))
(test-equal "string-for-each-index" '(2 1)
       (let ((r '()))
         (string-for-each-index (lambda (i) (set! r (cons i r))) "hello" 1 3)
         r))

(test-equal "xsubstring" "cdefab"
       (xsubstring "abcdef" 2))
(test-equal "xsubstring" "efabcd"
       (xsubstring "abcdef" -2))
(test-equal "xsubstring" "abcabca"
       (xsubstring "abc" 0 7))
;; (test-equal "xsubstring" "abcabca"
;;        (xsubstring "abc"
;;                    30000000000000000000000000000000
;;                    30000000000000000000000000000007))
(test-equal "xsubstring" "defdefd"
       (xsubstring "abcdefg" 0 7 3 6))
(test-equal "xsubstring" ""
       (xsubstring "abcdefg" 9 9 3 6))

(test-equal "string-xcopy!" "ZZcdefabZZ"
       (let ((s (make-string 10 #\Z)))
         (string-xcopy! s 2 "abcdef" 2)
         s))
(test-equal "string-xcopy!" "ZZdefdefZZ"
       (let ((s (make-string 10 #\Z)))
         (string-xcopy! s 2 "abcdef" 0 6 3)
         s))

(test-equal "string-replace" "abcdXYZghi"
       (string-replace "abcdefghi" "XYZ" 4 6))
(test-equal "string-replace" "abcdZghi"
       (string-replace "abcdefghi" "XYZ" 4 6 2))
(test-equal "string-replace" "abcdZefghi"
       (string-replace "abcdefghi" "XYZ" 4 4 2))
(test-equal "string-replace" "abcdefghi"
       (string-replace "abcdefghi" "XYZ" 4 4 1 1))
(test-equal "string-replace" "abcdhi"
       (string-replace "abcdefghi" "" 4 7))

(test-equal "string-tokenize" '("Help" "make" "programs" "run," "run," "RUN!")
       (string-tokenize "Help make programs run, run, RUN!"))
(test-equal "string-tokenize" '("Help" "make" "programs" "run" "run" "RUN")
       (string-tokenize "Help make programs run, run, RUN!"
                        char-set:letter))
(test-equal "string-tokenize" '("programs" "run" "run" "RUN")
       (string-tokenize "Help make programs run, run, RUN!"
                        char-set:letter 10))
(test-equal "string-tokenize" '("elp" "make" "programs" "run" "run")
       (string-tokenize "Help make programs run, run, RUN!"
                        char-set:lower-case))

(test-equal "string-filter" "rrrr"
       (string-filter #\r "Help make programs run, run, RUN!"))
(test-equal "string-filter" "HelpmakeprogramsrunrunRUN"
       (string-filter char-set:letter "Help make programs run, run, RUN!"))

(test-equal "string-filter" "programsrunrun"
       (string-filter (lambda (c) (char-lower-case? c))
                      "Help make programs run, run, RUN!"
                      10))
(test-equal "string-filter" ""
       (string-filter (lambda (c) (char-lower-case? c)) ""))
(test-equal "string-delete" "Help make pogams un, un, RUN!"
       (string-delete #\r "Help make programs run, run, RUN!"))
(test-equal "string-delete" "   , , !"
       (string-delete char-set:letter "Help make programs run, run, RUN!"))
(test-equal "string-delete" " , , RUN!"
       (string-delete (lambda (c) (char-lower-case? c))
                      "Help make programs run, run, RUN!"
                      10))
(test-equal "string-delete" ""
       (string-delete (lambda (c) (char-lower-case? c)) ""))

;;; Additional tests so that the suite at least touches all
;;; the functions.

(test-equal "string-hash" #t (<= 0 (string-hash "abracadabra" 20) 19))

(test-equal "string-hash"
  #t (= (string-hash "abracadabra" 20) (string-hash "abracadabra" 20)))

(test-equal "string-hash" #t (= (string-hash "abracadabra" 20 2 7)
                          (string-hash (substring "abracadabra" 2 7) 20)))

(test-equal "string-hash-ci" #t (= (string-hash-ci "aBrAcAdAbRa" 20)
                             (string-hash-ci "AbRaCaDaBrA" 20)))

(test-equal "string-hash-ci"
  #t (= (string-hash-ci "aBrAcAdAbRa" 20 2 7)
        (string-hash-ci (substring "AbRaCaDaBrA" 2 7) 20)))

(test-equal "string=" #t (string= "foo" "foo"))
(test-equal "string=" #t (string= "foobar" "foo" 0 3))
(test-equal "string=" #t (string= "foobar" "barfoo" 0 3 3))
(test-equal "string=" #t (not (string= "foobar" "barfoo" 0 3 2 5)))

(test-equal "string<>" #t (string<> "flo" "foo"))
(test-equal "string<>" #t (string<> "flobar" "foo" 0 3))
(test-equal "string<>" #t (string<> "flobar" "barfoo" 0 3 3))
(test-equal "string<>" #t (not (string<> "foobar" "foobar" 0 3 0 3)))

(test-equal "string<=" #t (string<= "fol" "foo"))
(test-equal "string<=" #t (string<= "folbar" "foo" 0 3))
(test-equal "string<=" #t (string<= "foobar" "barfoo" 0 3 3))
(test-equal "string<=" #f (string<= "foobar" "barfoo" 0 3 1 4))

(test-equal "string<" #t (string< "fol" "foo"))
(test-equal "string<" #t (string< "folbar" "foo" 0 3))
(test-equal "string<" #t (string< "folbar" "barfoo" 0 3 3))
(test-equal "string<" #t (not (string< "foobar" "barfoo" 0 3 1 4)))

(test-equal "string>=" #t (string>= "foo" "fol"))
(test-equal "string>=" #t (string>= "foo" "folbar" 0 3 0 3))
(test-equal "string>=" #t (string>= "barfoo" "foo" 3 6 0))
(test-equal "string>=" #t (not (string>= "barfoo" "foobar" 1 4 0 3)))

(test-equal "string>" #t (string> "foo" "fol"))
(test-equal "string>" #t (string> "foo" "folbar" 0 3 0 3))
(test-equal "string>" #t (string> "barfoo" "fol" 3 6 0))
(test-equal "string>" #t (not (string> "barfoo" "foobar" 1 4 0 3)))

(test-equal "string-ci=" #t (string-ci= "Foo" "foO"))
(test-equal "string-ci=" #t (string-ci= "Foobar" "fOo" 0 3))
(test-equal "string-ci=" #t (string-ci= "Foobar" "bArfOo" 0 3 3))
(test-equal "string-ci=" #t (not (string-ci= "foobar" "BARFOO" 0 3 2 5)))

(test-equal "string-ci<>" #t (string-ci<> "flo" "FOO"))
(test-equal "string-ci<>" #t (string-ci<> "FLOBAR" "foo" 0 3))
(test-equal "string-ci<>" #t (string-ci<> "flobar" "BARFOO" 0 3 3))
(test-equal "string-ci<>" #t (not (string-ci<> "foobar" "FOOBAR" 0 3 0 3)))

(test-equal "string-ci<=" #t (string-ci<= "FOL" "foo"))
(test-equal "string-ci<=" #t (string-ci<= "folBAR" "fOO" 0 3))
(test-equal "string-ci<=" #t (string-ci<= "fOOBAR" "BARFOO" 0 3 3))
(test-equal "string-ci<=" #t (not (string-ci<= "foobar" "BARFOO" 0 3 1 4)))

(test-equal "string-ci<" #t (string-ci< "fol" "FOO"))
(test-equal "string-ci<" #t (string-ci< "folbar" "FOO" 0 3))
(test-equal "string-ci<" #t (string-ci< "folbar" "BARFOO" 0 3 3))
(test-equal "string-ci<" #t (not (string-ci< "foobar" "BARFOO" 0 3 1 4)))

(test-equal "string-ci>=" #t (string-ci>= "FOO" "fol"))
(test-equal "string-ci>=" #t (string-ci>= "foo" "FOLBAR" 0 3 0 3))
(test-equal "string-ci>=" #t (string-ci>= "BARFOO" "foo" 3 6 0))
(test-equal "string-ci>=" #t (not (string-ci>= "barfoo" "FOOBAR" 1 4 0 3)))

(test-equal "string-ci>" #t (string-ci> "FOO" "fol"))
(test-equal "string-ci>" #t (string-ci> "foo" "FOLBAR" 0 3 0 3))
(test-equal "string-ci>" #t (string-ci> "barfoo" "FOL" 3 6 0))
(test-equal "string-ci>" #t (not (string-ci> "barfoo" "FOOBAR" 1 4 0 3)))

(test-equal "string=?"
  #t (string=? "abcd" (string-append/shared "a" "b" "c" "d")))

(test-equal "string-parse-start+end"
  #t
  (let-values (((rest start end)
                (string-parse-start+end #t "foo" '(1 3 fnord))))
    (and (= start 1)
         (= end 3)
         (equal? rest '(fnord)))))

(test-error "string-parse-start+end" #t
            (string-parse-start+end #t "foo" '(1 4)))

(test-equal "string-parse-start+end"
  #t
  (let-values (((start end)
                (string-parse-final-start+end #t "foo" '(1 3))))
    (and (= start 1)
         (= end 3))))

(test-equal "string-parse-start+end"
      #t
      (let-string-start+end (start end rest) #t "foo" '(1 3 fnord)
                            (and (= start 1)
                                 (= end 3)
                                 (equal? rest '(fnord)))))

(test-assert "check-substring-spec" (check-substring-spec #t "foo" 1 3))

(test-error "check-substring-spec" #t (check-substring-spec #t "foo" 1 4))

(test-assert "substring-spec-ok?" (substring-spec-ok? "foo" 1 3))

(test-assert "substring-spec-ok?" (not (substring-spec-ok? "foo" 1 4)))

(test-equal "make-kmp-restart-vector" '#() (make-kmp-restart-vector ""))

(test-equal "make-kmp-restart-vector" '#(-1) (make-kmp-restart-vector "a"))

(test-equal "make-kmp-restart-vector" '#(-1 0) (make-kmp-restart-vector "ab"))

; The following is from an example in the code.  It is the "optimised"
; version; it's also valid to return #(-1 0 0 0 1 2), but that will
; needlessly check the "a" twice before giving up.
(test-equal "make-kmp-restart-vector"
      '#(-1 0 0 -1 1 2)
      (make-kmp-restart-vector "abdabx"))

;; Each entry in kmp-cases is a pattern, a string to match against and
;; the expected run of the algorithm through the positions in the
;; pattern.  So for example 0 1 2 means it looks at position 0 first,
;; then at 1 and then at 2.
;;
;; This is easy to verify in simple cases; If there's a shared
;; substring and matching fails, you try matching again starting at
;; the end of the shared substring, otherwise you rewind.  For more
;; complex cases, it's increasingly difficult for humans to verify :)
(define kmp-cases
  '(("abc" "xx" #f 0 0)
    ("abc" "abc" #t 0 1 2)
    ("abcd" "abc" #f 0 1 2)
    ("abc" "abcd" #t 0 1 2)
    ("abc" "aabc" #t 0 1 1 2)
    ("ab" "aa" #f 0 1)
    ("ab" "aab" #t 0 1 1)
    ("abdabx" "abdbbabda" #f 0 1 2 3 0 0 1 2 3)
    ("aabc" "axaabc" #t 0 1 0 1 2 3)
    ("aabac" "aabaabac" #t 0 1 2 3 4 2 3 4)))

(for-each
 (lambda (test-case)
   (let* ((pat (car test-case))
          (n (string-length pat))
          (str (cadr test-case))
          (match? (car (cddr test-case)))
          (steps (cdr (cddr test-case)))
          (rv (make-kmp-restart-vector pat)))
     (let ((p (open-input-string str)))
       (let lp ((i 0)
                (step 0)
                (steps steps))
         (cond
           ((or (= i n) (eof-object? (peek-char p)))
            (test-assert (string-append "KMP match? " (written match?)
                                        ", case: " (written test-case))
              (eq? (= i n) match?))
            (test-assert (string-append "KMP empty remaining steps: "
                                        (written steps)
                                        ", case: " (written test-case))
                         (null? steps)))
           (else
            (let ((new-i (kmp-step pat rv (read-char p) i char=? 0))
                  (expected-i (and (not (null? steps)) (car steps))))
              (test-equal (string-append "KMP step " (written step)
                                         " (exp: " (written expected-i)
                                         ", act: " (written i)
                                         "), case: " (written test-case))
                expected-i i)
              (lp new-i (+ step 1) (cdr steps)))))))))
 kmp-cases)

; FIXME!  Implement tests for these:
;   string-kmp-partial-search
;   kmp-step


;;; Regression tests: check that reported bugs have been fixed

; From: Matthias Radestock <matthias@sorted.org>
; Date: Wed, 10 Dec 2003 21:05:22 +0100
;
; Chris Double has found the following bug in the reference implementation:
;
;  (string-contains "xabc" "ab") => 1    ;good
;  (string-contains "aabc" "ab") => #f   ;bad
;
; Matthias.

(test-equal "string-contains" 1 (string-contains "aabc" "ab"))

(test-equal "string-contains" 5 (string-contains "ababdabdabxxas" "abdabx"))

(test-equal "string-contains-ci" 1 (string-contains-ci "aabc" "ab"))

; (message continues)
;
; PS: There is also an off-by-one error in the bounds check of the
; unoptimized version of string-contains that is included as commented out
; code in the reference implementation. This breaks things like
; (string-contains "xab" "ab") and (string-contains "ab" "ab").

; This off-by-one bug has been fixed in the comments of the version
; of SRFI-13 shipped with Larceny.  In a version of the code without
; the fix the following test will catch the bug:

(test-equal "string-contains" 0 (string-contains "ab" "ab"))

; From: dvanhorn@emba.uvm.edu
; Date: Wed, 26 Mar 2003 08:46:41 +0100
;
; The SRFI document gives,
;
;   string-filter s char/char-set/pred [start end] -> string
;   string-delete s char/char-set/pred [start end] -> string
;
; Yet the reference implementation switches the order giving,
;
;   ;;; string-delete char/char-set/pred string [start end]
;   ;;; string-filter char/char-set/pred string [start end]
;   ...
;   (define (string-delete criterion s . maybe-start+end)
;   ...
;   (define (string-filter criterion s . maybe-start+end)
;
; I reviewed the SRFI-13 mailing list and c.l.scheme, but found no mention of
; this issue.  Apologies if I've missed something.

(test-assert "string=? + string-filter"
  (call-with-false-on-error
   (lambda () (string=? "ADR"
                        (string-filter char-set:upper-case "abrAcaDabRa")))))

(test-assert "string=? + string-delete"
  (call-with-false-on-error
   (lambda () (string=? "abrcaaba"
                        (string-delete char-set:upper-case "abrAcaDabRa")))))


; http://srfi.schemers.org/srfi-13/post-mail-archive/msg00007.html
; From: David Van Horn <address@hidden>
; Date: Wed, 01 Nov 2006 07:53:34 +0100
;
; Both string-index-right and string-skip-right will continue to search
; left past a given start index.
;
;    (string-index-right "abbb" #\a 1) ;; => 0, but should be #f
;    (string-skip-right  "abbb" #\b 1) ;; => 0, but should be #f
;
; This also causes incorrect results for string-trim-right,
; string-trim-both and string-tokenize when given a non-zero start
; argument.

(test-equal "string-index-right" #f (string-index-right "abbb" #\a 1))
(test-equal "string-skip-right" #f (string-skip-right  "abbb" #\b 1))

;; Tests to check the string-trim-right issue found by Seth Alves
;; http://lists.gnu.org/archive/html/chicken-hackers/2014-01/msg00016.html

(test-equal "string-trim-right"
  "" (string-trim-right "" char-whitespace? 0 0))

(test-equal "string-trim-right"
  "" (string-trim-right "a" char-whitespace? 0 0))

(test-equal "string-trim-right"
  "" (string-trim-right "a " char-whitespace? 0 0))

(test-equal "string-trim-right"
  "bc" (string-trim-right "abc   " char-whitespace? 1))

(test-equal "string-trim-right"
  "" (string-trim-right "abc   " char-whitespace? 4 4))

(test-end "srfi-13")
