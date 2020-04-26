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

(define-fail-check-type procedure 'procedure)

(define-prim (##procedure? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-procedure))))

(define-prim (procedure? obj)
  (macro-force-vars (obj)
    (##procedure? obj)))

;; apply is in "_kernel.scm"

;; call-with-current-continuation is in "_kernel.scm"

;; Port related procedures are in "_io.scm"

;;;----------------------------------------------------------------------------

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

(##include "~~lib/gambit/list/list.scm")
(##include "~~lib/gambit/char/char.scm")
(##include "~~lib/gambit/string/string.scm")

;;;============================================================================
