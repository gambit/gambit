;;;============================================================================

;;; File: "_ptree1.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include     "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

'(begin;**************brad
(##include "_sourceadt.scm")
(##include "_envadt.scm")
(##include "_utilsadt.scm")
(##include "_hostadt.scm")
)

;;;----------------------------------------------------------------------------
;;
;; Parse tree manipulation module: (part 1)
;; ------------------------------

;; This module contains procedures to construct the parse tree of a Scheme
;; expression and manipulate the parse tree.

(define next-node-stamp #f)

(define (node-children-set! x y)
  (vector-set! x 2 y)
  (for-each (lambda (child) (node-parent-set! child x)) y)
  (node-fv-invalidate! x))

(define (node-fv-invalidate! x)
  (let loop ((node x))
    (if node
      (begin
        (node-fv-set! node #t)
        (node-bfv-set! node #t)
        (loop (node-parent node))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Procedures to create parse tree nodes and extract sub-nodes.

(define (new-cst source env val)
  (make-cst #f '() #t #t env source val))

(define (new-ref source env var)
  (let ((node (make-ref #f '() #t #t env source var)))
    (var-refs-set! var (ptset-adjoin (var-refs var) node))
    node))

(define (new-ref-extended-bindings source name env)
  (new-ref source (add-extended-bindings env)
    (env-lookup-global-var env name)))

(define (new-set source env var val)
  (let ((node (make-set #f (list val) #t #t env source var)))
    (var-sets-set! var (ptset-adjoin (var-sets var) node))
    (node-parent-set! val node)
    node))

(define (set-val x)
  (if (set? x)
    (car (node-children x))
    (compiler-internal-error "set-val, 'set' node expected" x)))

(define (new-def source env var val)
  (let ((node (make-def #f (list val) #t #t env source var)))
    (var-sets-set! var (ptset-adjoin (var-sets var) node))
    (node-parent-set! val node)
    node))

(define (def-val x)
  (if (def? x)
    (car (node-children x))
    (compiler-internal-error "def-val, 'def' node expected" x)))

(define (new-tst source env pre con alt)
  (let ((node (make-tst #f (list pre con alt) #t #t env source)))
    (node-parent-set! pre node)
    (node-parent-set! con node)
    (node-parent-set! alt node)
    node))

(define (tst-pre x)
  (if (tst? x)
    (car (node-children x))
    (compiler-internal-error "tst-pre, 'tst' node expected" x)))

(define (tst-con x)
  (if (tst? x)
    (cadr (node-children x))
    (compiler-internal-error "tst-con, 'tst' node expected" x)))

(define (tst-alt x)
  (if (tst? x)
    (caddr (node-children x))
    (compiler-internal-error "tst-alt, 'tst' node expected" x)))

(define (new-conj source env pre alt)
  (let ((node (make-conj #f (list pre alt) #t #t env source)))
    (node-parent-set! pre node)
    (node-parent-set! alt node)
    node))

(define (conj-pre x)
  (if (conj? x)
    (car (node-children x))
    (compiler-internal-error "conj-pre, 'conj' node expected" x)))

(define (conj-alt x)
  (if (conj? x)
    (cadr (node-children x))
    (compiler-internal-error "conj-alt, 'conj' node expected" x)))

(define (new-disj source env pre alt)
  (let ((node (make-disj #f (list pre alt) #t #t env source)))
    (node-parent-set! pre node)
    (node-parent-set! alt node)
    node))

(define (disj-pre x)
  (if (disj? x)
    (car (node-children x))
    (compiler-internal-error "disj-pre, 'disj' node expected" x)))

(define (disj-alt x)
  (if (disj? x)
    (cadr (node-children x))
    (compiler-internal-error "disj-alt, 'disj' node expected" x)))

(define (new-prc source env name c-name parms opts keys rest? body)
  (let* ((children
          (list body))
         (node
          (make-prc #f children #t #t env source
                    name c-name parms opts keys rest? #f)))
    (for-each (lambda (x) (var-bound-set! x node)) parms)
    (node-parent-set! body node)
    node))

(define (prc-body x)
  (if (prc? x)
    (car (node-children x))
    (compiler-internal-error "prc-body, 'proc' node expected" x)))

(define (prc-req-and-opt-parms-only? x)
  (and (not (prc-keys x))
       (not (prc-rest? x))))

(define (prc-proc-obj-get x)
  (or (prc-proc-obj x)
      (let ((proc-obj
             (make-proc-obj ;; create proc-obj that will be modified later
              "*anonymous*" ;; name
              #f            ;; c-name
              #f            ;; primitive?
              #f            ;; code
              0             ;; call-pat
              #t            ;; side-effects?
              '()           ;; strict-pat
              0             ;; lift-pat
              '(#f)         ;; type
              #f)))         ;; standard
        (prc-proc-obj-set! x proc-obj)
        proc-obj)))

(define (new-call source env oper args)
  (let ((node (make-app #f (cons oper args) #t #t env source)))
    (node-parent-set! oper node)
    (for-each (lambda (x) (node-parent-set! x node)) args)
    node))

(define (new-call* source env oper args)
  (new-call source env oper args))

(define (app-oper x)
  (if (app? x)
    (car (node-children x))
    (compiler-internal-error "app-oper, 'call' node expected" x)))

(define (app-args x)
  (if (app? x)
    (cdr (node-children x))
    (compiler-internal-error "app-args, 'call' node expected" x)))

(define (oper-pos? node)
  (let ((parent (node-parent node)))
    (if parent
      (and (app? parent)
           (eq? (app-oper parent) node))
      #f)))

(define (new-fut source env val)
  (let ((node (make-fut #f (list val) #t #t env source)))
    (node-parent-set! val node)
    node))

(define (fut-val x)
  (if (fut? x)
    (car (node-children x))
    (compiler-internal-error "fut-val, 'fut' node expected" x)))

(define (new-disj-call source env pre oper alt)
  (new-call* source env
    (let* ((temp (new-temp-variable source 'cond-temp))
           (parms (list temp))
           (inner-env (env-frame env parms)))
      (new-prc source env #f #f parms '() #f #f
        (new-tst source inner-env
          (new-ref source inner-env temp)
          (new-call* source inner-env
            oper
            (list (new-ref source inner-env temp)))
          alt)))
    (list pre)))

(define (new-seq source env before after)
  (let ((temp (new-temp-variable source 'begin-temp)))
    (new-call* source env
      (new-prc source env #f #f (list temp) '() #f #f
        after)
      (list before))))

(define (new-let ptree proc vars vals body)
  (if (pair? vars)
    (new-call (node-source ptree) (node-env ptree)
      (new-prc (node-source proc) (node-env proc)
        (prc-name proc)
        (prc-c-name proc)
        (reverse vars)
        '()
        #f
        #f
        body)
      (reverse vals))
    body))

(define temp-variable-stamp #f)

(define (new-temp-variable source name)
  (make-var (string->symbol
             (string-append (symbol->string name)
                            "."
                            (number->string (temp-variable-stamp))))
            #t
            (ptset-empty)
            (ptset-empty)
            source
            #t))

(define (new-variables sources)
  (map new-variable sources))

(define (new-variable source)
  (make-var (source-code source)
            #t
            (ptset-empty)
            (ptset-empty)
            source
            #f))

(define (set-prc-names! vars vals)
  (let loop ((vars vars) (vals vals))
    (if (not (null? vars))
      (let ((var (car vars))
            (val (car vals)))
        (if (prc? val)
          (prc-name-set! val (symbol->string (var-name var))))
        (loop (cdr vars) (cdr vals))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Procedures to get variable classes from nodes.

(define (free-variables node) ; set of free variables used in the expression
  (if (eq? (node-fv node) #t)
    (let ((x (varset-union-multi (map free-variables (node-children node)))))
      (node-fv-set! node
        (cond ((cst? node)
               (let ((val (cst-val node)))
                 (if (proc-obj? val)
                     (varset-adjoin
                      x
                      (env-lookup-global-var
                       (node-env node)
                       (string->symbol (proc-obj-name val))))
                     x)))
              ((ref? node)
               (varset-adjoin x (ref-var node)))
              ((set? node)
               (varset-adjoin x (set-var node)))
              ((prc? node)
               (varset-difference x (bound-variables node)))
              ((and (app? node) (prc? (app-oper node)))
               (varset-difference x (bound-variables (app-oper node))))
              (else
               x)))))
  (node-fv node))

(define (bound-free-variables node) ; set of bound free variables used in expr
  (if (eq? (node-bfv node) #t)
    (node-bfv-set! node
     (list->varset (keep bound? (varset->list (free-variables node))))))
  (node-bfv node))

(define (bound-variables node) ; set of variables bound by a procedure
  (list->varset (prc-parms node)))

(define (mutable? var) ; var must be a bound variable (i.e. non-global)
  (not (ptset-empty? (var-sets var))))

(define (bound? var)
  (var-bound var))

(define (global? var)
  (not (bound? var)))

(define (global-single-def var)
  ;; get definition of a global if it is only defined once and it will
  ;; never change
  (let ((sets (ptset->list (var-sets var))))
    (and (pair? sets)
         (null? (cdr sets))
         (def? (car sets))
         (block-compilation? (node-env (car sets)))
         (def-val (car sets)))))

(define (global-proc-obj node)
  (global-standard-proc-obj node))

(define (global-standard-proc-obj node)
  (let* ((var (ref-var node))
         (name (var-name var)))
    (standard-proc-obj (target.prim-info name)
                       name
                       (node-env node))))

(define (global-singly-bound? node)
  (or (global-single-def (ref-var node))
      (global-standard-proc-obj node)))

(define (app->specialized-proc node)
  (let ((oper (app-oper node))
        (args (app-args node))
        (env (node-env node)))
    (specialize-app oper args env)))

(define (specialize-app oper args env)
  (specialize-proc
   (cond ((cst? oper)
          (let ((val (cst-val oper)))
            (and (proc-obj? val)
                 val)))
         ((ref? oper)
          (and (global? (ref-var oper))
               (global-proc-obj oper)))
         (else
          #f))
   args
   env))

(define (specialize-proc proc args env)
  (and proc
       (nb-args-conforms? (length args) (proc-obj-call-pat proc))
       (let loop ((proc proc))
         (let ((spec
                ((proc-obj-specialize proc)
                 env
                 (map (lambda (arg) (if (cst? arg) (cst-val arg) void-object))
                      args))))
           (if (eq? spec proc)
             proc
             (loop spec))))))

(define (nb-args-conforms? n call-pat)
  (pattern-member? n call-pat))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Declarations.

;; Dialect related declarations:
;;
;; (ieee-scheme)     use IEEE Scheme
;; (r4rs-scheme)     use R4RS Scheme
;; (r5rs-scheme)     use R5RS Scheme
;; (gambit-scheme)   use Gambit Scheme
;; (multilisp)       use Multilisp
;;
;; Partial-evaluation declarations:
;;
;; (constant-fold)                       can constant-fold primitives
;; (not constant-fold)                   can't constant-fold primitives
;;
;; Lambda-lifting declarations:
;;
;; (lambda-lift)                         can lambda-lift user procedures
;; (not lambda-lift)                     can't lambda-lift user procedures
;;
;; Inlining declarations:
;;
;; (inline)                              compiler may inline user procedures
;; (not inline)                          no user procedure will be inlined
;;
;; (inline-primitives)                   can inline all primitives
;; (inline-primitives <var1> ...)        can inline primitives <var1> ...
;; (not inline-primitives)               can't inline any primitives
;; (not inline-primitives <var1> ...)    can't inline primitives <var1> ...
;;
;; (inlining-limit n)                    inlined user procedures must not be
;;                                       bigger than 'n'
;;
;; Compilation strategy declarations:
;;
;; (block)     global vars defined are only mutated by code in the current file
;; (separate)  global vars defined can be mutated by other code
;;
;; (core)      toplevel expressions and definitions must be compiled to code
;; (not core)  toplevel expressions and definitions belong to another module
;;
;; Global variable binding declarations:
;;
;; (standard-bindings)                  compiler can assume standard bindings
;; (standard-bindings <var1> ...)       assume st. bind. for vars specified
;; (not standard-bindings)              can't assume st. bind. for any var
;; (not standard-bindings <var1> ...)   can't assume st. bind. for vars spec.
;;
;; (extended-bindings)                  compiler can assume extended bindings
;; (extended-bindings <var1> ...)       assume ext. bind. for vars specified
;; (not extended-bindings)              can't assume ext. bind. for any var
;; (not extended-bindings <var1> ...)   can't assume ext. bind. for vars spec.
;;
;; (run-time-bindings)                  should check bindings at run-time
;; (run-time-bindings <var1> ...)       check at run-time for vars specified
;; (not run-time-bindings)              should not check bindings at run-time
;; (not run-time-bindings <var1> ...)   don't check at run-time for vars specified
;;
;; Code safety declarations:
;;
;; (safe)                              runtime errors won't crash system
;; (not safe)                          assume program doesn't contain errors
;;
;; (warnings)                          show warnings
;; (not warnings)                      suppress warnings
;;
;; Interrupt checking declarations:
;;
;; (interrupts-enabled)                allow interrupts
;; (not interrupts-enabled)            disallow interrupts
;;
;; Environment map declarations:
;;
;; (environment-map)                   generate environment maps
;; (not environment-map)               don't generate environment maps
;;
;; Proper tail calls declarations:
;;
;; (proper-tail-calls)                 generate proper tail calls
;; (not proper-tail-calls)             don't generate proper tail calls
;;
;; Proper procedure identity declarations:
;;
;; (generative-lambda)                 generate closures even when no free vars
;; (not generative-lambda)             don't generate closures when no free vars
;;
;; Optimizing dead local variables declarations:
;;
;; (optimize-dead-local-variables)     optimize dead local variables
;; (not optimize-dead-local-variables) don't optimize dead local variables
;;
;; Optimizing dead definitions declarations:
;;
;; (optimize-dead-definitions)                compiler can remove dead defs.
;; (optimize-dead-definitions <var1> ...)     only for these var defs.
;; (not optimize-dead-definitions)            can't remove dead defs.
;; (not optimize-dead-definitions <var1> ...) only for these var defs.

(define-flag-decl ieee-scheme-sym   'dialect)
(define-flag-decl r4rs-scheme-sym   'dialect)
(define-flag-decl r5rs-scheme-sym   'dialect)
(define-flag-decl gambit-scheme-sym 'dialect)
(define-flag-decl multilisp-sym     'dialect)

(define-boolean-decl constant-fold-sym)

(define-boolean-decl lambda-lift-sym)

(define-boolean-decl inline-sym)
(define-namable-boolean-decl inline-primitives-sym)
(define-parameterized-decl inlining-limit-sym #f)

(define-flag-decl block-sym    'compilation-strategy)
(define-flag-decl separate-sym 'compilation-strategy)

(define-boolean-decl core-sym)

(define-namable-boolean-decl standard-bindings-sym)
(define-namable-boolean-decl extended-bindings-sym)
(define-namable-boolean-decl run-time-bindings-sym)

(define-boolean-decl safe-sym)

(define-boolean-decl warnings-sym)

(define-boolean-decl interrupts-enabled-sym)
(define-boolean-decl poll-on-return-sym)

(define-boolean-decl debug-sym)
(define-boolean-decl debug-location-sym)
(define-boolean-decl debug-source-sym)
(define-boolean-decl debug-environments-sym)

(define-boolean-decl environment-map-sym) ;; deprecated: use debug-environments

(define-boolean-decl proper-tail-calls-sym)

(define-boolean-decl generative-lambda-sym)

(define-boolean-decl optimize-dead-local-variables-sym)

(define-namable-boolean-decl optimize-dead-definitions-sym)

(define (scheme-dialect env) ; returns dialect in effect
  (declaration-value 'dialect #f gambit-scheme-sym env))

(define (constant-fold? env) ; true iff should constant-fold primitives
  (declaration-value constant-fold-sym #f #t env))

(define (lambda-lift? env) ; true iff should lambda-lift
  (declaration-value lambda-lift-sym #f #t env))

(define (inline? env) ; true iff should inline
  (declaration-value inline-sym #f #t env))

(define (inline-primitive? name env) ; true iff name can be inlined
  (declaration-value inline-primitives-sym name #t env))

(define (add-not-inline-primitives env)
  (env-declare env (list inline-primitives-sym #f)))

(define (inlining-limit env) ; returns the inlining limit
  (max 0 (min 1000000 (declaration-value inlining-limit-sym #f 370 env))))

(define (block-compilation? env) ; true iff block compilation strategy
  (eq? (declaration-value 'compilation-strategy #f separate-sym env)
       block-sym))

(define (core? env) ; true iff core code
  (declaration-value core-sym #f #t env))

(define (standard-binding? name env) ; true iff name's binding is standard
  (declaration-value standard-bindings-sym name #f env))

(define (extended-binding? name env) ; true iff name's binding is extended
  (declaration-value extended-bindings-sym name #f env))

(define (add-extended-bindings env)
  (env-declare env (list extended-bindings-sym #t)))

(define (run-time-binding? name env) ; true iff name's binding is checked at run-time
  (declaration-value run-time-bindings-sym name #t env))

(define (remove-std-ext-rt-bindings env)
  (env-declare (env-declare (env-declare env
                                         (list standard-bindings-sym #f))
                            (list extended-bindings-sym #f))
               (list run-time-bindings-sym #f)))

(define (safe? env) ; true iff system should prevent fatal runtime errors
  (declaration-value safe-sym #f #t env))

(define (add-safe env)
  (env-declare env (list safe-sym #t)))

(define (add-not-safe env)
  (env-declare env (list safe-sym #f)))

(define (warnings? env) ; true iff warnings are not suppressed
  (declaration-value warnings-sym #f #t env))

(define (intrs-enabled? env) ; true iff interrupt checks should be generated
  (declaration-value interrupts-enabled-sym #f #t env))

(define (add-not-interrupts-enabled env)
  (env-declare env (list interrupts-enabled-sym #f)))

(define (poll-on-return? env) ; true when interrupt checks should be generated on procedure returns
  (declaration-value poll-on-return-sym #f #f env))

(define (debug? env) ; true iff debugging information should be generated
  (declaration-value debug-sym #f compiler-option-debug env))

(define (debug-location? env) ; true iff source code location debugging information should be generated
  (declaration-value debug-location-sym #f compiler-option-debug-location env))

(define (debug-source? env) ; true iff source code debugging information should be generated
  (declaration-value debug-source-sym #f compiler-option-debug-source env))

(define (debug-environments? env) ; true iff environment debugging information should be generated
  (declaration-value debug-environments-sym #f compiler-option-debug-environments env))

(define (environment-map? env) ; true iff environment map should be generated
  (declaration-value environment-map-sym #f #f env))

(define (proper-tail-calls? env) ; true iff proper tail calls should be generated
  (declaration-value proper-tail-calls-sym #f #t env))

(define (add-proper-tail-calls env)
  (env-declare env (list proper-tail-calls-sym #t)))

(define (generative-lambda? env) ; true iff closures should be created even when there are no free variables
  (declaration-value generative-lambda-sym #f #f env))

(define (optimize-dead-local-variables? env) ; true iff dead local variables should be optimized
  (declaration-value optimize-dead-local-variables-sym #f #t env))

(define (optimize-dead-definitions? name env) ; true iff dead definition of name should be optimized
  (declaration-value optimize-dead-definitions-sym name #f env))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Dialect info.

(define (standard-proc-obj proc name env)
  (and proc
       (standard-procedure?
        proc
        (standard-binding? name env)
        (extended-binding? name env)
        (scheme-dialect env))
       proc))

(define (standard-procedure? proc std? ext? dialect)
  (let ((standard (proc-obj-standard proc)))
    (if (eq? standard 'extended)
      ext?
      (and std?
           (or (eq? standard 'ieee)
               (and (not (eq? dialect ieee-scheme-sym))
                    (or (eq? standard 'r4rs)
                        (and (not (eq? dialect r4rs-scheme-sym))
                             (or (eq? standard 'r5rs)
                                 (not (eq? dialect r5rs-scheme-sym)))))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; (parse-program program env module-ref proc) returns a (non-empty)
;; list of parse trees, one for each top-level expression in the program.
;; An artificial reference of the constant #f is added to the program
;; if it is otherwise empty.

(define (parse-program program env module-ref proc)

  (define (parse-exprs exprs env lst cont)
    (if (null? exprs)
      (cont env lst)
      (let ((source (car exprs)))

        (cond ((macro-expr? source env)
               (parse-exprs
                 (cons (macro-expand source env) (cdr exprs))
                 env
                 lst
                 cont))

              ((**begin-cmd-or-expr? source env)
               (parse-exprs
                 (append (begin-body source) (cdr exprs))
                 env
                 lst
                 cont))

              ((**define-expr? source env)
               (let* ((var-source (definition-name source env))
                      (var (source-code var-source))
                      (v (env-lookup-var env var var-source)))

                 (if *ptree-port*
                   (begin
                     (display "  " *ptree-port*)
                     (write (var-name v) *ptree-port*)
                     (newline *ptree-port*)))

                 (let ((node (pt (definition-value source) env 'true)))
                   (set-prc-names! (list v) (list node))
                   (parse-exprs
                     (cdr exprs)
                     env
                     (cons (new-def source env v node)
                           lst)
                     cont))))

              ((or (**define-macro-expr? source env)
                   (**define-syntax-expr? source env))

               (if *ptree-port*
                 (begin
                   (display "  \"macro\"" *ptree-port*)
                   (newline *ptree-port*)))

               (parse-exprs
                 (cdr exprs)
                 (add-macro source env)
                 lst
                 cont))

              ((**include-expr? source env)

               (if *ptree-port*
                 (display "  " *ptree-port*))

               (let ((x (include-expr->source source *ptree-port*)))

                 (if *ptree-port*
                   (newline *ptree-port*))

                 (parse-exprs
                   (cons x (cdr exprs))
                   env
                   lst
                   cont)))

              ((**declare-expr? source env)

               (if *ptree-port*
                 (begin
                   (display "  \"declare\"" *ptree-port*)
                   (newline *ptree-port*)))

               (parse-exprs
                 (cdr exprs)
                 (add-declarations source env)
                 lst
                 cont))

              ((**namespace-expr? source env)

               (if *ptree-port*
                 (begin
                   (display "  \"namespace\"" *ptree-port*)
                   (newline *ptree-port*)))

               (parse-exprs
                 (cdr exprs)
                 (add-namespace source env)
                 lst
                 cont))

              ((**declare-scope-expr? source env)
               (let ((save (env-decl-ref env)))
                 (parse-exprs
                   (declare-scope-body source)
                   env
                   lst
                   (lambda (env lst)
                     (parse-exprs
                       (cdr exprs)
                       (env-decl-set env save)
                       lst
                       cont)))))

              ((**namespace-scope-expr? source env)
               (let ((save (env-namespace-ref env)))
                 (parse-exprs
                   (namespace-scope-body source)
                   env
                   lst
                   (lambda (env lst)
                     (parse-exprs
                       (cdr exprs)
                       (env-namespace-set env save)
                       lst
                       cont)))))

              ((**macro-scope-expr? source env)
               (let ((save (env-macros-ref env)))
                 (parse-exprs
                   (macro-scope-body source)
                   env
                   lst
                   (lambda (env lst)
                     (parse-exprs
                       (cdr exprs)
                       (env-macros-set env save)
                       lst
                       cont)))))

              ((**c-define-type-expr? source env)
               (let ((name (source-code (c-type-definition-name source)))
                     (type (c-type-definition-type source)))

                 (if *ptree-port*
                   (begin
                     (display "  \"c-define-type\"" *ptree-port*)
                     (newline *ptree-port*)))

                 (add-c-type name type)

                 (parse-exprs
                   (cdr exprs)
                   env
                   lst
                   cont)))

              ((**c-declare-expr? source env)
               (let ((body (source-code (c-declaration-body source))))

                 (if *ptree-port*
                   (begin
                     (display "  \"c-declare\"" *ptree-port*)
                     (newline *ptree-port*)))

                 (add-c-decl body)

                 (parse-exprs
                   (cdr exprs)
                   env
                   lst
                   cont)))

              ((**c-initialize-expr? source env)
               (let ((body (source-code (c-initialization-body source))))

                 (if *ptree-port*
                   (begin
                     (display "  \"c-initialize\"" *ptree-port*)
                     (newline *ptree-port*)))

                 (add-c-init body)

                 (parse-exprs
                   (cdr exprs)
                   env
                   lst
                   cont)))

              ((**c-define-expr? source env)
               (let* ((var-source (c-definition-name source))
                      (var (source-code var-source))
                      (v (env-lookup-var env var var-source))
                      (param-types (c-definition-param-types source))
                      (result-type (c-definition-result-type source))
                      (proc-name-source (c-definition-proc-name source))
                      (proc-name (source-code proc-name-source))
                      (scope-source (c-definition-scope source))
                      (scope (source-code scope-source)))

                 (if *ptree-port*
                   (begin
                     (display "  " *ptree-port*)
                     (write (var-name v) *ptree-port*)
                     (newline *ptree-port*)))

                 (build-c-define param-types result-type proc-name scope)

                 (let ((node (pt (c-definition-value source) env 'true)))
                   (set-prc-names! (list v) (list node))
                   (prc-c-name-set! node proc-name)
                   (parse-exprs
                     (cdr exprs)
                     env
                     (cons (new-def source env v node)
                           lst)
                     cont))))

              (else

               (if *ptree-port*
                 (begin
                   (display "  \"expr\"" *ptree-port*)
                   (newline *ptree-port*)))

               (parse-exprs
                 (cdr exprs)
                 env
                 (cons (pt source env 'true) lst)
                 cont))))))

  (if *ptree-port*
    (begin
      (display "Parsing:" *ptree-port*)
      (newline *ptree-port*)))

  (c-interface-begin module-ref)

  (parse-exprs
    (list program)
    env
    '()
    (lambda (env lst)

      (if *ptree-port*
        (newline *ptree-port*))

      (check-global-defs env)

      (proc (if (null? lst)
              (list (new-cst (expression->source false-object #f) env
                      false-object))
              (reverse lst))
            env
            (c-interface-end)))))

(define (check-global-defs env)
  (let ((global-vars (env-global-variables env)))
    (for-each
     (lambda (var)
       (let* ((defs (keep def? (ptset->list (var-sets var))))
              (nb-defs (length defs)))
         (for-each
          (lambda (def)
            (let ((env (node-env def)))
              (if (warnings? env)
                  (let ((name (var-name var)))
                    (if (standard-proc-obj (target.prim-info name) name env)
                        (compiler-user-warning
                         (source-locat (node-source def))
                         "Definition of standardly bound global variable"
                         name))
                    (if (> nb-defs 1)
                        (compiler-user-warning
                         (source-locat (node-source def))
                         "More than one 'define' of global variable"
                         name))))))
          defs)))
     (reverse global-vars))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; (pt source env use) returns the parse tree for the Scheme source expression
;; 'source' in the environment 'env'.  If 'source' is not syntactically
;; correct, an error is signaled.  The value of 'use' determines what the
;; expression's value will be used for; it must be one of the following:
;;
;;  true  : the true value of the expression is needed
;;  pred  : the value is used as a predicate
;;  none  : the value is not needed (but its side effect might)

(define (pt-syntax-error source msg . args)
  (apply compiler-user-error
         (cons (source-locat source)
               (cons msg
                     args))))

(define (pt source env use)
  (cond ((macro-expr? source env)        (pt (macro-expand source env) env use))
        ((self-eval-expr? source env)    (pt-self-eval source env use))
        ((**quote-expr? source env)      (pt-quote source env use))
        ((**quasiquote-expr? source env) (pt-quasiquote source env use))
        ((var-expr? source env)          (pt-var source env use))
        ((**set!-expr? source env)       (pt-set! source env use))
        ((**lambda-expr? source env)     (pt-lambda source env use))
        ((**if-expr? source env)         (pt-if source env use))
        ((**cond-expr? source env)       (pt-cond source env use))
        ((**and-expr? source env)        (pt-and source env use))
        ((**or-expr? source env)         (pt-or source env use))
        ((**case-expr? source env)       (pt-case source env use))
        ((**let-expr? source env)        (pt-let source env use))
        ((**let*-expr? source env)       (pt-let* source env use))
        ((**letrec-expr? source env)     (pt-letrec source env use #f))
        ((**letrec*-expr? source env)    (pt-letrec source env use #t))
        ((**begin-expr? source env)      (pt-begin source env use))
        ((**do-expr? source env)         (pt-do source env use))
        ((**guard-expr? source env)      (pt-guard source env use #f))
        ((**r7rs-guard-expr? source env) (pt-guard source env use #t))
        ((**delay-expr? source env)      (pt-delay source env use))
        ((**future-expr? source env)     (pt-future source env use))
        ((**define-expr? source env)
         (pt-syntax-error source "Ill-placed 'define'"))
        ((**define-macro-expr? source env)
         (pt-syntax-error source "Ill-placed 'define-macro'"))
        ((**define-syntax-expr? source env)
         (pt-syntax-error source "Ill-placed 'define-syntax'"))
        ((**include-expr? source env)
         (pt-syntax-error source "Ill-placed 'include'"))
        ((**declare-expr? source env)
         (pt-syntax-error source "Ill-placed 'declare'"))
        ((**namespace-expr? source env)
         (pt-syntax-error source "Ill-placed 'namespace'"))
        ((**declare-scope-expr? source env)
         (pt-syntax-error source "Ill-placed 'declare-scope'"))
        ((**namespace-scope-expr? source env)
         (pt-syntax-error source "Ill-placed 'namespace-scope'"))
        ((**macro-scope-expr? source env)
         (pt-syntax-error source "Ill-placed 'macro-scope'"))
        ((**c-define-type-expr? source env)
         (pt-syntax-error source "Ill-placed 'c-define-type'"))
        ((**c-declare-expr? source env)
         (pt-syntax-error source "Ill-placed 'c-declare'"))
        ((**c-initialize-expr? source env)
         (pt-syntax-error source "Ill-placed 'c-initialize'"))
        ((**c-lambda-expr? source env)     (pt-c-lambda source env use))
        ((**c-define-expr? source env)
         (pt-syntax-error source "Ill-placed 'c-define'"))
        ((combination-expr? source env)    (pt-combination source env use))
        (else
         (pt-syntax-error source "Ill-formed expression"))))

(define (macro-expand source env)
  (let ((code (source-code source)))
    (let* ((descr (env-lookup-macro env (source-code (car code))))
           (expander (**macro-descr-expander descr)))
      (sourcify-deep
       (if (**macro-descr-def-syntax? descr)
           (expander source)
           (apply expander (cdr (source->expression source))))
       source))))

(define (pt-self-eval source env use)
  (let ((val (source->expression source)))
    (if (eq? use 'none)
      (new-cst source env void-object)
      (new-cst source env val))))

(define (pt-quote source env use)
  (let ((code (source-code source)))
    (if (eq? use 'none)
      (new-cst source env void-object)
      (new-cst source env (source->expression (cadr code))))))

(define (pt-quasiquote source env use)
  (let ((code (source-code source)))
    (pt-quasiquotation (cadr code) 1 env)))

(define (pt-quasiquotation form level env)
  (cond ((= level 0)
         (pt form env 'true))
        ((quasiquote-expr? form)
         (pt-quasiquotation-list form (source-code form) (+ level 1) env))
        ((unquote-expr? form)
         (if (= level 1)
           (pt (cadr (source-code form)) env 'true)
           (pt-quasiquotation-list form (source-code form) (- level 1) env)))
        ((unquote-splicing-expr? form)
         (if (= level 1)
           (pt-syntax-error form "Ill-placed 'unquote-splicing'")
           (pt-quasiquotation-list form (source-code form) (- level 1) env)))
        ((pair? (source-code form))
         (pt-quasiquotation-list form (source-code form) level env))
        ((vector-object? (source-code form))
         (let ((lst (vect->list (source-code form))))
           (vector-form
             form
             (pt-quasiquotation-list form lst level env)
             env)))
        (else
         (new-cst form env (source->expression form)))))

(define (pt-quasiquotation-list form l level env)
  (cond ((pair? l)
         (if (and (unquote-splicing-expr? (car l)) (= level 1))
           (let ((x (pt (cadr (source-code (car l))) env 'true)))
             (if (null? (cdr l))
               x
               (append-form (car l)
                            x
                            (pt-quasiquotation-list form (cdr l) 1 env)
                            env)))
           (cons-form form
                      (pt-quasiquotation (car l) level env)
                      (pt-quasiquotation-list form (cdr l) level env)
                      env)))
        ((null? l)
         (new-cst form env '()))
        (else
         (pt-quasiquotation l level env))))

(define (append-form source ptree1 ptree2 env)

  (define (call oper-sym args)
    (new-call* source (add-not-safe env)
      (new-ref-extended-bindings source oper-sym env)
      args))

  (cond ((and (cst? ptree1) (cst? ptree2))
         (new-cst source env
           (append (cst-val ptree1) (cst-val ptree2))))
        ((and (cst? ptree2) (null? (cst-val ptree2)))
         ptree1)
        (else
         (call **quasi-append-sym (list ptree1 ptree2)))))

(define (cons-form source ptree1 ptree2 env)

  (define (call oper-sym args)
    (new-call* source (add-not-safe env)
      (new-ref-extended-bindings source oper-sym env)
      args))

  (cond ((and (cst? ptree1) (cst? ptree2))
         (new-cst source env
           (cons (cst-val ptree1) (cst-val ptree2))))
        ((and (cst? ptree2) (null? (cst-val ptree2)))
         (call **quasi-list-sym (list ptree1)))
        ((and (app? ptree2)
              (app->specialized-proc ptree2))
         =>
         (lambda (proc)
           (if (eq? proc **quasi-list-proc-obj)
               (call **quasi-list-sym (cons ptree1 (app-args ptree2)))
               (call **quasi-cons-sym (list ptree1 ptree2)))))
        (else
         (call **quasi-cons-sym (list ptree1 ptree2)))))

(define (vector-form source ptree env)

  (define (call oper-sym args)
    (new-call* source (add-not-safe env)
      (new-ref-extended-bindings source oper-sym env)
      args))

  (cond ((cst? ptree)
         (new-cst source env
           (list->vect (cst-val ptree))))
        ((list-construction? source ptree env)
         =>
         (lambda (elems)
           (call **quasi-vector-sym elems)))
        (else
         (call **quasi-list->vector-sym (list ptree)))))

(define (list-construction? source ptree env)
  (cond ((cst? ptree)
         (let ((val (cst-val ptree)))
           (if (proper-length val)
               (map (lambda (elem-val)
                      (new-cst source env
                        elem-val))
                    val)
               #f)))
        ((and (app? ptree)
              (app->specialized-proc ptree))
         =>
         (lambda (proc)
           (cond ((eq? proc **quasi-cons-proc-obj)
                  (let ((args (app-args ptree)))
                    (and (eqv? 2 (proper-length args))
                         (let* ((arg1 (car args))
                                (arg2 (cadr args))
                                (x (list-construction? source arg2 env)))
                           (and x
                                (cons arg1 x))))))
                 ((eq? proc **quasi-list-proc-obj)
                  (app-args ptree))
                 (else
                  #f))))
        (else
         #f)))

(define (pt-var source env use)
  (if (eq? use 'none)
    (new-cst source env void-object)
    (new-ref source env
      (env-lookup-var env (source-code source) source))))

(define (pt-set! source env use)
  (let* ((code (source-code source))
         (var (cadr code)))
    (if (not (var-expr? var env))
      (pt-syntax-error var "Identifier expected"))
    (new-set source env
      (env-lookup-var env (source-code var) var)
      (pt (caddr code) env 'true))))

(define (pt-lambda source env use)

  (define (check-none-result node)
    (if (eq? use 'none)
      (new-cst source env void-object)
      node))

  (define (bind-default-bindings default-bindings env)
    (if (null? default-bindings)
      (pt-body source (cddr (source-code source)) env 'true)
      (let* ((binding (car default-bindings))
             (var1 (vector-ref binding 0))
             (var2 (vector-ref binding 1))
             (val (vector-ref binding 2))
             (parm-source (vector-ref binding 3))
             (vars (list var2)))
        (new-call* parm-source env
          (new-prc parm-source env #f #f vars '() #f #f
            (bind-default-bindings
              (cdr default-bindings)
              (env-frame env vars)))
          (list (new-tst parm-source env
                  (new-call* parm-source env
                    (new-ref-extended-bindings
                      parm-source
                      **eq?-sym
                      env)
                    (list (new-ref parm-source env var1)
                          (new-cst parm-source env absent-object)))
                  val
                  (new-ref parm-source env var1)))))))

  (define (split-default-bindings parms env cont)
    (let loop ((lst parms)
               (rev-vars '())
               (rev-defaults '())
               (rev-bindings '())
               (env env))
      (if (null? lst)

        (cont (reverse rev-vars)
              (reverse rev-defaults)
              (reverse rev-bindings)
              env)

        (let* ((parameter
                (car lst))
               (parm-source
                (parameter-source parameter))
               (val-source
                (parameter-default-source parameter))
               (var1
                (new-variable parm-source))
               (val
                (if val-source
                  (pt val-source env 'true)
                  (new-cst parm-source env
                    false-object))))
          (if (cst? val)
            (loop (cdr lst)
                  (cons var1 rev-vars)
                  (cons (cst-val val) rev-defaults)
                  rev-bindings
                  (env-frame env (list var1)))
            (let ((var2 (new-variable parm-source)))
              (loop (cdr lst)
                    (cons var1 rev-vars)
                    (cons absent-object rev-defaults)
                    (cons (vector var1 var2 val parm-source)
                          rev-bindings)
                    (env-frame env (list var2)))))))))

  (let* ((code
          (source-code source))
         (all-parms
          (extract-parameters (source->parms (cadr code)) env))
         (required-parameters
          (vector-ref all-parms 0))
         (optional-parameters
          (vector-ref all-parms 1))
         (rest-parameter
          (vector-ref all-parms 2))
         (dsssl-style-rest?
          (vector-ref all-parms 3))
         (key-parameters
          (vector-ref all-parms 4))
         (required-vars
          (new-variables (map parameter-source required-parameters)))
         (rest-vars
          (if rest-parameter
            (list (new-variable (parameter-source rest-parameter)))
            '())))

    (check-none-result
     (split-default-bindings
      (or optional-parameters '())
      (env-frame env required-vars)
      (lambda (opt-vars opt-defaults opt-bindings opt-env)
        (split-default-bindings
         (or key-parameters '())
         (if dsssl-style-rest? (env-frame opt-env rest-vars) opt-env)
         (lambda (key-vars key-defaults key-bindings key-env)
           (let ((keys
                  (and key-parameters
                       (map (lambda (x)
                              (cons (string->keyword-object
                                     (symbol->string (var-name (car x))))
                                    (cdr x)))
                            (pair-up key-vars key-defaults))))
                 (outer-vars
                  (append required-vars opt-vars key-vars rest-vars)))
             (new-prc source env #f #f outer-vars opt-defaults keys
               (and rest-parameter
                    (if dsssl-style-rest? 'dsssl #t))
               (bind-default-bindings
                (append opt-bindings key-bindings)
                (env-frame env outer-vars)))))))))))

(define (parameter-name parm)
  (vector-ref parm 0))

(define (parameter-source parm)
  (vector-ref parm 1))

(define (parameter-default-source parm)
  (vector-ref parm 2))

(define (extract-parameters param-list env)

  (define (parm-expected-err source)
    (pt-syntax-error source "Identifier expected"))

  (define (parm-or-default-binding-expected-err source)
    (pt-syntax-error source "Parameter must be an identifier or default binding"))

  (define (duplicate-parm-err source)
    (pt-syntax-error source "Duplicate parameter in parameter list"))

  (define (duplicate-rest-parm-err source)
    (pt-syntax-error source "Duplicate rest parameter in parameter list"))

  (define (rest-parm-expected-err source)
    (pt-syntax-error source "#!rest must be followed by a parameter"))

  (define (rest-parm-must-be-last-err source)
    (pt-syntax-error source "Rest parameter must be last"))

  (define (default-binding-err source)
    (pt-syntax-error source "Ill-formed default binding"))

  (define (optional-illegal-err source)
    (pt-syntax-error source "Ill-placed #!optional"))

  (define (key-illegal-err source)
    (pt-syntax-error source "Ill-placed #!key"))

  (define (key-expected-err source)
    (pt-syntax-error source "#!key expected after rest parameter"))

  (define (default-binding-illegal-err source)
    (pt-syntax-error source "Ill-placed default binding"))

  (let loop ((lst param-list)
             (rev-required-parms '())
             (rev-optional-parms #f)
             (rest-parm #f)
             (rev-key-parms #f)
             (state 1)) ; 1 = required parms or #!optional/#!rest/#!key
                        ; 2 = optional parms or #!rest/#!key
                        ; 3 = #!key
                        ; 4 = key parms (or #!rest if rest-parm=#f)

    (define (done rest-parm2)
      (vector (reverse rev-required-parms)
              (and rev-optional-parms (reverse rev-optional-parms))
              rest-parm2
              (and rest-parm (= state 4))
              (if (or (not rev-key-parms)
                      (and (null? rev-key-parms) (not rest-parm2)))
                #f
                (reverse rev-key-parms))))

    (define (parm-exists? parm lst)
      (and lst
           (not (null? lst))
           (or (eq? parm (vector-ref (car lst) 0))
               (parm-exists? parm (cdr lst)))))

    (define (check-if-duplicate parm parm-source)
      (if (or (parm-exists? parm rev-required-parms)
              (parm-exists? parm rev-optional-parms)
              (and rest-parm (eq? parm (vector-ref rest-parm 0)))
              (parm-exists? parm rev-key-parms))
        (duplicate-parm-err parm-source)))

    (cond ((null? lst)
           (done rest-parm))
          ((pair? lst)
           (let* ((parm-source (car lst))
                  (parm (source-code parm-source)))
             (cond ((optional-object? parm)
                    (if (not (= state 1))
                      (optional-illegal-err parm-source))
                    (loop (cdr lst)
                          rev-required-parms
                          '()
                          rest-parm
                          rev-key-parms
                          2))
                   ((rest-object? parm)
                    (if rest-parm
                      (duplicate-rest-parm-err parm-source))
                    (if (pair? (cdr lst))
                      (let* ((parm-source (cadr lst))
                             (parm (source-code parm-source)))
                        (if (bindable-var? parm-source env)
                          (begin
                            (check-if-duplicate parm parm-source)
                            (if (= state 4)
                              (if (null? (cddr lst))
                                (done (vector parm parm-source))
                                (rest-parm-must-be-last-err parm-source))
                              (loop (cddr lst)
                                    rev-required-parms
                                    rev-optional-parms
                                    (vector parm parm-source)
                                    rev-key-parms
                                    3)))
                          (parm-expected-err parm-source)))
                      (rest-parm-expected-err parm-source)))
                   ((key-object? parm)
                    (if (= state 4)
                      (key-illegal-err parm-source))
                    (loop (cdr lst)
                          rev-required-parms
                          rev-optional-parms
                          rest-parm
                          '()
                          4))
                   ((= state 3)
                    (key-expected-err parm-source))
                   ((bindable-var? parm-source env)
                    (check-if-duplicate parm parm-source)
                    (case state
                      ((1)
                       (loop (cdr lst)
                             (cons (vector parm parm-source)
                                   rev-required-parms)
                             rev-optional-parms
                             rest-parm
                             rev-key-parms
                             state))
                      ((2)
                       (loop (cdr lst)
                             rev-required-parms
                             (cons (vector parm parm-source #f)
                                   rev-optional-parms)
                             rest-parm
                             rev-key-parms
                             state))
                      (else
                       (loop (cdr lst)
                             rev-required-parms
                             rev-optional-parms
                             rest-parm
                             (cons (vector parm parm-source #f)
                                   rev-key-parms)
                             state))))
                   ((pair? parm)
                    (if (not (or (= state 2) (= state 4)))
                      (default-binding-illegal-err parm-source))
                    (let ((length (proper-length parm)))
                      (if (not (eqv? length 2))
                        (default-binding-err parm-source)))
                    (let* ((parm-source (car parm))
                           (val-source (cadr parm))
                           (parm (source-code parm-source)))
                      (if (bindable-var? parm-source env)
                        (begin
                          (check-if-duplicate parm parm-source)
                          (case state
                            ((2)
                             (loop (cdr lst)
                                   rev-required-parms
                                   (cons (vector parm parm-source val-source)
                                         rev-optional-parms)
                                   rest-parm
                                   rev-key-parms
                                   state))
                            (else
                             (loop (cdr lst)
                                   rev-required-parms
                                   rev-optional-parms
                                   rest-parm
                                   (cons (vector parm parm-source val-source)
                                         rev-key-parms)
                                   state))))
                        (parm-expected-err parm-source))))
                   (else
                    (if (not (= state 1))
                      (parm-or-default-binding-expected-err parm-source)
                      (parm-expected-err parm-source))))))
          (else
           (let* ((parm-source lst)
                  (parm (source-code parm-source)))
             (if (bindable-var? parm-source env)
               (begin
                 (if rest-parm
                   (duplicate-rest-parm-err parm-source))
                 (check-if-duplicate parm parm-source)
                 (done (vector parm parm-source)))
               (parm-expected-err parm-source)))))))

(define (source->parms source)
  (let ((x (source-code source)))
    (if (or (pair? x) (null? x)) x source)))

(define (pt-body source body env use)

  (define (extract-defs defs non-defs exprs env cont)
    (cond ((null? exprs)
           (cont defs
                 non-defs
                 env))
          ((not (null? non-defs))
           (extract-defs defs
                         (cons (vector (car exprs) env)
                               non-defs)
                         (cdr exprs)
                         env
                         cont))
          ((macro-expr? (car exprs) env)
           (extract-defs defs
                         non-defs
                         (cons (macro-expand (car exprs) env)
                               (cdr exprs))
                         env
                         cont))
          ((**begin-cmd-or-expr? (car exprs) env)
           (extract-defs defs
                         non-defs
                         (append (begin-body (car exprs))
                                 (cdr exprs))
                         env
                         cont))
          ((**define-expr? (car exprs) env)
           (let* ((var-source (definition-name (car exprs) env))
                  (var (source-code var-source))
                  (v (env-define-var env var var-source)))
             (extract-defs (cons (vector v
                                         (definition-value (car exprs))
                                         env)
                                 defs)
                           non-defs
                           (cdr exprs)
                           env
                           cont)))
          ((or (**define-macro-expr? (car exprs) env)
               (**define-syntax-expr? (car exprs) env))
           (extract-defs defs
                         non-defs
                         (cdr exprs)
                         (add-macro (car exprs) env)
                         cont))
          ((**include-expr? (car exprs) env)
           (if *ptree-port*
             (display "  " *ptree-port*))
           (let ((x (include-expr->source (car exprs) *ptree-port*)))
             (if *ptree-port*
               (newline *ptree-port*))
             (extract-defs defs
                           non-defs
                           (cons x (cdr exprs))
                           env
                           cont)))
          ((**declare-expr? (car exprs) env)
           (extract-defs defs
                         non-defs
                         (cdr exprs)
                         (add-declarations (car exprs) env)
                         cont))
          ((**namespace-expr? (car exprs) env)
           (extract-defs defs
                         non-defs
                         (cdr exprs)
                         (add-namespace (car exprs) env)
                         cont))
          ((**declare-scope-expr? (car exprs) env)
           (let ((save (env-decl-ref env)))
             (extract-defs defs
                           non-defs
                           (declare-scope-body (car exprs))
                           env
                           (lambda (defs non-defs env)
                             (extract-defs defs
                                           non-defs
                                           (cdr exprs)
                                           (env-decl-set env save)
                                           cont)))))
          ((**namespace-scope-expr? (car exprs) env)
           (let ((save (env-namespace-ref env)))
             (extract-defs defs
                           non-defs
                           (namespace-scope-body (car exprs))
                           env
                           (lambda (defs non-defs env)
                             (extract-defs defs
                                           non-defs
                                           (cdr exprs)
                                           (env-namespace-set env save)
                                           cont)))))
          ((**macro-scope-expr? (car exprs) env)
           (let ((save (env-macros-ref env)))
             (extract-defs defs
                           non-defs
                           (macro-scope-body (car exprs))
                           env
                           (lambda (defs non-defs env)
                             (extract-defs defs
                                           non-defs
                                           (cdr exprs)
                                           (env-macros-set env save)
                                           cont)))))
          ((**c-declare-expr? (car exprs) env)
           (let ((body (source-code (c-declaration-body (car exprs)))))
             (add-c-decl body)
             (extract-defs defs
                           non-defs
                           (cdr exprs)
                           env
                           cont)))
          ((**c-initialize-expr? (car exprs) env)
           (let ((body (source-code (c-initialization-body (car exprs)))))
             (add-c-init body)
             (extract-defs defs
                           non-defs
                           (cdr exprs)
                           env
                           cont)))
          (else
           (extract-defs defs
                         (cons (vector (car exprs) env)
                               non-defs)
                         (cdr exprs)
                         env
                         cont))))

  (extract-defs '()
                '()
                body
                (env-frame env '())
                (lambda (defs non-defs env)
                  (cond ((null? non-defs)
                         (pt-syntax-error
                          source
                          "Body must contain at least one expression"))
                        ((null? defs)
                         (pt-non-def-sequence source
                                              (reverse non-defs)
                                              use))
                        (else
                         (let loop ((lst defs)
                                    (vars '())
                                    (vals '()))
                           (if (pair? lst)
                               (let* ((var-val-env (car lst))
                                      (var (vector-ref var-val-env 0))
                                      (val (vector-ref var-val-env 1))
                                      (env (vector-ref var-val-env 2)))
                                 (loop (cdr lst)
                                       (cons var vars)
                                       (cons (pt val env 'true) vals)))
                               (pt-recursive-let
                                 source
                                 vars
                                 vals
                                 (lambda ()
                                   (pt-non-def-sequence source
                                                        (reverse non-defs)
                                                        use))
                                 env
                                 use
                                 #t))))))))

(define (pt-non-def-sequence source seq use)
  (let* ((first (car seq))
         (val (vector-ref first 0))
         (env (vector-ref first 1)))
    (if (length? seq 1)
        (pt val env use)
        (new-seq source env
          (pt val env 'none)
          (pt-non-def-sequence source (cdr seq) use)))))

(define (pt-sequence source seq env use)
  (cond ;; ((length? seq 0)
        ;; ;; treat empty sequence as constant evaluating to the void object
        ;; (new-cst source env void-object))
        ((length? seq 1)
         (pt (car seq) env use))
        (else
         (new-seq source env
           (pt (car seq) env 'none)
           (pt-sequence source (cdr seq) env use)))))

(define (pt-if source env use)
  (let ((code (source-code source)))
    (new-tst source env
      (pt (cadr code) env 'pred)
      (pt (caddr code) env use)
      (if (length? code 3)
        (new-cst source env void-object)
        (pt (cadddr code) env use)))))

(define (pt-cond source env use)
  (pt-cond-clauses
   source
   env
   use
   (cdr (source-code source))
   (lambda (source env)
     (new-cst source env void-object))))

(define (pt-cond-clauses source env use clauses fallthrough)
  (if (length? clauses 0)
      (fallthrough source env)
      (let* ((clause-source (car clauses))
             (clause (source-code clause-source)))
        (cond ((eq? (source-code (car clause)) else-sym)
               (pt-sequence clause-source (cdr clause) env use))
              ((length? clause 1)
               (new-disj clause-source env
                         (pt (car clause) env (if (eq? use 'true) 'true 'pred))
                         (pt-cond-clauses source env use (cdr clauses) fallthrough)))
              ((eq? (source-code (cadr clause)) =>-sym)
               (new-disj-call clause-source env
                              (pt (car clause) env 'true)
                              (pt (caddr clause) env 'true)
                              (pt-cond-clauses source env use (cdr clauses) fallthrough)))
              (else
               (new-tst clause-source env
                        (pt (car clause) env 'pred)
                        (pt-sequence clause-source (cdr clause) env use)
                        (pt-cond-clauses source env use (cdr clauses) fallthrough)))))))

(define (pt-cond-clauses-else? clauses)
  (if (length? clauses 0)
      #f
      (let* ((clause-source (car clauses))
             (clause (source-code clause-source)))
        (cond ((eq? (source-code (car clause)) else-sym)
               #t)
              (else
               (pt-cond-clauses-else? (cdr clauses)))))))

(define (pt-and source env use)

  (define (pt-exprs exprs)
    (cond ((length? exprs 0)
           (new-cst source env #t))
          ((length? exprs 1)
           (pt (car exprs) env use))
          (else
           (new-conj (car exprs) env
             (pt (car exprs) env (if (eq? use 'true) 'true 'pred))
             (pt-exprs (cdr exprs))))))

  (pt-exprs (cdr (source-code source))))

(define (pt-or source env use)

  (define (pt-exprs exprs)
    (cond ((length? exprs 0)
           (new-cst source env false-object))
          ((length? exprs 1)
           (pt (car exprs) env use))
          (else
           (new-disj (car exprs) env
             (pt (car exprs) env (if (eq? use 'true) 'true 'pred))
             (pt-exprs (cdr exprs))))))

  (pt-exprs (cdr (source-code source))))

(define (pt-case source env use)
  (let ((code (source-code source))
        (temp (new-temp-variable source 'case-temp)))

    (define (pt-clauses clauses)
      (if (length? clauses 0)
        (new-cst source env void-object)
        (let* ((clause-source (car clauses))
               (clause (source-code clause-source)))

          (define (pt-inlined-memv constants)
            (let ((test
                    (new-call*
                      clause-source
                      (add-not-safe env)
                      (new-ref-extended-bindings clause-source **eqv?-sym env)
                      (list (new-ref clause-source env
                              temp)
                            (new-cst (car clause) env
                              (car constants))))))
              (if (null? (cdr constants))
                test
                (new-disj clause-source env
                  test
                  (pt-inlined-memv (cdr constants))))))


          (if (eq? (source-code (car clause)) else-sym)
            (pt-sequence clause-source (cdr clause) env use)
            (new-tst clause-source env
              (pt-inlined-memv (source->expression (car clause)))
              (pt-sequence clause-source (cdr clause) env use)
              (pt-clauses (cdr clauses)))))))

    (new-call* source env
      (new-prc source env #f #f (list temp) '() #f #f
        (pt-clauses (cddr code)))
      (list (pt (cadr code) env 'true)))))

(define (pt-let source env use)
  (let ((code (source-code source)))
    (if (bindable-var? (cadr code) env)
      (let* ((self
              (list (new-variable (cadr code))))
             (bindings
              (map source-code (source-code (caddr code))))
             (vars
              (new-variables (map car bindings)))
             (vals
              (map (lambda (x) (pt (cadr x) env 'true)) bindings))
             (inner-env1
              (env-frame env vars))
             (inner-env2
              (env-frame inner-env1 self))
             (self-proc
              (list (new-prc source inner-env1
                      #f
                      #f
                      vars
                      '()
                      #f
                      #f
                      (pt-body source (cdddr code) inner-env2 use)))))
        (set-prc-names! self self-proc)
        (set-prc-names! vars vals)
        (new-call* source env
          (new-prc source env #f #f self '() #f #f
            (new-call* source inner-env1
              (new-ref source inner-env1 (car self))
              vals))
          self-proc))
      (if (null? (source-code (cadr code)))
        (pt-body source (cddr code) env use)
        (let* ((bindings
                (map source-code (source-code (cadr code))))
               (vars
                (new-variables (map car bindings)))
               (vals
                (map (lambda (x) (pt (cadr x) env 'true)) bindings))
               (inner-env
                (env-frame env vars)))
          (set-prc-names! vars vals)
          (new-call* source env
            (new-prc source env
              #f
              #f
              vars
              '()
              #f
              #f
              (pt-body source (cddr code) inner-env use))
            vals))))))

(define (pt-let* source env use)
  (let ((code (source-code source)))

    (define (pt-bindings bindings env use)
      (if (null? bindings)
        (pt-body source (cddr code) env use)
        (let* ((binding-source
                (car bindings))
               (binding
                (source-code binding-source))
               (vars
                (list (new-variable (car binding))))
               (vals
                (list (pt (cadr binding) env 'true)))
               (inner-env
                (env-frame env vars)))
          (set-prc-names! vars vals)
          (new-call* binding-source env
            (new-prc binding-source env #f #f vars '() #f #f
              (pt-bindings (cdr bindings) inner-env use))
            vals))))

    (pt-bindings (source-code (cadr code)) env use)))

(define (pt-letrec source env use *?)
  (let* ((code
          (source-code source))
         (bindings
          (map source-code (source-code (cadr code))))
         (vars*
          (new-variables (map car bindings)))
         (env*
          (env-frame env vars*)))
    (pt-recursive-let
      source
      vars*
      (map (lambda (x) (pt (cadr x) env* 'true)) bindings)
      (lambda () (pt-body source (cddr code) env* use))
      env*
      use
      *?)))

(define (pt-recursive-let source vars vals body env use *?)

  (define (dependency-graph vars vals)
    (let ((var-set (list->varset vars)))

      (define (dgraph vars vals)
        (if (null? vars)
          '()
          (let ((var (car vars)) (val (car vals)))
            (cons (make-gnode var (varset-intersection
                                    var-set
                                    (bound-free-variables val)))
                  (dgraph (cdr vars) (cdr vals))))))

      (dgraph vars vals)))

  (define (val-of var)
    (list-ref vals (- (length vars) (length (memq var vars)))))

  (define (bind-in-order order)
    (if (null? order)

      (body)

      ; get vars to be bound and vars to be assigned

      (let* ((vars (car order))
             (vars-set (list->varset vars)))
        (let loop1 ((l (reverse vars)) (vars-b '()) (vals-b '()) (vars-a '()))
          (if (not (null? l))

            (let* ((var (car l))
                   (val (val-of var)))
              (if (or (prc? val)
                      (not (varset-intersects? (bound-free-variables val)
                                               vars-set)))
                (loop1 (cdr l)
                       (cons var vars-b)
                       (cons val vals-b)
                       vars-a)
                (loop1 (cdr l)
                       vars-b
                       vals-b
                       (cons var vars-a))))

            (let* ((result1
                     (let loop2 ((l vars-a))
                       (if (not (null? l))

                         (let* ((var (car l))
                                (val (val-of var)))
                           (new-seq source env
                             (new-set source env var val)
                             (loop2 (cdr l))))

                         (bind-in-order (cdr order)))))

                   (result2
                     (if (null? vars-b)
                       result1
                       (new-call* source env
                         (new-prc source env
                           #f
                           #f
                           vars-b
                           '()
                           #f
                           #f
                           result1)
                         vals-b)))

                   (result3
                     (if (null? vars-a)
                       result2
                       (new-call* source env
                         (new-prc source env
                           #f
                           #f
                           vars-a
                           '()
                           #f
                           #f
                           result2)
                         (map (lambda (var)
                                (new-cst source env
                                  void-object))
                              vars-a)))))

              result3))))))

  (set-prc-names! vars vals)

  (let ((order
         (if *?
             (list vars)
             (map varset->list
                  (topological-sort
                   (transitive-closure
                    (dependency-graph vars vals)))))))
    (bind-in-order order)))

(define (pt-begin source env use)
  (pt-sequence source (begin-body source) env use))

(define (pt-do source env use)
  (let* ((code
          (source-code source))
         (loop
          (new-temp-variable source 'do-temp))
         (bindings
          (map source-code (source-code (cadr code))))
         (vars
          (new-variables (map car bindings)))
         (init
          (map (lambda (x) (pt (cadr x) env 'true)) bindings))
         (inner-env1
          (env-frame env (list loop)))
         (inner-env2
          (env-frame inner-env1 vars))
         (step
          (map (lambda (x)
                 (pt (if (length? x 2) (car x) (caddr x)) inner-env2 'true))
               bindings))
         (exit
          (source-code (caddr code))))
    (set-prc-names! vars init)
    (new-call* source env
      (new-prc source env #f #f (list loop) '() #f #f
        (new-call* source inner-env1
          (new-ref source inner-env1
            loop)
          init))
      (list
        (new-prc source env #f #f vars '() #f #f
          (new-tst source inner-env2
            (pt (car exit) inner-env2 'pred)
            (if (length? exit 1)
              (new-cst (caddr code) inner-env2 void-object)
              (pt-sequence (caddr code) (cdr exit) inner-env2 use))
            (if (length? code 3)
              (new-call* source inner-env2
                (new-ref source inner-env2 loop)
                step)
              (new-seq source inner-env2
                (pt-sequence source (cdddr code) inner-env2 'none)
                (new-call* source inner-env2
                  (new-ref source inner-env2
                    loop)
                  step)))))))))

(define (pt-guard source env use r7rs-guard?)
  (let* ((code (source-code source))
         (var-and-clauses (source-code (cadr code)))
         (clauses (cdr var-and-clauses))
         (extra-handler-parms
          (if (and r7rs-guard? (not (pt-cond-clauses-else? clauses)))
              (list (new-temp-variable source 'reraise-cont))
              '()))
         (exc-var
          (new-variable (car var-and-clauses)))
         (handler-parms
          (cons exc-var extra-handler-parms))
         (env-catcher
          (env-frame env handler-parms))
         (body-ptree
          (pt-cond-clauses
           source
           env-catcher
           use
           clauses
           (lambda (source env)
             (new-call* source (add-not-safe env)
               (new-ref-extended-bindings
                source
                (if (null? extra-handler-parms)
                    **raise-sym
                    **r7rs-reraise-sym)
                env)
               (map (lambda (v) (new-ref source env v)) handler-parms)))))
         (handler-ptree
          (new-prc source env #f #f handler-parms '() #f #f
            body-ptree))
         (thunk-ptree
          (new-prc source env #f #f '() '() #f #f
            (pt-sequence source (cddr code) env use))))
    (new-call* source (add-not-safe env)
      (new-ref-extended-bindings
       source
       (if (null? extra-handler-parms)
           **with-exception-catcher-sym
           **r7rs-with-exception-catcher-sym)
       env)
      (list handler-ptree
            thunk-ptree))))

(define (pt-combination source env use)
  (let* ((code (source-code source))
         (oper (pt (car code) env 'true)))
    (new-call* source env
      oper
      (map (lambda (x) (pt x env 'true)) (cdr code)))))

(define (pt-delay source env use)
  (let ((code (source-code source)))
    (new-call* source (add-not-safe env)
      (new-ref-extended-bindings source **make-delay-promise-sym env)
      (list (new-prc source env #f #f '() '() #f #f
              (pt (cadr code) env 'true))))))

(define (pt-future source env use)
  (let ((code (source-code source)))
    (new-fut source env
      (pt (cadr code) env 'true))))

;; Expression identification predicates and syntax checking.

(define (self-eval-expr? source env)
  (let ((code (source-code source)))
    (self-evaluating? code)))

(define (self-evaluating? code)
  (or (number? code)
      (string? code)
      (char? code)
      (keyword-object? code)
      (false-object? code)
      (eq? code #t)
      (end-of-file-object? code)
      (void-object? code)
      (unbound1-object? code)
      (unbound2-object? code)
      (optional-object? code)
      (key-object? code)
      (rest-object? code)
;;      (body-object? code)
      (vector-object? code)
      (u8vect? code)
      (s8vect? code)
      (u16vect? code)
      (s16vect? code)
      (u32vect? code)
      (s32vect? code)
      (u64vect? code)
      (s64vect? code)
      (f32vect? code)
      (f64vect? code)
      ))

(define (**quote-expr? source env)
  (match **quote-sym 2 source env))

(define (**quasiquote-expr? source env)
  (match **quasiquote-sym 2 source env))

(define (quasiquote-expr? source)
  (match quasiquote-sym 2 source #f))

(define (unquote-expr? source)
  (match unquote-sym 2 source #f))

(define (unquote-splicing-expr? source)
  (match unquote-splicing-sym 2 source #f))

(define (var-expr? source env)
  (let ((code (source-code source)))
    (and (symbol-object? code)
         (not-macro source env code))))

(define (not-macro source env name)
  (if (env-lookup-macro env name)
    (pt-syntax-error source "Macro name can't be used as a variable:" name)
    #t))

(define (bindable-var? source env)
  (let ((code (source-code source)))
    (symbol-object? code)))

(define (**set!-expr? source env)
  (match **set!-sym 3 source env))

(define (**lambda-expr? source env)
  (match **lambda-sym -3 source env))

(define (lambda-expr? source env)
  (match lambda-sym -3 source env))

(define (**if-expr? source env)
  (and (match **if-sym -3 source env)
       (or (<= (length (source-code source)) 4)
           (ill-formed-special-form source))))

(define (**cond-expr? source env)
  (and (match **cond-sym -2 source env)
       (proper-cond/guard-clauses? source (cdr (source-code source)) 'cond)))

(define (**and-expr? source env)
  (match **and-sym -1 source env))

(define (**or-expr? source env)
  (match **or-sym -1 source env))

(define (**case-expr? source env)
  (and (match **case-sym -3 source env)
       (proper-case-clauses? source)))

(define (**let-expr? source env)
  (and (match **let-sym -3 source env)
       (let ((code (source-code source)))
         (if (bindable-var? (cadr code) env)
           (and (proper-bindings? (caddr code) #t env)
                (or (> (length code) 3)
                    (ill-formed-special-form source)))
           (proper-bindings? (cadr code) #t env)))))

(define (**let*-expr? source env)
  (and (match **let*-sym -3 source env)
       (proper-bindings? (cadr (source-code source)) #f env)))

(define (**letrec-expr? source env)
  (and (match **letrec-sym -3 source env)
       (proper-bindings? (cadr (source-code source)) #t env)))

(define (**letrec*-expr? source env)
  (and (match **letrec*-sym -3 source env)
       (proper-bindings? (cadr (source-code source)) #t env)))

(define (**do-expr? source env)
  (and (match **do-sym -3 source env)
       (proper-do-bindings? source env)
       (proper-do-exit? source)))

(define (**guard-expr? source env)
  (and (match **guard-sym -3 source env)
       (proper-guard? source env 'guard)))

(define (**r7rs-guard-expr? source env)
  (and (match **r7rs-guard-sym -3 source env)
       (proper-guard? source env 'r7rs-guard)))

(define (proper-guard? source env form-name)
  (let* ((var-and-clauses (source-code (cadr (source-code source))))
         (length (proper-length var-and-clauses)))
    (if (not (and length (>= length 2)))
        (pt-syntax-error
         source
         (string-append
          "Ill-formed '"
          (symbol->string form-name)
          "' clause"))
        (let ((var (car var-and-clauses)))
          (if (bindable-var? var env)
              (proper-cond/guard-clauses? source (cdr var-and-clauses) form-name)
              (pt-syntax-error
               var
               "Identifier expected"))))))

(define (combination-expr? source env)
  (let ((code (source-code source)))
    (and (pair? code)
         (let ((length (proper-length code)))
           (if length
             (or (> length 0)
                 (pt-syntax-error source "Ill-formed procedure call"))
             (pt-syntax-error source "Ill-formed procedure call"))))))

(define (**delay-expr? source env)
  (and (not (eq? (scheme-dialect env) ieee-scheme-sym))
       (match **delay-sym 2 source env)))

(define (**future-expr? source env)
  (and (eq? (scheme-dialect env) multilisp-sym)
       (match **future-sym 2 source env)))

(define (macro-expr? source env)
  (let ((code (source-code source)))
    (and (pair? code)
         (symbol-object? (source-code (car code)))
         (let ((descr (env-lookup-macro env (source-code (car code)))))
           (and descr
                (let ((len (proper-length code)))
                  (if len
                    (let ((size (**macro-descr-size descr)))
                      (or (if (> size 0) (= len size) (>= len (- size)))
                          (ill-formed-special-form source)))
                    (ill-formed-special-form source))))))))

(define (**begin-cmd-or-expr? source env)
  (match **begin-sym -1 source env))

(define (**begin-expr? source env)
  (match **begin-sym -2 source env))

(define (**define-expr? source env)
  (match **define-sym -2 source env))

(define (**define-macro-expr? source env)
  (match **define-macro-sym -3 source env))

(define (**define-syntax-expr? source env)
  (match **define-syntax-sym 3 source env))

(define (**include-expr? source env)
  (and (match **include-sym 2 source env)
       (let ((filename (cadr (source-code source))))
         (if (not (string? (source-code filename)))
           (pt-syntax-error filename "Filename expected"))
         #t)))

(define (**declare-expr? source env)
  (match **declare-sym -1 source env))

(define (**namespace-expr? source env)
  (match **namespace-sym -1 source env))

(define (**declare-scope-expr? source env)
  (match **declare-scope-sym -1 source env))

(define (declare-scope-body source)
  (cdr (source-code source)))

(define (**namespace-scope-expr? source env)
  (match **namespace-scope-sym -1 source env))

(define (namespace-scope-body source)
  (cdr (source-code source)))

(define (**macro-scope-expr? source env)
  (match **macro-scope-sym -1 source env))

(define (macro-scope-body source)
  (cdr (source-code source)))

(define (match head size source env)
  (let ((code (source-code source)))

    (define (check name)
      (and (eq? name head)
           (let ((length (proper-length code)))
             (if length
                 (or (if (> size 0) (= length size) (>= length (- size)))
                     (ill-formed-special-form source))
                 (ill-formed-special-form source)))))

    (and (pair? code)
         (let ((first (source-code (car code))))
           (and (symbol? first)
                (if env
                    (env-lookup
                     env
                     first
                     #f
                     (lambda (env name x)
                       (and (not x)
                            (check name))))
                    (check first)))))))

(define (ill-formed-special-form source)
  (pt-syntax-error
   source
   "Ill-formed special form:"
   (let* ((code (source-code source))
          (head (source-code (car code)))
          (name (symbol->string head))
          (len (string-length name)))
     (if (and (< 2 len)
              (char=? #\# (string-ref name 0))
              (char=? #\# (string-ref name 1)))
         (string->symbol (substring name 2 len))
         head))))

(define (proper-length l)
  (define (length l n)
    (cond ((pair? l) (length (cdr l) (+ n 1)))
          ((null? l) n)
          (else      #f)))
  (length l 0))

(define (definition-name source env)
  (let* ((code (source-code source))
         (head-source (car code))
         (head (source-code head-source))
         (pattern-source (cadr code))
         (pattern (source-code pattern-source))
         (len (proper-length code)))
    (if (not (cond ((and (eq? head **define-sym)
                         (not (pair? pattern)))
                    (or (= len 2)
                        (= len 3)))
                   ((or (eq? head **define-syntax-sym)
                        (and (eq? head **define-macro-sym)
                             (not (pair? pattern))))
                    (= len 3))
                   (else
                    (>= len 3))))
      (ill-formed-special-form source))
    (let* ((name-source
            (if (and (not (eq? head **define-syntax-sym))
                     (pair? pattern))
              (car pattern)
              pattern-source))
           (name
            (source-code name-source)))
      (if (not (symbol-object? name))
        (pt-syntax-error name-source "Identifier expected"))
      name-source)))

(define (definition-value source)
  (let ((code (source-code source))
        (loc (source-locat source)))
    (cond ((pair? (source-code (cadr code)))
           (make-source
             (cons (make-source **lambda-sym loc)
                   (cons (parms->source (cdr (source-code (cadr code))) loc)
                         (cddr code)))
             loc))
          ((null? (cddr code))
           (make-source
             (list (make-source **quote-sym loc)
                   (make-source void-object loc))
             loc))
          (else
           (caddr code)))))

(define (parms->source parms loc)
  (if (or (pair? parms) (null? parms))
    (make-source parms loc)
    parms))

(define (proper-cond/guard-clauses? source clauses form-name)

  (define (proper-clauses clauses)
    (or (null? clauses)
        (let* ((clause-source (car clauses))
               (clause (source-code clause-source))
               (length (proper-length clause)))
          (if length
            (if (>= length 1)
              (if (eq? (source-code (car clause)) else-sym)
                (cond ((= length 1)
                       (pt-syntax-error
                        clause-source
                        (string-append
                         "Else clause in '"
                         (symbol->string form-name)
                         "' must have a body")))
                      ((not (null? (cdr clauses)))
                       (pt-syntax-error
                        clause-source
                        (string-append
                         "Else clause in '"
                         (symbol->string form-name)
                         "' must be last")))
                      (else
                       (proper-clauses (cdr clauses))))
                (if (and (>= length 2)
                         (eq? (source-code (cadr clause)) =>-sym)
                         (not (= length 3)))
                  (pt-syntax-error
                    (cadr clause)
                    "'=>' must be followed by a single expression")
                  (proper-clauses (cdr clauses))))
              (pt-syntax-error
               clause-source
               (string-append
                "Ill-formed '"
                (symbol->string form-name)
                "' clause")))
            (pt-syntax-error
             clause-source
             (string-append
              "Ill-formed '"
              (symbol->string form-name)
              "' clause"))))))

  (proper-clauses clauses))

(define (proper-case-clauses? source)

  (define (proper-case-clauses clauses)
    (or (null? clauses)
        (let* ((clause-source (car clauses))
               (clause (source-code clause-source))
               (length (proper-length clause)))
          (if length
            (if (>= length 2)
              (if (eq? (source-code (car clause)) else-sym)
                (if (not (null? (cdr clauses)))
                  (pt-syntax-error
                    clause-source
                    "Else clause in 'case' must be last")
                  (proper-case-clauses (cdr clauses)))
                (begin
                  (proper-selector-list? (car clause))
                  (proper-case-clauses (cdr clauses))))
              (pt-syntax-error
                clause-source
                "A 'case' clause must have a selector list and a body"))
            (pt-syntax-error clause-source "Ill-formed 'case' clause")))))

  (proper-case-clauses (cddr (source-code source))))

(define (proper-selector-list? source)
  (let* ((code (source-code source))
         (length (proper-length code)))
    (if length
      (or (>= length 1)
          (pt-syntax-error
            source
            "Selector list must contain at least one element"))
      (pt-syntax-error source "Ill-formed selector list"))))

(define (proper-bindings? bindings check-dupl? env)

  (define (proper-bindings l seen)
    (cond ((pair? l)
           (let* ((binding-source (car l))
                  (binding (source-code binding-source)))
             (if (eqv? (proper-length binding) 2)
               (let ((var (car binding)))
                 (if (bindable-var? var env)
                   (if (and check-dupl? (memq (source-code var) seen))
                     (pt-syntax-error var "Duplicate variable in bindings")
                     (proper-bindings (cdr l)
                                      (cons (source-code var) seen)))
                   (pt-syntax-error var "Identifier expected")))
               (pt-syntax-error binding-source "Ill-formed binding"))))
          ((null? l)
           #t)
          (else
           (pt-syntax-error bindings "Ill-formed binding list"))))

   (proper-bindings (source-code bindings) '()))

(define (extract-bindings src bindings-src binding-style allow-dups? env)

  ;; binding-style can be:
  ;;
  ;; #f     simple var-value syntax e.g. (let ((a X) (b Y)) ...)
  ;; #t     variables in a sequence e.g. (let ((a b c X) (d Y)) ...)
  ;; list   variables in a list e.g. (let-values (((a b c) X) ((d . e) Y)) ...)
  ;; step   variable + value + optional step e.g. (do ((i 0 (+ i 1))) ...)

  (define (ill-formed-binding-list)
    (pt-syntax-error src "Ill-formed binding list"))

  (define (duplicate-variable-binding src)
    (pt-syntax-error src "Duplicate variable binding"))

  (define (variable src)
    (if (not (bindable-var? src env))
        (pt-syntax-error src "Identifier expected")))

  (let loop1 ((lst1 (source-code bindings-src))
              (rev-bindings '())
              (seen '()))

    (cond ((null? lst1)
           (reverse rev-bindings))

          ((pair? lst1)
           (let* ((binding-src
                   (sourcify (car lst1) src))
                  (binding
                   (source-code binding-src))
                  (len-binding
                   (proper-length binding)))

             (cond ((eq? binding-style 'step)
                    (case len-binding
                      ((2 3)
                       (let* ((var-src
                               (sourcify (car binding) binding-src))
                              (var
                               (source-code var-src)))
                         (variable var-src)
                         (if (memq var seen)
                             (duplicate-variable-binding var-src)
                             (loop1 (cdr lst1)
                                    (cons (cons var (cdr binding))
                                          rev-bindings)
                                    (cons var seen)))))
                      (else
                       (ill-formed-binding-list))))

                   ((eq? binding-style 'list)
                    (if (eqv? 2 len-binding)
                        (let* ((vars-src
                                (sourcify (car binding) binding-src))
                               (vars
                                (source-code vars-src)))
                          (if (or (pair? vars)
                                  (null? vars))
                              (let loop2 ((lst2 vars)
                                          (n 0)
                                          (rev-vars '())
                                          (seen (if allow-dups? '() seen)))
                                (cond ((null? lst2)
                                       (loop1 (cdr lst1)
                                              (cons
                                               (cons
                                                (cons n
                                                      (reverse rev-vars))
                                                (cadr binding))
                                               rev-bindings)
                                              seen))
                                      ((pair? lst2)
                                       (let* ((var-src
                                               (sourcify (car lst2)
                                                         vars-src))
                                              (var
                                               (source-code var-src))
                                              (rest
                                               (cdr lst2)))
                                         (variable var-src)
                                         (if (memq var seen)
                                             (duplicate-variable-binding
                                              var-src)
                                             (loop2 rest
                                                    (+ n 1)
                                                    (cons var rev-vars)
                                                    (cons var seen)))))
                                      (else
                                       (let* ((var-src
                                               (sourcify lst2 binding-src))
                                              (var
                                               (source-code var-src)))
                                         (variable var-src)
                                         (if (memq var seen)
                                             (duplicate-variable-binding
                                              var-src)
                                             (loop1 (cdr lst1)
                                                    (cons
                                                     (cons
                                                      (cons (- -1 n)
                                                            (reverse
                                                             (cons var
                                                                   rev-vars)))
                                                      (cadr binding))
                                                     rev-bindings)
                                                    (cons var seen)))))))
                              (let* ((var-src
                                      vars-src)
                                     (var
                                      (source-code var-src)))
                                (variable var-src)
                                (if (memq var seen)
                                    (duplicate-variable-binding
                                     var-src)
                                    (loop1 (cdr lst1)
                                           (cons
                                            (cons
                                             (cons -1
                                                   (list var))
                                             (cadr binding))
                                            rev-bindings)
                                           (cons var seen))))))
                        (ill-formed-binding-list)))

                   (else
                    (if (if binding-style
                            (and len-binding (>= len-binding 2))
                            (eqv? 2 len-binding))
                        (let loop3 ((lst2 binding)
                                    (n 0)
                                    (rev-vars '())
                                    (seen (if allow-dups? '() seen)))
                          (if (not (pair? lst2))
                              (ill-formed-binding-list)
                              (let ((first-src
                                     (sourcify (car lst2) binding-src))
                                    (rest
                                     (cdr lst2)))
                                (if (null? rest)
                                    (if (or (not (eq? binding-style #f))
                                            (and (pair? rev-vars)
                                                 (null? (cdr rev-vars))))
                                        (loop1 (cdr lst1)
                                               (cons
                                                (cons
                                                 (cons n
                                                       (reverse rev-vars))
                                                 first-src)
                                                rev-bindings)
                                               seen)
                                        (ill-formed-binding-list))
                                    (let ((first
                                           (source-code first-src)))
                                      (variable first-src)
                                      (if (memq first seen)
                                          (duplicate-variable-binding first-src)
                                          (loop3 rest
                                                 (+ n 1)
                                                 (cons first rev-vars)
                                                 (cons first seen))))))))
                        (ill-formed-binding-list))))))

          (else
           (ill-formed-binding-list)))))

(define (proper-do-bindings? source env)
  (let ((bindings (cadr (source-code source))))

    (define (proper-bindings l seen)
      (cond ((pair? l)
             (let* ((binding-source (car l))
                    (binding (source-code binding-source))
                    (length (proper-length binding)))
               (if (or (eqv? length 2) (eqv? length 3))
                 (let ((var (car binding)))
                   (if (bindable-var? var env)
                     (if (memq (source-code var) seen)
                       (pt-syntax-error var "Duplicate variable in bindings")
                       (proper-bindings (cdr l)
                                        (cons (source-code var) seen)))
                     (pt-syntax-error
                       var
                       "Identifier expected")))
                 (pt-syntax-error binding-source "Ill-formed binding"))))
            ((null? l)
             #t)
            (else
             (pt-syntax-error bindings "Ill-formed binding list"))))

     (proper-bindings (source-code bindings) '())))

(define (proper-do-exit? source)
  (let* ((exit-source (caddr (source-code source)))
         (exit (source-code exit-source))
         (length (proper-length exit)))
    (if (and length (> length 0))
      #t
      (pt-syntax-error exit-source "Ill-formed exit clause"))))

(define (begin-body source)
  (cdr (source-code source)))

(define (length? l n)
  (cond ((null? l) (= n 0))
        ((> n 0)   (length? (cdr l) (- n 1)))
        (else      #f)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Declaration handling:
;; --------------------

;; A declaration has the form: (##declare <item1> <item2> ...)
;;
;; an <item> can be one of 6 types:
;;
;; - flag declaration           : (<id>)
;; - parameterized declaration  : (<id> <parameter>)
;; - boolean declaration        : (<id>)  or  (not <id>)
;; - namable declaration        : (<id> <name>...)
;; - namable boolean declaration: (<id> <name>...)  or  (not <id> <name>...)

(define (transform-declaration source)
  (let ((code (source-code source)))
    (if (not (pair? code))
      (pt-syntax-error source "Ill-formed declaration")
      (let* ((pos (not (eq? (source-code (car code)) not-sym)))
             (x (if pos code (cdr code))))
        (if (not (pair? x))
          (pt-syntax-error source "Ill-formed declaration")
          (let* ((id-source (car x))
                 (id (source-code id-source)))

            (cond ((not (symbol-object? id))
                   (pt-syntax-error
                     id-source
                     "Declaration name must be an identifier"))

                  ((assq id flag-declarations)
                   =>
                   (lambda (decl)
                     (cond ((not pos)
                            (pt-syntax-error
                             id-source
                             "Declaration can't be negated"))
                           ((null? (cdr x))
                            (flag-decl
                             source
                             (cdr decl)
                             id))
                           (else
                            (pt-syntax-error source
                                             "Ill-formed declaration")))))

                  ((assq id parameterized-declarations)
                   =>
                   (lambda (decl)
                     (cond ((not pos)
                            (pt-syntax-error
                             id-source
                             "Declaration can't be negated"))
                           ((eqv? (proper-length x) 2)
                            (let ((parm (source->expression (cadr x)))
                                  (allow-boolean (cdr decl)))
                              (if (or (and (boolean? parm) allow-boolean)
                                      (and (integer? parm) (exact? parm)))
                                  (parameterized-decl source id parm)
                                  (pt-syntax-error
                                   source
                                   (if allow-boolean
                                       "Exact integer or boolean expected"
                                       "Exact integer expected")))))
                           (else
                            (pt-syntax-error source
                                             "Ill-formed declaration")))))

                  ((memq id boolean-declarations)
                   (if (null? (cdr x))
                     (boolean-decl source id pos)
                     (pt-syntax-error source "Ill-formed declaration")))

                  ((assq id namable-declarations)
                   =>
                   (lambda (decl)
                     (cond ((not pos)
                            (pt-syntax-error
                             id-source
                             "Declaration can't be negated"))
                           (else
                            (namable-decl
                             source
                             (cdr decl)
                             id
                             (extract-names source (cdr x)))))))

                  ((memq id namable-boolean-declarations)
                   (namable-boolean-decl
                     source
                     id
                     pos
                     (extract-names source (cdr x))))

                  (else
                   (pt-syntax-error id-source "Unknown declaration")))))))))

(define (extract-names source lst)

  (define (extract lst)
    (cond ((pair? lst)
           (let* ((name-source (car lst))
                  (name (source-code name-source)))
             (if (symbol-object? name)
               (cons name (extract (cdr lst)))
               (pt-syntax-error name-source "Identifier expected"))))
          ((null? lst)
           '())
          (else
           (pt-syntax-error source "Ill-formed declaration"))))

  (extract lst))

(define (add-declarations source env)
  (let loop ((lst (cdr (source-code source))) (env env))
    (if (pair? lst)
      (loop (cdr lst)
            (env-declare env (transform-declaration (car lst))))
      env)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Namespace handling:
;; ------------------

(define (add-namespace source env)
  (let ((code (cdr (source-code source))))
    (let loop ((lst code) (env env))
      (if (pair? lst)
        (let* ((form-source (car lst))
               (form (source-code form-source)))
          (if (not (pair? form))
            (pt-syntax-error source "Ill-formed namespace")
            (let* ((space-source (car form))
                   (space (source-code space-source)))
              (cond ((not (string? space))
                     (pt-syntax-error source "Ill-formed namespace"))
                    ((not (namespace-valid? space))
                     (pt-syntax-error space-source "Illegal namespace"))
                    (else
                     (let ()

                       (define (extract lst)
                         (cond ((pair? lst)
                                (let* ((alias-source (car lst))
                                       (alias (source-code alias-source)))
                                  (if (not (or (symbol-object? alias)
                                               (and (pair? alias)
                                                    (pair? (cdr alias))
                                                    (null? (cddr alias))
                                                    (symbol-object?
                                                     (source-code (car alias)))
                                                    (symbol-object?
                                                     (source-code (cadr alias))))))
                                      (pt-syntax-error source "Ill-formed namespace")
                                      (cons (if (symbol-object? alias)
                                                (cons alias alias)
                                                (cons (source-code (car alias))
                                                      (source-code (cadr alias))))
                                            (extract (cdr lst))))))
                               ((null? lst)
                                '())
                               (else
                                (pt-syntax-error source "Ill-formed namespace"))))

                       (loop (cdr lst)
                             (env-namespace
                              env
                              (cons space (extract (cdr form)))))))))))
        env))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Macro handling:
;; --------------

(define (add-macro source env)
  (let ((def-syntax? (**define-syntax-expr? source env)))

    (define (form-size parms)
      (let loop ((lst parms) (n 1))
        (cond ((pair? lst)
               (let ((parm (source-code (car lst))))
                 (if (or (optional-object? parm)
                         (key-object? parm)
                         (rest-object? parm))
                     (- n)
                     (loop (cdr lst)
                           (+ n 1)))))
              ((null? lst)
               n)
              (else
               (- n)))))

    (define (error-proc . msgs)
      (apply compiler-user-error
             (cons (source-locat source)
                   (cons "(in macro body)" msgs))))

    (define (make-descr var proc size)
      (let ((expander
             (scheme-global-eval (source->expression proc)
                                 error-proc)))
        (if (not (procedure? expander))
            (pt-syntax-error proc "Macro expander must be a procedure")
            (env-macro env
                       (source-code var)
                       (**make-macro-descr def-syntax? size expander proc)))))

    (let* ((var (definition-name source env))
           (proc (definition-value source)))
      (if def-syntax?
          (make-descr var
                      proc
                      -1)
          (if (or (**lambda-expr? proc #f) ;; check for ##lambda or lambda
                  (lambda-expr? proc #f))  ;; not sensitive to compile env
              (make-descr var
                          proc
                          (form-size
                           (source->parms (cadr (source-code proc)))))
              (pt-syntax-error proc "Macro value must be a lambda expression"))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (ptree.begin! info-port) ; initialize module
  (set! *ptree-port* info-port)
  (set! next-node-stamp (make-counter 0))
  (set! temp-variable-stamp (make-counter 0))
  '())

(define (ptree.end!) ; finalize module
  (set! next-node-stamp #f)
  (set! temp-variable-stamp #f)
  '())

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Stuff local to the module:

(define *ptree-port* '())

;;;============================================================================
