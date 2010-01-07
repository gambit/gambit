;;;============================================================================

;;; File: "_t-c-1.scm", Time-stamp: <2010-01-07 14:56:18 feeley>

;;; Copyright (c) 1994-2010 by Marc Feeley, All Rights Reserved.

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

;; The registers available in the virtual machine are defined by the
;; parameters targ-nb-gvm-regs and targ-nb-arg-regs.  The definitions must
;; agree with the corresponding macros in the file "include/gambit.h.in"
;; (i.e. ___NB_GVM_REGS and ___NB_ARG_REGS).
;;
;; targ-nb-gvm-regs = total number of registers available
;;                    3 <= targ-nb-gvm-regs <= 25
;; targ-nb-arg-regs = maximum number of arguments passed in registers
;;                    1 <= targ-nb-arg-regs <= min( 12, targ-nb-gvm-regs-2 )

(define targ-nb-gvm-regs #f)
(set! targ-nb-gvm-regs 5)

(define targ-nb-arg-regs #f)
(set! targ-nb-arg-regs 3)

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

(define targ-msection-biggest 4096) ; Maximum size of objects in msections.

;; Number of tag bits per pointer:

(define targ-tag-bits 2)
(define targ-alignment (expt 2 targ-tag-bits))

;; Upper bound on space needed by various objects:

(define (targ-max-words i) ; minimum k such that targ-min-word-size*k >= i
                           ; and targ-min-word-size*k mod targ-alignment = 0

  (define (round-up-to-multiple-of n i)
    (* (quotient (+ i (- n 1)) n) n))

  (quotient (round-up-to-multiple-of
              targ-min-word-size
              (round-up-to-multiple-of targ-alignment i))
            targ-min-word-size))

;; Space occupied by various types of objects.

(define targ-pair-space        (targ-max-words (* 3 targ-min-word-size)))
(define targ-box-space         (targ-max-words (* 2 targ-min-word-size)))
(define targ-will-space        (targ-max-words (* 4 targ-min-word-size)))
(define targ-flonum-space      (targ-max-words 16))
(define targ-promise-space     (targ-max-words (* 3 targ-min-word-size)))
(define (targ-closure-space n) (targ-max-words (* (+ n 2) targ-min-word-size)))
(define (targ-string-space n)  (targ-max-words (* (+ n 1) targ-min-word-size)))
(define (targ-s8vector-space n)(targ-max-words (+ n targ-min-word-size)))
(define (targ-vector-space n)  (targ-max-words (* (+ n 1) targ-min-word-size)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; ***** PROCEDURE CALLING CONVENTION

(define (targ-label-info nb-parms closed?)

;; After a GVM "entry-point" or "closure-entry-point" label, the following
;; is true:
;;
;;  * return address is in GVM register 0
;;
;;  * if nb-parms <= nb-arg-regs
;;
;;      then parameter N is in GVM register N
;;
;;      else parameter N is in
;;               GVM register N-F, if N > F
;;               GVM stack slot N, if N <= F
;;           where F = nb-parms - nb-arg-regs
;;
;;  * for a "closure-entry-point" GVM register nb-arg-regs+1 contains
;;    a pointer to the closure object
;;
;;  * other GVM registers contain an unspecified value

  (let ((nb-stacked (max 0 (- nb-parms targ-nb-arg-regs))))

    (define (location-of-parms i)
      (if (> i nb-parms)
        '()
        (cons (cons i
                    (if (> i nb-stacked)
                      (make-reg (- i nb-stacked))
                      (make-stk i)))
              (location-of-parms (+ i 1)))))

    (let ((x (cons (cons 'return 0) (location-of-parms 1))))
      (make-pcontext nb-stacked
        (if closed?
          (cons (cons 'closure-env (make-reg (+ targ-nb-arg-regs 1))) x)
          x)))))

(define (targ-jump-info nb-args)

;; After a GVM "jump" instruction with argument count, the following
;; is true:
;;
;;  * the return address is in GVM register 0
;;
;;  * if nb-args <= nb-arg-regs
;;
;;      then argument N is in GVM register N
;;
;;      else argument N is in
;;               GVM register N-F, if N > F
;;               GVM stack slot N, if N <= F
;;           where F = nb-args - nb-arg-regs
;;
;;  * GVM register nb-arg-regs+1 contains a pointer to the closure object
;;    if a closure is being jumped to
;;
;;  * other GVM registers contain an unspecified value

  (let ((nb-stacked (max 0 (- nb-args targ-nb-arg-regs))))

    (define (location-of-args i)
      (if (> i nb-args)
        '()
        (cons (cons i
                    (if (> i nb-stacked)
                      (make-reg (- i nb-stacked))
                      (make-stk i)))
              (location-of-args (+ i 1)))))

    (make-pcontext nb-stacked
                   (cons (cons 'return (make-reg 0))
                         (location-of-args 1)))))

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

(let ((targ (make-target 6 'c)))

  (define (begin! info-port)

    (set! targ-info-port info-port)

    (target-dump-set!              targ targ-dump)
    (target-nb-regs-set!           targ targ-nb-gvm-regs)
    (target-prim-info-set!         targ targ-prim-info)
    (target-label-info-set!        targ targ-label-info)
    (target-jump-info-set!         targ targ-jump-info)
    (target-frame-constraints-set! targ (make-frame-constraints
                                         targ-frame-reserve
                                         targ-frame-alignment))
    (target-proc-result-set!       targ (make-reg 1))
    (target-task-return-set!       targ (make-reg 0))
    (target-switch-testable?-set!  targ targ-switch-testable?)

    #f)

  (define (end!)
    #f)

  (target-begin!-set! targ begin!)
  (target-end!-set! targ end!)
  (target-add targ))

(define targ-info-port #f)

;;;----------------------------------------------------------------------------
;;
;; Primitive procedure database

(define targ-prim-proc-table
  (make-vector 403 '()))

(define (targ-prim-proc-add! x)
  (let* ((sym (string->canonical-symbol (car x)))
         (index (modulo (symbol-hash sym) 403)))
    (vector-set!
     targ-prim-proc-table
     index
     (cons
      (cons
       sym
       (apply make-proc-obj (car x) #f #t #f (cdr x)))
      (vector-ref targ-prim-proc-table index)))))

(for-each targ-prim-proc-add! prim-procs)

(define (targ-prim-info name)
  (let ((index (modulo (symbol-hash name) 403)))
    (let ((x (assq name (vector-ref targ-prim-proc-table index))))
      (if x (cdr x) #f))))

(define (targ-get-prim-info name)
  (let ((proc (targ-prim-info (string->canonical-symbol name))))
    (if proc
      proc
      (compiler-internal-error
        "targ-get-prim-info, unknown primitive:" name))))

(define (targ-switch-testable? obj)
  (targ-testable-with-eq? obj))

;;;----------------------------------------------------------------------------
;;
;; Dumping of a compilation module

(define (targ-dump procs output output-root c-intf script-line options)
  (let ((c-decls (c-intf-decls c-intf))
        (c-procs (c-intf-procs c-intf))
        (c-inits (c-intf-inits c-intf))
        (c-objs (c-intf-objs c-intf)))

    (c-intf-decls-set! c-intf '()) ; clear c-intf structure so front-end
    (c-intf-procs-set! c-intf '()) ; will not generate C-interface file.
    (c-intf-inits-set! c-intf '())
    (c-intf-objs-set! c-intf '())

    (set! targ-track-scheme-option? compiler-option-track-scheme)
    (set! targ-debug-location-option? compiler-option-debug-location)
    (set! targ-debug-source-option? compiler-option-debug-source)
    (set! targ-debug-environments-option? compiler-option-debug-environments)
    (if compiler-option-debug
        (begin
          (set! targ-debug-location-option? #t)
          (set! targ-debug-source-option? #t)
          (set! targ-debug-environments-option? #t)))

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
          (targ-scan-procedure (queue-get! targ-prc-objs-to-scan))
          (loop))))

    (if targ-info-port
      (newline targ-info-port))

    (targ-heap-dump
      (or output
          (string-append output-root ".c"))
      (proc-obj-name (car procs))
      c-decls
      c-inits
      (map targ-use-obj c-objs)
      script-line)

    (targ-heap-end!)

    (set! targ-track-scheme-option? #f)
    (set! targ-debug-location-option? #f)
    (set! targ-debug-source-option? #f)
    (set! targ-debug-environments-option? #f)))

(define targ-track-scheme-option? #f)
(define targ-debug-location-option? #f)
(define targ-debug-source-option? #f)
(define targ-debug-environments-option? #f)

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
(define targ-key-objs #f)  ; table of keyword objects
(define targ-num-objs #f)  ; table of numbers that may be subtyped objects
(define targ-sub-objs #f)  ; ordered table of subtyped objects (vector, ...)
(define targ-prc-objs #f)  ; queue of procedure objects
(define targ-prc-objs-seen #f)    ; table of procedure objects seen
(define targ-prc-objs-to-scan #f) ; queue of procedure objects remaining to scan

(define targ-module-rd-res #f) ; set of resources read from
(define targ-module-wr-res #f) ; set of resources written to

(define targ-fp-cache #f) ; floating point number cache
(define targ-fr-cell #f)  ; cell of floating point region start

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
  #f)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-use-glo glo supply?)
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
        y))))

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
                               (list "BIGFIX" i obj))
                             (lambda (obj i)
                               (list "SUB" i))))))
                   (case subtype
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
            (list "SYM"
                  (targ-use-sym obj)
                  (targ-c-id-sym (symbol->string obj))))
           ((keyword)
            (list "KEY"
                  (targ-use-key obj)
                  (targ-c-id-key (keyword-object->string obj))))
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
       '("KEY_OBJ"))
      ((rest)
       '("REST"))
;;      ((body)
;;       '("BODY_OBJ"))
      ((fixnum32)
       (list "FIX" (targ-c-s32 obj)))
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
      (let ((i (targ-use-glo (string->symbol name) supply?)))
        (if p
          p
          (list 'prm i (targ-c-id-glo name))))
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
            (let ((x (table-ref targ-sym-objs obj #f)))
              (if x
                (list "REF_SYM"
                      x
                      (targ-c-id-sym (symbol->string obj)))
                (err))))
           ((keyword)
            (let ((x (table-ref targ-key-objs obj #f)))
              (if x
                (list "REF_KEY"
                      x
                      (targ-c-id-key (keyword-object->string obj)))
                (err))))
           ((flonum bigfixnum bignum ratnum cpxnum)
            (let ((x (table-ref targ-num-objs obj #f)))
              (if x
                (ref-subtyped-obj x)
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
       '("REF_KEY_OBJ"))
      ((rest)
       '("REF_REST"))
;;      ((body)
;;       '("REF_BODY_OBJ"))
      ((fixnum32)
       (list "REF_FIX" obj))
      ((char)
       (list "REF_CHR" (targ-c-char obj)))
      (else
       (compiler-internal-error
         "targ-heap-ref-obj, unknown object 'obj'" obj)))))

;;;----------------------------------------------------------------------------

(define (targ-linker extension? inputs output output-root warnings?)
  (with-exception-handling
    (lambda ()
      (let* ((root
               (or output-root
                   (path-strip-extension output)))
             (out
               (or output
                   (string-append root ".c")))
             (name
               (string-append module-prefix
                              (path-strip-directory root)))
             (input-files
               (map (lambda (x) (string-append x ".c")) inputs))
             (input-infos
               (map targ-read-linker-info input-files))
             (input-mods
               (apply append (map targ-mod-mods input-infos)))
             (sym-rsrc
               (targ-union-list-of-rsrc
                 (map targ-mod-sym-rsrc input-infos)))
             (key-rsrc
               (targ-union-list-of-rsrc
                 (map targ-mod-key-rsrc input-infos)))
             (glo-rsrc
               (targ-union-list-of-rsrc
                 (map targ-mod-glo-rsrc input-infos)))
             (script-line
              (let loop ((lst input-infos)
                         (last-script-line #f))
                (if (pair? lst)
                  (let ((script-line (targ-mod-script-line (car lst))))
                    (loop (cdr lst)
                          (or script-line
                              last-script-line)))
                  last-script-line))))

        (targ-link
          extension?
          out
          name
          input-mods
          (if extension?
            (list (targ-mod-name (car input-infos)))
            '())
          (if extension?
            (apply append (map targ-mod-mods (cdr input-infos)))
            input-mods)
          (if extension?
            (targ-mod-sym-rsrc (car input-infos))
            '())
          (if extension?
            (targ-mod-key-rsrc (car input-infos))
            '())
          (if extension?
            (targ-mod-glo-rsrc (car input-infos))
            '())
          sym-rsrc
          key-rsrc
          glo-rsrc
          script-line
          warnings?)

        out))))

(define (targ-make-mod name mods sym-rsrc key-rsrc glo-rsrc script-line)
  (vector name mods sym-rsrc key-rsrc glo-rsrc script-line))

(define (targ-mod-name module-info)
  (vector-ref module-info 0))

(define (targ-mod-mods module-info)
  (vector-ref module-info 1))

(define (targ-mod-sym-rsrc module-info)
  (vector-ref module-info 2))

(define (targ-mod-key-rsrc module-info)
  (vector-ref module-info 3))

(define (targ-mod-glo-rsrc module-info)
  (vector-ref module-info 4))

(define (targ-mod-script-line module-info)
  (vector-ref module-info 5))

(define targ-generated-c-file-first-line
  (string-append "#ifdef " c-id-prefix "LINKER_INFO"))

(define (targ-read-line in)
  (let loop ((lst '()))
    (let ((c (read-char in)))
      (if (or (eof-object? c)
              (char=? c #\return)
              (char=? c #\newline))
          (list->str (reverse lst))
          (loop (cons c lst))))))

(define (targ-generated-c-file? file)
  (let ((in (open-input-file* file)))
    (and in
         (let ((first-line (targ-read-line in)))
           (close-input-port in)
           (string=? targ-generated-c-file-first-line first-line)))))

(define (targ-read-linker-info file)
  (let ((in (open-input-file* file)))

    (define (err msg)
      (if in (close-input-port in))
      (compiler-error (string-append msg " " file)))

    (if in
      (let ((first-line (targ-read-line in)))
        (if (string=? targ-generated-c-file-first-line first-line)
          (let ((linker-info (read in)))
            (if (and (pair? linker-info)
                     (= (length linker-info) 9)
                     (equal? (car linker-info) (compiler-version)))
              (let* ((name (cadr linker-info))
                     (mods (caddr linker-info))
                     (rest (cdddr linker-info))
                     (syms (car rest))
                     (keys (cadr rest))
                     (glos-supplied-and-demanded (caddr rest))
                     (glos-supplied-and-not-demanded (cadddr rest))
                     (glos-not-supplied (car (cddddr rest)))
                     (script-line (cadr (cddddr rest))))
                (close-input-port in)
                (targ-make-mod
                  name
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
                  script-line))
              (err "incorrectly formatted file")))
          (err "linker info is missing from file")))
      (err "can't open file"))))

;;;----------------------------------------------------------------------------
;;
;; Dumping of objects

;; These routines write out the C code that represents the Scheme objects
;; contained in the compilation module.

(define (targ-heap-dump filename name c-decls c-inits c-objs script-line)
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
          (targ-get-ofd-count prc-list)))

    (targ-start-dump
     filename
     name
     (list name)
     sym-rsrc
     key-rsrc
     glo-rsrc
     script-line)

    (targ-dump-module-info name #f #f script-line)

    (targ-define-count "SYM_COUNT" (length sym-list))
    (targ-define-count "KEY_COUNT" (length key-list))
    (targ-define-count "GLO_COUNT" (length glo-list))
    (targ-define-count "SUP_COUNT" (length (keep targ-glo-supplied? glo-list)))
    (targ-define-count "CNS_COUNT" (length cns-list))
    (targ-define-count "SUB_COUNT" (length sub-list))
    (targ-define-count "LBL_COUNT" targ-lbl-alloc)
    (targ-define-count "OFD_COUNT" ofd-count)
    (targ-display "#include \"gambit.h\"")
    (targ-line)

    (targ-dump-sym-key-glo-comp sym-list key-list glo-list)
    (targ-dump-cns cns-list)
    (targ-dump-sub sub-list)
    (targ-dump-prc prc-list c-objs c-decls ofd-count)
    (targ-dump-mod prm-list c-inits sym-list key-list)
    (targ-end-dump)))

(define (targ-link
          extension?
          filename
          name
          all-mods
          old-mods
          new-mods
          old-sym-rsrc
          old-key-rsrc
          old-glo-rsrc
          sym-rsrc
          key-rsrc
          glo-rsrc
          script-line
          warnings?)

  (if warnings?
      (targ-validate-rsrc glo-rsrc))

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
     all-mods
     sym-rsrc
     key-rsrc
     glo-rsrc
     script-line)

    (targ-dump-module-info name #t extension? script-line)

    (targ-display "#include \"gambit.h\"")
    (targ-line)

    (targ-dump-linkfile old-mods new-mods)
    (targ-dump-sym-key-glo-link
      old-sym-glo-rsrc
      old-key-rsrc
      new-sym-glo-rsrc
      new-key-rsrc)
    (targ-end-dump)))

(define (targ-dump-linkfile old-mods new-mods)
  (targ-dump-section "BEGIN_OLD_LNK" "END_OLD_LNK" #f old-mods
    (lambda (i x)
      (targ-code* (list "DEF_OLD_LNK" (targ-c-id-linker x)))))
  (targ-dump-section "BEGIN_NEW_LNK" "END_NEW_LNK" #f new-mods
    (lambda (i x)
      (targ-code* (list "DEF_NEW_LNK" (targ-c-id-linker x)))))
  (targ-dump-section "BEGIN_LNK" "END_LNK" #t (append old-mods new-mods)
    (lambda (i x)
      (targ-code* (list "DEF_LNK" (targ-c-id-linker x))))))

(define (targ-start-dump
         filename
         name
         mods
         sym-rsrc
         key-rsrc
         glo-rsrc
         script-line)

  (set! targ-port (open-output-file filename))
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
  (targ-display ", produced by Gambit-C ")
  (targ-display (compiler-version-string))
  (targ-line)

  (targ-display "(")
  (targ-line)

  (targ-display (compiler-version))
  (targ-line)

  (write name targ-port)
  (targ-line)

  (write mods targ-port)
  (targ-line)

  (targ-write-rsrc-names sym-rsrc)
  (targ-write-rsrc-names key-rsrc)
  (targ-write-rsrc-names (keep targ-rsrc-supplied-and-demanded? glo-rsrc))
  (targ-write-rsrc-names (keep targ-rsrc-supplied-and-not-demanded? glo-rsrc))
  (targ-write-rsrc-names (keep targ-rsrc-not-supplied? glo-rsrc))

  (display " " targ-port) ; some C preprocessors don't like #f at the
                          ; beginning of a line
  (write script-line targ-port)
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

(define (targ-write-rsrc-names lst)
  (targ-display "(")
  (targ-line)
  (for-each
    (lambda (r)
      (let ((name (targ-rsrc-name r)))
        (write name targ-port)
        (targ-line)))
    lst)
  (targ-display ")")
  (targ-line))

(define (targ-dump-module-info name linkfile? extension? script-line)

  (targ-display "#define ")
  (targ-code '("VERSION "))
  (targ-display (compiler-version))
  (targ-line)

  (targ-display "#define ")
  (if linkfile?
    (targ-code '("LINKFILE_NAME "))
    (targ-code '("MODULE_NAME ")))
  (targ-display-c-string name)
  (targ-line)

  (targ-display "#define ")
  (targ-code '("LINKER_ID "))
  (targ-code (targ-c-id-linker name))
  (targ-line)

  (targ-display "#define ")
  (if linkfile?
    (if extension?
      (targ-code '("INCREMENTAL_LINKFILE"))
      (targ-code '("FLAT_LINKFILE")))
    (begin
      (targ-code '("MH_PROC "))
      (targ-code (targ-c-id-host name))))
  (targ-line)

  (targ-display "#define ")
  (targ-code '("SCRIPT_LINE "))
  (if script-line
    (targ-display-c-string script-line)
    (targ-display 0))
  (targ-line))

(define (targ-dump-sym-key-glo-comp sym-list key-list glo-list)

  (if (not (null? sym-list))
    (begin
      (targ-line)
      (for-each
        (lambda (s)
          (let ((name (symbol->string (car s))))
            (targ-code* (list "NEED_SYM" (targ-c-id-sym name)))))
        sym-list)))

  (if (not (null? key-list))
    (begin
      (targ-line)
      (for-each
        (lambda (k)
          (let ((name (keyword-object->string (car k))))
            (targ-code* (list "NEED_KEY" (targ-c-id-key name)))))
        key-list)))

  (if (not (null? glo-list))
    (begin
      (targ-line)
      (for-each
        (lambda (g)
          (let ((name (symbol->string (car g))))
            (targ-code* (list "NEED_GLO" (targ-c-id-glo name)))))
        glo-list)))

  (targ-dump-section "BEGIN_SYM1" "END_SYM1" #f sym-list
    (lambda (i s)
      (targ-cell-set! (cdr s) i)
      (let ((name (symbol->string (car s))))
        (targ-code* (list "DEF_SYM1"
                          i
                          (targ-c-id-sym name)
                          (targ-c-string name))))))

  (targ-dump-section "BEGIN_KEY1" "END_KEY1" #f key-list
    (lambda (i k)
      (targ-cell-set! (cdr k) i)
      (let ((name (keyword-object->string (car k))))
        (targ-code* (list "DEF_KEY1"
                          i
                          (targ-c-id-key name)
                          (targ-c-string name))))))

  (targ-dump-section "BEGIN_GLO" "END_GLO" #f
    (append (keep targ-glo-supplied? glo-list)
            (keep targ-glo-not-supplied? glo-list))
    (lambda (i g)
      (targ-cell-set! (cadr g) i)
      (let ((name (symbol->string (car g))))
        (targ-code* (list "DEF_GLO"
                          i
                          (targ-c-string name)))))))

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
    (begin
      (targ-display "#define ")
      (targ-code (list name))
      (targ-display " ")
      (targ-display n)
      (targ-line))))

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
      (targ-code* (list begin-name))
      (if comma? (targ-display " "))
      (dump 0 (car lst))
      (let loop ((i 1) (lst (cdr lst)))
        (if (not (null? lst))
          (begin
            (if comma? (targ-display ","))
            (dump i (car lst))
            (loop (+ i 1) (cdr lst)))))
      (targ-code* (list end-name)))))

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
    (targ-code* (list def-name id len))
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
             (begin
               (targ-display "#define ")
               (targ-code (cons 'c-lbl- c-name))
               (targ-display " ")
               (targ-code (caddr p))
               (targ-line)))))
       objs)))

  (if (pair? c-objs)
    (begin
      (targ-line)
      (let loop ((i 0) (lst c-objs))
        (if (pair? lst)
          (let ((x (car lst)))
            (targ-display "#define ")
            (targ-code (cons 'c-obj- i))
            (targ-display " ")
            (targ-code x)
            (targ-line)
            (loop (+ i 1) (cdr lst)))))))

  (if (pair? c-decls)
    (begin
      (targ-line)
      (for-each
        (lambda (x)
          (targ-display x)
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
              (host (targ-c-id-host name))
              (p (cdr obj))
              (info (car p))
              (val-lbls (vector-ref info 1))
              (proc-info (vector-ref info 4)))
         (if (= i 0)
           (targ-display " ")
           (targ-display ","))
         (set! i (+ i 1))
         (targ-code* (list "DEF_LBL_INTRO"
                           (targ-c-id-host name)
                           (if (proc-obj-primitive? proc)
                             (targ-c-string name)
                             0)
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
                   "targ-dump-prc, unknown label type"))))))
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
         (info (car p))
         (code (vector-ref info 0))
         (rd-res (vector-ref info 2))
         (wr-res (vector-ref info 3)))

    (define (def var val)
      (targ-define-prefix (list var))
      (targ-display " ")
      (targ-code val)
      (targ-line))

    (def "PH_PROC" (targ-c-id-host name))
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
                                                  name))))
                         ((targ-lbl-goto? lbl)
                          (targ-code*
                            (list "DEF_GLBL"
                                  (targ-make-glbl (targ-lbl-num lbl)
                                                  name)))))))
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
              (info (car p))
              (val-lbls (vector-ref info 1)))
         (for-each
          (lambda (lbl)
            (if lbl
              (let ((x (targ-make-glbl (targ-lbl-num lbl) name)))
                (targ-code* (list def-hlbl x)))
              (targ-code* (list def-hlbl-intro))))
          (cons #f val-lbls))))
     objs)

    (targ-code* (list end-hlbl))))

(define (targ-end-cod end)
  (targ-code* (list end)))

(define (targ-dump-mod objs c-inits sym-list key-list)

  (targ-code* '("BEGIN_MOD1"))

  (for-each
    (lambda (obj)
      (let* ((proc (car obj))
             (p (cdr obj))
             (name (proc-obj-name proc)))
        (targ-code* (list "DEF_PRM"
                          (targ-use-glo (string->symbol name) #f)
                          (targ-c-id-glo name)
                          (caddr p)))))
    objs)

  (for-each
    (lambda (x)
      (targ-display x)
      (targ-line))
    c-inits)

  (targ-code* '("END_MOD1"))

  (targ-line)

  (targ-code* '("BEGIN_MOD2"))

  (for-each
    (lambda (s)
      (let ((name (symbol->string (car s))))
        (targ-code* (list "DEF_SYM2"
                          (cdr s)
                          (targ-c-id-sym name)
                          (targ-c-string name)))))
    sym-list)

  (for-each
    (lambda (k)
      (let ((name (keyword-object->string (car k))))
        (targ-code* (list "DEF_KEY2"
                          (cdr k)
                          (targ-c-id-key name)
                          (targ-c-string name)))))
    key-list)

  (targ-code* '("END_MOD2")))

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

(define targ-linker-tag "")
(define targ-host-tag   "H_")
(define targ-glo-tag    "G_")
(define targ-sym-tag    "S_")
(define targ-key-tag    "K_")

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
    (targ-display (targ-name->c-id name)))

  (if (pair? x)
    (let ((head (car x)) (tail (cdr x)))
      (case head
        ((c-s32)       (targ-display-c-s32       tail))
        ((c-hex-u32)   (targ-display-c-hex-u32   tail))
        ((c-hex)       (targ-display-c-hex       tail))
        ((c-char)      (targ-display-c-char      tail))
        ((c-string)    (targ-display-c-string    tail))
        ((c-id-linker) (targ-display-c-id        targ-linker-tag tail))
        ((c-id-host)   (targ-display-c-id        targ-host-tag   tail))
        ((c-id-glo)    (targ-display-c-id        targ-glo-tag    tail))
        ((c-id-sym)    (targ-display-c-id        targ-sym-tag    tail))
        ((c-id-key)    (targ-display-c-id        targ-key-tag    tail))
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
        ((prm)         (one-head "PRM" tail))
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

(define (targ-c-s32 n)
  (cons 'c-s32 n))

(define (targ-c-hex-u32 n)
  (cons 'c-hex-u32 n))

(define (targ-c-hex n)
  (cons 'c-hex n))

(define (targ-c-char c)
  (cons 'c-char c))

(define (targ-c-string str)
  (cons 'c-string str))

(define (targ-c-id-linker name)
  (cons 'c-id-linker name))

(define (targ-c-id-host name)
  (cons 'c-id-host name))

(define (targ-c-id-glo name)
  (cons 'c-id-glo name))

(define (targ-c-id-sym name)
  (cons 'c-id-sym name))

(define (targ-c-id-key name)
  (cons 'c-id-key name))

(define (targ-sub-name n)
  (cons 'sub-name n))

(define (targ-display-prefixed str)
  (targ-display c-id-prefix) ; c-id-prefix is defined in "_parms.scm"
  (targ-display-no-line-info str))

(define (targ-display-c-s32 n)
  (targ-display n)
  (targ-display-no-line-info "L"))

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

(define (targ-display-c-id type name)
  (targ-display-prefixed type)
  (targ-display-no-line-info (targ-name->c-id name)))

(define (targ-name->c-id s)
  (scheme-id->c-id s))

;;;----------------------------------------------------------------------------
