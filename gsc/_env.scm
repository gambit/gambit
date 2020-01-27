;;;============================================================================

;;; File: "_env.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

(include     "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

;;;----------------------------------------------------------------------------

;;;; Environment manipulation and declaration handling module

;;;----------------------------------------------------------------------------

(define next-var-stamp #f)

(define (var-lexical-level var)
  (let ((bound (var-bound var)))
    (if (or (eq? bound #f) (eq? bound #t))
        0
        (let loop ((node bound) (n 0))
          (if node
              (loop (node-parent node)
                    (+ n (if (prc? node) 1 0)))
              n)))))


;; temporary variables are used to name intermediate values

(define (make-temp-var name)
  (make-var name #t (ptset-empty) (ptset-empty) #f))

(define (temp-var? var)
  (eq? (var-bound var) #t))

;; special variable used to denote the return address of a procedure

(define ret-var '())
(define ret-var-set '())

;; special variable used to denote the pointer to the closed variables

(define closure-env-var '())

;; special variable used to denote empty slots

(define empty-var '())


;; structure that represents environments:

(define make-global-environment #f)
(set! make-global-environment
      (lambda () (env-frame #f '())))

(define (env-frame env vars)
  (vector (cons vars #f)     ; cell containing variables in this frame
          '()                           ; macro definitions
          (if env (env-decl-ref env) '()) ; declarations
          '()                           ; namespace
          env))                         ; parent env

(define (env-new-var! env name source)
  (let* ((glob (not (env-parent-ref env)))
         (var (make-var name (not glob) (ptset-empty) (ptset-empty) source)))
    (env-vars-set! env (cons var (env-vars-ref env)))
    var))

(define (env-macro env name def)
  (let ((name* (or (and (not (full-name? name))
                        (env-namespace-lookup env name))
                   name)))
    (env-macros-set env (cons (cons name* def) (env-macros-ref env)))))

(define (env-macros-set env macro)
  (vector (vector-ref env 0)
          macro
          (env-decl-ref env)
          (env-namespace-ref env)
          (env-parent-ref env)))

(define (env-declare env d)
  (env-decl-set env (cons d (env-decl-ref env))))

(define (env-decl-set env decl)
  (vector (vector-ref env 0)
          (env-macros-ref env)
          decl
          (env-namespace-ref env)
          (env-parent-ref env)))

(define (env-namespace env n)
  (env-namespace-set env (cons n (env-namespace-ref env))))

(define (env-namespace-set env namespace)
  (vector (vector-ref env 0)
          (env-macros-ref env)
          (env-decl-ref env)
          namespace
          (env-parent-ref env)))

(define (env-vars-ref env)       (car (vector-ref env 0)))
(define (env-vars-set! env vars) (set-car! (vector-ref env 0) vars))
(define (env-macros-ref env)     (vector-ref env 1))
(define (env-decl-ref env)       (vector-ref env 2))
(define (env-namespace-ref env)  (vector-ref env 3))
(define (env-parent-ref env)     (vector-ref env 4))

(define (env-namespace-lookup env name)
  (let loop ((lst (env-namespace-ref env)))
    (if (pair? lst)
        (let* ((x (car lst))
               (space (car x))
               (aliases (cdr x)))
          (if (null? aliases)
              (make-full-name space name)
              (let ((a (assq name aliases)))
                (if a
                    (make-full-name space (cdr a))
                    (loop (cdr lst))))))
        #f)))

(define (env-lookup env name stop-at-first-frame? proc)

  (define (search env name full?)
    (if full?
        (search* env name #t)
        (let ((full-name (env-namespace-lookup env name)))
          (if full-name
              (search* env full-name #t)
              (search* env name #f)))))

  (define (search* env name full?)

    (define (search-macros macros)
      (if (pair? macros)
          (let ((m (car macros)))
            (if (eq? (car m) name)
                (proc env name (cdr m))
                (search-macros (cdr macros))))
          (search-vars (env-vars-ref env))))

    (define (search-vars vars)
      (if (pair? vars)
          (let* ((v (car vars))
                 (vn (var-name v)))
            (if (eq? vn name)
                (proc env name v)
                (search-vars (cdr vars))))
          (let ((env* (env-parent-ref env)))
            (if (or stop-at-first-frame? (not env*))
                (proc env name #f)
                (search env* name full?)))))

    (search-macros (env-macros-ref env)))

  (search env name (full-name? name)))

(define (namespace-valid? str)     ;; non-null name followed by a "#" at end
  (let ((len (string-length str))) ;; is valid as is the special prefix ""
    (or (= len 0)
        (and (>= len 2)
             (char=? (string-ref str (- len 1)) #\#)))))

(define (full-name? sym)           ;; full name if it contains a "#"
  (let ((str (symbol->string sym)))
    (let loop ((i (- (string-length str) 1)))
      (if (< i 0)
          #f
          (if (char=? (string-ref str i) #\#)
              #t
              (loop (- i 1)))))))

(define (make-full-name prefix sym)
  (if (= (string-length prefix) 0)
      sym
      (string->symbol (string-append prefix (symbol->string sym)))))

(define (env-lookup-var env name source)
  (env-lookup env name #f
              (lambda (env name x)
                (if x
                    (if (var? x)
                        x
                        (compiler-internal-error
                         "env-lookup-var, name is that of a macro" name))
                    (env-new-var! env name source)))))

(define (env-define-var env name source)
  (env-lookup env name #t
              (lambda (env name x)
                (if x
                    (if (var? x)
                        (pt-syntax-error
                         source
                         "Duplicate definition of a variable")
                        (compiler-internal-error
                         "env-define-var, name is that of a macro" name))
                    (env-new-var! env name source)))))

(define (env-lookup-global-var env name)
  (let ((env* (env-global-env env)))

    (define (search-vars vars)
      (if (pair? vars)
          (let ((v (car vars)))
            (if (eq? (var-name v) name)
                v
                (search-vars (cdr vars))))
          (env-new-var! env* name #f)))

    (search-vars (env-vars-ref env*))))

(define (env-global-variables env)
  (env-vars-ref (env-global-env env)))

(define (env-global-env env)
  (let loop ((env env))
    (let ((env* (env-parent-ref env)))
      (if env*
          (loop env*)
          env))))

(define (env-lookup-macro env name)
  (env-lookup env name #f
              (lambda (env name x)
                (if (or (not x) (var? x)) #f x))))


;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;;; Declarations

;; A declaration has the form: (##declare <item1> <item2> ...)
;;
;; an <item> can be one of 5 types:
;;
;; - flag declaration           : (<id>)
;; - parameterized declaration  : (<id> <exact-integer>)
;; - boolean declaration        : (<id>)  or  (NOT <id>)
;; - namable declaration        : (<id> <name>...)
;; - namable boolean declaration: (<id> <name>...)  or  (NOT <id> <name>...)

;; Declarations table (for parsing):

(define flag-declarations            '())
(define parameterized-declarations   '())
(define boolean-declarations         '())
(define namable-declarations         '())
(define namable-boolean-declarations '())

(define (define-flag-decl name type)
  (set! flag-declarations (cons (cons name type) flag-declarations))
  '())

(define (define-parameterized-decl name)
  (set! parameterized-declarations (cons name parameterized-declarations))
  '())

(define (define-boolean-decl name)
  (set! boolean-declarations (cons name boolean-declarations))
  '())

(define (define-namable-decl name type)
  (set! namable-declarations (cons (cons name type) namable-declarations))
  '())

(define (define-namable-boolean-decl name)
  (set! namable-boolean-declarations (cons name namable-boolean-declarations))
  '())

;; Declaration constructors:

(define (flag-decl source type val)
  (list type val))

(define (parameterized-decl source id parm)
  (list id parm))

(define (boolean-decl source id pos)
  (list id pos))

(define (namable-decl source type val names)
  (cons type (cons val names)))

(define (namable-boolean-decl source id pos names)
  (cons id (cons pos names)))

;; Declaration querying:

(define (declaration-value name element default env)
  (let loop ((lst (env-decl-ref env)))
    (if (pair? lst)
        (let ((d (car lst)))
          (if (and (eq? (car d) name)
                   (or (null? (cddr d)) (memq element (cddr d))))
              (cadr d)
              (loop (cdr lst))))
        default)))


;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (env.begin!)                    ; initialize module
  (set! next-var-stamp (make-counter 0))
  (set! ret-var (make-temp-var 'ret))
  (set! ret-var-set (varset-singleton ret-var))
  (set! closure-env-var (make-temp-var 'closure-env))
  (set! empty-var (make-temp-var #f))
  '())

(define (env.end!)                      ; finalize module
  (set! next-var-stamp '())
  (set! ret-var '())
  (set! ret-var-set '())
  (set! closure-env-var '())
  (set! empty-var '())
  '())


;;;============================================================================
