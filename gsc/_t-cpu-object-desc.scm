;;=============================================================================

;;; File: "_t-cpu-object-desc.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.
;;; Copyright (c) 2019 by Abdelhakim Qbaich, All Rights Reserved.

;;-----------------------------------------------------------------------------

;; Type tags are located in the lower 2 bits of an object.
(define type-tags
  '((fixnum   . 0)
    (special  . 2)   ; XXX USE_EVEN_TAG_FOR_SUBTYPED
    (mem1     . 1)   ; XXX USE_EVEN_TAG_FOR_SUBTYPED
    (mem2     . 3)
    (subtyped . 1)   ; XXX USE_EVEN_TAG_FOR_SUBTYPED
    (pair     . 3))) ; XXX USE_SAME_TAG_FOR_PAIRS_AND_SUBTYPED

(define (type-tag type)
  (cdr (assq type type-tags)))

(define type-tag-bits 2)
(define type-tag-mask
  (fx- (fxarithmetic-shift 1 type-tag-bits) 1))

;; Head type tags are located in the lower 3 bits of the head of memory
;; allocated objects.
(define head-type-tags
  '((movable0 . 0)
    (movable1 . 1)
    (movable2 . 2)
    (forw     . 3)
    (still    . 5)
    (perm     . 6)))

(define (head-type-tag head-type)
  (cdr (assq head-type head-type-tags)))

(define head-type-tag-bits 3)
(define head-type-tag-mask
  (fx- (fxarithmetic-shift 1 head-type-tag-bits) 1))

;; Subtype tags are located in the head of memory allocated objects.
(define subtype-tags
  '((vector       . 0)
    (pair         . 1)
    (ratnum       . 2)
    (cpxnum       . 3)
    (structure    . 4)
    (boxvalues    . 5)
    (meroon       . 6)
    (jazz         . 7)
    (symbol       . 8)
    (keyword      . 9)
    (frame        . 10)
    (continuation . 11)
    (promise      . 12)
    (weak         . 13)
    (procedure    . 14)
    (return       . 15)
    (foreign      . 18)
    (string       . 19)
    (s8vector     . 20)
    (u8vector     . 21)
    (s16vector    . 22)
    (u16vector    . 23)
    (s32vector    . 24)
    (u32vector    . 25)
    (f32vector    . 26)
    (s64vector    . 27)
    (u64vector    . 28)
    (f64vector    . 29)
    (flonum       . 30)
    (bignum       . 31)))

(define (subtype-tag subtype)
  (fxarithmetic-shift (cdr (assq subtype subtype-tags)) head-type-tag-bits))

(define subtype-tag-bits 5)
(define subtype-tag-mask
  (fxarithmetic-shift
    (fx- (fxarithmetic-shift 1 subtype-tag-bits) 1)
    head-type-tag-bits))

;; Lengths in bytes are located in the head of memory allocated objects.
(define length-mask
  (fxnot ; XXX
    (fx- (fxarithmetic-shift 1 (fx+ head-type-tag-bits subtype-tag-bits)) 1)))

;;-----------------------------------------------------------------------------

(define (body-offset type width)
  (fx- 0 (type-tag type) width))

(define (header-offset type width)
  (fx- 0 (type-tag type) width width))

;;-----------------------------------------------------------------------------

(define (desc-type desc)    (vector-ref desc 1))
(define (desc-encoder desc) (vector-ref desc 2))

(define (desc-type-tag desc)
  (type-tag (desc-type desc)))

(define (desc-encoder? encoder)
  (procedure? encoder))

;;-----------------------------------------------------------------------------

