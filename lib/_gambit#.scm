;;;============================================================================

;;; File: "_gambit#.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Define macro-define-syntax.

(##include "~~lib/_define-syntax.scm")

;;;----------------------------------------------------------------------------

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

(##define-macro (macro-subtype-ovector? x) `(##fx< ,x 8))
(##define-macro (macro-subtype-bvector? x) `(##fx< 16 ,x))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Special objects.

(##define-macro (macro-absent-obj)   `',(##absent-object))
(##define-macro (macro-unbound1-obj) `',(##type-cast -7 (##type #f)))
(##define-macro (macro-unbound2-obj) `',(##type-cast -8 (##type #f)))
(##define-macro (macro-unused-obj)   `',(##type-cast -14 (##type #f)))
(##define-macro (macro-deleted-obj)  `',(##type-cast -15 (##type #f)))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(##define-macro (macro-end-of-cont-marker) `(##void))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; System procedure classes.

(macro-define-syntax define-prim
  (lambda (stx)
    (syntax-case stx ()

      ((_ (id . params) body ...)
       (let* ((name
               (syntax->datum #'id))
              (pi
               (c#target.prim-info name))
              (inlinable?
               (and pi
                    (c#proc-obj-inline pi)
                    (let loop ((lst (syntax->datum #'params)))
                      (if (pair? lst)
                          (if (memq (car lst) '(#!optional #!key #!rest))
                              #f
                              (loop (cdr lst)))
                          (null? lst))))))
         (cond (inlinable?
                #'(define-prim id
                    (lambda params
                      (id . params))))
               ((not (null? (syntax->datum #'(body ...))))
                #'(define-prim id
                    (lambda params
                      (##declare (inline))
                      body ...)))
               (else
                (error "define-prim can't inline" name)))))

      ((_ id val)
       #'(define-prim-no-inline id val)))))

(macro-define-syntax define-prim-no-inline
  (lambda (stx)
    (syntax-case stx ()

      ((_ (id . params) body ...)
       #'(define-prim-no-inline id
           (lambda params
             (##declare (inline))
             body ...)))

      ((_ id val)
       #'(define id
           (let ()
             (##declare
               (not inline)
               (standard-bindings)
               (extended-bindings))
             val))))))

(##define-syntax declare-safe-define-procedure
  (lambda (src)

    (define (err)
      (##raise-expression-parsing-exception
       'ill-formed-special-form
       src
       (##source-strip (car (##source-strip src)))))

    (##deconstruct-call
     src
     2
     (lambda (arg-src)
       (let ((arg (##desourcify arg-src))
             (meta-info-tbl (vector-ref (##compilation-ctx) 2)))
         (if arg
             (table-set! meta-info-tbl 'safe-define-procedure arg)
             (if (eq? (table-ref meta-info-tbl 'safe-define-procedure #f)
                      #t)
                 (table-set! meta-info-tbl 'safe-define-procedure))))
       `(##begin)))))

(##define-syntax standard
  (lambda (src)

    (define (err)
      (##raise-expression-parsing-exception
       'ill-formed-special-form
       src
       (##source-strip (car (##source-strip src)))))

    (define (proc sym)
      `(##let () (##namespace ("")) ,sym))

    (##deconstruct-call
     src
     2
     (lambda (arg-src)
       (let ((arg (##desourcify arg-src)))
         (cond ((symbol? arg)
                (proc arg))
               ((pair? arg)
                (let ((name (##desourcify (car arg))))
                  (if (symbol? name)
                      (cons (proc name) (cdr arg))
                      (err))))
               (else
                (err))))))))

(##define-syntax primitive
  (lambda (src)

    (define (err)
      (##raise-expression-parsing-exception
       'ill-formed-special-form
       src
       (##source-strip (car (##source-strip src)))))

    (define (symbol-append . lst)
      (string->symbol (string-concatenate (map symbol->string lst))))

    (define (prim sym)
      (symbol-append '|##| sym))

    (##deconstruct-call
     src
     2
     (lambda (arg-src)
       (let ((arg (##desourcify arg-src)))
         (cond ((symbol? arg)
                (prim arg))
               ((pair? arg)
                (let ((name (##desourcify (car arg))))
                  (if (symbol? name)
                      (cons (prim name) (cdr arg))
                      (err))))
               (else
                (err))))))))

(##define-syntax define-procedure
  (lambda (src)

    (define (err)
      (##raise-expression-parsing-exception
       'ill-formed-special-form
       src
       (##source-strip (car (##source-strip src)))))

    (define (safe-define-procedure?)
      (let* ((cc
              (##global-var-ref
               (##make-global-var '##compilation-ctx)))
             (meta-info-tbl
              (and (##not (##unbound? cc))
                   (vector-ref (cc) 2))))
        (and meta-info-tbl
             (table-ref meta-info-tbl 'safe-define-procedure #f))))

    (define (expand src)
      (##deconstruct-call
       src
       -2
       (lambda (pattern-src . body)
         (let* ((pattern (##source-strip pattern-src))
                (head (and (pair? pattern) (##source-strip (car pattern))))
                (prim? (and (pair? head)
                            (pair? (cdr head))
                            (memq (##source-strip (car head))
                                  '(primitive prim&proc))))
                (name (if prim?
                          (##source-strip (cadr head))
                          head)))
           (if (not (symbol? name))
               (##raise-expression-parsing-exception
                'ill-formed-special-form
                src
                (##source-strip (car (##source-strip src))))
               (parse-parameters (and prim? (car prim?))
                                 name
                                 body
                                 (cdr pattern)))))))

    (define object-check '(object))
    (define strict-object-check '(strict-object))
    (define aux-suffix '-aux)

    (define (parse-check check-src)
      (let ((check (##source-strip check-src)))
        (cond ((symbol? check)
               (list check))
              ((and (pair? check)
                    (symbol? (##source-strip (car check))))
               (cons (##source-strip (car check))
                     (cdr check)))
              (else
               #f))))

    (define (parse-type type-src)
      (let ((type (##source-strip type-src)))
        (if (and (pair? type)
                 (eq? 'and (##source-strip (car type))))
            (let loop ((lst (cdr type)) (rev-checks '()))
              (if (pair? lst)
                  (let ((check (parse-check (car lst))))
                    (and check
                         (loop (cdr lst) (cons check rev-checks))))
                  (reverse rev-checks)))
            (let ((check (parse-check type-src)))
              (and check
                   (list check))))))

    (define (parse-parameters prim? name body params)
      (let loop ((lst params)
                 (rev-req '())
                 (rev-opt '()))

        (define (parse-rest-param param)
          (cond ((symbol? param)
                 (process-parameters prim?
                                     name
                                     body
                                     (reverse rev-req)
                                     (reverse rev-opt)
                                     (vector param (list object-check))))
                ((pair? param)
                 (let ((len (##proper-length param)))
                   (if (eqv? len 2)
                       (let* ((var-src (car param))
                              (var (##source-strip var-src))
                              (checks (parse-type (cadr param))))
                         (if checks
                             (process-parameters prim?
                                                 name
                                                 body
                                                 (reverse rev-req)
                                                 (reverse rev-opt)
                                                 (vector var checks))
                             (err)))
                       (err))))
                (else
                 (err))))

        (cond ((null? lst)
               (process-parameters prim?
                                   name
                                   body
                                   (reverse rev-req)
                                   (reverse rev-opt)
                                   #f))
              ((pair? lst)
               (let* ((param-src (car lst))
                      (param (##source-strip param-src)))
                 (cond ((and (pair? (cdr lst))
                             (null? (cddr lst))
                             (eq? (##source-strip (cadr lst)) '...))
                        (parse-rest-param param))
                       ((and (null? rev-opt) (symbol? param))
                        (loop (cdr lst)
                              (cons (vector param (list object-check))
                                    rev-req)
                              rev-opt))
                       ((pair? param)
                        (let ((len (##proper-length param)))
                          (if (or (and (eqv? len 2) (null? rev-opt))
                                  (eqv? len 3))
                              (let* ((var-src (car param))
                                     (var (##source-strip var-src))
                                     (checks (parse-type (cadr param))))
                                (cond ((not checks)
                                       (err))
                                      ((eqv? len 3)
                                       (let ((default-src (caddr param)))
                                         (loop (cdr lst)
                                               rev-req
                                               (cons (vector var
                                                             checks
                                                             default-src)
                                                     rev-opt))))
                                      (else
                                       (loop (cdr lst)
                                             (cons (vector var
                                                           checks)
                                                     rev-req)
                                             rev-opt))))
                              (err))))
                       (else
                        (err)))))
              (else
               (parse-rest-param (##source-strip lst))))))

    (define (var-name param)
      (if (symbol? param)
          param
          (vector-ref param 0)))

    (define (var-checks param)
      (vector-ref param 1))

    (define (default param)
      (vector-ref param 2))

    (define (param-name param)
      (symbol-append '% (var-name param)))

    (define (exception-param-name param)
      (if (optional? param)
          (param-name param)
          (var-name param)))

    (define (optional? param)
      (and (vector? param)
           (fx= 3 (vector-length param))))

    (define (force? param)
      (not (equal? (car (var-checks param)) object-check)))

    (define (symbol-append . lst)
      (string->symbol (string-concatenate (map symbol->string lst))))

    (define (prim sym)
      (symbol-append '|##| sym))

    (define (process-parameters prim?
                                name
                                body
                                req-params
                                opt-params
                                rest-param)

      (define with-aux?
        (and (eq? prim? 'prim&proc) rest-param))

      (define (gen-definition kind)
        (let* ((req-opt-params
                (append req-params opt-params))
               (prim-name
                (prim name))
               (proc-name
                (case kind
                  ((procedure) name)
                  ((primitive) prim-name)
                  ((primitive-aux) (prim (symbol-append name aux-suffix))))))

          (define (gen-bind-non-opt expr)
            (let ((params
                   (if (not rest-param)
                       req-params
                       (append req-params (list rest-param)))))
              (if (null? params)
                  expr
                  `(##let ,(map (lambda (param)
                                  (list (var-name param) (param-name param)))
                                params)
                          ,expr))))

          (define (gen-force expr)
            (if (eq? kind 'primitive-aux)
                expr
                (let ((force-params
                       (##append-lists
                        (map (lambda (param)
                               (if (force? param) (list (param-name param)) '()))
                             req-opt-params))))
                  (if (null? force-params)
                      expr
                      `(macro-force-vars ,force-params ,expr)))))

          (define (gen-default param expr)
            (if (optional? param)
                (let ((def-expr (default param)))
                  `(##let ((,(var-name param)
                            ,(if (equal? (##desourcify def-expr)
                                         '(macro-absent-obj))
                                 (param-name param)
                                 `(##if (##eq? ,(param-name param)
                                               (macro-absent-obj))
                                        ,def-expr
                                        ,(param-name param)))))
                          ,expr))
                expr))

          (define (gen-check param arg-num check expr)
            (if (or (equal? check object-check)
                    (equal? check strict-object-check)
                    (not (eq? kind 'procedure)))
                expr
                `(,(symbol-append 'macro-check- (car check))
                  ,(var-name param)
                  '(,arg-num . ,(var-name param))
                  ,@(cdr check)
                  ((%procedure%)
                   ,@(append (map exception-param-name req-opt-params)
                             (if (not rest-param)
                                 '()
                                 (exception-param-name rest-param))))
                  ,expr)))

          (define (gen-checks param arg-num checks expr)
            (if (pair? checks)
                (gen-check param
                           arg-num
                           (car checks)
                           (gen-checks param
                                       arg-num
                                       (cdr checks)
                                       expr))
                expr))

          (define (gen-defaults-and-checks params arg-num expr)
            (if (null? params)
                expr
                (let ((param (car params)))
                  (gen-default param
                               (gen-checks param
                                           arg-num
                                           (var-checks param)
                                           (gen-defaults-and-checks
                                            (cdr params)
                                            (fx+ arg-num 1)
                                            expr))))))

          (define (gen-body)
            (let ((req (map var-name req-params))
                  (opt (map var-name opt-params)))
              (if with-aux?
                  (if (eq? kind 'primitive-aux)
                      `(##let ()
                         ,@body)
                      `(##let ()
                         (##declare (not interrupts-enabled))
                         (,(prim (symbol-append name aux-suffix))
                          ,@req
                          ,@opt
                          ,(var-name rest-param))))
                  (if (or (null? body)
                          (and (eq? prim? 'prim&proc)
                               (eq? kind 'procedure)))
                      (if (eq? kind 'procedure)
                          `(##let ()
                             (##declare (not interrupts-enabled))
                             (primitive (,proc-name ,@req ,@opt)))
                          `(##let ()
                             (##declare (not interrupts-enabled))
                             (##declare (not safe))
                             (,proc-name ,@req ,@opt)))
                      `(##let ()
                         ,@body)))))

          (define (gen-block expr)
            expr #; ;; remove after next release
            `(cond-expand ((compilation-target (_))
                           ;; avoid ##declare-scope which is not
                           ;; implemented by interpreter
                           ,expr)
                          (else
                           (##declare-scope
                            (##begin
                             (##declare (block))
                             ,expr)))))

          (let* ((param-list-tail
                  (if (not rest-param)
                      '()
                      (if (eq? kind 'primitive-aux)
                          (list (param-name rest-param))
                          (param-name rest-param))))
                 (param-list
                  (append
                   (map param-name req-params)
                   (if (null? opt-params)
                       param-list-tail
                       (cons '#!optional
                             (append
                              (map (lambda (param)
                                     `(,(param-name param)
                                       (macro-absent-obj)))
                                   opt-params)
                              param-list-tail)))))
                 (expansion
                  (gen-block
                   `(##define ,proc-name
                      (##lambda ,param-list
                        (##let ((%procedure% (##lambda () ,name)))
                          (##declare (extended-bindings))
                          ,@(if (safe-define-procedure?)
                                `((##declare (safe)))
                                `((##declare (not safe))
                                  (##include "~~lib/gambit/prim/prim#.scm")))
                          ,(gen-force
                            (gen-bind-non-opt
                             (gen-defaults-and-checks
                              req-opt-params
                              1
                              (gen-body))))))))))
            ;;(pp (##desourcify expansion))
            expansion)))

      (if (and (null? body) rest-param)
          (error "define-procedure with empty body does not support rest parameter")
          (if (eq? prim? 'prim&proc)
              `(##begin
                ,@(if rest-param
                      `(,(gen-definition 'primitive-aux))
                      `())
                ,(gen-definition 'primitive)
                ,(gen-definition 'procedure))
              (gen-definition (or prim? 'procedure)))))

    (expand src)))

(##define-syntax define-primitive
  (lambda (src)

    (define (err)
      (##raise-expression-parsing-exception
       'ill-formed-special-form
       src
       (##source-strip (car (##source-strip src)))))

    (##deconstruct-call
     src
     -2
     (lambda (pattern-src . body)
       (let ((pattern (##desourcify pattern-src)))
         (cond ((pair? pattern)
                `(define-procedure ((primitive ,(car pattern)) ,@(cdr pattern))
                   ,@body))
               (else
                (err))))))))

(##define-syntax define-prim&proc
  (lambda (src)

    (define (err)
      (##raise-expression-parsing-exception
       'ill-formed-special-form
       src
       (##source-strip (car (##source-strip src)))))

    (##deconstruct-call
     src
     -2
     (lambda (pattern-src . body)
       (let ((pattern (##desourcify pattern-src)))
         (cond ((pair? pattern)
                `(define-procedure ((prim&proc ,(car pattern)) ,@(cdr pattern))
                   ,@body))
               (else
                (err))))))))

;;;----------------------------------------------------------------------------

;; Macro to define structure accessors.

(##define-macro (macro-slot index struct . val)
  (if (null? val)
    `(##vector-ref ,struct ,index)
    `(##vector-set! ,struct ,index ,@val)))

(##define-macro (macro-struct-slot index struct . val)
  (if (null? val)
    `(##unchecked-structure-ref ,struct ,index #f #f)
    `(##unchecked-structure-set! ,struct ,@val ,index #f #f)))

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
;; slot 2 = count (nb. of keys in table)
;; slot 3 = min-count (nb. of keys below which table needs to shrink)
;; slot 4 = free (nb. of keys that can be added to table before need to grow)
;; slot 5 = key of entry #0
;; slot 6 = value of entry #0

(##define-macro (macro-gc-hash-table-nb-entries ht)
  `(##fxwraplogical-shift-right
    (##fx- (##vector-length ,ht) (macro-gc-hash-table-key0))
    1))

(##define-macro (macro-gc-hash-table-minimal-nb-entries) 5)
(##define-macro (macro-gc-hash-table-minimal-free) 2) ;; need 2 free entries for union/find

(##define-macro (macro-make-minimal-gc-hash-table flags count)
  `(let ((ht
          (##vector
           0
           ,flags
           ,count
           0 ;; min-count
           3 ;; free = (- (macro-gc-hash-table-minimal-nb-entries)
             ;;           (macro-gc-hash-table-minimal-free))
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
           (##fx+ (##fxarithmetic-shift-left ,length 1)
                  (macro-gc-hash-table-key0))
           (macro-unused-obj))))
     (macro-gc-hash-table-flags-set! ht ,flags)
     (macro-gc-hash-table-count-set! ht ,count)
     (macro-gc-hash-table-min-count-set! ht ,min-count)
     (macro-gc-hash-table-free-set! ht ,free)
     (##subtype-set! ht (macro-subtype-weak))
     ht))

(##define-macro (macro-gc-hash-table-size ht)
  `(##fxarithmetic-shift-right
    (##fx- (##vector-length ,ht) (macro-gc-hash-table-key0))
    1))

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
(##define-macro (macro-gc-hash-table-flag-union-find)     64)

(##define-macro (macro-gc-hash-table-key-ref ht i*2)
  `(##vector-ref ,ht (##fx+ ,i*2 (macro-gc-hash-table-key0))))
(##define-macro (macro-gc-hash-table-key-set! ht i*2 x)
  `(##vector-set! ,ht (##fx+ ,i*2 (macro-gc-hash-table-key0)) ,x))

(##define-macro (macro-gc-hash-table-val-ref ht i*2)
  `(##vector-ref ,ht (##fx+ ,i*2 (macro-gc-hash-table-val0))))
(##define-macro (macro-gc-hash-table-val-set! ht i*2 x)
  `(##vector-set! ,ht (##fx+ ,i*2 (macro-gc-hash-table-val0)) ,x))

;;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Continuation objects

;; A continuation is represented by an object vector of length 2
;; slot 0 = frame object
;; slot 1 = dynamic-environment

(##define-macro (macro-make-continuation frame denv)
  `(##make-continuation ,frame ,denv))

(##define-macro (macro-continuation-frame c)
  `(##continuation-frame ,c))

(##define-macro (macro-continuation-frame-set! c x)
  `(##continuation-frame-set! ,c ,x))

(##define-macro (macro-continuation-denv c)
  `(##continuation-denv ,c))

(##define-macro (macro-continuation-denv-set! c x)
  `(##continuation-denv-set! ,c ,x))

;;;----------------------------------------------------------------------------

(macro-define-syntax macro-target
  (lambda (stx)
    (syntax-case stx ()
      ((_)
       (let ((target
              (let* ((co
                      (##global-var-ref
                       (##make-global-var '##compilation-options)))
                     (comp-opts
                      (if (##unbound? co) '() co))
                     (t
                      (assq 'target comp-opts)))
                (if t (cadr t) 'C))))
         (datum->syntax stx `',target))))))

(macro-define-syntax macro-case-target
  (lambda (stx)
    (syntax-case stx (else)
      ((_ . clauses)
       (let ((target
              (let* ((co
                      (##global-var-ref
                       (##make-global-var '##compilation-options)))
                     (comp-opts
                      (if (##unbound? co) '() co))
                     (t
                      (assq 'target comp-opts)))
                (if t (cadr t) 'C))))
         (let loop ((clauses (syntax->list #'clauses)))
           (if (pair? clauses)
               (syntax-case (car clauses) (else)
                 ((else . body)
                  #'(begin . body))
                 ((cases . body)
                  (if (memq target (syntax->datum #'cases))
                      #'(begin . body)
                      (loop (cdr clauses)))))
               #'(begin))))))))

(macro-define-syntax macro-if2-compilation-option
  (lambda (stx)
    (syntax-case stx ()
      ((_ option have-option dont-have-option)
       (if (let* ((co
                   (##global-var-ref
                    (##make-global-var '##compilation-options)))
                  (comp-opts
                   (if (##unbound? co) '() co)))
             (assq (syntax->datum #'option) comp-opts))

           #'have-option

           #'dont-have-option)))))

(macro-define-syntax macro-if-compilation-option
  (lambda (stx)
    (syntax-case stx ()
      ((_ option have-option)
       #'(macro-if2-compilation-option option have-option (begin)))
      ((_ option have-option dont-have-option)
       #'(macro-if2-compilation-option option have-option dont-have-option)))))

(macro-define-syntax macro-if-not-compilation-option
  (lambda (stx)
    (syntax-case stx ()
      ((_ option dont-have-option)
       #'(macro-if2-compilation-option option (begin) dont-have-option))
      ((_ option dont-have-option have-option)
       #'(macro-if2-compilation-option option have-option dont-have-option)))))

(macro-define-syntax macro-if-auto-forcing
  (lambda (stx)
    (syntax-case stx ()
      ((_ forcing noforcing)
       #'(cond-expand
          (enable-auto-forcing
           forcing)
          (else
           noforcing))))))

(macro-define-syntax macro-force-vars
  (lambda (stx)
    (syntax-case stx ()
      ((_ vars expr)
       (syntax-case (datum->syntax
                     #'vars
                     (map (lambda (x) `(,x (##force ,x)))
                          (syntax->list #'vars)))
           ()
         (bindings
          #'(cond-expand
             (enable-auto-forcing
              (let bindings expr))
             (else
              expr))))))))

(macro-define-syntax macro-if-checks
  (lambda (stx)
    (syntax-case stx ()
      ((_ checks nochecks)
       #'(cond-expand
          (enable-type-checking
           checks)
          (else
           nochecks))))))

(macro-define-syntax macro-no-force
  (lambda (stx)
    (syntax-case stx ()
      ((_ vars expr)
       #'expr))))

(macro-define-syntax macro-no-check
  (lambda (stx)
    (syntax-case stx ()
      ((_ var arg-id form expr)
       #'expr))))

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
                                        (list '##fx+ arg-num x)
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
                             '(##fx+ arg-num 3)
                             (if bool?
                               (list 'loop
                                     (list 'and
                                           result
                                           name-folded-result)
                                     name-param2
                                     'next
                                     '(##cdr lst)
                                     '(##fx+ arg-num 1))
                               (list 'loop
                                     result
                                     'next
                                     '(##cdr lst)
                                     '(##fx+ arg-num 1)))))))))))

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
          (cons name-fn (parameter-list))
          (body))))

(##define-macro
  (define-prim-nary form zero one two forcing pre-check . post-checks)
  `(define-prim-fold #f ,form ,zero ,one ,two ,forcing ,pre-check ,@post-checks))

(##define-macro
  (define-prim-nary-bool form zero one two forcing pre-check . post-checks)
  `(define-prim-fold #t ,form ,zero ,one ,two ,forcing ,pre-check ,@post-checks))

(##define-macro (define-check-type type-and-test-name type predicate . arguments)

  (define (symbol-append . lst)
    (string->symbol (string-concatenate (map symbol->string lst))))

  (let ((type-name
         (if (symbol? type-and-test-name)
             type-and-test-name
             (car type-and-test-name)))
        (test-name
         (if (symbol? type-and-test-name)
             type-and-test-name
             (cadr type-and-test-name))))

    (define macro-check-test (symbol-append 'macro-check- test-name))
    (define macro-test-test (symbol-append 'macro-test- test-name))

    (define macro-fail-check-type (symbol-append 'macro-fail-check- type-name))
    (define ##fail-check-type (symbol-append '##fail-check- type-name))

    `(begin

       ,@(if type
             `((##define-macro (,(symbol-append 'implement-check-type- type-name))
                 '(define-fail-check-type ,type-name ,type))
               (##define-macro (,macro-fail-check-type arg-id form)
                 `(macro-handle-failure ,',##fail-check-type ,arg-id ,form)))
             `())

       (##define-macro (,macro-test-test var)
         `(,',predicate ,var ,@',arguments))

       (##define-macro (,macro-check-test var arg-id form expr)
         `(macro-if-checks
           (if (,',predicate ,var ,@',arguments)
               ,expr
               (,',macro-fail-check-type ,arg-id ,form))
           ,expr)))))

(##define-macro (define-fail-check-type type-name . type-id)

  (define (symbol-append . lst)
    (string->symbol (string-concatenate (map symbol->string lst))))

  (let ()

    (define ##fail-check-type (symbol-append '##fail-check- type-name))

    `(define-prim (,##fail-check-type arg-id proc . args)
       (##raise-type-exception
        arg-id
        ,(if (pair? type-id) (car type-id) `',type-name)
        proc
        args))))

(##define-macro (macro-handle-failure failure-handler arg-id form)

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

  (let* ((k (key-params (cdr form)))
         (r (rest-param (cdr form)))
         (nr (nonrest-params (cdr form)))
         (pk (prekey-params nr)))
    (if (and (null? k) (not (null? r)))
        `(,failure-handler ,arg-id '() ,(car form) ,@pk ,r)
        `(,failure-handler
          ,arg-id
          ,(if (and (null? k) (null? r))
               (car form)
               `(##list ,(car form) ,@k ,@(if (null? r) '() (list r))))
          ,@pk))))

(##define-macro (define-check-index-range-macro type-id predicate . arguments)

  (define (symbol-append . lst)
    (string->symbol (string-concatenate (map symbol->string lst))))

  (let ()

    (define macro-check-type (symbol-append 'macro-check- type-id))

    `(##define-macro (,macro-check-type var arg-id ,@arguments form expr)
       `(macro-if-checks
          (if (##fixnum? ,var)
            (if (,',predicate ,var ,@,(cons 'list arguments))
              ,expr
              (macro-handle-failure ##raise-range-exception ,arg-id ,form))
            (if (##bignum? ,var)
              (macro-handle-failure ##raise-range-exception ,arg-id ,form)
              (macro-handle-failure ##fail-check-exact-integer ,arg-id ,form)))
          ,expr))))

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
           copier
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
               (fsetter
                (##vector-ref descr 4))
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
                  `()))
               (fsetter-def
                (if fsetter
                  (let ((fsetter-name
                         (if (##eq? fsetter #t)
                           (##symbol-append prefix
                                            name
                                            '-
                                            field-name
                                            '-set)
                           fsetter))
                        (macro-fsetter-name
                         (if (##eq? fsetter #t)
                           (##symbol-append 'macro-
                                            name
                                            '-
                                            field-name
                                            '-set)
                           (##symbol-append 'macro-
                                            fsetter))))
                    `((define-prim (,fsetter-name obj val)
                        (macro-force-vars (obj)
                          (,check
                           obj
                           1
                           (,fsetter-name obj val)
                           (,macro-fsetter-name obj val))))))
                  `())))
          (##append getter-def
                    (##append setter-def
                              (##append fsetter-def tail)))))

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
           ,@(if (##fx= (##fxand flags 1) 0)
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
           copier: #f
           implementer: ,(##symbol-append 'implement-type- name)
           no-functional-setter:
           ,@(##map (lambda (field)
                      (let* ((descr
                              (##cdr field))
                             (field-name
                              (##vector-ref descr 0))
                             (getter
                              (##vector-ref descr 2))
                             (setter
                              (##vector-ref descr 3))
                             (fsetter
                              (##vector-ref descr 4))
                             (options
                              (##vector-ref descr 5))
                             (attributes
                              (##vector-ref descr 6)))
                        `(,field-name
                          ,@(if (##symbol? getter)
                              `(,getter
                                ,@(if (##symbol? setter)
                                    `(,setter)
                                    (if (##symbol? fsetter)
                                      `(#f)
                                      `()))
                                ,@(if (##symbol? fsetter)
                                    `(,fsetter)
                                    `()))
                              `())
                          ,@(if (##fx= (##fxand options 1) 0)
                              `()
                              `(unprintable:))
                          ,@(if (##fx= (##fxand options 2) 0)
                              `()
                              `(read-only:))
                          ,@(if (##fx= (##fxand options 4) 0)
                              `()
                              `(equality-skip:))
                          ,@(if (##fx= (##fxand options 16) 0)
                              `(functional-setter:)
                              `())
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

;; u8vector and f64vector are always enabled

(macro-define-syntax macro-if-s8vector
  (lambda (stx)
    (syntax-case stx ()
      ((_ yes)
       #'(macro-if-s8vector yes (##begin)))
      ((_ yes no)
       #'(cond-expand
          ((or enable-s8vector (not disable-s8vector))
           yes)
          (else
           no))))))

(macro-define-syntax macro-if-u16vector
  (lambda (stx)
    (syntax-case stx ()
      ((_ yes)
       #'(macro-if-u16vector yes (##begin)))
      ((_ yes no)
       #'(cond-expand
          ((or enable-u16vector (not disable-u16vector))
           yes)
          (else
           no))))))

(macro-define-syntax macro-if-s16vector
  (lambda (stx)
    (syntax-case stx ()
      ((_ yes)
       #'(macro-if-s16vector yes (##begin)))
      ((_ yes no)
       #'(cond-expand
          ((or enable-s16vector (not disable-s16vector))
           yes)
          (else
           no))))))

(macro-define-syntax macro-if-u32vector
  (lambda (stx)
    (syntax-case stx ()
      ((_ yes)
       #'(macro-if-u32vector yes (##begin)))
      ((_ yes no)
       #'(cond-expand
          ((or enable-u32vector (not disable-u32vector))
           yes)
          (else
           no))))))

(macro-define-syntax macro-if-s32vector
  (lambda (stx)
    (syntax-case stx ()
      ((_ yes)
       #'(macro-if-s32vector yes (##begin)))
      ((_ yes no)
       #'(cond-expand
          ((or enable-s32vector (not disable-s32vector))
           yes)
          (else
           no))))))

(macro-define-syntax macro-if-u64vector
  (lambda (stx)
    (syntax-case stx ()
      ((_ yes)
       #'(macro-if-u64vector yes (##begin)))
      ((_ yes no)
       #'(cond-expand
          ((or enable-u64vector (not disable-u64vector))
           yes)
          (else
           no))))))

(macro-define-syntax macro-if-s64vector
  (lambda (stx)
    (syntax-case stx ()
      ((_ yes)
       #'(macro-if-s64vector yes (##begin)))
      ((_ yes no)
       #'(cond-expand
          ((or enable-s64vector (not disable-s64vector))
           yes)
          (else
           no))))))

(macro-define-syntax macro-if-f32vector
  (lambda (stx)
    (syntax-case stx ()
      ((_ yes)
       #'(macro-if-f32vector yes (##begin)))
      ((_ yes no)
       #'(cond-expand
          ((or enable-f32vector (not disable-f32vector))
           yes)
          (else
           no))))))

;;;----------------------------------------------------------------------------

(##include "_kernel#.scm")
(##include "_fifo#.scm")
(##include "_thread#.scm")
(##include "_system#.scm")
(##include "_num#.scm")
(##include "_io#.scm")
(##include "_eval#.scm")
(##include "_module#.scm")
(##include "_repl#.scm")
(##include "_std#.scm")
(##include "_nonstd#.scm")

;;;============================================================================
