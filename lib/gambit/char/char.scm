;;;============================================================================

;;; File: "char.scm"

;;; Copyright (c) 1994-2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Character operations.

(##include "char#.scm")

;;;----------------------------------------------------------------------------

(macro-define-unicode-tables)

;;;----------------------------------------------------------------------------

(define-fail-check-type char 'char)
(define-fail-check-type char-list 'char-list)
(define-fail-check-type char-vector 'char-vector)

(define-prim (##max-char-code)
  #x10ffff)

(define-prim&proc (char? (object object))
  (char? object))

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

(define-prim&proc (char-alphabetic? (char char))
  (macro-char-alphabetic? char))

(define-prim&proc (char-numeric? (char char))
  (macro-char-numeric? char))

(define-prim&proc (char-whitespace? (char char))
  (macro-char-whitespace? char))

(define-prim&proc (char-upper-case? (char char))
  (macro-char-upper-case? char))

(define-prim&proc (char-lower-case? (char char))
  (macro-char-lower-case? char))

(define-procedure (char->integer (char char))
  (char->integer char))

(define-macro (macro-unicode-surrogate? code)
  `(##fx= #xd800 (##fxand -2048 ,code)))

(define-procedure (integer->char (n (fixnum-range-incl 0 (##max-char-code))))
  (if (macro-unicode-surrogate? n)
      (primitive (raise-range-exception '(1 . n) (%procedure%) n))
      (integer->char n)))

(define-prim&proc (char-upcase (char char))
  (macro-char-upcase char))

(define-prim&proc (char-downcase (char char))
  (macro-char-downcase char))

(define-prim&proc (char-foldcase (char char))
  (macro-char-foldcase char))

(define-prim&proc (digit-value (char char))
  (macro-digit-value char))

;;;----------------------------------------------------------------------------

;;; Character set operations.

(macro-define-standard-char-sets)

(implement-type-char-set)

(define-fail-check-type char-set
  (macro-type-char-set))

(define-macro (macro-boundaries-length boundaries)
  `(u32vector-length ,boundaries))

(define-macro (macro-boundaries-ref boundaries i)
  `(u32vector-ref ,boundaries ,i))

(define-macro (macro-boundaries-set! boundaries i val)
  `(u32vector-set! ,boundaries ,i ,val))

(define-macro (macro-boundaries-empty)
  `'#u32())

(define-macro (macro-boundaries-copy boundaries)
  `(u32vector-copy ,boundaries))

(define-macro (macro-list->boundaries lst)
  `(list->u32vector ,lst))

(define-macro (macro-boundaries . boundaries)
  `(u32vector ,@boundaries))

;;;----------------------------------------------------------------------------

;;; General procedures

(define-prim&proc (char-set? (object object))
  (macro-char-set? object))

(define-primitive (char-set=2
                   (char-set1 char-set)
                   (char-set2 char-set))
  (cond ((not (macro-char-set? char-set1))
         '(1))
        ((not (macro-char-set? char-set2))
         '(2))
        (else
         (or (eq? char-set1 char-set2) ;; obvious quick check
             (and
              ;; check for same complement flag
              (fx= (fxand 1 (macro-char-set-hi-lo-complement char-set1))
                   (fxand 1 (macro-char-set-hi-lo-complement char-set2)))
              ;; check for same boundaries
              (let* ((boundaries1 (macro-char-set-boundaries char-set1))
                     (boundaries2 (macro-char-set-boundaries char-set2))
                     (len1 (macro-boundaries-length boundaries1))
                     (len2 (macro-boundaries-length boundaries2)))
                (and (fx= len1 len2)
                     (let loop ((i (fx- len1 1)))
                       (if (fx< i 0)
                           #t
                           (and (fx= (macro-boundaries-ref boundaries1 i)
                                     (macro-boundaries-ref boundaries2 i))
                                (loop (fx- i 1))))))))))))

(define-prim-nary-bool (##char-set= x y)
  #t
  #t
  (##char-set=2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-set= x y)
  #t
  (if (macro-char-set? x) #t '(1))
  (##char-set=2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-char-set))

(define-primitive (char-set<=2 char-set1 char-set2)

  (define (loop boundaries1 boundaries2 i1 lo1 hi1 i2 lo2 hi2)
    (cond ((fx> hi1 hi2)
           ;; hi1+1 is not in char-set2
           #f)
          ((fx> hi1 lo2)
           ;; lo1..hi1 intersects with lo2..hi2
           (if (fx>= lo1 lo2)
               ;; lo1..hi1 is nested in lo2..hi2
               (if (fx<= i1 0)
                   ;; all ranges of char-set1 have been checked
                   #t
                   ;; check the next range of char-set1
                   (let ((i1 (fx- i1 2)))
                     (loop boundaries1
                           boundaries2
                           i1
                           (if (fx< i1 0)
                               0
                               (macro-boundaries-ref boundaries1 i1))
                           (macro-boundaries-ref boundaries1 (fx+ i1 1))
                           i2
                           lo2
                           hi2)))
               ;; lo1-1 is not in char-set2
               #f))
          (else
           ;; lo1..hi1 is a range before lo2..hi2
           (if (fx<= i2 0)
               ;; all ranges of char-set2 have been checked (but not char-set1)
               #f
               ;; check the next range of char-set2
               (let ((i2 (fx- i2 2)))
                 (loop boundaries1
                       boundaries2
                       i1
                       lo1
                       hi1
                       i2
                       (if (fx< i2 0)
                           0
                           (macro-boundaries-ref boundaries2 i2))
                       (macro-boundaries-ref boundaries2 (fx+ i2 1))))))))

  (define (check-boundaries)
    (let ((boundaries1 (macro-char-set-boundaries char-set1)))

      (define (start1 i1 hi1)
        (let ((lo1 (if (fx< i1 0) 0 (macro-boundaries-ref boundaries1 i1)))
              (boundaries2 (macro-char-set-boundaries char-set2)))

          (define (start2 i2 hi2)
            (let ((lo2 (if (fx< i2 0) 0 (macro-boundaries-ref boundaries2 i2))))
              (loop boundaries1 boundaries2 i1 lo1 hi1 i2 lo2 hi2)))

          (let ((i2 (fx- (macro-boundaries-length boundaries2) 1)))
            (if (fxodd? (fxxor i2 (macro-char-set-hi-lo-complement char-set2)))
                ;; last boundary is the start of an "out" section
                (if (fx< i2 0)
                    #f ;; char-set2 is empty, so it is a subset of char-set1
                    (start2 (fx- i2 1) (macro-boundaries-ref boundaries2 i2)))
                ;; last boundary is the start of an "in" section which goes up
                ;; to (##max-char-code)
                (start2 i2 (fx+ 1 (##max-char-code)))))))

      (let ((i1 (fx- (macro-boundaries-length boundaries1) 1)))
        (if (fxodd? (fxxor i1 (macro-char-set-hi-lo-complement char-set1)))
            ;; last boundary is the start of an "out" section
            (if (fx< i1 0)
                #t ;; char-set1 is empty, so it is a subset of char-set2
                (start1 (fx- i1 1) (macro-boundaries-ref boundaries1 i1)))
            ;; last boundary is the start of an "in" section which goes up
            ;; to (##max-char-code)
            (start1 i1 (fx+ 1 (##max-char-code)))))))

  (cond ((not (macro-char-set? char-set1))
         '(1))
        ((not (macro-char-set? char-set2))
         '(2))
        (else
         (or (eq? char-set1 char-set2) ;; obvious quick check
             (check-boundaries)))))

(define-prim-nary-bool (##char-set<= x y)
  #t
  #t
  (##char-set<=2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (char-set<= x y)
  #t
  (if (macro-char-set? x) #t '(1))
  (##char-set<=2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-char-set))

(define-prim&proc (char-set-hash (char-set char-set) (bound nonnegative-exact-integer 0))
  (define char-set-salt 137193901)
  (let* ((boundaries (macro-char-set-boundaries char-set))
         (len (macro-boundaries-length boundaries)))
    (let loop ((h (macro-hash-combine
                   char-set-salt
                   (fxand 1 (macro-char-set-hi-lo-complement char-set))))
               (i (fx- len 1)))
      (if (fx< i 0)
          (if (and (fixnum? bound) (fx> bound 0))
              (fxremainder h bound)
              (fxand h (macro-max-fixnum32)))
          (loop (macro-hash-combine h (macro-boundaries-ref boundaries i))
                (fx- i 1))))))

;;;----------------------------------------------------------------------------

;;; Iterating over character sets

(define-macro (macro-end-of-char-set)
  -1)

(define-macro (macro-end-of-char-set? cursor)
  `(##eqv? -1 ,cursor))

(define-prim&proc (char-set-cursor (char-set char-set))
  (let* ((boundaries (macro-char-set-boundaries char-set))
         (i (fx- (macro-boundaries-length boundaries) 1)))
    (if (fxodd? (fxxor i (macro-char-set-hi-lo-complement char-set)))
        ;; last boundary is the start of an "out" section
        (if (fx< i 0)
            (macro-end-of-char-set) ;; no elements
            (primitive
             (char-set-cursor-range
              (if (fx<= i 0) 0 (macro-boundaries-ref boundaries (fx- i 1)))
              (macro-boundaries-ref boundaries i))))
        ;; last boundary is the start of an "in" section which goes up
        ;; to (##max-char-code)
        (primitive
         (char-set-cursor-range
          (if (fx< i 0) 0 (macro-boundaries-ref boundaries i))
          (fx+ 1 (##max-char-code)))))))

(define-primitive (char-set-cursor-range lo hi)

  (define (range lo hi)
    (let ((run-length (fxmin 256 (fx- hi lo))))
      (fx+ (fxarithmetic-shift-left (fx- run-length 1) 21)
           (fx- hi run-length))))

  (if (fx> hi #xe000) ;; remove surrogates area from range
      (range (fxmax lo #xe000) hi)
      (range lo (fxmin hi #xd800))))

(define-macro (macro-char-set-ref char-set cursor)
  `(##let ((char-set ,char-set)
           (cursor ,cursor))
     (##integer->char
      (##fx+ (##fxarithmetic-shift-right cursor 21)
             (##fxand cursor #x1fffff)))))

(define-prim&proc (char-set-ref (char-set char-set) (cursor fixnum))
  (macro-char-set-ref char-set cursor))

(define-macro (macro-char-set-cursor-next char-set cursor)
  `(##let ((char-set ,char-set)
           (cursor ,cursor))
     (##if (##fx>= cursor #x200000) ;; range not yet empty
           (##fx- cursor #x200000)
           (##char-set-cursor-next-nonneg char-set cursor))))

(define-prim&proc (char-set-cursor-next (char-set char-set) (cursor fixnum))
  (macro-char-set-cursor-next char-set cursor))

(define-primitive (char-set-cursor-next-nonneg char-set code)
  (if (fx<= code 0) ;; also true when code is end-of-char-set
      (macro-end-of-char-set)
      (let* ((boundaries
              (macro-char-set-boundaries char-set))
             (i
              (fx-
               (primitive
                (char-set-boundaries-lookup boundaries (fx- code 1)))
               1)))
        (if (fxodd? (fxxor i (macro-char-set-hi-lo-complement char-set)))
            (if (fx< i 0)
                (macro-end-of-char-set) ;; cursor reached end
                (primitive
                 (char-set-cursor-range
                  (if (fx<= i 0) 0 (macro-boundaries-ref boundaries (fx- i 1)))
                  (macro-boundaries-ref boundaries i))))
            (primitive
             (char-set-cursor-range
              (if (fx< i 0) 0 (macro-boundaries-ref boundaries i))
              code))))))

(define-prim&proc (end-of-char-set? (cursor fixnum))
  (macro-end-of-char-set? cursor))

(define-prim&proc (char-set-fold
                   (kons procedure)
                   (knil object)
                   (char-set char-set))
  (let loop ((cursor (primitive (char-set-cursor char-set))) (result knil))
    (if (macro-end-of-char-set? cursor)
        result
        (loop (macro-char-set-cursor-next char-set cursor)
              (kons (macro-char-set-ref char-set cursor) result)))))

(define-prim&proc (char-set-unfold
                   (p procedure)
                   (f procedure)
                   (g procedure)
                   (seed object)
                   (base-cs char-set ##char-set:empty))
  (let loop ((seed seed) (code-list '()))
    (let ((done? (p seed)))
      (macro-force-vars (done?)
        (if done?
            (primitive
             (char-set-union2-possibly-no-alloc
              base-cs
              (primitive (code-list->char-set code-list))))
            (let err ((char (f seed)))
              (macro-force-vars (char)
                (if (char? char)
                    (loop (g seed)
                          (cons (char->integer char) code-list))
                    (err (primitive
                          (fail-check-char 0 f seed)))))))))))

(define-prim&proc (char-set-unfold!
                   (p procedure)
                   (f procedure)
                   (g procedure)
                   (seed object)
                   (base-cs (and char-set mutable)))
  (primitive (char-set-unfold p f g seed base-cs)))

(define-prim&proc (char-set-for-each
                   (proc procedure)
                   (char-set char-set))
  (let loop ((cursor (primitive (char-set-cursor char-set))))
    (if (macro-end-of-char-set? cursor)
        (void)
        (begin
          (proc (macro-char-set-ref char-set cursor))
          (loop (macro-char-set-cursor-next char-set cursor))))))

(define-prim&proc (char-set-map
                   (proc procedure)
                   (char-set char-set))
  (let loop ((cursor (primitive (char-set-cursor char-set))) (code-list '()))
    (if (macro-end-of-char-set? cursor)
        (primitive (code-list->char-set code-list))
        (let ((char1 (macro-char-set-ref char-set cursor)))
          (let err ((char2 (proc char1)))
            (macro-force-vars (char2)
              (if (char? char2)
                  (loop (macro-char-set-cursor-next char-set cursor)
                        (cons (char->integer char2) code-list))
                  (err (primitive
                        (fail-check-char 0 proc char1))))))))))

;;;----------------------------------------------------------------------------

;;; Creating character sets

(define-prim&proc (char-set-copy (char-set char-set))
  (macro-make-char-set
   (macro-boundaries-copy (macro-char-set-boundaries char-set))
   ;; only keep complement bit so that future mutations don't need to mask it
   (fxand 1 (macro-char-set-hi-lo-complement char-set))))

(define-prim&proc (char-set (char char) ...)
  (let ((code-list (primitive (char-list->code-list char))))
    (if (fixnum? code-list)
        (macro-fail-check-char code-list ((%procedure%) . char))
        (primitive (code-list->char-set code-list)))))

(define-primitive (char->char-set (char char))
  (let ((code (char->integer char)))
    (if (fx<= code 0)
        (macro-make-char-set (macro-boundaries 1) 1)
        (if (fx>= code (##max-char-code))
            (macro-make-char-set (macro-boundaries code) 0)
            (macro-make-char-set (macro-boundaries code (fx+ 1 code)) 0)))))

(define-prim&proc (list->char-set
                   (char-list proper-list)
                   (base-cs char-set ##char-set:empty))
  (let ((code-list (primitive (char-list->code-list char-list))))
    (if (fixnum? code-list)
        (if (fx= 0 code-list)
            (macro-fail-check-proper-list
             '(1 . char-list)
             ((%procedure%) char-list base-cs))
            (macro-fail-check-char-list
             '(1 . char-list)
             ((%procedure%) char-list base-cs)))
        (primitive
         (char-set-union2-possibly-no-alloc
          base-cs
          (primitive (code-list->char-set code-list)))))))

(define-prim&proc (list->char-set!
                   (char-list proper-list)
                   (base-cs (and char-set mutable)))
  (let ((code-list (primitive (char-list->code-list char-list))))
    (if (fixnum? code-list)
        (if (fx= 0 code-list)
            (macro-fail-check-proper-list
             '(1 . char-list)
             ((%procedure%) char-list base-cs))
            (macro-fail-check-char-list
             '(1 . char-list)
             ((%procedure%) char-list base-cs)))
        (primitive
         (char-set-union2-possibly-no-alloc
          base-cs
          (primitive (code-list->char-set code-list)))))))

(define-primitive (char-list->code-list char-list)
  (let loop ((lst char-list) (codes '()))
    (macro-force-vars (lst)
      (if (pair? lst)
          (let ((char (car lst)))
            (macro-force-vars (char)
              (if (char? char)
                  (loop (cdr lst) (cons (char->integer char) codes))
                  (fx+ 1 (length codes))))) ;; "char expected" error
          (if (null? lst)
              codes
              0))))) ;; "improper list" error

(define-primitive (code-list->boundaries-list! code-list)
  (let loop ((lst (list-sort! fx>= code-list)) (prev -1) (boundaries-list '()))
    (if (pair? lst)
        (let ((code (car lst)))
          (loop (cdr lst)
                code
                (if (fx= code prev) ;; ignore duplicates
                    boundaries-list
                    (primitive (boundaries-list-add! boundaries-list code)))))
        boundaries-list)))

(define-primitive (boundaries-list-add! boundaries-list code)
  (if (pair? boundaries-list)
      (if (fx= (car boundaries-list)
               (let ((code+1 (fx+ 1 code)))
                 (if (macro-unicode-surrogate? code+1)
                     #xe000
                     code+1)))
          (begin
            ;; merge with current boundary
            (set-car! boundaries-list code)
            boundaries-list)
          (cons code
                (cons (fx+ 1 code)
                      boundaries-list)))
      (cons code
            (if (fx>= code (##max-char-code)) ;; don't add code+1 if redundant
                '()
                (cons (fx+ 1 code)
                      '())))))

(define-primitive (code-list->char-set code-list)
  (primitive
   (boundaries-list->char-set
    (primitive
     (code-list->boundaries-list! code-list))
    0)))

(define-primitive (boundaries-list->char-set boundaries-list complement)
  (if (and (pair? boundaries-list) (fx= 0 (car boundaries-list)))
      (macro-make-char-set
       (macro-list->boundaries (cdr boundaries-list))
       (fxxor 1 complement))
      (macro-make-char-set
       (macro-list->boundaries boundaries-list)
       complement)))

(define-prim&proc (string->char-set
                   (string string)
                   (base-cs char-set ##char-set:empty))
  (primitive (list->char-set (string->list string) base-cs)))

(define-prim&proc (string->char-set!
                   (string string)
                   (base-cs (and char-set mutable)))
  (primitive (list->char-set! (string->list string) base-cs)))

(define-prim&proc (char-set-filter
                   (pred procedure)
                   (char-set char-set)
                   (base-cs char-set ##char-set:empty))
  (let loop ((cursor (primitive (char-set-cursor char-set))) (code-list '()))
    (if (macro-end-of-char-set? cursor)
        (primitive
         (char-set-union2-possibly-no-alloc
          base-cs
          (primitive (code-list->char-set code-list))))
        (let ((char (macro-char-set-ref char-set cursor)))
          (let ((keep (pred char)))
            (macro-force-vars (keep)
              (loop (macro-char-set-cursor-next char-set cursor)
                    (if keep
                        (cons (char->integer char) code-list)
                        code-list))))))))

(define-prim&proc (char-set-filter!
                   (pred procedure)
                   (char-set char-set)
                   (base-cs (and char-set mutable)))
  (primitive (char-set-filter pred char-set base-cs)))

(define-prim&proc (ucs-range->char-set
                   (lower   fixnum)
                   (upper   fixnum)
                   (error?  object #f)
                   (base-cs char-set ##char-set:empty))

  (define (combine cs)
    (primitive
     (char-set-union2-possibly-no-alloc
      base-cs
      cs)))

  (let* ((lo
          (fxmax lower (if (fx< lower #xd800) 0 #xe000)))
         (hi
          (fxmax upper (if (fx< upper #xd800) 0 #xe000))))
    (if (fx>= lo hi)
        (combine ##char-set:empty)
        (if (and error? (fx> hi (fx+ 1 (##max-char-code))))
            (error "character range exceeds implementation limit")
            (if (fx> hi (##max-char-code)) ;; hi boundary not needed?
                (if (fx= lo 0) ;; lo boundary not needed?
                    (combine ##char-set:full)
                    (combine (macro-make-char-set (macro-boundaries lo) 0)))
                (if (fx= lo 0) ;; lo boundary not needed?
                    (combine (macro-make-char-set (macro-boundaries hi) 1))
                    (combine (macro-make-char-set (macro-boundaries lo hi) 0))))))))

(define-prim&proc (ucs-range->char-set!
                   (lower   fixnum)
                   (upper   fixnum)
                   (error?  object)
                   (base-cs (and char-set mutable)))
  (primitive (ucs-range->char-set lower upper error? base-cs)))

(define-prim&proc (->char-set (x object))
  (cond ((string? x)
         (primitive (string->char-set x)))
        ((char? x)
         (primitive (char->char-set x)))
        ((macro-char-set? x)
         x)
        (else
         (error "STRING, CHARACTER, or CHAR-SET expected" x))))

;;;----------------------------------------------------------------------------

;;; Querying character sets

(define-prim&proc (char-set-size (char-set char-set))
  (let ((boundaries (macro-char-set-boundaries char-set)))

    ;; Here are a few examples of the in-out boundaries and how they are added:
    ;;
    ;;      index:    0  1  2  3
    ;; boundaries:    a  b  c  d
    ;;                *--o  *--o    length = 4
    ;;             0--o  *--o       length = 3
    ;;                *--o          length = 2
    ;;             0--o             length = 1
    ;;                              length = 0

    (let loop ((i (fx- (macro-boundaries-length boundaries) 1)) (n 0))
      (if (fx<= i 0)
          (let* ((n
                  (if (fx= i 0)
                      (fx+ n (macro-boundaries-ref boundaries i)) ;; add last
                      n))
                 (n
                  (if (fxodd?
                       (fxxor i (macro-char-set-hi-lo-complement char-set)))
                      n
                      (fx- (fx+ 1 (##max-char-code)) n)))) ;; complement set
            (if (primitive (char-set-contains?-code char-set #xd800))
                (fx- n 2048) ;; remove surrogates area
                n))
          (loop (fx- i 2)
                (fx+ n
                     (fx- (macro-boundaries-ref boundaries i)
                          (macro-boundaries-ref boundaries (fx- i 1)))))))))

(define-prim&proc (char-set-count (pred procedure) (char-set char-set))
  (let loop ((cursor (primitive (char-set-cursor char-set))) (result 0))
    (if (macro-end-of-char-set? cursor)
        result
        (loop (macro-char-set-cursor-next char-set cursor)
              (if (pred (macro-char-set-ref char-set cursor))
                  (fx+ 1 result)
                  result)))))

(define-prim&proc (char-set->list (char-set char-set))
  (let loop ((cursor (primitive (char-set-cursor char-set))) (result '()))
    (if (macro-end-of-char-set? cursor)
        result
        (loop (macro-char-set-cursor-next char-set cursor)
              (cons (macro-char-set-ref char-set cursor) result)))))

(define-prim&proc (char-set->string (char-set char-set))
  (list->string (primitive (char-set->list char-set))))

(define-prim&proc (char-set-contains? (char-set char-set) (char char))
  (primitive (char-set-contains?-code char-set (char->integer char))))

(define-primitive (char-set-contains?-code (char-set char-set) (code fixnum))
  (let ((hi-lo-complement (macro-char-set-hi-lo-complement char-set)))
    (if (fx> hi-lo-complement 1)

        ;; class range representation
        (fxodd?
         (if (fx< code (u8vector-length ##unicode-class))
             (let ((class (u8vector-ref ##unicode-class code)))
               (if (and (fx< class
                             (fxarithmetic-shift-right hi-lo-complement 9))
                        (fx>= class
                              (fxand
                               (fxarithmetic-shift-right hi-lo-complement 1)
                               255)))
                   (fxxor 1 hi-lo-complement)
                   hi-lo-complement))
             hi-lo-complement))

        ;; in-out boundaries representation
        (fxodd?
         (fxxor
          (primitive
           (char-set-boundaries-lookup
            (macro-char-set-boundaries char-set)
            code))
          hi-lo-complement)))))

(define-primitive (char-set-boundaries-lookup boundaries code)
  (let loop ((lo 0) (hi (fx- (macro-boundaries-length boundaries) 1)))
    (if (fx<= lo hi)
        (let ((mid (fxarithmetic-shift-right (fx+ lo hi) 1)))
          (if (fx<= (macro-boundaries-ref boundaries mid) code)
              (loop (fx+ mid 1) hi)
              (loop lo (fx- mid 1))))
        lo)))

(define-prim&proc (char-set-every (pred procedure) (char-set char-set))
  (let loop ((cursor (primitive (char-set-cursor char-set))))
    (if (macro-end-of-char-set? cursor)
        #t
        (and (pred (macro-char-set-ref char-set cursor))
             (loop (macro-char-set-cursor-next char-set cursor))))))

(define-prim&proc (char-set-any (pred procedure) (char-set char-set))
  (let loop ((cursor (primitive (char-set-cursor char-set))))
    (if (macro-end-of-char-set? cursor)
        #f
        (or (pred (macro-char-set-ref char-set cursor))
            (loop (macro-char-set-cursor-next char-set cursor))))))

;;;----------------------------------------------------------------------------

;;; Character-set algebra

(define-prim&proc (char-set-adjoin
                   (char-set char-set)
                   (char char) ...)
  (let ((code-list (primitive (char-list->code-list char))))
    (if (fixnum? code-list)
        (macro-fail-check-char code-list ((%procedure%) char-set . char))
        (primitive
         (char-set-union2
          char-set
          (primitive (code-list->char-set code-list)))))))

(define-prim&proc (char-set-delete
                   (char-set char-set)
                   (char char) ...)
  (let ((code-list (primitive (char-list->code-list char))))
    (if (fixnum? code-list)
        (macro-fail-check-char code-list ((%procedure%) char-set . char))
        (primitive
         (char-set-difference2
          char-set
          (primitive (code-list->char-set code-list)))))))

(define-prim&proc (char-set-adjoin!
                   (char-set (and char-set mutable))
                   (char char) ...)
  (let ((code-list (primitive (char-list->code-list char))))
    (if (fixnum? code-list)
        (macro-fail-check-char code-list ((%procedure%) char-set . char))
        (primitive
         (char-set-union2
          char-set
          (primitive (code-list->char-set code-list)))))))

(define-prim&proc (char-set-delete!
                   (char-set (and char-set mutable))
                   (char char) ...)
  (let ((code-list (primitive (char-list->code-list char))))
    (if (fixnum? code-list)
        (macro-fail-check-char code-list ((%procedure%) char-set . char))
        (primitive
         (char-set-difference2
          char-set
          (primitive (code-list->char-set code-list)))))))

(define-prim&proc (char-set-complement (char-set char-set))
  (macro-make-char-set
   (macro-char-set-boundaries char-set)
   (fxxor 1 (macro-char-set-hi-lo-complement char-set)))) ;; flip complement

(define-prim&proc (char-set-complement! (char-set (and char-set mutable)))
  (macro-char-set-hi-lo-complement-set!
   char-set
   (fxxor 1 (macro-char-set-hi-lo-complement char-set))) ;; flip complement
  char-set)

(define-primitive (char-set-merge-boundaries
                   boundaries1
                   boundaries2
                   complement1
                   complement2)

  ;;(##namespace ("" pp))

  (define (merge-i-i i1 i2 result)
    ;;(pp (list 'merge-i-i i1 i2 result))
    (cond ((fx< i1 0)
           (complement result))
          ((fx< i2 0)
           (complement result))
          (else
           (let ((b1 (macro-boundaries-ref boundaries1 i1))
                 (b2 (macro-boundaries-ref boundaries2 i2)))
             (if (fx<= b1 b2)
                 (merge-i-o i1
                            (fx- i2 1) ;; b2 is redundant
                            result)
                 (merge-o-i (fx- i1 1) ;; b1 is redundant
                            i2
                            result))))))

  (define (merge-i-o i1 i2 result)
    ;;(pp (list 'merge-i-o i1 i2 result))
    (cond ((fx< i1 0)
           (complement result))
          ((fx< i2 0)
           (prepend-i boundaries1 i1 result))
          (else
           (let ((b1 (macro-boundaries-ref boundaries1 i1))
                 (b2 (macro-boundaries-ref boundaries2 i2)))
             (if (fx<= b1 b2)
                 (merge-i-i i1
                            (fx- i2 1) ;; b2 is redundant
                            result)
                 (merge-o-o (fx- i1 1) ;; b1 is a boundary
                            i2
                            (cons b1 result)))))))

  (define (merge-o-i i1 i2 result)
    ;;(pp (list 'merge-o-i i1 i2 result))
    (cond ((fx< i1 0)
           (prepend-i boundaries2 i2 result))
          ((fx< i2 0)
           (complement result))
          (else
           (let ((b1 (macro-boundaries-ref boundaries1 i1))
                 (b2 (macro-boundaries-ref boundaries2 i2)))
             (if (fx<= b2 b1)
                 (merge-i-i (fx- i1 1) ;; b1 is redundant
                            i2
                            result)
                 (merge-o-o i1
                            (fx- i2 1) ;; b2 is a boundary
                            (cons b2 result)))))))

  (define (merge-o-o i1 i2 result)
    ;;(pp (list 'merge-o-o i1 i2 result))
    (cond ((fx< i1 0)
           (prepend-o boundaries2 i2 result))
          ((fx< i2 0)
           (prepend-o boundaries1 i1 result))
          (else
           (let ((b1 (macro-boundaries-ref boundaries1 i1))
                 (b2 (macro-boundaries-ref boundaries2 i2)))
             (if (fx<= b1 b2)
                 (merge-o-i i1
                            (fx- i2 1) ;; b2 is a boundary
                            (cons b2 result))
                 (merge-i-o (fx- i1 1) ;; b1 is a boundary
                            i2
                            (cons b1 result)))))))

  (define (prepend-i boundaries i result)
    ;;(pp (list 'prepend-i i result))
    (if (fx< i 0)
        (complement result)
        (prepend-o boundaries
                   (fx- i 1)
                   (cons (macro-boundaries-ref boundaries i) result))))

  (define (prepend-o boundaries i result)
    ;;(pp (list 'prepend-o i result))
    (if (fx< i 0)
        result
        (prepend-i boundaries
                   (fx- i 1)
                   (cons (macro-boundaries-ref boundaries i) result))))

  (define (complement result)
    ;;(pp (list 'complement result))
    (if (and (pair? result) (eqv? 0 (car result)))
        (cdr result)
        (cons 0 result)))

  (let ((i1 (fx- (macro-boundaries-length boundaries1) 1))
        (i2 (fx- (macro-boundaries-length boundaries2) 1)))
    (if (fxodd? (fxxor i2
                       complement2))
        (if (fxodd? (fxxor i1
                           complement1))
            (merge-o-o i1 i2 '())
            (merge-i-o i1 i2 '()))
        (if (fxodd? (fxxor i1
                           complement1))
            (merge-o-i i1 i2 '())
            (merge-i-i i1 i2 '())))))

(define-primitive (char-set-union2-possibly-no-alloc
                   (char-set1 char-set)
                   (char-set2 char-set))
  (cond ((eq? char-set1 ##char-set:empty)
         char-set2)
        ((eq? char-set2 ##char-set:empty)
         char-set1)
        (else
         (primitive
          (char-set-union2 char-set1 char-set2)))))

(define-primitive (char-set-union2
                   (char-set1 char-set)
                   (char-set2 char-set))
  (primitive
   (boundaries-list->char-set
    (primitive
     (char-set-merge-boundaries
      (macro-char-set-boundaries char-set1)
      (macro-char-set-boundaries char-set2)
      (macro-char-set-hi-lo-complement char-set1)
      (macro-char-set-hi-lo-complement char-set2)))
    0)))

(define-primitive (char-set-intersection2
                   (char-set1 char-set)
                   (char-set2 char-set))
  (primitive
   (boundaries-list->char-set
    (primitive
     (char-set-merge-boundaries
      (macro-char-set-boundaries char-set1)
      (macro-char-set-boundaries char-set2)
      (fxxor 1 (macro-char-set-hi-lo-complement char-set1))
      (fxxor 1 (macro-char-set-hi-lo-complement char-set2))))
    1)))

(define-primitive (char-set-difference2
                   (char-set1 char-set)
                   (char-set2 char-set))
  (primitive
   (boundaries-list->char-set
    (primitive
     (char-set-merge-boundaries
      (macro-char-set-boundaries char-set1)
      (macro-char-set-boundaries char-set2)
      (fxxor 1 (macro-char-set-hi-lo-complement char-set1))
      (macro-char-set-hi-lo-complement char-set2)))
    1)))

(define-primitive (char-set-xor2
                   (char-set1 char-set)
                   (char-set2 char-set))
  (primitive
   (char-set-union2
    (primitive (char-set-difference2 char-set1 char-set2))
    (primitive (char-set-difference2 char-set2 char-set1)))))

(define-prim-nary (##char-set-union x y)
  ##char-set:empty
  x
  (##char-set-union2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (char-set-union x y)
  ##char-set:empty
  x
  (##char-set-union2 x y)
  macro-force-vars
  macro-check-char-set)

(define-prim-nary (##char-set-intersection x y)
  ##char-set:full
  x
  (##char-set-intersection2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (char-set-intersection x y)
  ##char-set:full
  x
  (##char-set-intersection2 x y)
  macro-force-vars
  macro-check-char-set)

(define-prim-nary (##char-set-difference x y)
  ()
  x
  (##char-set-difference2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (char-set-difference x y)
  ()
  x
  (##char-set-difference2 x y)
  macro-force-vars
  macro-check-char-set)

(define-prim-nary (##char-set-xor x y)
  ##char-set:empty
  x
  (##char-set-xor2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (char-set-xor x y)
  ##char-set:empty
  x
  (##char-set-xor2 x y)
  macro-force-vars
  macro-check-char-set)

(define-prim&proc (char-set-diff+intersection
                   (char-set1 char-set)
                   (char-set2 char-set) ...)
  (let loop ((lst char-set2)
             (i 2)
             (diff char-set1)
             (intersection char-set1))
    (if (pair? lst)
        (let ((cs (car lst)))
          (macro-force-vars (cs)
            (macro-check-char-set cs i (char-set-diff+intersection char-set1 . char-set2)
              (loop (cdr lst)
                    (fx+ i 1)
                    (primitive (char-set-difference diff cs))
                    (primitive (char-set-intersection intersection cs))))))
        (values diff intersection))))

;; The following procedures are defined in terms of the purely functional
;; variants defined above. This could be improved for higher performance.

(define-prim&proc (char-set-union!
                   (cs1 (and char-set mutable))
                   (cs2 char-set) ...)
  (apply (primitive char-set-union) (cons cs1 cs2)))

(define-prim&proc (char-set-intersection!
                   (cs1 (and char-set mutable))
                   (cs2 char-set) ...)
  (apply (primitive char-set-intersection) (cons cs1 cs2)))

(define-prim&proc (char-set-difference!
                   (cs1 (and char-set mutable))
                   (cs2 char-set) ...)
  (apply (primitive char-set-difference) (cons cs1 cs2)))

(define-prim&proc (char-set-xor!
                   (cs1 (and char-set mutable))
                   (cs2 char-set) ...)
  (apply (primitive char-set-xor) (cons cs1 cs2)))

(define-prim&proc (char-set-diff+intersection!
                   (cs1 (and char-set mutable))
                   (cs2 char-set) ...)
  (apply (primitive char-set-diff+intersection) (cons cs1 cs2)))

;;;----------------------------------------------------------------------------

;;; Standard character sets

(define char-set:lower-case   ##char-set:lower-case)
(define char-set:upper-case   ##char-set:upper-case)
(define char-set:title-case   ##char-set:title-case)
(define char-set:letter       ##char-set:letter)
(define char-set:digit        ##char-set:digit)
(define char-set:letter+digit ##char-set:letter+digit)
(define char-set:graphic      ##char-set:graphic)
(define char-set:printing     ##char-set:printing)
(define char-set:whitespace   ##char-set:whitespace)
(define char-set:iso-control  ##char-set:iso-control)
(define char-set:punctuation  ##char-set:punctuation)
(define char-set:symbol       ##char-set:symbol)
(define char-set:hex-digit    ##char-set:hex-digit)
(define char-set:blank        ##char-set:blank)
(define char-set:ascii        ##char-set:ascii)
(define char-set:empty        ##char-set:empty)
(define char-set:full         ##char-set:full)

;;;============================================================================