(define (imm-desc type encoder)
  (vector 'imm type encoder))

(define imm-type desc-type)
(define imm-encoder desc-encoder)

(define imm-type-tag desc-type-tag)

(define (imm-type? type)
  (or (eq? type 'fixnum)
      (eq? type 'special)))

(define imm-encoder? desc-encoder?)

(define (imm-desc? desc)
  (and (eq? 'imm (vector-ref desc 0))
       (imm-type?    (imm-type desc))
       (imm-encoder? (imm-encoder desc))))

;;-----------------------------------------------------------------------------

(define (ref-desc type encoder subtype)
  (vector 'ref type encoder subtype))

(define ref-type desc-type)
(define ref-encoder desc-encoder)
(define (ref-subtype desc) (vector-ref desc 3))

(define ref-type-tag desc-type-tag)
(define (ref-subtype-tag desc)
  (subtype-tag (ref-subtype desc)))

(define (ref-type? type)
  (or (eq? type 'subtyped)
      (eq? type 'pair)))

(define ref-encoder? desc-encoder?)

(define (ref-subtype? subtype)
  (assq subtype subtype-tags))

(define (ref-desc? desc)
  (and (eq? 'ref (vector-ref desc 0))
       (ref-type?    (ref-type desc))
       (ref-encoder? (ref-encoder desc))
       (ref-subtype? (ref-subtype desc))))

;;-----------------------------------------------------------------------------

(define (tagged-value val type) ; XXX
  (+ (arithmetic-shift val type-tag-bits) (type-tag type)))

(define fixnum-desc
  (imm-desc
    'fixnum
    (lambda (val)
      (tagged-value val 'fixnum))))

(define char-desc
  (imm-desc
    'special
    (lambda (val)
      (tagged-value (char->integer val) 'special)))) ; XXX

(define (special-desc val)
  (imm-desc
    'special
    (lambda (#!optional (_ #f)) ; XXX
      (tagged-value val 'special))))

(define fal-desc      (special-desc -1))
(define tru-desc      (special-desc -2))
(define nul-desc      (special-desc -3))
(define eof-desc      (special-desc -4))
(define void-desc     (special-desc -5))
(define absent-desc   (special-desc -6))
(define unb1-desc     (special-desc -7))
(define unb2-desc     (special-desc -8))
(define optional-desc (special-desc -9))
(define keyobj-desc   (special-desc -10))
(define rest-desc     (special-desc -11))
(define unused-desc   (special-desc -14))
(define deleted-desc  (special-desc -15))

;;-----------------------------------------------------------------------------

; TODO Encoders

(define pair-desc
  (ref-desc
    'pair
    (lambda (val) #f)
    'pair))

(define vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'vector))

(define ratnum-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'ratnum))

(define cpxnum-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'cpxnum))

(define structure-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'structure))

(define boxvalues-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'boxvalues))

(define meroon-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'meroon))

(define jazz-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'jazz))

(define symbol-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'symbol))

(define keyword-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'keyword))

(define frame-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'frame))

(define continuation-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'continuation))

(define promise-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'promise))

(define weak-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'weak))

(define procedure-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'procedure))

(define return-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'return))

(define foreign-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'foreign))

(define string-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'string))

(define s8vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    's8vector))

(define u8vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'u8vector))

(define s16vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    's16vector))

(define u16vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'u16vector))

(define s32vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    's32vector))

(define u32vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'u32vector))

(define f32vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'f32vector))

(define s64vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    's64vector))

(define u64vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'u64vector))

(define f64vector-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'f64vector))

(define flonum-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'flonum))

(define bignum-desc
  (ref-desc
    'subtyped
    (lambda (val) #f)
    'bignum))

;;-----------------------------------------------------------------------------

; FIXME Check if fixnum on target, not compilation machine
(define (object->desc object) ; XXX
  (cond ((fixnum? object)             fixnum-desc)
        ((char? object)               char-desc)
        ((eq? object #f)              fal-desc)
        ((eq? object #t)              tru-desc)
        ((null? object)               nul-desc)
        ((end-of-file-object? object) eof-desc)
        ((void-object? object)        void-desc)
        ((absent-object? object)      absent-desc)
        ((unbound1-object? object)    unb1-desc)
        ((unbound2-object? object)    unb2-desc)
        ((optional-object? object)    optional-desc)
        ((key-object? object)         keyobj-desc)
        ((rest-object? object)        rest-desc)
        ((unused-object? object)      unused-desc)
        ((deleted-object? object)     deleted-desc)
        ((pair? object)               pair-desc)
        ((vector? object)             vector-desc)
        ((rational? object)           ratnum-desc)
        ((complex? object)            cpxnum-desc)
        ((structure-object? object)   structure-desc)
        ((box? object)                boxvalues-desc)
        ((##meroon? object)           meroon-desc)
        ((##jazz? object)             jazz-desc)
        ((symbol? object)             symbol-desc)
        ((keyword? object)            keyword-desc)
        ((##frame? object)            frame-desc)
        ((continuation? object)       continuation-desc)
        ((promise? object)            promise-desc)
        ; TODO weak-desc
        ((procedure? object)          procedure-desc)
        ((##return? object)           return-desc)
        ((foreign? object)            foreign-desc)
        ((string? object)             string-desc)
        ((s8vector? object)           s8vector-desc)
        ((u8vector? object)           u8vector-desc)
        ((s16vector? object)          s16vector-desc)
        ((u16vector? object)          u16vector-desc)
        ((s32vector? object)          s32vector-desc)
        ((u32vector? object)          u32vector-desc)
        ((f32vector? object)          f32vector-desc)
        ((s64vector? object)          s64vector-desc)
        ((u64vector? object)          u64vector-desc)
        ((f64vector? object)          f64vector-desc)
        ((flonum? object)             flonum-desc)
        ((integer? object)            bignum-desc)
        (else (compiler-internal-error
                "object->desc, no description for object" object))))

(define (imm-object? object)
  (imm-desc? (object->desc object)))

(define (ref-object? object)
  (ref-desc? (object->desc object)))

(define (imm-encode object)
  (let ((desc (object->desc object)))
    (if (imm-desc? desc)
        ((imm-encoder desc) object)
        (compiler-internal-error
          "imm-encode, object not of immediate type" object))))

(define (ref-encode object)
  (let ((desc (object->desc object)))
    (if (ref-desc? desc)
        ((ref-encoder desc) object)
        (compiler-internal-error
          "ref-encode, object not of reference type" object))))

;;=============================================================================
