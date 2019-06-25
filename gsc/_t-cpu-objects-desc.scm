;;==============================================================================

;;; File: "_t-cpu-objects-desc.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

;;------------------------------------------------------------------------------

;; Object encoding

; data ObjectDescription = Immediate {
;   type :: ImmediateType,
;   encode-fun :: Object -> Fixnum (30 or 62 bits - Without tags)
; } | Reference {
;   type :: ReferenceType,
;   header-tag :: Fixnum (5 bits),
;   header-length-fun :: Object -> Fixnum (24 or 56 bits),
;   encode-fun :: Object -> [Object] -- Encodes the body of the object
; }

; data ImmediateType = Fixnum  | SpecialVal
; data ReferenceType = Subtype | Pair

(define (immediate-desc type encode-fun) (list 'imm type encode-fun))
(define (immediate-desc? desc) (eqv? 'imm (car desc)))
(define (immediate-type desc) (list-ref desc 1))
(define (immediate-encode-fun desc) (list-ref desc 2))

(define (reference-desc type header-tag header-fun encode-fun) (list 'ref type header-tag header-fun encode-fun))
(define (reference-desc? desc) (eqv? 'ref (car desc)))
(define (reference-type desc) (list-ref desc 1))
(define (reference-header-tag desc) (list-ref desc 2))
(define (reference-header-fun desc) (list-ref desc 3))
(define (reference-encode-fun desc) (list-ref desc 4))

(define (immediate-object? object)
  (immediate-desc? (get-object-description object)))

(define (reference-object? object)
  (reference-desc? (get-object-description object)))

(define (format-imm-object object)
  (let ((desc (get-object-description object)))
    (cond
      ((immediate-desc? desc)
       ((immediate-encode-fun desc) object))
      (else
        (compiler-internal-error "format-imm-object - Object must be an immediate: " object)))))

(define (get-object-description object)
  (cond
    ;; Fixnum
    ;; Todo: Check if fixnum on TARGET, not compilation machine
    ((fixnum? object)       fixnum-obj-desc)
    ;; Special int values
    ((boolean? object)      boolean-obj-desc)
    ((null? object)         nil-obj-desc)
    ((eof-object? object)   eof-obj-desc)
    ((equal? (void) object) void-obj-desc)
    ((char? object)         char-obj-desc)
    ;; Pair
    ; ((pair? object)       pair-obj-desc)
    ; ;; Subtypes
    ; ((string? object)     string-obj-desc)
    ; ((vector? object)     vector-obj-desc)
    ; ((symbol? object)     symbol-obj-desc)
    (else c-obj-desc)))
    ; (else (compiler-internal-error "Unknown object type: " object))))

(define (get-desc-pointer-tag desc)
  (cond
    ((and (immediate-desc? desc)
          (eqv? 'fixnum (immediate-type desc)))
     fixnum-tag)
    ((and (immediate-desc? desc)
          (eqv? 'specialval (immediate-type desc)))
     special-int-tag)
    ((and (reference-desc? desc)
          (eqv? 'subtype (reference-type desc)))
     object-tag)
    ((and (reference-desc? desc)
          (eqv? 'pair (reference-type desc)))
     pair-tag)
    (else
      (compiler-internal-error "get-desc-pointer-tag - Unknown object description: " desc))))

;; Pointer tagging constants

(define USE_EVEN_TAG_FOR_SUBTYPED #f)

(define pointer-header-offset 2)

(define header-tag-width     5)
(define header-tag-offset    3)
(define header-tag-mult      (expt 2 header-tag-offset))
(define header-length-offset (+ header-tag-offset header-tag-width))
(define header-length-mult   (expt 2 header-length-offset))

(define tag-width            2) ;(ceiling (/ (log tag-mult) (log 2))))
(define tag-mult             (expt 2 tag-width))

(define fixnum-tag           0)
(define object-tag           (if USE_EVEN_TAG_FOR_SUBTYPED 2 1))
(define special-int-tag      (if USE_EVEN_TAG_FOR_SUBTYPED 1 2))
(define pair-tag             3)

(define (tag-number val tag)
  (+ (* tag-mult val) tag))

;; Immediate types

;; Special int values
;; Use gsi with ##fx+ to find values
(define false-object-val -1) ;; Default value for false
(define true-object-val  -2) ;; Default value for true
(define nil-object-val   -3)
(define eof-object-val   -4)
(define void-object-val  -5)

(define fixnum-obj-desc
  (immediate-desc 'fixnum
    (lambda (val) (tag-number val fixnum-tag))))

(define (make-unit-type-desc fixnum-value)
  (immediate-desc 'specialval
    (lambda (void) (tag-number fixnum-value special-int-tag))))

(define boolean-obj-desc
  (immediate-desc 'specialval
    (lambda (val) (tag-number (if val true-object-val false-object-val) special-int-tag))))

(define char-obj-desc
  (immediate-desc 'specialval
    (lambda (val) (tag-number (char->integer val) special-int-tag))))

(define nil-obj-desc (make-unit-type-desc nil-object-val))
(define eof-obj-desc (make-unit-type-desc eof-object-val))
(define void-obj-desc (make-unit-type-desc void-object-val))

;; Reference types

(define-macro (obj-desc subtype)
  `(let ((header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
         (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype ,subtype header-fun encode-fun)))

(define c-obj-desc
    (let ((subtype 0)
          (header-fun (lambda (val) (compiler-internal-error "c-obj-desc: todo")))
          (encode-fun (lambda (val) (compiler-internal-error "c-obj-desc: todo"))))
      (reference-desc 'subtype subtype header-fun encode-fun)))

(define vector-obj-desc
  (let ((subtype 0)
        (header-fun (lambda (val) (vector-length val)))
        (encode-fun (lambda (val) (vector->list val))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define pair-obj-desc
  (let ((subtype 1)
        (header-fun (lambda (val) 2))
        (encode-fun (lambda (val) (list (cdr val) (car val)))))
    (reference-desc 'pair subtype header-fun encode-fun)))

(define ratnum-obj-desc (obj-desc 2))

(define cpxnum-obj-desc (obj-desc 3))

(define structure-obj-desc (obj-desc 4))

(define boxvalue-obj-desc (obj-desc 5))

(define meroon-obj-desc (obj-desc 6))

(define jazz-obj-desc (obj-desc 7))

(define symbol-obj-desc (obj-desc 8))

(define keyword-obj-desc (obj-desc 9))

(define frame-obj-desc (obj-desc 10))

(define continuation-obj-desc (obj-desc 11))

(define promise-obj-desc (obj-desc 12))

(define weak-obj-desc (obj-desc 13))

(define procedure-obj-desc (obj-desc 14))

(define return-obj-desc (obj-desc 15))

(define foreign-obj-desc (obj-desc 18))

(define string-obj-desc
  (let ((subtype 19)
        (header-fun (lambda (val) (* 4 (string-length val))))
        (encode-fun (lambda (val) (map char->integer (string->list val)))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define s8vector-obj-desc (obj-desc 20))

(define u8vector-obj-desc (obj-desc 21))

(define s16vector-obj-desc (obj-desc 22))

(define u16vector-obj-desc (obj-desc 23))

(define s32vector-obj-desc (obj-desc 24))

(define u32vector-obj-desc (obj-desc 25))

(define f32vector-obj-desc (obj-desc 26))

(define s64vector-obj-desc (obj-desc 27))

(define u64vector-obj-desc (obj-desc 28))

(define f64vector-obj-desc (obj-desc 29))

(define flonum-obj-desc (obj-desc 30))

(define bignum-obj-desc (obj-desc 31))
