;==============================================================================

; File: "digest.scm", Time-stamp: <2008-12-15 11:28:03 feeley>

; Copyright (c) 2005-2008 by Marc Feeley, All Rights Reserved.

;==============================================================================

(##namespace ("digest#"))

(##include "~~lib/gambit#.scm")

(##include "digest#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
;  (block)
;  (not safe)
;  (fixnum)
)

;==============================================================================

; Utilities to perform 32 bit operations using fixnums.

(define-macro (make-hash-block n) `(##make-u16vector ,n 0))
(define-macro (hash-block . args) `(##u16vector ,@args))
(define-macro (hash-block-ref hb i) `(##u16vector-ref ,hb ,i))
(define-macro (hash-block-set! hb i x) `(##u16vector-set! ,hb ,i ,x))

(define (hash-block->hex-string hb)

  (define (hex x)
    (##string-ref "0123456789abcdef" (##fixnum.bitwise-and x 15)))

  (let* ((len (u16vector-length hb))
         (n (##fixnum.* len 4))
         (str (##make-string n)))
    (let loop ((i (##fixnum.- len 1)) (j (##fixnum.- n 4)))
      (if (##fixnum.< i 0)
          str
          (let ((x (hash-block-ref hb i)))
            (##string-set!
             str
             (##fixnum.+ j 0)
             (hex (##fixnum.arithmetic-shift-right x 4)))
            (##string-set!
             str
             (##fixnum.+ j 1)
             (hex (##fixnum.arithmetic-shift-right x 0)))
            (##string-set!
             str
             (##fixnum.+ j 2)
             (hex (##fixnum.arithmetic-shift-right x 12)))
            (##string-set!
             str
             (##fixnum.+ j 3)
             (hex (##fixnum.arithmetic-shift-right x 8)))
            (loop (##fixnum.- i 1) (##fixnum.- j 4)))))))

(define-macro (LO var)
  (string->symbol (string-append (symbol->string var) "-L")))

(define-macro (HI var)
  (string->symbol (string-append (symbol->string var) "-H")))

(define-macro (wlet var lo hi body)
  `(let ((,(string->symbol (string-append (symbol->string var) "-L")) ,lo)
         (,(string->symbol (string-append (symbol->string var) "-H")) ,hi))
     ,body))

(define-macro (cast-u16 x)
  `(##fixnum.bitwise-and #xffff ,x))

(define-macro (wrot dst w r body)
  (if (< r 16)
      `(wlet ,dst
             (cast-u16
              (##fixnum.bitwise-ior
               (##fixnum.arithmetic-shift-left (LO ,w) ,r)
               (##fixnum.arithmetic-shift-right (HI ,w) ,(- 16 r))))
             (cast-u16
              (##fixnum.bitwise-ior
               (##fixnum.arithmetic-shift-left (HI ,w) ,r)
               (##fixnum.arithmetic-shift-right (LO ,w) ,(- 16 r))))
             ,body)
      `(wlet ,dst
             (cast-u16
              (##fixnum.bitwise-ior
               (##fixnum.arithmetic-shift-left (HI ,w) ,(- r 16))
               (##fixnum.arithmetic-shift-right (LO ,w) ,(- 32 r))))
             (cast-u16
              (##fixnum.bitwise-ior
               (##fixnum.arithmetic-shift-left (LO ,w) ,(- r 16))
               (##fixnum.arithmetic-shift-right (HI ,w) ,(- 32 r))))
             ,body)))

(define-macro (wadd dst a b body)
  `(wlet R
         (##fixnum.+ (LO ,a) (LO ,b))
         (##fixnum.+ (HI ,a) (HI ,b))
         (wlet ,dst
               (cast-u16 (LO R))
               (cast-u16
                (##fixnum.+ (HI R)
                            (##fixnum.arithmetic-shift-right (LO R) 16)))
               ,body)))

(define-macro (wxor dst a b body)
  `(wlet ,dst
         (##fixnum.bitwise-xor (LO ,a) (LO ,b))
         (##fixnum.bitwise-xor (HI ,a) (HI ,b))
         ,body))

(define-macro (wior dst a b body)
  `(wlet ,dst
         (##fixnum.bitwise-ior (LO ,a) (LO ,b))
         (##fixnum.bitwise-ior (HI ,a) (HI ,b))
         ,body))

(define-macro (wand dst a b body)
  `(wlet ,dst
         (##fixnum.bitwise-and (LO ,a) (LO ,b))
         (##fixnum.bitwise-and (HI ,a) (HI ,b))
         ,body))

(define-macro (wnot dst a body)
  `(wlet ,dst
         (##fixnum.bitwise-not (LO ,a))
         (##fixnum.bitwise-not (HI ,a))
         ,body))

;------------------------------------------------------------------------------

; Generic interface.

(define-type digest
  id: 1ce13de0-ccaa-4627-94be-b13eaa2c32e6
  close-digest
  hash-update
  hash
  block
  block-pos
  bit-pos
)

(define block-bit-length 512)

(define (open-digest algorithm)
  (case algorithm
    ((md5 MD5)
     (open-md5-digest))
    ((sha-1 SHA-1)
     (open-sha-1-digest))
    ((sha-224 SHA-224)
     (open-sha-224-digest))
    ((sha-256 SHA-256)
     (open-sha-256-digest))
    (else
     (error "unimplemented hashing algorithm" algorithm))))

(define (close-digest digest
                      #!optional
                      (result-type 'hex-string))
  ((digest-close-digest digest) digest result-type))

(define (digest-update-subu8vector digest u8vect start end)
  (let ((block (digest-block digest)))

    (define (aligned8 i bit-pos)

      ; bit-pos is a multiple of 8

      (if (##fixnum.< i end)
          (let ((j (##fixnum.arithmetic-shift-right bit-pos 4)))
            (if (##fixnum.= 0 (##fixnum.bitwise-and bit-pos 15))
                (begin
                  (if #t
                      (hash-block-set!
                       block
                       j
                       (##u8vector-ref u8vect i))
                      (let ((j (##fixnum.bitwise-xor j 1)))
                        (hash-block-set!
                         block
                         j
                         (##u8vector-ref u8vect i))))
                  (let ((new-bit-pos (##fixnum.+ bit-pos 8)))
                    (aligned8 (##fixnum.+ i 1) new-bit-pos)))
                (begin
                  (if #t
                      (hash-block-set!
                       block
                       j
                       (##fixnum.+ (hash-block-ref block j)
                                   (##fixnum.arithmetic-shift-left
                                    (##u8vector-ref u8vect i)
                                    8)))
                      (let ((j (##fixnum.bitwise-xor j 1)))
                        (hash-block-set!
                         block
                         j
                         (##fixnum.+ (hash-block-ref block j)
                                     (##fixnum.arithmetic-shift-left
                                      (##u8vector-ref u8vect i)
                                      8)))))
                  (let ((new-bit-pos (##fixnum.+ bit-pos 8)))
                    (if (##fixnum.= block-bit-length new-bit-pos)
                      (begin
                        ((digest-hash-update digest) digest)
                        (digest-block-pos-set!
                         digest
                         (##fixnum.+ (digest-block-pos digest) 1))
                        (aligned16 (##fixnum.+ i 1) 0))
                      (aligned16 (##fixnum.+ i 1) new-bit-pos))))))
          (digest-bit-pos-set! digest bit-pos)))

    (define (aligned16 i bit-pos)

      ; bit-pos is a multiple of 16

      (if (##fixnum.< (##fixnum.+ i 1) end)
          (let ((j (##fixnum.arithmetic-shift-right bit-pos 4)))
            (hash-block-set!
             block
             j
             (##fixnum.+
              (##fixnum.arithmetic-shift-left
               (##u8vector-ref u8vect (##fixnum.+ i 1))
               8)
              (##u8vector-ref u8vect i)))
            (let ((new-bit-pos (##fixnum.+ bit-pos 16)))
              (if (##fixnum.= block-bit-length new-bit-pos)
                  (begin
                    ((digest-hash-update digest) digest)
                    (digest-block-pos-set!
                     digest
                     (##fixnum.+ (digest-block-pos digest) 1))
                    (aligned16 (##fixnum.+ i 2) 0))
                  (aligned16 (##fixnum.+ i 2) new-bit-pos))))
          (aligned8 i bit-pos)))

;    (set! aligned16 aligned8)

    (let ((bit-pos (digest-bit-pos digest)))
      (cond ((##fixnum.= 0 (##fixnum.bitwise-and bit-pos 15)) ; u16 boundary?
             (aligned16 start bit-pos))
            (else
             ; (##fixnum.= 0 (##fixnum.bitwise-and bit-pos 7)) ; u8 boundary?
             (aligned8 start bit-pos))))))

(define zero-u8vector '#u8(0 0 0 0 0 0 0 0))

(define (digest-update-u8 digest n)
  (digest-update-subu8vector
   digest
   (if (##eqv? n 0)
       zero-u8vector
       (##u8vector n))
   0
   1))

(define (digest-update-u16-le digest n)
  (digest-update-subu8vector
   digest
   (if (##eqv? n 0)
       zero-u8vector
       (##u8vector (##fixnum.bitwise-and n #xff)
                   (##fixnum.arithmetic-shift-right n 8)))
   0
   2))

(define (digest-update-u16-be digest n)
  (digest-update-subu8vector
   digest
   (if (##eqv? n 0)
       zero-u8vector
       (##u8vector (##fixnum.arithmetic-shift-right n 8)
                   (##fixnum.bitwise-and n #xff)))
   0
   2))

(define (digest-update-u32-le digest n)
  (digest-update-subu8vector
   digest
   (if (##eqv? n 0)
       zero-u8vector
       (let ((lo16 (##bitwise-and n #xffff)); might overflow fixnums
             (hi16 (##arithmetic-shift n -16)))
         (##u8vector (##fixnum.bitwise-and lo16 #xff)
                     (##fixnum.arithmetic-shift-right lo16 8)
                     (##fixnum.bitwise-and hi16 #xff)
                     (##fixnum.arithmetic-shift-right hi16 8))))
   0
   4))

(define (digest-update-u32-be digest n)
  (digest-update-subu8vector
   digest
   (if (##eqv? n 0)
       zero-u8vector
       (let ((lo16 (##bitwise-and n #xffff)); might overflow fixnums
             (hi16 (##arithmetic-shift n -16)))
         (##u8vector (##fixnum.arithmetic-shift-right hi16 8)
                     (##fixnum.bitwise-and hi16 #xff)
                     (##fixnum.arithmetic-shift-right lo16 8)
                     (##fixnum.bitwise-and lo16 #xff))))
   0
   4))

(define (digest-update-u64-le digest n)
  (digest-update-u32-le digest (##bitwise-and n #xffffffff)); might overflow fixnums
  (digest-update-u32-le digest (##arithmetic-shift n -32)))

(define (digest-update-u64-be digest n)
  (digest-update-u32-be digest (##arithmetic-shift n -32)); might overflow fixnums
  (digest-update-u32-be digest (##bitwise-and n #xffffffff)))

(define (digest-string str
                       algorithm
                       #!optional
                       (result-type 'hex-string))
  (digest-substring str
                    0
                    (##string-length str)
                    algorithm
                    result-type))

(define (digest-substring str
                          start
                          end
                          algorithm
                          #!optional
                          (result-type 'hex-string))
  (let ((port (##open-output-u8vector
               '(init: #u8()
                 char-encoding: UTF-8))))
    (##write-substring str start end port)
    (let ((u8vect (##get-output-u8vector port)))
      (##close-output-port port)
      (digest-u8vector u8vect algorithm result-type))))

(define (digest-u8vector u8vect
                         algorithm
                         #!optional
                         (result-type 'hex-string))
  (digest-subu8vector u8vect
                      0
                      (##u8vector-length u8vect)
                      algorithm
                      result-type))

(define (digest-subu8vector u8vect
                            start
                            end
                            algorithm
                            #!optional
                            (result-type 'hex-string))
  (let ((digest (open-digest algorithm)))
    (digest-update-subu8vector digest u8vect start end)
    (close-digest digest result-type)))

(define (digest-file filename
                     algorithm
                     #!optional
                     (result-type 'hex-string))
  (let* ((digest (open-digest algorithm))
         (port (open-input-file filename))
         (u8vect (##make-u8vector 1024 0)))
    (let loop ()
      (let ((n (##read-subu8vector u8vect 0 (##u8vector-length u8vect) port)))
        (if (##fixnum.> n 0)
            (begin
              (digest-update-subu8vector digest u8vect 0 n)
              (loop))
            (begin
              (##close-input-port port)
              (close-digest digest result-type)))))))

;==============================================================================

; MD5 algorithm.

(define (open-md5-digest)
  (make-digest
   md5-close-digest
   md5-hash-update
   (md5-hash-block-init)
   (make-hash-block 32)
   0
   0))

(define (md5-close-digest digest result-type)
  (let* ((block-pos
          (digest-block-pos digest))
         (bit-pos
          (digest-bit-pos digest))
         (msg-length
          (+ bit-pos (* block-bit-length block-pos)))) ; might overflow fixnums

    (digest-update-subu8vector digest '#u8(#x80) 0 1) ; add 1 bit

    (let ((zero-padding-bytes
           (##fixnum.quotient
            (##fixnum.bitwise-and 511
                                  (##fixnum.- 448 (digest-bit-pos digest)))
            8)))
      (let loop ((n zero-padding-bytes))
        (if (##fixnum.< 0 n)
            (let ((m (##fixnum.min 8 n)))
              (digest-update-subu8vector digest zero-u8vector 0 m) ; add 0 bits
              (loop (##fixnum.- n m))))))

    (digest-update-u64-le digest msg-length) ; add message length (in bits)

    (hash-block->hex-string (digest-hash digest))))

(define (md5-hash-block-init)
  (hash-block #x2301 #x6745
              #xab89 #xefcd
              #xdcfe #x98ba
              #x5476 #x1032))

(define (md5-hash-update digest)
  (let ((hash (digest-hash digest))
        (block (digest-block digest)))

    (define-macro (wstp dst w f i n r body)
      `(wlet T1
             ,(cons (car f) (map (lambda (v) `(LO ,v)) (cdr f)))
             ,(cons (car f) (map (lambda (v) `(HI ,v)) (cdr f)))
             (wadd T2
                   ,dst
                   T1
                   (wlet T3
                         (hash-block-ref block ,(+ (* 2 i) 0))
                         (hash-block-ref block ,(+ (* 2 i) 1))
                         (wadd T4
                               T2
                               T3
                               (wlet T5
                                     ,(modulo n #x10000)
                                     ,(quotient n #x10000)
                                     (wadd T6
                                           T4
                                           T5
                                           (wrot T7
                                                 T6
                                                 ,r
                                                 (wadd ,dst
                                                       ,w
                                                       T7
                                                       ,body)))))))))

    (define-macro (F x y z)
      `(##fixnum.bitwise-ior
        (##fixnum.bitwise-and ,x ,y)
        (##fixnum.bitwise-and (##fixnum.bitwise-not ,x) ,z)))

    (define-macro (G x y z)
      `(##fixnum.bitwise-ior
        (##fixnum.bitwise-and ,x ,z)
        (##fixnum.bitwise-and ,y (##fixnum.bitwise-not ,z))))

    (define-macro (H x y z)
      `(##fixnum.bitwise-xor ,x (##fixnum.bitwise-xor ,y ,z)))

    (define-macro (I x y z)
      `(cast-u16
        (##fixnum.bitwise-xor
         ,y
         (##fixnum.bitwise-ior
          ,x
          (##fixnum.bitwise-not ,z)))))

    (wlet A (hash-block-ref hash 0) (hash-block-ref hash 1)
    (wlet B (hash-block-ref hash 2) (hash-block-ref hash 3)
    (wlet C (hash-block-ref hash 4) (hash-block-ref hash 5)
    (wlet D (hash-block-ref hash 6) (hash-block-ref hash 7)
    (wstp A B (F B C D)  0 #xD76AA478  7
    (wstp D A (F A B C)  1 #xE8C7B756 12
    (wstp C D (F D A B)  2 #x242070DB 17
    (wstp B C (F C D A)  3 #xC1BDCEEE 22
    (wstp A B (F B C D)  4 #xF57C0FAF  7
    (wstp D A (F A B C)  5 #x4787C62A 12
    (wstp C D (F D A B)  6 #xA8304613 17
    (wstp B C (F C D A)  7 #xFD469501 22
    (wstp A B (F B C D)  8 #x698098D8  7
    (wstp D A (F A B C)  9 #x8B44F7AF 12
    (wstp C D (F D A B) 10 #xFFFF5BB1 17
    (wstp B C (F C D A) 11 #x895CD7BE 22
    (wstp A B (F B C D) 12 #x6B901122  7
    (wstp D A (F A B C) 13 #xFD987193 12
    (wstp C D (F D A B) 14 #xA679438E 17
    (wstp B C (F C D A) 15 #x49B40821 22
    (wstp A B (G B C D)  1 #xF61E2562  5
    (wstp D A (G A B C)  6 #xC040B340  9
    (wstp C D (G D A B) 11 #x265E5A51 14
    (wstp B C (G C D A)  0 #xE9B6C7AA 20
    (wstp A B (G B C D)  5 #xD62F105D  5
    (wstp D A (G A B C) 10 #x02441453  9
    (wstp C D (G D A B) 15 #xD8A1E681 14
    (wstp B C (G C D A)  4 #xE7D3FBC8 20
    (wstp A B (G B C D)  9 #x21E1CDE6  5
    (wstp D A (G A B C) 14 #xC33707D6  9
    (wstp C D (G D A B)  3 #xF4D50D87 14
    (wstp B C (G C D A)  8 #x455A14ED 20
    (wstp A B (G B C D) 13 #xA9E3E905  5
    (wstp D A (G A B C)  2 #xFCEFA3F8  9
    (wstp C D (G D A B)  7 #x676F02D9 14
    (wstp B C (G C D A) 12 #x8D2A4C8A 20
    (wstp A B (H B C D)  5 #xFFFA3942  4
    (wstp D A (H A B C)  8 #x8771F681 11
    (wstp C D (H D A B) 11 #x6D9D6122 16
    (wstp B C (H C D A) 14 #xFDE5380C 23
    (wstp A B (H B C D)  1 #xA4BEEA44  4
    (wstp D A (H A B C)  4 #x4BDECFA9 11
    (wstp C D (H D A B)  7 #xF6BB4B60 16
    (wstp B C (H C D A) 10 #xBEBFBC70 23
    (wstp A B (H B C D) 13 #x289B7EC6  4
    (wstp D A (H A B C)  0 #xEAA127FA 11
    (wstp C D (H D A B)  3 #xD4EF3085 16
    (wstp B C (H C D A)  6 #x04881D05 23
    (wstp A B (H B C D)  9 #xD9D4D039  4
    (wstp D A (H A B C) 12 #xE6DB99E5 11
    (wstp C D (H D A B) 15 #x1FA27CF8 16
    (wstp B C (H C D A)  2 #xC4AC5665 23
    (wstp A B (I B C D)  0 #xF4292244  6
    (wstp D A (I A B C)  7 #x432AFF97 10
    (wstp C D (I D A B) 14 #xAB9423A7 15
    (wstp B C (I C D A)  5 #xFC93A039 21
    (wstp A B (I B C D) 12 #x655B59C3  6
    (wstp D A (I A B C)  3 #x8F0CCC92 10
    (wstp C D (I D A B) 10 #xFFEFF47D 15
    (wstp B C (I C D A)  1 #x85845DD1 21
    (wstp A B (I B C D)  8 #x6FA87E4F  6
    (wstp D A (I A B C) 15 #xFE2CE6E0 10
    (wstp C D (I D A B)  6 #xA3014314 15
    (wstp B C (I C D A) 13 #x4E0811A1 21
    (wstp A B (I B C D)  4 #xF7537E82  6
    (wstp D A (I A B C) 11 #xBD3AF235 10
    (wstp C D (I D A B)  2 #x2AD7D2BB 15
    (wstp B C (I C D A)  9 #xEB86D391 21
    (wlet AA (hash-block-ref hash 0) (hash-block-ref hash 1)
    (wadd A AA A
    (begin (hash-block-set! hash 0 (LO A)) (hash-block-set! hash 1 (HI A))
    (wlet BB (hash-block-ref hash 2) (hash-block-ref hash 3)
    (wadd B BB B
    (begin (hash-block-set! hash 2 (LO B)) (hash-block-set! hash 3 (HI B))
    (wlet CC (hash-block-ref hash 4) (hash-block-ref hash 5)
    (wadd C CC C
    (begin (hash-block-set! hash 4 (LO C)) (hash-block-set! hash 5 (HI C))
    (wlet DD (hash-block-ref hash 6) (hash-block-ref hash 7)
    (wadd D DD D
    (begin (hash-block-set! hash 6 (LO D)) (hash-block-set! hash 7 (HI D))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

;==============================================================================

; SHA-1 algorithm.

(define (open-sha-1-digest)
  (make-digest
   sha-1-close-digest
   sha-1-hash-update
   (sha-1-hash-block-init)
   (make-hash-block 160)
   0
   0))

(define (sha-1-close-digest digest result-type)
  (let* ((block-pos
          (digest-block-pos digest))
         (bit-pos
          (digest-bit-pos digest))
         (msg-length
          (+ bit-pos (* block-bit-length block-pos)))) ; might overflow fixnums

    (digest-update-subu8vector digest '#u8(#x80) 0 1) ; add 1 bit

    (let ((zero-padding-bytes
           (##fixnum.quotient
            (##fixnum.bitwise-and 511
                                  (##fixnum.- 448 (digest-bit-pos digest)))
            8)))
      (let loop ((n zero-padding-bytes))
        (if (##fixnum.< 0 n)
            (let ((m (##fixnum.min 8 n)))
              (digest-update-subu8vector digest zero-u8vector 0 m) ; add 0 bits
              (loop (##fixnum.- n m))))))

    (digest-update-u64-be digest msg-length) ; add message length (in bits)

    (hash-block->hex-string (digest-hash digest))))






(define (hex n)
  (substring (number->string (+ n (expt 2 32)) 16) 1 9))

(define (u32 n)
  (bitwise-and #xffffffff n))

(define (rol num cnt)
  (u32 (+ (arithmetic-shift num cnt)
          (arithmetic-shift num (- cnt 32)))))

(define (swap x)
  (let ((h (quotient x (expt 2 8)))
        (l (modulo x (expt 2 8))))
    (+ (arithmetic-shift l 8) h)))

(define (split x)
  (list (swap (quotient x (expt 2 16)))
        (swap (modulo x (expt 2 16)))))

(define (merge x)
  (+ (arithmetic-shift (swap (car x)) 16)
     (swap (cadr x))))

(define (vect-ref hb i)
  (let ((h (swap (hash-block-ref hb (+ (* 2 i) 0))))
        (l (swap (hash-block-ref hb (+ (* 2 i) 1)))))
    (+ (arithmetic-shift h 16) l)))
        
(define (vect-set! hb i x)
  (let ((h (swap (quotient x (expt 2 16))))
        (l (swap (modulo x (expt 2 16)))))
    (hash-block-set! hb (+ (* 2 i) 0) h)
    (hash-block-set! hb (+ (* 2 i) 1) l)))
        
(define (->hash-block vect)
  (list->u16vector (apply append (map split (vector->list vect)))))

(define (<-hash-block hb)
  (define (cvt lst)
    (if (null? lst)
        '()
        (cons (merge lst) (cvt (cddr lst)))))
  (list->vector (cvt (u16vector->list hb))))

(define (hash-block->hex hb)
  (apply string-append
         (map hex
              (vector->list (<-hash-block hb)))))

;(trace ->hash-block <-hash-block)

(define (sha-1-hash-block-init)
  (->hash-block
   (vector #x67452301
           #xefcdab89
           #x98badcfe
           #x10325476
           #xc3d2e1f0)))

(define (sha-1-hash-update digest)
  (let* ((hash (digest-hash digest))
         (block (digest-block digest)))
    (let ((OLDA (vect-ref hash 0))
          (OLDB (vect-ref hash 1))
          (OLDC (vect-ref hash 2))
          (OLDD (vect-ref hash 3))
          (OLDE (vect-ref hash 4)))
      (let loop ((j 0)
                 (j2 0)
                 (A OLDA)
                 (B OLDB)
                 (C OLDC)
                 (D OLDD)
                 (E OLDE))
        (if (< j 80)

            (let ((X
                   (if (< j 16)

                       (wlet T1
                             (hash-block-ref block (##fixnum.+ j2 1))
                             (hash-block-ref block (##fixnum.+ j2 0))
                       (wlet T2 (swap T1-L) (swap T1-H)
                             (+ (arithmetic-shift T2-H 16) T2-L)))

                       (wlet T1
                             (hash-block-ref block (##fixnum.- j2 5))
                             (hash-block-ref block (##fixnum.- j2 6))
                       (wlet T2
                             (hash-block-ref block (##fixnum.- j2 15))
                             (hash-block-ref block (##fixnum.- j2 16))
                       (wxor T3 T1 T2
                       (wlet T4
                             (hash-block-ref block (##fixnum.- j2 27))
                             (hash-block-ref block (##fixnum.- j2 28))
                       (wxor T5 T3 T4
                       (wlet T6
                             (hash-block-ref block (##fixnum.- j2 31))
                             (hash-block-ref block (##fixnum.- j2 32))
                       (wxor T7 T5 T6
                       (wlet T8 (swap T7-L) (swap T7-H)
                       (wrot X T8 1
                       (let ((X (+ (arithmetic-shift X-H 16) X-L)))
                         (vect-set! block j X)
                         X)))))))))))))

              (let ((T
                     (u32 (+ (rol A 5)
                             E
                             X
                             (cond ((< j 20)
                                    (+ #x5a827999
                                       (bitwise-ior
                                        (bitwise-and B C)
                                        (bitwise-and (bitwise-not B) D))))
                                   ((< j 40)
                                    (+ #x6ed9eba1
                                       (bitwise-xor B C D)))
                                   ((< j 60)
                                    (+ #x8f1bbcdc
                                       (bitwise-ior
                                        (bitwise-and B C)
                                        (bitwise-and B D)
                                        (bitwise-and C D))))
                                   (else
                                    (+ #xca62c1d6
                                       (bitwise-xor B C D))))))))
                (loop (+ j 1)
                      (+ j2 2)
                      T
                      A
                      (rol B 30)
                      C
                      D)))

            (let ((NEWA (u32 (+ A OLDA)))
                  (NEWB (u32 (+ B OLDB)))
                  (NEWC (u32 (+ C OLDC)))
                  (NEWD (u32 (+ D OLDD)))
                  (NEWE (u32 (+ E OLDE))))
              (vect-set! hash 0 NEWA)
              (vect-set! hash 1 NEWB)
              (vect-set! hash 2 NEWC)
              (vect-set! hash 3 NEWD)
              (vect-set! hash 4 NEWE)))))))

;==============================================================================

; SHA-224 algorithm.

(define (open-sha-224-digest)
  (make-digest
   sha-224-close-digest
   sha-256-hash-update
   (sha-224-hash-block-init)
   (make-hash-block 160)
   0
   0))

(define (sha-224-close-digest digest result-type)
  (let* ((block-pos
          (digest-block-pos digest))
         (bit-pos
          (digest-bit-pos digest))
         (msg-length
          (+ bit-pos (* block-bit-length block-pos)))) ; might overflow fixnums

    (digest-update-subu8vector digest '#u8(#x80) 0 1) ; add 1 bit

    (let ((zero-padding-bytes
           (##fixnum.quotient
            (##fixnum.bitwise-and 511
                                  (##fixnum.- 448 (digest-bit-pos digest)))
            8)))
      (let loop ((n zero-padding-bytes))
        (if (##fixnum.< 0 n)
            (let ((m (##fixnum.min 8 n)))
              (digest-update-subu8vector digest zero-u8vector 0 m) ; add 0 bits
              (loop (##fixnum.- n m))))))

    (digest-update-u64-be digest msg-length) ; add message length (in bits)

    (substring
     (hash-block->hex-string (digest-hash digest))
     0
     56)))

(define (sha-224-hash-block-init)
  (->hash-block
   (vector #xc1059ed8
           #x367cd507
           #x3070dd17
           #xf70e5939
           #xffc00b31
           #x68581511
           #x64f98fa7
           #xbefa4fa4)))

;==============================================================================

; SHA-256 algorithm.

(define (open-sha-256-digest)
  (make-digest
   sha-256-close-digest
   sha-256-hash-update
   (sha-256-hash-block-init)
   (make-hash-block 160)
   0
   0))

(define (sha-256-close-digest digest result-type)
  (let* ((block-pos
          (digest-block-pos digest))
         (bit-pos
          (digest-bit-pos digest))
         (msg-length
          (+ bit-pos (* block-bit-length block-pos)))) ; might overflow fixnums

    (digest-update-subu8vector digest '#u8(#x80) 0 1) ; add 1 bit

    (let ((zero-padding-bytes
           (##fixnum.quotient
            (##fixnum.bitwise-and 511
                                  (##fixnum.- 448 (digest-bit-pos digest)))
            8)))
      (let loop ((n zero-padding-bytes))
        (if (##fixnum.< 0 n)
            (let ((m (##fixnum.min 8 n)))
              (digest-update-subu8vector digest zero-u8vector 0 m) ; add 0 bits
              (loop (##fixnum.- n m))))))

    (digest-update-u64-be digest msg-length) ; add message length (in bits)

    (hash-block->hex-string (digest-hash digest))))

(define (sha-256-hash-block-init)
  (->hash-block
   (vector #x6a09e667
           #xbb67ae85
           #x3c6ef372
           #xa54ff53a
           #x510e527f
           #x9b05688c
           #x1f83d9ab
           #x5be0cd19)))

(define (sha-256-hash-update digest)
  (let* ((hash (digest-hash digest))
         (block (digest-block digest)))
    (let ((A (vect-ref hash 0))
          (B (vect-ref hash 1))
          (C (vect-ref hash 2))
          (D (vect-ref hash 3))
          (E (vect-ref hash 4))
          (F (vect-ref hash 5))
          (G (vect-ref hash 6))
          (H (vect-ref hash 7)))

      (define-macro (W i) `(vect-ref block ,i))
      (define-macro (W-set! i x) `(vect-set! block ,i ,x))

      (define (SHR num cnt)
        (arithmetic-shift (u32 num) (- cnt)))

      (define (ROTR num cnt)
        (u32 (+ (arithmetic-shift num (- 32 cnt))
                (arithmetic-shift num (- cnt)))))

      (define (S0 x) (bitwise-xor (ROTR x  7) (ROTR x 18) (SHR x  3)))
      (define (S1 x) (bitwise-xor (ROTR x 17) (ROTR x 19) (SHR x 10)))
      (define (S2 x) (bitwise-xor (ROTR x  2) (ROTR x 13) (ROTR x 22)))
      (define (S3 x) (bitwise-xor (ROTR x  6) (ROTR x 11) (ROTR x 25)))

      (define (F0 x y z)
        (bitwise-ior
         (bitwise-and x y)
         (bitwise-and z (bitwise-ior x y))))

      (define (F1 x y z)
        (bitwise-xor
         z
         (bitwise-and x (bitwise-xor y z))))

      (define-macro (R t)
        `(let ((w (u32 (+ (S1 (W ,(- t 2)))
                          (W ,(- t 7))
                          (S0 (W ,(- t 15)))
                          (W ,(- t 16))))))
           (W-set! ,t w)
           w))

      (define-macro (P a b c d e f g h x k)
        `(let ((temp1 (u32 (+ ,h (S3 ,e) (F1 ,e ,f ,g) ,k ,x)))
               (temp2 (u32 (+ (S2 ,a) (F0 ,a ,b ,c)))))
;           (pdump)
           (set! ,d (u32 (+ ,d temp1)))
           (set! ,h (u32 (+ temp1 temp2)))))

      (define (pdump)
        (println (string-append (hex A)
                                (hex B)
                                (hex C)
                                (hex D)
                                (hex E)
                                (hex F)
                                (hex G)
                                (hex H))))

    (P A B C D E F G H (W  0) #x428A2F98)
    (P H A B C D E F G (W  1) #x71374491)
    (P G H A B C D E F (W  2) #xB5C0FBCF)
    (P F G H A B C D E (W  3) #xE9B5DBA5)
    (P E F G H A B C D (W  4) #x3956C25B)
    (P D E F G H A B C (W  5) #x59F111F1)
    (P C D E F G H A B (W  6) #x923F82A4)
    (P B C D E F G H A (W  7) #xAB1C5ED5)
    (P A B C D E F G H (W  8) #xD807AA98)
    (P H A B C D E F G (W  9) #x12835B01)
    (P G H A B C D E F (W 10) #x243185BE)
    (P F G H A B C D E (W 11) #x550C7DC3)
    (P E F G H A B C D (W 12) #x72BE5D74)
    (P D E F G H A B C (W 13) #x80DEB1FE)
    (P C D E F G H A B (W 14) #x9BDC06A7)
    (P B C D E F G H A (W 15) #xC19BF174)
    (P A B C D E F G H (R 16) #xE49B69C1)
    (P H A B C D E F G (R 17) #xEFBE4786)
    (P G H A B C D E F (R 18) #x0FC19DC6)
    (P F G H A B C D E (R 19) #x240CA1CC)
    (P E F G H A B C D (R 20) #x2DE92C6F)
    (P D E F G H A B C (R 21) #x4A7484AA)
    (P C D E F G H A B (R 22) #x5CB0A9DC)
    (P B C D E F G H A (R 23) #x76F988DA)
    (P A B C D E F G H (R 24) #x983E5152)
    (P H A B C D E F G (R 25) #xA831C66D)
    (P G H A B C D E F (R 26) #xB00327C8)
    (P F G H A B C D E (R 27) #xBF597FC7)
    (P E F G H A B C D (R 28) #xC6E00BF3)
    (P D E F G H A B C (R 29) #xD5A79147)
    (P C D E F G H A B (R 30) #x06CA6351)
    (P B C D E F G H A (R 31) #x14292967)
    (P A B C D E F G H (R 32) #x27B70A85)
    (P H A B C D E F G (R 33) #x2E1B2138)
    (P G H A B C D E F (R 34) #x4D2C6DFC)
    (P F G H A B C D E (R 35) #x53380D13)
    (P E F G H A B C D (R 36) #x650A7354)
    (P D E F G H A B C (R 37) #x766A0ABB)
    (P C D E F G H A B (R 38) #x81C2C92E)
    (P B C D E F G H A (R 39) #x92722C85)
    (P A B C D E F G H (R 40) #xA2BFE8A1)
    (P H A B C D E F G (R 41) #xA81A664B)
    (P G H A B C D E F (R 42) #xC24B8B70)
    (P F G H A B C D E (R 43) #xC76C51A3)
    (P E F G H A B C D (R 44) #xD192E819)
    (P D E F G H A B C (R 45) #xD6990624)
    (P C D E F G H A B (R 46) #xF40E3585)
    (P B C D E F G H A (R 47) #x106AA070)
    (P A B C D E F G H (R 48) #x19A4C116)
    (P H A B C D E F G (R 49) #x1E376C08)
    (P G H A B C D E F (R 50) #x2748774C)
    (P F G H A B C D E (R 51) #x34B0BCB5)
    (P E F G H A B C D (R 52) #x391C0CB3)
    (P D E F G H A B C (R 53) #x4ED8AA4A)
    (P C D E F G H A B (R 54) #x5B9CCA4F)
    (P B C D E F G H A (R 55) #x682E6FF3)
    (P A B C D E F G H (R 56) #x748F82EE)
    (P H A B C D E F G (R 57) #x78A5636F)
    (P G H A B C D E F (R 58) #x84C87814)
    (P F G H A B C D E (R 59) #x8CC70208)
    (P E F G H A B C D (R 60) #x90BEFFFA)
    (P D E F G H A B C (R 61) #xA4506CEB)
    (P C D E F G H A B (R 62) #xBEF9A3F7)
    (P B C D E F G H A (R 63) #xC67178F2)

    (let ((A (u32 (+ A (vect-ref hash 0))))
          (B (u32 (+ B (vect-ref hash 1))))
          (C (u32 (+ C (vect-ref hash 2))))
          (D (u32 (+ D (vect-ref hash 3))))
          (E (u32 (+ E (vect-ref hash 4))))
          (F (u32 (+ F (vect-ref hash 5))))
          (G (u32 (+ G (vect-ref hash 6))))
          (H (u32 (+ H (vect-ref hash 7)))))
      (vect-set! hash 0 A)
      (vect-set! hash 1 B)
      (vect-set! hash 2 C)
      (vect-set! hash 3 D)
      (vect-set! hash 4 E)
      (vect-set! hash 5 F)
      (vect-set! hash 6 G)
      (vect-set! hash 7 H)))))

;==============================================================================

; Tests.

(begin

(define md5-test-vectors
  '(
    ; from RFC 1321:
    ("" 0 ""
     "d41d8cd98f00b204e9800998ecf8427e")
    ("" 0 "a"
     "0cc175b9c0f1b6a831c399e269772661")
    ("" 0 "abc"
     "900150983cd24fb0d6963f7d28e17f72")
    ("" 0 "message digest"
     "f96b697d7cb7938d525a2f31aaf161d0")
    ("" 0 "abcdefghijklmnopqrstuvwxyz"
     "c3fcd3d76192e4007dfb496cca67e13b")
    ("" 0 "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
     "d174ab98d277d9f5a5611c2c9f419d9f")
    ("" 0 "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
     "57edf4a22be3c955ac49da2e2107b67a")
    ))

(define sha-1-test-vectors
  '(
    ("" 0 ""
     "da39a3ee5e6b4b0d3255bfef95601890afd80709")
    ; from RFC 3174:
    ("" 0 "abc"
     "a9993e364706816aba3e25717850c26c9cd0d89d")
    ("" 0 "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
     "84983e441c3bd26ebaae4aa1f95129e5e54670f1")
#;    ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" 10000 ""
     "34aa973cd4c4daa4f61eeb2bdbad27316534016f")
    ("0123456701234567012345670123456701234567012345670123456701234567" 10 ""
     "dea356a2cddd90c7a7ecedc5ebb563934f460452")
    ))

(define sha-224-test-vectors
  '(
    ; from RFC 3874:
    ("" 0 "abc"
     "23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7")
    ("" 0 "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
     "75388b16512776cc5dba5da1fd890150b0c6455cb4f58b1952522525")
    ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" 10000 ""
     "20794655980c91d8bbb4c1ea97618a4bf03f42581948b2ee4ee7ad67")
   ))

(define sha-256-test-vectors
  '(
    ("" 0 ""
     "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    ; from FIPS-180-2:
    ("" 0 "abc"
     "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
    ("" 0 "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
     "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1")
#;    ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" 10000 ""
     "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0")
   ))

(define (test)

  (define (test algorithm vectors)

    (display "*** ====================== testing ")
    (write algorithm)
    (display " ======================\n")

    (for-each
     (lambda (v)
       (let ((str1 (car v))
             (repeat (cadr v))
             (str2 (caddr v))
             (expect (cadddr v)))
         (let ((md
                (if (= repeat 0)
                    (digest-string str2 algorithm)
                    (let ((u8vect1
                           (list->u8vector
                            (map char->integer (string->list str1))))
                          (u8vect2
                           (list->u8vector
                            (map char->integer (string->list str2))))
                          (digest
                           (open-digest algorithm)))
                      (let loop ((i 0))
                        (if (< i repeat)
                            (begin
                              (digest-update-subu8vector
                               digest
                               u8vect1
                               0
                               (u8vector-length u8vect1))
                              (loop (+ i 1)))
                            (begin
                              (digest-update-subu8vector
                               digest
                               u8vect2
                               0
                               (u8vector-length u8vect2))
                              (close-digest digest))))))))
           (if (equal? md expect)
               (begin
                 (display "*** passed ")
                 (write v)
                 (newline))
               (error (string-append (symbol->string algorithm)
                                     " hashing error")
                      v
                      md)))))
     vectors)

    (display (string-append "*** passed all "
                            (symbol->string algorithm)
                            " tests\n")))

  (test 'md5 md5-test-vectors)
  (test 'sha-1 sha-1-test-vectors)
  (test 'sha-224 sha-224-test-vectors)
  (test 'sha-256 sha-256-test-vectors)
)

(test))

;==============================================================================

#|
SHA-1 bitwise test vectors (Re: RSA Test)

Jim Gillogly jim at acm.org 
Tue, 23 Feb 1999 09:19:40 -0800
Previous message: Mark Thomas + ECHELON?
Next message: Encrypted sessions
Messages sorted by: [ date ] [ thread ] [ subject ] [ author ]
"Hani Almansour" <Almansour@bigfoot.com> wrote:
> I have implementation for RSA, SHA, MD5 and I want to test it. is there a
> fast way to test the output of any one of these encryption or if there is a
> program that test the output.

For the basic SHA-1 and MD5 you can use the test vectors published in
the specifications to see whether you have the basic idea right.
However, there are a lot of places to go wrong if you're implementing
the full SHA-1, which is defined for arbitrary bit strings.  Francois
Grieu and I have agreed on a number of SHA-1 bit strings and their hashes
to test problem areas where the internal buffers fill and roll over.  This
should shake out most of your bugs.

In the following we use the notation bitstring#n to mean a bitstring
repeated n (in decimal) times, and we use | for concatenation.  Therefore
110#3|1 is 1101101101.

110#148|11  : CE7387AE 577337BE 54EA94F8 2C842E8B E76BC3E1
110#149     : DE244F06 3142CB2F 4C903B7F 7660577F 9E0D8791
110#149|1   : A3D29824 27AE39C8 920CA5F4 99D6C2BD 71EBF03C
110#149|11  : 351AAB58 FF93CF12 AF7D5A58 4CFC8F7D 81023D10

110#170     : 99638692 1E480D4E 2955E727 5DF3522C E8F5AB6E
110#170|1   : BB5F4AD4 8913F51B 157EB985 A5C2034B 8243B01B
110#170|11  : 9E92C554 2237B957 BA2244E8 141FDB66 DEC730A5
110#171     : 2103E454 DA4491F4 E32DD425 A3341DC9 C2A90848

011#490     : B4B18049 DE405027 528CD9E7 4B2EC540 D4E6F06B
011#490|0   : 34C63356 B3087427 20AB9669 14EB0FC9 26E4294B
011#490|01  : 75FACE18 02B9F84F 326368AB 06E73E05 02E9EA34
011#491     : 7C2C3D62 F6AEC28D 94CDF93F 02E739E7 490698A1

Here is a set near 2^32 bits to test the roll-over in the length
field from one to two 32-bit words:

110#1431655764|11 1eef5a18 969255a3 b1793a2a 955c7ec2 8cd221a5
110#1431655765|   7a1045b9 14672afa ce8d90e6 d19b3a6a da3cb879
110#1431655765|1  d5e09777 a94f1ea9 240874c4 8d9fecb6 b634256b
110#1431655765|11 eb256904 3c3014e5 1b2862ae 6eb5fb4e 0b851d99

011#1431655764|01 4CB0C4EF 69143D5B F34FC35F 1D4B19F6 ECCAE0F2
011#1431655765    47D92F91 1FC7BB74 DE00ADFC 4E981A81 05556D52
011#1431655765|0  A3D7438C 589B0B93 2AA91CC2 446F06DF 9ABC73F0
011#1431655765|01 3EEE3E1E 28DEDE2C A444D68D A5675B2F AAAB3203

There are lots of cases where one might go wrong, so if you're
likely to do a partial-byte implementation you might want to
hang onto these test vectors, which were performed with quite
different implementations.

-- 
	Jim Gillogly
	Sterday, 3 Rethe S.R. 1999, 17:11
	12.19.5.17.8, 9 Lamat 1 Kayab, Sixth Lord of Night


Previous message: Mark Thomas + ECHELON?
Next message: Encrypted sessions
Messages sorted by: [ date ] [ thread ] [ subject ] [ author ]
|#
