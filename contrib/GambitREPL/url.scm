;;;============================================================================

;;; File: "url.scm"

;;; Copyright (c) 2011-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("url#"))

(##include "~~lib/gambit#.scm")

(##include "url#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (fixnum)
  (not safe)
)

;;;============================================================================

;; Encoding and decoding of x-www-form-urlencoded data.

(define (url-encode str #!optional (start 0) (end (string-length str)) (space-to-plus? #f))

  (define chunk-length 1024)

  (define (hex n)
    (string-ref "0123456789ABCDEF" (bitwise-and n 15)))

  (define (encode-chunk len i end)
    (if (< i end)
        (let ((c (string-ref str i)))
          (if (or (and (char>=? c #\a) (char<=? c #\z))
                  (and (char>=? c #\A) (char<=? c #\Z))
                  (and (char>=? c #\0) (char<=? c #\9))
                  (char=? c #\-)
                  (char=? c #\_)
                  (char=? c #\.)
                  (char=? c #\!)
                  (char=? c #\~)
                  (char=? c #\*)
                  (char=? c #\')
                  (char=? c #\()
                  (char=? c #\))
                  (and (char=? c #\space) space-to-plus?))
              (let ((result (encode-chunk (+ len 1) (+ i 1) end)))
                (string-set!
                 result
                 len
                 (if (and (char=? c #\space) space-to-plus?) #\+ c))
                result)
              (let ((result (encode-chunk (+ len 3) (+ i 1) end)))
                (let ((n (char->integer c)))
                  (string-set! result (+ len 0) #\%)
                  (string-set! result (+ len 1) (hex (arithmetic-shift n -4)))
                  (string-set! result (+ len 2) (hex n))
                  result))))
        (make-string len)))

  (let loop ((i start) (chunks '()))
    (let ((span (min (- end i) chunk-length)))
      (if (= span 0)
          (string-concatenate
           (reverse chunks))
          (let* ((next-i (+ i span))
                 (chunk (encode-chunk 0 i next-i)))
            (loop next-i (cons chunk chunks)))))))

(define (url-decode str #!optional (start 0) (end (string-length str)) (plus-to-space? #f))

  (define chunk-length 1024)

  (define (hex? c)
    (cond ((and (char>=? c #\0) (char<=? c #\9))
           (- (char->integer c) (char->integer #\0)))
          ((and (char>=? c #\a) (char<=? c #\f))
           (+ 10 (- (char->integer c) (char->integer #\a))))
          ((and (char>=? c #\A) (char<=? c #\F))
           (+ 10 (- (char->integer c) (char->integer #\A))))
          (else
           #f)))

  (define (decode len i end)
    (if (and (< i end)
             (< len chunk-length))
        (let ((c (string-ref str i)))
          (cond ((or (and (char>=? c #\a) (char<=? c #\z))
                     (and (char>=? c #\A) (char<=? c #\Z))
                     (and (char>=? c #\0) (char<=? c #\9))
                     (char=? c #\-)
                     (char=? c #\_)
                     (char=? c #\.)
                     (char=? c #\!)
                     (char=? c #\~)
                     (char=? c #\*)
                     (char=? c #\')
                     (char=? c #\()
                     (char=? c #\))
                     (and (char=? c #\+) plus-to-space?))
                 (let ((result (decode (+ len 1) (+ i 1) end)))
                   (and result
                        (begin
                          (string-set!
                           (cdr result)
                           len
                           (if (and (char=? c #\+) plus-to-space?) #\space c))
                          result))))
                ((char=? c #\%)
                 (if (< (+ i 2) end)
                     (let* ((a (hex? (string-ref str (+ i 1))))
                            (b (hex? (string-ref str (+ i 2)))))
                       (and a
                            b
                            (let ((result (decode (+ len 1) (+ i 3) end)))
                              (and result
                                   (begin
                                     (string-set! (cdr result)
                                                  len
                                                  (integer->char
                                                   (+ (arithmetic-shift a 4) b)))
                                     result)))))
                     #f))
                (else
                 #f)))
        (cons i (make-string len))))

  (let loop ((i start) (chunks '()))
    (if (< i end)
        (let ((x (decode 0 i end)))
          (and x
               (loop (car x) (cons (cdr x) chunks))))
        (string-concatenate
         (reverse chunks)))))

;;;============================================================================
