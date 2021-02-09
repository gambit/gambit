;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;============================================================================

;;; SRFI 60, Integers as Bits

(import (srfi 60))
(import (_test))

;;;============================================================================

(define-macro
  (test-number-args proc m- m+)
    (let* ((z?   (zero? m-))
           (args (iota (if z? (+ m+ 1) (- m- 1)))))
        `(begin
           (test-error-tail
             wrong-number-of-arguments-exception?
             (,proc ,@args))
           ,(if (or z? (zero? m+))
                    '#f
                   `(test-number-args ,proc 0 ,m+)))))

(define-macro
  (test-aux test-type)
    (let* ((test-type (symbol->string test-type))
           (test-name (string->symbol
                       (string-append
                         "test-" test-type )))
           (exception-type (string->symbol
                             (string-append
                               test-type "-exception?"))))
      `(define-syntax ,test-name
         (syntax-rules ()
           ((,test-name proc (arg00 arg01 ...)
                             (arg10 arg11 ...)
                             ...)
            (begin
              (test-error
                ,exception-type
                (proc arg00 arg01 ...))
              (test-error
                ,exception-type
                (proc arg10 arg11 ...))
              ...))
           ((,test-name proc arg0 ...)
            (test-error
              ,exception-type
              (proc arg0 ...)))))))

(test-aux type)
(test-aux range)

(define-syntax test-exception
  (syntax-rules (type: range: args:)
    ((test-exception proc)
     #f)
    ((test-exception proc (type: t0 t1 ...) tst2 ...)
     (begin
       (test-type proc t0 t1 ...)
       (test-exception proc tst2 ...)))
    ((test-exception proc (range: r0 r1 ...) tst2 ...)
     (begin
       (test-range proc r0 r1 ...)
       (test-exception proc tst2 ...)))
    ((test-exception proc (args: a0 a1) tst2 ...)
     (begin
       (test-number-args proc a0 a1)
       (test-exception proc tst2 ...)))))

(define-macro (test-bits res op . args)
  `(test-assert (string=? (number->string (,op ,@args) 2)
                          ,res)))

;;============================================================================
;; bitwise-and


(test-bits "10000" bitwise-and #b10100 #b10010)
(test-bits "0"     bitwise-and #b0011 #b1100)
(test-bits "1"     bitwise-and #b1 #b1 #b1 #b1)
(test-bits "0"     bitwise-and #b1 #b1 #b0 #b1)

(test-exception bitwise-and
                (type: (+ 0 0) (0 + 0) (0 0 +)))

(test-bits "10000" logand #b10100 #b10010)
(test-bits "0"     logand #b0011 #b1100)
(test-bits "1"     logand #b1 #b1 #b1 #b1)
(test-bits "0"     logand #b1 #b1 #b0 #b1)

(test-exception logand
                (type: (+ 0 0) (0 + 0) (0 0 +)))


;;============================================================================
;; bitwise-ior


(test-bits "1010" bitwise-ior #b1000 #b0010)
(test-bits "1111" bitwise-ior #b0011 #b1100)
(test-bits "0"    bitwise-ior #b0 #b0 #b0 #b0)
(test-bits "1"    bitwise-ior #b0 #b0 #b0 #b1)

(test-exception bitwise-ior
                (type: (+ 0 0) (0 + 0) (0 0 +)))

(test-bits "1010" logior #b1000 #b0010)
(test-bits "1111" logior #b0011 #b1100)
(test-bits "0"    logior #b0 #b0 #b0 #b0)
(test-bits "1"    logior #b0 #b0 #b0 #b1)

(test-exception logior
                (type: (+ 0 0) (0 + 0) (0 0 +)))



;;============================================================================
;; bitwise-xor


(test-bits "1010" bitwise-xor #b1000 #b0010)
(test-bits "1001" bitwise-xor #b0111 #b1110)
(test-bits "0"    bitwise-xor #b0 #b0 #b0 #b0)
(test-bits "1"    bitwise-xor #b1 #b1 #b0 #b1)

(test-exception bitwise-xor
                (type: (+ 0 0) (0 + 0) (0 0 +)))

(test-bits "1010" logxor #b1000 #b0010)
(test-bits "1001" logxor #b0111 #b1110)
(test-bits "0"    logxor #b0 #b0 #b0 #b0)
(test-bits "1"    logxor #b1 #b1 #b0 #b1)

(test-exception logxor
                (type: (+ 0 0) (0 + 0) (0 0 +)))



;;============================================================================
;; bitwise-not (1-complement)

(test-assert (= -1  (bitwise-not #b0000)))
(test-assert (= -2  (bitwise-not #b0001)))
(test-assert (= -14 (bitwise-not #b1101)))

(test-exception bitwise-not
                (type: +)
                (args: 0 2))

(test-assert (= -1  (lognot #b0000)))
(test-assert (= -2  (lognot #b0001)))
(test-assert (= -14 (lognot #b1101)))

(test-exception lognot
                (type: +)
                (args: 0 2))



;;============================================================================
;; bitwise-merge
(test-bits "1010" bitwise-merge #b0000 #b0101 #b1010)
(test-bits  "101" bitwise-merge #b1111 #b0101 #b1010)
(test-bits "1010" bitwise-merge #b0101 #b0000 #b1111)

(test-exception bitwise-merge
                (type: (+ 0 0) (0 + 0) (0 0 +))
                (args: 2 4))

(test-bits "1010" bitwise-if #b0000 #b0101 #b1010)
(test-bits  "101" bitwise-if #b1111 #b0101 #b1010)
(test-bits "1010" bitwise-if #b0101 #b0000 #b1111)

(test-exception bitwise-if
                (type: (+ 0 0) (0 + 0) (0 0 +))
                (args: 2 4))

;;============================================================================
;; any-bits-set?

(test-assert (any-bits-set? #b1000 #b1111))
(test-assert (not (any-bits-set? #b0000 #b0000)))
(test-assert (not (any-bits-set? #b0010 #b1101)))

(test-exception any-bits-set?
                (type: (+ 0) (0 +))
                (args: 1 3))

(test-assert (logtest #b1000 #b1111))
(test-assert (not (logtest #b0000 #b0000)))
(test-assert (not (logtest #b0010 #b1101)))

(test-exception logtest
                (type: (+ 0) (0 +))
                (args: 1 3))


;;============================================================================
;; bit-count

(test-assert (= (bit-count #b1000) 1))
(test-assert (= (bit-count #b1011) 3))
(test-assert (= (bit-count (- #b1000)) 3))
(test-assert (= (bit-count 0) 0))

(test-exception bit-count
                (type: +)
                (args: 0 -1))

(test-assert (= (logcount #b1000) 1))
(test-assert (= (logcount #b1011) 3))
(test-assert (= (logcount (- #b1000)) 3))
(test-assert (= (logcount 0) 0))

(test-exception logcount
                (type: +)
                (args: 0 -1))


;;============================================================================
;; integer-length

(test-assert (= (integer-length #b1000) 4))
(test-assert (= (integer-length #b1011) 4))
(test-assert (= (integer-length (- #b1000)) 3))
(test-assert (= (integer-length 0) 0))
(test-assert (= (integer-length #b10000000000) 11)) 

(test-exception integer-length
                (type: +)
                (args: 0 -1))


;;============================================================================
;; first-set-bit

(test-assert (= (first-set-bit  0)  -1))
(test-assert (= (first-set-bit  -1) 0))
(test-assert (= (first-set-bit  1) 0))
(test-assert (= (first-set-bit  -2) 1))
(test-assert (= (first-set-bit  2) 1))
(test-assert (= (first-set-bit  -3) 0))
(test-assert (= (first-set-bit  3) 0))
(test-assert (= (first-set-bit  -4) 2))
(test-assert (= (first-set-bit  4) 2))
(test-assert (= (first-set-bit  -5) 0))
(test-assert (= (first-set-bit  5) 0))
(test-assert (= (first-set-bit  -6) 1))
(test-assert (= (first-set-bit  6) 1))
(test-assert (= (first-set-bit  -7) 0))
(test-assert (= (first-set-bit  7) 0))
(test-assert (= (first-set-bit  -8) 3))
(test-assert (= (first-set-bit  8) 3))
(test-assert (= (first-set-bit  -9) 0))
(test-assert (= (first-set-bit  9) 0))
(test-assert (= (first-set-bit -10) 1))
(test-assert (= (first-set-bit 10) 1))
(test-assert (= (first-set-bit -11) 0))
(test-assert (= (first-set-bit 11) 0))
(test-assert (= (first-set-bit -12) 2))
(test-assert (= (first-set-bit 12) 2))
(test-assert (= (first-set-bit -13) 0))
(test-assert (= (first-set-bit 13) 0))
(test-assert (= (first-set-bit -14) 1))
(test-assert (= (first-set-bit 14) 1))
(test-assert (= (first-set-bit -15) 0))
(test-assert (= (first-set-bit 15) 0))
(test-assert (= (first-set-bit -16) 4))
(test-assert (= (first-set-bit 16) 4))


(test-exception first-set-bit
                (type: +)
                (args: 0 -1))

(test-assert (= (log2-binary-factors  0)  -1))
(test-assert (= (log2-binary-factors  -1) 0))
(test-assert (= (log2-binary-factors  1) 0))
(test-assert (= (log2-binary-factors  -2) 1))
(test-assert (= (log2-binary-factors  2) 1))
(test-assert (= (log2-binary-factors  -3) 0))
(test-assert (= (log2-binary-factors  3) 0))
(test-assert (= (log2-binary-factors  -4) 2))
(test-assert (= (log2-binary-factors  4) 2))
(test-assert (= (log2-binary-factors  -5) 0))
(test-assert (= (log2-binary-factors  5) 0))
(test-assert (= (log2-binary-factors  -6) 1))
(test-assert (= (log2-binary-factors  6) 1))
(test-assert (= (log2-binary-factors  -7) 0))
(test-assert (= (log2-binary-factors  7) 0))
(test-assert (= (log2-binary-factors  -8) 3))
(test-assert (= (log2-binary-factors  8) 3))
(test-assert (= (log2-binary-factors  -9) 0))
(test-assert (= (log2-binary-factors  9) 0))
(test-assert (= (log2-binary-factors -10) 1))
(test-assert (= (log2-binary-factors 10) 1))
(test-assert (= (log2-binary-factors -11) 0))
(test-assert (= (log2-binary-factors 11) 0))
(test-assert (= (log2-binary-factors -12) 2))
(test-assert (= (log2-binary-factors 12) 2))
(test-assert (= (log2-binary-factors -13) 0))
(test-assert (= (log2-binary-factors 13) 0))
(test-assert (= (log2-binary-factors -14) 1))
(test-assert (= (log2-binary-factors 14) 1))
(test-assert (= (log2-binary-factors -15) 0))
(test-assert (= (log2-binary-factors 15) 0))
(test-assert (= (log2-binary-factors -16) 4))
(test-assert (= (log2-binary-factors 16) 4))


(test-exception log2-binary-factors
                (type: +)
                (args: 0 -1))



;;============================================================================
;; bit-set? 


(test-assert      (bit-set? 0 #b0101))
(test-assert (not (bit-set? 1 #b0101)))
(test-assert      (bit-set? 2 #b0101))
(test-assert (not (bit-set? 3 #b0101)))
(test-assert      (bit-set? 35 (- 3)))
(test-assert (not (bit-set? 35 3)))

(test-exception bit-set?
                (type: (+ 0) (0 +))
                (range: (-1 35))
                (args: 1 3))

(test-assert      (logbit? 0 #b0101))
(test-assert (not (logbit? 1 #b0101)))
(test-assert      (logbit? 2 #b0101))
(test-assert (not (logbit? 3 #b0101)))
(test-assert      (logbit? 35 (- 3)))
(test-assert (not (logbit? 35 3)))

(test-exception logbit?
                (type: (+ 0) (0 +))
                (range: (-1 35))
                (args: 1 3))

;;============================================================================
;; copy-bit

(test-bits "1"    copy-bit 0 #b0    #t)
(test-bits "100"  copy-bit 2 #b0    #t)
(test-bits "1101" copy-bit 1 #b1111 #f)

(test-exception copy-bit
                (type: (+ 0 #t) (0 + #t) (0 0 +))
                (range: (-1 0 #t))
                (args: 3 -1))
                
;;===========================================================================
;; bit-field


(test-bits "1010"  bit-field    #b1101101010  0 4)
(test-bits "10110" bit-field    #b1101101010  4 9)
(test-bits "1"     bit-field    #b1101101010  9 13)
(test-bits "1110"  bit-field (- #b1101101010) 9 13)


(test-exception bit-field
                (type: (+ 0 0) (0 + 0) (0 0 +))
                (range: (35 -1 35))
                (args: 2 4))

;;============================================================================
;; copy-bit-field

(test-bits "1101100000"     copy-bit-field #b1101101010      0 0 4)
(test-bits "1101101111"     copy-bit-field #b1101101010     -1 0 4)
(test-bits "10100111110000" copy-bit-field #b10100100010000 -1 5 9)

(test-exception copy-bit-field
                (type: (+ 0 0 0) (0 + 0 0) (0 0 + 0) (0 0 0 +))
                (range: (0 0 -1 0) (0 0 0 -1) (0 0 2 1))
                (args: 3 5))


;;============================================================================
;; arithmetic-shift (built-in)

(test-bits "1000" arithmetic-shift #b1    3)
(test-bits "101"  arithmetic-shift #b1010 -1)

(test-exception arithmetic-shift
                (type: (+ 0) (0 +))
                (args: 1 3))

(test-bits "1000" ash #b1    3)
(test-bits "101"  ash #b1010 -1)

(test-exception ash
                (type: (+ 0) (0 +))
                (args: 1 3))


;;============================================================================
;; rotate-bit-field

(test-bits "10" rotate-bit-field #b0100 3 0 4)
(test-bits "10" rotate-bit-field #b0100 -1 0 4)
(test-bits "110100010010000" rotate-bit-field #b110100100010000 -1 5 9)
(test-bits "110100000110000" rotate-bit-field #b110100100010000  1 5 9)

(test-exception rotate-bit-field
                (type: (+ 0 0 0) (0 + 0 0) (0 0 + 0) (0 0 0 +))
                (range: (0 0 -1 0) (0 0 0 -1) (0 0 2 1))
                (args: 3 5))

;;============================================================================
;; reverse-bit-field



(test-bits "101" reverse-bit-field #b1010 0 4)
(test-assert (string=? (number->string (reverse-bit-field #xA7 0 8) 16)
                      "e5"))

(test-exception reverse-bit-field
                (type: (+ 0 0) (0 + 0) (0 0 +))
                (range: (0 -1 0) (0 0 -1) (0 2 1))
                (args: 2 4))


;;============================================================================
;; integer->list

(test-assert (equal? '(#t #t)    (integer->list #b011)))
(test-assert (equal? '(#t #f #t) (integer->list #b101)))

(test-exception integer->list
                (type: +)
                (range: (0 -1))
                (args: 0 2))

;;============================================================================
;; list->integer

(test-assert (= (list->integer '(#t #f #f #t)) #b1001))
(test-assert (= (list->integer '(#t #f #f #t)) #b1001))
(test-assert (= (list->integer '(#f #t #f #f #t)) #b1001))
(test-assert (= (list->integer '(#t #f #f #t #f)) #b10010))


(test-assert (equal? '(#t #f #t) (integer->list 
                                   (list->integer '(#t #f #t)))))


(test-exception list->integer
                (type: ('(+ #f #f)) ('(#f + #f)) ('(#f #f +)))
                (args: 0 2))
;;============================================================================
;; booleans->integer 

(test-assert (= (booleans->integer #t #f #f #t) #b1001))
(test-assert (= (booleans->integer #t #f #f #t) #b1001))
(test-assert (= (booleans->integer #f #t #f #f #t) #b1001))
(test-assert (= (booleans->integer #t #f #f #t #f) #b10010))


(test-exception booleans->integer
                (type: (+ #f #f) (#f + #f) (#f #f +)))

;;============================================================================
