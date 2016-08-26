;;;============================================================================

;;; File: "_std.scm"

;;; Copyright (c) 1994-2016 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Implementation of exceptions.

(implement-library-type-improper-length-list-exception)

(define-prim (##raise-improper-length-list-exception arg-num proc . args);;;;;;;;;;;
  (##extract-procedure-and-arguments
   proc
   args
   arg-num
   #f
   #f
   (lambda (procedure arguments arg-num dummy1 dummy2)
     (macro-raise
      (macro-make-improper-length-list-exception procedure arguments arg-num)))))

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
  ##char=?)

(define-prim-vector-procedures
  vector
  0
  macro-no-force
  macro-no-check
  macro-no-check
  ##equal?)

(define-prim-vector-procedures
  s8vector
  0
  macro-force-vars
  macro-check-exact-signed-int8
  macro-check-exact-signed-int8-list
  ##fx=)

(define-prim-vector-procedures
  u8vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int8
  macro-check-exact-unsigned-int8-list
  ##fx=)

(define-prim-vector-procedures
  s16vector
  0
  macro-force-vars
  macro-check-exact-signed-int16
  macro-check-exact-signed-int16-list
  ##fx=)

(define-prim-vector-procedures
  u16vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int16
  macro-check-exact-unsigned-int16-list
  ##fx=)

(define-prim-vector-procedures
  s32vector
  0
  macro-force-vars
  macro-check-exact-signed-int32
  macro-check-exact-signed-int32-list
  ##eqv?)

(define-prim-vector-procedures
  u32vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int32
  macro-check-exact-unsigned-int32-list
  ##eqv?)

(define-prim-vector-procedures
  s64vector
  0
  macro-force-vars
  macro-check-exact-signed-int64
  macro-check-exact-signed-int64-list
  ##eqv?)

(define-prim-vector-procedures
  u64vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int64
  macro-check-exact-unsigned-int64-list
  ##eqv?)

(define-prim-vector-procedures
  f32vector
  0.
  macro-force-vars
  macro-check-inexact-real
  macro-check-inexact-real-list
  ##fleqv?)

(define-prim-vector-procedures
  f64vector
  0.
  macro-force-vars
  macro-check-inexact-real
  macro-check-inexact-real-list
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
      (macro-check-subtyped-mutable vect 1 (vector-cas! vect k val oldval)
        (macro-check-index-range
          k
          2
          0
          (##vector-length vect)
          (vector-cas! vect k val oldval)
          (##vector-cas! vect k val oldval))))))

;;;----------------------------------------------------------------------------

;; IEEE Scheme procedures:

(define-prim (##not obj)
  (if obj #f #t))

(define-prim (not obj)
  (macro-force-vars (obj)
    (##not obj)))

(define-prim (##boolean? obj)
  (or (##eq? obj #t) (##eq? obj #f)))

(define-prim (boolean? obj)
  (macro-force-vars (obj)
    (##boolean? obj)))

;; eqv? is defined in "_num.scm"
;; eq? and equal? are defined in "_system.scm"

(define-fail-check-type pair-mutable 'mutable)
(define-fail-check-type subtyped-mutable 'mutable)
(define-fail-check-type pair 'pair)
(define-fail-check-type pair-list 'pair-list)
(define-fail-check-type list 'list)

(define-prim (##pair? obj))

(define-prim (##pair-mutable? obj))

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
      (macro-check-pair-mutable pair 1 (set-car! pair val)
        (begin
          (##set-car! pair val)
          (##void))))))

(define-prim (##set-cdr! pair val))

(define-prim (set-cdr! pair val)
  (macro-force-vars (pair)
    (macro-check-pair pair 1 (set-cdr! pair val)
      (macro-check-pair-mutable pair 1 (set-cdr! pair val)
        (begin
          (##set-cdr! pair val)
          (##void))))))

(define-prim (##null? obj)
  (##eq? obj '()))

(define-prim (null? obj)
  (macro-force-vars (obj)
    (##null? obj)))

(define-prim (list? lst)
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

(define-prim (##append lst1 lst2)
  (if (##pair? lst1)
      (##cons (##car lst1) (##append (##cdr lst1) lst2))
      lst2))

(define-prim (##append-lists lst)
  (if (##pair? lst)
      (let ((rev-lst (##reverse lst)))
        (let loop ((rev-lst (##cdr rev-lst)) (result (##car rev-lst)))
          (if (##pair? rev-lst)
              (loop (##cdr rev-lst)
                    (##append (##car rev-lst) result))
              result)))
      '()))

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
        (let ((head (##car x))
              (tail (##cdr x)))
          (macro-force-vars (tail)
            (if (##null? tail)
                (##cons head y)
                (let ((result (append-2-non-null tail y arg-num)))
                  (macro-if-checks
                   (if (##fixnum? result)
                       result
                       (##cons head result))
                   (##cons head result))))))
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

(define-prim (list-ref lst k)
  (macro-force-vars (k)
    (macro-check-index k 2 (list-ref lst k)
      (let loop ((x lst) (i k))
        (macro-force-vars (x)
          (macro-check-pair x 1 (list-ref lst k);;;;;;;error message confusing?
            (if (##fx< 0 i)
                (loop (##cdr x) (##fx- i 1))
                (##car x))))))))

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

(define-prim (##member obj lst)
  (let loop ((x lst))
    (if (##pair? x)
        (if (##equal? obj (##car x))
            x
            (loop (##cdr x)))
        #f)))

(define-prim (member obj lst)
  (let loop ((x lst))
    (macro-force-vars (x)
      (if (##pair? x)
          (let ((y (##car x)))
            (if (##equal? obj y)
                x
                (loop (##cdr x))))
          (macro-check-list x 2 (member obj lst)
            #f)))))

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

(define-prim (##assoc obj lst)
  (let loop ((x lst))
    (if (##pair? x)
        (let ((couple (##car x)))
          (if (##equal? obj (##car couple))
              couple
              (loop (##cdr x))))
        #f)))

(define-prim (assoc obj lst)
  (let loop ((x lst))
    (macro-force-vars (x)
      (if (##pair? x)
          (let ((couple (##car x)))
            (macro-force-vars (couple)
              (macro-check-pair-list couple 2 (assoc obj lst)
                (let ((y (##car couple)))
                  (if (##equal? obj y)
                      couple
                      (loop (##cdr x)))))))
          (macro-check-list x 2 (assoc obj lst)
            #f)))))

(define-fail-check-type symbol 'symbol)

(define-prim (##make-uninterned-symbol name hash)
  (macro-make-uninterned-symbol name hash))

(define-prim (##symbol-name sym)
  (macro-symbol-name sym))

(define-prim (##symbol-name-set! sym name)
  (macro-symbol-name-set! sym name))

(define-prim (##symbol-hash sym)
  (macro-symbol-hash sym))

(define-prim (##symbol-hash-set! sym hash)
  (macro-symbol-hash-set! sym hash))

(define-prim (##symbol-interned? sym)
  (macro-symbol-next sym))

(define-prim (##symbol? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-symbol))))

(define-prim (symbol? obj)
  (macro-force-vars (obj)
    (##symbol? obj)))

(define-prim (##symbol->string sym)
  (let ((name (macro-symbol-name sym)))
    (if (##fixnum? name)
        (let ((str (##string-append "g" (##number->string name 10))))
          (##declare (not interrupts-enabled))
          (let ((name (macro-symbol-name sym)))
            ;; Double-check in case a different thread has also called
            ;; and completed the call to ##symbol->string on this symbol.
            (if (##fixnum? name)
                (begin
                  (macro-symbol-name-set! sym str)
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
       (##not (macro-symbol-next obj))))

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
        (macro-make-uninterned-symbol str (##partial-bit-reverse n)))
      (macro-make-uninterned-symbol str hash)))

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

(define-fail-check-type char 'char)
(define-fail-check-type char-list 'char-list)

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

(##define-macro (case-independent-char=? x y)
  `(##char=? (##char-downcase ,x) (##char-downcase ,y)))

(##define-macro (case-independent-char<? x y)
  `(##char<? (##char-downcase ,x) (##char-downcase ,y)))

(define-prim-nary-bool (##char-ci=? x y)
  #t
  #t
  (case-independent-char=? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci=? x y)
  #t
  #t
  (case-independent-char=? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci<? x y)
  #t
  #t
  (case-independent-char<? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci<? x y)
  #t
  #t
  (case-independent-char<? x y)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci>? x y)
  #t
  #t
  (case-independent-char<? y x)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci>? x y)
  #t
  #t
  (case-independent-char<? y x)
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci<=? x y)
  #t
  #t
  (##not (case-independent-char<? y x))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci<=? x y)
  #t
  #t
  (##not (case-independent-char<? y x))
  macro-force-vars
  macro-check-char)

(define-prim-nary-bool (##char-ci>=? x y)
  #t
  #t
  (##not (case-independent-char<? x y))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-ci>=? x y)
  #t
  #t
  (##not (case-independent-char<? x y))
  macro-force-vars
  macro-check-char)

(define-prim (##char-alphabetic? c)
  (or (and (##char<=? #\A c) (##char<=? c #\Z))
      (and (##char<=? #\a c) (##char<=? c #\z))))

(define-prim (char-alphabetic? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-alphabetic? c)
      (##char-alphabetic? c))))

(define-prim (##char-numeric? c)
  (and (##char<=? #\0 c) (##char<=? c #\9)))

(define-prim (char-numeric? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-numeric? c)
      (##char-numeric? c))))

(define-prim (##char-whitespace? c)
  (or (and (##char<=? #\tab c)
	   (##char<=? c #\return))
      (##char=? c #\space)))

(define-prim (char-whitespace? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-whitespace? c)
      (##char-whitespace? c))))

(define-prim (##char-upper-case? c)
  (and (##char<=? #\A c) (##char<=? c #\Z)))

(define-prim (char-upper-case? c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-upper-case? c)
      (##char-upper-case? c))))

(define-prim (##char-lower-case? c)
  (and (##char<=? #\a c) (##char<=? c #\z)))

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
  (if (and (##char<=? #\a c) (##char<=? c #\z))
      (##integer->char (##fx- (##char->integer c) 32))
      c))

(define-prim (char-upcase c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-upcase c)
      (##char-upcase c))))

(define-prim (##char-downcase c)
  (if (and (##char<=? #\A c) (##char<=? c #\Z))
      (##integer->char (##fx+ (##char->integer c) 32))
      c))

(define-prim (char-downcase c)
  (macro-force-vars (c)
    (macro-check-char c 1 (char-downcase c)
      (##char-downcase c))))

(define-prim (##string=? str1 str2)
  (##string-equal? str1 str2))

(define-prim-nary-bool (string=? str1 str2)
  #t
  #t
  (##string=? str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim (##string<? str1 str2)
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

(define-prim-nary-bool (string<? str1 str2)
  #t
  #t
  (##string<? str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string>? str1 str2)
  #t
  #t
  (##string<? str2 str1)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string<=? str1 str2)
  #t
  #t
  (##not (##string<? str2 str1))
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string>=? str1 str2)
  #t
  #t
  (##not (##string<? str1 str2))
  macro-force-vars
  macro-check-string)

(define-prim (##string-ci=? str1 str2)
  (or (##eq? str1 str2)
      (let ((len1 (##string-length str1)))
        (if (##eq? len1 (##string-length str2))
            (let loop ((i (##fx- len1 1)))
              (cond ((##fx< i 0)
                     #t)
                    ((##char=? (##char-downcase (##string-ref str1 i))
                               (##char-downcase (##string-ref str2 i)))
                     (loop (##fx- i 1)))
                    (else
                     #f)))
            #f))))

(define-prim-nary-bool (string-ci=? str1 str2)
  #t
  #t
  (##string-ci=? str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim (##string-ci<? str1 str2)
  (and (##not (##eq? str1 str2))
       (let ((len1 (##string-length str1))
             (len2 (##string-length str2)))
         (let ((n (##fxmin len1 len2)))
           (let loop ((i 0))
             (if (##fx< i n)
                 (let ((c1 (##char-downcase (##string-ref str1 i)))
                       (c2 (##char-downcase (##string-ref str2 i))))
                   (if (##char=? c1 c2)
                       (loop (##fx+ i 1))
                       (##char<? c1 c2)))
                 (##fx< n len2)))))))

(define-prim-nary-bool (string-ci<? str1 str2)
  #t
  #t
  (##string-ci<? str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string-ci>? str1 str2)
  #t
  #t
  (##string-ci<? str2 str1)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string-ci<=? str1 str2)
  #t
  #t
  (##not (##string-ci<? str2 str1))
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (string-ci>=? str1 str2)
  #t
  #t
  (##not (##string-ci<? str1 str2))
  macro-force-vars
  macro-check-string)

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

(define-fail-check-type procedure 'procedure)

(define-prim (##procedure? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-procedure))))

(define-prim (procedure? obj)
  (macro-force-vars (obj)
    (##procedure? obj)))

;; apply is in "_kernel.scm"

(define-prim (##map proc lst)
  (let loop ((x lst))
    (if (##pair? x)
        (##cons (proc (##car x)) (loop (##cdr x)))
        '())))

(define-prim (map proc x . y)
  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (map proc x . y)
      (let ()

        (define (proper-list-length lst)
          (let loop ((lst lst) (n 0))
            (macro-force-vars (lst)
              (cond ((##pair? lst)
                     (loop (##cdr lst) (##fx+ n 1)))
                    ((##null? lst)
                     n)
                    (else
                     #f)))))

        (define (map-1 lst1)
          (macro-force-vars (lst1)
            (if (##pair? lst1)
                (let ((result (proc (##car lst1))))
                  (##cons result (map-1 (##cdr lst1))))
                '())))

        (define (cars lsts)
          (if (##pair? lsts)
              (let ((lst1 (##car lsts)))
                (macro-force-vars (lst1)
                  (let ((head (##car lst1)))
                    (let ((tail (cars (##cdr lsts))))
                      (##cons head tail)))))
              '()))

        (define (cdrs lsts)
          (if (##pair? lsts)
              (let ((lst1 (##car lsts)))
                (macro-force-vars (lst1)
                  (let ((head (##cdr lst1)))
                    (if (##pair? head)
                        (let ((tail (cdrs (##cdr lsts))))
                          (and tail
                               (##cons head tail)))
                        #f))))
              '()))

        (define (map-n lsts)
          (if lsts
              (let ((result (##apply proc (cars lsts))))
                (##cons result (map-n (cdrs lsts))))
              '()))

        (cond ((##null? y)
               (macro-if-checks
                (let ((len1 (proper-list-length x)))
                  (if len1
                      (map-1 x)
                      (macro-fail-check-list 2 (map proc x . y))))
                (map-1 x)))
              (else
               (macro-if-checks
                (let ((len1 (proper-list-length x)))
                  (if len1
                      (let loop ((lsts y) (arg-num 3))
                        (if (##null? lsts)
                            (if (##null? x)
                                '()
                                (map-n (##cons x y)))
                            (let ((len2 (proper-list-length (##car lsts))))
                              (if (##eq? len1 len2)
                                  (loop (##cdr lsts) (##fx+ arg-num 1))
                                  (if len2
                                      (##raise-improper-length-list-exception
                                       arg-num
                                       '()
                                       map
                                       proc
                                       x
                                       y)
                                      (macro-fail-check-list
                                       arg-num
                                       (map proc x . y)))))))
                      (macro-fail-check-list 2 (map proc x . y))))
                (if (##null? x)
                    '()
                    (map-n (##cons x y))))))))))

(define-prim (##for-each proc lst)
  (let loop ((x lst))
    (if (##pair? x)
        (begin
          (proc (##car x))
          (loop (##cdr x)))
        (##void))))

(define-prim (for-each proc x . y)
  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (for-each proc x . y)
      (let ()

        (define (proper-list-length lst)
          (let loop ((lst lst) (n 0))
            (macro-force-vars (lst)
              (cond ((##pair? lst)
                     (loop (##cdr lst) (##fx+ n 1)))
                    ((##null? lst)
                     n)
                    (else
                     #f)))))

        (define (for-each-1 lst1)
          (macro-force-vars (lst1)
            (if (##pair? lst1)
                (let ((result (proc (##car lst1))))
                  (for-each-1 (##cdr lst1)))
                (##void))))

        (define (cars lsts)
          (if (##pair? lsts)
              (let ((lst1 (##car lsts)))
                (macro-force-vars (lst1)
                  (let ((head (##car lst1)))
                    (let ((tail (cars (##cdr lsts))))
                      (##cons head tail)))))
              '()))

        (define (cdrs lsts)
          (if (##pair? lsts)
              (let ((lst1 (##car lsts)))
                (macro-force-vars (lst1)
                  (let ((head (##cdr lst1)))
                    (if (##pair? head)
                        (let ((tail (cdrs (##cdr lsts))))
                          (and tail
                               (##cons head tail)))
                        #f))))
              '()))

        (define (for-each-n lsts)
          (let ((tails (cdrs lsts)))
            (if tails
                (begin
                  (##apply proc (cars lsts))
                  (for-each-n tails))
                (##apply proc (cars lsts)))))

        (cond ((##null? y)
               (macro-if-checks
                (let ((len1 (proper-list-length x)))
                  (if len1
                      (for-each-1 x)
                      (macro-fail-check-list 2 (for-each proc x . y))))
                (for-each-1 x)))
              (else
               (macro-if-checks
                (let ((len1 (proper-list-length x)))
                  (if len1
                      (let loop ((lsts y) (arg-num 3))
                        (if (##null? lsts)
                            (if (##pair? x)
                                (for-each-n (##cons x y))
                                (##void))
                            (let ((len2 (proper-list-length (##car lsts))))
                              (if (##eq? len1 len2)
                                  (loop (##cdr lsts) (##fx+ arg-num 1))
                                  (if len2
                                      (##raise-improper-length-list-exception
                                       arg-num
                                       '()
                                       for-each
                                       proc
                                       x
                                       y)
                                      (macro-fail-check-list
                                       arg-num
                                       (for-each proc x . y)))))))
                      (macro-fail-check-list 2 (for-each proc x . y))))
                (if (##pair? x)
                    (for-each-n (##cons x y))
                    (##void)))))))))

;; call-with-current-continuation is in "_kernel.scm"

;; Port related procedures are in "_io.scm"

;;;----------------------------------------------------------------------------

;; R4RS Scheme procedures:

(define-prim (list-tail lst k)
  (macro-force-vars (k)
    (macro-check-index k 2 (list-tail lst k)
      (let loop ((x lst) (i k))
        (if (##fx< 0 i)
            (macro-force-vars (x)
              (macro-check-pair x 1 (list-tail lst k);;;;;;;;;;error message confusing?
                (loop (##cdr x) (##fx- i 1))))
            x)))))

(define-prim (##make-promise thunk)
  (macro-make-promise thunk))

(define-prim (##promise-thunk promise)
  (macro-promise-thunk promise))

(define-prim (##promise-thunk-set! promise thunk)
  (macro-promise-thunk-set! promise thunk))

(define-prim (##promise-result promise)
  (macro-promise-result promise))

(define-prim (##promise-result-set! promise result)
  (macro-promise-result-set! promise result))

(define-prim (##force obj)
  (if (##promise? obj)
      (let ((result (macro-promise-result obj)))
        (if (##eq? result obj)
            (let* ((r ((macro-promise-thunk obj)))
                   (result2 (macro-promise-result obj)))
              (if (##eq? result2 obj)
                  (begin
                    (macro-promise-result-set! obj r)
                    (macro-promise-thunk-set! obj #f)
                    r)
                  result2))))
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

(define-prim (##make-uninterned-keyword name hash)
  (macro-make-uninterned-keyword name hash))

(define-prim (##keyword-name key)
  (macro-keyword-name key))

(define-prim (##keyword-name-set! key name)
  (macro-keyword-name-set! key name))

(define-prim (##keyword-hash key)
  (macro-keyword-hash key))

(define-prim (##keyword-hash-set! key hash)
  (macro-keyword-hash-set! key hash))

(define-prim (##keyword-interned? key)
  (macro-keyword-next key))

(define-prim (##keyword? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-keyword))))

(define-prim (keyword? obj)
  (##keyword? obj))

(define-prim (##keyword->string key)
  (let ((name (macro-keyword-name key)))
    (if (##fixnum? name)
        (let ((str (##string-append "g" (##number->string name 10))))
          (##declare (not interrupts-enabled))
          (let ((name (macro-keyword-name key)))
            ;; Double-check in case a different thread has also called
            ;; and completed the call to ##keyword->string on this keyword.
            (if (##fixnum? name)
                (begin
                  (macro-keyword-name-set! key str)
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
       (##not (macro-keyword-next obj))))

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
        (macro-make-uninterned-keyword str (##partial-bit-reverse n)))
      (macro-make-uninterned-keyword str hash)))

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

;;;============================================================================
