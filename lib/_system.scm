;;;============================================================================

;;; File: "_system.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; System procedures

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Basic type predicates.

(define-prim (##fixnum? obj))

;; (##vector? obj) is defined in "_std.scm"

(macro-if-bignum (define-prim (##bignum? obj)))
(macro-if-ratnum (define-prim (##ratnum? obj)))
(macro-if-cpxnum (define-prim (##cpxnum? obj)))
(define-prim (##structure? obj))
(define-prim (##frame? obj))
(define-prim (##continuation? obj))
(define-prim (##promise? obj))
(define-prim (##return? obj))

;; (##string? obj) is defined in "_std.scm"
;; (##s8vector? obj) is defined in "_std.scm"
;; (##u8vector? obj) is defined in "_std.scm"
;; (##s16vector? obj) is defined in "_std.scm"
;; (##u16vector? obj) is defined in "_std.scm"
;; (##s32vector? obj) is defined in "_std.scm"
;; (##u32vector? obj) is defined in "_std.scm"
;; (##s64vector? obj) is defined in "_std.scm"
;; (##u64vector? obj) is defined in "_std.scm"
;; (##f32vector? obj) is defined in "_std.scm"
;; (##f64vector? obj) is defined in "_std.scm"

(define-prim (##flonum? obj))
(define-prim (##unbound? obj))
(define-prim (##foreign? obj))

(macro-case-target
 ((C)
  (define-prim (##type obj))
  (define-prim (##type-cast obj type))
  (define-prim (##subtype obj))
  (define-prim (##subtype-set! obj subtype))))

;; The following definitions only make sense with the C backend but need
;; to be defined for all backends.

(define-prim (##subtyped? obj) #f)
(define-prim (##subtyped.vector? obj) #f)
(define-prim (##subtyped.symbol? obj) #f)
(define-prim (##subtyped.flonum? obj) #f)
(macro-if-bignum (define-prim (##subtyped.bignum? obj) #f))
(define-prim (##special? obj) #f)
(define-prim (##meroon? obj) #f)
(define-prim (##jazz? obj) #f)
(define-prim (##gc-hash-table? obj) #f)

;;;----------------------------------------------------------------------------

;;; Support for the quasiquote special form.

;;; imports:

;;; exports:
;;;    (##quasi-append ...)
;;;    (##quasi-cons ...)
;;;    (##quasi-list ...)
;;;    (##quasi-list->vector ...)
;;;    (##quasi-vector ...)

;;;----------------------------------------------------------------------------

(define-prim (##quasi-append lst1 lst2)
  (macro-force-vars (lst1)
    (if (##pair? lst1)
        (let ((result (##cons (##car lst1) '())))
          (##set-cdr!
           (let loop ((end result) (x (##cdr lst1)))
             (macro-force-vars (x)
               (if (##pair? x)
                   (let ((tail (##cons (##car x) '())))
                     (##set-cdr! end tail)
                     (loop tail (##cdr x)))
                   end)))
           lst2)
          result)
        lst2)))

(define-prim (##quasi-list . lst)
  lst)

(define-prim (##quasi-cons obj1 obj2)
  (##cons obj1 obj2))

(define-prim (##quasi-list->vector lst)
  (let loop1 ((x lst) (n 0))
    (macro-force-vars (x)
      (if (##pair? x)
          (loop1 (##cdr x) (##fx+ n 1))
          (let ((vect (##make-vector n 0)))
            (let loop2 ((x lst) (i 0))
              (macro-force-vars (x)
                (if (and (##pair? x)  ;; double check in case another
                         (##fx< i n)) ;; thread mutates the list
                    (begin
                      (##vector-set! vect i (##car x))
                      (loop2 (##cdr x) (##fx+ i 1)))
                    vect))))))))

(define-prim (##quasi-vector . lst)
  (##quasi-list->vector lst))

;;;----------------------------------------------------------------------------

;;; Object equality.

;;; imports:
;;; from _kernel.scm
;;;    (##type-fields ...)
;;;    (##type-flags ...)
;;;    (##type-id ...)
;;;    (##type-super ...)
;;; from _num.scm
;;;    (##exact-int.= ...)
;;;    (##ratnum.= ...)
;;; from _std.scm
;;;    (##f32vector-equal? ...)
;;;    (##f64vector-equal? ...)
;;;    (##s16vector-equal? ...)
;;;    (##s32vector-equal? ...)
;;;    (##s64vector-equal? ...)
;;;    (##s8vector-equal? ...)
;;;    (##string-equal? ...)
;;;    (##u16vector-equal? ...)
;;;    (##u32vector-equal? ...)
;;;    (##u64vector-equal? ...)
;;;    (##u8vector-equal? ...)
;;;    (##vector-equal? ...)

;;; exports:
;;;    (##case-memv ...)
;;;    (##eq? ...)
;;;    (##equal? ...)
;;;    (##eqv? ...)
;;;    (eq? ...)
;;;    (equal? ...)
;;;    (eqv? ...)

;;;----------------------------------------------------------------------------

;;; Support for the case special form.

;;; The compiler frontend converts
;;;
;;;   (case x ((a b) c) ...)
;;;
;;; to
;;;
;;;   (if (##case-memv x '(a b)) c ...)

(define-prim (##case-memv obj lst)
  (macro-force-vars (obj)
    (let loop ((x lst))
      (if (##pair? x)
          (if (let () (##declare (generic)) (##eqv? obj (##car x)))
              x
              (loop (##cdr x)))
          #f))))

;;;----------------------------------------------------------------------------

(##define-macro (macro-numeqv?-otherwise obj1 obj2 true false otherwise)
  `(macro-number-dispatch ,obj1 ,otherwise
     (if (##fixnum? ,obj2) ;; obj1 = fixnum
         (if (##fx= ,obj1 ,obj2)
             ,true
             ,false)
         ,false)
     (if (##bignum? ,obj2) ;; obj1 = bignum
         (if (##exact-int.= ,obj1 ,obj2)
             ,true
             ,false)
         ,false)
     (if (##ratnum? ,obj2) ;; obj1 = ratnum
         (if (##ratnum.= ,obj1 ,obj2)
             ,true
             ,false)
         ,false)
     (if (##flonum? ,obj2) ;; obj1 = flonum
         (if (##fleqv? ,obj1 ,obj2)
             ,true
             ,false)
         ,false)
     (if (##cpxnum? ,obj2) ;; obj1 = cpxnum
         (if (and (##eqv? (macro-cpxnum-real ,obj1) (macro-cpxnum-real ,obj2))
                  (##eqv? (macro-cpxnum-imag ,obj1) (macro-cpxnum-imag ,obj2)))
             ,true
             ,false)
         ,false)))

(define-prim (##eqv? obj1 obj2)
  (or (##eq? obj1 obj2)
      (macro-numeqv?-otherwise
       obj1
       obj2
       #t
       #f
       #f)))

(define-prim (eqv? obj1 obj2)
  (macro-force-vars (obj1 obj2)
    (let ()
      (##declare (generic)) ;; avoid fixnum specific ##eqv?
      (##eqv? obj1 obj2))))

(define-prim (##eq? obj1 obj2))

(define-prim (eq? obj1 obj2)
  (macro-force-vars (obj1 obj2)
    (##eq? obj1 obj2)))

(define-prim-nary-bool (##symbol=? x y)
  #t
  #t
  (##eq? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (symbol=? x y)
  #t
  (if (##symbol? x) #t '(1))
  (##eq? x y)
  macro-force-vars
  macro-check-symbol
  (##pair? ##fail-check-symbol))

(define-prim-nary-bool (##boolean=? x y)
  #t
  #t
  (##eq? x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (boolean=? x y)
  #t
  (if (##boolean? x) #t '(1))
  (##eq? x y)
  macro-force-vars
  macro-check-boolean
  (##pair? ##fail-check-boolean))

;;-----------------------------------------------------------------------------

(##define-macro (macro-define-equal-objs?
                 equal-objs?
                 params
                 custom-recursion-handler
                 .
                 local-defines)

  `(define (,equal-objs? obj1 obj2 ,@params)

     ,@local-defines

     ,@(if custom-recursion-handler
           `()
           `((define (table-equal obj1 obj2 ,@params)
               (conj (gc-hash-table-equal (macro-table-gcht obj1)
                                          obj2
                                          ,@params)
                     (if (macro-table-test obj1)
                         (gc-hash-table-equal (macro-table-hash obj1)
                                              obj2
                                              ,@params)
                         (true))))

             (define (gc-hash-table-equal ht1 table2 ,@params)
               (##declare (not interrupts-enabled))
               (if (##gc-hash-table? ht1)
                   (let loop ((i (macro-gc-hash-table-key0))
                              ,@(map (lambda (p) `(,p ,p))
                                     params))
                     (if (##fx< i (##vector-length ht1))
                         (let ((key1 (##vector-ref ht1 i)))
                           (if (or (##eq? key1 (macro-unused-obj))
                                   (##eq? key1 (macro-deleted-obj)))
                               (let ()
                                 (##declare (interrupts-enabled))
                                 (loop (##fx+ i 2)
                                       ,@params))
                               (let* ((val1
                                       (##vector-ref ht1 (##fx+ i 1)))
                                      (val2
                                       (##table-ref table2
                                                    key1
                                                    (macro-unused-obj))))
                                 (conj (,equal-objs?
                                        val1
                                        val2
                                        ,@params)
                                       (let ()
                                         (##declare (interrupts-enabled))
                                         (loop (##fx+ i 2)
                                               ,@params))))))
                         (true)))))

             (define (structure-equal obj1 obj2 type len ,@params)
               (if (##not type) ;; have we reached root of inheritance chain?
                   (true)
                   (let ((fields (##type-fields type)))
                     (let loop ((i*3 (##fx- (##vector-length fields) 3))
                                (len len)
                                ,@(map (lambda (p) `(,p ,p))
                                       params))
                       (if (##fx< i*3 0) ;; time to check inherited fields?
                           (structure-equal obj1
                                            obj2
                                            (##type-super type)
                                            len
                                            ,@params)
                           (let ((field-attributes
                                  (##vector-ref fields (##fx+ i*3 1)))
                                 (len-1
                                  (##fx- len 1)))
                             (if (##not (##fx= ;; equality-skip flag set?
                                         (##fxand field-attributes 4)
                                         0))
                                 (loop (##fx- i*3 3) ;; don't check this field
                                       len-1
                                       ,@params)
                                 (conj (,equal-objs? (##unchecked-structure-ref
                                                      obj1
                                                      len-1
                                                      type
                                                      #f)
                                                     (##unchecked-structure-ref
                                                      obj2
                                                      len-1
                                                      type
                                                      #f)
                                                     ,@params)
                                       (loop (##fx- i*3 3)
                                             len-1
                                             ,@params)))))))))))

     (macro-force-vars (obj1 obj2)
       (if (##eq? obj1 obj2)
           (begin
             (profile! 0)
             (true))
           (cond ((##pair? obj1)
                  (profile! 1)
                  (if (##not (##pair? obj2))
                      (false)
                      ,(if custom-recursion-handler
                           `(,custom-recursion-handler obj1 obj2 ,@params)
                           `(recursion
                             obj1
                             obj2
                             (conj (,equal-objs? (##car obj1)
                                                 (##car obj2)
                                                 ,@params)
                                   (,equal-objs? (##cdr obj1)
                                                 (##cdr obj2)
                                                 ,@params))))))
                 ((##vector? obj1)
                  (profile! 2)
                  (if (##not (##vector? obj2))
                      (false)
                      (let ((len (##vector-length obj1)))
                        (if (##not (##fx= len (##vector-length obj2)))
                            (false)
                            ,(if custom-recursion-handler
                                 `(,custom-recursion-handler obj1 obj2 ,@params)
                                 `(recursion
                                   obj1
                                   obj2
                                   (let loop ((i (##fx- len 1))
                                              ,@(map (lambda (p) `(,p ,p))
                                                     params))
                                     (if (##fx< i 0)
                                         (true)
                                         (conj (,equal-objs?
                                                (##vector-ref obj1 i)
                                                (##vector-ref obj2 i)
                                                ,@params)
                                               (loop (##fx- i 1)
                                                     ,@params))))))))))
                 ((##fixnum? obj1)
                  (profile! 3)
                  (if (and (##fixnum? obj2)
                           (##fx= obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-bignum (##bignum? obj1) #f)
                  (profile! 4)
                  (if (and (##bignum? obj2)
                           (##exact-int.= obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-ratnum (##ratnum? obj1) #f)
                  (profile! 5)
                  (if (and (##ratnum? obj2)
                           (##ratnum.= obj1 obj2))
                      (true)
                      (false)))
                 ((##flonum? obj1)
                  (profile! 6)
                  (if (and (##flonum? obj2)
                           (##fleqv? obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-cpxnum (##cpxnum? obj1) #f)
                  (profile! 7)
                  (if (and (##cpxnum? obj2)
                           (##eqv? (macro-cpxnum-real obj1)
                                   (macro-cpxnum-real obj2))
                           (##eqv? (macro-cpxnum-imag obj1)
                                   (macro-cpxnum-imag obj2)))
                      (true)
                      (false)))
                 ((macro-table? obj1)
                  (profile! 8)
                  (if (##not (and (macro-table? obj2)
                                  (##fx= (macro-table-flags obj1)
                                         (macro-table-flags obj2))
                                  (##eq? (macro-table-test obj1)
                                         (macro-table-test obj2))
                                  (if (macro-table-test obj1)
                                      (##eq? (macro-table-hash obj1)
                                             (macro-table-hash obj2))
                                      #t)
                                  (##fx= (##table-length obj1)
                                         (##table-length obj2))))
                      (false)
                      ,(if custom-recursion-handler
                           `(,custom-recursion-handler
                             obj1
                             obj2
                             ,@params)
                           `(recursion
                             obj1
                             obj2
                             (table-equal
                              obj1
                              obj2
                              ,@params)))))
                 ((##structure? obj1)
                  (profile! 9)
                  (if (##not (##structure? obj2))
                      (false)
                      (let ((type (##structure-type obj1)))
                        (if (##not (##eq? (##type-id type)
                                          (##type-id
                                           (##structure-type obj2))))
                            (false)
                            (let ((len (##structure-length obj1)))
                              (if (##not
                                   (and (##fx=
                                         len
                                         (##structure-length obj2))
                                        (##fx= ;; not opaque?
                                         (##fxand
                                          (##type-flags type)
                                          1)
                                         0)))
                                  (false)
                                  ,(if custom-recursion-handler
                                       `(,custom-recursion-handler
                                         obj1
                                         obj2
                                         ,@params)
                                       `(recursion
                                         obj1
                                         obj2
                                         (structure-equal
                                          obj1
                                          obj2
                                          type
                                          len
                                          ,@params)))))))))
                 ((##box? obj1)
                  (profile! 10)
                  (if (##not (##box? obj2))
                      (false)
                      ,(if custom-recursion-handler
                           `(,custom-recursion-handler
                             obj1
                             obj2
                             ,@params)
                           `(recursion
                             obj1
                             obj2
                             (,equal-objs?
                              (##unbox obj1)
                              (##unbox obj2)
                              ,@params)))))
                 ((##string? obj1)
                  (profile! 11)
                  (if (and (##string? obj2)
                           (##string-equal? obj1 obj2))
                      (true)
                      (false)))
                 ((##u8vector? obj1)
                  (profile! 12)
                  (if (and (##u8vector? obj2)
                           (##u8vector-equal? obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-s8vector (##s8vector? obj1) #f)
                  (profile! 13)
                  (if (and (##s8vector? obj2)
                           (##s8vector-equal? obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-u16vector (##u16vector? obj1) #f)
                  (profile! 14)
                  (if (and (##u16vector? obj2)
                           (##u16vector-equal? obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-s16vector (##s16vector? obj1) #f)
                  (profile! 15)
                  (if (and (##s16vector? obj2)
                           (##s16vector-equal? obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-u32vector (##u32vector? obj1) #f)
                  (profile! 16)
                  (if (and (##u32vector? obj2)
                           (##u32vector-equal? obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-s32vector (##s32vector? obj1) #f)
                  (profile! 17)
                  (if (and (##s32vector? obj2)
                           (##s32vector-equal? obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-u64vector (##u64vector? obj1) #f)
                  (profile! 18)
                  (if (and (##u64vector? obj2)
                           (##u64vector-equal? obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-s64vector (##s64vector? obj1) #f)
                  (profile! 19)
                  (if (and (##s64vector? obj2)
                           (##s64vector-equal? obj1 obj2))
                      (true)
                      (false)))
                 ((macro-if-f32vector (##f32vector? obj1) #f)
                  (profile! 20)
                  (if (and (##f32vector? obj2)
                           (##f32vector-equal? obj1 obj2))
                      (true)
                      (false)))
                 ((##f64vector? obj1)
                  (profile! 21)
                  (if (and (##f64vector? obj2)
                           (##f64vector-equal? obj1 obj2))
                      (true)
                      (false)))
                 (else
                  (profile! 22)
                  (false)))))))

(macro-case-target

 ((C)

(define ##equal-hint 0)

(##define-macro (macro-equal-hint-get)
  `##equal-hint)

(##define-macro (macro-equal-hint-set! hint)
  `(let ((h ,hint))
     (set! ##equal-hint h)))

(define-prim (##equal? obj1 obj2)

  ;; various parameters to control how much effort is assigned to the fast
  ;; and slow algorithms

  (define fast-bank0    150)
  (define slow-size0    40)
  (define fast-bank1    2000)
  (define limit-growth  4)
  (define hint-bloat    135)
  (define max-used-bank 100000)
  (define max-ht-count  4000)
  (define loads         '#f64(0.0 0.2 0.85))

  (##define-macro (profile! i)
    `#f) ;; disable profiling

  ;; fast equality testing using a time bank to terminate when objects
  ;; have sharing or cycles

  (macro-define-equal-objs?
   fast-equal-objs? (bank)
   #f

   (##define-macro (true) `bank)
   (##define-macro (false) `##min-fixnum)

   (##define-macro (recursion obj1 obj2 tail-expr)
     `(let ((bank (##fx- bank 1)))
        (if (##fx< bank 0)
            bank
            ,tail-expr)))

   (##define-macro (conj equal-obj?-expr tail-expr)
     `(let ((bank ,equal-obj?-expr))
        (if (##fx< bank 0)
            bank
            ,tail-expr))))

  ;; slow equality testing using a hash table to check for sharing and cycles

  (macro-define-equal-objs?
   slow-equal-objs? (ht)
   #f

   (##define-macro (true) `1)
   (##define-macro (false) `0)

   (##define-macro (recursion obj1 obj2 tail-expr)
     `(let ((r (union-find ,obj1 ,obj2 ht)))
        (if (##not (##fx= r (false)))
            r ;; either obj1 & obj2 were in same equiv class or need to abort
            ,tail-expr)))

   (##define-macro (conj equal-obj?-expr tail-expr)
     `(let ((r ,equal-obj?-expr))
        (if (##not (##fx= r (true)))
            r ;; either obj1 & obj2 are not equal or need to abort
            ,tail-expr)))

   ;; union-find algorithm to detect sharing and cycles

   (define (union-find obj1 obj2 ht)
     (let* ((uht (##unbox ht))
            (code (##gc-hash-table-union! uht obj1 obj2)))

       ;; code
       ;; 0    obj1 and obj2 found in ht, and in same equiv class
       ;; 1    obj1 and obj2 found in ht, but not in same equiv class
       ;; 2-3  only one of obj1 and obj2 found in ht (2 = need to grow ht)
       ;; 4-5  neither obj1 or obj2 found in ht (4 = need to grow ht)

       (if (##fx< code 4) ;; code = 0, 1, 2 or 3... keep track of sharing
           (macro-gc-hash-table-min-count-set!
            uht
            (##fx+ 1 (macro-gc-hash-table-min-count uht))))

       (if (##fx= code 0)
           (true)
           (if (##fxodd? code) ;; code = 1, 3 or 5
               (false)
               ;; hash table is full and needs to be grown
               (if (##fx= 0 (macro-gc-hash-table-min-count uht))
                   -1 ;; no sharing found so abort equality testing
                   (let ((new-ht ;; sharing found so keep going
                          (##gc-hash-table-rehash!
                           uht
                           (##gc-hash-table-resize! uht loads))))
                     (##set-box! ht new-ht)
                     (false))))))))

  ;; main equality testing function

  (macro-define-equal-objs?
   main-equal-objs? ()
   recursion-handler

   (##define-macro (true) `#t)
   (##define-macro (false) `#f)

   (define (recursion-handler obj1 obj2)
     (let ((hint (macro-equal-hint-get)))
       (cond ((##fx= hint 0)
              (let* ((bank fast-bank0)
                     (fr (fast-equal-objs? obj1 obj2 bank)))
                (if (##fx>= fr 0) ;; determine if bank was not exhausted
                    (fast-equal-returning-true (##fx- bank fr)) ;; equal
                    (if (##fx= fr ##min-fixnum)
                        (fast-equal-returning-false) ;; not equal
                        (let* ((size slow-size0) ;; exhausted available bank
                               (ht (new-gc-hash-table size))
                               (sr (slow-equal-objs? obj1 obj2 ht)))
                          (if (##fx= sr -1) ;; reached limit, so try fast algo
                              (fast obj1 obj2 fast-bank1)
                              (slow-equal-returning
                               (##not (##fx= sr 0))
                               (macro-gc-hash-table-count (##unbox ht)))))))))
             ((##fx> hint 0)
              (fast obj1 obj2 hint))
             (else
              (slow obj1 obj2 (##fx- hint))))))

   (define (fast obj1 obj2 limit)
     (let* ((bank (##fx* limit-growth limit))
            (fr (fast-equal-objs? obj1 obj2 bank)))
       (if (##fx>= fr 0) ;; determine if bank was not exhausted
           (fast-equal-returning-true (##fx- bank fr)) ;; equal
           (if (##fx= fr ##min-fixnum)
               (fast-equal-returning-false) ;; not equal
               (slow obj1 obj2 limit))))) ;; reached limit, so try slow algo

   (define (fast-equal-returning-false)
     ;; change hint only if currently "slow"
     (if (##fx> (macro-equal-hint-get) 0)
         (macro-equal-hint-set! 0))
     #f)

   (define (fast-equal-returning-true used-bank)
     ;; change hint to "fast" with 135% of used bank
     (let ((new-bank
            (##fxquotient (##fx* (##fxmin used-bank max-used-bank) hint-bloat)
                          100)))
       (macro-equal-hint-set! (##fxmax new-bank fast-bank0))
       #t))

   (define (slow obj1 obj2 limit)
     (let* ((size limit)
            (ht (new-gc-hash-table size))
            (sr (slow-equal-objs? obj1 obj2 ht)))
        (if (##fx= sr -1) ;; reached limit, so try fast algorithm
            (fast obj1 obj2 (##fx* limit-growth limit))
            (slow-equal-returning
             (##not (##fx= sr 0))
             (macro-gc-hash-table-count (##unbox ht))))))

   (define (slow-equal-returning result count)
     ;; change hint to "slow" with 135% of count
     (let ((new-count
            (##fxquotient (##fx* (##fxmin count max-ht-count) hint-bloat)
                          100)))
       (macro-equal-hint-set! (##fx- (##fxmax new-count slow-size0)))
       result))

   (define (new-gc-hash-table size)
     (let ((uht (##gc-hash-table-allocate
                 size
                 (##fxior (macro-gc-hash-table-flag-mem-alloc-keys)
                          (macro-gc-hash-table-flag-union-find))
                 loads)))
       (macro-gc-hash-table-min-count-set! uht 0)
       (##box uht))))

  (main-equal-objs? obj1 obj2))

)

 (else

(define-prim (##equal? obj1 obj2)

  (##define-macro (profile! i)
    `#f) ;; disable profiling

  (macro-define-equal-objs?
   equal-objs? ()
   #f

   (##define-macro (macro-table-hash obj) `#f)
   (##define-macro (macro-table-gcht obj) `#f)

   (##define-macro (true) `#t)
   (##define-macro (false) `#f)

   (##define-macro (recursion obj1 obj2 tail-expr)
     tail-expr)

   (##define-macro (conj equal-obj?-expr tail-expr)
     `(and ,equal-obj?-expr ,tail-expr)))

  (equal-objs? obj1 obj2))

))

(define-prim (equal? obj1 obj2)
  (##equal? obj1 obj2))

;;;----------------------------------------------------------------------------

;;; Object hashing.

;;;----------------------------------------------------------------------------

(define-prim (##symbol-hash sym))

(define-prim (symbol-hash sym)
  (macro-force-vars (sym)
    (macro-check-symbol sym 1 (symbol-hash sym)
      (##symbol-hash sym))))

(define-prim (##keyword-hash key))

(define-prim (keyword-hash key)
  (macro-force-vars (key)
    (macro-check-keyword key 1 (keyword-hash key)
      (##keyword-hash key))))

(define-prim (##string=?-hash str)

  ;; for all str2 we must have that (##string=? str str2) implies that
  ;; (= (##string=?-hash str) (##string=?-hash str2))

  ;; FNV1a hash function adapted to fixnums fitting in 32 bit words

  (let loop ((h (macro-fnv1a-offset-basis-fixnum32))
             (i 0))
    (if (##fx< i (##string-length str))
        (loop (macro-hash-combine
               h
               (##char->integer (##string-ref str i)))
              (##fx+ i 1))
        h)))

(define-prim (string=?-hash str)
  (macro-force-vars (str)
    (macro-check-string str 1 (string=?-hash str)
      (##string=?-hash str))))

(define-prim (##string-ci=?-hash str)

  ;; for all str2 we must have that (##string-ci=? str str2) implies that
  ;; (= (##string-ci=?-hash str) (##string-ci=?-hash str2))

  ;; FNV1a hash function adapted to fixnums fitting in 32 bit words

  (let ((str (##string-foldcase str)))
    (let loop ((h (macro-fnv1a-offset-basis-fixnum32))
               (i 0))
      (if (##fx< i (##string-length str))
          (loop (macro-hash-combine
                 h
                 (##char->integer (##string-ref str i)))
                (##fx+ i 1))
          h))))

(define-prim (string-ci=?-hash str)
  (macro-force-vars (str)
    (macro-check-string str 1 (string-ci=?-hash str)
      (##string-ci=?-hash str))))

(define-prim (##generic-hash obj)
  0)

(define-prim (##eq?-hash obj)

  ;; for all obj2 we must have that (##eq? obj obj2) implies that
  ;; (= (##eq?-hash obj) (##eq?-hash obj2))

  (define (portable-eq?-hash obj)
    (cond ((##symbol? obj)
           (##symbol-hash obj))
          ((##keyword? obj)
           (##keyword-hash obj))
          (else
           (##fxand
            (##object->serial-number obj) ;; always a nonnegative fixnum
            (macro-max-fixnum32)))))

  (macro-case-target

   ((C)
    (if (##mem-allocated? obj)
        (portable-eq?-hash obj)
        (##fxand
         (##type-cast obj (macro-type-fixnum))
         (macro-max-fixnum32))))

   (else
    (portable-eq?-hash obj))))

(define-prim (eq?-hash obj)
  (macro-force-vars (obj)
    (##eq?-hash obj)))

(define-prim (##eqv?-hash obj)

  ;; for all obj2 we must have that (##eqv? obj obj2) implies that
  ;; (= (##eqv?-hash obj) (##eqv?-hash obj2))

  (define (hash obj)
    (macro-number-dispatch obj
      (##eq?-hash obj) ;; obj = not a number
      (macro-hash-combine ;; obj = fixnum
       obj
       (macro-fnv1a-offset-basis-fixnum32))
      (let ((len (##bignum.mdigit-length obj))) ;; obj = bignum
        (let loop ((h (macro-fnv1a-offset-basis-fixnum32))
                   (i (##fx- len 1)))
          (if (##fx< i 0)
              h
              (loop (macro-hash-combine h (##bignum.mdigit-ref obj i))
                    (##fx- i 1)))))
      (macro-hash-combine (hash (macro-ratnum-numerator obj)) ;; obj = ratnum
                          (hash (macro-ratnum-denominator obj)))
      ;; TODO: hash flonums in a portable way
      (macro-if-u16vector ;; obj = flonum
       (macro-hash-combine
        (##u16vector-ref obj 0)
        (macro-hash-combine
         (##u16vector-ref obj 1)
         (macro-hash-combine
          (##u16vector-ref obj 2)
          (##u16vector-ref obj 3))))
       (macro-hash-combine
        (##u8vector-ref obj 0)
        (macro-hash-combine
         (##u8vector-ref obj 1)
         (macro-hash-combine
          (##u8vector-ref obj 2)
          (macro-hash-combine
           (##u8vector-ref obj 3)
           (macro-hash-combine
            (##u8vector-ref obj 4)
            (macro-hash-combine
             (##u8vector-ref obj 5)
             (macro-hash-combine
              (##u8vector-ref obj 6)
              (##u8vector-ref obj 7)))))))))
      (macro-hash-combine (hash (macro-cpxnum-real obj)) ;; obj = cpxnum
                          (hash (macro-cpxnum-imag obj)))))

  (hash obj))

(define-prim (eqv?-hash obj)
  (macro-force-vars (obj)
    (##eqv?-hash obj)))

(macro-case-target

 ((C)

(define-prim (##equal?-hash obj)

  ;; for all obj2 we must have that (##equal? obj obj2) implies that
  ;; (= (##equal?-hash obj) (##equal?-hash obj2))

  (##define-macro (bank0) `31)
  (##define-macro (bk x) `(##fxand ,x 31))
  (##define-macro (hb h b) `(##fx+ (##fxwraparithmetic-shift-left ,h 5) ,b))
  (##define-macro (hc x) `(##fxand (##fxarithmetic-shift-right ,x 5) ,(- (expt 2 (- 32 2 5)) 1)))
  (##define-macro (split b) `(##fxquotient (##fx+ ,b 2) 3))

  (define pair-salt      171863262)
  (define vector-salt    314126733)
  (define table-salt     381975548)
  (define structure-salt 473043521)
  (define box-salt       502140387)

  (define (hash obj bank)
    (macro-force-vars (obj)
      (cond ((##pair? obj)
             (if (##fx= bank 0)
                 (hb pair-salt
                     0)
                 (let* ((b (##fx- bank 1))
                        (b1 (split b))
                        (h1 (hash (##car obj)
                                  b1))
                        (h2 (hash (##cdr obj)
                                  (##fx+ (##fx- b b1) (bk h1))))
                        (h (macro-hash-combine (hc h1) (hc h2))))
                   (if (##fx= bank (bank0))
                       h
                       (hb h
                           (bk h2))))))
            ((##vector? obj)
             (let ((len (##vector-length obj)))
               (if (or (##fx= bank 0) (##fx= len 0))
                   (hb (macro-hash-combine vector-salt len)
                       bank)
                   (let loop ((i 0)
                              (h vector-salt)
                              (b (##fx- bank 1)))
                     (if (##fx< i (##vector-length obj))
                         (let* ((b1 (split b))
                                (h1 (hash (##vector-ref obj i) b1)))
                           (loop (##fx+ i 1)
                                 (macro-hash-combine h (hc h1))
                                 (##fx+ (##fx- b b1) (bk h1))))
                         (if (##fx= bank (bank0))
                             h
                             (hb h
                                 b)))))))
            ((macro-table? obj)
             (let* ((len (##table-length obj))
                    (h0 (macro-hash-combine
                         table-salt
                         (macro-hash-combine
                          (macro-table-flags obj)
                          (macro-hash-combine
                           (##eq?-hash (macro-table-test obj))
                           (macro-hash-combine
                            (if (macro-table-test obj)
                                (##eq?-hash (macro-table-hash obj))
                                0)
                            len))))))
               (if (or (##fx= bank 0) (##fx= len 0))
                   (hb h0
                       bank)
                   (let* ((b (##fx- bank 1))
                          (b1 (##fxquotient b len))
                          (h
                           (##table-foldl
                            (lambda (x y)
                              ;; must be associative and commutative because
                              ;; end result must not depend on item ordering
                              (##fxxor x y))
                            h0
                            (lambda (key val)
                              (let ((h1 (hash val b1)))
                                (macro-hash-combine
                                 (hc h1)
                                 (if (macro-table-test obj)
                                     (let ((f (macro-table-hash obj)))
                                       (if (##eq? f ##equal?-hash)
                                           (hc (hash key (##fx- b1 (bk h1))))
                                           (f key)))
                                     0))))
                            obj)))
                     (if (##fx= bank (bank0))
                         h
                         (hb h
                             (##fx- b (##fx* b1 len))))))))
            ((##structure? obj)
             (let* ((type
                     (##structure-type obj))
                    (type-id
                     (##type-id type)))
               (if (##not (##fx= ;; opaque?
                           (##fxand
                            (##type-flags type)
                            1)
                           0))
                   (##eq?-hash obj)
                   (let ((h
                          (macro-hash-combine
                           structure-salt
                           (##eq?-hash type-id)))
                         (len
                          (##vector-length obj)))
                     (if (##fx= bank 0)
                         (hb (macro-hash-combine h len)
                             0)
                         (structure-hash obj
                                         type
                                         len
                                         h
                                         (##fx- bank 1)
                                         bank))))))
            ((##box? obj)
             (if (##fx= bank 0)
                 (hb box-salt
                     0)
                 (let* ((b1 (##fx- bank 1))
                        (h1 (hash (##unbox obj)
                                  b1))
                        (h (macro-hash-combine box-salt (hc h1))))
                   (if (##fx= bank (bank0))
                       h
                       (hb h
                           (bk h1))))))
            (else
             (let ((h (cond ((##symbol? obj)
                             (##symbol-hash obj))
                            ((##keyword? obj)
                             (##keyword-hash obj))
                            ((and (##subtyped? obj)
                                  (macro-subtype-bvector? (##subtype obj)))
                             (cond ((##string? obj)
                                    (##string=?-hash obj))
                                   ((or (##flonum? obj)
                                        (macro-if-bignum
                                         (##bignum? obj)
                                         #f))
                                    (##eqv?-hash obj))
                                   (else
                                    ;; TODO: hash bytevectors in a portable way
                                    (bvector-hash obj))))
                            (else
                             (##eqv?-hash obj)))))
               (if (##fx= bank (bank0))
                   h
                   (hb h
                       bank)))))))

  (define (bvector-hash obj)

    (define (u16vect-hash h i)
      (if (##fx< i 0)
          h
          (let ((x
                 (macro-if-u16vector
                  (##u16vector-ref obj i)
                  (let ((j (##fx* i 2)))
                    (##fx+ (##fxarithmetic-shift-left (##u8vector-ref obj j) 8)
                           (##u8vector-ref obj (##fx+ j 1)))))))
            (u16vect-hash (macro-hash-combine x h)
                          (##fx- i 1)))))

    (let ((len (##u8vector-length obj)))
      (u16vect-hash (##fxxor
                     (if (##fxodd? len)
                         (##u8vector-ref obj (##fx- len 1))
                         256)
                     (##fx+ len
                            (##fxarithmetic-shift-left
                             (##subtype obj)
                             20)))
                    (##fx- (##fxwraplogical-shift-right len 1) 1))))

  (define (structure-hash obj type len h b bank)
    (if (##not type) ;; stop when we reach root of inheritance chain
        (if (##fx= bank (bank0))
            h
            (hb h
                b))
        (let ((fields (##type-fields type)))
          (let loop ((h h)
                     (b b)
                     (len len)
                     (i*3 (##fx- (##vector-length fields) 3)))
            (if (##fx< i*3 0)
                (structure-hash obj (##type-super type) len h b bank)
                (let ((field-attributes
                       (##vector-ref fields (##fx+ i*3 1)))
                      (len-1
                       (##fx- len 1)))
                  (if (##not (##fx= ;; equality-skip flag set?
                              (##fxand field-attributes 4)
                              0))
                      (loop h ;; don't hash this field
                            b
                            len-1
                            (##fx- i*3 3))
                      (let* ((b1
                              (split b))
                             (h1
                              (hash (##unchecked-structure-ref
                                     obj
                                     len-1
                                     type
                                     #f)
                                    b1)))
                           (loop (macro-hash-combine h (hc h1))
                                 (##fx+ (##fx- b b1) (bk h1))
                                 len-1
                                 (##fx- i*3 3))))))))))

  (hash obj (bank0)))

(define-prim (equal?-hash obj)
  (macro-force-vars (obj)
    (##equal?-hash obj)))

))

;;;----------------------------------------------------------------------------

;;; Tables.

;;; imports:
;;; from _kernel.scm
;;;    (##extract-procedure-and-arguments ...)
;;;    (##raise-type-exception ...)
;;; from _equal.scm
;;;    (##equal? ...)
;;; from _std.scm
;;;    (##length ...)
;;;    (##map ...)
;;;    (##fail-check-procedure ...)

;;; exports:
;;;    (##fail-check-table ...)
;;;    (##fail-check-unbound-key-exception ...)
;;;    (##list->table-aux ...)
;;;    (##make-table-aux ...)
;;;    (##raise-unbound-key-exception ...)
;;;    (##table->list ...)
;;;    (##table-copy ...)
;;;    (##table-length ...)
;;;    (##table-ref ...)
;;;    (##table-search ...)
;;;    (##table-set! ...)
;;;    (list->table ...)
;;;    (make-table ...)
;;;    (table->list ...)
;;;    (table-copy ...)
;;;    (table-length ...)
;;;    (table-ref ...)
;;;    (table-set! ...)
;;;    (table? ...)
;;;    (unbound-key-exception-arguments ...)
;;;    (unbound-key-exception-procedure ...)
;;;    (unbound-key-exception? ...)

;;;----------------------------------------------------------------------------

(implement-type-table)

(define-fail-check-type table (macro-type-table))

(define-check-type table (macro-type-table)
  macro-table?)

(implement-library-type-unbound-key-exception)

(define-prim (##raise-unbound-key-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-unbound-key-exception
       procedure
       arguments)))))

(define-prim (##table? obj)
  (macro-table? obj))

(define-prim (table? obj)
  (macro-table? obj))

;;;----------------------------------------------------------------------------

(macro-case-target

 ((C)

(implement-library-type-invalid-hash-number-exception)

(define-prim (##raise-invalid-hash-number-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-invalid-hash-number-exception
       procedure
       arguments)))))

(define-prim (##mem-allocated? obj))

(define-prim (##gc-hash-table-ref gcht key))
(define-prim (##gc-hash-table-set! gcht key val))
(define-prim (##gc-hash-table-union! gcht key1 key2))
(define-prim (##gc-hash-table-find! gcht key1 key2))
(define-prim (##gc-hash-table-rehash! gcht-src gcht-dst))

(define-prim (##smallest-prime-no-less-than n) ;; n >= 3
  (let loop1 ((n (if (##fxeven? n) (##fx+ n 1) n)))
    (let loop2 ((d 3))
      (cond ((##fx< n (##fx* d d))
             n)
            ((##fxzero? (##fxmodulo n d))
             (loop1 (##fx+ n 2)))
            (else
             (loop2 (##fx+ d 2)))))))

(##define-macro (define-loose-smallest-prime-no-less-than max-param res)
  (let* ((resm1 (- res 1))
         (2^resm1 (expt 2 resm1))
         (2^resm1-1 (- 2^resm1 1)))

    (define (to-expo n)
      (let ((len (integer-length n)))
        (cons (arithmetic-shift n (- res len)) len)))

    (define (from-expo-lo x)
      (arithmetic-shift (car x) (- (cdr x) res)))

    (define (from-expo-hi x)
      (- (from-expo-lo (cons (+ 1 (car x)) (cdr x))) 1))

    (define (smallest-prime-no-less-than n) ;; n >= 3
      (let loop1 ((n (if (even? n) (+ n 1) n)))
        (let loop2 ((d 3))
          (cond ((< n (* d d))
                 n)
                ((zero? (modulo n d))
                 (loop1 (+ n 2)))
                (else
                 (loop2 (+ d 2)))))))

    (define (vector-of-primes)
      (let loop ((i 0) (lst '()))
        (let* ((n (+ 2^resm1 i))
               (x (cons (+ 2^resm1 (bitwise-and 2^resm1-1 n))
                        (+ resm1 (arithmetic-shift n (- resm1)))))
               (lo (from-expo-lo x)))
          (if (<= lo max-param)
              (let* ((hi (from-expo-hi x))
                     (p (smallest-prime-no-less-than hi)))
                ;;(pp (list i n x lo '.. hi p))
                (loop (+ i 1) (cons p lst)))
              (list->vector (reverse lst))))))

    `(define-prim (##loose-smallest-prime-no-less-than n)
       (let* ((primes ',(vector-of-primes))
              (len (##fxlength n))
              (shift (##fx- len ,res)))
         (if (##fx< shift 0)
             (##vector-ref primes 0)
             (let ((i (##fx+ (##fxand (##fxarithmetic-shift-right n shift)
                                      ,2^resm1-1)
                             (##fxarithmetic-shift-left shift ,resm1))))
               (if (##fx< i (##vector-length primes))
                   (##vector-ref primes i)
                   #f)))))))

(define-loose-smallest-prime-no-less-than 4294967295 4)

(define-prim (##gc-hash-table-resize! gcht loads)
  (let* ((count
          (macro-gc-hash-table-count gcht))
         (n
          (##fx+ 1
                 (##flonum->fixnum
                  (##fl/ (##fixnum->flonum count)
                         (##f64vector-ref loads 1))))))
    (##gc-hash-table-allocate
     n
     (##fxand
      (macro-gc-hash-table-flags gcht)
      (##fxnot ;; remove the following flags
       (##fxior
        (macro-gc-hash-table-flag-key-moved)
        (##fxior
         (macro-gc-hash-table-flag-entry-deleted)
         (macro-gc-hash-table-flag-need-rehash)))))
     loads)))

(define-prim (##gc-hash-table-allocate n flags loads)
  (if (##fx< (macro-gc-hash-table-minimal-nb-entries) n)
      (let ((nb-entries
             (##loose-smallest-prime-no-less-than n)))
        (if (##not nb-entries)
            (##raise-heap-overflow-exception)
            (let* ((min-count
                    (##flonum->fixnum
                     (##fl* (##fixnum->flonum nb-entries)
                            (##f64vector-ref loads 0))))
                   (free
                    (##flonum->fixnum
                     (##fl* (##fixnum->flonum
                             (##fx- nb-entries
                                    (macro-gc-hash-table-minimal-free)))
                            (##f64vector-ref loads 2)))))
              (macro-make-gc-hash-table
               flags
               0
               min-count
               free
               nb-entries))))
      (macro-make-minimal-gc-hash-table
       flags
       0)))

(define-prim (##gc-hash-table-allocate2 nb-entries flags loads)
  (if (##fx< (macro-gc-hash-table-minimal-nb-entries) nb-entries)
      (let* ((min-count
              (##flonum->fixnum
               (##fl* (##fixnum->flonum nb-entries)
                      (##f64vector-ref loads 0))))
             (free
              (##flonum->fixnum
               (##fl* (##fixnum->flonum
                       (##fx- nb-entries
                              (macro-gc-hash-table-minimal-free)))
                      (##f64vector-ref loads 2)))))
        (macro-make-gc-hash-table
         flags
         0
         min-count
         free
         nb-entries))
      (macro-make-minimal-gc-hash-table
       flags
       0)))

(define-prim (##gc-hash-table-for-each proc ht)
  (##declare (not interrupts-enabled))
  (if (##gc-hash-table? ht)
    (let loop ((i (macro-gc-hash-table-key0)))
      (if (##fx< i (##vector-length ht))
        (let ((key (##vector-ref ht i)))
          (if (and (##not (##eq? key (macro-unused-obj)))
                   (##not (##eq? key (macro-deleted-obj))))
            (proc key (##vector-ref ht (##fx+ i 1))))
          (let ()
            (##declare (interrupts-enabled))
            (loop (##fx+ i 2))))
        (##void)))
    (##void)))

(define-prim (##gc-hash-table-search proc ht)
  (##declare (not interrupts-enabled))
  (if (##gc-hash-table? ht)
    (let loop ((i (macro-gc-hash-table-key0)))
      (if (##fx< i (##vector-length ht))
        (let ((key (##vector-ref ht i)))
          (or (and (##not (##eq? key (macro-unused-obj)))
                   (##not (##eq? key (macro-deleted-obj)))
                   (proc key (##vector-ref ht (##fx+ i 1))))
              (let ()
                (##declare (interrupts-enabled))
                (loop (##fx+ i 2)))))
        #f))
    #f))

(define-prim (##gc-hash-table-foldl f base proc ht)
  (##declare (not interrupts-enabled))
  (if (##gc-hash-table? ht)
    (let loop ((i (macro-gc-hash-table-key0)) (base base))
      (if (##fx< i (##vector-length ht))
        (let ((key (##vector-ref ht i)))
          (if (and (##not (##eq? key (macro-unused-obj)))
                   (##not (##eq? key (macro-deleted-obj))))
            (let ((new-base
                   (f base (proc key (##vector-ref ht (##fx+ i 1))))))
              (##declare (interrupts-enabled))
              (loop (##fx+ i 2) new-base))
            (let ()
              (##declare (interrupts-enabled))
              (loop (##fx+ i 2) base))))
        base))
    base))

(define-prim (##make-table-aux
              #!optional
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))

  (define-macro (macro-default-weak-keys)   0)
  (define-macro (macro-default-weak-values) 0)

  (define-macro (macro-default-min-load) 0.45)
  (define-macro (macro-default-max-load) 0.90)

  (define-macro (macro-load-range-lo)    0.05)
  (define-macro (macro-load-range-hi)    0.95)
  (define-macro (macro-load-min-max-gap) 0.20)

  (define (check-size arg-num)
    (if (##eq? size (macro-absent-obj))
        (check-weak-keys 0
                         arg-num)
        (let ((arg-num (##fx+ arg-num 2)))
          (macro-check-index
            size
            arg-num
            (make-table size: size
                        init: init
                        weak-keys: weak-keys
                        weak-values: weak-values
                        test: test
                        hash: hash
                        min-load: min-load
                        max-load: max-load)
            (check-weak-keys (##fxmin size 2000000) ;; avoid fixnum overflows
                             arg-num)))))

  (define (check-weak-keys siz arg-num)
    (if (##eq? weak-keys (macro-absent-obj))
        (check-weak-values siz
                           (macro-default-weak-keys)
                           arg-num)
        (let ((arg-num (##fx+ arg-num 2)))
          (check-weak-values siz
                             (if weak-keys
                                 (macro-gc-hash-table-flag-weak-keys)
                                 0)
                             arg-num))))

  (define (check-weak-values siz flags arg-num)
    (if (##eq? weak-values (macro-absent-obj))
        (check-test siz
                    (##fx+ flags
                           (macro-default-weak-values))
                    arg-num)
        (let ((arg-num (##fx+ arg-num 2)))
          (check-test siz
                      (##fx+ flags
                             (if weak-values
                                 (macro-gc-hash-table-flag-weak-vals)
                                 0))
                      arg-num))))

  (define (check-test siz flags arg-num)
    (if (##eq? test (macro-absent-obj))
        (check-hash siz
                    flags
                    ##equal?
                    arg-num)
        (let ((arg-num (##fx+ arg-num 2)))
          (macro-check-procedure
            test
            arg-num
            (make-table size: size
                        init: init
                        weak-keys: weak-keys
                        weak-values: weak-values
                        test: test
                        hash: hash
                        min-load: min-load
                        max-load: max-load)
            (check-hash siz
                        flags
                        test
                        arg-num)))))

  (define (check-hash siz flags test-fn arg-num)
    (if (##eq? hash (macro-absent-obj))
        (cond ((or (##eq? test-fn ##eq?) (##eq? test-fn eq?))
               (check-loads siz
                            flags
                            #f
                            #f
                            arg-num))
              ((or (##eq? test-fn ##eqv?) (##eq? test-fn eqv?))
               (check-loads siz
                            flags
                            test-fn
                            ##eqv?-hash
                            arg-num))
              ((or (##eq? test-fn ##equal?) (##eq? test-fn equal?))
               (check-loads siz
                            flags
                            test-fn
                            ##equal?-hash
                            arg-num))
              ((or (##eq? test-fn ##string=?) (##eq? test-fn string=?))
               (check-loads siz
                            flags
                            test-fn
                            string=?-hash
                            arg-num))
              ((or (##eq? test-fn ##string-ci=?) (##eq? test-fn string-ci=?))
               (check-loads siz
                            flags
                            test-fn
                            string-ci=?-hash
                            arg-num))
              (else
               (check-loads siz
                            flags
                            test-fn
                            ##generic-hash
                            arg-num)))
        (let ((arg-num (##fx+ arg-num 2)))
          (macro-check-procedure
            hash
            arg-num
            (make-table size: size
                        init: init
                        weak-keys: weak-keys
                        weak-values: weak-values
                        test: test
                        hash: hash
                        min-load: min-load
                        max-load: max-load)
            (check-loads siz
                         flags
                         test-fn
                         hash
                         arg-num)))))

  (define (check-loads siz flags test-fn hash-fn arg-num)
    (if (and (##eq? min-load (macro-absent-obj))
             (##eq? max-load (macro-absent-obj)))
        (checks-done siz
                     flags
                     test-fn
                     hash-fn
                     '#f64(.45 .6363961030678927 .9)
                     arg-num)
        (check-min-load siz
                        flags
                        test-fn
                        hash-fn
                        (##f64vector (macro-default-min-load)
                                     (macro-inexact-+0)
                                     (macro-default-max-load))
                        arg-num)))

  (define (check-min-load siz flags test-fn hash-fn loads arg-num)
    (if (##eq? min-load (macro-absent-obj))
        (check-max-load siz
                        flags
                        test-fn
                        hash-fn
                        loads
                        arg-num)
        (let ((arg-num (##fx+ arg-num 2)))
          (if (##not (##real? min-load))
              (##fail-check-real
               arg-num
               (##list size: size
                       init: init
                       weak-keys: weak-keys
                       weak-values: weak-values
                       test: test
                       hash: hash
                       min-load: min-load
                       max-load: max-load)
               make-table)
              (begin
                (##f64vector-set! loads 0 (macro-real->inexact min-load))
                (check-max-load siz
                                flags
                                test-fn
                                hash-fn
                                loads
                                arg-num))))))

  (define (check-max-load siz flags test-fn hash-fn loads arg-num)
    (if (##eq? max-load (macro-absent-obj))
        (check-loads-done siz
                          flags
                          test-fn
                          hash-fn
                          loads
                          arg-num)
        (let ((arg-num (##fx+ arg-num 2)))
          (if (##not (##real? max-load))
              (##fail-check-real
               arg-num
               (##list size: size
                       init: init
                       weak-keys: weak-keys
                       weak-values: weak-values
                       test: test
                       hash: hash
                       min-load: min-load
                       max-load: max-load)
               make-table)
              (begin
                (##f64vector-set! loads 2 (macro-real->inexact max-load))
                (check-loads-done siz
                                  flags
                                  test-fn
                                  hash-fn
                                  loads
                                  arg-num))))))

  (define (check-loads-done siz flags test-fn hash-fn loads arg-num)
    (##f64vector-set!
     loads
     0
     (##flmin (##fl- (macro-load-range-hi)
                     (macro-load-min-max-gap))
              (##flmax (macro-load-range-lo)
                       (##f64vector-ref loads 0))))
    (##f64vector-set!
     loads
     2
     (##flmin (macro-load-range-hi)
              (##flmax (##fl+ (##f64vector-ref loads 0)
                              (macro-load-min-max-gap))
                       (##f64vector-ref loads 2))))
    (##f64vector-set!
     loads
     1
     (##flsqrt (##fl* (##f64vector-ref loads 0)
                      (##f64vector-ref loads 2))))
    (checks-done siz
                 flags
                 test-fn
                 hash-fn
                 loads
                 arg-num))

  (define (checks-done siz flags test-fn hash-fn loads arg-num)
    (macro-make-table (if (and #f ;; don't make a special case for eq? tables
                               (##not test-fn)
                               (##eq? weak-keys (macro-absent-obj)))
                          (##fxior
                           flags
                           (macro-gc-hash-table-flag-weak-keys))
                          flags)
                      test-fn
                      hash-fn
                      loads
                      siz
                      init))

  (check-size 0))

(define-prim (##make-table
              #!key
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))
  (##make-table-aux
   size
   init
   weak-keys
   weak-values
   test
   hash
   min-load
   max-load))

(define-prim (make-table
              #!key
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))
  (##make-table-aux
   size
   init
   weak-keys
   weak-values
   test
   hash
   min-load
   max-load))

(define (##table-get-eq-gcht table key)
  (##declare (not interrupts-enabled))
  (if (##mem-allocated? key)
      (##table-get-gcht table)
      (##table-get-gcht-not-mem-alloc table)))

(define (##table-get-gcht-not-mem-alloc table)
  (##declare (not interrupts-enabled))
  (or (macro-table-hash table)
      (let* ((n ;; initial size
              (let ((gcht (macro-table-gcht table)))
                (if (##fixnum? gcht)
                    gcht
                    (macro-gc-hash-table-nb-entries gcht))))
             (gcht
              (##gc-hash-table-allocate
               n
               (macro-table-flags table)
               (macro-table-loads table))))
        (macro-table-hash-set! table gcht)
        gcht)))

(define (##table-get-gcht table)
  (##declare (not interrupts-enabled))
  (let ((gcht (macro-table-gcht table)))
    (if (##fixnum? gcht)
        (let* ((n ;; initial size
                gcht)
               (gcht
                (##gc-hash-table-allocate
                 n
                 (##fxior
                  (macro-gc-hash-table-flag-mem-alloc-keys)
                  (macro-table-flags table))
                 (macro-table-loads table))))
          (macro-table-gcht-set! table gcht)
          gcht)
        gcht)))

(define-prim (##table-length table)

  (##declare (not interrupts-enabled))

  (define (count ht)
    (if (##gc-hash-table? ht)
        (macro-gc-hash-table-count ht)
        0))

  (if (macro-table-test table)
      (count (macro-table-gcht table))
      (##fx+ (count (macro-table-hash table))
             (count (macro-table-gcht table)))))

(define-prim (table-length table)
  (macro-force-vars (table)
    (macro-check-table table 1 (table-length table)
      (##table-length table))))

(define-prim (##table-access table key found not-found val)
  (##declare (not interrupts-enabled))
  (let ((f (macro-table-hash table)))
    (let loop1 ((h (f key)))
      (if (##not (##fixnum? h))
          (loop1 (##raise-invalid-hash-number-exception f key))
          (let* ((gcht
                  (let* ((gcht (##table-get-gcht table))
                         (flags (macro-gc-hash-table-flags gcht)))
                    (if (or (##not
                             (##fx=
                              0
                              (##fxand
                               flags
                               (macro-gc-hash-table-flag-need-rehash))))
                            (and (##not
                                  (##fx=
                                   0
                                   (##fxand
                                    flags
                                    (macro-gc-hash-table-flag-entry-deleted))))
                                 (begin
                                   (macro-gc-hash-table-flags-set!
                                    gcht
                                    (##fxand
                                     (macro-gc-hash-table-flags gcht)
                                     (##fxnot
                                      (macro-gc-hash-table-flag-entry-deleted))))
                                   (##fx<
                                    (macro-gc-hash-table-count gcht)
                                    (macro-gc-hash-table-min-count gcht)))))
                        (begin
                          (##table-resize! table)
                          (macro-table-gcht table))
                        gcht)))
                 (size
                  (macro-gc-hash-table-nb-entries gcht))
                 (probe2
                  (##fxarithmetic-shift-left
                   (##fxmodulo h size)
                   1))
                 (step2
                  2)
                 (size2
                  (##fxarithmetic-shift-left size 1))
                 (test
                  (macro-table-test table)))
            (let loop2 ((probe2 probe2)
                        (deleted2 #f))
              (let ((k (macro-gc-hash-table-key-ref gcht probe2)))
                (cond ((##eq? k (macro-unused-obj))
                       (not-found table key gcht probe2 deleted2 val))
                      ((##eq? k (macro-deleted-obj))
                       (let ((next-probe2 (##fx- probe2 step2)))
                         (loop2 (if (##fx< next-probe2 0)
                                    (##fx+ next-probe2 size2)
                                    next-probe2)
                                (or deleted2 probe2))))
                      ((test key k)
                       (found table key gcht probe2 val))
                      (else
                       (let ((next-probe2 (##fx- probe2 step2)))
                         (loop2 (if (##fx< next-probe2 0)
                                    (##fx+ next-probe2 size2)
                                    next-probe2)
                                deleted2)))))))))))

(define-prim (##table-ref
              table
              key
              #!optional
              (default-value (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((test (macro-table-test table)))
    (if test

        (##table-access
         table
         key
         (lambda (table key gcht probe2 default-value)
           ;; key was found at position "probe2" so just return value field
           (macro-gc-hash-table-val-ref gcht probe2))
         (lambda (table key gcht probe2 deleted2 default-value)
           ;; key was not found (search ended at position "probe2" and the
           ;; first deleted entry encountered is at position "deleted2")
           (cond ((##not (##eq? default-value (macro-absent-obj)))
                  default-value)
                 ((##not (##eq? (macro-table-init table) (macro-absent-obj)))
                  (macro-table-init table))
                 (else
                  (##raise-unbound-key-exception
                   table-ref
                   table
                   key))))
         default-value)

        (let* ((gcht (##table-get-eq-gcht table key))
               (val (##gc-hash-table-ref gcht key)))
          (if (##eq? val (macro-unused-obj))
              (cond ((##not (##eq? default-value (macro-absent-obj)))
                     default-value)
                    ((##not (##eq? (macro-table-init table) (macro-absent-obj)))
                     (macro-table-init table))
                    (else
                     (##raise-unbound-key-exception
                      table-ref
                      table
                      key)))
              val)))))

(define-prim (table-ref
              table
              key
              #!optional
              (default-value (macro-absent-obj)))
  (macro-force-vars (table key default-value)
    (macro-check-table table 1 (table-ref table key default-value)
      (##table-ref table key default-value))))

(define-prim (##table-resize! table)
  (##declare (not interrupts-enabled))
  (let ((gcht (macro-table-gcht table)))
    (let ((new-gcht
           (##gc-hash-table-resize! gcht (macro-table-loads table))))
      (macro-table-gcht-set! table new-gcht)
      (let loop ((i (macro-gc-hash-table-key0)))
        (if (##fx< i (##vector-length gcht))
            (let ((key (##vector-ref gcht i)))
              (if (and (##not (##eq? key (macro-unused-obj)))
                       (##not (##eq? key (macro-deleted-obj))))
                  (let ((val (##vector-ref gcht (##fx+ i 1))))
                    (##table-set! table key val)))
              (let ()
                (##declare (interrupts-enabled))
                (loop (##fx+ i 2))))
            (##void))))))

(define-prim (##table-set!
              table
              key
              #!optional
              (val (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  (let ((test (macro-table-test table)))
    (if test

        (##table-access
         table
         key
         (lambda (table key gcht probe2 val)
           ;; key was found at position "probe2"
           (if (##eq? val (macro-absent-obj))
               (let ((count (##fx- (macro-gc-hash-table-count gcht) 1)))
                 (macro-gc-hash-table-count-set! gcht count)
                 (macro-gc-hash-table-key-set! gcht probe2 (macro-deleted-obj))
                 (macro-gc-hash-table-val-set! gcht probe2 (macro-unused-obj))
                 (if (##fx< count (macro-gc-hash-table-min-count gcht))
                     (##table-resize! table)
                     (##void)))
               (begin
                 (macro-gc-hash-table-val-set! gcht probe2 val)
                 (##void))))
         (lambda (table key gcht probe2 deleted2 val)
           ;; key was not found (search ended at position "probe2" and the
           ;; first deleted entry encountered is at position "deleted2")
           (if (##eq? val (macro-absent-obj))
               (##void)
               (if deleted2
                   (let ((count (##fx+ (macro-gc-hash-table-count gcht) 1)))
                     (macro-gc-hash-table-count-set! gcht count)
                     (macro-gc-hash-table-key-set! gcht deleted2 key)
                     (macro-gc-hash-table-val-set! gcht deleted2 val)
                     (##void))
                   (let ((count (##fx+ (macro-gc-hash-table-count gcht) 1))
                         (free (##fx- (macro-gc-hash-table-free gcht) 1)))
                     (macro-gc-hash-table-count-set! gcht count)
                     (macro-gc-hash-table-free-set! gcht free)
                     (macro-gc-hash-table-key-set! gcht probe2 key)
                     (macro-gc-hash-table-val-set! gcht probe2 val)
                     (if (##fx< free 0)
                         (##table-resize! table)
                         (##void))))))
         val)

        (let ((gcht (##table-get-eq-gcht table key)))
          (if (##gc-hash-table-set! gcht key val)
              (let ((new-gcht
                     (##gc-hash-table-rehash!
                      gcht
                      (##gc-hash-table-resize! gcht (macro-table-loads table)))))
                (if (##mem-allocated? key)
                    (macro-table-gcht-set! table new-gcht)
                    (macro-table-hash-set! table new-gcht))))
          (##void)))))

(define-prim (table-set!
              table
              key
              #!optional
              (val (macro-absent-obj)))
  (macro-force-vars (table key val)
    (macro-check-table table 1 (table-set! table key val)
      (##table-set! table key val))))

(define-prim (##table-search proc table)
  (or (##gc-hash-table-search proc (macro-table-gcht table))
      (and (##not (macro-table-test table))
           (##gc-hash-table-search proc (macro-table-hash table)))))

(define-prim (table-search proc table)
  (macro-force-vars (proc table)
    (macro-check-procedure proc 1 (table-search proc table)
      (macro-check-table table 2 (table-search proc table)
        (##table-search proc table)))))

(define-prim (##table-for-each proc table)
  (##gc-hash-table-for-each proc (macro-table-gcht table))
  (if (##not (macro-table-test table))
    (##gc-hash-table-for-each proc (macro-table-hash table))))

(define-prim (table-for-each proc table)
  (macro-force-vars (proc table)
    (macro-check-procedure proc 1 (table-for-each proc table)
      (macro-check-table table 2 (table-for-each proc table)
        (##table-for-each proc table)))))

(define-prim (##table-foldl f base proc table)
  (let ((x (##gc-hash-table-foldl f base proc (macro-table-gcht table))))
    (if (macro-table-test table)
        x
        (##gc-hash-table-foldl f x proc (macro-table-hash table)))))

(define-prim (##table->list table)
  (let ((cons (lambda (x y) (##cons x y)))
        (rcons (lambda (x y) (##cons y x))))
    (##table-foldl rcons '() cons table)))

(define-prim (table->list table)
  (macro-force-vars (table)
    (macro-check-table table 1 (table->list table)
      (##table->list table))))

(define-prim (##list->table-aux
              lst
              #!optional
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))
  (let ((table
         (##make-table-aux
          size
          init
          weak-keys
          weak-values
          test
          hash
          min-load
          max-load)))
    (let loop ((x lst))
      (macro-force-vars (x)
        (if (##pair? x)
            (let ((couple (##car x)))
              (macro-force-vars (couple)
                (macro-check-pair-list-pair
                  couple
                  1
                  (list->table lst
                               size: size
                               init: init
                               weak-keys: weak-keys
                               weak-values: weak-values
                               test: test
                               hash: hash
                               min-load: min-load
                               max-load: max-load)
                  (let ((key (##car couple)))
                    (if (##eq? table (##table-ref table key table))
                        (##table-set! table key (##cdr couple)))
                    (loop (##cdr x))))))
            (macro-check-proper-list-null
              x
              1
              (list->table lst
                           size: size
                           init: init
                           weak-keys: weak-keys
                           weak-values: weak-values
                           test: test
                           hash: hash
                           min-load: min-load
                           max-load: max-load)
              table))))))

(define-prim (##list->table
              lst
              #!key
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))
  (##list->table-aux
   lst
   size
   init
   weak-keys
   weak-values
   test
   hash
   min-load
   max-load))

(define-prim (list->table
              lst
              #!key
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))
  (##list->table-aux
   lst
   size
   init
   weak-keys
   weak-values
   test
   hash
   min-load
   max-load))

(define-prim (##table-copy table)
  (let* ((size
          (##table-length table))
         (init
          (macro-table-init table))
         (flags
          (macro-table-flags table))
         (weak-keys
          (##not (##fx= 0 (##fxand
                           flags
                           (macro-gc-hash-table-flag-weak-keys)))))
         (weak-values
          (##not (##fx= 0 (##fxand
                           flags
                           (macro-gc-hash-table-flag-weak-vals)))))
         (test-field
          (macro-table-test table))
         (test
          (or test-field
              ##eq?)) ;; test-field = #f means test function = ##eq?
         (hash
          (if test-field
              (macro-table-hash table)
              (macro-absent-obj))) ;; test-field = #f means special hash function
         (loads
          (macro-table-loads table))
         (min-load
          (##f64vector-ref loads 0))
         (max-load
          (##f64vector-ref loads 2)))
    (let ((t
           (##make-table-aux
            size
            init
            weak-keys
            weak-values
            test
            hash
            min-load
            max-load)))
      (##table-for-each
       (lambda (k v)
         (##table-set! t k v))
       table)
      t)))

(define-prim (table-copy table)
  (macro-force-vars (table)
    (macro-check-table table 1 (table-copy table)
      (##table-copy table))))

(define-prim (##table-merge! table1
                             table2
                             #!optional
                             (table2-takes-precedence? #f))
  (if table2-takes-precedence?
      (##table-for-each
       (lambda (k v)
         (##table-set! table1 k v))
       table2)
      (##table-for-each
       (lambda (k v)
         (if (##eq? (##table-ref table1 k (macro-unused-obj))
                    (macro-unused-obj))
             (##table-set! table1 k v)))
       table2))
  table1)

(define-prim (table-merge! table1
                           table2
                           #!optional
                           (table2-takes-precedence? (macro-absent-obj)))
  (macro-force-vars (table1 table2 table2-takes-precedence?)
    (macro-check-table
      table1
      1
      (table-merge! table1 table2 table2-takes-precedence?)
      (macro-check-table
        table2
        2
        (table-merge! table1 table2 table2-takes-precedence?)
        (let ((t2-takes-precedence?
               (if (##eq? table2-takes-precedence? (macro-absent-obj))
                   #f
                   table2-takes-precedence?)))
          (##table-merge! table1 table2 t2-takes-precedence?))))))

(define-prim (##table-merge table1
                            table2
                            #!optional
                            (table2-takes-precedence? #f))
  (##table-merge! (##table-copy table1)
                  table2
                  table2-takes-precedence?))

(define-prim (table-merge table1
                          table2
                          #!optional
                          (table2-takes-precedence? (macro-absent-obj)))
  (macro-force-vars (table1 table2 table2-takes-precedence?)
    (macro-check-table
      table1
      1
      (table-merge table1 table2 table2-takes-precedence?)
      (macro-check-table
        table2
        2
        (table-merge table1 table2 table2-takes-precedence?)
        (let ((t2-takes-precedence?
               (if (##eq? table2-takes-precedence? (macro-absent-obj))
                   #f
                   table2-takes-precedence?)))
          (##table-merge table1 table2 t2-takes-precedence?))))))

)

;;;----------------------------------------------------------------------------

 (else

(define-prim (##make-table-aux
              #!optional
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys #f)
              (weak-values #f)
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))

  (define (check-test arg-num)
    (if (##eq? test (macro-absent-obj))
      (checks-done ##equal?
                   arg-num)
      (let ((arg-num (##fx+ arg-num 2)))
        (macro-check-procedure
         test
         arg-num
         (make-table size: size
                     init: init
                     weak-keys: weak-keys
                     weak-values: weak-values
                     test: test
                     hash: hash
                     min-load: min-load
                     max-load: max-load)
         (checks-done test
                      arg-num)))))

  (define (checks-done test-fn arg-num)
    (macro-make-table (if (or (##eq? test-fn eq?)
                              (##eq? test-fn ##eq?))
                          #f
                          test-fn)
                      init
                      ;; weak-keys/values are extended booleans
                      (##univ-table-make-hashtable (##not (##not weak-keys))
                                                   (##not (##not weak-values)))
                      (##fx+ (if weak-keys 1 0)
                             (if weak-values 2 0))
))

  (check-test 0))

(define-prim (##make-table
              #!key
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))
  (##make-table-aux
   size
   init
   weak-keys
   weak-values
   test
   hash
   min-load
   max-load))

(define-prim (make-table
              #!key
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))
  (##make-table-aux
   size
   init
   weak-keys
   weak-values
   test
   hash
   min-load
   max-load))

(define-prim (##table-find-key
              table
              key
              #!optional
              (found (lambda (key) key))
              (not-found (lambda () #!void)))
  (let ((test (macro-table-test table)))
    (let loop ((keys (##univ-table-keys (macro-table-hashtable table))))
      (cond
       ((##null? keys)
        (not-found))
       ((test (##car keys) key)
        (found (##car keys)))
       (else
        (loop (##cdr keys)))))))

(define-prim (##table-ref
              table
              key
              #!optional
              (default-value (macro-absent-obj)))

  (let ((test (macro-table-test table)))
    (define (found key)
      (##univ-table-ref (macro-table-hashtable table) key))
    (define (not-found)
      (cond
       ((##not (##eq? default-value (macro-absent-obj)))
        default-value)
       ((##not (##eq? (macro-table-init table) (macro-absent-obj)))
        (macro-table-init table))
       (else
        (##raise-unbound-key-exception
         table-ref
         table
         key))))
    (cond
     (test ;; not and eq?-table
      (##table-find-key table key found not-found))
     ((##univ-table-key-exists? (macro-table-hashtable table) key)
      (found key))
     (else
      (not-found)))))

(define-prim (table-ref
              table
              key
              #!optional
              (default-value (macro-absent-obj)))
  (macro-force-vars (table key default-value)
    (macro-check-table table 1 (table-ref table key default-value)
      (##table-ref table key default-value))))

(define-prim (##table-set!
              table
              key
              #!optional
              (val (macro-absent-obj)))

  (let ((test (macro-table-test table)))
    (if (macro-table-test table) ;; if it's not an eq?-table
        (##table-find-key table key
                          (lambda (k)
                            (##univ-table-delete (macro-table-hashtable table) k))))

    (if (##eq? val (macro-absent-obj))
        (##univ-table-delete (macro-table-hashtable table) key)
        (##univ-table-set! (macro-table-hashtable table)
                           key
                           val))))

(define-prim (table-set!
              table
              key
              #!optional
              (val (macro-absent-obj)))
  (macro-force-vars (table key val)
    (macro-check-table table 1 (table-set! table key val)
      (##table-set! table key val))))

(define-prim (##table-length table)
  (##univ-table-length (macro-table-hashtable table)))

(define-prim (table-length table)
  (macro-force-vars (table)
    (macro-check-table table 1 (table-length table)
      (##table-length table))))

(define-prim (##table->list table)
  (let ((hashtable (macro-table-hashtable table)))
    (map (lambda (key)
           (cons key (##univ-table-ref hashtable key)))
         (##univ-table-keys (macro-table-hashtable table)))))

(define-prim (table->list table)
  (macro-force-vars (table)
    (macro-check-table table 1 (table->list table)
      (##table->list table))))

(define-prim (##list->table-aux
              lst
              #!optional
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))
  (let ((table
         (##make-table-aux
          size
          init
          weak-keys
          weak-values
          test
          hash
          min-load
          max-load)))
    (let loop ((x lst))
      (if (##pair? x)
          (let ((couple (##car x)))
            (macro-check-pair-list-pair
             couple
             1
             (list->table lst
                          size: size
                          init: init
                          weak-keys: weak-keys
                          weak-values: weak-values
                          test: test
                          hash: hash
                          min-load: min-load
                          max-load: max-load)
             (##univ-table-set! (macro-table-hashtable table)
                                (##car couple)
                                (##cdr couple)))
            (loop (##cdr x)))
          (macro-check-proper-list-null
           x
           1
           (list->table lst
                        size: size
                        init: init
                        weak-keys: weak-keys
                        weak-values: weak-values
                        test: test
                        hash: hash
                        min-load: min-load
                        max-load: max-load)
           table)))))

(define-prim (##list->table
              lst
              #!key
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))
  (##list->table-aux lst))

(define-prim (list->table
              lst
              #!key
              (size (macro-absent-obj))
              (init (macro-absent-obj))
              (weak-keys (macro-absent-obj))
              (weak-values (macro-absent-obj))
              (test (macro-absent-obj))
              (hash (macro-absent-obj))
              (min-load (macro-absent-obj))
              (max-load (macro-absent-obj)))
  (##list->table-aux lst))

(define-prim (##table-copy table)
  (let ((copy (##make-table-aux
               (macro-absent-obj) ;; size
               (macro-table-init table) ;; init
               (##fxand 1 (macro-table-flags table)) ;; weak-keys
               (##fxand 2 (macro-table-flags table)) ;; weak-values
               (or (macro-table-test table) ##eq?) ;; test
               (macro-absent-obj) ;; hash
               (macro-absent-obj) ;; min-load
               (macro-absent-obj)))) ;; max-load
    (for-each
     (lambda (pair)
       (##table-set! copy (##car pair) (##cdr pair)))
     (##table->list table))
    copy))

(define-prim (table-copy table)
  (macro-force-vars (table)
    (macro-check-table table 1 (table-copy table)
      (##table-copy table))))

(define-prim (##table-search proc table)
  (let loop ((lst (##table->list table)))
    (if (##pair? lst)
        (let ((pair (##car lst)))
          (or (proc (##car pair) (##cdr pair))
              (loop (##cdr lst))))
        #f)))

(define-prim (table-search proc table)
  (##table-search proc table))

(define-prim (##table-for-each proc table)
  (let loop ((lst (##table->list table)))
    (if (##pair? lst)
        (let ((pair (##car lst)))
          (proc (##car pair) (##cdr pair))
          (loop (##cdr lst)))
        #!void)))

(define-prim (table-for-each proc table)
  (##table-for-each proc table))

))

;;;----------------------------------------------------------------------------

;;; Serial numbers.

;;; imports:
;;; from _kernel.scm
;;;    (##extract-procedure-and-arguments ...)
;;;    (##raise-type-exception ...)
;;; from _num.scm
;;;    (##fail-check-exact-integer ...)
;;;    (##raise-range-exception ...)
;;; from _table.scm
;;;    (##make-table-aux ...)
;;;    (##table-ref ...)
;;;    (##table-set! ...)

;;; exports:
;;;    (##fail-check-unbound-serial-number-exception ...)
;;;    (##object->serial-number ...)
;;;    (##raise-unbound-serial-number-exception ...)
;;;    (##serial-number->object ...)
;;;    (object->serial-number ...)
;;;    (serial-number->object ...)
;;;    (unbound-serial-number-exception-arguments ...)
;;;    (unbound-serial-number-exception-procedure ...)
;;;    (unbound-serial-number-exception? ...)

;;;----------------------------------------------------------------------------

(implement-library-type-unbound-serial-number-exception)

(define-prim (##raise-unbound-serial-number-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-unbound-serial-number-exception
       procedure
       arguments)))))

(define ##last-serial-number 0)

(define ##object-to-serial-number-table (##make-table-aux 0 #f #t #f ##eq?))
(define ##serial-number-to-object-table (##make-table-aux 0 #f #f #t ##eq?))

(define-prim (##object->serial-number obj)
  (let loop ()
    (##declare (not interrupts-enabled))
    (or (##table-ref ##object-to-serial-number-table obj #f)
        (let* ((n ##last-serial-number)
               (n+1 (or (##fx+? n 1) 0)))
          (set! ##last-serial-number n+1)
          (if (##table-ref ##serial-number-to-object-table n+1 #f)
              (loop)
              (begin
                (##table-set! ##object-to-serial-number-table obj n+1)
                (##table-set! ##serial-number-to-object-table n+1 obj)
                n+1))))))

(define-prim (object->serial-number obj)
  (##object->serial-number obj))

(define-prim (##serial-number->object
              sn
              #!optional
              (default-value (macro-absent-obj)))
  (let ((result
         (##table-ref ##serial-number-to-object-table sn (macro-unused-obj))))
    (cond ((##not (##eq? result (macro-unused-obj)))
           result)
          ((##eq? default-value (macro-absent-obj))
           (##raise-unbound-serial-number-exception serial-number->object sn))
          (else
           default-value))))

(define-prim (serial-number->object
              sn
              #!optional
              (default-value (macro-absent-obj)))
  (macro-force-vars (sn default-value)
    (macro-check-index sn 1 (serial-number->object sn default-value)
      (##serial-number->object sn default-value))))

;;;----------------------------------------------------------------------------

;;; Binary serialization/deserialization.

;;; imports:
;;; from _kernel.scm
;;;    ##max-char
;;;    ##max-fixnum
;;;    (##global-var? ...)
;;;    (##type-id ...)
;;;    (##type-super ...)
;;;    (##fail-check-procedure ...)
;;;    (##system-version ...)
;;;    (##structure-instance-of? ...)
;;; from _equal.scm
;;;    (##eq? ...)
;;;    (##eqv? ...)
;;; from _table.scm
;;;    (##make-table-aux ...)
;;;    (##table-ref ...)
;;;    (##table-set! ...)
;;; from _num.scm
;;;    (##+ ...)
;;;    (##arithmetic-shift ...)
;;;    (##bit-set? ...)
;;;    (##bitwise-ior ...)
;;;    (##extract-bit-field ...)
;;;    (##flonum->ieee754-32 ...)
;;;    (##flonum->ieee754-64 ...)
;;;    (##ieee754-32->flonum ...)
;;;    (##ieee754-64->flonum ...)
;;;    (##integer-length ...)
;;; from _std.scm
;;;    (##fail-check-u8vector ...)
;;;    (##fifo->u8vector ...)
;;;    (##subvector-move! ...)
;;;    (##uninterned-keyword? ...)
;;;    (##uninterned-symbol? ...)
;;; from _nonstd.scm
;;;    (error ...)

;;; exports:
;;;    (##object->u8vector ...)
;;;    (##u8vector->object ...)
;;;    (object->u8vector ...)
;;;    (u8vector->object ...)

;;;----------------------------------------------------------------------------

;; Needed to give a temporary type to structures while they are in the
;; process of being deserialized.

(implement-type-partially-initialized-structure)

;;;----------------------------------------------------------------------------

(##define-macro (shared-tag-mask)    #x80)
(##define-macro (shared-tag)         #x80)

(##define-macro (other-tag-mask)     #xf0)
(##define-macro (symbol-tag)         #x00)
(##define-macro (string-tag)         #x10)
(##define-macro (vector-tag)         #x20)
(##define-macro (structure-tag)      #x30)
(##define-macro (subprocedure-tag)   #x40)
(##define-macro (exact-int-tag)      #x50)

(##define-macro (character-tag)      #x60)
(##define-macro (flonum-tag)         #x61)
(##define-macro (ratnum-tag)         #x62)
(##define-macro (cpxnum-tag)         #x63)
(##define-macro (pair-tag)           #x64)
(##define-macro (continuation-tag)   #x65)
(##define-macro (boxvalues-tag)      #x66)
(##define-macro (ui-symbol-tag)      #x67)
(##define-macro (keyword-tag)        #x68)
(##define-macro (ui-keyword-tag)     #x69)
(##define-macro (closure-tag)        #x6a)
(##define-macro (frame-tag)          #x6b)
(##define-macro (gchashtable-tag)    #x6c)
(##define-macro (meroon-tag)         #x6d)
(##define-macro (jazz-tag)           #x6f) ;; note: tag is not consecutive
(##define-macro (homvector-tag)      #x6e)

(##define-macro (false-tag)          #x70)
(##define-macro (true-tag)           #x71)
(##define-macro (nil-tag)            #x72)
(##define-macro (eof-tag)            #x73)
(##define-macro (void-tag)           #x74)
(##define-macro (absent-tag)         #x75)
(##define-macro (unbound-tag)        #x76)
(##define-macro (unbound2-tag)       #x77)
(##define-macro (optional-tag)       #x78)
(##define-macro (key-tag)            #x79)
(##define-macro (rest-tag)           #x7a)
(##define-macro (unused-tag)         #x7b)
(##define-macro (deleted-tag)        #x7c)
(##define-macro (promise-tag)        #x7d)
(##define-macro (unassigned1-tag)    #x7e)
(##define-macro (unassigned2-tag)    #x7f)

(##define-macro (s8vector-tag)       #x00)
(##define-macro (u8vector-tag)       #x01)
(##define-macro (s16vector-tag)      #x02)
(##define-macro (u16vector-tag)      #x03)
(##define-macro (s32vector-tag)      #x04)
(##define-macro (u32vector-tag)      #x05)
(##define-macro (f32vector-tag)      #x06)
(##define-macro (s64vector-tag)      #x07)
(##define-macro (u64vector-tag)      #x08)
(##define-macro (f64vector-tag)      #x09)

(##namespace ("##"
 structure?
 gc-hash-table?
 fixnum?
 subtype-set!
 subvector-move!
 continuation?
 make-continuation
 continuation-frame
 continuation-frame-set!
 continuation-denv
 continuation-denv-set!
 continuation-fs
 continuation-ret
 continuation-link
 continuation-slot-live?
 continuation-ref
 continuation-set!
 continuation-next
 frame?
 make-frame
 frame-ret
 frame-fs
 frame-ref
 frame-set!
 frame-slot-live?
 subprocedure-parent-name
 subprocedure-id
 subprocedure-nb-closed
 closure?
 make-closure
 closure-code
 closure-ref
 closure-set!
 make-delay-promise
 promise-state
 promise-state-set!
 box?
 box
 unbox
 set-box!
 values?
 make-values
 values-length
 values-ref
 values-set!
 extract-bit-field
 bignum?
 subtyped?
 flonum?
 ratnum?
 cpxnum?
 promise?
 make-string
 string?
 string-length
 string-ref
 string-set!
 make-vector
 vector?
 vector-length
 vector-ref
 vector-set!
 make-s8vector
 s8vector?
 s8vector-length
 s8vector-ref
 s8vector-set!
 s8vector-shrink!
 make-u8vector
 u8vector?
 u8vector-length
 u8vector-ref
 u8vector-set!
 u8vector-shrink!
 fifo->u8vector
 make-s16vector
 s16vector?
 s16vector-length
 s16vector-ref
 s16vector-set!
 s16vector-shrink!
 make-u16vector
 u16vector?
 u16vector-length
 u16vector-ref
 u16vector-set!
 u16vector-shrink!
 make-s32vector
 s32vector?
 s32vector-length
 s32vector-ref
 s32vector-set!
 s32vector-shrink!
 make-u32vector
 u32vector?
 u32vector-length
 u32vector-ref
 u32vector-set!
 u32vector-shrink!
 make-s64vector
 s64vector?
 s64vector-length
 s64vector-ref
 s64vector-set!
 s64vector-shrink!
 make-u64vector
 u64vector?
 u64vector-length
 u64vector-ref
 u64vector-set!
 u64vector-shrink!
 make-f32vector
 f32vector?
 f32vector-length
 f32vector-ref
 f32vector-set!
 f32vector-shrink!
 make-f64vector
 f64vector?
 f64vector-length
 f64vector-ref
 f64vector-set!
 f64vector-shrink!
 symbol?
 symbol->string
 string->symbol
 keyword?
 keyword->string
 string->keyword
 integer-length
 table-ref
 table-set!
 uninterned-keyword?
 uninterned-symbol?
 char->integer
 integer->char
 vector
 cons
 pair?
 car
 cdr
 set-car!
 set-cdr!
 procedure?
 char?
 real?
 not
 eq?
 eqv?
 fx+
 fx-
 fx*
 fx<
 fx>
 fx=
 fx<=
 fx>=
 fxand
 fxior
 fxarithmetic-shift-left
 fxwraplogical-shift-right
 negative?
 +
 arithmetic-shift
 bit-set?
 bitwise-ior
 extract-bit-field
 gcd
 ))

(##define-macro (max-fixnum)
  `##max-fixnum)

(##define-macro (max-char)
  `##max-char)

(##define-macro (make-table . args)
  `(##make-table-aux 0 #f #f #f ##eq?))

(define-prim (##object->u8vector
              obj
              #!optional
              (transform (macro-absent-obj)))

  (define (cannot-serialize obj)
    (error "can't serialize" obj))

  (define chunk-len 256) ;; must be a power of 2

  (define state
    (vector 0
            (macro-make-fifo)
            0
            (make-table test: ##eq?)
            (if (eq? transform (macro-absent-obj))
                (lambda (x) x)
                transform)))

  (define (write-u8 x)
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

  (define (share obj)
    (let ((n (table-ref (vector-ref state 3) obj #f)))
      (if n
          (begin
            (serialize-shared! n)
            #t)
          #f)))

  (define (alloc! obj)
    (let ((n (vector-ref state 2)))
      (vector-set! state 2 (fx+ n 1))
      (table-set! (vector-ref state 3) obj n)))

  (define (serialize-shared! n)
    (let ((lo (fxand n #x7f))
          (hi (fxwraplogical-shift-right n 7)))
      (write-u8 (fxior (shared-tag) lo))
      (serialize-nonneg-fixnum! hi)))

  (define (serialize-nonneg-fixnum! n)
    (let ((lo (fxand n #x7f))
          (hi (fxwraplogical-shift-right n 7)))
      (if (fx= hi 0)
          (write-u8 lo)
          (begin
            (write-u8 (fxior #x80 lo))
            (serialize-nonneg-fixnum! hi)))))

  (define (serialize-flonum-32! n)
    (serialize-exact-int-of-length!
     (##flonum->ieee754-32 n)
     4))

  (define (serialize-flonum-64! n)
    (serialize-exact-int-of-length!
     (##flonum->ieee754-64 n)
     8))

  (define (serialize-exact-int-of-length! n len)
    (if (fixnum? n)
        (let loop ((n n) (len len))
          (if (fx> len 0)
              (begin
                (write-u8 (fxand n #xff))
                (loop (fxarithmetic-shift-right n 8) (fx- len 1)))))
        (let* ((len/2 (fxwraplogical-shift-right len 1))
               (len/2*8 (fx* len/2 8)))
          (serialize-exact-int-of-length!
           (extract-bit-field len/2*8 0 n)
           len/2)
          (serialize-exact-int-of-length!
           (arithmetic-shift n (fx- len/2*8))
           (fx- len len/2)))))

  (define (exact-int-length n signed?)
    (fxwraplogical-shift-right
     (fx+ (integer-length n) (if signed? 8 7))
     3))

  (define (serialize-exact-int! n)
    (or (share n)
        (let ((len (exact-int-length n #t)))
          (if (fx<= len 4)
              (write-u8 (fxior (exact-int-tag) (fx- #x0f len)))
              (begin
                (write-u8 (fxior (exact-int-tag) #x0f))
                (serialize-nonneg-fixnum! len)))
          (serialize-exact-int-of-length! n len)
          (alloc! n))))

  (define (serialize-vector-like! vect vect-tag vect-length vect-ref)
    (let ((len (vect-length vect)))
      (if (fx< len #x0f)
          (write-u8 (fxior vect-tag len))
          (begin
            (write-u8 (fxior vect-tag #x0f))
            (serialize-nonneg-fixnum! len)))
      (serialize-subvector! vect 0 len vect-ref)))

  (define (serialize-subvector! vect start end vect-ref)
    (let loop ((i start))
      (if (fx< i end)
          (begin
            (serialize! (vect-ref vect i))
            (loop (fx+ i 1))))))

  (define (serialize-string-like! str tag mask)
    (let ((len (string-length str)))
      (if (fx< len mask)
          (write-u8 (fxior tag len))
          (begin
            (write-u8 (fxior tag mask))
            (serialize-nonneg-fixnum! len)))
      (serialize-string! str)))

  (define (serialize-string! str)
    (serialize-elements!
     str
     0
     (string-length str)
     (lambda (str i)
       (serialize-nonneg-fixnum! (char->integer (string-ref str i))))))

  (define (serialize-elements! obj start end serialize-element!)
    (let loop ((i start))
      (if (fx< i end)
          (begin
            (serialize-element! obj i)
            (loop (fx+ i 1))))))

  (define (serialize-homintvector! vect vect-tag vect-length vect-ref elem-len)
    (or (share vect)
        (let ((len (vect-length vect)))
          (write-u8 (homvector-tag))
          (serialize-nonneg-fixnum!
           (fxior vect-tag (fxarithmetic-shift-left len 4)))
          (serialize-elements!
           vect
           0
           len
           (lambda (vect i)
             (serialize-exact-int-of-length!
              (vect-ref vect i)
              elem-len)))
          (alloc! vect))))

  (define (serialize-homfloatvector! vect vect-tag vect-length vect-ref f32?)
    (or (share vect)
        (let ((len (vect-length vect)))
          (write-u8 (homvector-tag))
          (serialize-nonneg-fixnum!
           (fxior vect-tag (fxarithmetic-shift-left len 4)))
          (serialize-elements!
           vect
           0
           len
           (lambda (vect i)
             (let ((n (vect-ref vect i)))
               (if f32?
                   (serialize-flonum-32! n)
                   (serialize-flonum-64! n)))))
          (alloc! vect))))

  (define (serialize-subprocedure! subproc tag mask)
    (or (share subproc)
        (let ((parent-name (subprocedure-parent-name subproc)))
          (if (not parent-name)
              (cannot-serialize subproc)
              (let ((subproc-id (subprocedure-id subproc)))
                (if (fx< subproc-id mask)
                    (write-u8 (fxior tag subproc-id))
                    (begin
                      (write-u8 (fxior tag mask))
                      (serialize-nonneg-fixnum! subproc-id)))
                (serialize! (##system-version))
                (or (share parent-name)
                    (let ((str (symbol->string parent-name)))
                      (serialize-string-like! str 0 #x7f)
                      (alloc! parent-name)))
                (alloc! subproc))))))

  (define (serialize! obj)
    (let* ((transform (vector-ref state 4))
           (obj (transform obj)))
      (cond ((fixnum? obj)
             (cond ((and (fx>= obj #x00)
                         (fx< obj #x0b))
                    (write-u8 (fxior (exact-int-tag) obj)))
                   ((and (fx>= obj #x-80)
                         (fx< obj #x80))
                    (write-u8 (fxior (exact-int-tag) #x0e))
                    (write-u8 (fxand obj #xff)))
                   (else
                    (serialize-exact-int! obj))))

            ((pair? obj)
             (or (share obj)
                 (begin
                   (alloc! obj)
                   (write-u8 (pair-tag))
                   (serialize! (car obj))
                   (serialize! (cdr obj)))))

            ((symbol? obj)
             (or (share obj)
                 (begin
                   (if (uninterned-symbol? obj)
                       (begin
                         (write-u8 (ui-symbol-tag))
                         (serialize-string-like!
                          (symbol->string obj)
                          0
                          #xff)
                         (serialize-exact-int-of-length!
                          (##symbol-hash obj)
                          4))
                       (serialize-string-like!
                        (symbol->string obj)
                        (symbol-tag)
                        #x0f))
                   (write-u8 (if (##global-var? obj) 1 0))
                   (alloc! obj))))

            ((keyword? obj)
             (or (share obj)
                 (begin
                   (if (uninterned-keyword? obj)
                       (begin
                         (write-u8 (ui-keyword-tag))
                         (serialize-string-like!
                          (keyword->string obj)
                          0
                          #xff)
                         (serialize-exact-int-of-length!
                          (##keyword-hash obj)
                          4))
                       (serialize-string-like!
                        (keyword->string obj)
                        (keyword-tag)
                        0))
                   (alloc! obj))))

            ((string? obj)
             (or (share obj)
                 (begin
                   (serialize-string-like!
                    obj
                    (string-tag)
                    #x0f)
                   (alloc! obj))))

            ((vector? obj)
             (or (share obj)
                 (begin
                   (alloc! obj)
                   (serialize-vector-like!
                    obj
                    (vector-tag)
                    (lambda (vect) (vector-length vect))
                    (lambda (vect i) (vector-ref vect i))))))

            ((structure? obj)
             (if (or (macro-thread? obj)
                     (macro-tgroup? obj)
                     (macro-mutex? obj)
                     (macro-condvar? obj))
                 (cannot-serialize obj)
                 (or (share obj)
                     (begin
                       (alloc! obj)
                       (serialize-vector-like!
                        obj
                        (structure-tag)
                        (lambda (obj) (##structure-length obj))
                        (lambda (obj i) (##unchecked-structure-ref obj i #f #f)))))))

            ((procedure? obj)
             (if (closure? obj)

                 (or (share obj)
                     (begin
                       (write-u8 (closure-tag))
                       (let* ((subproc
                               (closure-code obj))
                              (nb-closed
                               (subprocedure-nb-closed subproc)))
                         (serialize-subprocedure! subproc 0 #x7f)
                         (alloc! obj)
                         (let loop ((i 1))
                           (if (fx<= i nb-closed)
                               (begin
                                 (serialize! (closure-ref obj i))
                                 (loop (fx+ i 1))))))))

                 (serialize-subprocedure! obj (subprocedure-tag) #x0f)))

            ((flonum? obj)
             (or (share obj)
                 (begin
                   (write-u8 (flonum-tag))
                   (serialize-flonum-64! obj)
                   (alloc! obj))))

            ((macro-if-bignum (bignum? obj) #f)
             (serialize-exact-int! obj))

            ((macro-if-ratnum (ratnum? obj) #f)
             (or (share obj)
                 (begin
                   (write-u8 (ratnum-tag))
                   (serialize! (macro-ratnum-numerator obj))
                   (serialize! (macro-ratnum-denominator obj))
                   (alloc! obj))))

            ((macro-if-cpxnum (cpxnum? obj) #f)
             (or (share obj)
                 (begin
                   (write-u8 (cpxnum-tag))
                   (serialize! (macro-cpxnum-real obj))
                   (serialize! (macro-cpxnum-imag obj))
                   (alloc! obj))))

            ((continuation? obj)
             (let ()

               (define (serialize-cont-frame! cont)
                 (write-u8 (frame-tag))
                 (let ((subproc (continuation-ret cont))
                       (fs (continuation-fs cont)))
                   (serialize-subprocedure! subproc 0 #x7f)
                   (alloc! (cons 11 22)) ;; create unique identity for frame
                   (let loop ((i 1))
                     (if (fx<= i fs)
                         (begin
                           (if (continuation-slot-live? cont i)
                               (if (fx= i (continuation-link cont))
                                   (let ((next (continuation-next cont)))
                                     (if next
                                         (serialize-cont-frame! next)
                                         (serialize! (macro-end-of-cont-marker))))
                                   (serialize! (continuation-ref cont i))))
                           (loop (fx+ i 1)))))))

               (or (share obj)
                   (begin
                     (alloc! obj)
                     (write-u8 (continuation-tag))
                     (serialize-cont-frame! obj)
                     (serialize! (continuation-denv obj))))))

            ((frame? obj)
             (or (share obj)
                 (begin
                   (write-u8 (frame-tag))
                   (let* ((subproc (frame-ret obj))
                          (fs (frame-fs obj)))
                     (serialize-subprocedure! subproc 0 #x7f)
                     (alloc! obj)
                     (let loop ((i 1))
                       (if (fx<= i fs)
                           (begin
                             (if (frame-slot-live? obj i)
                                 (serialize! (frame-ref obj i)))
                             (loop (fx+ i 1)))))))))

            ((box? obj)
             (or (share obj)
                 (begin
                   (alloc! obj)
                   (write-u8 (boxvalues-tag))
                   (serialize-nonneg-fixnum! 1)
                   (serialize! (unbox obj)))))

            ((values? obj)
             (or (share obj)
                 (begin
                   (alloc! obj)
                   (let ((len (values-length obj)))
                     (write-u8 (boxvalues-tag))
                     (serialize-nonneg-fixnum! len)
                     (let loop ((i 0))
                       (if (fx< i len)
                           (begin
                             (serialize! (values-ref obj i))
                             (loop (fx+ i 1)))))))))

            ((u8vector? obj)
             (serialize-homintvector!
              obj
              (u8vector-tag)
              (lambda (v) (u8vector-length v))
              (lambda (v i) (u8vector-ref v i))
              1))

            ((macro-if-s8vector (s8vector? obj) #f)
             (serialize-homintvector!
              obj
              (s8vector-tag)
              (lambda (v) (s8vector-length v))
              (lambda (v i) (s8vector-ref v i))
              1))

            ((macro-if-u16vector (u16vector? obj) #f)
             (serialize-homintvector!
              obj
              (u16vector-tag)
              (lambda (v) (u16vector-length v))
              (lambda (v i) (u16vector-ref v i))
              2))

            ((macro-if-s16vector (s16vector? obj) #f)
             (serialize-homintvector!
              obj
              (s16vector-tag)
              (lambda (v) (s16vector-length v))
              (lambda (v i) (s16vector-ref v i))
              2))

            ((macro-if-u32vector (u32vector? obj) #f)
             (serialize-homintvector!
              obj
              (u32vector-tag)
              (lambda (v) (u32vector-length v))
              (lambda (v i) (u32vector-ref v i))
              4))

            ((macro-if-s32vector (s32vector? obj) #f)
             (serialize-homintvector!
              obj
              (s32vector-tag)
              (lambda (v) (s32vector-length v))
              (lambda (v i) (s32vector-ref v i))
              4))

            ((macro-if-u64vector (u64vector? obj) #f)
             (serialize-homintvector!
              obj
              (u64vector-tag)
              (lambda (v) (u64vector-length v))
              (lambda (v i) (u64vector-ref v i))
              8))

            ((macro-if-s64vector (s64vector? obj) #f)
             (serialize-homintvector!
              obj
              (s64vector-tag)
              (lambda (v) (s64vector-length v))
              (lambda (v i) (s64vector-ref v i))
              8))

            ((macro-if-f32vector (f32vector? obj) #f)
             (serialize-homfloatvector!
              obj
              (f32vector-tag)
              (lambda (v) (f32vector-length v))
              (lambda (v i) (f32vector-ref v i))
              #t))

            ((f64vector? obj)
             (serialize-homfloatvector!
              obj
              (f64vector-tag)
              (lambda (v) (f64vector-length v))
              (lambda (v i) (f64vector-ref v i))
              #f))

            ((promise? obj)
             (or (share obj)
                 (begin
                   (alloc! obj)
                   (write-u8 (promise-tag))
                   (serialize! (promise-state obj)))))

            ((char? obj)
             (let ((n (char->integer obj)))
               (write-u8 (character-tag))
               (serialize-nonneg-fixnum! n)))

            ((eq? obj #f)                  (write-u8 (false-tag)))
            ((eq? obj #t)                  (write-u8 (true-tag)))
            ((eq? obj '())                 (write-u8 (nil-tag)))
            ((eq? obj #!eof)               (write-u8 (eof-tag)))
            ((eq? obj #!void)              (write-u8 (void-tag)))
            ((eq? obj (macro-absent-obj))  (write-u8 (absent-tag)))
            ((eq? obj #!unbound)           (write-u8 (unbound-tag)))
            ((eq? obj #!unbound2)          (write-u8 (unbound2-tag)))
            ((eq? obj #!optional)          (write-u8 (optional-tag)))
            ((eq? obj #!key)               (write-u8 (key-tag)))
            ((eq? obj #!rest)              (write-u8 (rest-tag)))

            ((macro-case-target ((c C) #t) (else #f))

             (cond ((eq? obj (macro-unused-obj))
                    (write-u8 (unused-tag)))

                   ((eq? obj (macro-deleted-obj))
                    (write-u8 (deleted-tag)))

                   ((gc-hash-table? obj)
                    (or (share obj)
                        (begin
                          (alloc! obj)
                          (write-u8 (gchashtable-tag))
                          (let ()
                            (##declare (not interrupts-enabled))
                            (let ((len
                                   (vector-length obj))
                                  (flags
                                   (macro-gc-hash-table-flags obj))
                                  (count
                                   (macro-gc-hash-table-count obj))
                                  (min-count
                                   (macro-gc-hash-table-min-count obj))
                                  (free
                                   (macro-gc-hash-table-free obj)))
                              (serialize-nonneg-fixnum! len)
                              (serialize-nonneg-fixnum! flags)
                              (serialize-nonneg-fixnum! count)
                              (serialize-nonneg-fixnum! min-count)
                              (serialize-nonneg-fixnum! free))
                            (let loop ((i (macro-gc-hash-table-key0)))
                              (if (fx< i (vector-length obj))
                                  (let ((key (vector-ref obj i)))
                                    (if (and (not (eq? key (macro-unused-obj)))
                                             (not (eq? key (macro-deleted-obj))))
                                        (let ((val (vector-ref obj (fx+ i 1))))
                                          (serialize! key)
                                          (serialize! val)))
                                    (let ()
                                      (##declare (interrupts-enabled))
                                      (loop (fx+ i 2))))
                                  (serialize! (macro-unused-obj))))))))

                   (else
                    (cannot-serialize obj))))

            (else
             (cannot-serialize obj)))))

  (serialize! obj)

  (get-output-u8vector))

(define-prim (object->u8vector
              obj
              #!optional
              (transform (macro-absent-obj)))
  (macro-force-vars (transform)
    (if (eq? transform (macro-absent-obj))
        (##object->u8vector obj)
        (macro-check-procedure transform 2 (object->u8vector obj transform)
          (##object->u8vector obj transform)))))

(define-prim (##u8vector->object
              u8vect
              #!optional
              (transform (macro-absent-obj)))

  (define (err)
    (error "deserialization error"))

  (define state
    (vector 0
            u8vect
            0
            (make-vector 64)
            (if (eq? transform (macro-absent-obj))
                (lambda (x) x)
                transform)))

  (define (read-u8)
    (let ((ptr (vector-ref state 0))
          (u8vect (vector-ref state 1)))
      (if (fx< ptr (u8vector-length u8vect))
          (begin
            (vector-set! state 0 (fx+ ptr 1))
            (u8vector-ref u8vect ptr))
          (err))))

  (define (eof?)
    (let ((ptr (vector-ref state 0))
          (u8vect (vector-ref state 1)))
      (fx= ptr (u8vector-length u8vect))))

  (define (alloc! obj)
    (let* ((n (vector-ref state 2))
           (vect (vector-ref state 3))
           (len (vector-length vect)))
      (vector-set! state 2 (fx+ n 1))
      (if (fx= n len)
          (let* ((new-len (fx+ (fxwraplogical-shift-right (fx* len 3) 1) 1))
                 (new-vect (make-vector new-len)))
            (vector-set! state 3 new-vect)
            (subvector-move! vect 0 n new-vect 0)
            (vector-set! new-vect n obj))
          (vector-set! vect n obj))
      n))

  (define (shared-ref i)
    (let* ((n (vector-ref state 2))
           (vect (vector-ref state 3)))
      (if (fx< i n)
          (vector-ref vect i)
          (err))))

  (define (deserialize-nonneg-fixnum! n shift)
    (let loop ((n n)
               (shift shift)
               (range (fxwraplogical-shift-right (max-fixnum) shift)))
      (if (fx= range 0)
          (err)
          (let ((x (read-u8)))
            (if (fx< x #x80)
                (if (fx< range x)
                    (err)
                    (fxior n (fxarithmetic-shift-left x shift)))
                (let ((b (fxand x #x7f)))
                  (if (fx< range b)
                      (err)
                      (loop (fxior n (fxarithmetic-shift-left b shift))
                            (fx+ shift 7)
                            (fxwraplogical-shift-right range 7)))))))))

  (define (deserialize-flonum-32!)
    (let ((n (deserialize-nonneg-exact-int-of-length! 4)))
      (##ieee754-32->flonum n)))

  (define (deserialize-flonum-64!)
    (let ((n (deserialize-nonneg-exact-int-of-length! 8)))
      (##ieee754-64->flonum n)))

  (define (deserialize-nonneg-exact-int-of-length! len)
    (if (fx<= len 3) ;; result fits in a 32 bit fixnum?
        (let ((a (read-u8)))
          (if (fx= len 1)
              a
              (fx+ a
                   (fxarithmetic-shift-left
                    (let ((b (read-u8)))
                      (if (fx= len 2)
                          b
                          (fx+ b
                               (fxarithmetic-shift-left
                                (let ((c (read-u8)))
                                  c)
                                8))))
                    8))))
        (let* ((len/2 (fxwraplogical-shift-right len 1))
               (a (deserialize-nonneg-exact-int-of-length! len/2))
               (b (deserialize-nonneg-exact-int-of-length! (fx- len len/2))))
          (bitwise-ior a (arithmetic-shift b (fx* 8 len/2))))))

  (define (deserialize-exact-int-of-length! len)
    (let ((n (deserialize-nonneg-exact-int-of-length! len)))
      (if (bit-set? (fx- (fx* 8 len) 1) n)
          (+ n (arithmetic-shift -1 (fx* 8 len)))
          n)))

  (define (deserialize-string! x mask)
    (deserialize-string-of-length!
     (let ((lo (fxand x mask)))
       (if (fx< lo mask)
           lo
           (deserialize-nonneg-fixnum! 0 0)))))

  (define (deserialize-string-of-length! len)
    (let ((obj (make-string len)))
      (let loop ((i 0))
        (if (fx< i len)
            (let ((n (deserialize-nonneg-fixnum! 0 0)))
              (if (fx<= n (max-char))
                  (begin
                    (string-set! obj i (integer->char n))
                    (loop (fx+ i 1)))
                  (err)))
            obj))))

  (define (deserialize-vector-like! x make-vect vect-set!)
    (let* ((len (fxand x #x0f)))
      (if (fx< len #x0f)
          (deserialize-vector-like-fill! len make-vect vect-set!)
          (deserialize-vector-like-long! make-vect vect-set!))))

  (define (deserialize-vector-like-long! make-vect vect-set!)
    (let ((len (deserialize-nonneg-fixnum! 0 0)))
      (deserialize-vector-like-fill! len make-vect vect-set!)))

  (define (deserialize-vector-like-fill! len make-vect vect-set!)
    (let ((obj (make-vect len)))
      (alloc! obj)
      (let loop ((i 0))
        (if (fx< i len)
            (begin
              (vect-set! obj i (deserialize!))
              (loop (fx+ i 1)))
            obj))))

  (define (deserialize-homintvector! make-vect vect-set! elem-len signed? len)
    (let ((obj (make-vect len)))
      (let loop ((i 0))
        (if (fx< i len)
            (begin
              (vect-set!
               obj
               i
               (if signed?
                   (deserialize-exact-int-of-length! elem-len)
                   (deserialize-nonneg-exact-int-of-length! elem-len)))
              (loop (fx+ i 1)))
            (begin
              (alloc! obj)
              obj)))))

  (define (deserialize-homfloatvector! make-vect vect-set! len f32?)
    (let ((obj (make-vect len)))
      (let loop ((i 0))
        (if (fx< i len)
            (begin
              (vect-set!
               obj
               i
               (if f32?
                   (deserialize-flonum-32!)
                   (deserialize-flonum-64!)))
              (loop (fx+ i 1)))
            (begin
              (alloc! obj)
              obj)))))

  (define (deserialize-subprocedure!)
    (let ((x (read-u8)))
      (if (fx>= x (shared-tag))
          (shared-ref
           (deserialize-nonneg-fixnum! (fxand x #x7f) 7))
          (let ((subproc-id
                 (let ((id (fxand x #x7f)))
                   (if (fx< id #x7f)
                       id
                       (deserialize-nonneg-fixnum! 0 0)))))
            (deserialize-subprocedure-with-id! subproc-id)))))

  (define (deserialize-subprocedure-with-id! subproc-id)

    (define (get-subprocedure proc err parent-name subproc-id)
      (let ((obj (proc parent-name subproc-id)))
        ;;(##display parent-name ##stdout-port)
        ;;(##newline ##stdout-port)
        (if obj
          (begin
            (alloc! obj)
            obj)
          (err))))

    (let ((v (deserialize!)))
      (if (not (eqv? v (##system-version)))
          (err)
          (let* ((x
                  (read-u8))
                 (parent-name
                  (if (fx>= x (shared-tag))
                      (let ((name
                             (shared-ref
                              (deserialize-nonneg-fixnum!
                               (fxand x #x7f)
                               7))))
                        (if #f #;(not (symbol? name))
                            (err)
                            name))
                      (let ((name
                             (string->symbol (deserialize-string! x #x7f))))
                        (alloc! name)
                        name))))

            (get-subprocedure
              ##get-subprocedure-from-name-and-id
              (lambda ()
                (get-subprocedure
                  ##unknown-procedure-handler
                  err
                  parent-name
                  subproc-id))
              parent-name
              subproc-id)))))

  (define (create-global-var-if-needed sym)
    (let ((x (read-u8)))
      (if (fx= x 1)
          (##make-global-var sym))))

  (define (deserialize!)
    (let ((x (read-u8)))
      (if (fx>= x (shared-tag))

          (shared-ref
           (deserialize-nonneg-fixnum! (fxand x #x7f) 7))

          ((vector-ref state 4) ;; transform
           (cond ((fx>= x (false-tag))
                  (cond ((fx= x (false-tag))
                         #f)

                        ((fx= x (true-tag))
                         #t)

                        ((fx= x (nil-tag))
                         '())

                        ((fx= x (eof-tag))
                         #!eof)

                        ((fx= x (void-tag))
                         #!void)

                        ((fx= x (absent-tag))
                         (macro-absent-obj))

                        ((fx= x (unbound-tag))
                         #!unbound)

                        ((fx= x (unbound2-tag))
                         #!unbound2)

                        ((fx= x (optional-tag))
                         #!optional)

                        ((fx= x (key-tag))
                         #!key)

                        ((fx= x (rest-tag))
                         #!rest)

                        ((fx= x (promise-tag))
                         (let ((obj (make-delay-promise #f)))
                           (alloc! obj)
                           (let ((state (deserialize!)))
                             (promise-state-set! obj state)
                             obj)))

                        ((macro-case-target ((c C) #t) (else #f))
                         (cond ((fx= x (unused-tag))
                                (macro-unused-obj))
                               ((fx= x (deleted-tag))
                                (macro-deleted-obj))
                               (else
                                (err))))

                        (else
                         (err))))

                 ((fx>= x (character-tag))
                  (cond ((fx= x (character-tag))
                         (let ((n (deserialize-nonneg-fixnum! 0 0)))
                           (if (fx<= n (max-char))
                               (integer->char n)
                               (err))))

                        ((fx= x (flonum-tag))
                         (let ((obj (deserialize-flonum-64!)))
                           (alloc! obj)
                           obj))

                        ((macro-if-ratnum (fx= x (ratnum-tag)) #f)
                         (let* ((num (deserialize!))
                                (den (deserialize!)))
                           (if #f #;(or (and (fixnum? den)
                                             (fx<= den 1))
                                        (and (bignum? den)
                                             (negative? den))
                                        (not (eqv? 1 (gcd num den))))
                           (err)
                           (let ((obj (macro-ratnum-make num den)))
                             (alloc! obj)
                             obj))))

                        ((macro-if-cpxnum (fx= x (cpxnum-tag)) #f)
                         (let* ((real (deserialize!))
                                (imag (deserialize!)))
                           (if #f #;(or (not (real? real))
                               (not (real? imag)))
                               (err)
                               (let ((obj (macro-cpxnum-make real imag)))
                                 (alloc! obj)
                                 obj))))

                        ((fx= x (pair-tag))
                         (let ((obj (cons #f #f)))
                           (alloc! obj)
                           (let* ((a (deserialize!))
                                  (d (deserialize!)))
                             (set-car! obj a)
                             (set-cdr! obj d)
                             obj)))

                        ((fx= x (continuation-tag))
                         (let ((obj
                                (make-continuation (macro-end-of-cont-marker) #f)))
                           (alloc! obj)
                           (let* ((frame (deserialize!))
                                  (denv (deserialize!)))
                             (if #f #;(not (frame? frame)) ;; should also check denv
                                 (err)
                                 (begin
                                   (continuation-frame-set! obj frame)
                                   (continuation-denv-set! obj denv)
                                   obj)))))

                        ((fx= x (boxvalues-tag))
                         (let ((len (deserialize-nonneg-fixnum! 0 0)))
                           (if (fx= len 1)
                               (let ((obj (box #f)))
                                 (alloc! obj)
                                 (set-box! obj (deserialize!))
                                 obj)
                               (let ((obj (make-values len)))
                                 (alloc! obj)
                                 (let loop ((i 0))
                                   (if (fx< i len)
                                       (begin
                                         (values-set! obj i (deserialize!))
                                         (loop (fx+ i 1)))
                                       obj))))))

                        ((fx= x (ui-symbol-tag))
                         (let* ((y (read-u8))
                                (name (deserialize-string! y #xff))
                                (hash (deserialize-exact-int-of-length! 4))
                                (obj (##make-uninterned-symbol name hash)))
                           (create-global-var-if-needed obj)
                           (alloc! obj)
                           obj))

                        ((fx= x (keyword-tag))
                         (let* ((name (deserialize-string! 0 0))
                                (obj (string->keyword name)))
                           (alloc! obj)
                           obj))

                        ((fx= x (ui-keyword-tag))
                         (let* ((y (read-u8))
                                (name (deserialize-string! y #xff))
                                (hash (deserialize-exact-int-of-length! 4))
                                (obj (##make-uninterned-keyword name hash)))
                           (alloc! obj)
                           obj))

                        ((fx= x (closure-tag))
                         (let ((subproc (deserialize-subprocedure!)))
                           (if #f ;;;;;;;not subprocedure
                               (err)
                               (let ((nb-closed
                                      (subprocedure-nb-closed subproc)))
                                 (if #f ;;;;; nb-closed < 0
                                     (err)
                                     (let ((obj (make-closure subproc nb-closed)))
                                       (alloc! obj)
                                       (let loop ((i 1))
                                         (if (fx<= i nb-closed)
                                             (let ((x (deserialize!)))
                                               (closure-set! obj i x)
                                               (loop (fx+ i 1)))
                                             obj))))))))

                        ((fx= x (frame-tag))
                         (let ((subproc (deserialize-subprocedure!)))
                           (if #f #;(not (##return? subproc))
                               (err)
                               (let* ((obj (make-frame subproc))
                                      (fs (frame-fs obj)))
                                 (alloc! obj)
                                 (let loop ((i 1))
                                   (if (fx<= i fs)
                                       (begin
                                         (frame-set!
                                          obj
                                          i
                                          (if (frame-slot-live? obj i)
                                              (deserialize!)
                                              0))
                                         (loop (fx+ i 1)))
                                       obj))))))

                        ((and (macro-case-target ((c C) #t) (else #f))
                              (fx= x (gchashtable-tag)))
                         (let* ((len (deserialize-nonneg-fixnum! 0 0))
                                (flags (deserialize-nonneg-fixnum! 0 0))
                                (count (deserialize-nonneg-fixnum! 0 0))
                                (min-count (deserialize-nonneg-fixnum! 0 0))
                                (free (deserialize-nonneg-fixnum! 0 0)))
                           (if #f ;;;;;;;;parameters OK?
                               (err)
                               (let ((obj (make-vector len (macro-unused-obj))))
                                 (alloc! obj)
                                 (macro-gc-hash-table-flags-set!
                                  obj
                                  (fxior ;; force rehash at next access!
                                   flags
                                   (fx+ (macro-gc-hash-table-flag-key-moved)
                                        (macro-gc-hash-table-flag-need-rehash))))
                                 (macro-gc-hash-table-count-set! obj count)
                                 (macro-gc-hash-table-min-count-set! obj min-count)
                                 (macro-gc-hash-table-free-set! obj free)
                                 (let loop ((i (macro-gc-hash-table-key0)))
                                   (if (fx< i (vector-length obj))
                                       (let ((key (deserialize!)))
                                         (if (not (eq? key (macro-unused-obj)))
                                             (let ((val (deserialize!)))
                                               (vector-set! obj i key)
                                               (vector-set! obj (fx+ i 1) val)
                                               (loop (fx+ i 2)))
                                             (begin
                                               (subtype-set!
                                                obj
                                                (macro-subtype-weak))
                                               obj)))
                                       (err)))))))

                        ((fx= x (homvector-tag))
                         (let* ((len/type
                                 (deserialize-nonneg-fixnum! 0 0))
                                (len
                                 (fxwraplogical-shift-right len/type 4))
                                (type
                                 (fxand len/type #x0f)))
                           (cond ((fx= type (u8vector-tag))
                                  (deserialize-homintvector!
                                   (lambda (n) (make-u8vector n))
                                   (lambda (v i n) (u8vector-set! v i n))
                                   1
                                   #f
                                   len))
                                 ((macro-if-s8vector (fx= type (s8vector-tag)) #f)
                                  (deserialize-homintvector!
                                   (lambda (n) (make-s8vector n))
                                   (lambda (v i n) (s8vector-set! v i n))
                                   1
                                   #t
                                   len))
                                 ((macro-if-u16vector (fx= type (u16vector-tag)) #f)
                                  (deserialize-homintvector!
                                   (lambda (n) (make-u16vector n))
                                   (lambda (v i n) (u16vector-set! v i n))
                                   2
                                   #f
                                   len))
                                 ((macro-if-s16vector (fx= type (s16vector-tag)) #f)
                                  (deserialize-homintvector!
                                   (lambda (n) (make-s16vector n))
                                   (lambda (v i n) (s16vector-set! v i n))
                                   2
                                   #t
                                   len))
                                 ((macro-if-u32vector (fx= type (u32vector-tag)) #f)
                                  (deserialize-homintvector!
                                   (lambda (n) (make-u32vector n))
                                   (lambda (v i n) (u32vector-set! v i n))
                                   4
                                   #f
                                   len))
                                 ((macro-if-s32vector (fx= type (s32vector-tag)) #f)
                                  (deserialize-homintvector!
                                   (lambda (n) (make-s32vector n))
                                   (lambda (v i n) (s32vector-set! v i n))
                                   4
                                   #t
                                   len))
                                 ((macro-if-u64vector (fx= type (u64vector-tag)) #f)
                                  (deserialize-homintvector!
                                   (lambda (n) (make-u64vector n))
                                   (lambda (v i n) (u64vector-set! v i n))
                                   8
                                   #f
                                   len))
                                 ((macro-if-s64vector (fx= type (s64vector-tag)) #f)
                                  (deserialize-homintvector!
                                   (lambda (n) (make-s64vector n))
                                   (lambda (v i n) (s64vector-set! v i n))
                                   8
                                   #t
                                   len))
                                 ((macro-if-f32vector (fx= type (f32vector-tag)) #f)
                                  (deserialize-homfloatvector!
                                   (lambda (n) (make-f32vector n))
                                   (lambda (v i n) (f32vector-set! v i n))
                                   len
                                   #t))
                                 ((fx= type (f64vector-tag))
                                  (deserialize-homfloatvector!
                                   (lambda (n) (make-f64vector n))
                                   (lambda (v i n) (f64vector-set! v i n))
                                   len
                                   #f))
                                 (else
                                  (err)))))

                        (else
                         (err))))

                 ((fx>= x (exact-int-tag))
                  (let ((lo (fxand x #x0f)))
                    (if (fx< lo #x0b)
                        lo
                        (let* ((len
                                (if (fx= lo #x0f)
                                    (deserialize-nonneg-fixnum! 0 0)
                                    (fx- #x0f lo)))
                               (n
                                (deserialize-exact-int-of-length! len)))
                          (if (fx= lo #x0e)
                              n
                              (begin
                                (alloc! n)
                                n))))))

                 ((fx>= x (subprocedure-tag))
                  (let ((subproc-id
                         (let ((id (fxand x #x0f)))
                           (if (fx< id #x0f)
                               id
                               (deserialize-nonneg-fixnum! 0 0)))))
                    (deserialize-subprocedure-with-id! subproc-id)))

                 ((fx>= x (structure-tag))
                  (deserialize-vector-like!
                   x
                   (lambda (len)
                     (##make-structure
                      (macro-type-partially-initialized-structure)
                      len))
                   (lambda (obj i val)
                     (##unchecked-structure-set! obj val i #f #f))))

                 ((fx>= x (vector-tag))
                  (deserialize-vector-like!
                   x
                   (lambda (len)
                     (##make-vector len))
                   (lambda (obj i val)
                     (##vector-set! obj i val))))

                 ((fx>= x (string-tag))
                  (let ((obj (deserialize-string! x #x0f)))
                    (alloc! obj)
                    obj))

                 (else ;; symbol-tag
                  (let* ((name (deserialize-string! x #x0f))
                         (obj (string->symbol name)))
                    (create-global-var-if-needed obj)
                    (alloc! obj)
                    obj)))))))

  (let ((obj (deserialize!)))
    (if (eof?)
        obj
        (err))))

(define-prim (u8vector->object
              u8vect
              #!optional
              (transform (macro-absent-obj)))
  (macro-force-vars (u8vect transform)
    (macro-check-u8vector u8vect 1 (u8vector->object u8vect transform)
      (if (eq? transform (macro-absent-obj))
          (##u8vector->object u8vect)
          (macro-check-procedure transform 2 (u8vector->object u8vect transform)
            (##u8vector->object u8vect transform))))))

(define-prim (##get-subprocedure-from-name-and-id name subproc-id)
  (let ((parent (##global-var-primitive-ref
                 (##make-global-var name))))
    (and (procedure? parent)
         (##make-subprocedure parent subproc-id))))

(define-prim (##unknown-procedure-handler name subproc-id)
  #f)

(define-prim (##unknown-procedure-handler-set! x)
  (set! ##unknown-procedure-handler x))

(##namespace (""
 structure?
 gc-hash-table?
 fixnum?
 subtype-set!
 subvector-move!
 continuation?
 make-continuation
 continuation-frame
 continuation-frame-set!
 continuation-denv
 continuation-denv-set!
 continuation-fs
 continuation-ret
 continuation-link
 continuation-slot-live?
 continuation-ref
 continuation-set!
 continuation-next
 frame?
 make-frame
 frame-ret
 frame-fs
 frame-ref
 frame-set!
 frame-slot-live?
 subprocedure-parent-name
 subprocedure-id
 subprocedure-nb-closed
 closure?
 make-closure
 closure-code
 closure-ref
 closure-set!
 make-delay-promise
 promise-state
 promise-state-set!
 box?
 box
 unbox
 set-box!
 values?
 make-values
 values-length
 values-ref
 values-set!
 extract-bit-field
 bignum?
 subtyped?
 flonum?
 ratnum?
 cpxnum?
 promise?
 make-string
 string?
 string-length
 string-ref
 string-set!
 make-vector
 vector?
 vector-length
 vector-ref
 vector-set!
 make-s8vector
 s8vector?
 s8vector-length
 s8vector-ref
 s8vector-set!
 s8vector-shrink!
 make-u8vector
 u8vector?
 u8vector-length
 u8vector-ref
 u8vector-set!
 u8vector-shrink!
 fifo->u8vector
 make-s16vector
 s16vector?
 s16vector-length
 s16vector-ref
 s16vector-set!
 s16vector-shrink!
 make-u16vector
 u16vector?
 u16vector-length
 u16vector-ref
 u16vector-set!
 u16vector-shrink!
 make-s32vector
 s32vector?
 s32vector-length
 s32vector-ref
 s32vector-set!
 s32vector-shrink!
 make-u32vector
 u32vector?
 u32vector-length
 u32vector-ref
 u32vector-set!
 u32vector-shrink!
 make-s64vector
 s64vector?
 s64vector-length
 s64vector-ref
 s64vector-set!
 s64vector-shrink!
 make-u64vector
 u64vector?
 u64vector-length
 u64vector-ref
 u64vector-set!
 u64vector-shrink!
 make-f32vector
 f32vector?
 f32vector-length
 f32vector-ref
 f32vector-set!
 f32vector-shrink!
 make-f64vector
 f64vector?
 f64vector-length
 f64vector-ref
 f64vector-set!
 f64vector-shrink!
 symbol?
 symbol->string
 string->symbol
 keyword?
 keyword->string
 string->keyword
 integer-length
 table-ref
 table-set!
 uninterned-keyword?
 uninterned-symbol?
 char->integer
 integer->char
 vector
 cons
 pair?
 car
 cdr
 set-car!
 set-cdr!
 procedure?
 char?
 real?
 not
 eq?
 eqv?
 fx+
 fx-
 fx*
 fx<
 fx>
 fx=
 fx<=
 fx>=
 fxand
 fxior
 fxarithmetic-shift-left
 fxwraplogical-shift-right
 negative?
 +
 arithmetic-shift
 bit-set?
 bitwise-ior
 extract-bit-field
 gcd
 ))

;;;============================================================================
