;;;============================================================================

;;; File: "_gambit#.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

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

(##define-macro (macro-absent-obj)   `',(##type-cast -6 (##type #f)));;TODO: remplace with (##absent-object) after next release
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
      ((_ var arg-num form expr)
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

(##define-macro (define-check-type type-id type predicate . arguments)

  (define (sym . lst)
    (string->symbol (apply string-append (map symbol->string lst))))

  (let ()

    (define macro-check-type (sym 'macro-check- type-id))
    (define macro-test-type (sym 'macro-test- type-id))
    (define ##fail-check-type (sym '##fail-check- type-id))

    `(begin
       (##define-macro (,(sym 'implement-check-type- type-id));;;;;;;;;;
         '(define-fail-check-type ,type-id ,type))

     (##define-macro (,macro-test-type var)
       `(,',predicate ,var ,@',arguments))

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
