;;;============================================================================

;;; File: "_system.scm", Time-stamp: <2018-08-15 22:33:20 feeley>

;;; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "header.scm")

;;;============================================================================

;;; System procedures

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Type operations.

(define-prim (##type obj))
(define-prim (##type-cast obj type))
(define-prim (##subtype obj))
(define-prim (##subtype-set! obj subtype))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Basic type predicates.

(define-prim (##fixnum? obj)
  (##eq? (##type obj) (macro-type-fixnum)))

(define-prim (##subtyped? obj)
  (##eq? (##type obj) (macro-type-subtyped)))

(define-prim (##subtyped.vector? obj)
  (##eq? (##subtype obj) (macro-subtype-vector)))

(define-prim (##subtyped.symbol? obj)
  (##eq? (##subtype obj) (macro-subtype-symbol)))

(define-prim (##subtyped.flonum? obj)
  (##eq? (##subtype obj) (macro-subtype-flonum)))

(define-prim (##subtyped.bignum? obj)
  (##eq? (##subtype obj) (macro-subtype-bignum)))

(define-prim (##special? obj)
  (##eq? (##type obj) (macro-type-special)))

;; (##vector? obj) is defined in "_std.scm"

(define-prim (##ratnum? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-ratnum))))

(define-prim (##cpxnum? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-cpxnum))))

(define-prim (##structure? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-structure))))

(define-prim (##values? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-boxvalues))
       (##not (##fixnum.= (##vector-length obj) 1))))

(define-prim (##meroon? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-meroon))))

(define-prim (##frame? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-frame))))

(define-prim (##continuation? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-continuation))))

(define-prim (##promise? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-promise))))

(define-prim (##return? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-return))))

(define-prim (##foreign? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-foreign))))

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

(define-prim (##flonum? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-flonum))))

(define-prim (##bignum? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-bignum))))

(define-prim (##unbound? obj))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Procedures for front end

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
        (loop1 (##cdr x) (##fixnum.+ n 1))
        (let ((vect (##make-vector n 0)))
          (let loop2 ((x lst) (i 0))
            (macro-force-vars (x)
              (if (and (##pair? x)      ;; double check in case another
                       (##fixnum.< i n));; thread mutates the list
                (begin
                  (##vector-set! vect i (##car x))
                  (loop2 (##cdr x) (##fixnum.+ i 1)))
                vect))))))))

(define-prim (##case-memv obj lst)
  (macro-force-vars (obj)
    (let loop ((x lst))
      (if (##pair? x)
        (if (let () (##declare (generic)) (##eqv? obj (##car x)))
          x
          (loop (##cdr x)))
        #f))))

;;;----------------------------------------------------------------------------

;;; Object equality.

(define-prim (##eqv? obj1 obj2)
  (macro-number-dispatch obj1 (##eq? obj1 obj2)
    (and (##fixnum? obj2) (##fixnum.= obj1 obj2)) ;; obj1 = fixnum
    (and (##bignum? obj2) (##bignum.= obj1 obj2)) ;; obj1 = bignum
    (and (##ratnum? obj2) (##ratnum.= obj1 obj2)) ;; obj1 = ratnum
    (and (##flonum? obj2) (##bvector-equal? obj1 obj2)) ;; obj1 = flonum
    (and (##cpxnum? obj2) ;; obj1 = cpxnum
         (##eqv? (macro-cpxnum-real obj1) (macro-cpxnum-real obj2))
         (##eqv? (macro-cpxnum-imag obj1) (macro-cpxnum-imag obj2)))))

(define-prim (eqv? obj1 obj2)
  (macro-force-vars (obj1 obj2)
    (let ()
      (##declare (generic)) ;; avoid fixnum specific ##eqv?
      (##eqv? obj1 obj2))))

(define-prim (##eq? obj1 obj2))

(define-prim (eq? obj1 obj2)
  (macro-force-vars (obj1 obj2)
    (##eq? obj1 obj2)))

(define-prim (##bvector-equal? obj1 obj2)

  (define (equal obj1 obj2 len)
    (let loop ((i (##fixnum.- len 1)))
      (or (##fixnum.< i 0)
          (and (##fixnum.= (##u16vector-ref obj1 i)
                           (##u16vector-ref obj2 i))
               (loop (##fixnum.- i 1))))))

  (let ((len-obj1 (##u8vector-length obj1)))
    (and (##fixnum.= len-obj1 (##u8vector-length obj2))
         (if (##fixnum.odd? len-obj1)
           (let ((i (##fixnum.- len-obj1 1)))
             (and (##fixnum.= (##u8vector-ref obj1 i)
                              (##u8vector-ref obj2 i))
                  (equal obj1
                         obj2
                         (##fixnum.arithmetic-shift-right len-obj1 1))))
           (equal obj1
                  obj2
                  (##fixnum.arithmetic-shift-right len-obj1 1))))))

(define-prim (##equal? obj1 obj2)

  (define (eqv obj1 obj2)
    (##declare (generic)) ;; avoid fixnum specific ##eqv?
    (##eqv? obj1 obj2))

  (define (structure-equal obj1 obj2 type len)
    (or (##not type) ;; have we reached root of inheritance chain?
        (let ((fields (##type-fields type)))
          (let loop ((i*3 (##fixnum.- (##vector-length fields) 3))
                     (len len))
            (if (##fixnum.< i*3 0)
              (structure-equal obj1 obj2 (##type-super type) len)
              (let ((field-attributes
                     (##vector-ref fields (##fixnum.+ i*3 1)))
                    (len-1
                     (##fixnum.- len 1)))
                (and (or (##not (##fixnum.=
                                 (##fixnum.bitwise-and field-attributes 4)
                                 0))
                         (equal (##unchecked-structure-ref
                                 obj1
                                 len-1
                                 type
                                 #f)
                                (##unchecked-structure-ref
                                 obj2
                                 len-1
                                 type
                                 #f)))
                     (loop (##fixnum.- i*3 3)
                           len-1))))))))

  (define (equal obj1 obj2)
    (macro-force-vars (obj1 obj2)
      (cond ((##eq? obj1 obj2)
             #t)
            ((##pair? obj1)
             (and (##pair? obj2)
                  (equal (##car obj1) (##car obj2))
                  (equal (##cdr obj1) (##cdr obj2))))
            ((##subtyped? obj1)
             (and (##subtyped? obj2)
                  (let ((subtype-obj1 (##subtype obj1)))
                    (and (##fixnum.= subtype-obj1 (##subtype obj2))
                         (cond ((macro-subtype-bvector? subtype-obj1)
                                (##bvector-equal? obj1 obj2))
                               ((##vector? obj1)
                                (let ((len-obj1 (##vector-length obj1)))
                                  (and (##fixnum.= len-obj1
                                                   (##vector-length obj2))
                                       (let loop ((i (##fixnum.- len-obj1 1)))
                                         (or (##fixnum.< i 0)
                                             (and (equal (##vector-ref obj1 i)
                                                         (##vector-ref obj2 i))
                                                  (loop (##fixnum.- i 1))))))))
                               ((macro-table? obj1)
                                (and (macro-table? obj2)
                                     (##table-equal? obj1 obj2)))
                               ((##structure? obj1)
                                (and (##structure? obj2)
                                     (let* ((type-obj1
                                             (##structure-type obj1))
                                            (type-obj2
                                             (##structure-type obj2))
                                            (type-id-obj1
                                             (##type-id type-obj1))
                                            (type-id-obj2
                                             (##type-id type-obj2)))
                                       (and (##eq? type-id-obj1
                                                   type-id-obj2)
                                            (let ((len-obj1
                                                   (##vector-length obj1)))
                                              (and (##fixnum.=
                                                    len-obj1
                                                    (##vector-length obj2))
                                                   (##fixnum.= ;; not opaque?
                                                    (##fixnum.bitwise-and
                                                     (##type-flags type-obj1)
                                                     1)
                                                    0)
                                                   (structure-equal
                                                    obj1
                                                    obj2
                                                    type-obj1
                                                    len-obj1)))))))
                               ((##box? obj1)
                                (and (##box? obj2)
                                     (equal (##unbox obj1)
                                            (##unbox obj2))))
                               (else
                                (eqv obj1 obj2)))))))
          (else
           (eqv obj1 obj2)))))

  (equal obj1 obj2))

(define-prim (equal? obj1 obj2)
  (##equal? obj1 obj2))

;;;----------------------------------------------------------------------------

;;; Object hashing.

(define-prim (##symbol-hash sym)
  (macro-symbol-hash sym))

(define-prim (symbol-hash sym)
  (macro-force-vars (sym)
    (macro-check-symbol sym 1 (symbol-hash sym)
      (##symbol-hash sym))))

(define-prim (##keyword-hash key)
  (macro-keyword-hash key))

(define-prim (keyword-hash key)
  (macro-force-vars (key)
    (macro-check-keyword key 1 (keyword-hash key)
      (##keyword-hash key))))

(define-prim (##eq?-hash obj)

  ;; for all obj2 we must have that (##eq? obj obj2) implies that
  ;; (= (##eq?-hash obj) (##eq?-hash obj2))

  (cond ((##not (##mem-allocated? obj))
         (##fixnum.bitwise-and
          (##type-cast obj (macro-type-fixnum))
          (macro-max-fixnum32)))
        ((##symbol? obj)
         (##symbol-hash obj))
        ((##keyword? obj)
         (##keyword-hash obj))
        (else
         (##fixnum.bitwise-and
          (let ((sn (##object->serial-number obj)))
            (if (##fixnum? sn)
              sn
              (##fixnum.arithmetic-shift-left
               (##bignum.mdigit-ref sn 0)
               10)))
          (macro-max-fixnum32)))))

(define-prim (eq?-hash obj)
  (macro-force-vars (obj)
    (##eq?-hash obj)))

(define-prim (##eqv?-hash obj)

  ;; for all obj2 we must have that (##eqv? obj obj2) implies that
  ;; (= (##eqv?-hash obj) (##eqv?-hash obj2))

  (define (combine a b)
    (##fixnum.bitwise-and
     (##fixnum.* (##fixnum.+ a (##fixnum.arithmetic-shift-left b 1))
                 331804471)
     (macro-max-fixnum32)))

  (define (hash obj)
    (macro-number-dispatch obj
      (##eq?-hash obj) ;; obj = not a number
      (##fixnum.bitwise-and obj (macro-max-fixnum32)) ;; obj = fixnum
      (##modulo obj 331804481) ;; obj = bignum
      (combine (hash (macro-ratnum-numerator obj)) ;; obj = ratnum
               (hash (macro-ratnum-denominator obj)))
      (combine (##u16vector-ref obj 0) ;; obj = flonum
               (combine (##u16vector-ref obj 1)
                        (combine (##u16vector-ref obj 2)
                                 (##u16vector-ref obj 3))))
      (combine (hash (macro-cpxnum-real obj)) ;; obj = cpxnum
               (hash (macro-cpxnum-imag obj)))))

  (hash obj))

(define-prim (eqv?-hash obj)
  (macro-force-vars (obj)
    (##eqv?-hash obj)))

(define-prim (##equal?-hash obj)

  ;; for all obj2 we must have that (##equal? obj obj2) implies that
  ;; (= (##equal?-hash obj) (##equal?-hash obj2))

  (define (combine a b)
    (##fixnum.bitwise-and
     (##fixnum.* (##fixnum.+ a (##fixnum.arithmetic-shift-left b 1))
                 331804471)
     (macro-max-fixnum32)))

  (define (bvector-hash obj)

    (define (u16vect-hash i h)
      (if (##fixnum.< i 0)
        h
        (u16vect-hash (##fixnum.- i 1)
                      (combine (##u16vector-ref obj i) h))))

    (let ((len (##u8vector-length obj)))
      (u16vect-hash (##fixnum.- (##fixnum.arithmetic-shift-right len 1) 1)
                    (##fixnum.bitwise-xor
                     (if (##fixnum.odd? len)
                       (##u8vector-ref obj (##fixnum.- len 1))
                       256)
                     (##fixnum.+ len
                                 (##fixnum.arithmetic-shift-left
                                  (##subtype obj)
                                  20))))))

  (define (structure-hash obj type len h)
    (if (##not type) ;; have we reached root of inheritance chain?
      h
      (let ((fields (##type-fields type)))
        (let loop ((h 0)
                   (i*3 (##fixnum.- (##vector-length fields) 3))
                   (len len))
          (if (##fixnum.< i*3 0)
            (structure-hash obj (##type-super type) len h)
            (let ((field-attributes
                   (##vector-ref fields (##fixnum.+ i*3 1)))
                  (len-1
                   (##fixnum.- len 1)))
              (loop (if (##fixnum.=
                         (##fixnum.bitwise-and field-attributes 4)
                         0)
                      (combine (hash (##unchecked-structure-ref
                                      obj
                                      len-1
                                      type
                                      #f))
                               h)
                      h)
                    (##fixnum.- i*3 3)
                    len-1)))))))

  (define (hash obj)
    (macro-force-vars (obj)
      (cond ((##pair? obj)
             (combine (hash (##car obj))
                      (hash (##cdr obj))))
            ((##subtyped? obj)
             (cond ((macro-subtype-bvector? (##subtype obj))
                    (cond ((##string? obj)
                           (##string=?-hash obj))
                          ((or (##flonum? obj)
                               (##bignum? obj))
                           (##eqv?-hash obj))
                          (else
                           (bvector-hash obj))))
                   ((##symbol? obj)
                    (##symbol-hash obj))
                   ((##keyword? obj)
                    (##keyword-hash obj))
                   ((##vector? obj)
                    (let loop ((i (##fixnum.- (##vector-length obj) 1))
                               (h 383479237))
                      (if (##fixnum.< i 0)
                        h
                        (loop (##fixnum.- i 1)
                              (combine (hash (##vector-ref obj i))
                                       h)))))
                   ((macro-table? obj)
                    (##table-equal?-hash obj))
                   ((##structure? obj)
                    (let* ((type
                            (##structure-type obj))
                           (type-id
                            (##type-id type)))
                      (if (##fixnum.= ;; not opaque?
                           (##fixnum.bitwise-and
                            (##type-flags type)
                            1)
                           0)
                        (structure-hash obj
                                        type
                                        (##vector-length obj)
                                        (hash type-id))
                        (##eq?-hash obj))))
                   ((##box? obj)
                    (combine (hash (##unbox obj))
                             153391703))
                   (else
                    (##eqv?-hash obj))))
            (else
             (##eqv?-hash obj)))))

  (hash obj))

(define-prim (equal?-hash obj)
  (macro-force-vars (obj)
    (##equal?-hash obj)))

(define-prim (##string=?-hash str)

  ;; for all str2 we must have that (##string=? str str2) implies that
  ;; (= (##string=?-hash str) (##string=?-hash str2))

  (let ((len (##string-length str)))
    (let loop ((h 0) (i 0))
      (if (##fixnum.< i len)
        (loop (##fixnum.bitwise-and
               (##fixnum.* (##fixnum.+
                            (##fixnum.arithmetic-shift-right h 8)
                            (##fixnum.<-char (##string-ref str i)))
                           331804471)
               (macro-max-fixnum32))
              (##fixnum.+ i 1))
        h))))

(define-prim (string=?-hash str)
  (macro-force-vars (str)
    (macro-check-string str 1 (string=?-hash str)
      (##string=?-hash str))))

(define-prim (##string-ci=?-hash str)

  ;; for all str2 we must have that (##string-ci=? str str2) implies that
  ;; (= (##string-ci=?-hash str) (##string-ci=?-hash str2))

  (let ((len (##string-length str)))
    (let loop ((h 0) (i 0))
      (if (##fixnum.< i len)
        (loop (##fixnum.bitwise-and
               (##fixnum.* (##fixnum.+
                            (##fixnum.arithmetic-shift-right h 8)
                            (##fixnum.<-char
                             (##char-downcase (##string-ref str i))))
                           331804471)
               (macro-max-fixnum32))
              (##fixnum.+ i 1))
        h))))

(define-prim (string-ci=?-hash str)
  (macro-force-vars (str)
    (macro-check-string str 1 (string-ci=?-hash str)
      (##string-ci=?-hash str))))

(define-prim (##generic-hash obj)
  0)

;;;----------------------------------------------------------------------------

;;; Tables.

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

(implement-library-type-unbound-table-key-exception)

(define-prim (##raise-unbound-table-key-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-unbound-table-key-exception
       procedure
       arguments)))))

(define-prim (##gc-hash-table? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-weak))
       (##not (##fixnum.= (##vector-length obj) (macro-will-size)))))

(define-prim (##gc-hash-table-ref gcht key))
(define-prim (##gc-hash-table-set! gcht key val))
(define-prim (##gc-hash-table-rehash! gcht-src gcht-dst))

(define-prim (##smallest-prime-no-less-than n) ;; n >= 3
  (let loop1 ((n (if (##fixnum.even? n) (##fixnum.+ n 1) n)))
    (let loop2 ((d 3))
      (cond ((##fixnum.< n (##fixnum.* d d))
             n)
            ((##fixnum.zero? (##fixnum.modulo n d))
             (loop1 (##fixnum.+ n 2)))
            (else
             (loop2 (##fixnum.+ d 2)))))))

(define-prim (##gc-hash-table-resize! gcht loads)
  (let* ((count
          (macro-gc-hash-table-count gcht))
         (n
          (##flonum.->fixnum
           (##flonum./ (##flonum.<-fixnum count)
                       (##f64vector-ref loads 1)))))
    (##gc-hash-table-allocate
     n
     (##fixnum.bitwise-and
      (macro-gc-hash-table-flags gcht)
      (##fixnum.bitwise-not
       (macro-gc-hash-table-flag-need-rehash)))
     loads)))

(define-prim (##gc-hash-table-allocate n flags loads)
  (if (##fixnum.< (macro-gc-hash-table-minimal-nb-entries) n)
    (let* ((nb-entries
            (##smallest-prime-no-less-than (##fixnum.+ n 1)))
           (min-count
            (##flonum.->fixnum
             (##flonum.* (##flonum.<-fixnum n)
                         (##f64vector-ref loads 0))))
           (free
            (##fixnum.+ 1
                        (##flonum.->fixnum
                         (##flonum.* (##flonum.<-fixnum
                                      (##fixnum.- nb-entries 1))
                                     (##f64vector-ref loads 2))))))
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
      (if (##fixnum.< i (##vector-length ht))
        (let ((key (##vector-ref ht i)))
          (if (and (##not (##eq? key (macro-unused-obj)))
                   (##not (##eq? key (macro-deleted-obj))))
            (proc key (##vector-ref ht (##fixnum.+ i 1))))
          (let ()
            (##declare (interrupts-enabled))
            (loop (##fixnum.+ i 2))))
        (##void)))
    (##void)))

(define-prim (##gc-hash-table-search proc ht)
  (##declare (not interrupts-enabled))
  (if (##gc-hash-table? ht)
    (let loop ((i (macro-gc-hash-table-key0)))
      (if (##fixnum.< i (##vector-length ht))
        (let ((key (##vector-ref ht i)))
          (or (and (##not (##eq? key (macro-unused-obj)))
                   (##not (##eq? key (macro-deleted-obj)))
                   (proc key (##vector-ref ht (##fixnum.+ i 1))))
              (let ()
                (##declare (interrupts-enabled))
                (loop (##fixnum.+ i 2)))))
        #f))
    #f))

(define-prim (##gc-hash-table-foldl f base proc ht)
  (##declare (not interrupts-enabled))
  (if (##gc-hash-table? ht)
    (let loop ((i (macro-gc-hash-table-key0)) (base base))
      (if (##fixnum.< i (##vector-length ht))
        (let ((key (##vector-ref ht i)))
          (if (and (##not (##eq? key (macro-unused-obj)))
                   (##not (##eq? key (macro-deleted-obj))))
            (let ((new-base
                   (f base (proc key (##vector-ref ht (##fixnum.+ i 1))))))
              (##declare (interrupts-enabled))
              (loop (##fixnum.+ i 2) new-base))
            (let ()
              (##declare (interrupts-enabled))
              (loop (##fixnum.+ i 2) base))))
        base))
    base))

(define-prim (##mem-allocated? obj)
  (let ((type (##type obj)))
    (or (##fixnum.= type (macro-type-subtyped))
        (##fixnum.= type (macro-type-pair)))))

(implement-type-table)

(define-fail-check-type table (macro-type-table))

(define-check-type table (macro-type-table)
  macro-table?)

(define-prim (table? obj)
  (macro-table? obj))

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
      (let ((arg-num (##fixnum.+ arg-num 2)))
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
         (check-weak-keys (##fixnum.min size 2000000) ;; avoid fixnum overflows
                          arg-num)))))

  (define (check-weak-keys siz arg-num)
    (if (##eq? weak-keys (macro-absent-obj))
      (check-weak-values siz
                         (macro-default-weak-keys)
                         arg-num)
      (let ((arg-num (##fixnum.+ arg-num 2)))
        (check-weak-values siz
                           (if weak-keys
                             (macro-gc-hash-table-flag-weak-keys)
                             0)
                           arg-num))))

  (define (check-weak-values siz flags arg-num)
    (if (##eq? weak-values (macro-absent-obj))
      (check-test siz
                  (##fixnum.+ flags
                              (macro-default-weak-values))
                  arg-num)
      (let ((arg-num (##fixnum.+ arg-num 2)))
        (check-test siz
                    (##fixnum.+ flags
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
      (let ((arg-num (##fixnum.+ arg-num 2)))
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
      (let ((arg-num (##fixnum.+ arg-num 2)))
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
      (let ((arg-num (##fixnum.+ arg-num 2)))
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
      (let ((arg-num (##fixnum.+ arg-num 2)))
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
     (##flonum.min (##flonum.- (macro-load-range-hi)
                               (macro-load-min-max-gap))
                   (##flonum.max (macro-load-range-lo)
                                 (##f64vector-ref loads 0))))
    (##f64vector-set!
     loads
     2
     (##flonum.min (macro-load-range-hi)
                   (##flonum.max (##flonum.+ (##f64vector-ref loads 0)
                                             (macro-load-min-max-gap))
                                 (##f64vector-ref loads 2))))
    (##f64vector-set!
     loads
     1
     (##flonum.sqrt (##flonum.* (##f64vector-ref loads 0)
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
                        (##fixnum.bitwise-ior
                         flags
                         (macro-gc-hash-table-flag-weak-keys))
                        flags)
                      test-fn
                      hash-fn
                      loads
                      siz
                      init))

  (check-size 0))

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
               (##fixnum.bitwise-ior
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
    (##fixnum.+ (count (macro-table-hash table))
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
                (let ((gcht (##table-get-gcht table)))
                  (if (##not
                       (##fixnum.= 0
                                   (##fixnum.bitwise-and
                                    (macro-gc-hash-table-flags gcht)
                                    (macro-gc-hash-table-flag-need-rehash))))
                      (begin
                        (##table-resize! table)
                        (macro-table-gcht table))
                      gcht)))
               (size
                (macro-gc-hash-table-nb-entries gcht))
               (probe2
                (##fixnum.arithmetic-shift-left
                 (##fixnum.modulo h size)
                 1))
               (step2
                (##fixnum.arithmetic-shift-left
                 (##fixnum.+ (##fixnum.modulo h (##fixnum.- size 1)) 1)
                 1))
               (size2
                (##fixnum.arithmetic-shift-left size 1))
               (test
                (macro-table-test table)))
          (let loop2 ((probe2 probe2)
                      (deleted2 #f))
            (let ((k (macro-gc-hash-table-key-ref gcht probe2)))
              (cond ((##eq? k (macro-unused-obj))
                     (not-found table key gcht probe2 deleted2 val))
                    ((##eq? k (macro-deleted-obj))
                     (let ((next-probe2 (##fixnum.- probe2 step2)))
                       (loop2 (if (##fixnum.< next-probe2 0)
                                (##fixnum.+ next-probe2 size2)
                                next-probe2)
                              (or deleted2 probe2))))
                    ((test key k)
                     (found table key gcht probe2 val))
                    (else
                     (let ((next-probe2 (##fixnum.- probe2 step2)))
                       (loop2 (if (##fixnum.< next-probe2 0)
                                (##fixnum.+ next-probe2 size2)
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
                (##raise-unbound-table-key-exception
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
                 (##raise-unbound-table-key-exception
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
        (if (##fixnum.< i (##vector-length gcht))
          (let ((key (##vector-ref gcht i)))
            (if (and (##not (##eq? key (macro-unused-obj)))
                     (##not (##eq? key (macro-deleted-obj))))
              (let ((val (##vector-ref gcht (##fixnum.+ i 1))))
                (##table-set! table key val)))
            (let ()
              (##declare (interrupts-enabled))
              (loop (##fixnum.+ i 2))))
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
           (let ((count (##fixnum.- (macro-gc-hash-table-count gcht) 1)))
             (macro-gc-hash-table-count-set! gcht count)
             (macro-gc-hash-table-key-set! gcht probe2 (macro-deleted-obj))
             (macro-gc-hash-table-val-set! gcht probe2 (macro-unused-obj))
             (if (##fixnum.< count (macro-gc-hash-table-min-count gcht))
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
             (let ((count (##fixnum.+ (macro-gc-hash-table-count gcht) 1)))
               (macro-gc-hash-table-count-set! gcht count)
               (macro-gc-hash-table-key-set! gcht deleted2 key)
               (macro-gc-hash-table-val-set! gcht deleted2 val)
               (##void))
             (let ((count (##fixnum.+ (macro-gc-hash-table-count gcht) 1))
                   (free (##fixnum.- (macro-gc-hash-table-free gcht) 1)))
               (macro-gc-hash-table-count-set! gcht count)
               (macro-gc-hash-table-free-set! gcht free)
               (macro-gc-hash-table-key-set! gcht probe2 key)
               (macro-gc-hash-table-val-set! gcht probe2 val)
               (if (##fixnum.< free 0)
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
          (##not (##fixnum.= 0 (##fixnum.bitwise-and
                                flags
                                (macro-gc-hash-table-flag-weak-keys)))))
         (weak-values
          (##not (##fixnum.= 0 (##fixnum.bitwise-and
                                flags
                                (macro-gc-hash-table-flag-weak-vals)))))
         (test-field
          (macro-table-test table))
         (test
          (or test-field
              (macro-absent-obj)))
         (hash
          (if test-field
            (macro-table-hash table)
            (macro-absent-obj)))
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

(define-prim (##table-equal? table1 table2)

  (##declare (not interrupts-enabled))

  (and (##fixnum.= (macro-table-flags table1)
                   (macro-table-flags table2))
       (##eq? (macro-table-test table1)
              (macro-table-test table2))
       (if (macro-table-test table1)
         (##eq? (macro-table-hash table1)
                (macro-table-hash table2))
         #t)
       (let* ((len1 (##table-length table1))
              (len2 (##table-length table2)))
         (and (##fixnum.= len1 len2)
              (##not (##table-search
                      (lambda (key1 val1)
                        (let ((val2
                               (##table-ref table2 key1 (macro-unused-obj))))
                          (##not (##equal? val1 val2))))
                      table1))))))

(define-prim (##table-equal?-hash table)

  (define (combine a b)
    (##fixnum.bitwise-and
     (##fixnum.* (##fixnum.+ a (##fixnum.arithmetic-shift-left b 1))
                 331804471)
     (macro-max-fixnum32)))

  (##table-foldl
   (lambda (a b) ;; must be associative and commutative
     (##fixnum.bitwise-xor a b))
   (combine
    (macro-table-flags table)
    (combine
     (##eq?-hash (macro-table-test table))
     (combine
      (if (macro-table-test table)
        (##eq?-hash (macro-table-hash table))
        0)
      (##table-length table))))
   (lambda (key val)
     (combine
      (if (macro-table-test table)
        (let ((f (macro-table-hash table)))
          (f key))
        0)
      (##equal?-hash val)))
   table))

;;;----------------------------------------------------------------------------

;;; Serial numbers.

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
               (n+1 (or (##fixnum.+? n 1) 0)))
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

;;;============================================================================

;;; Binary serialization/deserialization.

;;;============================================================================

;;; General object representation.

;;; Type tags.

(##define-macro (macro-type-fixnum)   0)
(##define-macro (macro-type-subtyped) 1)
(##define-macro (macro-type-special)  2)
(##define-macro (macro-type-pair)     3)

;;; Subtype tags.

(##define-macro (macro-subtype-vector)       0)
(##define-macro (macro-subtype-pair)         1)
(##define-macro (macro-subtype-ratnum)       2)
(##define-macro (macro-subtype-cpxnum)       3)
(##define-macro (macro-subtype-structure)    4)
(##define-macro (macro-subtype-boxvalues)    5)
(##define-macro (macro-subtype-meroon)       6)

(##define-macro (macro-subtype-symbol)       8)
(##define-macro (macro-subtype-keyword)      9)
(##define-macro (macro-subtype-frame)        10)
(##define-macro (macro-subtype-continuation) 11)
(##define-macro (macro-subtype-promise)      12)
(##define-macro (macro-subtype-weak)         13)
(##define-macro (macro-subtype-procedure)    14)
(##define-macro (macro-subtype-return)       15)

(##define-macro (macro-subtype-foreign)      18)
(##define-macro (macro-subtype-string)       19)
(##define-macro (macro-subtype-s8vector)     20)
(##define-macro (macro-subtype-u8vector)     21)
(##define-macro (macro-subtype-s16vector)    22)
(##define-macro (macro-subtype-u16vector)    23)
(##define-macro (macro-subtype-s32vector)    24)
(##define-macro (macro-subtype-u32vector)    25)
(##define-macro (macro-subtype-f32vector)    26)

;; for alignment these 5 must be last:
(##define-macro (macro-subtype-s64vector)    27)
(##define-macro (macro-subtype-u64vector)    28)
(##define-macro (macro-subtype-f64vector)    29)
(##define-macro (macro-subtype-flonum)       30)
(##define-macro (macro-subtype-bignum)       31)

(##define-macro (macro-absent-obj)  `(##type-cast -6 (##type #f)))
(##define-macro (macro-unused-obj)  `(##type-cast -14 (##type #f)))
(##define-macro (macro-deleted-obj) `(##type-cast -15 (##type #f)))

(##define-macro (macro-slot index struct . val)
  (if (null? val)
    `(##vector-ref ,struct ,index)
    `(##vector-set! ,struct ,index ,@val)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Symbol objects

;; A symbol is represented by an object vector of length 4
;; slot 0 = symbol name (a string or a fixnum <n> for a symbol named "g<n>")
;; slot 1 = hash code (non-negative fixnum)
;; slot 2 = link to next symbol in symbol table (#f for uninterned)
;; slot 3 = pointer to corresponding global variable (0 if none exists)

(##define-macro (macro-make-uninterned-symbol name hash)
  `(##subtype-set!
    (##vector ,name ,hash #f 0)
    (macro-subtype-symbol)))

(##define-macro (macro-symbol-name s)        `(macro-slot 0 ,s))
(##define-macro (macro-symbol-name-set! s x) `(macro-slot 0 ,s ,x))
(##define-macro (macro-symbol-hash s)        `(macro-slot 1 ,s))
(##define-macro (macro-symbol-hash-set! s x) `(macro-slot 1 ,s ,x))
(##define-macro (macro-symbol-next s)        `(macro-slot 2 ,s))
(##define-macro (macro-symbol-next-set! s x) `(macro-slot 2 ,s ,x))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Keyword objects

;; A keyword is represented by an object vector of length 3
;; slot 0 = keyword name (a string or a fixnum <n> for a keyword named "g<n>")
;; slot 1 = hash code (non-negative fixnum)
;; slot 2 = link to next keyword in keyword table (#f for uninterned)

(##define-macro (macro-make-uninterned-keyword name hash)
  `(##subtype-set!
    (##vector ,name ,hash #f)
    (macro-subtype-keyword)))

(##define-macro (macro-keyword-name k)        `(macro-slot 0 ,k))
(##define-macro (macro-keyword-name-set! k x) `(macro-slot 0 ,k ,x))
(##define-macro (macro-keyword-hash k)        `(macro-slot 1 ,k))
(##define-macro (macro-keyword-hash-set! k x) `(macro-slot 1 ,k ,x))
(##define-macro (macro-keyword-next k)        `(macro-slot 2 ,k))
(##define-macro (macro-keyword-next-set! k x) `(macro-slot 2 ,k ,x))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(##define-macro (macro-ratnum-make num den)
  `(##subtype-set!
    (##vector ,num ,den)
    (macro-subtype-ratnum)))

(##define-macro (macro-ratnum-numerator r)          `(macro-slot 0 ,r))
(##define-macro (macro-ratnum-numerator-set! r x)   `(macro-slot 0 ,r ,x))
(##define-macro (macro-ratnum-denominator r)        `(macro-slot 1 ,r))
(##define-macro (macro-ratnum-denominator-set! r x) `(macro-slot 1 ,r ,x))

(##define-macro (macro-cpxnum-make r i)
  `(##subtype-set!
    (##vector ,r ,i)
    (macro-subtype-cpxnum)))

(##define-macro (macro-cpxnum-real c)        `(macro-slot 0 ,c))
(##define-macro (macro-cpxnum-real-set! c x) `(macro-slot 0 ,c ,x))
(##define-macro (macro-cpxnum-imag c)        `(macro-slot 1 ,c))
(##define-macro (macro-cpxnum-imag-set! c x) `(macro-slot 1 ,c ,x))

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

(##define-macro (structure? obj) `(##structure? ,obj))
(##define-macro (gc-hash-table? obj) `(##gc-hash-table? ,obj))
(##define-macro (fixnum? obj) `(##fixnum? ,obj))

(define-prim (##object->u8vector
              obj
              #!optional
              (transform (macro-absent-obj)))

(##define-macro (subtype-set! obj subtype)
  `(##subtype-set! ,obj ,subtype))

(##define-macro (subvector-move! src-vect src-start src-end dst-vect dst-start)
  `(##subvector-move! ,src-vect ,src-start ,src-end ,dst-vect ,dst-start))

(##define-macro (max-fixnum)
  `##max-fixnum)

(##define-macro (max-char)
  `##max-char)


(##define-macro (continuation? obj)
  `(##continuation? ,obj))

(##define-macro (continuation-frame cont)
  `(##continuation-frame ,cont))

(##define-macro (continuation-denv cont)
  `(##continuation-denv ,cont))

(##define-macro (frame? obj)
  `(##frame? ,obj))

(##define-macro (frame-fs frame)
  `(##frame-fs ,frame))

(##define-macro (frame-ret frame)
  `(##frame-ret ,frame))

(##define-macro (frame-ref frame i)
  `(##frame-ref ,frame ,i))

(##define-macro (frame-slot-live? frame i)
  `(##frame-slot-live? ,frame ,i))

(##define-macro (subprocedure-parent-name subproc)
  `(##subprocedure-parent-name ,subproc))

(##define-macro (subprocedure-id subproc)
  `(##subprocedure-id ,subproc))

(##define-macro (subprocedure-nb-closed subproc)
  `(##subprocedure-nb-closed ,subproc))

(##define-macro (closure? obj)
  `(##closure? ,obj))

(##define-macro (closure-code closure)
  `(##closure-code ,closure))

(##define-macro (closure-ref closure i)
  `(##closure-ref ,closure ,i))

(##define-macro (extract-bit-field size position n)
  `(##extract-bit-field ,size ,position ,n))

(##define-macro (bignum? obj)
  `(##bignum? ,obj))

(##define-macro (subtyped? obj)
  `(##subtyped? ,obj))

(##define-macro (flonum? obj)
  `(##flonum? ,obj))

(##define-macro (ratnum? obj)
  `(##ratnum? ,obj))

(##define-macro (cpxnum? obj)
  `(##cpxnum? ,obj))

(##define-macro (boxvalues? obj)
  `(##fixnum.= (##subtype ,obj) (macro-subtype-boxvalues)))


(##define-macro (make-string . args)
  `(##make-string ,@args))

(##define-macro (string? . args)
  `(##string? ,@args))

(##define-macro (string-length str)
  `(##string-length ,str))

(##define-macro (string-ref str i)
  `(##string-ref ,str ,i))

(##define-macro (string-set! str i x)
  `(##string-set! ,str ,i ,x))


(##define-macro (make-vector . args)
  `(##make-vector ,@args))

(##define-macro (vector? . args)
  `(##vector? ,@args))

(##define-macro (vector-length vect)
  `(##vector-length ,vect))

(##define-macro (vector-ref vect i)
  `(##vector-ref ,vect ,i))

(##define-macro (vector-set! vect i x)
  `(##vector-set! ,vect ,i ,x))


(##define-macro (make-s8vector . args)
  `(##make-s8vector ,@args))

(##define-macro (s8vector? . args)
  `(##s8vector? ,@args))

(##define-macro (s8vector-length s8vect)
  `(##s8vector-length ,s8vect))

(##define-macro (s8vector-ref s8vect i)
  `(##s8vector-ref ,s8vect ,i))

(##define-macro (s8vector-set! s8vect i x)
  `(##s8vector-set! ,s8vect ,i ,x))

(##define-macro (s8vector-shrink! s8vect len)
  `(##s8vector-shrink! ,s8vect ,len))

(##define-macro (make-u8vector . args)
  `(##make-u8vector ,@args))

(##define-macro (u8vector? . args)
  `(##u8vector? ,@args))

(##define-macro (u8vector-length u8vect)
  `(##u8vector-length ,u8vect))

(##define-macro (u8vector-ref u8vect i)
  `(##u8vector-ref ,u8vect ,i))

(##define-macro (u8vector-set! u8vect i x)
  `(##u8vector-set! ,u8vect ,i ,x))

(##define-macro (u8vector-shrink! u8vect len)
  `(##u8vector-shrink! ,u8vect ,len))

(##define-macro (fifo->u8vector fifo start end)
  `(##fifo->u8vector ,fifo ,start ,end))


(##define-macro (make-s16vector . args)
  `(##make-s16vector ,@args))

(##define-macro (s16vector? . args)
  `(##s16vector? ,@args))

(##define-macro (s16vector-length s16vect)
  `(##s16vector-length ,s16vect))

(##define-macro (s16vector-ref s16vect i)
  `(##s16vector-ref ,s16vect ,i))

(##define-macro (s16vector-set! s16vect i x)
  `(##s16vector-set! ,s16vect ,i ,x))

(##define-macro (s16vector-shrink! s16vect len)
  `(##s16vector-shrink! ,s16vect ,len))

(##define-macro (make-u16vector . args)
  `(##make-u16vector ,@args))

(##define-macro (u16vector? . args)
  `(##u16vector? ,@args))

(##define-macro (u16vector-length u16vect)
  `(##u16vector-length ,u16vect))

(##define-macro (u16vector-ref u16vect i)
  `(##u16vector-ref ,u16vect ,i))

(##define-macro (u16vector-set! u16vect i x)
  `(##u16vector-set! ,u16vect ,i ,x))

(##define-macro (u16vector-shrink! u16vect len)
  `(##u16vector-shrink! ,u16vect ,len))


(##define-macro (make-s32vector . args)
  `(##make-s32vector ,@args))

(##define-macro (s32vector? . args)
  `(##s32vector? ,@args))

(##define-macro (s32vector-length s32vect)
  `(##s32vector-length ,s32vect))

(##define-macro (s32vector-ref s32vect i)
  `(##s32vector-ref ,s32vect ,i))

(##define-macro (s32vector-set! s32vect i x)
  `(##s32vector-set! ,s32vect ,i ,x))

(##define-macro (s32vector-shrink! s32vect len)
  `(##s32vector-shrink! ,s32vect ,len))

(##define-macro (make-u32vector . args)
  `(##make-u32vector ,@args))

(##define-macro (u32vector? . args)
  `(##u32vector? ,@args))

(##define-macro (u32vector-length u32vect)
  `(##u32vector-length ,u32vect))

(##define-macro (u32vector-ref u32vect i)
  `(##u32vector-ref ,u32vect ,i))

(##define-macro (u32vector-set! u32vect i x)
  `(##u32vector-set! ,u32vect ,i ,x))

(##define-macro (u32vector-shrink! u32vect len)
  `(##u32vector-shrink! ,u32vect ,len))


(##define-macro (make-s64vector . args)
  `(##make-s64vector ,@args))

(##define-macro (s64vector? . args)
  `(##s64vector? ,@args))

(##define-macro (s64vector-length s64vect)
  `(##s64vector-length ,s64vect))

(##define-macro (s64vector-ref s64vect i)
  `(##s64vector-ref ,s64vect ,i))

(##define-macro (s64vector-set! s64vect i x)
  `(##s64vector-set! ,s64vect ,i ,x))

(##define-macro (s64vector-shrink! s64vect len)
  `(##s64vector-shrink! ,s64vect ,len))

(##define-macro (make-u64vector . args)
  `(##make-u64vector ,@args))

(##define-macro (u64vector? . args)
  `(##u64vector? ,@args))

(##define-macro (u64vector-length u64vect)
  `(##u64vector-length ,u64vect))

(##define-macro (u64vector-ref u64vect i)
  `(##u64vector-ref ,u64vect ,i))

(##define-macro (u64vector-set! u64vect i x)
  `(##u64vector-set! ,u64vect ,i ,x))

(##define-macro (u64vector-shrink! u64vect len)
  `(##u64vector-shrink! ,u64vect ,len))


(##define-macro (make-f32vector . args)
  `(##make-f32vector ,@args))

(##define-macro (f32vector? . args)
  `(##f32vector? ,@args))

(##define-macro (f32vector-length f32vect)
  `(##f32vector-length ,f32vect))

(##define-macro (f32vector-ref f32vect i)
  `(##f32vector-ref ,f32vect ,i))

(##define-macro (f32vector-set! f32vect i x)
  `(##f32vector-set! ,f32vect ,i ,x))

(##define-macro (f32vector-shrink! f32vect len)
  `(##f32vector-shrink! ,f32vect ,len))

(##define-macro (make-f64vector . args)
  `(##make-f64vector ,@args))

(##define-macro (f64vector? . args)
  `(##f64vector? ,@args))

(##define-macro (f64vector-length f64vect)
  `(##f64vector-length ,f64vect))

(##define-macro (f64vector-ref f64vect i)
  `(##f64vector-ref ,f64vect ,i))

(##define-macro (f64vector-set! f64vect i x)
  `(##f64vector-set! ,f64vect ,i ,x))

(##define-macro (f64vector-shrink! f64vect len)
  `(##f64vector-shrink! ,f64vect ,len))


(##define-macro (symbol? . args)
  `(##symbol? ,@args))

(##define-macro (symbol->string . args)
  `(##symbol->string ,@args))

(##define-macro (string->symbol . args)
  `(##string->symbol ,@args))

(##define-macro (keyword? . args)
  `(##keyword? ,@args))

(##define-macro (keyword->string . args)
  `(##keyword->string ,@args))

(##define-macro (string->keyword . args)
  `(##string->keyword ,@args))


(##define-macro (+ . args)
  `(##fixnum.+ ,@args))

(##define-macro (- . args)
  `(##fixnum.- ,@args))

(##define-macro (* . args)
  `(##fixnum.* ,@args))

(##define-macro (< . args)
  `(##fixnum.< ,@args))

(##define-macro (> . args)
  `(##fixnum.> ,@args))

(##define-macro (= . args)
  `(##fixnum.= ,@args))

(##define-macro (>= . args)
  `(##fixnum.>= ,@args))

(##define-macro (<= . args)
  `(##fixnum.<= ,@args))

(##define-macro (bitwise-and . args)
  `(##fixnum.bitwise-and ,@args))

(##define-macro (bitwise-ior . args)
  `(##fixnum.bitwise-ior ,@args))

(##define-macro (arithmetic-shift-left . args)
  `(##fixnum.arithmetic-shift-left ,@args))

(##define-macro (arithmetic-shift-right . args)
  `(##fixnum.arithmetic-shift-right ,@args))

(##define-macro (generic.+ . args)
  `(##+ ,@args))

(##define-macro (generic.arithmetic-shift . args)
  `(##arithmetic-shift ,@args))

(##define-macro (generic.bit-set? . args)
  `(##bit-set? ,@args))

(##define-macro (generic.bitwise-ior . args)
  `(##bitwise-ior ,@args))

(##define-macro (generic.extract-bit-field . args)
  `(##extract-bit-field ,@args))

(##define-macro (generic.gcd . args)
  `(##gcd ,@args))

(##define-macro (generic.negative? . args)
  `(##negative? ,@args))

(##define-macro (integer-length . args)
  `(##integer-length ,@args))

(##define-macro (make-table . args)
  `(##make-table-aux 0 #f #f #f ##eq?))

(##define-macro (table-ref . args)
  `(##table-ref ,@args))

(##define-macro (table-set! . args)
  `(##table-set! ,@args))

(##define-macro (uninterned-keyword? . args)
  `(##uninterned-keyword? ,@args))

(##define-macro (uninterned-symbol? . args)
  `(##uninterned-symbol? ,@args))


(##define-macro (char->integer . args)
  `(##fixnum.<-char ,@args))

(##define-macro (integer->char . args)
  `(##fixnum.->char ,@args))


(##define-macro (vector . args)
  `(##vector ,@args))


(##define-macro (cons . args)
  `(##cons ,@args))

(##define-macro (pair? . args)
  `(##pair? ,@args))

(##define-macro (car . args)
  `(##car ,@args))

(##define-macro (cdr . args)
  `(##cdr ,@args))

(##define-macro (set-car! . args)
  `(##set-car! ,@args))

(##define-macro (set-cdr! . args)
  `(##set-cdr! ,@args))


(##define-macro (procedure? . args)
  `(##procedure? ,@args))

(##define-macro (char? . args)
  `(##char? ,@args))

(##define-macro (real? . args)
  `(##real? ,@args))

(##define-macro (not . args)
  `(##not ,@args))

(##define-macro (eq? . args)
  `(##eq? ,@args))

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
      (vector-set! state 0 (+ ptr 1))
      (let ((fifo (vector-ref state 1))
            (i (bitwise-and ptr (- chunk-len 1))))
        (u8vector-set!
         (if (= i 0)
             (let ((chunk (make-u8vector chunk-len)))
               (macro-fifo-insert-at-tail! fifo chunk)
               chunk)
             (macro-fifo-elem (macro-fifo-tail fifo)))
         i
         x))))

  (define (get-output-u8vector)
    (let ((ptr (vector-ref state 0))
          (fifo (vector-ref state 1)))
      (if (and (< 0 ptr) (<= ptr chunk-len))
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
      (vector-set! state 2 (+ n 1))
      (table-set! (vector-ref state 3) obj n)))

  (define (serialize-shared! n)
    (let ((lo (bitwise-and n #x7f))
          (hi (arithmetic-shift-right n 7)))
      (write-u8 (bitwise-ior (shared-tag) lo))
      (serialize-nonneg-fixnum! hi)))

  (define (serialize-nonneg-fixnum! n)
    (let ((lo (bitwise-and n #x7f))
          (hi (arithmetic-shift-right n 7)))
      (if (= hi 0)
          (write-u8 lo)
          (begin
            (write-u8 (bitwise-ior #x80 lo))
            (serialize-nonneg-fixnum! hi)))))

  (define (serialize-flonum-32! n)
    (serialize-exact-int-of-length!
     (##flonum.->ieee754-32 n)
     4))

  (define (serialize-flonum-64! n)
    (serialize-exact-int-of-length!
     (##flonum.->ieee754-64 n)
     8))

  (define (serialize-exact-int-of-length! n len)
    (if (fixnum? n)
        (let loop ((n n) (len len))
          (if (> len 0)
              (begin
                (write-u8 (bitwise-and n #xff))
                (loop (arithmetic-shift-right n 8) (- len 1)))))
        (let* ((len/2 (arithmetic-shift-right len 1))
               (len/2*8 (* len/2 8)))
          (serialize-exact-int-of-length!
           (generic.extract-bit-field len/2*8 0 n)
           len/2)
          (serialize-exact-int-of-length!
           (generic.arithmetic-shift n (- len/2*8))
           (- len len/2)))))

  (define (exact-int-length n signed?)
    (arithmetic-shift-right
     (+ (integer-length n) (if signed? 8 7))
     3))

  (define (serialize-exact-int! n)
    (or (share n)
        (let ((len (exact-int-length n #t)))
          (if (<= len 4)
              (write-u8 (bitwise-ior (exact-int-tag) (- #x0f len)))
              (begin
                (write-u8 (bitwise-ior (exact-int-tag) #x0f))
                (serialize-nonneg-fixnum! len)))
          (serialize-exact-int-of-length! n len)
          (alloc! n))))

  (define (serialize-vector-like! vect tag)
    (let ((len (vector-length vect)))
      (if (< len #x0f)
          (begin
            (write-u8 (bitwise-ior tag len))
            (serialize-subvector! vect 0 len))
          (serialize-vector-like-long! vect (bitwise-ior tag #x0f)))))

  (define (serialize-vector-like-long! vect tag)
    (let ((len (vector-length vect)))
      (write-u8 tag)
      (serialize-nonneg-fixnum! len)
      (serialize-subvector! vect 0 len)))

  (define (serialize-subvector! vect start end)
    (let loop ((i start))
      (if (< i end)
          (begin
            (serialize! (vector-ref vect i))
            (loop (+ i 1))))))

  (define (serialize-string-like! str tag mask)
    (let ((len (string-length str)))
      (if (< len mask)
          (begin
            (write-u8 (bitwise-ior tag len))
            (serialize-string! str))
          (begin
            (write-u8 (bitwise-ior tag mask))
            (serialize-nonneg-fixnum! len)
            (serialize-string! str)))))

  (define (serialize-string! str)
    (serialize-elements!
     0
     (string-length str)
     (lambda (i)
       (serialize-nonneg-fixnum! (char->integer (string-ref str i))))))

  (define (serialize-elements! start end serialize-element!)
    (let loop ((i start))
      (if (< i end)
          (begin
            (serialize-element! i)
            (loop (+ i 1))))))

  (define (serialize-homintvector! vect vect-tag vect-length vect-ref elem-len)
    (or (share vect)
        (let ((len (vect-length vect)))
          (write-u8 (homvector-tag))
          (serialize-nonneg-fixnum!
           (bitwise-ior vect-tag (arithmetic-shift-left len 4)))
          (serialize-elements!
           0
           len
           (lambda (i)
             (serialize-exact-int-of-length!
              (vect-ref vect i)
              elem-len)))
          (alloc! vect))))

  (define (serialize-homfloatvector! vect vect-tag vect-length vect-ref f32?)
    (or (share vect)
        (let ((len (vect-length vect)))
          (write-u8 (homvector-tag))
          (serialize-nonneg-fixnum!
           (bitwise-ior vect-tag (arithmetic-shift-left len 4)))
          (serialize-elements!
           0
           len
           (lambda (i)
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
                (if (< subproc-id mask)
                    (write-u8 (bitwise-ior tag subproc-id))
                    (begin
                      (write-u8 (bitwise-ior tag mask))
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
      (cond ((subtyped? obj)

             (cond ((symbol? obj)
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
                          (serialize-vector-like! obj (vector-tag)))))

                   ((structure? obj)
                    (if (or (macro-thread? obj)
                            (macro-tgroup? obj)
                            (macro-mutex? obj)
                            (macro-condvar? obj))
                      (cannot-serialize obj)
                      (or (share obj)
                          (begin
                            (alloc! obj)
                            (serialize-vector-like! obj (structure-tag))))))

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
                                (serialize-subvector! obj 1 (+ nb-closed 1)))))

                        (serialize-subprocedure! obj (subprocedure-tag) #x0f)))

                   ((flonum? obj)
                    (or (share obj)
                        (begin
                          (write-u8 (flonum-tag))
                          (serialize-flonum-64! obj)
                          (alloc! obj))))

                   ((bignum? obj)
                    (serialize-exact-int! obj))

                   ((ratnum? obj)
                    (or (share obj)
                        (begin
                          (write-u8 (ratnum-tag))
                          (serialize! (macro-ratnum-numerator obj))
                          (serialize! (macro-ratnum-denominator obj))
                          (alloc! obj))))

                   ((cpxnum? obj)
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
                        (let ((subproc (##continuation-ret cont))
                              (fs (##continuation-fs cont)))
                          (serialize-subprocedure! subproc 0 #x7f)
                          (alloc! (##cons 11 22))
                          (let loop ((i fs))
                            (if (##fixnum.> i 0)
                                (begin
                                  (serialize-cont-frame-ref! cont i)
                                  (loop (##fixnum.- i 1)))))))

                      (define (serialize-cont-frame-ref! cont i)
                        (let* ((fs (##continuation-fs cont))
                               (j (##fixnum.+ (##fixnum.- fs i) 1)))
                          (if (##continuation-slot-live? cont j)
                              (if (##fixnum.= j (##continuation-link cont))
                                  (let ((next (##continuation-next cont)))
                                    (if next
                                        (serialize-cont-frame! next)
                                        (serialize! 0)))
                                  (serialize! (##continuation-ref cont j))))))

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
                              (if (<= i fs)
                                  (begin
                                    (if (frame-slot-live? obj i)
                                        (serialize! (frame-ref obj i)))
                                    (loop (+ i 1)))))))))

                   ((boxvalues? obj)
                    (or (share obj)
                        (begin
                          (alloc! obj)
                          (serialize-vector-like-long! obj (boxvalues-tag)))))

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
                              (if (< i (vector-length obj))
                                  (let ((key (vector-ref obj i)))
                                    (if (and (not (eq? key (macro-unused-obj)))
                                             (not (eq? key (macro-deleted-obj))))
                                        (let ((val (vector-ref obj (+ i 1))))
                                          (serialize! key)
                                          (serialize! val)))
                                    (let ()
                                      (##declare (interrupts-enabled))
                                      (loop (+ i 2))))
                                  (serialize! (macro-unused-obj))))))))

                   ((s8vector? obj)
                    (serialize-homintvector!
                     obj
                     (s8vector-tag)
                     (lambda (v) (s8vector-length v))
                     (lambda (v i) (s8vector-ref v i))
                     1))

                   ((u8vector? obj)
                    (serialize-homintvector!
                     obj
                     (u8vector-tag)
                     (lambda (v) (u8vector-length v))
                     (lambda (v i) (u8vector-ref v i))
                     1))

                   ((s16vector? obj)
                    (serialize-homintvector!
                     obj
                     (s16vector-tag)
                     (lambda (v) (s16vector-length v))
                     (lambda (v i) (s16vector-ref v i))
                     2))

                   ((u16vector? obj)
                    (serialize-homintvector!
                     obj
                     (u16vector-tag)
                     (lambda (v) (u16vector-length v))
                     (lambda (v i) (u16vector-ref v i))
                     2))

                   ((s32vector? obj)
                    (serialize-homintvector!
                     obj
                     (s32vector-tag)
                     (lambda (v) (s32vector-length v))
                     (lambda (v i) (s32vector-ref v i))
                     4))

                   ((u32vector? obj)
                    (serialize-homintvector!
                     obj
                     (u32vector-tag)
                     (lambda (v) (u32vector-length v))
                     (lambda (v i) (u32vector-ref v i))
                     4))

                   ((s64vector? obj)
                    (serialize-homintvector!
                     obj
                     (s64vector-tag)
                     (lambda (v) (s64vector-length v))
                     (lambda (v i) (s64vector-ref v i))
                     8))

                   ((u64vector? obj)
                    (serialize-homintvector!
                     obj
                     (u64vector-tag)
                     (lambda (v) (u64vector-length v))
                     (lambda (v i) (u64vector-ref v i))
                     8))

                   ((f32vector? obj)
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

                   (else
                    (cannot-serialize obj))))

            ((pair? obj)
             (or (share obj)
                 (begin
                   (alloc! obj)
                   (write-u8 (pair-tag))
                   (serialize! (car obj))
                   (serialize! (cdr obj)))))

            ((fixnum? obj)
             (cond ((and (>= obj #x00)
                         (< obj #x0b))
                    (write-u8 (bitwise-ior (exact-int-tag) obj)))
                   ((and (>= obj #x-80)
                         (< obj #x80))
                    (write-u8 (bitwise-ior (exact-int-tag) #x0e))
                    (write-u8 (bitwise-and obj #xff)))
                   (else
                    (serialize-exact-int! obj))))

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
            ((eq? obj (macro-unused-obj))  (write-u8 (unused-tag)))
            ((eq? obj (macro-deleted-obj)) (write-u8 (deleted-tag)))

            (else
             (cannot-serialize obj)))))

  (serialize! obj)

  (get-output-u8vector))

(define-prim (object->u8vector
              obj
              #!optional
              (transform (macro-absent-obj)))
  (macro-force-vars (obj transform)
    (if (eq? transform (macro-absent-obj))
        (##object->u8vector obj)
        (macro-check-procedure transform 2 (object->u8vector obj transform)
          (##object->u8vector obj transform)))))

(define-prim (##u8vector->object
              u8vect
              #!optional
              (transform (macro-absent-obj)))

(##define-macro (subtype-set! obj subtype)
  `(##subtype-set! ,obj ,subtype))

(##define-macro (subvector-move! src-vect src-start src-end dst-vect dst-start)
  `(##subvector-move! ,src-vect ,src-start ,src-end ,dst-vect ,dst-start))

(##define-macro (max-fixnum)
  `##max-fixnum)

(##define-macro (max-char)
  `##max-char)


(##define-macro (continuation? obj)
  `(##continuation? ,obj))

(##define-macro (continuation-frame cont)
  `(##continuation-frame ,cont))

(##define-macro (continuation-denv cont)
  `(##continuation-denv ,cont))

(##define-macro (frame? obj)
  `(##frame? ,obj))

(##define-macro (frame-fs frame)
  `(##frame-fs ,frame))

(##define-macro (frame-ret frame)
  `(##frame-ret ,frame))

(##define-macro (frame-ref frame i)
  `(##frame-ref ,frame ,i))

(##define-macro (frame-slot-live? frame i)
  `(##frame-slot-live? ,frame ,i))

(##define-macro (subprocedure-parent-name subproc)
  `(##subprocedure-parent-name ,subproc))

(##define-macro (subprocedure-id subproc)
  `(##subprocedure-id ,subproc))

(##define-macro (subprocedure-nb-closed subproc)
  `(##subprocedure-nb-closed ,subproc))

(##define-macro (closure? obj)
  `(##closure? ,obj))

(##define-macro (closure-code closure)
  `(##closure-code ,closure))

(##define-macro (closure-ref closure i)
  `(##closure-ref ,closure ,i))

(##define-macro (extract-bit-field size position n)
  `(##extract-bit-field ,size ,position ,n))

(##define-macro (bignum? obj)
  `(##bignum? ,obj))

(##define-macro (subtyped? obj)
  `(##subtyped? ,obj))

(##define-macro (flonum? obj)
  `(##flonum? ,obj))

(##define-macro (ratnum? obj)
  `(##ratnum? ,obj))

(##define-macro (cpxnum? obj)
  `(##cpxnum? ,obj))

(##define-macro (boxvalues? obj)
  `(##fixnum.= (##subtype ,obj) (macro-subtype-boxvalues)))


(##define-macro (make-string . args)
  `(##make-string ,@args))

(##define-macro (string? . args)
  `(##string? ,@args))

(##define-macro (string-length str)
  `(##string-length ,str))

(##define-macro (string-ref str i)
  `(##string-ref ,str ,i))

(##define-macro (string-set! str i x)
  `(##string-set! ,str ,i ,x))


(##define-macro (make-vector . args)
  `(##make-vector ,@args))

(##define-macro (vector? . args)
  `(##vector? ,@args))

(##define-macro (vector-length vect)
  `(##vector-length ,vect))

(##define-macro (vector-ref vect i)
  `(##vector-ref ,vect ,i))

(##define-macro (vector-set! vect i x)
  `(##vector-set! ,vect ,i ,x))


(##define-macro (make-s8vector . args)
  `(##make-s8vector ,@args))

(##define-macro (s8vector? . args)
  `(##s8vector? ,@args))

(##define-macro (s8vector-length s8vect)
  `(##s8vector-length ,s8vect))

(##define-macro (s8vector-ref s8vect i)
  `(##s8vector-ref ,s8vect ,i))

(##define-macro (s8vector-set! s8vect i x)
  `(##s8vector-set! ,s8vect ,i ,x))

(##define-macro (s8vector-shrink! s8vect len)
  `(##s8vector-shrink! ,s8vect ,len))

(##define-macro (make-u8vector . args)
  `(##make-u8vector ,@args))

(##define-macro (u8vector? . args)
  `(##u8vector? ,@args))

(##define-macro (u8vector-length u8vect)
  `(##u8vector-length ,u8vect))

(##define-macro (u8vector-ref u8vect i)
  `(##u8vector-ref ,u8vect ,i))

(##define-macro (u8vector-set! u8vect i x)
  `(##u8vector-set! ,u8vect ,i ,x))

(##define-macro (u8vector-shrink! u8vect len)
  `(##u8vector-shrink! ,u8vect ,len))

(##define-macro (fifo->u8vector fifo start end)
  `(##fifo->u8vector ,fifo ,start ,end))


(##define-macro (make-s16vector . args)
  `(##make-s16vector ,@args))

(##define-macro (s16vector? . args)
  `(##s16vector? ,@args))

(##define-macro (s16vector-length s16vect)
  `(##s16vector-length ,s16vect))

(##define-macro (s16vector-ref s16vect i)
  `(##s16vector-ref ,s16vect ,i))

(##define-macro (s16vector-set! s16vect i x)
  `(##s16vector-set! ,s16vect ,i ,x))

(##define-macro (s16vector-shrink! s16vect len)
  `(##s16vector-shrink! ,s16vect ,len))

(##define-macro (make-u16vector . args)
  `(##make-u16vector ,@args))

(##define-macro (u16vector? . args)
  `(##u16vector? ,@args))

(##define-macro (u16vector-length u16vect)
  `(##u16vector-length ,u16vect))

(##define-macro (u16vector-ref u16vect i)
  `(##u16vector-ref ,u16vect ,i))

(##define-macro (u16vector-set! u16vect i x)
  `(##u16vector-set! ,u16vect ,i ,x))

(##define-macro (u16vector-shrink! u16vect len)
  `(##u16vector-shrink! ,u16vect ,len))


(##define-macro (make-s32vector . args)
  `(##make-s32vector ,@args))

(##define-macro (s32vector? . args)
  `(##s32vector? ,@args))

(##define-macro (s32vector-length s32vect)
  `(##s32vector-length ,s32vect))

(##define-macro (s32vector-ref s32vect i)
  `(##s32vector-ref ,s32vect ,i))

(##define-macro (s32vector-set! s32vect i x)
  `(##s32vector-set! ,s32vect ,i ,x))

(##define-macro (s32vector-shrink! s32vect len)
  `(##s32vector-shrink! ,s32vect ,len))

(##define-macro (make-u32vector . args)
  `(##make-u32vector ,@args))

(##define-macro (u32vector? . args)
  `(##u32vector? ,@args))

(##define-macro (u32vector-length u32vect)
  `(##u32vector-length ,u32vect))

(##define-macro (u32vector-ref u32vect i)
  `(##u32vector-ref ,u32vect ,i))

(##define-macro (u32vector-set! u32vect i x)
  `(##u32vector-set! ,u32vect ,i ,x))

(##define-macro (u32vector-shrink! u32vect len)
  `(##u32vector-shrink! ,u32vect ,len))


(##define-macro (make-s64vector . args)
  `(##make-s64vector ,@args))

(##define-macro (s64vector? . args)
  `(##s64vector? ,@args))

(##define-macro (s64vector-length s64vect)
  `(##s64vector-length ,s64vect))

(##define-macro (s64vector-ref s64vect i)
  `(##s64vector-ref ,s64vect ,i))

(##define-macro (s64vector-set! s64vect i x)
  `(##s64vector-set! ,s64vect ,i ,x))

(##define-macro (s64vector-shrink! s64vect len)
  `(##s64vector-shrink! ,s64vect ,len))

(##define-macro (make-u64vector . args)
  `(##make-u64vector ,@args))

(##define-macro (u64vector? . args)
  `(##u64vector? ,@args))

(##define-macro (u64vector-length u64vect)
  `(##u64vector-length ,u64vect))

(##define-macro (u64vector-ref u64vect i)
  `(##u64vector-ref ,u64vect ,i))

(##define-macro (u64vector-set! u64vect i x)
  `(##u64vector-set! ,u64vect ,i ,x))

(##define-macro (u64vector-shrink! u64vect len)
  `(##u64vector-shrink! ,u64vect ,len))


(##define-macro (make-f32vector . args)
  `(##make-f32vector ,@args))

(##define-macro (f32vector? . args)
  `(##f32vector? ,@args))

(##define-macro (f32vector-length f32vect)
  `(##f32vector-length ,f32vect))

(##define-macro (f32vector-ref f32vect i)
  `(##f32vector-ref ,f32vect ,i))

(##define-macro (f32vector-set! f32vect i x)
  `(##f32vector-set! ,f32vect ,i ,x))

(##define-macro (f32vector-shrink! f32vect len)
  `(##f32vector-shrink! ,f32vect ,len))

(##define-macro (make-f64vector . args)
  `(##make-f64vector ,@args))

(##define-macro (f64vector? . args)
  `(##f64vector? ,@args))

(##define-macro (f64vector-length f64vect)
  `(##f64vector-length ,f64vect))

(##define-macro (f64vector-ref f64vect i)
  `(##f64vector-ref ,f64vect ,i))

(##define-macro (f64vector-set! f64vect i x)
  `(##f64vector-set! ,f64vect ,i ,x))

(##define-macro (f64vector-shrink! f64vect len)
  `(##f64vector-shrink! ,f64vect ,len))


(##define-macro (symbol? . args)
  `(##symbol? ,@args))

(##define-macro (symbol->string . args)
  `(##symbol->string ,@args))

(##define-macro (string->symbol . args)
  `(##string->symbol ,@args))

(##define-macro (keyword? . args)
  `(##keyword? ,@args))

(##define-macro (keyword->string . args)
  `(##keyword->string ,@args))

(##define-macro (string->keyword . args)
  `(##string->keyword ,@args))


(##define-macro (+ . args)
  `(##fixnum.+ ,@args))

(##define-macro (- . args)
  `(##fixnum.- ,@args))

(##define-macro (* . args)
  `(##fixnum.* ,@args))

(##define-macro (< . args)
  `(##fixnum.< ,@args))

(##define-macro (> . args)
  `(##fixnum.> ,@args))

(##define-macro (= . args)
  `(##fixnum.= ,@args))

(##define-macro (>= . args)
  `(##fixnum.>= ,@args))

(##define-macro (<= . args)
  `(##fixnum.<= ,@args))

(##define-macro (bitwise-and . args)
  `(##fixnum.bitwise-and ,@args))

(##define-macro (bitwise-ior . args)
  `(##fixnum.bitwise-ior ,@args))

(##define-macro (arithmetic-shift-left . args)
  `(##fixnum.arithmetic-shift-left ,@args))

(##define-macro (arithmetic-shift-right . args)
  `(##fixnum.arithmetic-shift-right ,@args))

(##define-macro (generic.+ . args)
  `(##+ ,@args))

(##define-macro (generic.arithmetic-shift . args)
  `(##arithmetic-shift ,@args))

(##define-macro (generic.bit-set? . args)
  `(##bit-set? ,@args))

(##define-macro (generic.bitwise-ior . args)
  `(##bitwise-ior ,@args))

(##define-macro (generic.extract-bit-field . args)
  `(##extract-bit-field ,@args))

(##define-macro (generic.gcd . args)
  `(##gcd ,@args))

(##define-macro (generic.negative? . args)
  `(##negative? ,@args))

(##define-macro (integer-length . args)
  `(##integer-length ,@args))

(##define-macro (make-table . args)
  `(##make-table-aux 0 #f #f #f ##eq?))

(##define-macro (table-ref . args)
  `(##table-ref ,@args))

(##define-macro (table-set! . args)
  `(##table-set! ,@args))

(##define-macro (uninterned-keyword? . args)
  `(##uninterned-keyword? ,@args))

(##define-macro (uninterned-symbol? . args)
  `(##uninterned-symbol? ,@args))


(##define-macro (char->integer . args)
  `(##fixnum.<-char ,@args))

(##define-macro (integer->char . args)
  `(##fixnum.->char ,@args))


(##define-macro (vector . args)
  `(##vector ,@args))


(##define-macro (cons . args)
  `(##cons ,@args))

(##define-macro (pair? . args)
  `(##pair? ,@args))

(##define-macro (car . args)
  `(##car ,@args))

(##define-macro (cdr . args)
  `(##cdr ,@args))

(##define-macro (set-car! . args)
  `(##set-car! ,@args))

(##define-macro (set-cdr! . args)
  `(##set-cdr! ,@args))


(##define-macro (procedure? . args)
  `(##procedure? ,@args))

(##define-macro (char? . args)
  `(##char? ,@args))

(##define-macro (real? . args)
  `(##real? ,@args))

(##define-macro (not . args)
  `(##not ,@args))

(##define-macro (eq? . args)
  `(##eq? ,@args))

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
      (if (< ptr (u8vector-length u8vect))
          (begin
            (vector-set! state 0 (+ ptr 1))
            (u8vector-ref u8vect ptr))
          (err))))

  (define (eof?)
    (let ((ptr (vector-ref state 0))
          (u8vect (vector-ref state 1)))
      (= ptr (u8vector-length u8vect))))

  (define (alloc! obj)
    (let* ((n (vector-ref state 2))
           (vect (vector-ref state 3))
           (len (vector-length vect)))
      (vector-set! state 2 (+ n 1))
      (if (= n len)
          (let* ((new-len (+ (arithmetic-shift-right (* len 3) 1) 1))
                 (new-vect (make-vector new-len)))
            (vector-set! state 3 new-vect)
            (subvector-move! vect 0 n new-vect 0)
            (vector-set! new-vect n obj))
          (vector-set! vect n obj))
      n))

  (define (shared-ref i)
    (let* ((n (vector-ref state 2))
           (vect (vector-ref state 3)))
      (if (< i n)
          (vector-ref vect i)
          (err))))

  (define (deserialize-nonneg-fixnum! n shift)
    (let loop ((n n)
               (shift shift)
               (range (arithmetic-shift-right (max-fixnum) shift)))
      (if (= range 0)
          (err)
          (let ((x (read-u8)))
            (if (< x #x80)
                (if (< range x)
                    (err)
                    (bitwise-ior n (arithmetic-shift-left x shift)))
                (let ((b (bitwise-and x #x7f)))
                  (if (< range b)
                      (err)
                      (loop (bitwise-ior n (arithmetic-shift-left b shift))
                            (+ shift 7)
                            (arithmetic-shift-right range 7)))))))))

  (define (deserialize-flonum-32!)
    (let ((n (deserialize-nonneg-exact-int-of-length! 4)))
      (##flonum.<-ieee754-32 n)))

  (define (deserialize-flonum-64!)
    (let ((n (deserialize-nonneg-exact-int-of-length! 8)))
      (##flonum.<-ieee754-64 n)))

  (define (deserialize-nonneg-exact-int-of-length! len)
    (if (<= len 3) ;; result fits in a 32 bit fixnum?
        (let ((a (read-u8)))
          (if (= len 1)
              a
              (+ a
                 (arithmetic-shift-left
                  (let ((b (read-u8)))
                    (if (= len 2)
                        b
                        (+ b
                           (arithmetic-shift-left
                            (let ((c (read-u8)))
                              c)
                            8))))
                  8))))
        (let* ((len/2 (arithmetic-shift-right len 1))
               (a (deserialize-nonneg-exact-int-of-length! len/2))
               (b (deserialize-nonneg-exact-int-of-length! (- len len/2))))
          (generic.bitwise-ior a (generic.arithmetic-shift b (* 8 len/2))))))

  (define (deserialize-exact-int-of-length! len)
    (let ((n (deserialize-nonneg-exact-int-of-length! len)))
      (if (generic.bit-set? (- (* 8 len) 1) n)
          (generic.+ n (generic.arithmetic-shift -1 (* 8 len)))
          n)))

  (define (deserialize-string! x mask)
    (deserialize-string-of-length!
     (let ((lo (bitwise-and x mask)))
       (if (< lo mask)
           lo
           (deserialize-nonneg-fixnum! 0 0)))))

  (define (deserialize-string-of-length! len)
    (let ((obj (make-string len)))
      (let loop ((i 0))
        (if (< i len)
            (let ((n (deserialize-nonneg-fixnum! 0 0)))
              (if (<= n (max-char))
                  (begin
                    (string-set! obj i (integer->char n))
                    (loop (+ i 1)))
                  (err)))
            obj))))

  (define (deserialize-vector-like! subtype x)
    (let* ((len (bitwise-and x #x0f)))
      (if (< len #x0f)
          (deserialize-vector-like-fill! subtype len)
          (deserialize-vector-like-long! subtype))))

  (define (deserialize-vector-like-long! subtype)
    (let ((len (deserialize-nonneg-fixnum! 0 0)))
      (deserialize-vector-like-fill! subtype len)))

  (define (deserialize-vector-like-fill! subtype len)
    (let ((obj (make-vector len)))
      (alloc! obj)
      (let loop ((i 0))
        (if (< i len)
            (begin
              (vector-set! obj i (deserialize!))
              (loop (+ i 1)))
            (begin
              (subtype-set! obj subtype)
              obj)))))

  (define (deserialize-homintvector! make-vect vect-set! elem-len signed? len)
    (let ((obj (make-vect len)))
      (let loop ((i 0))
        (if (< i len)
            (begin
              (vect-set!
               obj
               i
               (if signed?
                   (deserialize-exact-int-of-length! elem-len)
                   (deserialize-nonneg-exact-int-of-length! elem-len)))
              (loop (+ i 1)))
            (begin
              (alloc! obj)
              obj)))))

  (define (deserialize-homfloatvector! make-vect vect-set! len f32?)
    (let ((obj (make-vect len)))
      (let loop ((i 0))
        (if (< i len)
            (begin
              (vect-set!
               obj
               i
               (if f32?
                   (deserialize-flonum-32!)
                   (deserialize-flonum-64!)))
              (loop (+ i 1)))
            (begin
              (alloc! obj)
              obj)))))

  (define (deserialize-subprocedure!)
    (let ((x (read-u8)))
      (if (>= x (shared-tag))
          (shared-ref
           (deserialize-nonneg-fixnum! (bitwise-and x #x7f) 7))
          (let ((subproc-id
                 (let ((id (bitwise-and x #x7f)))
                   (if (< id #x7f)
                       id
                       (deserialize-nonneg-fixnum! 0 0)))))
            (deserialize-subprocedure-with-id! subproc-id)))))

  (define (deserialize-subprocedure-with-id! subproc-id)
    (let ((v (deserialize!)))
      (if (not (eq? v (##system-version)))
          (err)
          (let* ((x
                  (read-u8))
                 (parent-name
                  (if (>= x (shared-tag))
                      (let ((name
                             (shared-ref
                              (deserialize-nonneg-fixnum!
                               (bitwise-and x #x7f)
                               7))))
                        (if (not (symbol? name))
                            (err)
                            name))
                      (let ((name
                             (string->symbol (deserialize-string! x #x7f))))
                        (alloc! name)
                        name)))
                 (parent
                  (##global-var-primitive-ref
                   (##make-global-var parent-name))))
            (if (not (procedure? parent)) ;; should also check subproc-id
                (err)
                (let ((obj (##make-subprocedure parent subproc-id)))
                  (alloc! obj)
                  obj))))))

  (define (create-global-var-if-needed sym)
    (let ((x (read-u8)))
      (if (= x 1)
          (##make-global-var sym))))

  (define (deserialize-without-transform!)
    (let ((x (read-u8)))

      (cond ((>= x (shared-tag))
             (shared-ref
              (deserialize-nonneg-fixnum! (bitwise-and x #x7f) 7)))

            ((>= x (false-tag))
             (cond ((= x (false-tag))
                    #f)

                   ((= x (true-tag))
                    #t)

                   ((= x (nil-tag))
                    '())

                   ((= x (eof-tag))
                    #!eof)

                   ((= x (void-tag))
                    #!void)

                   ((= x (absent-tag))
                    (macro-absent-obj))

                   ((= x (unbound-tag))
                    #!unbound)

                   ((= x (unbound2-tag))
                    #!unbound2)

                   ((= x (optional-tag))
                    #!optional)

                   ((= x (key-tag))
                    #!key)

                   ((= x (rest-tag))
                    #!rest)

                   ((= x (unused-tag))
                    (macro-unused-obj))

                   ((= x (deleted-tag))
                    (macro-deleted-obj))

                   (else
                    (err))))

            ((>= x (character-tag))
             (cond ((= x (character-tag))
                    (let ((n (deserialize-nonneg-fixnum! 0 0)))
                      (if (<= n (max-char))
                          (integer->char n)
                          (err))))

                   ((= x (flonum-tag))
                    (let ((obj (deserialize-flonum-64!)))
                      (alloc! obj)
                      obj))

                   ((= x (ratnum-tag))
                    (let* ((num (deserialize!))
                           (den (deserialize!)))
                      (if (or (and (fixnum? den)
                                   (<= den 1))
                              (and (bignum? den)
                                   (generic.negative? den))
                              (not (eq? 1 (generic.gcd num den))))
                          (err)
                          (let ((obj (macro-ratnum-make num den)))
                            (alloc! obj)
                            obj))))

                   ((= x (cpxnum-tag))
                    (let* ((real (deserialize!))
                           (imag (deserialize!)))
                      (if (or (not (real? real))
                              (not (real? imag)))
                          (err)
                          (let ((obj (macro-cpxnum-make real imag)))
                            (alloc! obj)
                            obj))))

                   ((= x (pair-tag))
                    (let ((obj (cons #f #f)))
                      (alloc! obj)
                      (let* ((a (deserialize!))
                             (d (deserialize!)))
                        (set-car! obj a)
                        (set-cdr! obj d)
                        obj)))

                   ((= x (continuation-tag))
                    (let ((obj (vector #f #f)))
                      (alloc! obj)
                      (let* ((frame (deserialize!))
                             (denv (deserialize!)))
                        (if (not (frame? frame)) ;; should also check denv
                            (err)
                            (begin
                              (vector-set! obj 0 frame)
                              (vector-set! obj 1 denv)
                              (subtype-set! obj (macro-subtype-continuation))
                              obj)))))

                   ((= x (boxvalues-tag))
                    (deserialize-vector-like-long!
                     (macro-subtype-boxvalues)))

                   ((= x (ui-symbol-tag))
                    (let* ((y (read-u8))
                           (name (deserialize-string! y #xff))
                           (hash (deserialize-exact-int-of-length! 4))
                           (obj (macro-make-uninterned-symbol name hash)))
                      (create-global-var-if-needed obj)
                      (alloc! obj)
                      obj))

                   ((= x (keyword-tag))
                    (let* ((name (deserialize-string! 0 0))
                           (obj (string->keyword name)))
                      (alloc! obj)
                      obj))

                   ((= x (ui-keyword-tag))
                    (let* ((y (read-u8))
                           (name (deserialize-string! y #xff))
                           (hash (deserialize-exact-int-of-length! 4))
                           (obj (macro-make-uninterned-keyword name hash)))
                      (alloc! obj)
                      obj))

                   ((= x (closure-tag))
                    (let ((subproc (deserialize-subprocedure!)))
                      (if #f;;;;;;;not subprocedure
                          (err)
                          (let ((nb-closed
                                 (subprocedure-nb-closed subproc)))
                            (if #f;;;;; nb-closed = 0
                                (err)
                                (let ((obj (make-vector (+ nb-closed 1))))
                                  (vector-set! obj 0 subproc)
                                  (alloc! obj)
                                  (let loop ((i 1))
                                    (if (<= i nb-closed)
                                        (begin
                                          (vector-set! obj i (deserialize!))
                                          (loop (+ i 1)))
                                        (begin
                                          (subtype-set!
                                           obj
                                           (macro-subtype-procedure))
                                          obj)))))))))

                   ((= x (frame-tag))
                    (let ((subproc (deserialize-subprocedure!)))
                      (if (not (##return? subproc))
                          (err)
                          (let* ((fs (##return-fs subproc))
                                 (obj (make-vector (+ fs 1))))
                            (vector-set! obj 0 subproc)
                            (alloc! obj)
                            (let loop ((i 1))
                              (if (<= i fs)
                                  (begin
                                    (vector-set!
                                     obj
                                     (+ (- fs i) 1)
                                     (if (frame-slot-live? obj i)
                                         (deserialize!)
                                         0))
                                    (loop (+ i 1)))
                                  (begin
                                    (subtype-set! obj (macro-subtype-frame))
                                    obj)))))))

                   ((= x (gchashtable-tag))
                    (let* ((len (deserialize-nonneg-fixnum! 0 0))
                           (flags (deserialize-nonneg-fixnum! 0 0))
                           (count (deserialize-nonneg-fixnum! 0 0))
                           (min-count (deserialize-nonneg-fixnum! 0 0))
                           (free (deserialize-nonneg-fixnum! 0 0)))
                      (if #f;;;;;;;;parameters OK?
                          (err)
                          (let ((obj (make-vector len (macro-unused-obj))))
                            (alloc! obj)
                            (macro-gc-hash-table-flags-set!
                             obj
                             (bitwise-ior ;; force rehash at next access!
                              flags
                              (macro-gc-hash-table-flag-need-rehash)))
                            (macro-gc-hash-table-count-set! obj count)
                            (macro-gc-hash-table-min-count-set! obj min-count)
                            (macro-gc-hash-table-free-set! obj free)
                            (let loop ((i (macro-gc-hash-table-key0)))
                              (if (< i (vector-length obj))
                                  (let ((key (deserialize!)))
                                    (if (not (eq? key (macro-unused-obj)))
                                        (let ((val (deserialize!)))
                                          (vector-set! obj i key)
                                          (vector-set! obj (+ i 1) val)
                                          (loop (+ i 2)))
                                        (begin
                                          (subtype-set!
                                           obj
                                           (macro-subtype-weak))
                                          obj)))
                                  (err)))))))

                   ((= x (meroon-tag))
                    (deserialize-vector-like-long!
                     (macro-subtype-meroon)))

                   ((= x (homvector-tag))
                    (let* ((len/type
                            (deserialize-nonneg-fixnum! 0 0))
                           (len
                            (arithmetic-shift-right len/type 4))
                           (type
                            (bitwise-and len/type #x0f)))
                      (cond ((= type (s8vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-s8vector n))
                              (lambda (v i n) (s8vector-set! v i n))
                              1
                              #t
                              len))
                            ((= type (u8vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-u8vector n))
                              (lambda (v i n) (u8vector-set! v i n))
                              1
                              #f
                              len))
                            ((= type (s16vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-s16vector n))
                              (lambda (v i n) (s16vector-set! v i n))
                              2
                              #t
                              len))
                            ((= type (u16vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-u16vector n))
                              (lambda (v i n) (u16vector-set! v i n))
                              2
                              #f
                              len))
                            ((= type (s32vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-s32vector n))
                              (lambda (v i n) (s32vector-set! v i n))
                              4
                              #t
                              len))
                            ((= type (u32vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-u32vector n))
                              (lambda (v i n) (u32vector-set! v i n))
                              4
                              #f
                              len))
                            ((= type (s64vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-s64vector n))
                              (lambda (v i n) (s64vector-set! v i n))
                              8
                              #t
                              len))
                            ((= type (u64vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-u64vector n))
                              (lambda (v i n) (u64vector-set! v i n))
                              8
                              #f
                              len))
                            ((= type (f32vector-tag))
                             (deserialize-homfloatvector!
                              (lambda (n) (make-f32vector n))
                              (lambda (v i n) (f32vector-set! v i n))
                              len
                              #t))
                            ((= type (f64vector-tag))
                             (deserialize-homfloatvector!
                              (lambda (n) (make-f64vector n))
                              (lambda (v i n) (f64vector-set! v i n))
                              len
                              #f))
                            (else
                             (err)))))

                   (else
                    (err))))

            ((>= x (exact-int-tag))
             (let ((lo (bitwise-and x #x0f)))
               (if (< lo #x0b)
                   lo
                   (let* ((len
                           (if (= lo #x0f)
                               (deserialize-nonneg-fixnum! 0 0)
                               (- #x0f lo)))
                          (n
                           (deserialize-exact-int-of-length! len)))
                     (if (= lo #x0e)
                         n
                         (begin
                           (alloc! n)
                           n))))))

            ((>= x (subprocedure-tag))
             (let ((subproc-id
                    (let ((id (bitwise-and x #x0f)))
                      (if (< id #x0f)
                          id
                          (deserialize-nonneg-fixnum! 0 0)))))
               (deserialize-subprocedure-with-id! subproc-id)))

            ((>= x (structure-tag))
             (deserialize-vector-like!
              (macro-subtype-structure)
              x))

            ((>= x (vector-tag))
             (deserialize-vector-like!
              (macro-subtype-vector)
              x))

            ((>= x (string-tag))
             (let ((obj (deserialize-string! x #x0f)))
               (alloc! obj)
               obj))

            (else ;; symbol-tag
             (let* ((name (deserialize-string! x #x0f))
                    (obj (string->symbol name)))
               (create-global-var-if-needed obj)
               (alloc! obj)
               obj)))))

  (define (deserialize!)
    (let* ((obj (deserialize-without-transform!))
           (transform (vector-ref state 4)))
      (transform obj)))

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

;;;============================================================================

;;; Termite specific serialization/deserialization.

(define-prim (##obj->u8vector obj)

(##define-macro (subtype-set! obj subtype)
  `(##subtype-set! ,obj ,subtype))

(##define-macro (subvector-move! src-vect src-start src-end dst-vect dst-start)
  `(##subvector-move! ,src-vect ,src-start ,src-end ,dst-vect ,dst-start))

(##define-macro (max-fixnum)
  `##max-fixnum)

(##define-macro (max-char)
  `##max-char)


(##define-macro (continuation? obj)
  `(##continuation? ,obj))

(##define-macro (continuation-frame cont)
  `(##continuation-frame ,cont))

(##define-macro (continuation-denv cont)
  `(##continuation-denv ,cont))

(##define-macro (frame? obj)
  `(##frame? ,obj))

(##define-macro (frame-fs frame)
  `(##frame-fs ,frame))

(##define-macro (frame-ret frame)
  `(##frame-ret ,frame))

(##define-macro (frame-ref frame i)
  `(##frame-ref ,frame ,i))

(##define-macro (frame-slot-live? frame i)
  `(##frame-slot-live? ,frame ,i))

(##define-macro (subprocedure-parent-name subproc)
  `(##subprocedure-parent-name ,subproc))

(##define-macro (subprocedure-id subproc)
  `(##subprocedure-id ,subproc))

(##define-macro (subprocedure-nb-closed subproc)
  `(##subprocedure-nb-closed ,subproc))

(##define-macro (closure? obj)
  `(##closure? ,obj))

(##define-macro (closure-code closure)
  `(##closure-code ,closure))

(##define-macro (closure-ref closure i)
  `(##closure-ref ,closure ,i))

(##define-macro (extract-bit-field size position n)
  `(##extract-bit-field ,size ,position ,n))

(##define-macro (bignum? obj)
  `(##bignum? ,obj))

(##define-macro (subtyped? obj)
  `(##subtyped? ,obj))

(##define-macro (flonum? obj)
  `(##flonum? ,obj))

(##define-macro (ratnum? obj)
  `(##ratnum? ,obj))

(##define-macro (cpxnum? obj)
  `(##cpxnum? ,obj))

(##define-macro (boxvalues? obj)
  `(##fixnum.= (##subtype ,obj) (macro-subtype-boxvalues)))


(##define-macro (make-string . args)
  `(##make-string ,@args))

(##define-macro (string? . args)
  `(##string? ,@args))

(##define-macro (string-length str)
  `(##string-length ,str))

(##define-macro (string-ref str i)
  `(##string-ref ,str ,i))

(##define-macro (string-set! str i x)
  `(##string-set! ,str ,i ,x))


(##define-macro (make-vector . args)
  `(##make-vector ,@args))

(##define-macro (vector? . args)
  `(##vector? ,@args))

(##define-macro (vector-length vect)
  `(##vector-length ,vect))

(##define-macro (vector-ref vect i)
  `(##vector-ref ,vect ,i))

(##define-macro (vector-set! vect i x)
  `(##vector-set! ,vect ,i ,x))


(##define-macro (make-s8vector . args)
  `(##make-s8vector ,@args))

(##define-macro (s8vector? . args)
  `(##s8vector? ,@args))

(##define-macro (s8vector-length s8vect)
  `(##s8vector-length ,s8vect))

(##define-macro (s8vector-ref s8vect i)
  `(##s8vector-ref ,s8vect ,i))

(##define-macro (s8vector-set! s8vect i x)
  `(##s8vector-set! ,s8vect ,i ,x))

(##define-macro (s8vector-shrink! s8vect len)
  `(##s8vector-shrink! ,s8vect ,len))

(##define-macro (make-u8vector . args)
  `(##make-u8vector ,@args))

(##define-macro (u8vector? . args)
  `(##u8vector? ,@args))

(##define-macro (u8vector-length u8vect)
  `(##u8vector-length ,u8vect))

(##define-macro (u8vector-ref u8vect i)
  `(##u8vector-ref ,u8vect ,i))

(##define-macro (u8vector-set! u8vect i x)
  `(##u8vector-set! ,u8vect ,i ,x))

(##define-macro (u8vector-shrink! u8vect len)
  `(##u8vector-shrink! ,u8vect ,len))

(##define-macro (fifo->u8vector fifo start end)
  `(##fifo->u8vector ,fifo ,start ,end))


(##define-macro (make-s16vector . args)
  `(##make-s16vector ,@args))

(##define-macro (s16vector? . args)
  `(##s16vector? ,@args))

(##define-macro (s16vector-length s16vect)
  `(##s16vector-length ,s16vect))

(##define-macro (s16vector-ref s16vect i)
  `(##s16vector-ref ,s16vect ,i))

(##define-macro (s16vector-set! s16vect i x)
  `(##s16vector-set! ,s16vect ,i ,x))

(##define-macro (s16vector-shrink! s16vect len)
  `(##s16vector-shrink! ,s16vect ,len))

(##define-macro (make-u16vector . args)
  `(##make-u16vector ,@args))

(##define-macro (u16vector? . args)
  `(##u16vector? ,@args))

(##define-macro (u16vector-length u16vect)
  `(##u16vector-length ,u16vect))

(##define-macro (u16vector-ref u16vect i)
  `(##u16vector-ref ,u16vect ,i))

(##define-macro (u16vector-set! u16vect i x)
  `(##u16vector-set! ,u16vect ,i ,x))

(##define-macro (u16vector-shrink! u16vect len)
  `(##u16vector-shrink! ,u16vect ,len))


(##define-macro (make-s32vector . args)
  `(##make-s32vector ,@args))

(##define-macro (s32vector? . args)
  `(##s32vector? ,@args))

(##define-macro (s32vector-length s32vect)
  `(##s32vector-length ,s32vect))

(##define-macro (s32vector-ref s32vect i)
  `(##s32vector-ref ,s32vect ,i))

(##define-macro (s32vector-set! s32vect i x)
  `(##s32vector-set! ,s32vect ,i ,x))

(##define-macro (s32vector-shrink! s32vect len)
  `(##s32vector-shrink! ,s32vect ,len))

(##define-macro (make-u32vector . args)
  `(##make-u32vector ,@args))

(##define-macro (u32vector? . args)
  `(##u32vector? ,@args))

(##define-macro (u32vector-length u32vect)
  `(##u32vector-length ,u32vect))

(##define-macro (u32vector-ref u32vect i)
  `(##u32vector-ref ,u32vect ,i))

(##define-macro (u32vector-set! u32vect i x)
  `(##u32vector-set! ,u32vect ,i ,x))

(##define-macro (u32vector-shrink! u32vect len)
  `(##u32vector-shrink! ,u32vect ,len))


(##define-macro (make-s64vector . args)
  `(##make-s64vector ,@args))

(##define-macro (s64vector? . args)
  `(##s64vector? ,@args))

(##define-macro (s64vector-length s64vect)
  `(##s64vector-length ,s64vect))

(##define-macro (s64vector-ref s64vect i)
  `(##s64vector-ref ,s64vect ,i))

(##define-macro (s64vector-set! s64vect i x)
  `(##s64vector-set! ,s64vect ,i ,x))

(##define-macro (s64vector-shrink! s64vect len)
  `(##s64vector-shrink! ,s64vect ,len))

(##define-macro (make-u64vector . args)
  `(##make-u64vector ,@args))

(##define-macro (u64vector? . args)
  `(##u64vector? ,@args))

(##define-macro (u64vector-length u64vect)
  `(##u64vector-length ,u64vect))

(##define-macro (u64vector-ref u64vect i)
  `(##u64vector-ref ,u64vect ,i))

(##define-macro (u64vector-set! u64vect i x)
  `(##u64vector-set! ,u64vect ,i ,x))

(##define-macro (u64vector-shrink! u64vect len)
  `(##u64vector-shrink! ,u64vect ,len))


(##define-macro (make-f32vector . args)
  `(##make-f32vector ,@args))

(##define-macro (f32vector? . args)
  `(##f32vector? ,@args))

(##define-macro (f32vector-length f32vect)
  `(##f32vector-length ,f32vect))

(##define-macro (f32vector-ref f32vect i)
  `(##f32vector-ref ,f32vect ,i))

(##define-macro (f32vector-set! f32vect i x)
  `(##f32vector-set! ,f32vect ,i ,x))

(##define-macro (f32vector-shrink! f32vect len)
  `(##f32vector-shrink! ,f32vect ,len))

(##define-macro (make-f64vector . args)
  `(##make-f64vector ,@args))

(##define-macro (f64vector? . args)
  `(##f64vector? ,@args))

(##define-macro (f64vector-length f64vect)
  `(##f64vector-length ,f64vect))

(##define-macro (f64vector-ref f64vect i)
  `(##f64vector-ref ,f64vect ,i))

(##define-macro (f64vector-set! f64vect i x)
  `(##f64vector-set! ,f64vect ,i ,x))

(##define-macro (f64vector-shrink! f64vect len)
  `(##f64vector-shrink! ,f64vect ,len))


(##define-macro (symbol? . args)
  `(##symbol? ,@args))

(##define-macro (symbol->string . args)
  `(##symbol->string ,@args))

(##define-macro (string->symbol . args)
  `(##string->symbol ,@args))

(##define-macro (keyword? . args)
  `(##keyword? ,@args))

(##define-macro (keyword->string . args)
  `(##keyword->string ,@args))

(##define-macro (string->keyword . args)
  `(##string->keyword ,@args))


(##define-macro (+ . args)
  `(##fixnum.+ ,@args))

(##define-macro (- . args)
  `(##fixnum.- ,@args))

(##define-macro (* . args)
  `(##fixnum.* ,@args))

(##define-macro (< . args)
  `(##fixnum.< ,@args))

(##define-macro (> . args)
  `(##fixnum.> ,@args))

(##define-macro (= . args)
  `(##fixnum.= ,@args))

(##define-macro (>= . args)
  `(##fixnum.>= ,@args))

(##define-macro (<= . args)
  `(##fixnum.<= ,@args))

(##define-macro (bitwise-and . args)
  `(##fixnum.bitwise-and ,@args))

(##define-macro (bitwise-ior . args)
  `(##fixnum.bitwise-ior ,@args))

(##define-macro (arithmetic-shift-left . args)
  `(##fixnum.arithmetic-shift-left ,@args))

(##define-macro (arithmetic-shift-right . args)
  `(##fixnum.arithmetic-shift-right ,@args))

(##define-macro (generic.+ . args)
  `(##+ ,@args))

(##define-macro (generic.arithmetic-shift . args)
  `(##arithmetic-shift ,@args))

(##define-macro (generic.bit-set? . args)
  `(##bit-set? ,@args))

(##define-macro (generic.bitwise-ior . args)
  `(##bitwise-ior ,@args))

(##define-macro (generic.extract-bit-field . args)
  `(##extract-bit-field ,@args))

(##define-macro (generic.gcd . args)
  `(##gcd ,@args))

(##define-macro (generic.negative? . args)
  `(##negative? ,@args))

(##define-macro (integer-length . args)
  `(##integer-length ,@args))

(##define-macro (make-table . args)
  `(##make-table-aux 0 #f #f #f ##eq?))

(##define-macro (table-ref . args)
  `(##table-ref ,@args))

(##define-macro (table-set! . args)
  `(##table-set! ,@args))

(##define-macro (uninterned-keyword? . args)
  `(##uninterned-keyword? ,@args))

(##define-macro (uninterned-symbol? . args)
  `(##uninterned-symbol? ,@args))


(##define-macro (char->integer . args)
  `(##fixnum.<-char ,@args))

(##define-macro (integer->char . args)
  `(##fixnum.->char ,@args))


(##define-macro (vector . args)
  `(##vector ,@args))


(##define-macro (cons . args)
  `(##cons ,@args))

(##define-macro (pair? . args)
  `(##pair? ,@args))

(##define-macro (car . args)
  `(##car ,@args))

(##define-macro (cdr . args)
  `(##cdr ,@args))

(##define-macro (set-car! . args)
  `(##set-car! ,@args))

(##define-macro (set-cdr! . args)
  `(##set-cdr! ,@args))


(##define-macro (procedure? . args)
  `(##procedure? ,@args))

(##define-macro (char? . args)
  `(##char? ,@args))

(##define-macro (real? . args)
  `(##real? ,@args))

(##define-macro (not . args)
  `(##not ,@args))

(##define-macro (eq? . args)
  `(##eq? ,@args))

  (define (cannot-serialize obj)
    (error "can't serialize" obj))

  (define chunk-len 256) ;; must be a power of 2

  (define state
    (vector 0
            (macro-make-fifo)
            0
            (make-table test: ##eq?)))

  (define (write-u8 x)
    (let ((ptr (vector-ref state 0)))
      (vector-set! state 0 (+ ptr 1))
      (let ((fifo (vector-ref state 1))
            (i (bitwise-and ptr (- chunk-len 1))))
        (u8vector-set!
         (if (= i 0)
             (let ((chunk (make-u8vector chunk-len)))
               (macro-fifo-insert-at-tail! fifo chunk)
               chunk)
             (macro-fifo-elem (macro-fifo-tail fifo)))
         i
         x))))

  (define (get-output-u8vector)
    (let ((ptr (vector-ref state 0))
          (fifo (vector-ref state 1)))
      (if (and (< 0 ptr) (<= ptr chunk-len))
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
      (vector-set! state 2 (+ n 1))
      (table-set! (vector-ref state 3) obj n)))

  (define (serialize-shared! n)
    (let ((lo (bitwise-and n #x7f))
          (hi (arithmetic-shift-right n 7)))
      (write-u8 (bitwise-ior (shared-tag) lo))
      (serialize-nonneg-fixnum! hi)))

  (define (serialize-nonneg-fixnum! n)
    (let ((lo (bitwise-and n #x7f))
          (hi (arithmetic-shift-right n 7)))
      (if (= hi 0)
          (write-u8 lo)
          (begin
            (write-u8 (bitwise-ior #x80 lo))
            (serialize-nonneg-fixnum! hi)))))

  (define (serialize-flonum-32! n)
    (serialize-exact-int-of-length!
     (##flonum.->ieee754-32 n)
     4))

  (define (serialize-flonum-64! n)
    (serialize-exact-int-of-length!
     (##flonum.->ieee754-64 n)
     8))

  (define (serialize-exact-int-of-length! n len)
    (if (fixnum? n)
        (let loop ((n n) (len len))
          (if (> len 0)
              (begin
                (write-u8 (bitwise-and n #xff))
                (loop (arithmetic-shift-right n 8) (- len 1)))))
        (let* ((len/2 (arithmetic-shift-right len 1))
               (len/2*8 (* len/2 8)))
          (serialize-exact-int-of-length!
           (generic.extract-bit-field len/2*8 0 n)
           len/2)
          (serialize-exact-int-of-length!
           (generic.arithmetic-shift n (- len/2*8))
           (- len len/2)))))

  (define (exact-int-length n signed?)
    (arithmetic-shift-right
     (+ (integer-length n) (if signed? 8 7))
     3))

  (define (serialize-exact-int! n)
    (or (share n)
        (let ((len (exact-int-length n #t)))
          (if (<= len 4)
              (write-u8 (bitwise-ior (exact-int-tag) (- #x0f len)))
              (begin
                (write-u8 (bitwise-ior (exact-int-tag) #x0f))
                (serialize-nonneg-fixnum! len)))
          (serialize-exact-int-of-length! n len)
          (alloc! n))))

  (define (serialize-vector-like! vect tag)
    (let ((len (vector-length vect)))
      (if (< len #x0f)
          (begin
            (write-u8 (bitwise-ior tag len))
            (serialize-subvector! vect 0 len))
          (serialize-vector-like-long! vect (bitwise-ior tag #x0f)))))

  (define (serialize-vector-like-long! vect tag)
    (let ((len (vector-length vect)))
      (write-u8 tag)
      (serialize-nonneg-fixnum! len)
      (serialize-subvector! vect 0 len)))

  (define (serialize-subvector! vect start end)
    (let loop ((i start))
      (if (< i end)
          (begin
            (serialize! (vector-ref vect i))
            (loop (+ i 1))))))

  (define (serialize-string-like! str tag mask)
    (let ((len (string-length str)))
      (if (< len mask)
          (begin
            (write-u8 (bitwise-ior tag len))
            (serialize-string! str))
          (begin
            (write-u8 (bitwise-ior tag mask))
            (serialize-nonneg-fixnum! len)
            (serialize-string! str)))))

  (define (serialize-string! str)
    (serialize-elements!
     0
     (string-length str)
     (lambda (i)
       (serialize-nonneg-fixnum! (char->integer (string-ref str i))))))

  (define (serialize-elements! start end serialize-element!)
    (let loop ((i start))
      (if (< i end)
          (begin
            (serialize-element! i)
            (loop (+ i 1))))))

  (define (serialize-homintvector! vect vect-tag vect-length vect-ref elem-len)
    (or (share vect)
        (let ((len (vect-length vect)))
          (write-u8 (homvector-tag))
          (serialize-nonneg-fixnum!
           (bitwise-ior vect-tag (arithmetic-shift-left len 4)))
          (serialize-elements!
           0
           len
           (lambda (i)
             (serialize-exact-int-of-length!
              (vect-ref vect i)
              elem-len)))
          (alloc! vect))))

  (define (serialize-homfloatvector! vect vect-tag vect-length vect-ref f32?)
    (or (share vect)
        (let ((len (vect-length vect)))
          (write-u8 (homvector-tag))
          (serialize-nonneg-fixnum!
           (bitwise-ior vect-tag (arithmetic-shift-left len 4)))
          (serialize-elements!
           0
           len
           (lambda (i)
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
                (if (< subproc-id mask)
                    (write-u8 (bitwise-ior tag subproc-id))
                    (begin
                      (write-u8 (bitwise-ior tag mask))
                      (serialize-nonneg-fixnum! subproc-id)))
                (serialize! (##system-version))
                (or (share parent-name)
                    (let ((str (symbol->string parent-name)))
                      (serialize-string-like! str 0 #x7f)
                      (alloc! parent-name)))
                (alloc! subproc))))))

  (define (serialize! obj)
    (let ((obj (serialize-hook obj)))
      (cond ((subtyped? obj)

             (cond ((symbol? obj)
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
                          (serialize-vector-like! obj (vector-tag)))))

                   ((structure? obj)
                    (if (or (macro-thread? obj)
                            (macro-tgroup? obj)
                            (macro-mutex? obj)
                            (macro-condvar? obj))
                      (cannot-serialize obj)
                      (or (share obj)
                          (begin
                            (alloc! obj)
                            (serialize-vector-like! obj (structure-tag))))))

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
                                (serialize-subvector! obj 1 (+ nb-closed 1)))))

                        (serialize-subprocedure! obj (subprocedure-tag) #x0f)))

                   ((flonum? obj)
                    (or (share obj)
                        (begin
                          (write-u8 (flonum-tag))
                          (serialize-flonum-64! obj)
                          (alloc! obj))))

                   ((bignum? obj)
                    (serialize-exact-int! obj))

                   ((ratnum? obj)
                    (or (share obj)
                        (begin
                          (write-u8 (ratnum-tag))
                          (serialize! (macro-ratnum-numerator obj))
                          (serialize! (macro-ratnum-denominator obj))
                          (alloc! obj))))

                   ((cpxnum? obj)
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
                        (let ((subproc (##continuation-ret cont))
                              (fs (##continuation-fs cont)))
                          (serialize-subprocedure! subproc 0 #x7f)
                          (alloc! (##cons 11 22))
                          (let loop ((i fs))
                            (if (##fixnum.> i 0)
                                (begin
                                  (serialize-cont-frame-ref! cont i)
                                  (loop (##fixnum.- i 1)))))))

                      (define (serialize-cont-frame-ref! cont i)
                        (let* ((fs (##continuation-fs cont))
                               (j (##fixnum.+ (##fixnum.- fs i) 1)))
                          (if (##continuation-slot-live? cont j)
                              (if (##fixnum.= j (##continuation-link cont))
                                  (let ((next (##continuation-next cont)))
                                    (if next
                                        (serialize-cont-frame! next)
                                        (serialize! 0)))
                                  (serialize! (##continuation-ref cont j))))))

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
                              (if (<= i fs)
                                  (begin
                                    (if (frame-slot-live? obj i)
                                        (serialize! (frame-ref obj i)))
                                    (loop (+ i 1)))))))))

                   ((boxvalues? obj)
                    (or (share obj)
                        (begin
                          (alloc! obj)
                          (serialize-vector-like-long! obj (boxvalues-tag)))))

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
                              (if (< i (vector-length obj))
                                  (let ((key (vector-ref obj i)))
                                    (if (and (not (eq? key (macro-unused-obj)))
                                             (not (eq? key (macro-deleted-obj))))
                                        (let ((val (vector-ref obj (+ i 1))))
                                          (serialize! key)
                                          (serialize! val)))
                                    (let ()
                                      (##declare (interrupts-enabled))
                                      (loop (+ i 2))))
                                  (serialize! (macro-unused-obj))))))))

                   ((s8vector? obj)
                    (serialize-homintvector!
                     obj
                     (s8vector-tag)
                     (lambda (v) (s8vector-length v))
                     (lambda (v i) (s8vector-ref v i))
                     1))

                   ((u8vector? obj)
                    (serialize-homintvector!
                     obj
                     (u8vector-tag)
                     (lambda (v) (u8vector-length v))
                     (lambda (v i) (u8vector-ref v i))
                     1))

                   ((s16vector? obj)
                    (serialize-homintvector!
                     obj
                     (s16vector-tag)
                     (lambda (v) (s16vector-length v))
                     (lambda (v i) (s16vector-ref v i))
                     2))

                   ((u16vector? obj)
                    (serialize-homintvector!
                     obj
                     (u16vector-tag)
                     (lambda (v) (u16vector-length v))
                     (lambda (v i) (u16vector-ref v i))
                     2))

                   ((s32vector? obj)
                    (serialize-homintvector!
                     obj
                     (s32vector-tag)
                     (lambda (v) (s32vector-length v))
                     (lambda (v i) (s32vector-ref v i))
                     4))

                   ((u32vector? obj)
                    (serialize-homintvector!
                     obj
                     (u32vector-tag)
                     (lambda (v) (u32vector-length v))
                     (lambda (v i) (u32vector-ref v i))
                     4))

                   ((s64vector? obj)
                    (serialize-homintvector!
                     obj
                     (s64vector-tag)
                     (lambda (v) (s64vector-length v))
                     (lambda (v i) (s64vector-ref v i))
                     8))

                   ((u64vector? obj)
                    (serialize-homintvector!
                     obj
                     (u64vector-tag)
                     (lambda (v) (u64vector-length v))
                     (lambda (v i) (u64vector-ref v i))
                     8))

                   ((f32vector? obj)
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

                   (else
                    (cannot-serialize obj))))

            ((pair? obj)
             (or (share obj)
                 (begin
                   (alloc! obj)
                   (write-u8 (pair-tag))
                   (serialize! (car obj))
                   (serialize! (cdr obj)))))

            ((fixnum? obj)
             (cond ((and (>= obj #x00)
                         (< obj #x0b))
                    (write-u8 (bitwise-ior (exact-int-tag) obj)))
                   ((and (>= obj #x-80)
                         (< obj #x80))
                    (write-u8 (bitwise-ior (exact-int-tag) #x0e))
                    (write-u8 (bitwise-and obj #xff)))
                   (else
                    (serialize-exact-int! obj))))

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
            ((eq? obj (macro-unused-obj))  (write-u8 (unused-tag)))
            ((eq? obj (macro-deleted-obj)) (write-u8 (deleted-tag)))

            (else
             (cannot-serialize obj)))))

  (serialize! obj)

  (get-output-u8vector))

(define-prim (obj->u8vector obj)
  (macro-force-vars (obj)
    (##obj->u8vector obj)))

(define-prim (##u8vector->obj u8vect)

(##define-macro (subtype-set! obj subtype)
  `(##subtype-set! ,obj ,subtype))

(##define-macro (subvector-move! src-vect src-start src-end dst-vect dst-start)
  `(##subvector-move! ,src-vect ,src-start ,src-end ,dst-vect ,dst-start))

(##define-macro (max-fixnum)
  `##max-fixnum)

(##define-macro (max-char)
  `##max-char)


(##define-macro (continuation? obj)
  `(##continuation? ,obj))

(##define-macro (continuation-frame cont)
  `(##continuation-frame ,cont))

(##define-macro (continuation-denv cont)
  `(##continuation-denv ,cont))

(##define-macro (frame? obj)
  `(##frame? ,obj))

(##define-macro (frame-fs frame)
  `(##frame-fs ,frame))

(##define-macro (frame-ret frame)
  `(##frame-ret ,frame))

(##define-macro (frame-ref frame i)
  `(##frame-ref ,frame ,i))

(##define-macro (frame-slot-live? frame i)
  `(##frame-slot-live? ,frame ,i))

(##define-macro (subprocedure-parent-name subproc)
  `(##subprocedure-parent-name ,subproc))

(##define-macro (subprocedure-id subproc)
  `(##subprocedure-id ,subproc))

(##define-macro (subprocedure-nb-closed subproc)
  `(##subprocedure-nb-closed ,subproc))

(##define-macro (closure? obj)
  `(##closure? ,obj))

(##define-macro (closure-code closure)
  `(##closure-code ,closure))

(##define-macro (closure-ref closure i)
  `(##closure-ref ,closure ,i))

(##define-macro (extract-bit-field size position n)
  `(##extract-bit-field ,size ,position ,n))

(##define-macro (bignum? obj)
  `(##bignum? ,obj))

(##define-macro (subtyped? obj)
  `(##subtyped? ,obj))

(##define-macro (flonum? obj)
  `(##flonum? ,obj))

(##define-macro (ratnum? obj)
  `(##ratnum? ,obj))

(##define-macro (cpxnum? obj)
  `(##cpxnum? ,obj))

(##define-macro (boxvalues? obj)
  `(##fixnum.= (##subtype ,obj) (macro-subtype-boxvalues)))


(##define-macro (make-string . args)
  `(##make-string ,@args))

(##define-macro (string? . args)
  `(##string? ,@args))

(##define-macro (string-length str)
  `(##string-length ,str))

(##define-macro (string-ref str i)
  `(##string-ref ,str ,i))

(##define-macro (string-set! str i x)
  `(##string-set! ,str ,i ,x))


(##define-macro (make-vector . args)
  `(##make-vector ,@args))

(##define-macro (vector? . args)
  `(##vector? ,@args))

(##define-macro (vector-length vect)
  `(##vector-length ,vect))

(##define-macro (vector-ref vect i)
  `(##vector-ref ,vect ,i))

(##define-macro (vector-set! vect i x)
  `(##vector-set! ,vect ,i ,x))


(##define-macro (make-s8vector . args)
  `(##make-s8vector ,@args))

(##define-macro (s8vector? . args)
  `(##s8vector? ,@args))

(##define-macro (s8vector-length s8vect)
  `(##s8vector-length ,s8vect))

(##define-macro (s8vector-ref s8vect i)
  `(##s8vector-ref ,s8vect ,i))

(##define-macro (s8vector-set! s8vect i x)
  `(##s8vector-set! ,s8vect ,i ,x))

(##define-macro (s8vector-shrink! s8vect len)
  `(##s8vector-shrink! ,s8vect ,len))

(##define-macro (make-u8vector . args)
  `(##make-u8vector ,@args))

(##define-macro (u8vector? . args)
  `(##u8vector? ,@args))

(##define-macro (u8vector-length u8vect)
  `(##u8vector-length ,u8vect))

(##define-macro (u8vector-ref u8vect i)
  `(##u8vector-ref ,u8vect ,i))

(##define-macro (u8vector-set! u8vect i x)
  `(##u8vector-set! ,u8vect ,i ,x))

(##define-macro (u8vector-shrink! u8vect len)
  `(##u8vector-shrink! ,u8vect ,len))

(##define-macro (fifo->u8vector fifo start end)
  `(##fifo->u8vector ,fifo ,start ,end))


(##define-macro (make-s16vector . args)
  `(##make-s16vector ,@args))

(##define-macro (s16vector? . args)
  `(##s16vector? ,@args))

(##define-macro (s16vector-length s16vect)
  `(##s16vector-length ,s16vect))

(##define-macro (s16vector-ref s16vect i)
  `(##s16vector-ref ,s16vect ,i))

(##define-macro (s16vector-set! s16vect i x)
  `(##s16vector-set! ,s16vect ,i ,x))

(##define-macro (s16vector-shrink! s16vect len)
  `(##s16vector-shrink! ,s16vect ,len))

(##define-macro (make-u16vector . args)
  `(##make-u16vector ,@args))

(##define-macro (u16vector? . args)
  `(##u16vector? ,@args))

(##define-macro (u16vector-length u16vect)
  `(##u16vector-length ,u16vect))

(##define-macro (u16vector-ref u16vect i)
  `(##u16vector-ref ,u16vect ,i))

(##define-macro (u16vector-set! u16vect i x)
  `(##u16vector-set! ,u16vect ,i ,x))

(##define-macro (u16vector-shrink! u16vect len)
  `(##u16vector-shrink! ,u16vect ,len))


(##define-macro (make-s32vector . args)
  `(##make-s32vector ,@args))

(##define-macro (s32vector? . args)
  `(##s32vector? ,@args))

(##define-macro (s32vector-length s32vect)
  `(##s32vector-length ,s32vect))

(##define-macro (s32vector-ref s32vect i)
  `(##s32vector-ref ,s32vect ,i))

(##define-macro (s32vector-set! s32vect i x)
  `(##s32vector-set! ,s32vect ,i ,x))

(##define-macro (s32vector-shrink! s32vect len)
  `(##s32vector-shrink! ,s32vect ,len))

(##define-macro (make-u32vector . args)
  `(##make-u32vector ,@args))

(##define-macro (u32vector? . args)
  `(##u32vector? ,@args))

(##define-macro (u32vector-length u32vect)
  `(##u32vector-length ,u32vect))

(##define-macro (u32vector-ref u32vect i)
  `(##u32vector-ref ,u32vect ,i))

(##define-macro (u32vector-set! u32vect i x)
  `(##u32vector-set! ,u32vect ,i ,x))

(##define-macro (u32vector-shrink! u32vect len)
  `(##u32vector-shrink! ,u32vect ,len))


(##define-macro (make-s64vector . args)
  `(##make-s64vector ,@args))

(##define-macro (s64vector? . args)
  `(##s64vector? ,@args))

(##define-macro (s64vector-length s64vect)
  `(##s64vector-length ,s64vect))

(##define-macro (s64vector-ref s64vect i)
  `(##s64vector-ref ,s64vect ,i))

(##define-macro (s64vector-set! s64vect i x)
  `(##s64vector-set! ,s64vect ,i ,x))

(##define-macro (s64vector-shrink! s64vect len)
  `(##s64vector-shrink! ,s64vect ,len))

(##define-macro (make-u64vector . args)
  `(##make-u64vector ,@args))

(##define-macro (u64vector? . args)
  `(##u64vector? ,@args))

(##define-macro (u64vector-length u64vect)
  `(##u64vector-length ,u64vect))

(##define-macro (u64vector-ref u64vect i)
  `(##u64vector-ref ,u64vect ,i))

(##define-macro (u64vector-set! u64vect i x)
  `(##u64vector-set! ,u64vect ,i ,x))

(##define-macro (u64vector-shrink! u64vect len)
  `(##u64vector-shrink! ,u64vect ,len))


(##define-macro (make-f32vector . args)
  `(##make-f32vector ,@args))

(##define-macro (f32vector? . args)
  `(##f32vector? ,@args))

(##define-macro (f32vector-length f32vect)
  `(##f32vector-length ,f32vect))

(##define-macro (f32vector-ref f32vect i)
  `(##f32vector-ref ,f32vect ,i))

(##define-macro (f32vector-set! f32vect i x)
  `(##f32vector-set! ,f32vect ,i ,x))

(##define-macro (f32vector-shrink! f32vect len)
  `(##f32vector-shrink! ,f32vect ,len))

(##define-macro (make-f64vector . args)
  `(##make-f64vector ,@args))

(##define-macro (f64vector? . args)
  `(##f64vector? ,@args))

(##define-macro (f64vector-length f64vect)
  `(##f64vector-length ,f64vect))

(##define-macro (f64vector-ref f64vect i)
  `(##f64vector-ref ,f64vect ,i))

(##define-macro (f64vector-set! f64vect i x)
  `(##f64vector-set! ,f64vect ,i ,x))

(##define-macro (f64vector-shrink! f64vect len)
  `(##f64vector-shrink! ,f64vect ,len))


(##define-macro (symbol? . args)
  `(##symbol? ,@args))

(##define-macro (symbol->string . args)
  `(##symbol->string ,@args))

(##define-macro (string->symbol . args)
  `(##string->symbol ,@args))

(##define-macro (keyword? . args)
  `(##keyword? ,@args))

(##define-macro (keyword->string . args)
  `(##keyword->string ,@args))

(##define-macro (string->keyword . args)
  `(##string->keyword ,@args))


(##define-macro (+ . args)
  `(##fixnum.+ ,@args))

(##define-macro (- . args)
  `(##fixnum.- ,@args))

(##define-macro (* . args)
  `(##fixnum.* ,@args))

(##define-macro (< . args)
  `(##fixnum.< ,@args))

(##define-macro (> . args)
  `(##fixnum.> ,@args))

(##define-macro (= . args)
  `(##fixnum.= ,@args))

(##define-macro (>= . args)
  `(##fixnum.>= ,@args))

(##define-macro (<= . args)
  `(##fixnum.<= ,@args))

(##define-macro (bitwise-and . args)
  `(##fixnum.bitwise-and ,@args))

(##define-macro (bitwise-ior . args)
  `(##fixnum.bitwise-ior ,@args))

(##define-macro (arithmetic-shift-left . args)
  `(##fixnum.arithmetic-shift-left ,@args))

(##define-macro (arithmetic-shift-right . args)
  `(##fixnum.arithmetic-shift-right ,@args))

(##define-macro (generic.+ . args)
  `(##+ ,@args))

(##define-macro (generic.arithmetic-shift . args)
  `(##arithmetic-shift ,@args))

(##define-macro (generic.bit-set? . args)
  `(##bit-set? ,@args))

(##define-macro (generic.bitwise-ior . args)
  `(##bitwise-ior ,@args))

(##define-macro (generic.extract-bit-field . args)
  `(##extract-bit-field ,@args))

(##define-macro (generic.gcd . args)
  `(##gcd ,@args))

(##define-macro (generic.negative? . args)
  `(##negative? ,@args))

(##define-macro (integer-length . args)
  `(##integer-length ,@args))

(##define-macro (make-table . args)
  `(##make-table-aux 0 #f #f #f ##eq?))

(##define-macro (table-ref . args)
  `(##table-ref ,@args))

(##define-macro (table-set! . args)
  `(##table-set! ,@args))

(##define-macro (uninterned-keyword? . args)
  `(##uninterned-keyword? ,@args))

(##define-macro (uninterned-symbol? . args)
  `(##uninterned-symbol? ,@args))


(##define-macro (char->integer . args)
  `(##fixnum.<-char ,@args))

(##define-macro (integer->char . args)
  `(##fixnum.->char ,@args))


(##define-macro (vector . args)
  `(##vector ,@args))


(##define-macro (cons . args)
  `(##cons ,@args))

(##define-macro (pair? . args)
  `(##pair? ,@args))

(##define-macro (car . args)
  `(##car ,@args))

(##define-macro (cdr . args)
  `(##cdr ,@args))

(##define-macro (set-car! . args)
  `(##set-car! ,@args))

(##define-macro (set-cdr! . args)
  `(##set-cdr! ,@args))


(##define-macro (procedure? . args)
  `(##procedure? ,@args))

(##define-macro (char? . args)
  `(##char? ,@args))

(##define-macro (real? . args)
  `(##real? ,@args))

(##define-macro (not . args)
  `(##not ,@args))

(##define-macro (eq? . args)
  `(##eq? ,@args))

  (define (err)
    (error "deserialization error"))

  (define state
    (vector 0
            u8vect
            0
            (make-vector 64)))

  (define (read-u8)
    (let ((ptr (vector-ref state 0))
          (u8vect (vector-ref state 1)))
      (if (< ptr (u8vector-length u8vect))
          (begin
            (vector-set! state 0 (+ ptr 1))
            (u8vector-ref u8vect ptr))
          (err))))

  (define (eof?)
    (let ((ptr (vector-ref state 0))
          (u8vect (vector-ref state 1)))
      (= ptr (u8vector-length u8vect))))

  (define (alloc! obj)
    (let* ((n (vector-ref state 2))
           (vect (vector-ref state 3))
           (len (vector-length vect)))
      (vector-set! state 2 (+ n 1))
      (if (= n len)
          (let* ((new-len (+ (arithmetic-shift-right (* len 3) 1) 1))
                 (new-vect (make-vector new-len)))
            (vector-set! state 3 new-vect)
            (subvector-move! vect 0 n new-vect 0)
            (vector-set! new-vect n obj))
          (vector-set! vect n obj))
      n))

  (define (shared-ref i)
    (let* ((n (vector-ref state 2))
           (vect (vector-ref state 3)))
      (if (< i n)
          (vector-ref vect i)
          (err))))

  (define (deserialize-nonneg-fixnum! n shift)
    (let loop ((n n)
               (shift shift)
               (range (arithmetic-shift-right (max-fixnum) shift)))
      (if (= range 0)
          (err)
          (let ((x (read-u8)))
            (if (< x #x80)
                (if (< range x)
                    (err)
                    (bitwise-ior n (arithmetic-shift-left x shift)))
                (let ((b (bitwise-and x #x7f)))
                  (if (< range b)
                      (err)
                      (loop (bitwise-ior n (arithmetic-shift-left b shift))
                            (+ shift 7)
                            (arithmetic-shift-right range 7)))))))))

  (define (deserialize-flonum-32!)
    (let ((n (deserialize-nonneg-exact-int-of-length! 4)))
      (##flonum.<-ieee754-32 n)))

  (define (deserialize-flonum-64!)
    (let ((n (deserialize-nonneg-exact-int-of-length! 8)))
      (##flonum.<-ieee754-64 n)))

  (define (deserialize-nonneg-exact-int-of-length! len)
    (if (<= len 3) ;; result fits in a 32 bit fixnum?
        (let ((a (read-u8)))
          (if (= len 1)
              a
              (+ a
                 (arithmetic-shift-left
                  (let ((b (read-u8)))
                    (if (= len 2)
                        b
                        (+ b
                           (arithmetic-shift-left
                            (let ((c (read-u8)))
                              c)
                            8))))
                  8))))
        (let* ((len/2 (arithmetic-shift-right len 1))
               (a (deserialize-nonneg-exact-int-of-length! len/2))
               (b (deserialize-nonneg-exact-int-of-length! (- len len/2))))
          (generic.bitwise-ior a (generic.arithmetic-shift b (* 8 len/2))))))

  (define (deserialize-exact-int-of-length! len)
    (let ((n (deserialize-nonneg-exact-int-of-length! len)))
      (if (generic.bit-set? (- (* 8 len) 1) n)
          (generic.+ n (generic.arithmetic-shift -1 (* 8 len)))
          n)))

  (define (deserialize-string! x mask)
    (deserialize-string-of-length!
     (let ((lo (bitwise-and x mask)))
       (if (< lo mask)
           lo
           (deserialize-nonneg-fixnum! 0 0)))))

  (define (deserialize-string-of-length! len)
    (let ((obj (make-string len)))
      (let loop ((i 0))
        (if (< i len)
            (let ((n (deserialize-nonneg-fixnum! 0 0)))
              (if (<= n (max-char))
                  (begin
                    (string-set! obj i (integer->char n))
                    (loop (+ i 1)))
                  (err)))
            obj))))

  (define (deserialize-vector-like! subtype x)
    (let* ((len (bitwise-and x #x0f)))
      (if (< len #x0f)
          (deserialize-vector-like-fill! subtype len)
          (deserialize-vector-like-long! subtype))))

  (define (deserialize-vector-like-long! subtype)
    (let ((len (deserialize-nonneg-fixnum! 0 0)))
      (deserialize-vector-like-fill! subtype len)))

  (define (deserialize-vector-like-fill! subtype len)
    (let ((obj (make-vector len)))
      (alloc! obj)
      (let loop ((i 0))
        (if (< i len)
            (begin
              (vector-set! obj i (deserialize!))
              (loop (+ i 1)))
            (begin
              (subtype-set! obj subtype)
              obj)))))

  (define (deserialize-homintvector! make-vect vect-set! elem-len signed? len)
    (let ((obj (make-vect len)))
      (let loop ((i 0))
        (if (< i len)
            (begin
              (vect-set!
               obj
               i
               (if signed?
                   (deserialize-exact-int-of-length! elem-len)
                   (deserialize-nonneg-exact-int-of-length! elem-len)))
              (loop (+ i 1)))
            (begin
              (alloc! obj)
              obj)))))

  (define (deserialize-homfloatvector! make-vect vect-set! len f32?)
    (let ((obj (make-vect len)))
      (let loop ((i 0))
        (if (< i len)
            (begin
              (vect-set!
               obj
               i
               (if f32?
                   (deserialize-flonum-32!)
                   (deserialize-flonum-64!)))
              (loop (+ i 1)))
            (begin
              (alloc! obj)
              obj)))))

  (define (deserialize-subprocedure!)
    (let ((x (read-u8)))
      (if (>= x (shared-tag))
          (shared-ref
           (deserialize-nonneg-fixnum! (bitwise-and x #x7f) 7))
          (let ((subproc-id
                 (let ((id (bitwise-and x #x7f)))
                   (if (< id #x7f)
                       id
                       (deserialize-nonneg-fixnum! 0 0)))))
            (deserialize-subprocedure-with-id! subproc-id)))))

  (define (deserialize-subprocedure-with-id! subproc-id)
    (let ((v (deserialize!)))
      (if (not (eq? v (##system-version)))
          (err)
          (let* ((x
                  (read-u8))
                 (parent-name
                  (if (>= x (shared-tag))
                      (let ((name
                             (shared-ref
                              (deserialize-nonneg-fixnum!
                               (bitwise-and x #x7f)
                               7))))
                        (if (not (symbol? name))
                            (err)
                            name))
                      (let ((name
                             (string->symbol (deserialize-string! x #x7f))))
                        (alloc! name)
                        name)))
                 (parent
                  (##global-var-primitive-ref
                   (##make-global-var parent-name))))
            (if (not (procedure? parent)) ;; should also check subproc-id
                (err)
                (let ((obj (##make-subprocedure parent subproc-id)))
                  (alloc! obj)
                  obj))))))

  (define (create-global-var-if-needed sym)
    (let ((x (read-u8)))
      (if (= x 1)
          (##make-global-var sym))))

  (define (deserialize-without-transform!)
    (let ((x (read-u8)))

      (cond ((>= x (shared-tag))
             (shared-ref
              (deserialize-nonneg-fixnum! (bitwise-and x #x7f) 7)))

            ((>= x (false-tag))
             (cond ((= x (false-tag))
                    #f)

                   ((= x (true-tag))
                    #t)

                   ((= x (nil-tag))
                    '())

                   ((= x (eof-tag))
                    #!eof)

                   ((= x (void-tag))
                    #!void)

                   ((= x (absent-tag))
                    (macro-absent-obj))

                   ((= x (unbound-tag))
                    #!unbound)

                   ((= x (unbound2-tag))
                    #!unbound2)

                   ((= x (optional-tag))
                    #!optional)

                   ((= x (key-tag))
                    #!key)

                   ((= x (rest-tag))
                    #!rest)

                   ((= x (unused-tag))
                    (macro-unused-obj))

                   ((= x (deleted-tag))
                    (macro-deleted-obj))

                   (else
                    (err))))

            ((>= x (character-tag))
             (cond ((= x (character-tag))
                    (let ((n (deserialize-nonneg-fixnum! 0 0)))
                      (if (<= n (max-char))
                          (integer->char n)
                          (err))))

                   ((= x (flonum-tag))
                    (let ((obj (deserialize-flonum-64!)))
                      (alloc! obj)
                      obj))

                   ((= x (ratnum-tag))
                    (let* ((num (deserialize!))
                           (den (deserialize!)))
                      (if (or (and (fixnum? den)
                                   (<= den 1))
                              (and (bignum? den)
                                   (generic.negative? den))
                              (not (eq? 1 (generic.gcd num den))))
                          (err)
                          (let ((obj (macro-ratnum-make num den)))
                            (alloc! obj)
                            obj))))

                   ((= x (cpxnum-tag))
                    (let* ((real (deserialize!))
                           (imag (deserialize!)))
                      (if (or (not (real? real))
                              (not (real? imag)))
                          (err)
                          (let ((obj (macro-cpxnum-make real imag)))
                            (alloc! obj)
                            obj))))

                   ((= x (pair-tag))
                    (let ((obj (cons #f #f)))
                      (alloc! obj)
                      (let* ((a (deserialize!))
                             (d (deserialize!)))
                        (set-car! obj a)
                        (set-cdr! obj d)
                        obj)))

                   ((= x (continuation-tag))
                    (let ((obj (vector #f #f)))
                      (alloc! obj)
                      (let* ((frame (deserialize!))
                             (denv (deserialize!)))
                        (if (not (frame? frame)) ;; should also check denv
                            (err)
                            (begin
                              (vector-set! obj 0 frame)
                              (vector-set! obj 1 denv)
                              (subtype-set! obj (macro-subtype-continuation))
                              obj)))))

                   ((= x (boxvalues-tag))
                    (deserialize-vector-like-long!
                     (macro-subtype-boxvalues)))

                   ((= x (ui-symbol-tag))
                    (let* ((y (read-u8))
                           (name (deserialize-string! y #xff))
                           (hash (deserialize-exact-int-of-length! 4))
                           (obj (macro-make-uninterned-symbol name hash)))
                      (create-global-var-if-needed obj)
                      (alloc! obj)
                      obj))

                   ((= x (keyword-tag))
                    (let* ((name (deserialize-string! 0 0))
                           (obj (string->keyword name)))
                      (alloc! obj)
                      obj))

                   ((= x (ui-keyword-tag))
                    (let* ((y (read-u8))
                           (name (deserialize-string! y #xff))
                           (hash (deserialize-exact-int-of-length! 4))
                           (obj (macro-make-uninterned-keyword name hash)))
                      (alloc! obj)
                      obj))

                   ((= x (closure-tag))
                    (let ((subproc (deserialize-subprocedure!)))
                      (if #f;;;;;;;not subprocedure
                          (err)
                          (let ((nb-closed
                                 (subprocedure-nb-closed subproc)))
                            (if #f;;;;; nb-closed = 0
                                (err)
                                (let ((obj (make-vector (+ nb-closed 1))))
                                  (vector-set! obj 0 subproc)
                                  (alloc! obj)
                                  (let loop ((i 1))
                                    (if (<= i nb-closed)
                                        (begin
                                          (vector-set! obj i (deserialize!))
                                          (loop (+ i 1)))
                                        (begin
                                          (subtype-set!
                                           obj
                                           (macro-subtype-procedure))
                                          obj)))))))))

                   ((= x (frame-tag))
                    (let ((subproc (deserialize-subprocedure!)))
                      (if (not (##return? subproc))
                          (err)
                          (let* ((fs (##return-fs subproc))
                                 (obj (make-vector (+ fs 1))))
                            (vector-set! obj 0 subproc)
                            (alloc! obj)
                            (let loop ((i 1))
                              (if (<= i fs)
                                  (begin
                                    (vector-set!
                                     obj
                                     (+ (- fs i) 1)
                                     (if (frame-slot-live? obj i)
                                         (deserialize!)
                                         0))
                                    (loop (+ i 1)))
                                  (begin
                                    (subtype-set! obj (macro-subtype-frame))
                                    obj)))))))

                   ((= x (gchashtable-tag))
                    (let* ((len (deserialize-nonneg-fixnum! 0 0))
                           (flags (deserialize-nonneg-fixnum! 0 0))
                           (count (deserialize-nonneg-fixnum! 0 0))
                           (min-count (deserialize-nonneg-fixnum! 0 0))
                           (free (deserialize-nonneg-fixnum! 0 0)))
                      (if #f;;;;;;;;parameters OK?
                          (err)
                          (let ((obj (make-vector len (macro-unused-obj))))
                            (alloc! obj)
                            (macro-gc-hash-table-flags-set!
                             obj
                             (bitwise-ior ;; force rehash at next access!
                              flags
                              (macro-gc-hash-table-flag-need-rehash)))
                            (macro-gc-hash-table-count-set! obj count)
                            (macro-gc-hash-table-min-count-set! obj min-count)
                            (macro-gc-hash-table-free-set! obj free)
                            (let loop ((i (macro-gc-hash-table-key0)))
                              (if (< i (vector-length obj))
                                  (let ((key (deserialize!)))
                                    (if (not (eq? key (macro-unused-obj)))
                                        (let ((val (deserialize!)))
                                          (vector-set! obj i key)
                                          (vector-set! obj (+ i 1) val)
                                          (loop (+ i 2)))
                                        (begin
                                          (subtype-set!
                                           obj
                                           (macro-subtype-weak))
                                          obj)))
                                  (err)))))))

                   ((= x (meroon-tag))
                    (deserialize-vector-like-long!
                     (macro-subtype-meroon)))

                   ((= x (homvector-tag))
                    (let* ((len/type
                            (deserialize-nonneg-fixnum! 0 0))
                           (len
                            (arithmetic-shift-right len/type 4))
                           (type
                            (bitwise-and len/type #x0f)))
                      (cond ((= type (s8vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-s8vector n))
                              (lambda (v i n) (s8vector-set! v i n))
                              1
                              #t
                              len))
                            ((= type (u8vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-u8vector n))
                              (lambda (v i n) (u8vector-set! v i n))
                              1
                              #f
                              len))
                            ((= type (s16vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-s16vector n))
                              (lambda (v i n) (s16vector-set! v i n))
                              2
                              #t
                              len))
                            ((= type (u16vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-u16vector n))
                              (lambda (v i n) (u16vector-set! v i n))
                              2
                              #f
                              len))
                            ((= type (s32vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-s32vector n))
                              (lambda (v i n) (s32vector-set! v i n))
                              4
                              #t
                              len))
                            ((= type (u32vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-u32vector n))
                              (lambda (v i n) (u32vector-set! v i n))
                              4
                              #f
                              len))
                            ((= type (s64vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-s64vector n))
                              (lambda (v i n) (s64vector-set! v i n))
                              8
                              #t
                              len))
                            ((= type (u64vector-tag))
                             (deserialize-homintvector!
                              (lambda (n) (make-u64vector n))
                              (lambda (v i n) (u64vector-set! v i n))
                              8
                              #f
                              len))
                            ((= type (f32vector-tag))
                             (deserialize-homfloatvector!
                              (lambda (n) (make-f32vector n))
                              (lambda (v i n) (f32vector-set! v i n))
                              len
                              #t))
                            ((= type (f64vector-tag))
                             (deserialize-homfloatvector!
                              (lambda (n) (make-f64vector n))
                              (lambda (v i n) (f64vector-set! v i n))
                              len
                              #f))
                            (else
                             (err)))))

                   (else
                    (err))))

            ((>= x (exact-int-tag))
             (let ((lo (bitwise-and x #x0f)))
               (if (< lo #x0b)
                   lo
                   (let* ((len
                           (if (= lo #x0f)
                               (deserialize-nonneg-fixnum! 0 0)
                               (- #x0f lo)))
                          (n
                           (deserialize-exact-int-of-length! len)))
                     (if (= lo #x0e)
                         n
                         (begin
                           (alloc! n)
                           n))))))

            ((>= x (subprocedure-tag))
             (let ((subproc-id
                    (let ((id (bitwise-and x #x0f)))
                      (if (< id #x0f)
                          id
                          (deserialize-nonneg-fixnum! 0 0)))))
               (deserialize-subprocedure-with-id! subproc-id)))

            ((>= x (structure-tag))
             (deserialize-vector-like!
              (macro-subtype-structure)
              x))

            ((>= x (vector-tag))
             (deserialize-vector-like!
              (macro-subtype-vector)
              x))

            ((>= x (string-tag))
             (let ((obj (deserialize-string! x #x0f)))
               (alloc! obj)
               obj))

            (else ;; symbol-tag
             (let* ((name (deserialize-string! x #x0f))
                    (obj (string->symbol name)))
               (create-global-var-if-needed obj)
               (alloc! obj)
               obj)))))

  (define (deserialize!)
    (let ((obj (deserialize-without-transform!)))
      (deserialize-hook obj)))

  (let ((obj (deserialize!)))
    (if (eof?)
        obj
        (err))))

(define-prim (u8vector->obj u8vect)
  (macro-force-vars (u8vect)
    (macro-check-u8vector u8vect 1 (u8vector->obj u8vect)
      (##u8vector->obj u8vect))))
