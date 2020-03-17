;;;============================================================================

;;; File: "_std.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Implementation of exceptions.

(implement-library-type-length-mismatch-exception)

(define-prim (##raise-length-mismatch-exception arg-num proc . args);;;;;;;;;;;
  (##extract-procedure-and-arguments
   proc
   args
   arg-num
   #f
   #f
   (lambda (procedure arguments arg-num dummy1 dummy2)
     (macro-raise
      (macro-make-length-mismatch-exception procedure arguments arg-num)))))

;;;----------------------------------------------------------------------------

;; Definition of vector-like data types (i.e. string, vector, s8vector, ...).

(macro-case-target
 ((C)
  (c-declare "#include \"os.h\"")))

(define-prim-vector-procedures
  string
  #\nul
  macro-force-vars
  macro-check-char
  macro-check-char-list
  macro-test-char
  ##fail-check-char
  define-map-and-for-each
  ##char=?)

(define-prim-vector-procedures
  vector
  0
  macro-no-force
  macro-no-check
  macro-no-check
  #f
  #f
  define-map-and-for-each
  ##equal?)

(define-prim-vector-procedures
  s8vector
  0
  macro-force-vars
  macro-check-exact-signed-int8
  macro-check-exact-signed-int8-list
  macro-test-exact-signed-int8
  ##fail-check-exact-signed-int8
  #f
  ##fx=)

(define-prim-vector-procedures
  u8vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int8
  macro-check-exact-unsigned-int8-list
  macro-test-exact-unsigned-int8
  ##fail-check-exact-unsigned-int8
  #f
  ##fx=)

(define-prim-vector-procedures
  s16vector
  0
  macro-force-vars
  macro-check-exact-signed-int16
  macro-check-exact-signed-int16-list
  macro-test-exact-signed-int16
  ##fail-check-exact-signed-int16
  #f
  ##fx=)

(define-prim-vector-procedures
  u16vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int16
  macro-check-exact-unsigned-int16-list
  macro-test-exact-unsigned-int16
  ##fail-check-exact-unsigned-int16
  #f
  ##fx=)

(define-prim-vector-procedures
  s32vector
  0
  macro-force-vars
  macro-check-exact-signed-int32
  macro-check-exact-signed-int32-list
  macro-test-exact-signed-int32
  ##fail-check-exact-signed-int32
  #f
  ##eqv?)

(define-prim-vector-procedures
  u32vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int32
  macro-check-exact-unsigned-int32-list
  macro-test-exact-unsigned-int32
  ##fail-check-exact-unsigned-int32
  #f
  ##eqv?)

(define-prim-vector-procedures
  s64vector
  0
  macro-force-vars
  macro-check-exact-signed-int64
  macro-check-exact-signed-int64-list
  macro-test-exact-signed-int64
  ##fail-check-exact-signed-int64
  #f
  ##eqv?)

(define-prim-vector-procedures
  u64vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int64
  macro-check-exact-unsigned-int64-list
  macro-test-exact-unsigned-int64
  ##fail-check-exact-unsigned-int64
  #f
  ##eqv?)

(define-prim-vector-procedures
  f32vector
  0.
  macro-force-vars
  macro-check-inexact-real
  macro-check-inexact-real-list
  macro-test-inexact-real
  ##fail-check-inexact-real
  #f
  ##fleqv?)

(define-prim-vector-procedures
  f64vector
  0.
  macro-force-vars
  macro-check-inexact-real
  macro-check-inexact-real-list
  macro-test-inexact-real
  ##fail-check-inexact-real
  #f
  ##fleqv?)

(define-prim (##vector-cas! vect k val oldval)
  ;;TODO: remove after bootstrap
  (##declare (not interrupts-enabled))
  (let ((result (##vector-ref vect k)))
    (if (##eq? result oldval)
        (##vector-set! vect k val))
    result))

(define-prim (vector-cas! vect k val oldval)
  (macro-force-vars (vect k oldval)
    (macro-check-vector vect 1 (vector-cas! vect k val oldval)
      (macro-check-mutable vect 1 (vector-cas! vect k val oldval)
        (macro-check-index-range
          k
          2
          0
          (##vector-length vect)
          (vector-cas! vect k val oldval)
          (##vector-cas! vect k val oldval))))))

(define-prim (##vector-inc! vect k #!optional (val 1))
  ;;TODO: remove after bootstrap
  (##declare (not interrupts-enabled))
  (let ((result (##vector-ref vect k)))
    (##vector-set! vect k (##fxwrap+ result val))
    result))

(define-prim (vector-inc! vect k #!optional (v (macro-absent-obj)))
  (macro-force-vars (vect k v)
    (macro-check-vector vect 1 (vector-inc! vect k v)
      (macro-check-mutable vect 1 (vector-inc! vect k v)
        (macro-check-index-range
          k
          2
          0
          (##vector-length vect)
          (vector-inc! vect k v)
          (let ((val (if (##eq? v (macro-absent-obj)) 1 v)))
            (macro-check-fixnum
              val
              3
              (vector-inc! vect k v)
              (let ((elem (##vector-ref vect k)))
                (macro-check-fixnum
                  elem
                  1
                  (vector-inc! vect k v)
                  (##vector-inc! vect k val))))))))))

(define bytevector?        u8vector?)
(define make-bytevector    make-u8vector)
(define bytevector         u8vector)
(define bytevector-length  u8vector-length)
(define bytevector-u8-ref  u8vector-ref)
(define bytevector-u8-set! u8vector-set!)
(define bytevector-copy    u8vector-copy)
(define bytevector-copy!   u8vector-copy!)
(define bytevector-append  u8vector-append)

;;;----------------------------------------------------------------------------

;; UTF-8 encoding and decoding

(implement-library-type-invalid-utf8-encoding-exception)

(define-prim (##raise-invalid-utf8-encoding-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-invalid-utf8-encoding-exception
       procedure
       arguments)))))

(define-prim (##string->utf8-length
              str
              #!optional
              (start 0)
              (end (##string-length str)))
  (let loop ((i start)
             (len 0))
    (if (##fx< i end)
        (let ((c (##char->integer (##string-ref str i))))
          (cond ((##fx<= c #x7f)
                 ;; 1 byte encoding (ASCII)
                 (loop (##fx+ i 1)
                       (##fx+ len 1)))
                ((##fx<= c #x7ff)
                 ;; 2 byte encoding
                 (loop (##fx+ i 1)
                       (##fx+ len 2)))
                ((##fx<= c #xffff)
                 ;; 3 byte encoding
                 (loop (##fx+ i 1)
                       (##fx+ len 3)))
                (else
                 ;; 4 byte encoding
                 (loop (##fx+ i 1)
                       (##fx+ len 4)))))
        len)))

(define-prim (##string->utf8
              str
              #!optional
              (start 0)
              (end (##string-length str)))
  (let* ((len (##string->utf8-length str start end))
         (result (##make-u8vector len)))
    (if (##fx= len (##fx- end start))
        (let loop1 ((i 0))
          (if (##fx< i end)
              (begin
                (##u8vector-set!
                 result
                 i
                 (##char->integer
                  (##string-ref str (##fx+ start i))))
                (loop1 (##fx+ i 1)))
              result))
        (let loop2 ((i start)
                    (j 0))
          (if (and (##fx< i end)
                   (##fx< j len)) ;; account for str mutation by other thread
              (let ((c (##char->integer (##string-ref str i))))
                (cond ((##fx<= c #x7f)
                       ;; 1 byte encoding (ASCII)
                       (##u8vector-set! result j c)
                       (loop2 (##fx+ i 1)
                              (##fx+ j 1)))
                      ((##fx<= c #x7ff)
                       ;; 2 byte encoding
                       (##u8vector-set!
                        result
                        j
                        (##fx+ #xc0 (##fxarithmetic-shift-right c 6)))
                       (##u8vector-set!
                        result
                        (##fx+ j 1)
                        (##fx+ #x80 (##fxand #x3f c)))
                       (loop2 (##fx+ i 1)
                              (##fx+ j 2)))
                      ((##fx<= c #xffff)
                       ;; 3 byte encoding
                       (##u8vector-set!
                        result
                        j
                        (##fx+ #xe0 (##fxarithmetic-shift-right c 12)))
                       (##u8vector-set!
                        result
                        (##fx+ j 1)
                        (##fx+ #x80 (##fxand #x3f (##fxarithmetic-shift-right c 6))))
                       (##u8vector-set!
                        result
                        (##fx+ j 2)
                        (##fx+ #x80 (##fxand #x3f c)))
                       (loop2 (##fx+ i 1)
                              (##fx+ j 3)))
                      (else
                       ;; 4 byte encoding
                       (##u8vector-set!
                        result
                        j
                        (##fx+ #xf0 (##fxarithmetic-shift-right c 18)))
                       (##u8vector-set!
                        result
                        (##fx+ j 1)
                        (##fx+ #x80 (##fxand #x3f (##fxarithmetic-shift-right c 12))))
                       (##u8vector-set!
                        result
                        (##fx+ j 2)
                        (##fx+ #x80 (##fxand #x3f (##fxarithmetic-shift-right c 6))))
                       (##u8vector-set!
                        result
                        (##fx+ j 3)
                        (##fx+ #x80 (##fxand #x3f c)))
                       (loop2 (##fx+ i 1)
                              (##fx+ j 4)))))
              result)))))

(define-prim (string->utf8
              str
              #!optional
              (start (macro-absent-obj))
              (end (macro-absent-obj)))
  (macro-force-vars (str start end)
    (macro-check-string
      str
      1
      (string->utf8 str start end)
      (if (##eq? start (macro-absent-obj))
          (##string->utf8 str)
          (macro-check-index-range-incl
            start
            2
            0
            (##string-length str)
            (string->utf8 str start end)
            (if (##eq? end (macro-absent-obj))
                (##string->utf8 str start)
                (macro-check-index-range-incl
                  end
                  3
                  start
                  (##string-length str)
                  (string->utf8 str start end)
                  (##string->utf8 str start end))))))))

(define-prim (##utf8->string-length
              u8vect
              #!optional
              (start 0)
              (end (##u8vector-length u8vect)))
  (let loop ((i start)
             (len 0))
    (if (##fx< i end)
        (let ((b0 (##u8vector-ref u8vect i)))
          (cond ((##fx< b0 #x80)
                 ;; 1 byte encoding (ASCII)
                 (loop (##fx+ i 1)
                       (##fx+ len 1)))
                ((##fx< b0 #xe0)
                 ;; 2 byte encoding or invalid encoding
                 (loop (##fx+ i 2)
                       (##fx+ len 1)))
                ((##fx< b0 #xf0)
                 ;; 3 byte encoding or invalid encoding
                 (loop (##fx+ i 3)
                       (##fx+ len 1)))
                (else
                 ;; 4 byte encoding or invalid encoding
                 (loop (##fx+ i 4)
                       (##fx+ len 1)))))
        (if (##fx> i end)
            0 ;; invalid or truncated encoding
            len))))

(define-prim (##utf8->string
              u8vect
              #!optional
              (start 0)
              (end (##u8vector-length u8vect)))

  (define (invalid-utf8)
    (##raise-invalid-utf8-encoding-exception utf8->string u8vect start end))

  (let* ((len (##utf8->string-length u8vect start end))
         (result (##make-string len)))
    (if (##fx= len (##fx- end start))
        (let loop1 ((i 0))
          (if (##fx< i end)
              (begin
                (##string-set!
                 result
                 i
                 (##integer->char
                  (##u8vector-ref u8vect (##fx+ start i))))
                (loop1 (##fx+ i 1)))
              result))
        (let loop2 ((i start)
                    (j 0))
          (if (##fx< i end)
              (if (##fx< j len) ;; account for u8vect mutation by other thread
                  (let ((b0 (##u8vector-ref u8vect i)))
                    (cond ((##fx< b0 #x80)
                           ;; 1 byte encoding (ASCII)
                           (##string-set!
                            result
                            j
                            (##integer->char b0))
                           (loop2 (##fx+ i 1)
                                  (##fx+ j 1)))
                          ((##fx< b0 #xc2)
                           (invalid-utf8))
                          ((##fx< b0 #xe0)
                           ;; 2 byte encoding
                           (let* ((b1 (##u8vector-ref
                                       u8vect
                                       (##fx+ i 1)))
                                  (n (##fx+
                                      (##fxarithmetic-shift-left
                                       (##fxand b0 #x1f)
                                       6)
                                      (##fxand b1 #x3f))))
                             (if (and (##fx= (##fxand b1 #xc0)
                                             #x80)
                                      (##fx>= n #x80))
                                 (begin
                                   (##string-set!
                                    result
                                    j
                                    (##integer->char n))
                                   (loop2 (##fx+ i 2)
                                          (##fx+ j 1)))
                                 (invalid-utf8))))
                          ((##fx< b0 #xf0)
                           ;; 3 byte encoding
                           (let* ((b1 (##u8vector-ref
                                       u8vect
                                       (##fx+ i 1)))
                                  (b2 (##u8vector-ref
                                       u8vect
                                       (##fx+ i 2)))
                                  (n (##fx+
                                      (##fxarithmetic-shift-left
                                       (##fxand b0 #x0f)
                                       12)
                                      (##fxarithmetic-shift-left
                                       (##fxand b1 #x3f)
                                       6)
                                      (##fxand b2 #x3f))))
                             (if (and (##fx= (##fxand (##fxior b1
                                                               b2)
                                                      #xc0)
                                             #x80)
                                      (##fx>= n #x800)
                                      (##not
                                       (and (##fx>= n #xd800)
                                            (##fx<= n #xdfff))))
                                 (begin
                                   (##string-set!
                                    result
                                    j
                                    (##integer->char n))
                                   (loop2 (##fx+ i 3)
                                          (##fx+ j 1)))
                                 (invalid-utf8))))
                          ((##fx< b0 #xf5)
                           ;; 4 byte encoding
                           (let* ((b1 (##u8vector-ref
                                       u8vect
                                       (##fx+ i 1)))
                                  (b2 (##u8vector-ref
                                       u8vect
                                       (##fx+ i 2)))
                                  (b3 (##u8vector-ref
                                       u8vect
                                       (##fx+ i 3)))
                                  (n (##fx+
                                      (##fxarithmetic-shift-left
                                       (##fxand b0 #x07)
                                       18)
                                      (##fxarithmetic-shift-left
                                       (##fxand b1 #x3f)
                                       12)
                                      (##fxarithmetic-shift-left
                                       (##fxand b2 #x3f)
                                       6)
                                      (##fxand b3 #x3f))))
                             (if (and (##fx= (##fxand (##fxior b1
                                                               b2
                                                               b3)
                                                      #xc0)
                                             #x80)
                                      (##fx>= n #x10000)
                                      (##fx<= n #x10ffff))
                                 (begin
                                   (##string-set!
                                    result
                                    j
                                    (##integer->char n))
                                   (loop2 (##fx+ i 4)
                                          (##fx+ j 1)))
                                 (invalid-utf8))))
                          (else
                           (invalid-utf8))))
                  (invalid-utf8))
              (if (or (##fx> i end)
                      (##fx< j len))
                  (invalid-utf8)
                  result))))))

(define-prim (utf8->string
              u8vect
              #!optional
              (start (macro-absent-obj))
              (end (macro-absent-obj)))
  (macro-force-vars (u8vect start end)
    (macro-check-u8vector
      u8vect
      1
      (utf8->string u8vect start end)
      (if (##eq? start (macro-absent-obj))
          (##utf8->string u8vect)
          (macro-check-index-range-incl
            start
            2
            0
            (##u8vector-length u8vect)
            (utf8->string u8vect start end)
            (if (##eq? end (macro-absent-obj))
                (##utf8->string u8vect start)
                (macro-check-index-range-incl
                  end
                  3
                  start
                  (##u8vector-length u8vect)
                  (utf8->string u8vect start end)
                  (##utf8->string u8vect start end))))))))

;;;----------------------------------------------------------------------------

;; IEEE Scheme procedures:

(define-prim (##not obj)
  (if obj #f #t))

(define-prim (not obj)
  (macro-force-vars (obj)
    (##not obj)))

(define-fail-check-type boolean 'boolean)

(define-prim (##boolean? obj)
  (or (##eq? obj #t) (##eq? obj #f)))

(define-prim (boolean? obj)
  (macro-force-vars (obj)
    (##boolean? obj)))

;; eqv? is defined in "_num.scm"
;; eq? and equal? are defined in "_system.scm"

(define-fail-check-type mutable 'mutable)
(define-fail-check-type pair 'pair)
(define-fail-check-type pair-list 'pair-list)
(define-fail-check-type list 'list)

(define-prim (##mutable? obj))

(define-prim (##pair? obj))

(define-prim (pair? obj)
  (macro-force-vars (obj)
    (##pair? obj)))

(define-prim (##cons obj1 obj2))

(define-prim (cons obj1 obj2)
  (##cons obj1 obj2))

(##define-macro (define-prim-c...r-procedures from-length to-length)

  (define (gen-name pattern)

    (define (ads pattern)
      (if (= pattern 1)
          ""
          (string-append (ads (quotient pattern 2))
                         (if (odd? pattern) "d" "a"))))

    (string->symbol (string-append "c" (ads pattern) "r")))

  (define (gen3 i j)
    (if (> i j)
        `()
        (let* ((name
                (gen-name i))
               (##name
                (string->symbol (string-append "##" (symbol->string name)))))

          (define (gen1 var pattern)
            (if (<= pattern 3)
                (if (= pattern 3) `(##cdr ,var) `(##car ,var))
                `(let ((x ,(if (odd? pattern) `(##cdr ,var) `(##car ,var))))
                   ,(gen1 'x (quotient pattern 2)))))

          (define (gen2 var pattern)
            `(macro-check-pair ,var 1 (,name pair);;;;;;error message confusing?
               ,(if (<= pattern 3)
                    (if (= pattern 3) `(##cdr ,var) `(##car ,var))
                    `(let ((x ,(if (odd? pattern) `(##cdr ,var) `(##car ,var))))
                       (macro-force-vars (x)
                         ,(gen2 'x (quotient pattern 2)))))))

          `((define-prim (,##name pair)
              ,(gen1 'pair i))

            (define-prim (,name pair)
              (macro-force-vars (pair)
                ,(gen2 'pair i)))

            ,@(gen3 (+ i 1) j)))))

  `(begin ,@(gen3 (expt 2 from-length) (- (expt 2 (+ to-length 1)) 1))))

(define-prim-c...r-procedures 1 4) ;; define car to cddddr

(define-prim (##set-car! pair val))

(define-prim (set-car! pair val)
  (macro-force-vars (pair)
    (macro-check-pair pair 1 (set-car! pair val)
      (macro-check-mutable pair 1 (set-car! pair val)
        (begin
          (##set-car! pair val)
          (##void))))))

(define-prim (##set-cdr! pair val))

(define-prim (set-cdr! pair val)
  (macro-force-vars (pair)
    (macro-check-pair pair 1 (set-cdr! pair val)
      (macro-check-mutable pair 1 (set-cdr! pair val)
        (begin
          (##set-cdr! pair val)
          (##void))))))

(define-prim (##null? obj)
  (##eq? obj '()))

(define-prim (null? obj)
  (macro-force-vars (obj)
    (##null? obj)))

(define-prim (##list? lst)
  ;; This procedure may get into an infinite loop if another thread
  ;; mutates "lst" (if lst1 and lst2 each point to disconnected cycles).
  (let loop ((lst1 lst) (lst2 lst))
    (macro-force-vars (lst1)
      (if (##not (##pair? lst1))
          (##null? lst1)
          (let ((lst1 (##cdr lst1)))
            (macro-force-vars (lst1 lst2)
              (cond ((##eq? lst1 lst2)
                     #f)
                    ((##not (##pair? lst2))
                     ;; this case is possible if other threads mutate the list
                     (##null? lst2))
                    ((##pair? lst1)
                     (loop (##cdr lst1) (##cdr lst2)))
                    (else
                     (##null? lst1)))))))))

(define-prim (list? lst)
  (##list? lst))

(define-prim (##list . lst)
  lst)

(define-prim (list . lst)
  lst)

(define-prim (##length lst)
  (let loop ((x lst) (n 0))
    (if (##pair? x)
        (loop (##cdr x) (##fx+ n 1))
        n)))

(define-prim (length lst)
  (let loop ((x lst) (n 0))
    (macro-force-vars (x)
      (if (##pair? x)
          (loop (##cdr x) (##fx+ n 1))
          (macro-check-list x 1 (length lst)
            n)))))

(define-prim (##append2 lst1 lst2)
  (if (##pair? lst1)
      (##cons (##car lst1) (##append2 (##cdr lst1) lst2))
      lst2))

(define-prim (##append-lists lst)
  (if (##pair? lst)
      (let ((rev-lst (##reverse lst)))
        (let loop ((rev-lst (##cdr rev-lst)) (result (##car rev-lst)))
          (if (##pair? rev-lst)
              (loop (##cdr rev-lst)
                    (##append2 (##car rev-lst) result))
              result)))
      '()))

(define-prim (##append
              #!optional
              (lst1 (macro-absent-obj))
              (lst2 (macro-absent-obj))
              #!rest
              others)
  (if (##eq? lst2 (macro-absent-obj))
      (if (##eq? lst1 (macro-absent-obj))
          '()
          lst1)
      (##append-lists (##cons lst1 (##cons lst2 others)))))

(define-prim (append
              #!optional
              (lst1 (macro-absent-obj))
              (lst2 (macro-absent-obj))
              #!rest
              others)

  (define (append-multiple head tail arg-num)
    (if (##null? tail)
        head
        (macro-force-vars (head)
          (if (##null? head)
              (append-multiple (##car tail) (##cdr tail) (##fx+ arg-num 1))
              (list-expected-check
               (append-multiple-non-null head
                                         tail
                                         arg-num
                                         (##fx+ arg-num 1)))))))

  (define (append-multiple-non-null x lsts arg-num1 arg-num2)
    ;; x!=(), returns fixnum on error
    (let ((head (##car lsts))
          (tail (##cdr lsts)))
      (if (##null? tail)
          (append-2-non-null x head arg-num1)
          (macro-force-vars (head)
            (if (##null? head)
                (append-multiple-non-null x
                                          tail
                                          arg-num1
                                          (##fx+ arg-num2 1))
                (let ((result
                       (append-multiple-non-null head
                                                 tail
                                                 arg-num2
                                                 (##fx+ arg-num2 1))))
                  (macro-if-checks
                   (if (##fixnum? result)
                       result
                       (append-2-non-null x result arg-num1))
                   (append-2-non-null x result arg-num1))))))))

  (define (append-2-non-null x y arg-num)
    ;; x!=(), returns fixnum on error
    (if (##pair? x)
        (let ((result (##cons (##car x) '())))
          (let loop ((last result) (tail (##cdr x)))
            (macro-force-vars (tail)
              (if (##pair? tail)
                  (let ((next (##cons (##car tail) '())))
                    (##set-cdr! last next)
                    (loop next (##cdr tail)))
                  (begin
                    (##set-cdr! last y)
                    (macro-if-checks
                     (if (##null? tail)
                         result
                         arg-num) ;; error: list expected
                     result))))))
        (macro-if-checks
         arg-num ;; error: list expected
         y)))

  (define (list-expected-check result)
    (macro-if-checks
     (if (##fixnum? result)
         (macro-fail-check-list result (append lst1 lst2 . others))
         result)
     result))

  (cond ((##eq? lst2 (macro-absent-obj))
         (if (##eq? lst1 (macro-absent-obj))
             '()
             lst1))
        ((##null? others)
         (macro-force-vars (lst1)
           (if (##null? lst1)
               lst2
               (list-expected-check (append-2-non-null lst1 lst2 1)))))
        (else
         (append-multiple lst1 (##cons lst2 others) 1))))

(define-prim (##reverse lst)
  (let loop ((x lst) (result '()))
    (if (##pair? x)
        (loop (##cdr x) (##cons (##car x) result))
        result)))

(define-prim (reverse lst)
  (let loop ((x lst) (result '()))
    (macro-force-vars (x)
      (if (##pair? x)
          (loop (##cdr x) (##cons (##car x) result))
          (macro-check-list x 1 (reverse lst)
            result)))))

(define-prim (##list-ref lst k)
  (let loop ((x lst) (i k))
    (if (##fx< 0 i)
        (loop (##cdr x) (##fx- i 1))
        (##car x))))

(define-prim (list-ref lst k)
  (macro-force-vars (k)
    (macro-check-index k 2 (list-ref lst k)
      (let loop ((x lst) (i k))
        (macro-force-vars (x)
          (macro-check-pair x 1 (list-ref lst k);;;;;;;error message confusing?
            (if (##fx< 0 i)
                (loop (##cdr x) (##fx- i 1))
                (##car x))))))))

(define-prim (##list-set! lst k val)
  (let loop ((x lst) (i k))
    (if (##fx< 0 i)
        (loop (##cdr x) (##fx- i 1))
        (begin
          (##set-car! x val)
          (##void)))))

(define-prim (list-set! lst k val)
  (macro-force-vars (k)
    (macro-check-index k 2 (list-set! lst k val)
      (let loop ((x lst) (i k))
        (macro-force-vars (x)
          (macro-check-pair x 1 (list-set! lst k val)
            (if (##fx< 0 i)
                (loop (##cdr x) (##fx- i 1))
                (macro-check-mutable x 1 (list-set! lst k val)
                  (begin
                    (##set-car! x val)
                    (##void))))))))))

(define-prim (##list-set lst k val)

  (define (set x i)
    (if (##fx< 0 i)
        (##cons (##car x) (set (##cdr x) (##fx- i 1)))
        (##cons val (##cdr x))))

  (set lst k))

(define-prim (list-set lst k val)
  (macro-force-vars (k)
    (macro-check-index k 2 (list-set lst k val)

      (let ()

        (define (set x i)
          (macro-force-vars (x)
            (if (##pair? x)
                (if (##fx< 0 i)
                    (let ((r (set (##cdr x) (##fx- i 1))))
                      (if (##pair? r)
                          (##cons (##car x) r)
                          r))
                    (##cons val (##cdr x)))
                #f)))

        (or (set lst k)
            (##fail-check-pair 1 list-set lst k val))))))

(define-prim (##memq obj lst)
  (let loop ((x lst))
    (if (##pair? x)
        (if (##eq? obj (##car x))
            x
            (loop (##cdr x)))
        #f)))

(define-prim (memq obj lst)
  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (##pair? x)
            (let ((y (##car x)))
              (macro-force-vars (y)
                (if (##eq? obj y)
                    x
                    (loop (##cdr x)))))
            (macro-check-list x 2 (memq obj lst)
              #f))))))

(define-prim (##memv obj lst)
  (let loop ((x lst))
    (if (##pair? x)
        (if (let ()
              (##declare (generic)) ;; avoid fixnum specific ##eqv?
              (##eqv? obj (##car x)))
            x
            (loop (##cdr x)))
        #f)))

(define-prim (memv obj lst)
  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (##pair? x)
            (let ((y (##car x)))
              (macro-force-vars (y)
                (if (let ()
                      (##declare (generic)) ;; avoid fixnum specific ##eqv?
                      (##eqv? obj y))
                    x
                    (loop (##cdr x)))))
            (macro-check-list x 2 (memv obj lst)
              #f))))))

(define-prim (##member obj lst #!optional (compare ##equal?))
  (let loop ((x lst))
    (if (##pair? x)
        (if (compare obj (##car x))
            x
            (loop (##cdr x)))
        #f)))

(define-prim (member obj lst #!optional (c (macro-absent-obj)))
  (macro-force-vars (c)
    (let ((compare (if (##eq? c (macro-absent-obj)) ##equal? c)))
      (macro-check-procedure compare 3 (member obj lst c)
        (let loop ((x lst))
          (macro-force-vars (x)
            (if (##pair? x)
                (let ((y (##car x)))
                  (if (compare obj y)
                      x
                      (loop (##cdr x))))
                (macro-check-list x 2 (member obj lst c)
                  #f))))))))

;; ##assq defined in _kernel.scm

(define-prim (assq obj lst)
  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (##pair? x)
            (let ((couple (##car x)))
              (macro-force-vars (couple)
                (macro-check-pair-list couple 2 (assq obj lst)
                  (let ((y (##car couple)))
                    (macro-force-vars (y)
                      (if (##eq? obj y)
                          couple
                          (loop (##cdr x))))))))
            (macro-check-list x 2 (assq obj lst)
              #f))))))

(define-prim (##assv obj lst)
  (let loop ((x lst))
    (if (##pair? x)
        (let ((couple (##car x)))
          (if (let ()
                (##declare (generic)) ;; avoid fixnum specific ##eqv?
                (##eqv? obj (##car couple)))
              couple
              (loop (##cdr x))))
        #f)))

(define-prim (assv obj lst)
  (macro-force-vars (obj)
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (##pair? x)
            (let ((couple (##car x)))
              (macro-force-vars (couple)
                (macro-check-pair-list couple 2 (assv obj lst)
                  (let ((y (##car couple)))
                    (macro-force-vars (y)
                      (if (let ()
                            (##declare (generic)) ;; avoid fixnum specific ##eqv?
                            (##eqv? obj y))
                          couple
                          (loop (##cdr x))))))))
            (macro-check-list x 2 (assv obj lst)
              #f))))))

(define-prim (##assoc obj lst #!optional (compare ##equal?))
  (let loop ((x lst))
    (if (##pair? x)
        (let ((couple (##car x)))
          (if (compare obj (##car couple))
              couple
              (loop (##cdr x))))
        #f)))

(define-prim (assoc obj lst #!optional (c (macro-absent-obj)))
  (macro-force-vars (c)
    (let ((compare (if (##eq? c (macro-absent-obj)) ##equal? c)))
      (macro-check-procedure compare 3 (assoc obj lst c)
        (let loop ((x lst))
          (macro-force-vars (x)
            (if (##pair? x)
                (let ((couple (##car x)))
                  (macro-force-vars (couple)
                    (macro-check-pair-list couple 2 (assoc obj lst c)
                      (let ((y (##car couple)))
                        (if (compare obj y)
                            couple
                            (loop (##cdr x)))))))
                (macro-check-list x 2 (assoc obj lst c)
                  #f))))))))

(define-prim (##remq elem lst)

  (define (rem elem lst)
    (if (##pair? lst)
        (let* ((lst2 (rem elem (##cdr lst)))
               (x (##car lst)))
          (if (##eq? x elem)
              lst2
              (if (##eq? lst2 (##cdr lst))
                  lst
                  (##cons x lst2))))
        '()))

  (rem elem lst))

(define-fail-check-type symbol 'symbol)

(define-prim (##make-uninterned-symbol name hash))
(define-prim (##symbol-name sym))
(define-prim (##symbol-name-set! sym name))
(define-prim (##symbol-hash sym))
(define-prim (##symbol-hash-set! sym hash))
(define-prim (##symbol-interned? sym))
(define-prim (##symbol? obj))

(define-prim (symbol? obj)
  (macro-force-vars (obj)
    (##symbol? obj)))

(define-prim (##symbol->string sym)
  (let ((name (##symbol-name sym)))
    (if (##fixnum? name)
        (let ((str (##string-append "g" (##number->string name 10))))
          (##declare (not interrupts-enabled))
          (let ((name (##symbol-name sym)))
            ;; Double-check in case a different thread has also called
            ;; and completed the call to ##symbol->string on this symbol.
            (if (##fixnum? name)
                (begin
                  (##symbol-name-set! sym str)
                  str)
                name)))
        name)))

(define-prim (symbol->string sym)
  (macro-force-vars (sym)
    (macro-check-symbol sym 1 (symbol->string sym)
      (##symbol->string sym))))

(define-prim (##string->symbol str)
  (##make-interned-symbol str))

(define-prim (string->symbol str)
  (macro-force-vars (str)
    (macro-check-string str 1 (string->symbol str)
      (##string->symbol str))))

(define-prim (##uninterned-symbol? obj)
  (and (##symbol? obj)
       (##not (##symbol-interned? obj))))

(define-prim (uninterned-symbol? obj)
  (macro-force-vars (obj)
    (##uninterned-symbol? obj)))

(define ##symbol-counter 0)

(define-prim (##string->uninterned-symbol
              str
              #!optional
              (hash (macro-absent-obj)))

  ;; str must be a nonmutable string

  (if (##eq? hash (macro-absent-obj))
      (let ((n (##fxwrap+ ##symbol-counter 1)))
        ;; Note: it is unimportant if the increment of ##symbol-counter
        ;; is not atomic; it simply means a possible close repetition
        ;; of the same hash code.  The counter will wrap around eventually.
        (set! ##symbol-counter n)
        (##make-uninterned-symbol str (##partial-bit-reverse n)))
      (##make-uninterned-symbol str hash)))

(define-prim (string->uninterned-symbol
              str
              #!optional
              (hash (macro-absent-obj)))
  (macro-force-vars (str hash)
    (macro-check-string str 1 (string->uninterned-symbol str hash)
      (if (##eq? hash (macro-absent-obj))
          (##string->uninterned-symbol str)
          (macro-check-fixnum-range-incl hash 2 0 536870911 (string->uninterned-symbol str hash)
            (##string->uninterned-symbol str hash))))))

;; Number related procedures are in "_num.scm"

;; define Unicode related macros

(##include "_unicode#.scm")

(macro-implement-unicode-tables)

(define-fail-check-type char 'char)
(define-fail-check-type char-list 'char-list)
(define-fail-check-type char-vector 'char-vector)

(define-prim (##char? obj))

(define-prim (char? obj)
  (macro-force-vars (obj)
    (##char? obj)))

(define-prim-nary-bool (##char=? x y)
  #t
  #t
  (##char=? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char=? x y)
  #t
  #t
  (##char=? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char<? x y)
  #t
  #t
  (##char<? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char<? x y)
  #t
  #t
  (##char<? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char>? x y)
  #t
  #t
  (##char<? y x)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char>? x y)
  #t
  #t
  (##char<? y x)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char<=? x y)
  #t
  #t
  (##not (##char<? y x))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char<=? x y)
  #t
  #t
  (##not (##char<? y x))
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char>=? x y)
  #t
  #t
  (##not (##char<? x y))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char>=? x y)
  #t
  #t
  (##not (##char<? x y))
  macro-force-vars
  macro-check-char)

(##define-macro (macro-char-ci=? x y)
  `(##char=? (##char-foldcase ,x) (##char-foldcase ,y)))

(##define-macro (macro-char-ci<? x y)
  `(##char<? (##char-foldcase ,x) (##char-foldcase ,y)))

(define-prim-nary-bool (##char-ci=? x y)
  #t
  #t
  (macro-char-ci=? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci=? x y)
  #t
  #t
  (macro-char-ci=? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci<? x y)
  #t
  #t
  (macro-char-ci<? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci<? x y)
  #t
  #t
  (macro-char-ci<? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci>? x y)
  #t
  #t
  (macro-char-ci<? y x)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci>? x y)
  #t
  #t
  (macro-char-ci<? y x)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci<=? x y)
  #t
  #t
  (##not (macro-char-ci<? y x))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci<=? x y)
  #t
  #t
  (##not (macro-char-ci<? y x))
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci>=? x y)
  #t
  #t
  (##not (macro-char-ci<? x y))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci>=? x y)
  #t
  #t
  (##not (macro-char-ci<? x y))
  macro-force-vars
  macro-check-char)

(define-prim (##char-alphabetic? c)
  (macro-char-alphabetic? c))

(define-prim (char-alphabetic? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-alphabetic? c)
      (##char-alphabetic? c))))

(define-prim (##char-numeric? c)
  (macro-char-numeric? c))

(define-prim (char-numeric? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-numeric? c)
      (##char-numeric? c))))

(define-prim (##char-whitespace? c)
  (macro-char-whitespace? c))

(define-prim (char-whitespace? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-whitespace? c)
      (##char-whitespace? c))))

(define-prim (##char-upper-case? c)
  (macro-char-upper-case? c))

(define-prim (char-upper-case? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-upper-case? c)
      (##char-upper-case? c))))

(define-prim (##char-lower-case? c)
  (macro-char-lower-case? c))

(define-prim (char-lower-case? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-lower-case? c)
      (##char-lower-case? c))))

(define-prim (char->integer c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char->integer c)
      (##char->integer c))))

(define-prim (integer->char n)
  (macro-force-vars (n)
    (macro-check-fixnum-range-incl n 1 0 ##max-char (integer->char n)
      (if (or (##fx< n #xd800)
              (##fx< #xdfff n))
          (##integer->char n)
          (##raise-range-exception 1 integer->char n)))))

(define-prim (##char-upcase c)
  (macro-char-upcase c))

(define-prim (char-upcase c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-upcase c)
      (##char-upcase c))))

(define-prim (##char-downcase c)
  (macro-char-downcase c))

(define-prim (char-downcase c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-downcase c)
      (##char-downcase c))))

(define-prim (##char-foldcase c)
  (macro-char-foldcase c))

(define-prim (char-foldcase c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-foldcase c)
      (##char-foldcase c))))

(define-prim (##digit-value c)
  (macro-digit-value c))

(define-prim (digit-value c)
  (macro-force-vars (c)
    (macro-check-char c 1 (digit-value c)
      (##digit-value c))))

(define-prim-nary-bool (##string=? str1 str2)
  #t
  #t
  (##string-equal? str1 str2)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string=? str1 str2)
  #t
  #t
  (##string-equal? str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim (##string<?2 str1 str2)
  (and (##not (##eq? str1 str2))
       (let ((len1 (##string-length str1))
             (len2 (##string-length str2)))
         (let ((n (##fxmin len1 len2)))
           (let loop ((i 0))
             (if (##fx< i n)
                 (let ((c1 (##string-ref str1 i))
                       (c2 (##string-ref str2 i)))
                   (if (##char=? c1 c2)
                       (loop (##fx+ i 1))
                       (##char<? c1 c2)))
                 (##fx< n len2)))))))

(define-prim-nary-bool (##string<? str1 str2)
  #t
  #t
  (##string<?2 str1 str2)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string<? str1 str2)
  #t
  #t
  (##string<?2 str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string>? str1 str2)
  #t
  #t
  (##string<?2 str2 str1)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string>? str1 str2)
  #t
  #t
  (##string<?2 str2 str1)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string<=? str1 str2)
  #t
  #t
  (##not (##string<?2 str2 str1))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string<=? str1 str2)
  #t
  #t
  (##not (##string<?2 str2 str1))
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string>=? str1 str2)
  #t
  #t
  (##not (##string<?2 str1 str2))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string>=? str1 str2)
  #t
  #t
  (##not (##string<?2 str1 str2))
  macro-force-vars
  macro-check-string)

(define-prim (##string-cmp-ci str1 str2)
  (macro-string-cmp-ci str1
                       str2
                       0
                       (##string-length str1)
                       0
                       (##string-length str2)))

(define-prim (##string-ci=?2 str1 str2)
  (or (##eq? str1 str2)
      (##fx= (##string-cmp-ci str1 str2) 0)))

(define-prim-nary-bool (##string-ci=? str1 str2)
  #t
  #t
  (##string-ci=?2 str1 str2)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string-ci=? str1 str2)
  #t
  #t
  (##string-ci=?2 str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim (##string-ci<?2 str1 str2)
  (and (##not (##eq? str1 str2))
       (##fx< (##string-cmp-ci str1 str2) 0)))

(define-prim-nary-bool (##string-ci<? str1 str2)
  #t
  #t
  (##string-ci<?2 str1 str2)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string-ci<? str1 str2)
  #t
  #t
  (##string-ci<?2 str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string-ci>? str1 str2)
  #t
  #t
  (##string-ci<?2 str2 str1)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string-ci>? str1 str2)
  #t
  #t
  (##string-ci<?2 str2 str1)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string-ci<=? str1 str2)
  #t
  #t
  (##not (##string-ci<?2 str2 str1))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string-ci<=? str1 str2)
  #t
  #t
  (##not (##string-ci<?2 str2 str1))
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string-ci>=? str1 str2)
  #t
  #t
  (##not (##string-ci<?2 str1 str2))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string-ci>=? str1 str2)
  #t
  #t
  (##not (##string-ci<?2 str1 str2))
  macro-force-vars
  macro-check-string)

(define (##string-upcase str)
  (let* ((start 0)
         (end (##string-length str))
         (len (##fx- end start))
         (result (##make-string len)))
    (let loop ((i (##fx- len 1)))
      (if (##fx< i 0)
          result
          (begin
            (##string-set! result i (macro-char-upcase (##string-ref str i)))
            (loop (##fx- i 1)))))))

(define-prim (string-upcase str)
  (macro-force-vars (str)
    (macro-check-string
      str
      1
      (string-upcase str)
      (##string-upcase str))))

(define (##string-downcase str)
  (let* ((start 0)
         (end (##string-length str))
         (len (##fx- end start))
         (result (##make-string len)))
    (let loop ((i (##fx- len 1)))
      (if (##fx< i 0)
          result
          (begin
            (##string-set! result i (macro-char-downcase (##string-ref str i)))
            (loop (##fx- i 1)))))))

(define-prim (string-downcase str)
  (macro-force-vars (str)
    (macro-check-string
      str
      1
      (string-downcase str)
      (##string-downcase str))))

(define-prim (##string-foldcase str)
  (macro-string-foldcase str 0 (##string-length str)))

(define-prim (string-foldcase str)
  (macro-force-vars (str)
    (macro-check-string
      str
      1
      (string-foldcase str)
      (##string-foldcase str))))

(define-prim (##copy-string-list lst)

  (define (copy lst i)
    (macro-force-vars (lst)
      (cond ((##pair? lst)
             (let ((str (##car lst)))
               (macro-force-vars (str)
                 (if (##string? str)
                     (let ((x (copy (##cdr lst) (##fx+ i 1))))
                       (if (##fixnum? x)
                           x
                           (##cons str x)))
                     i))))
            ((##null? lst)
             '())
            (else
             0))))

  (copy lst 1))

(define-prim (##string-prefix=? str prefix)
  (let ((prefix-len (##string-length prefix)))
    (and (##fx>= (##string-length str) prefix-len)
         (let loop ((i 0))
           (if (##fx< i prefix-len)
               (and (##char=? (##string-ref str i)
                              (##string-ref prefix i))
                    (loop (##fx+ i 1)))
               (##substring str i (##string-length str)))))))

(define-prim (##string-suffix=? str suffix)
  (let ((suffix-len (##string-length suffix)))
    (and (##fx>= (##string-length str) suffix-len)
         (let loop ((i suffix-len))
           (if (##fx> i 0)
               (and (##char=? (##string-ref str
                                            (##fx- (##string-length str) i))
                              (##string-ref suffix
                                            (##fx- suffix-len i)))
                    (loop (##fx- i 1)))
               (##substring str 0 (##fx- (##string-length str) suffix-len)))))))

(define-fail-check-type procedure 'procedure)

(define-prim (##procedure? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-procedure))))

(define-prim (procedure? obj)
  (macro-force-vars (obj)
    (##procedure? obj)))

;; apply is in "_kernel.scm"

(define ##allow-length-mismatch? #t)

(define-prim (##allow-length-mismatch?-set! x)
  (set! ##allow-length-mismatch? x))

(define (##proper-list-length lst)
  (let loop ((lst lst) (n 0))
    (macro-force-vars (lst)
      (cond ((##pair? lst)
             (loop (##cdr lst) (##fx+ n 1)))
            ((##null? lst)
             n)
            (else
             #f)))))

(define (##cars lsts end)

  (define (cars lsts end) ;; assumes lsts is a list of pairs
    (if (##pair? lsts)
        (let ((lst1 (##car lsts)))
          (macro-force-vars (lst1)
            (##cons (##car lst1)
                    (cars (##cdr lsts) end))))
        end))

  (cars lsts end))

(define (##cdrs lsts)

  (define (cdrs lsts)
    (if (##pair? lsts)
        (let ((tail (cdrs (##cdr lsts))))

          ;; tail is either
          ;; 1) () : (##cdr lsts) is ()
          ;; 2) #f : all the elements of (##cdr lsts) are not pairs
          ;; 3) a pair : all the elements of (##cdr lsts) are pairs
          ;; 4) a fixnum >= 0 : at least one of (##cdr lsts) is ()
          ;;                    and at index tail of (##cdr lsts) is a pair
          ;; 5) a fixnum < 0 : at least one of (##cdr lsts) is not a pair and
          ;;                   at index tail - ##min-fixnum of (##cdr lsts) is
          ;;                   the first element that is neither a pair or ()

          (let ((lst1 (##car lsts)))
            (macro-force-vars (lst1)
              (cond ((##pair? lst1)
                     (cond ((##fixnum? tail)
                            (if (##fx< tail 0)
                                (##fx+ tail 1)
                                0))
                           ((##not tail)
                            (if ##allow-length-mismatch?
                                #f
                                0))
                           (else
                            (##cons (##cdr lst1) tail))))
                    ((##null? lst1)
                     (cond ((##fixnum? tail)
                            (##fx+ tail 1))
                           ((##pair? tail)
                            (if ##allow-length-mismatch?
                                #f
                                1))
                           (else
                            #f)))
                    (else
                     ##min-fixnum)))))
        '()))

  (cdrs lsts))

(define-prim (##map proc x . y)

  (define (map-1 x)

    (define (map-1 lst1)
      (if (##pair? lst1)
          (let* ((result (proc (##car lst1)))
                 (tail (map-1 (##cdr lst1))))
            (##cons result tail))
          '()))

    (map-1 x))

  (define (map-n x-y)

    (define (map-n lsts)
      (let ((rests (##cdrs lsts)))
        (if (##not rests)
            '()
            (if (##pair? rests)
                (let* ((args (##cars lsts '()))
                       (result (##apply proc args))
                       (tail (map-n rests)))
                  (##cons result tail))
                '()))))

    (map-n x-y))

  (if (##null? y)
      (map-1 x)
      (map-n (##cons x y))))

(define-prim (map proc x . y)
  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (map proc x . y)
      (let ()

        (define (map-1 x)

          (define (map-1 lst1)
            (macro-force-vars (lst1)
              (if (##pair? lst1)
                  (let* ((result (proc (##car lst1)))
                         (tail (map-1 (##cdr lst1))))
                    (macro-if-checks
                     (and tail
                          (##cons result tail))
                     (##cons result tail)))
                  (macro-if-checks
                   (if (##null? lst1)
                       '()
                       #f)
                   '()))))

          (macro-if-checks
           (let ((result (map-1 x)))
             (or result
                 (macro-fail-check-list
                  2
                  (map proc x))))
           (map-1 x)))

        (define (map-n x-y)

          (define (map-n lsts)
            (let ((rests (##cdrs lsts)))
              (if (##not rests)
                  '()
                  (if (##pair? rests)
                      (let* ((args (##cars lsts '()))
                             (result (##apply proc args))
                             (tail (map-n rests)))
                        (macro-if-checks
                         (if (##fixnum? tail)
                             tail
                             (##cons result tail))
                         (##cons result tail)))
                      (macro-if-checks
                       rests
                       '())))))

          (macro-if-checks
           (let ((result (map-n x-y)))
             (if (##fixnum? result)
                 (if (##fx< result 0)
                     (macro-fail-check-list
                      (##fx- (##fx+ 2 result) ##min-fixnum)
                      (map proc . x-y))
                     (##raise-length-mismatch-exception
                      (##fx+ 2 result)
                      '()
                      map
                      proc
                      x-y))
                 result))
           (map-n x-y)))

        (if (##null? y)
            (map-1 x)
            (map-n (##cons x y)))))))

(define-prim (##for-each proc x . y)

  (define (for-each-1 x)

    (define (for-each-1 lst1)
      (if (##pair? lst1)
          (begin
            (proc (##car lst1))
            (for-each-1 (##cdr lst1)))
          (##void)))

    (for-each-1 x))

  (define (for-each-n x-y)

    (define (for-each-n lsts)
      (let ((rests (##cdrs lsts)))
        (if (##not rests)
            (##void)
            (if (##pair? rests)
                (begin
                  (##apply proc (##cars lsts '()))
                  (for-each-n rests))
                (##void)))))

    (for-each-n x-y))

  (if (##null? y)
      (for-each-1 x)
      (for-each-n (##cons x y))))

(define-prim (for-each proc x . y)
  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (for-each proc x . y)
      (let ()

        (define (for-each-1 x)

          (define (for-each-1 lst1)
            (macro-force-vars (lst1)
              (if (##pair? lst1)
                  (begin
                    (proc (##car lst1))
                    (for-each-1 (##cdr lst1)))
                  (macro-check-list lst1 2 (for-each proc x)
                    (##void)))))

          (for-each-1 x))

        (define (for-each-n x-y)

          (define (for-each-n lsts)
            (let ((rests (##cdrs lsts)))
              (if (##not rests)
                  (##void)
                  (if (##pair? rests)
                      (begin
                        (##apply proc (##cars lsts '()))
                        (for-each-n rests))
                      (macro-if-checks
                       (if (##fx< rests 0)
                           (macro-fail-check-list
                            (##fx- (##fx+ 2 rests) ##min-fixnum)
                            (for-each proc . x-y))
                           (##raise-length-mismatch-exception
                            (##fx+ 2 rests)
                            '()
                            for-each
                            proc
                            x-y))
                       (##void))))))

          (for-each-n x-y))

        (if (##null? y)
            (for-each-1 x)
            (for-each-n (##cons x y)))))))

;; call-with-current-continuation is in "_kernel.scm"

;; Port related procedures are in "_io.scm"

;;;----------------------------------------------------------------------------

;; R4RS Scheme procedures:

(define-prim (##list-tail lst k)
  (let loop ((x lst) (i k))
    (if (##fx< 0 i)
        (loop (##cdr x) (##fx- i 1))
        x)))

(define-prim (list-tail lst k)
  (macro-force-vars (k)
    (macro-check-index k 2 (list-tail lst k)
      (let loop ((x lst) (i k))
        (if (##fx< 0 i)
            (macro-force-vars (x)
              (macro-check-pair x 1 (list-tail lst k);;;;;;;;;;error message confusing?
                (loop (##cdr x) (##fx- i 1))))
            x)))))

(define-prim (##make-delay-promise thunk))
(define-prim (##promise-state promise))
(define-prim (##promise-state-set! promise state))

(define-prim (promise? obj)
  (##promise? obj))

(define-prim (make-promise val)
  (if (##promise? val)
      val
      (let ((p (##make-delay-promise #f)))
        (##vector-set! (##promise-state p) 0 val)
        p)))

(define-prim (##force obj)
  (if (##promise? obj)
      (##force-out-of-line obj)
      obj))

(define-prim (force obj)
  (##force obj))

;; Port related procedures are in "_io.scm"

;;;----------------------------------------------------------------------------

;; R5RS Scheme procedures:

;; values, call-with-values and dynamic-wind are in "_thread.scm"

;;(eval expr env)
;;(scheme-report-environment version)
;;(null-environment version)
;;(interaction-environment)

;;;----------------------------------------------------------------------------

;; Multilisp procedures:

(define-prim (touch obj)
  (##force obj))

;;;----------------------------------------------------------------------------

;; DSSSL procedures:

(define-fail-check-type keyword 'keyword)

(define-prim (##make-uninterned-keyword name hash))
(define-prim (##keyword-name key))
(define-prim (##keyword-name-set! key name))
(define-prim (##keyword-hash key))
(define-prim (##keyword-hash-set! key hash))
(define-prim (##keyword-interned? key))
(define-prim (##keyword? obj))

(define-prim (keyword? obj)
  (##keyword? obj))

(define-prim (##keyword->string key)
  (let ((name (##keyword-name key)))
    (if (##fixnum? name)
        (let ((str (##string-append "g" (##number->string name 10))))
          (##declare (not interrupts-enabled))
          (let ((name (##keyword-name key)))
            ;; Double-check in case a different thread has also called
            ;; and completed the call to ##keyword->string on this keyword.
            (if (##fixnum? name)
                (begin
                  (##keyword-name-set! key str)
                  str)
                name)))
        name)))

(define-prim (keyword->string key)
  (macro-force-vars (key)
    (macro-check-keyword key 1 (keyword->string key)
      (##keyword->string key))))

(define-prim (##string->keyword str)
  (##make-interned-keyword str))

(define-prim (string->keyword str)
  (macro-force-vars (str)
    (macro-check-string str 1 (string->keyword str)
      (##string->keyword str))))

(define-prim (##uninterned-keyword? obj)
  (and (##keyword? obj)
       (##not (##keyword-interned? obj))))

(define-prim (uninterned-keyword? obj)
  (macro-force-vars (obj)
    (##uninterned-keyword? obj)))

(define ##keyword-counter 0)

(define-prim (##string->uninterned-keyword
              str
              #!optional
              (hash (macro-absent-obj)))

  ;; str must be a nonmutable string

  (if (##eq? hash (macro-absent-obj))
      (let ((n (##fxwrap+ ##keyword-counter 1)))
        ;; Note: it is unimportant if the increment of ##keyword-counter
        ;; is not atomic; it simply means a possible close repetition
        ;; of the same hash code.  The counter will wrap around eventually.
        (set! ##keyword-counter n)
        (##make-uninterned-keyword str (##partial-bit-reverse n)))
      (##make-uninterned-keyword str hash)))

(define-prim (string->uninterned-keyword
              str
              #!optional
              (hash (macro-absent-obj)))
  (macro-force-vars (str hash)
    (macro-check-string str 1 (string->uninterned-keyword str hash)
      (if (##eq? hash (macro-absent-obj))
          (##string->uninterned-keyword str)
          (macro-check-fixnum-range-incl hash 2 0 536870911 (string->uninterned-keyword str hash)
            (##string->uninterned-keyword str hash))))))

(define-prim (##partial-bit-reverse i)

  (##define-macro (bit n)
    `(##fxarithmetic-shift-left
      (##fxand i ,(expt 2 n)) ,(- 28 (* 2 n))))

  (##fx+
   (bit 0)
   (##fx+
    (bit 1)
    (##fx+
     (bit 2)
     (##fx+
      (bit 3)
      (##fx+
       (bit 4)
       (##fx+
        (bit 5)
        (##fx+
         (bit 6)
         (##fx+
          (bit 7)
          (##fx+
           (bit 8)
           (##fx+
            (bit 9)
            (##fx+
             (bit 10)
             (##fx+
              (bit 11)
              (##fx+
               (bit 12)
               (##fx+
                (bit 13)
                (bit 14))))))))))))))))

;;;----------------------------------------------------------------------------

;;; Implementation of parameter objects.

(define ##parameter-counter 0)

(define-prim (##make-parameter
              init
              #!optional
              (f (macro-absent-obj)))
  (let ((filter
         (if (##eq? f (macro-absent-obj))
           (lambda (x) x)
           f)))
    (macro-check-procedure filter 2 (make-parameter init f)
      (let* ((val
              (filter init))
             (new-count
              (##fxwrap+ ##parameter-counter 1)))
        ;; Note: it is unimportant if the increment of
        ;; ##parameter-counter is not atomic; it simply means a
        ;; possible close repetition of the same hash code
        (set! ##parameter-counter new-count)
        (let ((descr
               (macro-make-parameter-descr
                val
                (##partial-bit-reverse new-count)
                filter)))
          (letrec ((param
                    (lambda (#!optional (new-val (macro-absent-obj)))
                      (if (##eq? new-val (macro-absent-obj))
                        (##dynamic-ref param)
                        (##dynamic-set!
                         param
                         ((macro-parameter-descr-filter descr) new-val))))))
            param))))))

(define-prim (make-parameter init #!optional (f (macro-absent-obj)))
  (macro-force-vars (f)
    (##make-parameter init f)))

;;;----------------------------------------------------------------------------

;; SRFI-1 procedures:

(define-prim (##xcons d a)
  (##cons a d))

(define-prim (xcons d a)
  (##cons a d))

(define-prim (##cons*-aux x rest)
  (if (##pair? rest)
      (let loop ((x x) (probe rest))
        (let ((y (##car probe))
              (tail (##cdr probe)))
          (##set-car! probe x)
          (if (##pair? tail)
              (loop y tail)
              (begin
                (##set-cdr! probe y)
                rest))))
      x))

(define-prim (##cons* x . rest)
  (##cons*-aux x rest))

(define-prim (cons* x . rest)
  (##cons*-aux x rest))

(define-prim (##make-list n #!optional (fill 0))
  (let loop ((i n) (result '()))
    (if (##fx> i 0)
        (loop (##fx- i 1) (##cons fill result))
        result)))

(define-prim (make-list n #!optional (fill (macro-absent-obj)))
  (macro-force-vars (n fill)
    (macro-check-index n 1 (make-list n fill)
      (if (##eq? fill (macro-absent-obj))
          (##make-list n)
          (##make-list n fill)))))

(define-prim (##list-tabulate n init-proc)
  (let loop ((i n) (result '()))
    (if (##fx> i 0)
        (let ((i (##fx- i 1)))
          (loop i (##cons (init-proc i) result)))
        result)))

(define-prim (list-tabulate n init-proc)
  (macro-force-vars (n init-proc)
    (macro-check-index n 1 (list-tabulate n init-proc)
      (macro-check-procedure init-proc 2 (list-tabulate n init-proc)
        (##list-tabulate n init-proc)))))

(define-prim (##list-copy lst)

  (define (copy lst)
    (macro-force-vars (lst)
      (if (##pair? lst)
          (##cons (##car lst) (copy (##cdr lst)))
          lst)))

  (copy lst))

(define-prim (list-copy lst)
  (##list-copy lst))

(define-prim (##circular-list x . rest)
  (let ((result (##cons x rest)))
    (##set-cdr! (##last-pair result) result)
    result))

(define-prim (circular-list x . rest)
  (let ((result (##cons x rest)))
    (##set-cdr! (##last-pair result) result)
    result))

(define-prim (##iota count #!optional (start 0) (step 1))
  (if (and (##eqv? step 1)
           (##fixnum? start)
           (##fx+? (##fx- count 1) start))

      (let loop ((i count) (result '()))
        (if (##fx> i 0)
            (let ((i (##fx- i 1)))
              (loop i (##cons (##fx+ start i) result)))
            result))

      (let loop ((i count) (result '()))
        (if (##fx> i 0)
            (let ((i (##fx- i 1)))
              (loop i (##cons (##+ start (##* step i)) result)))
            result))))

(define-prim (iota count
                   #!optional
                   (start (macro-absent-obj))
                   (step (macro-absent-obj)))
  (macro-force-vars (count start step)
    (macro-check-index count 1 (iota count start step)
      (if (##eq? start (macro-absent-obj))
          (##iota count 0 1)
          (if (##not (##number? start))
              (##fail-check-number 2 iota count start step)
              (if (##eq? step (macro-absent-obj))
                  (##iota count start 1)
                  (if (##not (##number? step))
                      (##fail-check-number 3 iota count start step)
                      (##iota count start step))))))))

(define-prim (##take x i)
  (let loop ((probe x)
             (j i)
             (rev-result '()))
    (if (##fx> j 0)
        (loop (##cdr probe)
              (##fx- j 1)
              (##cons (##car probe) rev-result))
        (##reverse! rev-result))))

(define-prim (take x i)
  (macro-force-vars (i)
    (macro-check-index i 2 (take x i)
      (let loop ((probe x)
                 (j i)
                 (rev-result '()))
        (if (##fx> j 0)
            (macro-force-vars (probe)
              (macro-check-pair probe 1 (take x i)
                (loop (##cdr probe)
                      (##fx- j 1)
                      (##cons (##car probe) rev-result))))
            (##reverse! rev-result))))))

(define-prim (##drop x i)
  (let loop ((probe x)
             (j i))
    (if (##fx> j 0)
        (loop (##cdr probe)
              (##fx- j 1))
        probe)))

(define-prim (drop x i)
  (macro-force-vars (i)
    (macro-check-index i 2 (drop x i)
      (let loop ((probe x)
                 (j i))
        (if (##fx> j 0)
            (macro-force-vars (probe)
              (macro-check-pair probe 1 (drop x i)
                (loop (##cdr probe)
                      (##fx- j 1))))
            probe)))))

(define-prim (##last-pair lst)
  (let loop ((lst lst))
    (let ((tail (##cdr lst)))
      (if (##pair? tail)
          (loop tail)
          lst))))

(define-prim (last-pair lst)
  (macro-force-vars (lst)
    (macro-check-pair lst 1 (last-pair lst)
      (let loop ((lst lst))
        (let ((tail (##cdr lst)))
          (macro-force-vars (tail)
            (if (##pair? tail)
                (loop tail)
                lst)))))))

(define-prim (##last lst)
  (##car (##last-pair lst)))

(define-prim (last lst)
  (macro-force-vars (lst)
    (macro-check-pair lst 1 (last lst)
      (let loop ((lst lst))
        (let ((tail (##cdr lst)))
          (macro-force-vars (tail)
            (if (##pair? tail)
                (loop tail)
                (##car lst))))))))

(define-prim (##butlast lst)

  (define (butlast lst)
    (if (##pair? (##cdr lst))
        (##cons (##car lst) (butlast (##cdr lst)))
        '()))

  (butlast lst))

;; ##reverse! defined in _kernel.scm

(define-prim (reverse! lst)
  (let loop ((prev '()) (curr lst))
    (macro-force-vars (curr)
      (if (##pair? curr)
          (let ((next (##cdr curr)))
            (##set-cdr! curr prev)
            (loop curr next))
          (macro-check-list curr 1 (reverse! lst)
            prev)))))

(define-prim (##fold proc base lst)
  (let loop ((r base) (x lst))
    (if (##pair? x)
        (loop (proc (##car x) r)
              (##cdr x))
        r)))

(define-prim (fold proc base x . y)
  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (fold proc base x . y)
      (let ()

        (define (fold-1 x)

          (define (fold-1 r lst1)
            (macro-force-vars (lst1)
              (if (##pair? lst1)
                  (fold-1 (proc (##car lst1) r)
                          (##cdr lst1))
                  (macro-check-list lst1 3 (fold proc base x)
                    r))))

          (fold-1 base x))

        (define (fold-n x-y)

          (define (fold-n r lsts)
            (let ((rests (##cdrs lsts)))
              (if (##not rests)
                  r
                  (if (##pair? rests)
                      (fold-n (##apply proc (##cars lsts (##list r)))
                              rests)
                      (macro-if-checks
                       (if (##fx< rests 0)
                           (macro-fail-check-list
                            (##fx- (##fx+ 3 rests) ##min-fixnum)
                            (fold proc base . x-y))
                           (##raise-length-mismatch-exception
                            (##fx+ 3 rests)
                            '()
                            fold
                            proc
                            base
                            x-y))
                       r)))))

          (fold-n base x-y))

        (if (##null? y)
            (fold-1 x)
            (fold-n (##cons x y)))))))

(define-prim (##fold-right proc base lst)

  (define (fold-right x)
    (if (##pair? x)
        (proc (##car x)
              (fold-right (##cdr x)))
        base))

  (fold-right lst))

(define-prim (fold-right proc base x . y)
  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (fold-right proc base x . y)
      (let ()

        (define (fold-right-1 x)

          (define (fold-right-1 lst1)
            (macro-force-vars (lst1)
              (if (##pair? lst1)
                  (let ((tail (fold-right-1 (##cdr lst1))))
                    (macro-if-checks
                     (and tail
                          (##list (proc (##car lst1) (##car tail))))
                     (proc (##car lst1) tail)))
                  (macro-if-checks
                   (if (##null? lst1)
                       (##list base)
                       #f)
                   (##list base)))))

          (macro-if-checks
           (let ((result (fold-right-1 x)))
             (if result
                 (##car result)
                 (macro-fail-check-list
                  3
                  (fold-right proc base x))))
           (fold-right-1 x)))

        (define (fold-right-n x-y)

          (define (fold-right-n lsts)
            (let ((rests (##cdrs lsts)))
              (if (##not rests)
                  (macro-if-checks
                   (##list base)
                   base)
                  (if (##pair? rests)
                      (let ((tail (fold-right-n rests)))
                        (macro-if-checks
                         (if (##fixnum? tail)
                             tail
                             (##list (##apply proc (##cars lsts tail))))
                         (##apply proc (##cars lsts (##list tail)))))
                      (macro-if-checks
                       rests
                       base)))))

          (macro-if-checks
           (let ((result (fold-right-n x-y)))
             (if (##fixnum? result)
                 (if (##fx< result 0)
                     (macro-fail-check-list
                      (##fx- (##fx+ 3 result) ##min-fixnum)
                      (fold-right proc base . x-y))
                     (##raise-length-mismatch-exception
                      (##fx+ 3 result)
                      '()
                      fold-right
                      proc
                      base
                      x-y))
                 (##car result)))
           (fold-right-n x-y)))

        (if (##null? y)
            (fold-right-1 x)
            (fold-right-n (##cons x y)))))))

(define-prim (##list-sort! proc lst)

  ;; Stable mergesort algorithm

  (define (sort lst len)
    (if (##fx= len 1)
        (begin
          (##set-cdr! lst '())
          lst)
        (let ((len1 (##fxarithmetic-shift-right len 1)))
          (let loop ((n len1) (tail lst))
            (if (##fx> n 0)
                (loop (##fx- n 1) (##cdr tail))
                (let ((x (sort tail (##fx- len len1))))
                  (merge (sort lst len1) x)))))))

  (define (merge lst1 lst2)
    (if (##pair? lst1)
        (if (##pair? lst2)
            (let ((x1 (##car lst1))
                  (x2 (##car lst2)))
              (if (proc x2 x1)
                  (merge-loop lst2 lst2 lst1 (##cdr lst2))
                  (merge-loop lst1 lst1 (##cdr lst1) lst2)))
            lst1)
        lst2))

  (define (merge-loop result prev lst1 lst2)
    (if (##pair? lst1)
        (if (##pair? lst2)
            (let ((x1 (##car lst1))
                  (x2 (##car lst2)))
              (if (proc x2 x1)
                  (begin
                    (##set-cdr! prev lst2)
                    (merge-loop result lst2 lst1 (##cdr lst2)))
                  (begin
                    (##set-cdr! prev lst1)
                    (merge-loop result lst1 (##cdr lst1) lst2))))
            (begin
              (##set-cdr! prev lst1)
              result))
        (begin
          (##set-cdr! prev lst2)
          result)))

  (let ((len (##length lst)))
    (if (##fx= len 0)
        '()
        (sort lst len))))

(define-prim (##list-sort proc lst)
  (##list-sort! proc (##list-copy lst)))

(define-prim (##string-contains
              str
              substr
              #!optional
              (start1 (macro-absent-obj))
              (end1 (macro-absent-obj))
              (start2 (macro-absent-obj))
              (end2 (macro-absent-obj)))
  (let* ((s1
          (if (##eq? start1 (macro-absent-obj))
              0
              start1))
         (e1
          (if (##eq? end1 (macro-absent-obj))
              (##string-length str)
              end1))
         (s2
          (if (##eq? start2 (macro-absent-obj))
              0
              start2))
         (e2
          (if (##eq? end2 (macro-absent-obj))
              (##string-length substr)
              end2)))
    (let* ((len (##fx- e2 s2))
	   (limit (##fx- e1 len)))
      (let loop1 ((i s1))
	(and (##fx<= i limit)
             (let loop2 ((j (##fx- len 1)))
               (if (##fx>= j 0)
                   (if (##char=? (##string-ref str (##fx+ i j))
                                 (##string-ref substr j))
                       (loop2 (##fx- j 1))
                       (loop1 (##fx+ i 1)))
                   i)))))))

;;;============================================================================
