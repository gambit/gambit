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
  ;; todo: Use macro to shorten code and reduce repetition
  (cond
    ;; Fixnum
    ;; Todo: Check if fixnum on TARGET, not compilation machine
    ((fixnum? object)     fixnum-obj-desc)
    ;; Special int values
    ((boolean? object)    boolean-obj-desc)
    ((null? object)       nil-obj-desc)
    ((eof-object? object) eof-obj-desc)
    ;; Pair
    ((pair? object)       pair-obj-desc)
    ;; Subtypes
    ((string? object)     string-obj-desc)
    (else (compiler-internal-error "Unknown object type: " object))))

(define (get-desc-pointer-tag desc)
  (cond
    ((and (immediate-desc? desc) (eqv? 'fixnum (immediate-type desc)))
      fixnum-tag)
    ((and (immediate-desc? desc) (eqv? 'specialval (immediate-type desc)))
      special-int-tag)
    ((and (reference-desc? desc) (eqv? 'subtype (immediate-type desc)))
      object-tag)
    ((and (reference-desc? desc) (eqv? 'pair (immediate-type desc)))
      pair-tag)
    (else
      (compiler-internal-error "get-desc-pointer-tag - Unknown object description: " desc))))

;; Pointer tagging constants
(define header-tag-width  5)
(define header-tag-offset 3)

(define tag-mult          4)
(define tag-width         2) ;(ceiling (/ (log tag-mult) (log 2))))

(define fixnum-tag        0)
(define object-tag        1)
(define special-int-tag   2)
(define pair-tag          3)

(define (tag-number val tag)
  (+ (* tag-mult val) tag))

;; Immediate types

;; Special int values
(define false-object-val -1) ;; Default value for false
(define true-object-val  -2) ;; Default value for true
(define eof-object-val   -100)
(define nil-object-val   -1000)

(define fixnum-obj-desc
  (immediate-desc 'fixnum
    (lambda (val) (tag-number val fixnum-tag))))

(define (make-unit-type-desc fixnum-value)
  (immediate-desc 'specialval
    (lambda (void) (tag-number fixnum-value special-int-tag))))

(define boolean-obj-desc
  (immediate-desc 'specialval
    (lambda (val) (tag-number (if val true-object-val false-object-val) special-int-tag))))

(define nil-obj-desc (make-unit-type-desc nil-object-val))
(define eof-obj-desc (make-unit-type-desc nil-object-val))

;; Reference types

(define vector-obj-desc
  (let ((subtype 0)
        (header-fun (lambda (val) (vector-length val)))
        (encode-fun (lambda (val) (vector->list val))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define pair-obj-desc
  (let ((subtype 1)
        (header-fun (lambda (val) 2))
        (encode-fun (lambda (val) (list (car val) (cdr val)))))
    (reference-desc 'pair subtype header-fun encode-fun)))

(define ratnum-obj-desc
  (let ((subtype 2)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define cpxnum-obj-desc
  (let ((subtype 3)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define structure-obj-desc
  (let ((subtype 4)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define boxvalue-obj-desc
  (let ((subtype 5)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define meroon-obj-desc
  (let ((subtype 6)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define jazz-obj-desc
  (let ((subtype 7)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define symbol-obj-desc
  (let ((subtype 8)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define keyword-obj-desc
  (let ((subtype 9)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define frame-obj-desc
  (let ((subtype 10)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define continuation-obj-desc
  (let ((subtype 11)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define promise-obj-desc
  (let ((subtype 12)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define weak-obj-desc
  (let ((subtype 13)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define procedure-obj-desc
  (let ((subtype 14)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define return-obj-desc
  (let ((subtype 15)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define foreign-obj-desc
  (let ((subtype 18)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define string-obj-desc
  (let ((subtype 19)
        (header-fun (lambda (val) (* 4 (string-length val))))
        (encode-fun (lambda (val) (map char->integer (string->list val)))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define s8vector-obj-desc
  (let ((subtype 20)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define u8vector-obj-desc
  (let ((subtype 21)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define s16vector-obj-desc
  (let ((subtype 22)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define u16vector-obj-desc
  (let ((subtype 23)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define s32vector-obj-desc
  (let ((subtype 24)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define u32vector-obj-desc
  (let ((subtype 25)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define f32vector-obj-desc
  (let ((subtype 26)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define s64vector-obj-desc
  (let ((subtype 27)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define u64vector-obj-desc
  (let ((subtype 28)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define f64vector-obj-desc
  (let ((subtype 29)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define flonum-obj-desc
  (let ((subtype 30)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))

(define bignum-obj-desc
  (let ((subtype 31)
        (header-fun (lambda (val) (compiler-internal-error "Implement header-fun function")))
        (encode-fun (lambda (val) (compiler-internal-error "Implement encode-obj function"))))
    (reference-desc 'subtype subtype header-fun encode-fun)))