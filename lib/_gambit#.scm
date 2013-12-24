;;;============================================================================

;;; File: "_gambit#.scm"

;;; Copyright (c) 1994-2013 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; General object representation.

;; IMPORTANT: These definitions need to be consistent with the
;; definitions in the files "lib/gambit.h.in" (macros ___t... and
;; ___s...) and "gsc/_t-c-3.scm" (procedure targ-obj-subtype-integer).

;; Type tags.

(##define-macro (macro-type-fixnum)   0)
(##define-macro (macro-type-mem1)     1)
(##define-macro (macro-type-special)  2)
(##define-macro (macro-type-mem2)     3)

(##define-macro (macro-type-subtyped) `(macro-type-mem1))

;; The type for pair depends on compile-time flags
;; (##define-macro (macro-type-pair) `(macro-type-mem1))
;; (##define-macro (macro-type-pair) `(macro-type-mem2))

;; Subtype tags.

(##define-macro (macro-subtype-vector)       0)
(##define-macro (macro-subtype-pair)         1)
(##define-macro (macro-subtype-ratnum)       2)
(##define-macro (macro-subtype-cpxnum)       3)
(##define-macro (macro-subtype-structure)    4)
(##define-macro (macro-subtype-boxvalues)    5)
(##define-macro (macro-subtype-meroon)       6)
(##define-macro (macro-subtype-jazz)         7)

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

(##define-macro (macro-subtype-ovector? x) `(##fixnum.< ,x 8))
(##define-macro (macro-subtype-bvector? x) `(##fixnum.< 16 ,x))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Special objects.

(##define-macro (macro-absent-obj)  `',(##type-cast -6 2))
(##define-macro (macro-unused-obj)  `',(##type-cast -14 2))
(##define-macro (macro-deleted-obj) `',(##type-cast -15 2))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; System procedure classes.

(##define-macro (define-prim form . exprs)

  (define inlinable-procs '(

##type ##type-cast ##subtype ##subtype-set!
##not ##boolean? ##null? ##unbound? ##eq? ##eof-object?
##fixnum? ##flonum? ##special? ##pair? ##pair-mutable? ##subtyped? ##subtyped-mutable?
##subtyped.vector? ##subtyped.symbol? ##subtyped.flonum? ##subtyped.bignum?
##procedure? ##promise? ##vector? ##symbol? ##keyword? ##ratnum? ##cpxnum?
##string? ##structure? ##values? ##bignum?
##char? ;;;  ##closure? ##subprocedure?

##number? ##complex?

;;; ##fixnum.max ##fixnum.min
;;; ##fixnum.wrap+ ##fixnum.+
##fixnum.+?
;;; ##fixnum.wrap* ##fixnum.*
##fixnum.*?
;;; ##fixnum.wrap- ##fixnum.- ##fixnum.-?
##fixnum.wrapquotient ##fixnum.quotient
##fixnum.remainder ##fixnum.modulo
;;; ##fixnum.bitwise-ior ##fixnum.bitwise-xor
;;; ##fixnum.bitwise-and ##fixnum.bitwise-not
##fixnum.wraparithmetic-shift ##fixnum.arithmetic-shift
##fixnum.arithmetic-shift?
##fixnum.wraparithmetic-shift-left ##fixnum.arithmetic-shift-left
##fixnum.arithmetic-shift-left?
##fixnum.arithmetic-shift-right
##fixnum.arithmetic-shift-right?
##fixnum.wraplogical-shift-right
##fixnum.wraplogical-shift-right?
##fixnum.wrapabs ##fixnum.abs ##fixnum.abs?
##fixnum.zero? ##fixnum.positive? ##fixnum.negative?
##fixnum.odd? ##fixnum.even?
;;; ##fixnum.= ##fixnum.< ##fixnum.> ##fixnum.<= ##fixnum.>=
##fixnum.->char ##fixnum.<-char

##flonum.->fixnum ##flonum.<-fixnum
;;; ##flonum.max ##flonum.min
;;; ##flonum.+ ##flonum.- ##flonum.*  ##flonum./
##flonum.abs
##flonum.floor ##flonum.ceiling ##flonum.truncate ##flonum.round
##flonum.exp ##flonum.log
##flonum.sin ##flonum.cos ##flonum.tan
##flonum.asin ##flonum.acos
;;; ##flonum.atan
##flonum.expt ##flonum.sqrt
##flonum.copysign
##flonum.integer? ##flonum.zero? ##flonum.positive? ##flonum.negative?
##flonum.odd? ##flonum.even?
##flonum.finite? ##flonum.infinite? ##flonum.nan?
##flonum.<-fixnum-exact?
;;; ##flonum.= ##flonum.< ##flonum.> ##flonum.<= ##flonum.>=

##fx->char ##fx<-char
##fl->fx ##fl<-fx
##fl<-fx-exact?


;;; ##fxmax ##fxmin
;;; ##fxwrap+ ##fx+
##fx+?
;;; ##fxwrap* ##fx*
##fx*?
;;; ##fxwrap- ##fx- ##fx-?
##fxwrapquotient ##fxquotient
##fxremainder ##fxmodulo
;;; ##fxnot ##fxand
;;; ##fxior ##fxxor
##fxif ##fxbit-count ##fxlength ##fxfirst-bit-set ##fxbit-set?
##fxwraparithmetic-shift ##fxarithmetic-shift
##fxarithmetic-shift?
##fxwraparithmetic-shift-left ##fxarithmetic-shift-left
##fxarithmetic-shift-left?
##fxarithmetic-shift-right
##fxarithmetic-shift-right?
##fxwraplogical-shift-right
##fxwraplogical-shift-right?
##fxwrapabs ##fxabs ##fxabs?
##fxwrapsquare ##fxsquare ##fxsquare?
##fxzero? ##fxpositive? ##fxnegative?
##fxodd? ##fxeven?
;;; ##fx= ##fx< ##fx> ##fx<= ##fx>=
##fixnum->char ##char->fixnum

##flonum->fixnum ##fixnum->flonum ##fixnum->flonum-exact?
;;; ##flmax ##flmin
;;; ##fl+ ##fl- ##fl*  ##fl/
##flabs
##flfloor ##flceiling ##fltruncate ##flround
##flscalbn ##flilogb
##flexp ##flexpm1 ##fllog ##fllog1p
##flsin ##flcos ##fltan ##flasin ##flacos ;;; ##flatan
##flsinh ##flcosh ##fltanh ##flasinh ##flacosh ##flatanh
##flexpt ##flsqrt ##flsquare
##flcopysign
##flinteger? ##flzero? ##flpositive? ##flnegative?
##flodd? ##fleven?
##flfinite? ##flinfinite? ##flnan?
;;; ##fl= ##fl< ##fl> ##fl<= ##fl>=



##char=? ##char<? ##char>? ##char<=? ##char>=?
##char-alphabetic? ##char-numeric? ##char-whitespace?
##char-upper-case? ##char-lower-case? ##char-upcase ##char-downcase
##cons ##set-car! ##set-cdr! ##car ##cdr
##caar ##cadr ##cdar ##cddr
##caaar ##caadr ##cadar ##caddr ##cdaar ##cdadr ##cddar ##cdddr
##caaaar ##caaadr ##caadar ##caaddr ##cadaar ##cadadr ##caddar ##cadddr
##cdaaar ##cdaadr ##cdadar ##cdaddr ##cddaar ##cddadr ##cdddar ##cddddr
;;; ##list
##box? ##box ##unbox ##set-box!
;;; ##vector
##vector-length ##vector-ref ##vector-set! ##vector-shrink!
;;; ##string
##string-length ##string-ref ##string-set! ##string-shrink!
##s8vector? ;;; ##s8vector
##s8vector-length ##s8vector-ref ##s8vector-set! ##s8vector-shrink!
##u8vector? ;;; ##u8vector
##u8vector-length ##u8vector-ref ##u8vector-set! ##u8vector-shrink!
##s16vector? ;;; ##s16vector
##s16vector-length ##s16vector-ref ##s16vector-set! ##s16vector-shrink!
##u16vector? ;;; ##u16vector
##u16vector-length ##u16vector-ref ##u16vector-set! ##u16vector-shrink!
##s32vector? ;;; ##s32vector
##s32vector-length ##s32vector-ref ##s32vector-set! ##s32vector-shrink!
##u32vector? ;;; ##u32vector
##u32vector-length ##u32vector-ref ##u32vector-set! ##u32vector-shrink!
##s64vector? ;;; ##s64vector
##s64vector-length ##s64vector-ref ##s64vector-set! ##s64vector-shrink!
##u64vector? ;;; ##u64vector
##u64vector-length ##u64vector-ref ##u64vector-set! ##u64vector-shrink!
##f32vector? ;;; ##f32vector
##f32vector-length ##f32vector-ref ##f32vector-set! ##f32vector-shrink!
##f64vector? ;;; ##f64vector
##f64vector-length ##f64vector-ref ##f64vector-set! ##f64vector-shrink!
;;; ##symbol->string ##keyword->string
##closure-length ##closure-code ##closure-ref ##closure-set!
;;; ##subprocedure-id ##subprocedure-parent
;;; ##subprocedure-parent-info ##subprocedure-parent-name
##make-promise ##force ##void

##unchecked-structure-ref ##unchecked-structure-set!

##will? ##make-will ##will-testator
##mem-allocated? ##gc-hash-table?
##gc-hash-table-ref ##gc-hash-table-set! ##gc-hash-table-rehash!

##global-var-ref ##global-var-primitive-ref
##global-var-set! ##global-var-primitive-set!

##bignum.negative?
##bignum.adigit-length
##bignum.adigit-inc!
##bignum.adigit-dec!
##bignum.adigit-add!
##bignum.adigit-sub!
##bignum.mdigit-length
##bignum.mdigit-ref
##bignum.mdigit-set!
##bignum.mdigit-mul!
##bignum.mdigit-div!
##bignum.mdigit-quotient
##bignum.mdigit-remainder
##bignum.mdigit-test?

##bignum.adigit-ones?
##bignum.adigit-zero?
##bignum.adigit-negative?
##bignum.adigit-=
##bignum.adigit-<
##bignum.->fixnum
##bignum.<-fixnum
##bignum.adigit-shrink!
##bignum.adigit-copy!
##bignum.adigit-cat!
##bignum.adigit-bitwise-and!
##bignum.adigit-bitwise-ior!
##bignum.adigit-bitwise-xor!
##bignum.adigit-bitwise-not!

##bignum.fdigit-length
##bignum.fdigit-ref
##bignum.fdigit-set!

))

  (let ((name
         (if (symbol? form)
           form
           (car form))))
    (let ((val
           (if (symbol? form)
             (if (and (pair? exprs) (null? (cdr exprs)))
               (car exprs)
               (error "Incorrect define-prim"))
             (if (memq name inlinable-procs)
               `(lambda ,(cdr form)
                  ,form)
               (if (null? exprs)
                 (error "define-prim can't inline" name)
                 `(lambda ,(cdr form)
                    ,@exprs))))))
      `(define ,name
         (let ()
           (##declare
            (not inline)
            (standard-bindings)
            (extended-bindings))
           ,val)))))

;;;----------------------------------------------------------------------------

;; Macro to define structure accessors.

(##define-macro (macro-slot index struct . val)
  (if (null? val)
    `(##vector-ref ,struct ,index)
    `(##vector-set! ,struct ,index ,@val)))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Symbol objects

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

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Keyword objects

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

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Will objects

;; A will is represented by an object vector of length 3
;; slot 0 = link to next will in list of non-executable wills
;; slot 1 = testator
;; slot 2 = action procedure

(##define-macro (macro-make-will testator action)
  `(##make-will ,testator ,action))

(##define-macro (macro-will-testator w)        `(macro-slot 1 ,w))
(##define-macro (macro-will-testator-set! w x) `(macro-slot 1 ,w ,x))
(##define-macro (macro-will-action w)          `(macro-slot 2 ,w))
(##define-macro (macro-will-action-set! w x)   `(macro-slot 2 ,w ,x))

(##define-macro (macro-will-execute! will)
  `(let ((will ,will))
     (##declare (not interrupts-enabled))
     (let ((testator (macro-will-testator will))
           (action (macro-will-action will)))
       (macro-will-testator-set! will #f) ;; zap testator
       (macro-will-action-set! will #f)   ;; and action procedure
       (let ()
         (##declare (interrupts-enabled))
         (if action
           (action testator))
         (##void)))))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; GC hash tables

;; A GC hash table is represented by an object vector
;; slot 0 = link to next GC hash table
;; slot 1 = flags (1=weak keys, 2=weak values, 4=need rehashing, ...)
;; slot 2 = na (number of allocations before need to grow)
;; slot 3 = nd (number of deallocations before need to shrink)
;; slot 4 = key of entry #0
;; slot 5 = value of entry #0

(##define-macro (macro-gc-hash-table-nb-entries ht)
  `(##fixnum.arithmetic-shift-right
    (##fixnum.- (##vector-length ,ht) (macro-gc-hash-table-key0))
    1))

(##define-macro (macro-gc-hash-table-minimal-nb-entries) 5)

(##define-macro (macro-make-minimal-gc-hash-table flags count)
  `(let ((ht
          (##vector
           0
           ,flags
           ,count
           0 ;; min-count
           4 ;; free
           (macro-unused-obj) (macro-unused-obj)
           (macro-unused-obj) (macro-unused-obj)
           (macro-unused-obj) (macro-unused-obj)
           (macro-unused-obj) (macro-unused-obj)
           (macro-unused-obj) (macro-unused-obj))))
     (##subtype-set! ht (macro-subtype-weak))
     ht))

(##define-macro (macro-make-gc-hash-table flags count min-count free length)
  `(let ((ht
          (##make-vector
           (##fixnum.+ (##fixnum.arithmetic-shift-left ,length 1)
                       (macro-gc-hash-table-key0))
           (macro-unused-obj))))
     (macro-gc-hash-table-flags-set! ht ,flags)
     (macro-gc-hash-table-count-set! ht ,count)
     (macro-gc-hash-table-min-count-set! ht ,min-count)
     (macro-gc-hash-table-free-set! ht ,free)
     (##subtype-set! ht (macro-subtype-weak))
     ht))

(##define-macro (macro-gc-hash-table-flags ht)        `(macro-slot 1 ,ht))
(##define-macro (macro-gc-hash-table-flags-set! ht x) `(macro-slot 1 ,ht ,x))
(##define-macro (macro-gc-hash-table-count ht)        `(macro-slot 2 ,ht))
(##define-macro (macro-gc-hash-table-count-set! ht x) `(macro-slot 2 ,ht ,x))
(##define-macro (macro-gc-hash-table-min-count ht)       `(macro-slot 3 ,ht))
(##define-macro (macro-gc-hash-table-min-count-set! ht x)`(macro-slot 3 ,ht ,x))
(##define-macro (macro-gc-hash-table-free ht)         `(macro-slot 4 ,ht))
(##define-macro (macro-gc-hash-table-free-set! ht x)  `(macro-slot 4 ,ht ,x))

(##define-macro (macro-gc-hash-table-key0) 5)
(##define-macro (macro-gc-hash-table-val0) 6)

(##define-macro (macro-gc-hash-table-flag-weak-keys)      1)
(##define-macro (macro-gc-hash-table-flag-weak-vals)      2)
(##define-macro (macro-gc-hash-table-flag-key-moved)      4)
(##define-macro (macro-gc-hash-table-flag-entry-deleted)  8)
(##define-macro (macro-gc-hash-table-flag-mem-alloc-keys) 16)
(##define-macro (macro-gc-hash-table-flag-need-rehash)    32)

(##define-macro (macro-gc-hash-table-key-ref ht i*2)
  `(##vector-ref ,ht (##fixnum.+ ,i*2 (macro-gc-hash-table-key0))))
(##define-macro (macro-gc-hash-table-key-set! ht i*2 x)
  `(##vector-set! ,ht (##fixnum.+ ,i*2 (macro-gc-hash-table-key0)) ,x))

(##define-macro (macro-gc-hash-table-val-ref ht i*2)
  `(##vector-ref ,ht (##fixnum.+ ,i*2 (macro-gc-hash-table-val0))))
(##define-macro (macro-gc-hash-table-val-set! ht i*2 x)
  `(##vector-set! ,ht (##fixnum.+ ,i*2 (macro-gc-hash-table-val0)) ,x))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Continuation objects

;; A continuation is represented by an object vector of length 2
;; slot 0 = frame object
;; slot 1 = dynamic-environment

(##define-macro (macro-make-continuation frame denv)
  `(##subtype-set!
    (##vector ,frame ,denv)
    (macro-subtype-continuation)))

(##define-macro (macro-continuation-frame c)        `(macro-slot 0 ,c))
(##define-macro (macro-continuation-frame-set! c x) `(macro-slot 0 ,c ,x))
(##define-macro (macro-continuation-denv c)         `(macro-slot 1 ,c))
(##define-macro (macro-continuation-denv-set! c x)  `(macro-slot 1 ,c ,x))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Promise objects

;; A promise is represented by an object vector of length 2
;; slot 0 = thunk
;; slot 1 = result (eq? to promise object itself when not yet determined)

(##define-macro (macro-make-promise thunk)
  `(##make-promise thunk))

(##define-macro (macro-promise-thunk p)         `(macro-slot 0 ,p))
(##define-macro (macro-promise-thunk-set! p x)  `(macro-slot 0 ,p ,x))
(##define-macro (macro-promise-result p)        `(macro-slot 1 ,p))
(##define-macro (macro-promise-result-set! p x) `(macro-slot 1 ,p ,x))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Foreign objects

;; A foreign object is represented by an object vector of length 4
;; slot 0 = tags
;; slot 1 = C pointer to release function
;; slot 2 = C pointer to foreign data
;; slot 3 = Scheme strong reference

(##define-macro (macro-foreign-tags f)         `(macro-slot 0 ,f))
(##define-macro (macro-foreign-tags-set! f x)  `(macro-slot 0 ,f ,x))

;;;----------------------------------------------------------------------------

(##define-macro (macro-if-forces forces noforces)
  (if ((if (and (pair? ##compilation-options)
                (pair? (car ##compilation-options)))
           assq
           memq)
       'force
       ##compilation-options)
      forces
      noforces))

(##define-macro (macro-force-vars vars expr)
  (if ((if (and (pair? ##compilation-options)
                (pair? (car ##compilation-options)))
           assq
           memq)
       'force
       ##compilation-options)
      `(let ,(map (lambda (x) `(,x (##force ,x))) vars) ,expr)
      expr))

(##define-macro (macro-if-checks checks nochecks)
  (if ((if (and (pair? ##compilation-options)
                (pair? (car ##compilation-options)))
           assq
           memq)
       'check
       ##compilation-options)
      checks
      nochecks))

(##define-macro (macro-no-force vars expr)
  expr)

(##define-macro (macro-no-check var arg-num form expr)
  expr)

(##define-macro
  (define-prim-fold bool? form zero one two forcing pre-check . post-checks)
  (let* ((name-fn (car form))
         (name-param1 (cadr form))
         (name-param2 (caddr form))
         (name-others 'others)
         (name-result 'result)
         (name-folded-result 'folded-result)
         (param-name-map
          (list (cons name-param1 'param1) (cons name-param2 'param2)))
         (two-wrap
          (if (pair? (cadr two)) (car two) #f))
         (two-call
          (if (pair? (cadr two)) (cadr two) two)))

    (define (param-name sym)
      (cdr (assq sym param-name-map)))

    (define (rewrite expr)
      (let ((x (assq expr param-name-map)))
        (if x
          (cdr x)
          (if (pair? expr)
            (cons (car expr)
                  (map rewrite (cdr expr)))
            expr))))

    (define (parameter-list)
      (if (null? zero)
        ;; 1 or more arguments
        (list (param-name name-param1)
              '#!optional
              (list (param-name name-param2) '(macro-absent-obj))
              '#!rest
              name-others)
        ;; 0 or more arguments
        (list '#!optional
              (list (param-name name-param1) '(macro-absent-obj))
              (list (param-name name-param2) '(macro-absent-obj))
              '#!rest
              name-others)))

    (define (add-post-checks wrap expr arg-num cont)

      (define (add-wrap x)
        (if wrap
          (list wrap x)
          x))

      (define (inside lst)
        (if (null? lst)
          (if cont
            (cont (add-wrap name-result))
            (add-wrap name-result))
          (let ((check (car lst)))
            (list 'if
                  (list (car check) name-result)
                  (append (list (cadr check))
                          (if (eq? (car check) '##pair?)
                            (let ((x (list '##car name-result)))
                              (list (if arg-num
                                        (list '##fixnum.+ arg-num x)
                                        x)))
                            '())
                          (list ''()
                                name-fn
                                (param-name name-param1)
                                (param-name name-param2)
                                name-others))
                  (inside (cdr lst))))))

      (if (or cont (not (null? post-checks)))
        (list 'let
              (list (list name-result expr))
              (inside post-checks))
        (add-wrap expr)))

    (define (add-forcing names expr)
      (list forcing
            names
            expr))

    (define (add-pre-check name arg-num expr)
      (list pre-check
            name
            arg-num
            (cons name-fn
                  (cons (param-name name-param1)
                        (cons (param-name name-param2)
                              name-others)))
            expr))

    (define (exactly-1-arg)
      (add-forcing
       (list (param-name name-param1))
       (add-pre-check
        (param-name name-param1)
        1
        (if (pair? one)
          (add-post-checks
           #f
           (rewrite one)
           #f
           #f)
          (rewrite one)))))

    (define (exactly-2-args)
      (add-post-checks
       two-wrap
       (rewrite two-call)
       #f
       #f))

    (define (at-least-2-args)
      (list 'let
            'loop
            (append (if bool?
                      (list (list name-folded-result #t))
                      '())
                    (list (list name-param1 (param-name name-param1))
                          (list name-param2 (param-name name-param2))
                          (list 'lst name-others)
                          (list 'arg-num 0)))
            (add-post-checks
             two-wrap
             two-call
             'arg-num
             (lambda (result)
               (list 'if
                     '(##null? lst)
                     (if bool?
                       (list 'and
                             result
                             name-folded-result)
                       result)
                     (list 'let
                           '((next (##car lst)))
                           (add-forcing
                            '(next)
                            (add-pre-check
                             'next
                             '(##fixnum.+ arg-num 3)
                             (if bool?
                               (list 'loop
                                     (list 'and
                                           result
                                           name-folded-result)
                                     name-param2
                                     'next
                                     '(##cdr lst)
                                     '(##fixnum.+ arg-num 1))
                               (list 'loop
                                     result
                                     'next
                                     '(##cdr lst)
                                     '(##fixnum.+ arg-num 1)))))))))))

    (define (body)
      (cons 'cond
            (cons (list (list '##not
                              (list '##eq?
                                    (param-name name-param2)
                                    '(macro-absent-obj)))
                        (add-forcing
                         (list (param-name name-param1)
                               (param-name name-param2))
                         (add-pre-check
                          (param-name name-param1)
                          1
                          (add-pre-check
                           (param-name name-param2)
                           2
                           (list 'if
                                 (list '##null? name-others)
                                 (exactly-2-args)
                                 (at-least-2-args))))))
                  (append (if (null? zero)
                            '()
                            (list (list (list '##eq?
                                              (param-name name-param1)
                                              '(macro-absent-obj))
                                        zero)))
                          (list (list 'else
                                      (exactly-1-arg)))))))

    (list 'define-prim
          name-fn
          (list 'lambda
                (parameter-list)
                (body)))))

(##define-macro
  (define-prim-nary form zero one two forcing pre-check . post-checks)
  `(define-prim-fold #f ,form ,zero ,one ,two ,forcing ,pre-check ,@post-checks))

(##define-macro
  (define-prim-nary-bool form zero one two forcing pre-check . post-checks)
  `(define-prim-fold #t ,form ,zero ,one ,two ,forcing ,pre-check ,@post-checks))

(##define-macro (define-check-type type-id type predicate . arguments)

  (define (sym . lst)
    (string->symbol (apply string-append (map symbol->string lst))))

  (let ()

    (define macro-check-type (sym 'macro-check- type-id))
    (define ##fail-check-type (sym '##fail-check- type-id))

    `(begin
       (##define-macro (,(sym 'implement-check-type- type-id));;;;;;;;;;
         '(define-fail-check-type ,type-id ,type))

     (##define-macro (,macro-check-type var arg-num form expr)

       (define (rest-param x)
         (if (pair? x)
             (rest-param (cdr x))
             x))

       (define (nonrest-params x)
         (if (pair? x)
           (cons (car x) (nonrest-params (cdr x)))
           '()))

       (define (key-params x)
         (if (pair? x)
           (if (keyword? (car x))
             (cons (car x) (cons (cadr x) (key-params (cddr x))))
             (key-params (cdr x)))
           '()))

       (define (prekey-params x)
         (if (or (not (pair? x)) (keyword? (car x)))
           '()
           (cons (car x) (prekey-params (cdr x)))))

       (define (failure name)
         (let* ((k (key-params (cdr form)))
                (r (rest-param (cdr form)))
                (nr (nonrest-params (cdr form)))
                (pk (prekey-params nr)))
           (if (and (null? k) (not (null? r)))
             `(,name ,arg-num '() ,(car form) ,@pk ,r)
             `(,name
               ,arg-num
               ,(if (and (null? k) (null? r))
                  (car form)
                  `(##list ,(car form) ,@k ,@(if (null? r) '() (list r))))
               ,@pk))))

       `(macro-if-checks
          (if (,',predicate ,var ,@',arguments)
            ,expr
            ,(failure ',##fail-check-type))
          ,expr)))))

(##define-macro (define-check-index-range-macro type-id predicate . arguments)

  (define (sym . lst)
    (string->symbol (apply string-append (map symbol->string lst))))

  (let ()

    (define macro-check-type (sym 'macro-check- type-id))

    `(##define-macro (,macro-check-type var arg-num ,@arguments form expr)

       (define (rest-param x)
         (if (pair? x)
             (rest-param (cdr x))
             x))

       (define (nonrest-params x)
         (if (pair? x)
           (cons (car x) (nonrest-params (cdr x)))
           '()))

       (define (key-params x)
         (if (pair? x)
           (if (keyword? (car x))
             (cons (car x) (cons (cadr x) (key-params (cddr x))))
             (key-params (cdr x)))
           '()))

       (define (prekey-params x)
         (if (or (not (pair? x)) (keyword? (car x)))
           '()
           (cons (car x) (prekey-params (cdr x)))))

       (define (failure name)
         (let* ((k (key-params (cdr form)))
                (r (rest-param (cdr form)))
                (nr (nonrest-params (cdr form)))
                (pk (prekey-params nr)))
           `(,name
             ,arg-num
             ,(if (and (null? k) (null? r))
                (car form)
                `(##list ,(car form) ,@k ,@(if (null? r) '() (list r))))
             ,@pk)))

       `(macro-if-checks
          (if (##fixnum? ,var)
            (if (,',predicate ,var ,@,(cons 'list arguments))
              ,expr
              ,(failure '##raise-range-exception))
            (if (##bignum? ,var)
              ,(failure '##raise-range-exception)
              ,(failure '##fail-check-exact-integer)))
          ,expr))))

(##define-macro (define-fail-check-type type-name . type-id)

  (define (sym . lst)
    (string->symbol (apply string-append (map symbol->string lst))))

  (let ()

    (define ##fail-check-type (sym '##fail-check- type-name))

    `(define-prim (,##fail-check-type arg-num proc . args)
       (##raise-type-exception
        arg-num
        ,(if (pair? type-id) (car type-id) `',type-name)
        proc
        args))))

(##define-macro (define-library-type . args)
  `(define-library-type-expand define-type define-library-type ,@args))

(##define-macro (define-library-type-expand type-definer form-name . args)

  (define (generate
           name
           flags
           id
           extender
           constructor
           constant-constructor
           predicate
           implementer
           type-exhibitor
           prefix
           fields
           total-fields)

    (let ((check
           (##symbol-append 'macro-check- name)))

      (define (generate-getter-and-setter field tail)
        (let* ((descr
                (##cdr field))
               (field-name
                (##vector-ref descr 0))
               (field-index
                (##vector-ref descr 1))
               (getter
                (##vector-ref descr 2))
               (setter
                (##vector-ref descr 3))
               (getter-def
                (if getter
                  (let ((getter-name
                         (if (##eq? getter #t)
                           (##symbol-append prefix
                                            name
                                            '-
                                            field-name)
                           getter))
                        (macro-getter-name
                         (if (##eq? getter #t)
                           (##symbol-append 'macro-
                                            name
                                            '-
                                            field-name)
                           (##symbol-append 'macro-
                                            getter))))
                    `((define-prim (,getter-name obj)
                        (macro-force-vars (obj)
                          (,check
                           obj
                           1
                           (,getter-name obj)
                           (,macro-getter-name obj))))))
                  `()))
               (setter-def
                (if setter
                  (let ((setter-name
                         (if (##eq? setter #t)
                           (##symbol-append prefix
                                            name
                                            '-
                                            field-name
                                            '-set!)
                           setter))
                        (macro-setter-name
                         (if (##eq? setter #t)
                           (##symbol-append 'macro-
                                            name
                                            '-
                                            field-name
                                            '-set!)
                           (##symbol-append 'macro-
                                            setter))))
                    `((define-prim (,setter-name obj val)
                        (macro-force-vars (obj)
                          (,check
                           obj
                           1
                           (,setter-name obj val)
                           (,macro-setter-name obj val))))))
                  `())))
          (##append getter-def (##append setter-def tail))))

      (define (generate-constructor-predicate-getters-setters)
        `(,@(if #f;constructor;;;;;;;;;;;
              `((define-prim (,(##car constructor) ,@parameters)
                  ...));;;;;;;;;;
              `())

          ,@(if predicate
              `((define-prim (,predicate obj)
                  (macro-force-vars (obj)
                    (,(##symbol-append 'macro- name '?) obj))))
              `())

          ,@(let loop ((lst1 (##reverse fields))
                       (lst2 '()))
              (if (##pair? lst1)
                (loop (##cdr lst1)
                      (generate-getter-and-setter (##car lst1) lst2))
                lst2))))

      `(begin
         (##define-macro (,(##symbol-append 'implement-library-type- name))
           `(begin
              (,',(##symbol-append 'implement-type- name))
              (,',(##symbol-append 'implement-check-type- name))
              ,@',(generate-constructor-predicate-getters-setters)))
         ,@(if extender
             `((##define-macro (,extender . args)
                 `(define-library-type-expand
                   ,',(##symbol-append 'define-type-of- name)
                   ,',extender
                   ,@args)))
             `())
         (,type-definer ,name
           ,@(if id
               `(id: ,id)
               `())
           ,@(if (##fixnum.= (##fixnum.bitwise-and flags 1) 0)
               `()
               `(opaque:))
           ,@(if extender
               `(extender: ,(##symbol-append 'define-type-of- name))
               `())
           macros:
           prefix: macro-
           type-exhibitor: ,(##symbol-append 'macro-type- name)
           constructor: ,(##symbol-append 'macro-make- name)
           constant-constructor: ,(##symbol-append 'macro-make-constant- name)
           implementer: ,(##symbol-append 'implement-type- name)
           ,@(##map (lambda (field)
                      (let* ((descr
                              (##cdr field))
                             (field-name
                              (##vector-ref descr 0))
                             (getter
                              (##vector-ref descr 2))
                             (setter
                              (##vector-ref descr 3))
                             (options
                              (##vector-ref descr 4))
                             (attributes
                              (##vector-ref descr 5)))
                        `(,field-name
                          ,@(if (##symbol? getter)
                              `(,getter)
                              `())
                          ,@(if (##symbol? setter)
                              `(,setter)
                              `())
                          ,@(if (##fixnum.= (##fixnum.bitwise-and options 1) 0)
                              `()
                              `(unprintable:))
                          ,@(if (##fixnum.= (##fixnum.bitwise-and options 2) 0)
                              `()
                              `(read-only:))
                          ,@(if (##fixnum.= (##fixnum.bitwise-and options 4) 0)
                              `()
                              `(equality-skip:))
                          ,@(let loop ((lst1 attributes)
                                       (lst2 '()))
                              (if (##pair? lst1)
                                (loop (##cdr lst1)
                                      (let ((x (##car lst1)))
                                        (##cons (##car x)
                                                (##cons (##cdr x)
                                                        lst2))))
                                (##reverse lst2))))))
                    fields))
         (define-check-type
           ,name
           (,(##symbol-append 'macro-type- name))
           ,(##symbol-append 'macro- name '?)))))

  (##define-type-parser
   form-name
   #f
   args
   generate))

(##define-macro (define-exception-type . args)
  `(define-library-type ,@args))

;;;----------------------------------------------------------------------------

(##include "_kernel#.scm")
(##include "_thread#.scm")
(##include "_system#.scm")
(##include "_num#.scm")
(##include "_io#.scm")
(##include "_eval#.scm")
(##include "_repl#.scm")
(##include "_std#.scm")
(##include "_nonstd#.scm")

;;;============================================================================
