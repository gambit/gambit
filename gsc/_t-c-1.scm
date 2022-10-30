;;;============================================================================

;;; File: "_t-c-1.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

'(begin;***********brad
(##include "_gvmadt.scm")
(##include "_utilsadt.scm")
(##include "_hostadt.scm")
)

;;;----------------------------------------------------------------------------
;;
;; Back end for C language (part 1)
;; -----------------------

;; Back end parameters:

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; ***** REGISTERS AVAILABLE

;; The registers available in the virtual machine default to
;; targ-default-nb-gvm-regs and targ-default-nb-arg-regs but can be
;; changed with the gsc options -nb-gvm-regs and -nb-arg-regs.  They
;; must be compatible with the corresponding macros in the file
;; "include/gambit.h.in" (i.e. nb-gvm-regs <= ___NB_GVM_REGS and
;; nb-arg-regs = ___NB_ARG_REGS).
;;
;; nb-gvm-regs = total number of registers available
;;               3 <= nb-gvm-regs <= 25
;; nb-arg-regs = maximum number of arguments passed in registers
;;               1 <= nb-arg-regs <= min( 12, nb-gvm-regs-2 )
;; compactness = compactness of the generated code (0..9)

(define targ-default-nb-gvm-regs 5) ;; default value of nb-gvm-regs
(define targ-default-nb-arg-regs 3) ;; default value of nb-arg-regs
(define targ-default-compactness 5) ;; default value of compactness

(define (targ-nb-gvm-regs) (target-nb-regs targ-target))
(define (targ-nb-arg-regs) (target-nb-arg-regs targ-target))
(define (targ-compactness) (target-compactness targ-target))

(define (targ-set-nb-regs targ sem-changing-opts)
  (let ((nb-gvm-regs
         (get-option sem-changing-opts
                     'nb-gvm-regs
                     targ-default-nb-gvm-regs))
        (nb-arg-regs
         (get-option sem-changing-opts
                     'nb-arg-regs
                     targ-default-nb-arg-regs))
        (compactness
         (get-option sem-changing-opts
                     'compactness
                     targ-default-compactness)))

    (if (not (and (<= 3 nb-gvm-regs)
                  (<= nb-gvm-regs 25)))
        (compiler-error "-nb-gvm-regs option must be between 3 and 25"))

    (if (not (and (<= 1 nb-arg-regs)
                  (<= nb-arg-regs (min 12 (- nb-gvm-regs 2)))))
        (compiler-error
         (string-append "-nb-arg-regs option must be between 1 and "
                        (number->string (min 12 (- nb-gvm-regs 2))))))

    (target-nb-regs-set! targ nb-gvm-regs)
    (target-nb-arg-regs-set! targ nb-arg-regs)
    (target-compactness-set! targ compactness)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; ***** IMPLEMENTATION LIMITS

;; These limits are due to the implementation of the stack and heap.

(define targ-max-nb-parms        1024) ; max. number of formal parameters
(define targ-max-nb-args         4096) ; max. number of actual parameters
(define targ-max-nb-frame-slots  4096) ; max. number of slots in frames

;************** use these constants!

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; ***** SUPPORTED WORD SIZES (in bytes per word)

;; It is assumed that the target machine's word size (in bytes)
;; is a power of 2.  The minimal supported word size must be known to
;; decide if an integer should be represented with a fixnum or bignum.  The
;; largest supported word size is needed in order to generate portable macros
;; to pack strings and bignums into words.

(define targ-min-word-size 4) ; At least 4 bytes per word
(define targ-max-word-size 8) ; Up to 8 bytes per word

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; ***** DATA REPRESENTATION

;; Note: The data representation is mostly machine independent.  This means
;; that it is possible to change the format of objects by redefining the
;; appropriate macros in "gambit.h".  However, the back end must know
;; a few things about the representation in order for the output to be
;; portable to different word sizes and to perform a few optimizations.
;; In the following definitions, space is expressed in number of words.

(define targ-msection-biggest  255) ;; Max size in words of msection objects
(define targ-msection-fudge   4096) ;; Space in words reserved for allocations
                                    ;; before heap overflow check

;; Number of tag bits per pointer:

(define targ-tag-bits 2)
(define targ-alignment (expt 2 targ-tag-bits))

;; Upper bound on space needed by various objects:

(define (targ-round-up-to-multiple-of n i)
  (* (quotient (+ i (- n 1)) n) n))

(define (targ-max-words i) ;; minimum k such that targ-min-word-size*k >= i
                           ;; and targ-min-word-size*k mod targ-alignment = 0
  (quotient (targ-round-up-to-multiple-of
              targ-min-word-size
              (targ-round-up-to-multiple-of targ-alignment i))
            targ-min-word-size))

;; Space occupied by various types of objects.

(define targ-header-words 2) ;; account for possible handle

(define (targ-obj-words words)
  (targ-max-words (* targ-min-word-size (+ targ-header-words words))))

(define targ-pair-space          (targ-obj-words 2))
(define targ-box-space           (targ-obj-words 1))
(define targ-will-space          (targ-obj-words 3))
(define targ-delay-promise-space (targ-obj-words 4))
(define targ-continuation-space  (targ-obj-words 2))
(define targ-ratnum-space        (targ-obj-words 2))
(define targ-cpxnum-space        (targ-obj-words 2))
(define targ-symbol-space        (targ-obj-words 4))
(define targ-keyword-space       (targ-obj-words 3))

(define (targ-vector-of-byte-elements-space n) ;; no alignment constraints
  (quotient
   (targ-round-up-to-multiple-of
    targ-min-word-size
    (+ n (* targ-header-words targ-min-word-size)))
   targ-min-word-size))

(define (targ-vector-of-64-bit-elements-space n) ;; has alignment constraints
  (quotient
   (targ-round-up-to-multiple-of
    8
    (+ (* 8 n) targ-min-word-size (* targ-header-words targ-min-word-size)))
   targ-min-word-size))

(define targ-flonum-space
  (targ-vector-of-64-bit-elements-space 1))

(define (targ-closure-space n)
  (targ-obj-words (+ n 1)))

(define (targ-string-space n)
  (targ-s8vector-space (* n 4))) ;; 4 bytes max per character

(define (targ-s8vector-space n)
  (targ-vector-of-byte-elements-space n))

(define (targ-vector-space n)
  (targ-obj-words n))

(define (targ-max-small-allocation vect-kind)
  (let ((min-msection-max-size-bytes
         (* (- targ-msection-biggest targ-header-words)
            targ-min-word-size)))
    (quotient
     min-msection-max-size-bytes
     (case vect-kind
       ((string)
        4) ;; 4 bytes max per character
       ((s8vector u8vector)
        1)
       ((s16vector u16vector)
        2)
       ((s32vector u32vector f32vector)
        4)
       ((s64vector u64vector f64vector)
        8)
       (else ;; vector
        targ-min-word-size)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; The frame constraints are defined by the parameters
;; targ-frame-reserve and targ-frame-alignment.  The definitions must
;; agree with the corresponding macros in the file "include/gambit.h.in"
;; (i.e. ___FRAME_RESERVE and ___FRAME_ALIGNMENT).

(define targ-frame-reserve #f)
(set! targ-frame-reserve 3) ;; when the stack frame is transformed to a
                            ;; heap frame, 3 extra slots are needed to
                            ;; store the subtype object header, the link
                            ;; to the next frame and the return address.

(define targ-frame-alignment #f)
(set! targ-frame-alignment 4) ;; align frame to multiple of 4 slots

;;;----------------------------------------------------------------------------
;;
;; Initialization/finalization of back-end

(define (targ-make-target)
  (let ((targ
         (make-target 15
                      'C
                      '((".c"    . C)
                        (".C"    . C++)
                        (".cc"   . C++)
                        (".cp"   . C++)
                        (".cpp"  . C++)
                        (".CPP"  . C++)
                        (".cxx"  . C++)
                        (".c++"  . C++)
                        (".m"    . Objective-C)
                        (".M"    . Objective-C++)
                        (".mm"   . Objective-C++))
                      '()
                      '()
                      0)))

    (define (begin! sem-changing-opts
                    sem-preserving-opts
                    info-port)

      (set! targ-info-port info-port)

      (target-dump-set!              targ targ-dump)
      (target-link-info-set!         targ targ-link-info)
      (target-link-set!              targ targ-link)
      (target-prim-info-set!         targ targ-prim-info)
      (target-frame-constraints-set! targ (make-frame-constraints
                                           targ-frame-reserve
                                           targ-frame-alignment))
      (target-proc-result-set!       targ (make-reg 1))
      (target-switch-testable?-set!  targ targ-switch-testable?)
      (target-eq-testable?-set!      targ targ-eq-testable?)
      (target-object-type-set!       targ targ-object-type)

      (targ-set-nb-regs targ sem-changing-opts)

      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)

    (target-max-small-allocation-set! targ targ-max-small-allocation)

    targ))

(define targ-target (targ-make-target))

(target-add targ-target)

(define targ-info-port #f)

;;;----------------------------------------------------------------------------

;; ***** PROCEDURE CALLING CONVENTION

(define (targ-label-info nb-params closed?)
  ((target-label-info targ-target) nb-params closed?))

(define (targ-jump-info nb-args)
  ((target-jump-info targ-target) nb-args))

;;;----------------------------------------------------------------------------

;; ***** PRIMITIVE PROCEDURE DATABASE

(define targ-prim-proc-table
  (let ((t (make-prim-proc-table)))
    (for-each
     (lambda (x) (prim-proc-add! t x))
     '(("##c-code"  0            #t 0        0 (#f)   extended)))
    t))

(define (targ-prim-info name)
  (prim-proc-info targ-prim-proc-table name))

(define (targ-get-prim-info name)
  (let ((proc (targ-prim-info (string->canonical-symbol name))))
    (if proc
        proc
        (compiler-internal-error
         "targ-get-prim-info, unknown primitive:" name))))

;;;----------------------------------------------------------------------------

;; ***** OBJECT PROPERTIES

(define (targ-switch-testable? type)
  (targ-eq-testable? type))

(define (targ-eq-testable? type)
  (define tctx (make-tctx)) ;; TODO: store in the target
  (or (type-included? tctx type type-typically-eq-testable)
      (and (type-singleton? type)
           (memq (targ-obj-type (type-singleton-val type))
                 '(;; boolean null void eof absent fixnum char (covered by above)
                   unused deleted optional key rest)))))

(define (targ-object-type obj)
  (let ((t (targ-obj-type obj)))
    (if (eq? t 'subtyped)
        (targ-obj-subtype obj)
        t)))

;;;----------------------------------------------------------------------------
;;
;; Dumping of a compilation module

(define (targ-dump procs output c-intf module-descr linker-name)
  (let ((c-decls-queue (list->queue (c-intf-decls c-intf)))
        (c-procs (c-intf-procs c-intf))
        (c-inits (c-intf-inits c-intf))
        (c-objs (c-intf-objs c-intf)))

    (c-intf-decls-set! c-intf '()) ; clear c-intf structure so front-end
    (c-intf-procs-set! c-intf '()) ; will not generate C-interface file.
    (c-intf-inits-set! c-intf '())
    (c-intf-objs-set! c-intf '())

    (set! targ-track-scheme-option? compiler-option-track-scheme)

    (targ-heap-begin!)

    (let ((proc (car procs)))
      (targ-use-prc proc #f)
      (targ-use-prc proc #t))

    (if (not targ-tree-shake?)
        (for-each (lambda (proc) (targ-use-prc proc #t)) (cdr procs)))

    ; scan and convert each procedure

    (if targ-info-port
      (begin
        (display "Dumping:" targ-info-port)
        (newline targ-info-port)))

    (let loop ()
      (if (not (queue-empty? targ-prc-objs-to-scan))
        (begin
          (targ-scan-procedure
           (queue-get! targ-prc-objs-to-scan)
           c-decls-queue)
          (loop))))

    (if targ-info-port
      (newline targ-info-port))

    (targ-use-obj module-descr)

    (targ-heap-dump
     output
     (queue->list c-decls-queue)
     c-inits
     (map (lambda (x) (cons (car x) (targ-use-obj (cdr x)))) c-objs)
     module-descr
     linker-name)

    (targ-heap-end!)

    (set! targ-track-scheme-option? #f)

    (lambda () output)))

(define targ-track-scheme-option? #f)

(define targ-tree-shake? #f)
(set! targ-tree-shake? #f) ;; no tree shaking

;;;----------------------------------------------------------------------------
;;
;; Object management

;; These routines are used to keep track of all the Scheme objects and
;; global variables that the compilation module uses.  These objects and
;; variables will have to be created before the module is run (either
;; at compile time, link time or run time).

(define targ-glo-vars #f)  ; table of global variables used
(define targ-lbl-alloc #f) ; label table allocation pointer
(define targ-cns-objs #f)  ; ordered table of pair objects
(define targ-sym-objs #f)  ; table of interned symbol objects
(define targ-key-objs #f)  ; table of interned keyword objects
(define targ-num-objs #f)  ; table of numbers that may be subtyped objects
(define targ-sub-objs #f)  ; ordered table of subtyped objects (vector, ...)
(define targ-prc-objs #f)  ; queue of procedure objects
(define targ-prc-objs-seen #f)    ; table of procedure objects seen
(define targ-prc-objs-to-scan #f) ; queue of procedure objects remaining to scan

(define targ-module-rd-res #f) ; set of resources read from
(define targ-module-wr-res #f) ; set of resources written to

(define targ-fp-cache #f) ; floating point number cache
(define targ-fr-cell #f)  ; cell of floating point region start

(define targ-sharing-table #f) ; table for compacting meta-information

(define targ-unique-name-table #f) ; table for generating unique procedure object names

(define (targ-heap-begin!)
  (set! targ-glo-vars         (make-table 'test: eq?))
  (set! targ-lbl-alloc        0)
  (set! targ-cns-objs         (make-ordered-table eq?))
  (set! targ-sym-objs         (make-table 'test: eq?))
  (set! targ-key-objs         (make-table 'test: eq?))
  (set! targ-num-objs         (make-table 'test: eqv?))
  (set! targ-sub-objs         (make-ordered-table eq?))
  (set! targ-prc-objs         (queue-empty))
  (set! targ-prc-objs-seen    (make-table 'test: eq?))
  (set! targ-prc-objs-to-scan (queue-empty))
  (set! targ-module-rd-res    (make-stretchable-vector #f))
  (set! targ-module-wr-res    (make-stretchable-vector #f))
  (set! targ-fp-cache #f)
  (set! targ-fr-cell #f)
  (set! targ-sharing-table    (make-table))
  (set! targ-unique-name-table (make-table))
  #f)

(define (targ-heap-end!)
  (set! targ-glo-vars #f)
  (set! targ-lbl-alloc #f)
  (set! targ-cns-objs #f)
  (set! targ-sym-objs #f)
  (set! targ-key-objs #f)
  (set! targ-num-objs #f)
  (set! targ-sub-objs #f)
  (set! targ-prc-objs #f)
  (set! targ-prc-objs-seen #f)
  (set! targ-prc-objs-to-scan #f)
  (set! targ-module-rd-res #f)
  (set! targ-module-wr-res #f)
  (set! targ-fp-cache #f)
  (set! targ-fr-cell #f)
  (set! targ-sharing-table #f)
  (set! targ-unique-name-table #f)
  #f)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-use-glo glo supply?)
  (if (symbol-object-interned? glo)
      (let ((x (table-ref targ-glo-vars glo #f)))
        (if x
            (begin
              (if supply?
                  (targ-rsrc-suppliers-set! (cdr x) '(""))
                  (targ-rsrc-demanders-set! (cdr x) '("")))
              (car x))
            (let* ((y (targ-make-cell #f))
                   (name (symbol->string glo))
                   (r (if supply?
                          (targ-make-rsrc name '() '(""))
                          (targ-make-rsrc name '("") '()))))
              (table-set! targ-glo-vars glo (cons y r))
              y)))
      (compiler-error
       "invalid uninterned global variable" glo)))

(define (targ-glo-rsrc g)
  (cddr g))

(define (targ-glo-not-supplied? g)
  (targ-rsrc-not-supplied? (targ-glo-rsrc g)))

(define (targ-glo-supplied? g)
  (targ-rsrc-supplied? (targ-glo-rsrc g)))

(define (targ-make-rsrc name demanders suppliers)
  (vector name demanders suppliers))

(define (targ-rsrc-name r)
  (vector-ref r 0))

(define (targ-rsrc-demanders r)
  (vector-ref r 1))

(define (targ-rsrc-demanders-set! r demanders)
  (vector-set! r 1 demanders))

(define (targ-rsrc-suppliers r)
  (vector-ref r 2))

(define (targ-rsrc-suppliers-set! r suppliers)
  (vector-set! r 2 suppliers))

(define (targ-rsrc-not-demanded? r)
  (null? (targ-rsrc-demanders r)))

(define (targ-rsrc-demanded? r)
  (not (null? (targ-rsrc-demanders r))))

(define (targ-rsrc-not-supplied? r)
  (null? (targ-rsrc-suppliers r)))

(define (targ-rsrc-supplied? r)
  (not (null? (targ-rsrc-suppliers r))))

(define (targ-rsrc-supplied-and-demanded? r)
  (and (targ-rsrc-demanded? r)
       (targ-rsrc-supplied? r)))

(define (targ-rsrc-supplied-and-not-demanded? r)
  (and (targ-rsrc-not-demanded? r)
       (targ-rsrc-supplied? r)))

(define (targ-union-list-of-rsrc list-of-rsrc)
  (let loop ((lst list-of-rsrc) (table '()))
    (if (null? lst)
      table
      (loop (cdr lst)
            (targ-union-rsrc (car lst) table)))))

(define (targ-union-rsrc lst1 lst2)
  (if (null? lst1)
    lst2
    (let* ((r1 (car lst1))
           (r1-name (targ-rsrc-name r1)))
      (if (null? lst2)
        (cons r1 (targ-union-rsrc (cdr lst1) lst2))
        (let* ((r2 (car lst2))
               (r2-name (targ-rsrc-name r2)))
          (cond ((string<? r1-name r2-name)
                 (cons r1 (targ-union-rsrc (cdr lst1) lst2)))
                ((string>? r1-name r2-name)
                 (cons r2 (targ-union-rsrc lst1 (cdr lst2))))
                (else
                 (cons (targ-make-rsrc
                         r1-name
                         (append (targ-rsrc-demanders r1)
                                 (targ-rsrc-demanders r2))
                         (append (targ-rsrc-suppliers r1)
                                 (targ-rsrc-suppliers r2)))
                       (targ-union-rsrc (cdr lst1) (cdr lst2))))))))))

(define (targ-difference-rsrc lst1 lst2)
  (if (null? lst1)
    '()
    (if (null? lst2)
      lst1
      (let* ((r1 (car lst1))
             (r1-name (targ-rsrc-name r1))
             (r2 (car lst2))
             (r2-name (targ-rsrc-name r2)))
        (cond ((string<? r1-name r2-name)
               (cons r1 (targ-difference-rsrc (cdr lst1) lst2)))
              ((string>? r1-name r2-name)
               (targ-difference-rsrc lst1 (cdr lst2)))
              (else
               (targ-difference-rsrc (cdr lst1) (cdr lst2))))))))

(define (targ-validate-rsrc lst)
  (for-each
    (lambda (r)
      (let ((name (targ-rsrc-name r))
            (demanders (targ-rsrc-demanders r))
            (suppliers (targ-rsrc-suppliers r)))

        (if (and all-warnings (> (length suppliers) 1))
          (begin
            (display "*** WARNING -- \"")
            (display name)
            (display "\" is defined more than once,")
            (newline)
            (display "***            defined in: ")
            (write suppliers)
            (newline)))

        (cond ((and (null? suppliers) (not (null? demanders)))
               (display "*** WARNING -- \"")
               (display name)
               (display "\" is not defined,")
               (newline)
               (display "***            referenced in: ")
               (write demanders)
               (newline))
              ((and all-warnings (null? demanders) (not (null? suppliers)))
               (display "*** WARNING -- \"")
               (display name)
               (display "\" is defined but not referenced,")
               (newline)
               (display "***            defined in: ")
               (write suppliers)
               (newline)))))
    lst))

(define (targ-validate-modules supply-modules demand-modules)
  (for-each
   (lambda (mod)
     (if (not (member mod supply-modules))
         (begin
           (display "*** WARNING -- dynamic loading of module ")
           (write mod)
           (newline))))
   demand-modules))

(define all-warnings #t)
(set! all-warnings #f)

(define (targ-use-sym sym)
  (targ-use-sym-key sym targ-sym-objs))

(define (targ-use-key key)
  (targ-use-sym-key key targ-key-objs))

(define (targ-use-sym-key obj obj-table)
  (let ((x (table-ref obj-table obj #f)))
    (or x
        (let ((y (targ-make-cell #f)))
          (table-set! obj-table obj y)
          y))))

(define (targ-sym-rsrc s)
  (targ-make-rsrc (symbol->string (car s)) '() '()))

(define (targ-key-rsrc k)
  (targ-make-rsrc (keyword-object->string (car k)) '() '()))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-use-obj obj)
  (let ((type (targ-obj-type obj)))
    (case type
      ((pair)
       (let ((x (ordered-table-lookup targ-cns-objs obj)))
         (or x
             (let ((y (ordered-table-enter
                       targ-cns-objs
                       obj
                       (lambda (obj i)
                         (list "CNS" i)))))
               (targ-use-obj (car obj))
               (targ-use-obj (cdr obj))
               y))))
      ((subtyped)
       (let ((subtype (targ-obj-subtype obj)))

         (define (use-subtyped-obj obj)
           (let ((x (ordered-table-lookup targ-sub-objs obj)))
             (or x
                 (let ((y (ordered-table-enter
                           targ-sub-objs
                           obj
                           (if (eq? subtype 'bigfixnum)
                             (lambda (obj i)
                               (list "BIGFIX" i (targ-c-long-long obj)))
                             (lambda (obj i)
                               (list "SUB" i))))))
                   (case subtype
                     ((symbol)
                      (targ-use-obj (symbol->string obj))
                      (targ-use-obj (symbol-object-hash obj)))
                     ((keyword)
                      (targ-use-obj (keyword-object->string obj))
                      (targ-use-obj (keyword-object-hash obj)))
                     ((vector)
                      (for-each targ-use-obj (vect->list obj)))
                     ((ratnum)
                      (targ-use-obj (targ-numerator obj))
                      (targ-use-obj (targ-denominator obj)))
                     ((cpxnum)
                      (targ-use-obj (targ-real-part obj))
                      (targ-use-obj (targ-imag-part obj)))
                     ((structure)
                      (for-each targ-use-obj (structure->list obj)))
                     ((box)
                      (targ-use-obj (unbox-object obj))))
                   y))))

         (case subtype
           ((procedure)
            (targ-use-prc obj #f))
           ((symbol)
            (if (symbol-object-interned? obj)
                (begin
                  (targ-use-sym obj)
                  (targ-c-id-sym2 (symbol->string obj)))
                (use-subtyped-obj obj)))
           ((keyword)
            (if (keyword-object-interned? obj)
                (begin
                  (targ-use-key obj)
                  (targ-c-id-key2 (keyword-object->string obj)))
                (use-subtyped-obj obj)))
           ((flonum bigfixnum bignum ratnum cpxnum)
            (let ((x (table-ref targ-num-objs obj #f)))
              (use-subtyped-obj
               (or x
                   (begin
                     (table-set! targ-num-objs obj obj)
                     obj)))))
           (else
            (use-subtyped-obj obj)))))
      ((boolean)
       (if (eq? obj #t) '("TRU") '("FAL")))
      ((null)
       '("NUL"))
      ((absent)
       '("ABSENT"))
      ((unused)
       '("UNUSED"))
      ((deleted)
       '("DELETED"))
      ((void)
       '("VOID"))
      ((unbound1)
       '("UNB1"))
      ((unbound2)
       '("UNB2"))
      ((eof)
       '("EOF"))
      ((optional)
       '("OPTIONAL"))
      ((key)
       '("KEYOBJ"))
      ((rest)
       '("REST"))
;;      ((body)
;;       '("BODYOBJ"))
      ((fixnum)
       (list "FIX" (targ-c-long obj)))
      ((char)
       (list "CHR" (targ-c-char obj)))
      (else
       (compiler-internal-error
         "targ-use-obj, unknown object 'obj'" obj)))))

(define (targ-use-prc proc supply?)
  (let* ((name (proc-obj-name proc))
         (p (if (proc-obj-code proc)
              (let ((x (table-ref targ-prc-objs-seen proc #f)))
                (if x
                  (cddr x)
                  (let* ((y (list 'prc (targ-make-cell #f)))
                         (z (cons proc (cons #f y))))
                    (table-set! targ-prc-objs-seen proc z)
                    (queue-put! targ-prc-objs z)
                    (queue-put! targ-prc-objs-to-scan z)
                    y)))
              #f)))
    (if (proc-obj-primitive? proc)
      (begin
        (targ-use-glo (string->symbol name) supply?)
        (or p
            (targ-c-id-prm2 name)))
      p)))

(define (targ-heap-ref-obj obj)

  (define (err)
    (compiler-internal-error
      "targ-heap-ref-obj, object was not scanned 'obj'" obj))

  (let ((type (targ-obj-type obj)))
    (case type
      ((pair)
       (let ((x (ordered-table-lookup targ-cns-objs obj)))
         (if x
           (cons "REF_CNS" (cdr x))
           (err))))
      ((subtyped)
       (let ((subtype (targ-obj-subtype obj)))

         (define (ref-subtyped-obj obj)
           (let ((x (ordered-table-lookup targ-sub-objs obj)))
             (if x
               (cons (if (eq? subtype 'bigfixnum)
                       "REF_BIGFIX"
                       "REF_SUB")
                     (cdr x))
               (err))))

         (case subtype
           ((symbol)
            (if (symbol-object-interned? obj)
                (let ((x (table-ref targ-sym-objs obj #f)))
                  (if x
                      (list "REF_SYM"
                            x
                            (targ-c-id-sym (symbol->string obj))) ;; TODO: remove this useless argument to ___REF_SYM
                      (err)))
                (ref-subtyped-obj obj)))
           ((keyword)
            (if (keyword-object-interned? obj)
                (let ((x (table-ref targ-key-objs obj #f)))
                  (if x
                      (list "REF_KEY"
                            x
                            (targ-c-id-key (keyword-object->string obj))) ;; TODO: remove this useless argument to ___REF_KEY
                      (err)))
                (ref-subtyped-obj obj)))
           ((flonum bigfixnum bignum ratnum cpxnum)
            (let ((x (table-ref targ-num-objs obj #f)))
              (if x
                (ref-subtyped-obj x)
                (err))))
           ((procedure)
            (let ((x (table-ref targ-prc-objs-seen obj #f)))
              (if x
                  (cons "REF_PRC" (cdddr x))
                  (err))))
           (else
            (ref-subtyped-obj obj)))))
      ((boolean)
       (if (eq? obj #t) '("REF_TRU") '("REF_FAL")))
      ((null)
       '("REF_NUL"))
      ((absent)
       '("REF_ABSENT"))
      ((unused)
       '("REF_UNUSED"))
      ((deleted)
       '("REF_DELETED"))
      ((void)
       '("REF_VOID"))
      ((unbound1)
       '("REF_UNB1"))
      ((unbound2)
       '("REF_UNB2"))
      ((eof)
       '("REF_EOF"))
      ((optional)
       '("REF_OPTIONAL"))
      ((key)
       '("REF_KEYOBJ"))
      ((rest)
       '("REF_REST"))
;;      ((body)
;;       '("REF_BODYOBJ"))
      ((fixnum)
       (list "REF_FIX" obj))
      ((char)
       (list "REF_CHR" (targ-c-char obj)))
      (else
       (compiler-internal-error
         "targ-heap-ref-obj, unknown object 'obj'" obj)))))

;;;----------------------------------------------------------------------------

(define (targ-link-info file)
  (let ((in (open-input-file*-preserving-case file)))
    (and in
         (let* ((first-line
                 (read-line* in))
                (info
                 (and (string=? targ-generated-c-file-first-line first-line)
                      (read in))))
           (close-input-port in)
           (and (pair? info)
                (pair? (cdr info))
                (pair? (cadr info))
                (equal? (car info) (compiler-version))
                (equal? (car (cadr info)) (target-name targ-target))
                info)))))

(define (targ-set-of lst)
  (let loop ((lst lst) (result '()))
    (if (null? lst)
        (reverse result)
        (let ((x (car lst)))
          (loop (cdr lst)
                (if (member x result)
                    result
                    (cons x result)))))))

(define (targ-link extension? inputs output linker-name warnings?)
  (with-exception-handling
    (lambda ()
      (let* ((root
               (path-strip-extension output))
             (name
               (or linker-name
                   (path-strip-directory root)))
             (input-mods
               (map targ-get-mod inputs))
             (input-mods-and-flags
               (append-lists (map targ-mod-mods-and-flags input-mods)))
             (supply-modules
              (targ-set-of
               (append-lists (map targ-mod-supply-modules input-mods))))
             (demand-modules
              (targ-set-of
               (append-lists (map targ-mod-demand-modules input-mods))))
             (sym-rsrc
               (targ-union-list-of-rsrc
                 (map targ-mod-sym-rsrc input-mods)))
             (key-rsrc
               (targ-union-list-of-rsrc
                 (map targ-mod-key-rsrc input-mods)))
             (glo-rsrc
               (targ-union-list-of-rsrc
                 (map targ-mod-glo-rsrc input-mods))))

        (define (combine-meta-info input-mods)
          (let loop ((lst input-mods)
                     (last-script-line #f)
                     (rev-ld-options-prelude '())
                     (rev-ld-options '())
                     (rev-pkg-config '())
                     (rev-pkg-config-path '()))
            (if (pair? lst)
                (let ((module-meta-info
                       (targ-mod-meta-info (car lst))))

                  (define (get key)
                    (and (pair? module-meta-info)
                         (assq key module-meta-info)))

                  (let ((script-line
                         (cond ((get 'script-line)
                                =>
                                (lambda (pair)
                                  (let ((x (cdr pair)))
                                    (if (pair? x) (car x) x))))
                               (else
                                #f)))
                        (ld-options-prelude
                         (cond ((get 'ld-options-prelude)
                                =>
                                cdr)
                               (else
                                '())))
                        (ld-options
                         (cond ((get 'ld-options)
                                =>
                                cdr)
                               (else
                                '())))
                        (pkg-config
                         (cond ((get 'pkg-config)
                                =>
                                cdr)
                               (else
                                '())))
                        (pkg-config-path
                         (cond ((get 'pkg-config-path)
                                =>
                                cdr)
                               (else
                                '()))))
                    (loop (cdr lst)
                          (or script-line
                              last-script-line)
                          (append (reverse ld-options-prelude)
                                  rev-ld-options-prelude)
                          (append (reverse ld-options)
                                  rev-ld-options)
                          (append (reverse pkg-config)
                                  rev-pkg-config)
                          (append (reverse pkg-config-path)
                                  rev-pkg-config-path))))
                (append (if last-script-line
                            (list (list 'script-line last-script-line))
                            '())
                        (if (pair? rev-ld-options-prelude)
                            (list (cons 'ld-options-prelude
                                        (reverse rev-ld-options-prelude)))
                            '())
                        (if (pair? rev-ld-options)
                            (list (cons 'ld-options
                                        (reverse rev-ld-options)))
                            '())
                        (if (pair? rev-pkg-config)
                            (list (cons 'pkg-config
                                        (reverse rev-pkg-config)))
                            '())
                        (if (pair? rev-pkg-config-path)
                            (list (cons 'pkg-config-path
                                        (reverse rev-pkg-config-path)))
                            '())))))

        (targ-link-aux
          extension?
          output
          name
          supply-modules
          demand-modules
          input-mods-and-flags
          (if extension?
            (list (list (targ-mod-name (car input-mods))))
            '())
          (if extension?
            (append-lists (map targ-mod-mods-and-flags (cdr input-mods)))
            input-mods-and-flags)
          (if extension?
            (targ-mod-sym-rsrc (car input-mods))
            '())
          (if extension?
            (targ-mod-key-rsrc (car input-mods))
            '())
          (if extension?
            (targ-mod-glo-rsrc (car input-mods))
            '())
          sym-rsrc
          key-rsrc
          glo-rsrc
          (combine-meta-info input-mods)
          warnings?)

        output))))

(define (targ-make-mod name
                       supply-modules
                       demand-modules
                       mods-and-flags
                       sym-rsrc
                       key-rsrc
                       glo-rsrc
                       meta-info)
  (vector name
          supply-modules
          demand-modules
          mods-and-flags
          sym-rsrc
          key-rsrc
          glo-rsrc
          meta-info))

(define (targ-mod-name module-info)
  (vector-ref module-info 0))

(define (targ-mod-supply-modules module-info)
  (vector-ref module-info 1))

(define (targ-mod-demand-modules module-info)
  (vector-ref module-info 2))

(define (targ-mod-mods-and-flags module-info)
  (vector-ref module-info 3))

(define (targ-mod-sym-rsrc module-info)
  (vector-ref module-info 4))

(define (targ-mod-key-rsrc module-info)
  (vector-ref module-info 5))

(define (targ-mod-glo-rsrc module-info)
  (vector-ref module-info 6))

(define (targ-mod-meta-info module-info)
  (vector-ref module-info 7))

(define targ-generated-c-file-first-line
  (string-append "#ifdef " c-id-prefix "LINKER_INFO"))

(define (targ-get-mod file-and-flags-and-link-info)
  (let ((file (car file-and-flags-and-link-info))
        (flags (cadr file-and-flags-and-link-info))
        (link-info (list->vector (caddr file-and-flags-and-link-info))))

    (define (combine-flags flags1 flags2)
      (append flags1 flags2))

    (let* ((name (vector-ref link-info 2))
           (supply-modules (vector-ref link-info 3))
           (demand-modules (vector-ref link-info 4))
           (mods (map (lambda (x)
                        (cons (car x) (combine-flags flags (cdr x))))
                      (vector-ref link-info 5)))
           (syms (vector-ref link-info 6))
           (keys (vector-ref link-info 7))
           (glos-supplied-and-demanded (vector-ref link-info 8))
           (glos-supplied-and-not-demanded (vector-ref link-info 9))
           (glos-not-supplied (vector-ref link-info 10))
           (meta-info (vector-ref link-info 11)))
      (targ-make-mod
       name
       supply-modules
       demand-modules
       mods
       (map (lambda (sym)
              (targ-make-rsrc sym '() '()))
            syms)
       (map (lambda (key)
              (targ-make-rsrc key '() '()))
            keys)
       (targ-union-rsrc
        (map (lambda (glo)
               (targ-make-rsrc glo (list file) (list file)))
             glos-supplied-and-demanded)
        (targ-union-rsrc
         (map (lambda (glo)
                (targ-make-rsrc glo '() (list file)))
              glos-supplied-and-not-demanded)
         (map (lambda (glo)
                (targ-make-rsrc glo (list file) '()))
              glos-not-supplied)))
       meta-info))))

;;;----------------------------------------------------------------------------
;;
;; Dumping of objects

;; These routines write out the C code that represents the Scheme objects
;; contained in the compilation module.

(define (targ-heap-dump filename c-decls c-inits c-objs module-descr linker-name)
  (let* ((sym-list
          (targ-sort (table->list targ-sym-objs) symbol->string))
         (key-list
          (targ-sort (table->list targ-key-objs) keyword-object->string))
         (glo-list
          (targ-sort (table->list targ-glo-vars) symbol->string))
         (cns-list
          (ordered-table->list targ-cns-objs))
         (sub-list
          (ordered-table->list targ-sub-objs))
         (prc-list
          (queue->list targ-prc-objs))
         (prm-list
          (targ-extract-primitives prc-list))
         (sym-rsrc
          (map targ-sym-rsrc sym-list))
         (key-rsrc
          (map targ-key-rsrc key-list))
         (glo-rsrc
          (map targ-glo-rsrc glo-list))
         (ofd-count
          (targ-get-ofd-count prc-list))
         (supply-modules
          (vector-ref module-descr 0))
         (demand-modules
          (vector-ref module-descr 1))
         (module-name
          (symbol->string
           (vector-ref supply-modules (- (vector-length supply-modules) 1))))
         (module-meta-info
          (vector-ref module-descr 2)))

    (targ-start-dump
     filename
     module-name
     (map symbol->string (vector->list supply-modules))
     (map symbol->string (vector->list demand-modules))
     (list (cons module-name ;; module name
                 '()))       ;; flags
     sym-rsrc
     key-rsrc
     glo-rsrc
     module-meta-info)

    (targ-dump-module-info
     module-name
     linker-name
     #f
     #f
     module-meta-info)

    (targ-define-count "SYMCOUNT" (length sym-list))
    (targ-define-count "KEYCOUNT" (length key-list))
    (targ-define-count "GLOCOUNT" (length glo-list))
    (targ-define-count "SUPCOUNT" (length (keep targ-glo-supplied? glo-list)))
    (targ-define-count "CNSCOUNT" (length cns-list))
    (targ-define-count "SUBCOUNT" (length sub-list))
    (targ-define-count "LBLCOUNT" targ-lbl-alloc)
    (targ-define-count "OFDCOUNT" ofd-count)
    (targ-macro-definition '("MODDESCR") (targ-heap-ref-obj module-descr))
    (targ-display "#include \"gambit.h\"")
    (targ-line)

    (targ-dump-sym-key-glo-comp sym-list key-list glo-list)
    (targ-dump-cns cns-list)
    (targ-dump-sub sub-list)
    (targ-dump-prc prc-list c-objs c-decls ofd-count)
    (targ-dump-mod prm-list c-inits sym-list key-list)
    (targ-end-dump)))

(define (targ-link-aux
          extension?
          filename
          name
          supply-modules
          demand-modules
          all-mods-and-flags
          old-mods-and-flags
          new-mods-and-flags
          old-sym-rsrc
          old-key-rsrc
          old-glo-rsrc
          sym-rsrc
          key-rsrc
          glo-rsrc
          linkfile-meta-info
          warnings?)

  (if warnings?
      (begin
        (targ-validate-rsrc glo-rsrc)
        (targ-validate-modules supply-modules demand-modules)))

  (let* ((old-sym-glo-rsrc
          (targ-union-rsrc old-sym-rsrc old-glo-rsrc))
         (new-sym-glo-rsrc
           (targ-difference-rsrc
             (targ-union-rsrc sym-rsrc glo-rsrc)
             old-sym-glo-rsrc))
         (new-key-rsrc
           (targ-difference-rsrc
             key-rsrc
             old-key-rsrc)))

    (targ-start-dump
     filename
     name
     supply-modules
     demand-modules
     all-mods-and-flags
     sym-rsrc
     key-rsrc
     glo-rsrc
     linkfile-meta-info)

    (targ-dump-module-info
     name
     name
     #t
     extension?
     linkfile-meta-info)

    (targ-display "#include \"gambit.h\"")
    (targ-line)

    (targ-dump-linkfile old-mods-and-flags new-mods-and-flags)
    (targ-dump-sym-key-glo-link
      old-sym-glo-rsrc
      old-key-rsrc
      new-sym-glo-rsrc
      new-key-rsrc)
    (targ-end-dump)))

(define (targ-dump-linkfile old-mods-and-flags new-mods-and-flags)
  (targ-dump-section "BEGIN_OLD_LNK" "END_OLD_LNK" #f old-mods-and-flags
    (lambda (i x)
      (targ-code* (list "DEF_OLD_LNK" (targ-linker-id (car x))))))
  (targ-dump-section "BEGIN_NEW_LNK" "END_NEW_LNK" #f new-mods-and-flags
    (lambda (i x)
      (targ-code* (list "DEF_NEW_LNK" (targ-linker-id (car x))))))
  (targ-dump-section "BEGIN_LNK" "END_LNK" #t (append old-mods-and-flags new-mods-and-flags)
    (lambda (i x)
      (targ-code* (list (if (cond ((assq 'preload (cdr x)) => cdr)
                                  (else #t))
                            "DEF_LNK"
                            "DEF_LNK_NOPRELOAD")
                        (targ-linker-id (car x)))))))

(define (targ-start-dump
         filename
         name
         supply-modules
         demand-modules
         mods-and-flags
         sym-rsrc
         key-rsrc
         glo-rsrc
         meta-info)

  (set! targ-port (open-output-file-preserving-case filename))
  (set! targ-line-size 0)
  (set! targ-line-number 1)
  (set! targ-filename filename)
  (set! targ-current-line-number 1)
  (set! targ-current-filename filename)
  (set! targ-source-line-number #f)
  (set! targ-source-filename #f)
  (set! targ-in-macro-definition? #f)

  (targ-display targ-generated-c-file-first-line)
  (targ-line)

  (targ-display "; File: ")
  (targ-display-c-string (path-strip-directory filename))
  (targ-display ", produced by Gambit ")
  (targ-display (compiler-version-string))
  (targ-line)

  (targ-display "(")
  (targ-line)

  (targ-display (compiler-version))
  (targ-line)

  (write (list (target-name targ-target)) targ-port)
  (targ-line)

  (write name targ-port)
  (targ-line)

  (write supply-modules targ-port)
  (targ-line)

  (write demand-modules targ-port)
  (targ-line)

  (write mods-and-flags targ-port)
  (targ-line)

  (targ-write-rsrc-names 'symbols
                         sym-rsrc)

  (targ-write-rsrc-names 'keywords
                         key-rsrc)

  (targ-write-rsrc-names 'globals-s-d
                         (keep targ-rsrc-supplied-and-demanded? glo-rsrc))

  (targ-write-rsrc-names 'globals-s-nd
                         (keep targ-rsrc-supplied-and-not-demanded? glo-rsrc))

  (targ-write-rsrc-names 'globals-ns
                         (keep targ-rsrc-not-supplied? glo-rsrc))

  (targ-display "( ")
  (targ-write-escaped 'meta-info)
  (targ-line)
  (let loop1 ((lst meta-info))
    (if (pair? lst)
        (let* ((key-attribs (car lst))
               (key (car key-attribs))
               (attribs (cdr key-attribs)))
          (targ-display "(")
          (write key targ-port)
          (if (not (or (pair? attribs) (null? attribs)))
              (begin
                (targ-display " .")
                (set! attribs (list attribs))))
          (targ-line)
          (let loop2 ((attribs attribs))
            (if (pair? attribs)
                (let ((attrib (car attribs)))
                  (targ-display " ")
                  (targ-write-escaped key)
                  (write attrib targ-port)
                  (targ-line)
                  (loop2 (cdr attribs)))))
          (targ-display ")")
          (targ-line)
          (loop1 (cdr lst)))))
  (targ-display ") ")
  (targ-write-escaped 'meta-info)
  (targ-line)

  (targ-display ")")
  (targ-line)

  (targ-display "#else")
  (targ-line))

(define (targ-end-dump)
  (targ-line)
  (targ-display "#endif")
  (targ-line)
  (close-output-port targ-port))

(define (targ-sort lst ->string)
  (sort-list
    lst
    (lambda (x y)
      (string<? (->string (car x)) (->string (car y))))))

(define (targ-write-rsrc-names marker lst)
  (targ-display "( ")
  (targ-write-escaped marker)
  (targ-line)
  (for-each
    (lambda (r)
      (let ((name (targ-rsrc-name r)))
        (write name targ-port)
        (targ-line)))
    lst)
  (targ-display ") ")
  (targ-write-escaped marker)
  (targ-line))

(define (targ-write-escaped obj)
  ;; writes obj so that it can't be part of valid C code (even in a
  ;; C string or mutliline C comment)
  (targ-display "#|*/\"*/\"")
  (write obj targ-port)
  (targ-display "|#"))

(define (targ-dump-module-info name linker-name linkfile? extension? meta-info)

  (targ-macro-definition '("VERSION")
                         (compiler-version))

  (targ-macro-definition (if linkfile?
                             '("LINKFILE_NAME")
                             '("MODULE_NAME"))
                         (targ-c-string name))

  (targ-macro-definition '("LINKER_ID")
                         (targ-linker-id linker-name))

  (if linkfile?

      (targ-macro-definition (if extension?
                                 '("INCREMENTAL_LINKFILE")
                                 '("FLAT_LINKFILE"))
                             #f)

      (targ-macro-definition '("MH_PROC")
                             (targ-c-id-host name)))

  (let ((script-line
         (cond ((assq 'script-line meta-info)
                =>
                (lambda (pair)
                  (let ((x (cdr pair)))
                    (if (pair? x) (car x) x))))
               (else
                #f))))
    (targ-macro-definition '("SCRIPT_LINE")
                           (if script-line
                               (targ-c-string script-line)
                               0))))

(define (targ-dump-sym-key-glo-comp sym-list key-list glo-list)

  (if (not (null? sym-list))
    (begin
      (targ-line)
      (for-each
        (lambda (s)
          (let ((sym (car s)))
            (if (symbol-object-interned? sym)
                (let ((name (symbol->string sym)))
                  (targ-code* (list "NEED_SYM" (targ-c-id-sym name)))))))
        sym-list)))

  (if (not (null? key-list))
    (begin
      (targ-line)
      (for-each
        (lambda (k)
          (let ((key (car k)))
            (if (keyword-object-interned? key)
                (let ((name (keyword-object->string key)))
                  (targ-code* (list "NEED_KEY" (targ-c-id-key name)))))))
        key-list)))

  (if (not (null? glo-list))
    (begin
      (targ-line)
      (for-each
        (lambda (g)
          (let ((name (symbol->string (car g))))
            (targ-code* (list "NEED_GLO" (targ-c-id-glo name)))))
        glo-list)))

  (targ-dump-section "BEGIN_SYM" "END_SYM" #f sym-list
    (lambda (i s)
      (targ-cell-set! (cdr s) i)
      (let ((name (symbol->string (car s))))
        (targ-code* (list "DEF_SYM"
                          i
                          (targ-c-id-sym name)
                          (targ-c-string name))))))

  (targ-dump-section #f #f #f sym-list
    (lambda (i s)
      (let ((name (symbol->string (car s))))
        (targ-macro-definition (targ-c-id-sym2 name)
                               (list "SYM"
                                     i
                                     (targ-c-id-sym name))))))

  (targ-dump-section "BEGIN_KEY" "END_KEY" #f key-list
    (lambda (i k)
      (targ-cell-set! (cdr k) i)
      (let ((name (keyword-object->string (car k))))
        (targ-code* (list "DEF_KEY"
                          i
                          (targ-c-id-key name)
                          (targ-c-string name))))))

  (targ-dump-section #f #f #f key-list
    (lambda (i k)
      (let ((name (keyword-object->string (car k))))
        (targ-macro-definition (targ-c-id-key2 name)
                               (list "KEY"
                                     i
                                     (targ-c-id-key name))))))

  (let ((glos
         (append (keep targ-glo-supplied? glo-list)
                 (keep targ-glo-not-supplied? glo-list))))

    (targ-dump-section "BEGIN_GLO" "END_GLO" #f glos
      (lambda (i g)
        (targ-cell-set! (cadr g) i)
        (let ((name (symbol->string (car g))))
          (targ-code* (list "DEF_GLO"
                            i
                            (targ-c-string name))))))

    (targ-dump-section #f #f #f glos
      (lambda (i g)
        (let ((name (symbol->string (car g))))
          (targ-macro-definition (targ-c-id-glo2 name)
                                 (list "GLO"
                                       i
                                       (targ-c-id-glo name)))
          (targ-macro-definition (targ-c-id-prm2 name)
                                 (list "PRM"
                                       i
                                       (targ-c-id-glo name))))))))

(define (targ-dump-sym-key-glo-link
          old-sym-glo-rsrc
          old-key-rsrc
          new-sym-glo-rsrc
          new-key-rsrc)

  (targ-dump-section "BEGIN_OLD_KEY" "END_OLD_KEY" #f old-key-rsrc
    (lambda (i r)
      (let* ((name (targ-rsrc-name r))
             (key (targ-c-id-key name)))
        (targ-code* (list "DEF_OLD_KEY" key)))))

  (targ-dump-section "BEGIN_OLD_SYM_GLO" "END_OLD_SYM_GLO" #f old-sym-glo-rsrc
    (lambda (i r)
      (let* ((name (targ-rsrc-name r))
             (sym (targ-c-id-sym name))
             (glo (targ-c-id-glo name)))
        (targ-code* (list "DEF_OLD_SYM_GLO" sym glo)))))

  (let ((key-count 0) (prev-key 0) (sym-count 0) (prev-sym 0))

    (targ-dump-section "BEGIN_NEW_KEY" "END_NEW_KEY" #f new-key-rsrc
      (lambda (i r)
        (let* ((name (targ-rsrc-name r))
               (key (targ-c-id-key name))
               (id (targ-sub-name key-count)))
          (targ-dump-nstring name id)
          (targ-code*
            (list "DEF_NEW_KEY" prev-key key id (targ-hash name)))
          (set! key-count (+ key-count 1))
          (set! prev-key key))))

    (targ-line)
    (targ-code* '("BEGIN_NEW_SYM_GLO"))
    (for-each
      (lambda (r)
        (let* ((name (targ-rsrc-name r))
               (sym (targ-c-id-sym name))
               (glo (targ-c-id-glo name))
               (id (targ-sub-name (+ key-count sym-count))))
          (targ-dump-nstring name id)
          (targ-code*
            (list (if (targ-rsrc-supplied? r)
                    "DEF_NEW_SYM_GLO_SUP"
                    "DEF_NEW_SYM_GLO")
                  prev-sym
                  sym
                  id
                  (targ-hash name)
                  glo))
          (set! sym-count (+ sym-count 1))
          (set! prev-sym sym)))
      new-sym-glo-rsrc)
    (targ-code* (list "END_NEW_SYM_GLO" prev-sym prev-key))))

(define (targ-define-count name n)
  (if (not (= n 0))
      (targ-macro-definition (list name) n)))

(define (targ-define-prefix var)
  (targ-display "#undef ")
  (targ-code var)
  (targ-line)
  (targ-display "#define ")
  (targ-code var))

(define (targ-dump-section begin-name end-name comma? lst dump)
  (if (not (null? lst))
    (begin
      (targ-line)
      (if begin-name (targ-code* (list begin-name)))
      (if comma? (targ-display " "))
      (dump 0 (car lst))
      (let loop ((i 1) (lst (cdr lst)))
        (if (not (null? lst))
          (begin
            (if comma? (targ-display ","))
            (dump i (car lst))
            (loop (+ i 1) (cdr lst)))))
      (if end-name (targ-code* (list end-name))))))

(define (targ-dump-cns objs)
  (targ-dump-section "BEGIN_CNS" "END_CNS" #t objs
    (lambda (i x)
      (let ((obj (car x)) (i (caddr x)))
        (targ-code* (list "DEF_CNS"
                          (targ-heap-ref-obj (car obj))
                          (targ-heap-ref-obj (cdr obj))))))))

(define (targ-dump-sub objs)
  (if (not (null? objs))
    (begin
      (targ-line)
      (for-each (lambda (x)
                  (let ((obj (car x)) (id (targ-sub-name (caddr x))))
                    (let ((subtype (targ-obj-subtype obj)))
                      (case subtype
                        ((symbol)
                         (targ-dump-symbol obj id))
                        ((keyword)
                         (targ-dump-keyword obj id))
                        ((string)
                         (targ-dump-string obj id))
                        ((bignum)
                         (targ-dump-bignum obj id))
                        ((bigfixnum)
                         (targ-dump-bigfixnum obj id))
                        ((ratnum)
                         (targ-dump-ratnum obj id))
                        ((flonum)
                         (targ-dump-flonum obj id))
                        ((cpxnum)
                         (targ-dump-cpxnum obj id))
                        ((vector
                          s8vector
                          u8vector
                          s16vector
                          u16vector
                          s32vector
                          u32vector
                          s64vector
                          u64vector
                          f32vector
                          f64vector
                          structure
                          box)
                         (targ-dump-vector subtype obj id))
                        (else
                         (compiler-internal-error
                           "targ-dump, unknown subtype" subtype))))))
                objs)
      (targ-dump-section "BEGIN_SUB" "END_SUB" #t objs
        (lambda (i x)
          (let ((id (targ-sub-name (caddr x))))
            (targ-code* (list "DEF_SUB" id)))))
      (targ-line))))

(define (targ-vector-like-object def-name id chunk-name elems convert cycle)
  (let ((len (length elems)))
    (targ-code* (list def-name id (targ-c-unsigned-long len)))
    (targ-vector-like-object-body chunk-name elems convert cycle)))

(define (targ-vector-like-object-body chunk-name elems convert cycle)
  (let ((len (length elems)))
    (let loop1 ((i 0) (elems elems))
      (if (<= i len)
        (let ((n (min cycle (- len i))))
          (let loop2 ((j (- n 1)) (elems elems) (lst '()))
            (if (>= j 0)
              (loop2 (- j 1) (cdr elems) (cons (convert (car elems)) lst))
              (begin
                (targ-display "               ")
                (targ-code* (cons chunk-name (cons n (reverse lst))))
                (if (= n cycle) (loop1 (+ i n) elems))))))))))

(define (targ-dump-symbol obj id)
  (targ-code* (list "DEF_SUB_SYM" id
                    (targ-heap-ref-obj (symbol->string obj))
                    (targ-heap-ref-obj (symbol-object-hash obj)))))

(define (targ-dump-keyword obj id)
  (targ-code* (list "DEF_SUB_KEY" id
                    (targ-heap-ref-obj (keyword-object->string obj))
                    (targ-heap-ref-obj (keyword-object-hash obj)))))

(define (targ-dump-string obj id)
  (targ-vector-like-object "DEF_SUB_STR" id 'str
                           (str->list obj)
                           targ-c-char
                           targ-max-word-size))

(define (targ-dump-nstring obj id)
  (targ-vector-like-object "DEF_SUB_NSTR" id 'nstr
                           (str->list obj)
                           targ-c-char
                           targ-max-word-size))

(define (targ-dump-bignum obj id)
  (targ-vector-like-object "DEF_SUB_BIG" id 'big
                           (targ-bignum-digits obj)
                           targ-c-hex-u32
                           (quotient targ-max-adigit-width
                                     targ-min-adigit-width)))

(define (targ-dump-bigfixnum obj id)
  (targ-vector-like-object "DEF_SUB_BIGFIX" id 'bigfix
                           (targ-bignum-digits obj)
                           targ-c-hex-u32
                           (quotient targ-max-adigit-width
                                     targ-min-adigit-width)))

(define (targ-dump-ratnum obj id)
  (targ-code* (list "DEF_SUB_RAT" id
                    (targ-heap-ref-obj (targ-numerator obj))
                    (targ-heap-ref-obj (targ-denominator obj)))))

(define (targ-dump-flonum obj id)
  (let ((hi-lo-bits (targ-f64->hi-lo-bits obj)))
    (targ-code* (list "DEF_SUB_FLO" id
                      (targ-c-hex-u32 (car hi-lo-bits))
                      (targ-c-hex-u32 (cdr hi-lo-bits))))))

(define (targ-dump-cpxnum obj id)
  (targ-code* (list "DEF_SUB_CPX" id
                    (targ-heap-ref-obj (targ-real-part obj))
                    (targ-heap-ref-obj (targ-imag-part obj)))))

(define (targ-dump-vector subtype obj id)
  (let ((def-name
          (case subtype
            ((s8vector)  "DEF_SUB_S8VEC")
            ((u8vector)  "DEF_SUB_U8VEC")
            ((s16vector) "DEF_SUB_S16VEC")
            ((u16vector) "DEF_SUB_U16VEC")
            ((s32vector) "DEF_SUB_S32VEC")
            ((u32vector) "DEF_SUB_U32VEC")
            ((s64vector) "DEF_SUB_S64VEC")
            ((u64vector) "DEF_SUB_U64VEC")
            ((f32vector) "DEF_SUB_F32VEC")
            ((f64vector) "DEF_SUB_F64VEC")
            ((structure) "DEF_SUB_STRUCTURE")
            ((box)       "DEF_SUB_BOX")
            (else        "DEF_SUB_VEC")))
        (chunk-name
          (case subtype
            ((s8vector)  's8vec)
            ((u8vector)  'u8vec)
            ((s16vector) 's16vec)
            ((u16vector) 'u16vec)
            ((s32vector) 's32vec)
            ((u32vector) 'u32vec)
            ((s64vector) 's64vec)
            ((u64vector) 'u64vec)
            ((f32vector) 'f32vec)
            ((f64vector) 'f64vec)
            (else        'vec)))
        (elems
          (case subtype
            ((s8vector)  (s8vect->list obj))
            ((u8vector)  (u8vect->list obj))
            ((s16vector) (s16vect->list obj))
            ((u16vector) (u16vect->list obj))
            ((s32vector) (s32vect->list obj))
            ((u32vector) (u32vect->list obj))
            ((s64vector) (s64vect->list obj))
            ((u64vector) (u64vect->list obj))
            ((f32vector) (f32vect->list obj))
            ((f64vector) (f64vect->list obj))
            ((structure) (structure->list obj))
            ((box)       (list (unbox-object obj)))
            (else        (vect->list obj))))
        (convert
          (case subtype
            ((s8vector)  (lambda (x)
                           (targ-c-hex x)))
            ((u8vector)  (lambda (x)
                           (targ-c-hex-u32 x)))
            ((s16vector) (lambda (x)
                           (targ-c-hex x)))
            ((u16vector) (lambda (x)
                           (targ-c-hex-u32 x)))
            ((s32vector) (lambda (x)
                           (targ-c-hex x)))
            ((u32vector) (lambda (x)
                           (targ-c-hex-u32 x)))
            ((s64vector) (lambda (x)
                           (let ((hi-lo-bits (targ-s64->hi-lo-bits x)))
                             (list 'append
                                   (targ-c-hex (car hi-lo-bits))
                                   ","
                                   (targ-c-hex-u32 (cdr hi-lo-bits))))))
            ((u64vector) (lambda (x)
                           (let ((hi-lo-bits (targ-u64->hi-lo-bits x)))
                             (list 'append
                                   (targ-c-hex-u32 (car hi-lo-bits))
                                   ","
                                   (targ-c-hex-u32 (cdr hi-lo-bits))))))
            ((f32vector) (lambda (x)
                           (targ-c-hex-u32 (targ-f32->bits x))))
            ((f64vector) (lambda (x)
                           (let ((hi-lo-bits (targ-f64->hi-lo-bits x)))
                             (list 'append
                                   (targ-c-hex-u32 (car hi-lo-bits))
                                   ","
                                   (targ-c-hex-u32 (cdr hi-lo-bits))))))
            (else        targ-heap-ref-obj)))
        (cycle
          (case subtype
            ((s8vector)  targ-max-word-size)
            ((u8vector)  targ-max-word-size)
            ((s16vector) (quotient targ-max-word-size 2))
            ((u16vector) (quotient targ-max-word-size 2))
            ((s32vector) (quotient targ-max-word-size 4))
            ((u32vector) (quotient targ-max-word-size 4))
            ((s64vector) (quotient targ-max-word-size 8))
            ((u64vector) (quotient targ-max-word-size 8))
            ((f32vector) (quotient targ-max-word-size 4))
            ((f64vector) (quotient targ-max-word-size 8))
            (else        1))))
    (targ-vector-like-object def-name id chunk-name elems convert cycle)))

(define (targ-dump-prc objs c-objs c-decls ofd-count)

  (if (pair? objs)
    (begin
      (targ-line)
      (for-each
       (lambda (obj)
         (let* ((proc (car obj))
                (p (cdr obj))
                (c-name (proc-obj-c-name proc)))
           (if c-name
               (targ-macro-definition (cons 'c-lbl- c-name) (caddr p)))))
       objs)))

  (if (pair? c-objs)
    (begin
      (targ-line)
      (let loop ((i 0) (lst c-objs))
        (if (pair? lst)
          (let ((x (car lst)))
            (targ-macro-definition (car x) (cdr x))
            (loop (+ i 1) (cdr lst)))))))

  (if (pair? c-decls)
    (begin
      (targ-line)
      (for-each
        (lambda (x)
          (targ-code x)
          (targ-line))
        c-decls)))

  (targ-line)

  (targ-begin-cod targ-module-rd-res targ-module-wr-res
                  "BEGIN_M_COD" 'md- 'mr- 'mw-
                  "BEGIN_M_HLBL" "DEF_M_HLBL_INTRO" "DEF_M_HLBL" "END_M_HLBL"
                  objs)

  (targ-line)

  (targ-code* '("BEGIN_M_SW"))

  (targ-line)

  (for-each targ-dump-cod objs)

  (targ-code* '("END_M_SW"))

  (targ-end-cod "END_M_COD")

  (targ-line)

  (targ-code* '("BEGIN_LBL"))

  (let ((i 0))
    (for-each
     (lambda (obj)
       (let* ((proc (car obj))
              (c-name (proc-obj-c-name proc))
              (name (proc-obj-name proc))
              (unique-name (targ-unique-name proc))
              (host (targ-c-id-host unique-name))
              (p (cdr obj))
              (info (car p))
              (val-lbls (vector-ref info 1))
              (proc-info (vector-ref info 4)))
         (if (= i 0)
           (targ-display " ")
           (targ-display ","))
         (set! i (+ i 1))
         (targ-code* (list "DEF_LBL_INTRO"
                           host
                           (targ-heap-ref-obj
                            (and (proc-obj-primitive? proc)
                                 (string->symbol name)))
                           (targ-heap-ref-obj proc-info)
                           (length val-lbls)
                           (if c-name c-name 0)))
         (for-each
          (lambda (lbl)
            (let ((class (vector-ref lbl 2))
                  (info (vector-ref lbl 3)))
              (targ-display ",")
              (targ-code*
               (case class
                 ((proc)
                  (let ((nb-params (vector-ref info 0))
                        (nb-closed (vector-ref info 1)))
                    (list "DEF_LBL_PROC"
                          host
                          nb-params
                          nb-closed)))
                 ((return)
                  (let ((kind (vector-ref info 0))
                        (fs (vector-ref info 1))
                        (link (vector-ref info 2))
                        (gc-map (vector-ref info 3)))
                    (list
                     "DEF_LBL_RET"
                     host
                     (list
                      (if (targ-out-of-line-frame? kind fs) "OFD" "IFD")
                      (case kind
                        ((internal) '("RETI"))
                        ((task)     '("RETT"))
                        (else       '("RETN")))
                      fs
                      link
                      (targ-c-hex gc-map)))))
                 (else
                  (compiler-internal-error
                   "targ-dump-prc, unknown label kind"))))))
          val-lbls)))
     objs))

  (targ-code* '("END_LBL"))

  (targ-line)

  (if (> ofd-count 0)
    (begin
      (targ-code* '("BEGIN_OFD"))
      (let ((i 0))
        (for-each
         (lambda (obj)
           (let* ((p (cdr obj))
                  (info (car p)))
             (for-each
              (lambda (lbl)
                (let ((class (vector-ref lbl 2))
                      (info (vector-ref lbl 3)))
                  (if (eq? class 'return)
                    (let ((kind (vector-ref info 0))
                          (fs (vector-ref info 1))
                          (link (vector-ref info 2))
                          (gc-map (vector-ref info 3)))
                      (if (targ-out-of-line-frame? kind fs)
                        (begin
                          (if (= i 0)
                            (targ-display " ")
                            (targ-display ","))
                          (set! i (+ i 1))
                          (targ-code*
                           (list
                            "DEF_OFD"
                            (case kind
                              ((internal) '("RETI"))
                              ((task)     '("RETT"))
                              (else       '("RETN")))
                            fs
                            link))
                          (targ-vector-like-object-body
                           'gcmap
                           (targ-gc-map-chunks gc-map kind fs)
                           (lambda (x) (targ-c-hex-u32 x))
                           (quotient targ-max-word-size 4))))))))
              (vector-ref info 1))))
         objs))
      (targ-code* '("END_OFD"))
      (targ-line))))

(define (targ-unique-name proc)

  (define (version n)
    (string-append "_V" (number->string n) "_"))

  (let* ((name (proc-obj-name proc))
         (state (table-ref targ-unique-name-table name #f)))
    (if state
        (or (table-ref (vector-ref state 3) proc #f)
            (let* ((count (vector-ref state 0))
                   (count+1 (+ count 1))
                   (unique-name (cons (version count+1) name)))
              (vector-set! state 0 count+1)
              (if (= count+1 2)
                  (targ-cell-set! (vector-ref state 1) (version 1)))
              (vector-set! state 2 unique-name)
              (table-set! (vector-ref state 3) proc unique-name)
              unique-name))
        (let* ((conflicts (make-table 'test: eq?))
               (cell (targ-make-cell "")) ;; for now use empty version
               (unique-name (cons cell name))
               (state (vector 1 cell unique-name conflicts)))
           (table-set! targ-unique-name-table name state)
           (table-set! conflicts proc unique-name)
           unique-name))))

(define (targ-last-unique-name proc)
  (let* ((name (proc-obj-name proc))
         (state (table-ref targ-unique-name-table name #f)))
    (vector-ref state 2)))

(define (targ-get-ofd-count objs)
  (let ((n 0))
    (for-each
     (lambda (obj)
       (let* ((p (cdr obj))
              (info (car p)))
         (for-each
          (lambda (lbl)
            (let ((class (vector-ref lbl 2))
                  (info (vector-ref lbl 3)))
              (if (eq? class 'return)
                (let ((kind (vector-ref info 0))
                      (fs (vector-ref info 1)))
                  (if (targ-out-of-line-frame? kind fs)
                    (set! n (+ n 1)))))))
          (vector-ref info 1))))
     objs)
    n))

(define (targ-dump-cod obj)
  (let* ((proc (car obj))
         (p (cdr obj))
         (name (proc-obj-name proc))
         (unique-name (targ-unique-name proc))
         (host (targ-c-id-host unique-name))
         (info (car p))
         (code (vector-ref info 0))
         (rd-res (vector-ref info 2))
         (wr-res (vector-ref info 3)))

    (define (def var val)
      (targ-define-prefix (list var))
      (targ-display " ")
      (targ-code val)
      (targ-line))

    (def "PH_PROC" host)
    (def "PH_LBL0" (caddr p))

    (targ-begin-cod rd-res wr-res
                    "BEGIN_P_COD" 'pd- 'pr- 'pw-
                    "BEGIN_P_HLBL" "DEF_P_HLBL_INTRO" "DEF_P_HLBL" "END_P_HLBL"
                    (list obj))

    (targ-code* '("BEGIN_P_SW"))

    (stretchable-vector-for-each
      (lambda (x i)
        (if x
          (cond ((and (pair? x) (eq? (car x) 'label))
                 (let ((lbl (cdr x)))
                   (cond ((targ-lbl-val? lbl)
                          (targ-code*
                            (list "DEF_SLBL"
                                  (targ-lbl-num lbl)
                                  (targ-make-glbl (targ-lbl-num lbl)
                                                  unique-name))))
                         ((targ-lbl-goto? lbl)
                          (targ-code*
                            (list "DEF_GLBL"
                                  (targ-make-glbl (targ-lbl-num lbl)
                                                  unique-name)))))))
                ((and (pair? x)
                      (eq? (car x) 'line))
                 (set! targ-source-line-number (cadr x))
                 (set! targ-source-filename (caddr x)))
                ((and (pair? x)
                      (or (eq? (car x) 'append)
                          (eq? (car x) 'cell)))
                 (targ-code x))
                (else
                 (targ-display "   ")
                 (targ-code* x)))))
      code)

    (targ-track-source targ-line-number targ-filename)

    (targ-code* '("END_P_SW"))

    (targ-track-source #f #f)

    (targ-end-cod "END_P_COD")

    (targ-line)))

(define (targ-begin-cod rd-res wr-res beg decl rd wr
                        beg-hlbl def-hlbl-intro def-hlbl end-hlbl objs)
  (let ((nb-res
         (max (stretchable-vector-length rd-res)
              (stretchable-vector-length wr-res))))

    (define (resource-set op1 op2 element?)
      (targ-define-prefix (cons op1 "ALL"))
      (set! targ-in-macro-definition? #t)
      (let loop ((i 0))
        (if (< i nb-res)
          (if (element? i)
            (begin
              (targ-code (targ-res-op i op2))
              (loop (+ i 1)))
            (loop (+ i 1)))))
      (set! targ-in-macro-definition? #f)
      (targ-line))

    (resource-set
      decl
      'd-
      (lambda (i) (or (stretchable-vector-ref rd-res i)
                      (stretchable-vector-ref wr-res i))))

    (resource-set
      rd
      'r-
      (lambda (i) (stretchable-vector-ref rd-res i)))

    (resource-set
      wr
      'w-
      (lambda (i) (stretchable-vector-ref wr-res i)))

    (targ-code* (list beg))

    (targ-code* (list beg-hlbl))

    (for-each
     (lambda (obj)
       (let* ((proc (car obj))
              (p (cdr obj))
              (name (proc-obj-name proc))
              (unique-name (targ-unique-name proc))
              (info (car p))
              (val-lbls (vector-ref info 1)))
         (for-each
          (lambda (lbl)
            (if lbl
                (let ((x (targ-make-glbl (targ-lbl-num lbl)
                                         unique-name)))
                  (targ-code* (list def-hlbl x)))
                (targ-code* (list def-hlbl-intro))))
          (cons #f val-lbls))))
     objs)

    (targ-code* (list end-hlbl))))

(define (targ-end-cod end)
  (targ-code* (list end)))

(define (targ-dump-mod objs c-inits sym-list key-list)

  (define (def-mod-prm-glo kind)
    (for-each
     (lambda (obj)
       (let* ((proc (car obj))
              (p (cdr obj))
              (name (proc-obj-name proc)))
         (targ-code* (list kind
                           (targ-use-glo (string->symbol name) #f)
                           (targ-c-id-glo name)
                           (caddr p)))))
     objs))

  (targ-code* '("BEGIN_MOD_PRM"))

  (def-mod-prm-glo "DEF_MOD_PRM")

  (targ-code* '("END_MOD_PRM"))

  (targ-line)

  (targ-code* '("BEGIN_MOD_C_INIT"))

  (for-each
    (lambda (x)
      (targ-display x)
      (targ-line))
    c-inits)

  (targ-code* '("END_MOD_C_INIT"))

  (targ-line)

  (targ-code* '("BEGIN_MOD_GLO"))

  (def-mod-prm-glo "DEF_MOD_GLO")

  (targ-code* '("END_MOD_GLO"))

  (targ-line)

  (targ-code* '("BEGIN_MOD_SYM_KEY"))

  (for-each
    (lambda (s)
      (let ((name (symbol->string (car s))))
        (targ-code* (list "DEF_MOD_SYM"
                          (cdr s)
                          (targ-c-id-sym name)
                          (targ-c-string name)))))
    sym-list)

  (for-each
    (lambda (k)
      (let ((name (keyword-object->string (car k))))
        (targ-code* (list "DEF_MOD_KEY"
                          (cdr k)
                          (targ-c-id-key name)
                          (targ-c-string name)))))
    key-list)

  (targ-code* '("END_MOD_SYM_KEY")))

(define (targ-extract-primitives objs)
  (let loop ((objs objs) (prms '()))
    (if (pair? objs)
      (let ((obj (car objs)))
        (let ((proc (car obj)))
          (if (proc-obj-primitive? proc)
            (loop (cdr objs) (cons obj prms))
            (loop (cdr objs) prms))))
      (reverse prms))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define targ-linker-tag "LNK_")
(define targ-host-tag   "H_")
(define targ-glo-tag    "G_")
(define targ-glo2-tag   "GLO_")
(define targ-prm2-tag   "PRM_")
(define targ-sym-tag    "S_")
(define targ-sym2-tag   "SYM_")
(define targ-key-tag    "K_")
(define targ-key2-tag   "KEY_")

(define targ-port #f)
(define targ-line-size #f)
(define targ-line-number #f)
(define targ-filename #f)
(define targ-current-line-number #f)
(define targ-current-filename #f)
(define targ-source-line-number #f)
(define targ-source-filename #f)
(define targ-in-macro-definition? #f)

(define (targ-code* x)
  (targ-code x)
  (targ-line))

(define (targ-code x)

  (define (one-head head args)
    (targ-display-prefixed head)
    (targ-code-args args))

  (define (two-heads head1 head2 args)
    (targ-display-prefixed head1)
    (targ-display head2)
    (targ-code-args args))

  (define (goto-lbl n name)
    (targ-display-prefixed "L")
    (targ-code n)
    (targ-display "_")
    (targ-display-c-id name))

  (if (pair? x)
    (let ((head (car x)) (tail (cdr x)))
      (case head
        ((c-long)      (targ-display-c-long      tail))
        ((c-long-long) (targ-display-c-long-long tail))
        ((c-unsigned-long) (targ-display-c-unsigned-long tail))
        ((c-hex-u32)   (targ-display-c-hex-u32   tail))
        ((c-hex)       (targ-display-c-hex       tail))
        ((c-char)      (targ-display-c-char      tail))
        ((c-string)    (targ-display-c-string    tail))
        ((c-id-linker) (targ-display-prefixed-c-id targ-linker-tag tail))
        ((c-id-host)   (targ-display-prefixed-c-id targ-host-tag   tail))
        ((c-id-glo)    (targ-display-prefixed-c-id targ-glo-tag    tail))
        ((c-id-glo2)   (targ-display-prefixed-c-id targ-glo2-tag   tail))
        ((c-id-prm2)   (targ-display-prefixed-c-id targ-prm2-tag   tail))
        ((c-id-sym)    (targ-display-prefixed-c-id targ-sym-tag    tail))
        ((c-id-sym2)   (targ-display-prefixed-c-id targ-sym2-tag   tail))
        ((c-id-key)    (targ-display-prefixed-c-id targ-key-tag    tail))
        ((c-id-key2)   (targ-display-prefixed-c-id targ-key2-tag   tail))
        ((sub-name)    (targ-display-prefixed "X") (targ-code tail))
        ((glbl)        (goto-lbl (car tail) (cadr tail)))
        ((d-)          (two-heads "D_"        tail '()))
        ((r-)          (two-heads "R_"        tail '()))
        ((w-)          (two-heads "W_"        tail '()))
        ((md-)         (two-heads "MD_"       tail '()))
        ((mr-)         (two-heads "MR_"       tail '()))
        ((mw-)         (two-heads "MW_"       tail '()))
        ((pd-)         (two-heads "PD_"       tail '()))
        ((pr-)         (two-heads "PR_"       tail '()))
        ((pw-)         (two-heads "PW_"       tail '()))
        ((c-lbl-)      (two-heads "C_LBL_"    tail '()))
        ((c-obj-)      (two-heads "C_OBJ_"    tail '()))
        ((psr)         (two-heads "PSR"       tail '()))
        ((r)           (two-heads "R"         tail '()))
        ((set-r)       (two-heads "SET_R"     (car tail) (cdr tail)))
        ((vec)         (two-heads "VEC"       (car tail) (cdr tail)))
        ((s8vec)       (two-heads "S8VEC"     (car tail) (cdr tail)))
        ((u8vec)       (two-heads "U8VEC"     (car tail) (cdr tail)))
        ((s16vec)      (two-heads "S16VEC"    (car tail) (cdr tail)))
        ((u16vec)      (two-heads "U16VEC"    (car tail) (cdr tail)))
        ((s32vec)      (two-heads "S32VEC"    (car tail) (cdr tail)))
        ((u32vec)      (two-heads "U32VEC"    (car tail) (cdr tail)))
        ((s64vec)      (two-heads "S64VEC"    (car tail) (cdr tail)))
        ((u64vec)      (two-heads "U64VEC"    (car tail) (cdr tail)))
        ((f32vec)      (two-heads "F32VEC"    (car tail) (cdr tail)))
        ((f64vec)      (two-heads "F64VEC"    (car tail) (cdr tail)))
        ((str)         (two-heads "STR"       (car tail) (cdr tail)))
        ((nstr)        (two-heads "NSTR"      (car tail) (cdr tail)))
        ((big)         (two-heads "BIG"       (car tail) (cdr tail)))
        ((bigfix)      (two-heads "BIGFIX"    (car tail) (cdr tail)))
        ((gcmap)       (two-heads "GCMAP"     (car tail) (cdr tail)))
        ((seq)         (targ-code-seq tail))
        ((append)      (targ-code-append tail))
        ((cell)        (targ-code tail))
        ((prc)         (one-head "PRC" tail))
        (else          (one-head head tail))))
    (if x (targ-display x))))

(define (targ-code-args args)
  (targ-code-list
    args
    (lambda () (targ-display ","))
    (lambda () (targ-display "("))
    (lambda () (targ-display ")"))
    (lambda () (if (> targ-line-size 40)
                 (begin (targ-line) (set! targ-line-size 1))))))

(define (targ-code-seq args)
  (targ-code-list
    args
    (lambda () (targ-display " "))
    (lambda () 0)
    (lambda () 0)
    (lambda () 0)))

(define (targ-code-append args)
  (targ-code-list
    args
    (lambda () 0)
    (lambda () 0)
    (lambda () 0)
    (lambda () 0)))

(define (targ-code-list args sep prefix suffix line-break)
  (if (pair? args)
    (let ((arg (car args)))
      (if arg
        (begin
          (prefix)
          (line-break)
          (targ-code arg)
          (let loop ((args (cdr args)))
            (if (pair? args)
              (let ((arg (car args)))
                (if arg
                  (begin
                    (sep)
                    (line-break)
                    (targ-code arg)))
                (loop (cdr args)))))
          (suffix)
          (line-break))
        (targ-code-list (cdr args) sep prefix suffix line-break)))))

(define (targ-track-source line filename)
  (if (and line
           (not (and (= line targ-current-line-number)
                     (string=? filename targ-current-filename))))
    (set! targ-source-line-number (+ line 1))
    (set! targ-source-line-number line))
  (set! targ-source-filename filename))

(define (targ-display-no-line-info x)
  (display x targ-port)
  (if (eqv? x #\newline)
    (begin
      (set! targ-line-size 0)
      (set! targ-line-number (+ targ-line-number 1))
      (set! targ-current-line-number (+ targ-current-line-number 1)))
    (set! targ-line-size (+ targ-line-size 1))))

(define (targ-display x)
  (if (= targ-line-size 0)
    (if targ-source-filename
      (begin
        (cond ((not (string=? targ-source-filename targ-current-filename))
               (targ-display-no-line-info "#line ")
               (targ-display-no-line-info targ-source-line-number)
               (targ-display-no-line-info " ")
               (targ-display-no-line-info-c-string
                (path-strip-directory targ-source-filename))
               (targ-display-no-line-info #\newline))
              ((not (= targ-source-line-number targ-current-line-number))
               (targ-display-no-line-info "#line ")
               (targ-display-no-line-info targ-source-line-number)
               (targ-display-no-line-info #\newline)))
        (set! targ-current-line-number targ-source-line-number)
        (set! targ-current-filename targ-source-filename))))
  (targ-display-no-line-info x))

(define (targ-macro-definition name value)
  (set! targ-in-macro-definition? #t)
  (targ-display "#define ")
  (targ-code name)
  (if value
      (begin
        (targ-display " ")
        (targ-code value)))
  (set! targ-in-macro-definition? #f)
  (targ-line))

(define (targ-line)
  (if targ-in-macro-definition?
    (begin
      (targ-display " \\")
      (targ-display #\newline)
      (set! targ-line-size 1))
    (targ-display #\newline)))

(define (targ-make-cell x)
  (cons 'cell x))

(define (targ-cell-set! x y)
  (set-cdr! x y))

(define (targ-c-long n)
  (cons 'c-long n))

(define (targ-c-long-long n)
  (cons 'c-long-long n))

(define (targ-c-unsigned-long n)
  (cons 'c-unsigned-long n))

(define (targ-c-hex-u32 n)
  (cons 'c-hex-u32 n))

(define (targ-c-hex n)
  (cons 'c-hex n))

(define (targ-c-char c)
  (cons 'c-char c))

(define (targ-c-string str)
  (cons 'c-string str))

(define (targ-linker-id name)
  (targ-c-id-linker name))

(define (targ-c-id-linker name)
  (cons 'c-id-linker name))

(define (targ-c-id-host name)
  (cons 'c-id-host name))

(define (targ-c-id-glo name)
  (cons 'c-id-glo name))

(define (targ-c-id-glo2 name)
  (cons 'c-id-glo2 name))

(define (targ-c-id-prm2 name)
  (cons 'c-id-prm2 name))

(define (targ-c-id-sym name)
  (cons 'c-id-sym name))

(define (targ-c-id-sym2 name)
  (cons 'c-id-sym2 name))

(define (targ-c-id-key name)
  (cons 'c-id-key name))

(define (targ-c-id-key2 name)
  (cons 'c-id-key2 name))

(define (targ-sub-name n)
  (cons 'sub-name n))

(define (targ-display-prefixed str)
  (targ-display c-id-prefix) ; c-id-prefix is defined in "_parms.scm"
  (targ-display-no-line-info str))

(define (targ-display-c-long n)
  (targ-display n)
  (targ-display-no-line-info "L"))

(define (targ-display-c-long-long n)
  (targ-display n)
  (targ-display-no-line-info "LL"))

(define (targ-display-c-unsigned-long n)
  (targ-display n)
  (targ-display-no-line-info "UL"))

(define (targ-display-c-hex-u32 n)
  (targ-display-c-hex (targ-u32-to-s32 n)))

(define (targ-display-c-hex n)
  (targ-display (targ-s32->hex-string n))
  (targ-display-no-line-info "L"))

(define (targ-display-c-char c)
  (targ-display (character->unicode c))) ; can't assume type "char" is ASCII

(define (targ-display-c-string str)
  (targ-display #\")
  (targ-display-no-line-info-c-string-tail str))

(define (targ-display-no-line-info-c-string str)
  (targ-display-no-line-info #\")
  (targ-display-no-line-info-c-string-tail str))

(define (targ-display-no-line-info-c-string-tail str)
  (let loop ((i 0))
    (if (< i (string-length str))
      (let ((c (string-ref str i)))
        (cond ((char=? c (unicode->character 0))
               ; allow nul characters in strings
               (targ-display-no-line-info (unicode->character #xc0))
               (targ-display-no-line-info (unicode->character #x80)))
              ((or (char=? c #\\) (char=? c #\"))
               (targ-display-no-line-info #\\)
               (targ-display-no-line-info c))
              (else
               (targ-display-no-line-info-UTF-8 c)))
        (loop (+ i 1)))))
  (targ-display-no-line-info #\"))

(define (targ-display-no-line-info-UTF-8 c)

  (define (write-octal n)
    (targ-display-no-line-info (modulo n 8)))

  (define (write-byte byte)
    (if (and (>= byte 32) (<= byte 126))
      (targ-display-no-line-info (unicode->character byte))
      (begin
        (targ-display-no-line-info #\\)
        (write-octal (quotient byte 64))
        (write-octal (quotient byte 8))
        (write-octal byte))))

  (define (shift-right-6-bits x)
    (quotient x 64))

  (define (extract-low-6-bits x)
    (modulo x 64))

  (define (write-first-byte shift x)
    (write-byte (+ (- #xff (quotient #xff shift)) x)))

  (define (write-next-byte x)
    (write-byte (+ #x80 (extract-low-6-bits x))))

  (let ((x0 (character->unicode c)))
    (cond ((<= x0 #x7f)
           (write-byte x0))
          ((<= x0 #x7ff)
           (let* ((x1 (shift-right-6-bits x0)))
             (write-first-byte 4 x1)
             (write-next-byte x0)))
          ((<= x0 #xffff)
           (let* ((x1 (shift-right-6-bits x0))
                  (x2 (shift-right-6-bits x1)))
             (write-first-byte 8 x2)
             (write-next-byte x1)
             (write-next-byte x0)))
          ((<= x0 #x1fffff)
           (let* ((x1 (shift-right-6-bits x0))
                  (x2 (shift-right-6-bits x1))
                  (x3 (shift-right-6-bits x2)))
             (write-first-byte 16 x3)
             (write-next-byte x2)
             (write-next-byte x1)
             (write-next-byte x0)))
          ((<= x0 #x3ffffff)
           (let* ((x1 (shift-right-6-bits x0))
                  (x2 (shift-right-6-bits x1))
                  (x3 (shift-right-6-bits x2))
                  (x4 (shift-right-6-bits x3)))
             (write-first-byte 32 x4)
             (write-next-byte x3)
             (write-next-byte x2)
             (write-next-byte x1)
             (write-next-byte x0)))
          (else
           (let* ((x1 (shift-right-6-bits x0))
                  (x2 (shift-right-6-bits x1))
                  (x3 (shift-right-6-bits x2))
                  (x4 (shift-right-6-bits x3))
                  (x5 (shift-right-6-bits x4)))
             (write-first-byte 64 x5)
             (write-next-byte x4)
             (write-next-byte x3)
             (write-next-byte x2)
             (write-next-byte x1)
             (write-next-byte x0))))))

(define (targ-display-prefixed-c-id type name)
  (targ-display-prefixed type)
  (targ-display-c-id name))

(define (targ-display-c-id name)
  (if (pair? name)
      (begin
        (targ-code (car name))
        (targ-display-no-line-info (scheme-id->c-id (cdr name))))
      (targ-display-no-line-info (scheme-id->c-id name))))

;;;----------------------------------------------------------------------------
