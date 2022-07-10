;;;============================================================================

;;; File: "_base64#.scm"

;;; Copyright (c) 2005-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Base64 encoding/decoding.

(##supply-module _base64)

(##namespace ("_base64#"))                ;; in _base64#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;----------------------------------------------------------------------------

(##include "_base64#.scm")

(##namespace ("##" fifo->u8vector fifo->string))

;;;----------------------------------------------------------------------------

;; Encoding.

(define-prim&proc (u8vector->base64
                   (u8vector u8vector)
                   (start (index-range-incl
                           0
                           (u8vector-length u8vector))
                          0)
                   (end (index-range-incl
                         start
                         (u8vector-length u8vector))
                        (u8vector-length u8vector))
                   (alt-char1 char #\+) ;; encoding of 62
                   (alt-char2 char #\/) ;; encoding of 63
                   (width index 0))     ;; where to insert line breaks (0=none)

  (define pad-char #\=)

  (define (err)
    (error "base64 encoding error"))

  (define chunk-len 64) ;; must be a power of 2

  (define state
    (vector 0
            (macro-make-fifo)))

  (define (wr-char c)
    (let ((ptr (vector-ref state 0)))
      (vector-set! state 0 (fx+ ptr 1))
      (let ((fifo (vector-ref state 1))
            (i (fxand ptr (fx- chunk-len 1))))
        (string-set!
         (if (fx= i 0)
             (let ((chunk (make-string chunk-len)))
               (macro-fifo-insert-at-tail! fifo chunk)
               chunk)
             (macro-fifo-elem (macro-fifo-tail fifo)))
         i
         c))))

  (define (get-output-string)
    (let ((ptr (vector-ref state 0))
          (fifo (vector-ref state 1)))
      (if (and (fx< 0 ptr) (fx<= ptr chunk-len))
          (let ((str (macro-fifo-elem (macro-fifo-tail fifo))))
            (string-shrink! str ptr)
            str)
          (fifo->string fifo 0 ptr))))

  (define (add c)
    (wr-char c))

  (define (out x n)
    (let ((new-n
           (cond ((fx= -1 n)
                  n)
                 ((fx= 0 n)
                  (add #\newline)
                  (fx- width 1))
                 (else
                  (fx- n 1)))))
      (add (cond ((fx<= x 25)
                  (integer->char (fx+ x (char->integer #\A))))
                 ((fx<= x 51)
                  (integer->char (fx+ (fx- x 26) (char->integer #\a))))
                 ((fx<= x 61)
                  (integer->char (fx+ (fx- x 52) (char->integer #\0))))
                 ((fx= x 62)
                  alt-char1)
                 ((fx= x 63)
                  alt-char2)
                 (else
                  pad-char)))
      new-n))

  (let loop ((i start)
             (n (if (fx> width 0) width -1)))
    (if (fx<= (fx+ i 3) end)
        (let ((b0 (u8vector-ref u8vector i))
              (b1 (u8vector-ref u8vector (fx+ i 1)))
              (b2 (u8vector-ref u8vector (fx+ i 2))))
          (let ((x0
                 (fxarithmetic-shift-right b0 2))
                (x1
                 (fxand #x3f
                        (fx+ (fxarithmetic-shift-left b0 4)
                             (fxarithmetic-shift-right b1 4))))
                (x2
                 (fxand #x3f
                        (fx+ (fxarithmetic-shift-left b1 2)
                             (fxarithmetic-shift-right b2 6))))
                (x3
                 (fxand #x3f b2)))
            (loop (fx+ i 3)
                  (out x3 (out x2 (out x1 (out x0 n)))))))
        (let ((rest (fx- end i)))
          (cond ((fx= rest 2)
                 (let ((b0 (u8vector-ref u8vector i))
                       (b1 (u8vector-ref u8vector (fx+ i 1))))
                   (let ((x0
                          (fxarithmetic-shift-right b0 2))
                         (x1
                          (fxand #x3f
                                 (fx+ (fxarithmetic-shift-left b0 4)
                                      (fxarithmetic-shift-right b1 4))))
                         (x2
                          (fxand #x3f
                                 (fxarithmetic-shift-left b1 2)))
                         (x3
                          64))
                     (out x3 (out x2 (out x1 (out x0 n)))))))
                ((fx= rest 1)
                 (let ((b0 (u8vector-ref u8vector i)))
                   (let ((x0
                          (fxarithmetic-shift-right b0 2))
                         (x1
                          (fxand #x3f
                                 (fxarithmetic-shift-left b0 4)))
                         (x2
                          64)
                         (x3
                          64))
                     (out x3 (out x2 (out x1 (out x0 n))))))))
          (get-output-string)))))

;; Decoding.

(define-prim&proc (base64->u8vector
                   (string string)
                   (start (index-range-incl
                           0
                           (string-length string))
                          0)
                   (end (index-range-incl
                         start
                         (string-length string))
                        (string-length string))
                   (alt-char1 char #\+)  ;; encoding of 62
                   (alt-char2 char #\/)) ;; encoding of 63

  (define pad-char #\=)

  (define strict? #f) ;; only allow base64 characters?

  (define (err)
    (error "base64 decoding error"))

  (define chunk-len 64) ;; must be a power of 2

  (define state
    (vector 0
            (macro-make-fifo)))

  (define (wr-u8 x)
    (let ((ptr (vector-ref state 0)))
      (vector-set! state 0 (fx+ ptr 1))
      (let ((fifo (vector-ref state 1))
            (i (fxand ptr (fx- chunk-len 1))))
        (u8vector-set!
         (if (fx= i 0)
             (let ((chunk (make-u8vector chunk-len)))
               (macro-fifo-insert-at-tail! fifo chunk)
               chunk)
             (macro-fifo-elem (macro-fifo-tail fifo)))
         i
         x))))

  (define (get-output-u8vector)
    (let ((ptr (vector-ref state 0))
          (fifo (vector-ref state 1)))
      (if (and (fx< 0 ptr) (fx<= ptr chunk-len))
          (let ((u8vect (macro-fifo-elem (macro-fifo-tail fifo))))
            (u8vector-shrink! u8vect ptr)
            u8vect)
          (fifo->u8vector fifo 0 ptr))))

  (define (decode c)
    (cond ((and (char>=? c #\A) (char<=? c #\Z))
           (fx- (char->integer c) (char->integer #\A)))
          ((and (char>=? c #\a) (char<=? c #\z))
           (fx+ 26 (fx- (char->integer c) (char->integer #\a))))
          ((and (char>=? c #\0) (char<=? c #\9))
           (fx+ 52 (fx- (char->integer c) (char->integer #\0))))
          ((char=? c alt-char1)
           62)
          ((char=? c alt-char2)
           63)
          (else
           #f)))

  (define (done)
    (get-output-u8vector))

  (define (add x)
    (wr-u8 x))

  (define (add1 x0 x1)
    (add (fx+ (fxarithmetic-shift-left x0 2)
              (fxarithmetic-shift-right x1 4))))

  (define (add2 x0 x1 x2)
    (add1 x0 x1)
    (add (fxand #xff
                (fx+ (fxarithmetic-shift-left x1 4)
                     (fxarithmetic-shift-right x2 2)))))

  (define (add3 x0 x1 x2 x3)
    (add2 x0 x1 x2)
    (add (fxand #xff
                (fx+ (fxarithmetic-shift-left x2 6)
                     x3))))

  (let loop0 ((i start))
    (if (fx>= i end)
        (done)
        (let* ((c0 (string-ref string i))
               (x0 (decode c0)))
          (if x0
              (let loop1 ((i (fx+ i 1)))
                (if (fx>= i end)
                    (err)
                    (let* ((c1 (string-ref string i))
                           (x1 (decode c1)))
                      (if x1
                          (let loop2 ((i (fx+ i 1)))
                            (if (fx>= i end)
                                (err)
                                (let* ((c2 (string-ref string i))
                                       (x2 (decode c2)))
                                  (if x2
                                      (let loop3 ((i (fx+ i 1)))
                                        (if (fx>= i end)
                                            (err)
                                            (let* ((c3 (string-ref string i))
                                                   (x3 (decode c3)))
                                              (if x3
                                                  (begin
                                                    (add3 x0 x1 x2 x3)
                                                    (loop0 (fx+ i 1)))
                                                  (if (char=? c3 pad-char)
                                                      (begin
                                                        (add2 x0 x1 x2)
                                                        (done))
                                                      (if strict?
                                                          (err)
                                                          (loop3 (fx+ i 1))))))))
                                      (if (char=? c2 pad-char)
                                          (begin
                                            (add1 x0 x1)
                                            (done))
                                          (if strict?
                                              (err)
                                              (loop2 (fx+ i 1))))))))
                          (if (or strict? (char=? c1 pad-char))
                              (err)
                              (loop1 (fx+ i 1)))))))
              (if (or strict? (char=? c0 pad-char))
                  (err)
                  (loop0 (fx+ i 1))))))))

;;;============================================================================
