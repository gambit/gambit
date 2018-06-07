;;;============================================================================

;;; File: "_codegen.scm"

;;; Copyright (c) 2010-2018 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; This module implements the code generation infrastructure.

(namespace ("_codegen#") ("" include))
(include "~~lib/gambit#.scm")

(include "_asm#.scm")
(include "_codegen#.scm")

(codegen-implement)

;;;============================================================================

(define (make-codegen-context)
  (let ((cgc (make-vector (+ (asm-code-block-size) 14) 'codegen-context)))
    (codegen-context-listing-format-set!             cgc #f)
    (codegen-context-arch-set!                       cgc #f)

    (codegen-context-target-set!                     cgc #f)

    (codegen-context-fixup-locs-set!                 cgc '())
    (codegen-context-fixup-objs-set!                 cgc (make-table 'test: eq?))

    (codegen-context-current-proc-set!               cgc #f)
    (codegen-context-current-code-set!               cgc #f)
    (codegen-context-frame-size-set!                 cgc #f)
    (codegen-context-nargs-set!                      cgc #f)
    (codegen-context-label-struct-position-set!      cgc #f)

    (codegen-context-extra-registers-allocation-set! cgc #f)

    (codegen-context-primitive-labels-table-set!     cgc (make-table 'test: equal?))
    (codegen-context-proc-labels-table-set!          cgc (make-table 'test: equal?))
    (codegen-context-other-labels-table-set!         cgc (make-table 'test: equal?))

    cgc))

;; Instruction encoding

(define (codegen-context-listing-format cgc)
  (vector-ref cgc (+ (asm-code-block-size) 0)))

(define (codegen-context-listing-format-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 0) x))

(define (codegen-context-arch cgc)
  (vector-ref cgc (+ (asm-code-block-size) 1)))

(define (codegen-context-arch-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 1) x))

;; Target

(define (codegen-context-target cgc)
  (vector-ref cgc (+ (asm-code-block-size) 2)))

(define (codegen-context-target-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 2) x))

;; Loader values

(define (codegen-context-fixup-locs cgc)
  (vector-ref cgc (+ (asm-code-block-size) 3)))

(define (codegen-context-fixup-locs-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 3) x))

(define (codegen-context-fixup-objs cgc)
  (vector-ref cgc (+ (asm-code-block-size) 4)))

(define (codegen-context-fixup-objs-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 4) x))

;; Execution context

(define (codegen-context-current-proc cgc)
  (vector-ref cgc (+ (asm-code-block-size) 5)))

(define (codegen-context-current-proc-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 5) x))

(define (codegen-context-current-code cgc)
  (vector-ref cgc (+ (asm-code-block-size) 6)))

(define (codegen-context-current-code-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 6) x))

(define (codegen-context-frame-size cgc)
  (vector-ref cgc (+ (asm-code-block-size) 7)))

(define (codegen-context-frame-size-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 7) x))

(define (codegen-context-nargs cgc)
  (vector-ref cgc (+ (asm-code-block-size) 8)))

(define (codegen-context-nargs-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 8) x))

(define (codegen-context-label-struct-position cgc)
  (vector-ref cgc (+ (asm-code-block-size) 9)))

(define (codegen-context-label-struct-position-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 9) x))

;; Resource tracking

(define (codegen-context-extra-registers-allocation cgc)
  (vector-ref cgc (+ (asm-code-block-size) 10)))

(define (codegen-context-extra-registers-allocation-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 10) x))

;; Label tables

(define (codegen-context-primitive-labels-table cgc)
  (vector-ref cgc (+ (asm-code-block-size) 11)))

(define (codegen-context-primitive-labels-table-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 11) x))

(define (codegen-context-proc-labels-table cgc)
  (vector-ref cgc (+ (asm-code-block-size) 12)))

(define (codegen-context-proc-labels-table-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 12) x))

(define (codegen-context-other-labels-table cgc)
  (vector-ref cgc (+ (asm-code-block-size) 13)))

(define (codegen-context-other-labels-table-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 13) x))

;; Utils

;; Utils - Fixups

(define (codegen-context-fixup-locs-add! cgc lbl width)
  (codegen-context-fixup-locs-set!
     cgc
     (cons (cons lbl width)
           (codegen-context-fixup-locs cgc))))

(define (codegen-context-fixup-locs->vector cgc)
  (let ((lst
         (c#sort-list
          (codegen-context-fixup-locs cgc)
          (lambda (x y)
            (fx< (asm-label-pos (car x)) (asm-label-pos (car y))))))
        (svect
         (c#make-stretchable-vector #f)))
    (let loop1 ((i 0) (last-pos 0) (lst lst))
      (if (pair? lst)
          (let* ((x (car lst))
                 (next-pos (asm-label-pos (car x)))
                 (dist (fx- next-pos last-pos)))
            (let loop2 ((i i) (dist dist))
              (if (fx>= dist 127)
                  (begin
                    ;; distance too large, insert "skip noop"
                    (c#stretchable-vector-set! svect i 1)
                    (loop2 (fx+ i 1)
                           (fx- dist 127)))
                  (if (fx= (cdr x) 32)
                      (begin
                        ;; 32 bit = 4 byte fixup
                        (c#stretchable-vector-set! svect i (fx+ 2 (fx* 2 dist)))
                        (loop1 (fx+ i 1)
                               (fx+ next-pos 4)
                               (cdr lst)))
                      (begin
                        ;; 64 bit = 8 byte fixup
                        (c#stretchable-vector-set! svect i (fx+ 3 (fx* 2 dist)))
                        (loop1 (fx+ i 1)
                               (fx+ next-pos 8)
                               (cdr lst)))))))
          (c#stretchable-vector-set! svect i 0)))
    (list->u8vector (c#stretchable-vector->list svect))))

(define (codegen-context-fixup-obj-register! cgc obj)
  (let ((objs (codegen-context-fixup-objs cgc)))
    (or (table-ref objs obj #f)
        (let ((len (table-length objs)))
          (table-set! objs obj len)
          len))))

(define (codegen-context-fixup-objs->vector cgc)
  (let* ((len (table-length (codegen-context-fixup-objs cgc)))
         (vect (make-vector len)))
    (for-each (lambda (kv)
                (vector-set! vect (cdr kv) (car kv)))
              (table->list (codegen-context-fixup-objs cgc)))
    vect))

(define (codegen-fixup-generic! cgc width gen-value #!optional (listing #f))
  (let ((lbl (asm-make-label cgc 'fixup)))
    (codegen-context-fixup-locs-add! cgc lbl width)
    (asm-label cgc lbl)
    (if listing
      (asm-listing cgc (list "'" listing)))
    (asm-at-assembly
     cgc
     (lambda (cgc self)
       (fxarithmetic-shift-right width 3))
     (lambda (cgc self)
       (asm-int-le cgc (gen-value cgc self) width)))))

(define (codegen-fixup-lbl! cgc lbl offset relative? width)
  (codegen-fixup-generic!
   cgc
   width
   (lambda (cgc self)
     (fx+ (if relative? 0 1)
          (fx* 256
               (fx- (fx+ (asm-label-pos lbl) offset)
                    self))))
    (asm-label-name lbl)))

(define (codegen-fixup-lbl-late! cgc make-lbl relative? width #!optional (label-name #f))
  (codegen-fixup-generic!
   cgc
   width
   (lambda (cgc self)
     (let ((lbl (make-lbl)))
      (if lbl
        (fx+ (if relative? 0 1)
              (fx* 256
                  (fx- (asm-label-pos lbl)
                        self)))
        0)))
    label-name))

(define (codegen-fixup-obj-generic! cgc op obj width)
  (codegen-context-fixup-obj-register! cgc obj)
  (codegen-fixup-generic!
   cgc
   width
   (lambda (cgc self)
     (fx+ op
          (fx* 256
               (codegen-context-fixup-obj-register! cgc obj))))))

(define (codegen-fixup-obj! cgc obj width)
  (codegen-fixup-obj-generic! cgc 2 obj width))

(define (codegen-fixup-glo! cgc glo-name width)
  (codegen-fixup-obj-generic! cgc 3 glo-name width))

(define (codegen-fixup-prm! cgc prm-name width)
  (codegen-fixup-obj-generic! cgc 4 prm-name width))

(define (codegen-fixup-handler! cgc handler-name width)
  (codegen-fixup-generic!
   cgc
   width
   (lambda (cgc self)
     (fx+ 5
          (fx* 256
               (c#object-pos-in-list handler-name codegen-fixup-handlers))))))

(define codegen-fixup-handlers
  '(___lowlevel_exec))

;;;============================================================================
