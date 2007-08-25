;;;============================================================================

;;; File: "_eval.scm", Time-stamp: <2007-08-19 22:39:04 feeley>

;;; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "header.scm")

;;(##define-macro (macro-step! leapable? handler-index vars . body) `(let () ,@body)) ;; disable single-stepping

;;;============================================================================

;;; Implementation of exceptions.

(implement-library-type-expression-parsing-exception)

(define-prim (##raise-expression-parsing-exception kind source . parameters)
  (macro-raise
   (macro-make-expression-parsing-exception kind source parameters)))

(implement-library-type-unbound-global-exception)

(define-prim (##raise-unbound-global-exception code rte variable)
  (macro-raise (macro-make-unbound-global-exception code rte variable)))

;;;----------------------------------------------------------------------------

(define (##make-code* code-prc cte src stepper lst n)
  (let ((code (##make-vector (##fixnum.+ (##length lst) (##fixnum.+ n 5)) #f)))
    (##vector-set! code 0 #f)
    (##vector-set! code 1 code-prc)
    (##vector-set! code 2 cte)
    (##vector-set! code 3 src)
    (##vector-set! code 4 stepper)
    (let loop ((i 0) (l lst))
      (if (##pair? l)
        (let ((child (##car l)))
          (##vector-set! child 0 code)
          (macro-code-set! code i child)
          (loop (##fixnum.+ i 1) (##cdr l)))
        code))))

(define (##no-stepper) (macro-make-no-stepper))

(define ##main-stepper (##no-stepper))
(set! ##main-stepper ##main-stepper)

(define (##current-stepper) ##main-stepper)

;;;----------------------------------------------------------------------------

;;; Structure representing source code.

(define ##source1-marker '#(source1)) ;; source markers
(define ##source2-marker '#(source2))

(define (##make-source code locat)
  (##vector ##source1-marker
            code
            (if locat (##locat-container locat) #f)
            (if locat (##locat-position locat) #f)))

(define (##sourcify x src)
  (if (##source? x)
    x
    (##vector ##source2-marker
              x
              (##vector-ref src 2)
              (##vector-ref src 3))))

(define (##source? x)
  (and (##vector? x)
       (##fixnum.< 0 (##vector-length x))
       (let ((y (##vector-ref x 0)))
         (and (##vector? y)
              (##fixnum.= 1 (##vector-length y))
              (let ((z (##vector-ref y 0)))
                (or (##eq? z 'source1)
                    (##eq? z 'source2)))))))

(define (##source-code src)
  (##vector-ref src 1))

(define (##source-locat src)
  (let ((container (##vector-ref src 2)))
    (if container
      (##make-locat container
                    (##vector-ref src 3))
      #f)))

(define (##desourcify src)

  (define (desourcify-list lst)
    (cond ((##pair? lst)
           (##cons (##desourcify (##car lst))
                   (desourcify-list (##cdr lst))))
          ((##null? lst)
           '())
          (else
           (##desourcify lst))))

  (define (desourcify-vector vect)
    (let* ((len (##vector-length vect))
           (x (##make-vector len 0)))
      (let loop ((i (##fixnum.- len 1)))
        (if (##fixnum.< i 0)
          x
          (begin
            (##vector-set! x i (##desourcify (##vector-ref vect i)))
            (loop (##fixnum.- i 1)))))))

  (if (##source? src)
    (let ((code (##source-code src)))
      (if (##eq? (##vector-ref src 0) ##source2-marker)
        code
        (cond ((##pair? code)
               (desourcify-list code))
              ((##vector? code)
               (desourcify-vector code))
              ((##box? code)
               (##box (##desourcify (##unbox code))))
              (else
               code))))
    src))

(define (##make-alias-syntax alias)
  (lambda (src)
    (let ((locat (##source-locat src)))
      (##make-source
       (##cons (##make-source alias locat)
               (##cdr (##source-code src)))
       locat))))

;;;----------------------------------------------------------------------------

;; A "locat" object represents a source code location.  The location is
;; a pair composed of the container of the source code (a file, a text
;; editor window, etc) and a position within that container (a
;; character offset, a line/column index, a text bookmark, an
;; expression, etc).
;;
;; Source code location containers and positions can be encoded with
;; any concrete type, except that positions cannot be pairs.  The
;; procedure "##container->file" takes a container object and returns
;; #f if the container does not denote a file, otherwise it returns the
;; absolute path of the file as a string.  The procedure
;; "##container->id" takes a container object and returns a string that
;; can be used to identify the container when it is not a file
;; (e.g. the name of a text editor window).  The procedure
;; "##position->filepos" takes a position object and returns a fixnum
;; encoding the line and column position (see function ##make-filepos).

(define-prim (##make-locat-from-readenv re)
  (##make-locat (##make-container-from-port-name
                 (##port-name (macro-readenv-port re)))
                (##make-position-from-filepos
                 (macro-readenv-filepos re))))

(define-prim (##make-locat container position)
  (##vector container position))

(define-prim (##locat? x)
  (##vector? x))

(define-prim (##locat-container locat)
  (let ((container (##vector-ref locat 0)))
    (if (##source? container)
      (##locat-container (##source-locat container))
      container)))

(define-prim (##locat-position locat)
  (let ((container (##vector-ref locat 0)))
    (if (##source? container)
      (##locat-position (##source-locat container))
      (##vector-ref locat 1))))

(define-prim (##container->file container)
  (cond ((##string? container)
         container)
        (else
         #f)))

(define-prim (##container->id container)
  (##object->string container))

(define-prim (##position->filepos position)
  (cond ((##fixnum? position)
         position)
        (else
         0)))

(define-prim (##make-container-from-port-name port-name)
  port-name)

(define-prim (##make-container-from-path path)
  path)

(define-prim (##make-position-from-filepos filepos)
  filepos)

;;;============================================================================

;;; Compiler

;;;----------------------------------------------------------------------------

;;; Compile time environments

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of local variables (up and over) and global variables.

(##define-macro (mk-loc-access up over) `(##cons ,up ,over))
(##define-macro (loc-access? x) `(##pair? ,x))
(##define-macro (loc-access-up x) `(##car ,x))
(##define-macro (loc-access-over x) `(##cdr ,x))

(##define-macro (mk-glo-access src id)
  `(##make-global-var ,id))

(##define-macro (glo-access? x)
  `(##not (##pair? ,x)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of compile time environments

;; There are 4 types of structures in a compile time environment:
;;
;;    top        end of the environment and container for current state
;;    frame      binding context for variables
;;    macro      binding context for a macro
;;    namespace  binding context for a namespace

(define (##cte-top top-cte)
  (##vector top-cte))

(define (##cte-top? cte)
  (##fixnum.= (##vector-length cte) 1))

(define (##cte-top-cte cte)
  (##vector-ref cte 0))

(define (##cte-top-cte-set! cte new-cte)
  (##vector-set! cte 0 new-cte))

(define (##cte-parent-cte cte)
  (##vector-ref cte 0))

(define (##cte-frame parent-cte vars)
  (##vector parent-cte vars))

(define (##cte-frame? cte)
  (##fixnum.= (##vector-length cte) 2))

(define (##cte-frame-vars cte)
  (##vector-ref cte 1))

(define (##cte-macro parent-cte name descr)
  (##vector parent-cte name descr))

(define (##cte-macro? cte)
  (and (##fixnum.= (##vector-length cte) 3)
       (##not (##string? (##vector-ref cte 1))))) ;; distinguish from namespace

(define (##cte-macro-name cte)
  (##vector-ref cte 1))

(define (##cte-macro-descr cte)
  (##vector-ref cte 2))

(define (##cte-namespace parent-cte prefix vars)
  (##vector parent-cte prefix vars))

(define (##cte-namespace? cte)
  (and (##fixnum.= (##vector-length cte) 3)
       (##string? (##vector-ref cte 1)))) ;; distinguish from macro

(define (##cte-namespace-prefix cte)
  (##vector-ref cte 1))

(define (##cte-namespace-vars cte)
  (##vector-ref cte 2))

(define (##cte-relink cte new-parent-cte)
  (if new-parent-cte
    (cond ((##cte-frame? cte)
           (##cte-frame new-parent-cte
                        (##cte-frame-vars cte)))
          ((##cte-macro? cte)
           (##cte-macro new-parent-cte
                        (##cte-macro-name cte)
                        (##cte-macro-descr cte)))
          ((##cte-namespace? cte)
           (##cte-namespace new-parent-cte
                            (##cte-namespace-prefix cte)
                            (##cte-namespace-vars cte))))
    #f))

(define (##cte-add-macro parent-cte name descr)

  (define (replace cte)
    (cond ((##cte-top? cte)
           (##cte-macro cte name descr))
          ((and (##cte-macro? cte) (##eq? name (##cte-macro-name cte)))
           (##cte-macro (##cte-parent-cte cte) name descr))
          (else
           (##cte-relink cte (replace (##cte-parent-cte cte))))))

  (replace parent-cte))

(define (##cte-add-namespace parent-cte prefix vars)

  (define (replace cte)
    (cond ((##cte-top? cte)
           #f)
          ((##cte-namespace? cte)
           (if (##pair? (##cte-namespace-vars cte))
             (replace (##cte-parent-cte cte))
             (##cte-namespace (##cte-parent-cte cte) prefix vars)))
          (else
           #f))) ;; don't go beyond a frame or macro definition

  (if (##pair? vars)
    (##cte-namespace parent-cte prefix vars)
    (or (replace parent-cte)
        (##cte-namespace parent-cte prefix vars))))

(define (##check-namespace src)
  (let ((code (##source-code src)))
    (let loop1 ((forms (##cdr code)))
      (cond ((##pair? forms)
             (let* ((form-src (##sourcify (##car forms) src))
                    (form (##source-code form-src)))
               (if (##pair? form)
                 (let* ((space-src (##sourcify (##car form) form-src))
                        (space (##source-code space-src)))
                   (if (##string? space)
                     (if (##valid-prefix? space)
                       (let loop2 ((lst (##cdr form)))
                         (cond ((##pair? lst)
                                (let* ((id-src
                                        (##sourcify (##car lst) form-src))
                                       (id
                                        (##source-code id-src)))
                                  (if (##not (##symbol? id))
                                    (##raise-expression-parsing-exception
                                     'id-expected
                                     id-src))
                                  (loop2 (##cdr lst))))
                               ((##not (##null? lst))
                                (##raise-expression-parsing-exception
                                 'ill-formed-namespace
                                 form-src))
                               (else
                                (loop1 (##cdr forms)))))
                         (##raise-expression-parsing-exception
                          'ill-formed-namespace-prefix
                          space-src))
                       (##raise-expression-parsing-exception
                        'namespace-prefix-must-be-string
                        space-src)))
                   (##raise-expression-parsing-exception
                    'ill-formed-namespace
                    form-src))))
            ((##not (##null? forms))
             (##raise-expression-parsing-exception
              'ill-formed-namespace
              src))))))

(define (##cte-process-declare parent-cte src)
  parent-cte) ;; simply ignore ##declare

(define (##cte-process-namespace parent-cte src)
  (##check-namespace src)
  (let ((forms (##cdr (##desourcify src))))
    (let loop ((cte parent-cte) (forms forms))
      (if (##pair? forms)
        (let ((form (##car forms)))
          (loop (##cte-add-namespace cte (##car form) (##cdr form))
                (##cdr forms)))
        cte))))

(define (##cte-get-top-cte cte)
  (if (##cte-top? cte)
    cte
    (##cte-get-top-cte (##cte-parent-cte cte))))

(define (##cte-mutate-top-cte! cte proc)
  (let ((top-cte (##cte-get-top-cte cte)))
    (##cte-top-cte-set! top-cte (proc (##cte-top-cte top-cte)))))

(define (##make-top-cte)
  (let ((top-cte (##cte-top #f)))
    (##cte-top-cte-set! top-cte top-cte)
    top-cte))

(define (##top-cte-add-macro! top-cte name def)
  (let ((global-name (##cte-global-macro-name (##cte-top-cte top-cte) name)))
    (##cte-mutate-top-cte!
      top-cte
      (lambda (cte) (##cte-add-macro cte global-name def)))))

(define (##top-cte-process-declare! top-cte src)
  (##cte-mutate-top-cte!
    top-cte
    (lambda (cte) (##cte-process-declare cte src))))

(define (##top-cte-process-namespace! top-cte src)
  (##cte-mutate-top-cte!
    top-cte
    (lambda (cte) (##cte-process-namespace cte src))))

(define (##top-cte-clone top-cte)
  (let ((new-top-cte (##cte-top #f)))

    (define (clone cte)
      (if (##cte-top? cte)
        new-top-cte
        (##cte-relink cte (clone (##cte-parent-cte cte)))))

    (##cte-top-cte-set! new-top-cte (clone (##cte-top-cte top-cte)))
    new-top-cte))

(define (##cte-lookup cte name)
  (##declare (inlining-limit 500)) ;; inline CTE access procedures
  (let loop ((name name) (full? (##full-name? name)) (cte cte) (up 0))
    (if (##cte-top? cte)
      (##vector 'not-found name)
      (let ((parent-cte (##cte-parent-cte cte)))
        (cond ((##cte-frame? cte)
               (let* ((vars (##cte-frame-vars cte))
                      (x (##memq name vars)))
                 (if x
                   (##vector
                     'var
                     name
                     up
                     (##fixnum.+ (##fixnum.- (##length vars) (##length x)) 1))
                   (loop name full? parent-cte (##fixnum.+ up 1)))))
              ((##cte-macro? cte)
               (if (##eq? name (##cte-macro-name cte))
                 (##vector 'macro name (##cte-macro-descr cte))
                 (loop name full? parent-cte up)))
              ((and (##not full?) (##cte-namespace? cte))
               (let ((vars (##cte-namespace-vars cte)))
                 (if (or (##not (##pair? vars)) (##memq name vars))
                   (loop (##make-full-name (##cte-namespace-prefix cte) name)
                         #t
                         parent-cte
                         up)
                   (loop name full? parent-cte up))))
              (else
               (loop name full? parent-cte up)))))))

(define (##cte-global-macro-name cte name)
  (if (##full-name? name)
    name
    (let loop ((cte cte))
      (if (##cte-top? cte)
        name
        (let ((parent-cte (##cte-parent-cte cte)))
          (cond ((##cte-namespace? cte)
                 (let ((vars (##cte-namespace-vars cte)))
                   (if (or (##not (##pair? vars)) (##memq name vars))
                     (##make-full-name (##cte-namespace-prefix cte) name)
                     (loop parent-cte))))
                (else
                 (loop parent-cte))))))))

(define ##namespace-separators '(#\#))
(set! ##namespace-separators ##namespace-separators)

(define (##full-name? sym) ;; full name if it contains a namespace separator
  (let ((str (##symbol->string sym)))
    (let loop ((i (##fixnum.- (##string-length str) 1)))
      (if (##fixnum.< i 0)
        #f
        (if (##memq (##string-ref str i) ##namespace-separators)
          #t
          (loop (##fixnum.- i 1)))))))

(define (##make-full-name prefix sym)
  (if (##fixnum.= (##string-length prefix) 0)
    sym
    (##string->symbol (##string-append prefix (##symbol->string sym)))))

(define (##valid-prefix? str)

  ;; non-null name followed by a namespace separator at end is
  ;; valid as is the special prefix ""

  (let ((l (##string-length str)))
    (or (##fixnum.= l 0)
        (and (##not (##fixnum.< l 2))
             (##memq (##string-ref str (##fixnum.- l 1))
                     ##namespace-separators)))))

(define (##var-lookup cte src)
  (let* ((name (##source-code src))
         (ind (##cte-lookup cte name)))
    (case (##vector-ref ind 0)
      ((not-found)
       (mk-glo-access src (##vector-ref ind 1)))
      ((var)
       (mk-loc-access (##vector-ref ind 2) (##vector-ref ind 3)))
      (else
       (##raise-expression-parsing-exception
        'macro-used-as-variable
        src
        name)))))

(define (##make-macro-descr def-syntax? size expander expander-src)
  (##vector def-syntax? size expander expander-src))

(define (##macro-descr-def-syntax? descr)
  (##vector-ref descr 0))

(define (##macro-descr-size descr)
  (##vector-ref descr 1))

(define (##macro-descr-expander descr)
  (##vector-ref descr 2))

(define (##macro-descr-expander-src descr)
  (##vector-ref descr 3))

(define ##macro-lookup #f)
(set! ##macro-lookup
  (lambda (cte name)
    (and (##symbol? name)
         (let ((ind (##cte-lookup cte name)))
           (case (##vector-ref ind 0)
             ((macro)
              (##vector-ref ind 2))
             (else
              #f))))))

(define ##macro-expand #f)
(set! ##macro-expand
  (lambda (cte src descr)
    (##shape src src (##macro-descr-size descr))
    (##sourcify
     (if (##macro-descr-def-syntax? descr)
         ((##macro-descr-expander descr) src)
         (##apply (##macro-descr-expander descr)
                  (##cdr (##desourcify src))))
     src)))

(define ##macro-descr #f)
(set! ##macro-descr
  (lambda (src def-syntax?)

    (define (err)
      (##raise-expression-parsing-exception
       'ill-formed-macro-transformer
       src))

    (define (make-descr size)
      (let ((expander (##eval-top src ##interaction-cte)))
        (if (##not (##procedure? expander))
          (err)
          (##make-macro-descr def-syntax? size expander src))))

    (if def-syntax?
      (make-descr -1)
      (let ((code (##source-code src)))
        (if (and (##pair? code)
                 (##memq (##source-code (##sourcify (##car code) src))
                         '(##lambda lambda)))
          (begin
            (##shape src src -3)
            (make-descr (##form-size (##sourcify (##cadr code) src))))
          (err))))))

(define (##form-size parms-src)
  (let ((parms (##source-code parms-src)))
    (let loop ((lst parms) (n 1))
      (cond ((##pair? lst)
             (let ((parm (##source-code (##sourcify (##car lst) parms-src))))
               (if (##memq parm '(#!optional #!key #!rest))
                 (##fixnum.- 0 n)
                 (loop (##cdr lst)
                       (##fixnum.+ n 1)))))
            ((##null? lst)
             n)
            (else
             (##fixnum.- 0 n))))))

(define ##interaction-cte
  (##make-top-cte))

;;;----------------------------------------------------------------------------

;;; Utilities

(define (##self-eval? val)
  (or (##complex? val)
      (##string? val)
      (##char? val)
      (##keyword? val)
      (##memq val
              '(#f
                #t
                #!eof
                #!void
                #!unbound
                #!unbound2
                #!optional
                #!key
                #!rest
                ))))

(define (##variable src)
  (let ((code (##source-code src)))
    (if (##not (##symbol? code))
      (##raise-expression-parsing-exception
       'id-expected
       src))))

(define (##shape src x size)
  (let* ((code (##source-code x))
         (n (##proper-length code)))
    (if (or (##not n)
            (if (##fixnum.< 0 size)
              (##not (##fixnum.= n size))
              (##fixnum.< n (##fixnum.- 0 size))))
      (##raise-expression-parsing-exception
       'ill-formed-special-form
       src
       (let* ((code (##source-code src))
              (head (##source-code (##sourcify (##car code) src)))
              (name (##symbol->string head))
              (len (##string-length name)))
         (if (and (##fixnum.< 2 len)
                  (##char=? #\# (##string-ref name 0))
                  (##char=? #\# (##string-ref name 1)))
           (##string->symbol (##substring name 2 len))
           head))))))

(define (##proper-length lst)
  (let loop ((lst lst) (n 0))
    (cond ((##pair? lst) (loop (##cdr lst) (##fixnum.+ n 1)))
          ((##null? lst) n)
          (else          #f))))

(define (##include-file-as-a-begin-expr src)
  (let* ((code (##source-code src))
         (filename-src (##sourcify (##cadr code) src))
         (filename (##source-code filename-src)))
    (if (##string? filename)

      (let* ((locat
              (##source-locat src))
             (relative-to-path
              (and locat
                   (##container->file (##locat-container locat)))))
        (let* ((path
                (##path-reference filename relative-to-path))
               (x
                (##read-all-as-a-begin-expr-from-path
                 path
                 (##current-readtable)
                 ##wrap-datum
                 ##unwrap-datum)))
          (if (##fixnum? x)
            (##raise-expression-parsing-exception
             'cannot-open-file
             src
             path)
            (##vector-ref x 1))))

      (##raise-expression-parsing-exception
       'filename-expected
       filename-src))))

;;;----------------------------------------------------------------------------

;;; Compiler's main entry

(define ##expand-source #f)
(set! ##expand-source
  (lambda (src)
    src))

(define (##compile-module top-cte src)
  (##with-compilation-scope
   top-cte
   src
   #f
   (lambda (cte src tail?)
     (let* ((lib+body
             (##extract-library src))
            (new-src
             (if lib+body
               (let* ((lib (##car lib+body))
                      (body (##cdr lib+body))
                      (new-lib (##generate-library-prelude lib)))
                 (##sourcify
                  (##cons (##sourcify '##begin src)
                          (##cons new-lib
                                  body))
                  src))
               src)))
       (let ((tail? #f))
         (##comp-top top-cte new-src tail?))))))

(define (##compile-top top-cte src)
  (##with-compilation-scope
   top-cte
   src
   #f
   (lambda (cte src tail?)
     (let ((tail? #f))
       (##comp-top top-cte src tail?)))))

(define (##compile-inner cte src)
  (##with-compilation-scope
   cte
   src
   #f
   (lambda (cte src tail?)
     (macro-gen ##gen-top src
       (##comp (##cte-frame cte (##list (macro-self-var))) src tail?)))))

(define (##convert-source-to-locat! code)

  (define (convert! container code)
    (let ((locat (##source-locat (macro-code-locat code)))) ;; get location
      (if (##locat? locat)
        (let ((new-container (##locat-container locat)))
          (if (##eq? container new-container)
            (convert2! container (##locat-position locat) code)
            (convert2! new-container locat code)))
        (convert2! container #f code))))

  (define (convert2! container locat-or-position code)
    (macro-code-locat-set! code locat-or-position)
    (let ((n (macro-code-length code)))
      (let loop ((i 0))
        (if (##fixnum.< i n)
          (let ((x (macro-code-ref code i)))
            (if (macro-is-child-code? x code)
              (begin
                (convert! container x)
                (loop (##fixnum.+ i 1)))))))))

  (convert! #f code)
  code)

(define ##compilation-scope
  (##make-parameter #f))

(define (##with-compilation-scope cte src tail? proc)
  (let* ((src
          (##expand-source src))
         (comp-scope
          (##vector '()))
         (code
          (##parameterize
           ##compilation-scope
           comp-scope
           (lambda ()
             (proc cte src tail?))))
         (imports
          (##reverse (##vector-ref comp-scope 0))))
    (##convert-source-to-locat!
     (if (##null? imports)
       code
       (macro-gen ##gen-require src
         code
         imports)))))

(define (##cte-process-import cte src)
  (let* ((code (##source-code src))
         (lib-name-src (##sourcify (##cadr code) src))
         (lib-name (##source-code lib-name-src))
         (include-file (##add-import-requirement lib-name)))
    (if include-file
      (##sourcify (##list (##sourcify '##include src)
                          (##sourcify include-file src))
                  src)
      (##sourcify (##list (##sourcify '##begin src))
                  src))))

(define ##add-import-requirement #f)
(set! ##add-import-requirement
      (lambda (lib-name)
        (let ((comp-scope (##compilation-scope)))
          (##vector-set!
           comp-scope
           0
           (##cons lib-name
                   (##vector-ref comp-scope 0)))
          #f)))

(define ##fulfill-requirements #f)
(set! ##fulfill-requirements
      (lambda (requirements)
        (##pretty-print (##cons requirements: requirements)
                        ##stdout-port)))

(define (##extract-library expr)
  #f #; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (let* ((src (##sourcify expr (##make-source #f #f)))
         (code (##source-code src)))
    (and (##pair? code)
         (let* ((h-src (##sourcify (##car code) src))
                (h (##source-code h-src)))
           (and (##eq? h '##begin)
                (##pair? (##cdr code))
                (let* ((lib-src (##sourcify (##cadr code) src))
                       (lib (##source-code lib-src)))
                  (and (##pair? lib)
                       (let* ((libh-src (##sourcify (##car lib) src))
                              (libh (##source-code libh-src)))
                         (and (or (##eq? libh 'library)
                                  (##eq? libh '##library))
                              (begin
                                (##shape lib-src lib-src -3)
                                (cond ((##null? (##cdddr lib))
                                       (##cons lib-src
                                               (##cddr code)))
                                      ((##null? (##cddr code))
                                       (##cons lib-src
                                               (##cdddr lib)))
                                      (else
                                       (##raise-expression-parsing-exception
                                        'ill-placed-library
                                        lib-src)))))))))))))

(define ##generate-library-prelude #f)
(set! ##generate-library-prelude
      (lambda (lib)
        lib))

;;;----------------------------------------------------------------------------

(define (##comp-top top-cte src tail?)
  (let ((code (##source-code src))
        (cte (##cte-top-cte top-cte)))
    (if (##pair? code)
      (let* ((first-src (##sourcify (##car code) src))
             (first (##source-code first-src))
             (descr (##macro-lookup cte first)))
        (if descr
          (##comp-top top-cte (##macro-expand cte src descr) tail?)
          (case first
            ((##begin)           (##comp-top-begin top-cte src tail?))
            ((##define)          (##comp-top-define top-cte src tail?))
            ((##define-macro)    (##comp-top-define-macro top-cte src tail?))
            ((##define-syntax)   (##comp-top-define-syntax top-cte src tail?))
            ((##include)         (##comp-top-include top-cte src tail?))
            ((##declare)         (##comp-top-declare top-cte src tail?))
            ((##namespace)       (##comp-top-namespace top-cte src tail?))
;;            ((library ##library) (##comp-top-library top-cte src tail?))
;;            ((export ##export)   (##comp-top-export top-cte src tail?))
;;            ((import ##import)   (##comp-top-import top-cte src tail?))
            (else                (##comp-aux cte src tail? first)))))
      (##comp-simple cte src tail?))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-top-begin top-cte src tail?)
  (##shape src src -1)
  (let ((code (##source-code src)))
    (##comp-top-seq top-cte src tail? (##cdr code))))

(define (##comp-top-seq top-cte src tail? seq)
  (if (##pair? seq)
    (##comp-top-seq-aux top-cte src tail? seq)
    (let ((cte (##cte-top-cte top-cte)))
      (macro-gen ##gen-cst-no-step src
        (##void)))))

(define (##comp-top-seq-aux top-cte src tail? seq)
  (let ((first-src (##sourcify (##car seq) src))
        (rest (##cdr seq)))
    (if (##pair? rest)
      (let ((cte (##cte-top-cte top-cte)))
        (macro-gen ##gen-seq first-src
          (##comp-top top-cte first-src #f)
          (##comp-top-seq-aux top-cte src tail? rest)))
      (##comp-top top-cte first-src tail?))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-top-define top-cte src tail?)
  (let ((name (##definition-name src)))
    (##variable name)
    (let* ((cte (##cte-top-cte top-cte))
           (ind (##var-lookup cte name))
           (val (##definition-value src)))
      (macro-gen ##gen-glo-def src
        ind
        (##comp cte val #f)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-top-include top-cte src tail?)
  (##shape src src 2)
  (##comp-top top-cte
              (##include-file-as-a-begin-expr src)
              tail?))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-top-define-macro top-cte src tail?)
  (##comp-top-define-macro-or-syntax top-cte src tail? #f))

(define (##comp-top-define-syntax top-cte src tail?)
  (##comp-top-define-macro-or-syntax top-cte src tail? #t))

(define (##comp-top-define-macro-or-syntax top-cte src tail? def-syntax?)
  (let* ((cte (##cte-top-cte top-cte))
         (name (##definition-name src))
         (val (##definition-value src)))
    (##top-cte-add-macro!
     top-cte
     (##source-code name)
     (##macro-descr val def-syntax?))
    (macro-gen ##gen-cst-no-step src
      (##void))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-top-declare top-cte src tail?)
  (##shape src src -1)
  (let ((cte (##cte-top-cte top-cte)))
    (##top-cte-process-declare! top-cte src)
    (macro-gen ##gen-cst-no-step src
      (##void))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-top-namespace top-cte src tail?)
  (##shape src src -1)
  (let ((cte (##cte-top-cte top-cte)))
    (##top-cte-process-namespace! top-cte src)
    (macro-gen ##gen-cst-no-step src
      (##void))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-top-library top-cte src tail?)

  ;; The library form is handled specially because it must be the only
  ;; form in the module.

  (##raise-expression-parsing-exception
   'ill-placed-library
   src))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-top-export top-cte src tail?)
  (##shape src src -2)
  #f);;;;;;;;;;;;;;;;;;;;;;;

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-top-import top-cte src tail?)
  (##shape src src 2)
  (##comp-top top-cte
              (##cte-process-import top-cte src)
              tail?))

;;;----------------------------------------------------------------------------

(define (##comp cte src tail?)
  (let ((code (##source-code src)))
    (if (##pair? code)
      (let* ((first-src (##sourcify (##car code) src))
             (first (##source-code first-src))
             (descr (##macro-lookup cte first)))
        (if descr
          (##comp cte (##macro-expand cte src descr) tail?)
          (case first
            ((##begin)
             (##comp-begin cte src tail?))
            ((##define)
             (##raise-expression-parsing-exception
              'ill-placed-define
              src))
            ((##define-macro)
             (##raise-expression-parsing-exception
              'ill-placed-define-macro
              src))
            ((##define-syntax)
             (##raise-expression-parsing-exception
              'ill-placed-define-syntax
              src))
            ((##include)
             (##raise-expression-parsing-exception
              'ill-placed-include
              src))
            ((##declare)
             (##raise-expression-parsing-exception
              'ill-placed-declare
              src))
            ((##namespace)
             (##raise-expression-parsing-exception
              'ill-placed-namespace
              src))
;;            ((library ##library)
;;             (##raise-expression-parsing-exception
;;              'ill-placed-library
;;              src))
;;            ((export ##export)
;;             (##raise-expression-parsing-exception
;;              'ill-placed-export
;;              src))
;;            ((import ##import)
;;             (##raise-expression-parsing-exception
;;              'ill-placed-import
;;              src))
            (else
             (##comp-aux cte src tail? first)))))
      (##comp-simple cte src tail?))))

(define (##comp-simple cte src tail?)
  (let ((code (##source-code src)))
    (cond ((##symbol? code)
           (##comp-ref cte src tail?))
          ((##self-eval? code)
           (##comp-cst cte src tail?))
          (else
           (##raise-expression-parsing-exception
            'ill-formed-expression
            src)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-begin cte src tail?)
  (##shape src src -2)
  (let ((code (##source-code src)))
    (##comp-seq cte src tail? (##cdr code))))

(define (##comp-seq cte src tail? seq)
  (if (##pair? seq)
    (##comp-seq-aux cte src tail? seq)
    (macro-gen ##gen-cst-no-step src
      (##void))))

(define (##comp-seq-aux cte src tail? seq)
  (let ((first-src (##sourcify (##car seq) src))
        (rest (##cdr seq)))
    (if (##pair? rest)
      (let ((code (##source-code first-src)))
        (macro-gen ##gen-seq first-src
          (##comp cte first-src #f)
          (##comp-seq-aux cte src tail? rest)))
      (##comp cte first-src tail?))))

;;;----------------------------------------------------------------------------

(define (##comp-aux cte src tail? first)

  (define (unsupported)
    (##raise-expression-parsing-exception
     'unsupported-special-form
     src
     first))

  (case first
    ((##quote)
     (##comp-quote cte src tail?))
    ((##quasiquote)
     (##comp-quasiquote cte src tail?))
    ((##set!)
     (##comp-set! cte src tail?))
    ((##lambda)
     (##comp-lambda cte src tail?))
    ((##if)
     (##comp-if cte src tail?))
    ((##cond)
     (##comp-cond cte src tail?))
    ((##and)
     (##comp-and cte src tail?))
    ((##or)
     (##comp-or cte src tail?))
    ((##case)
     (##comp-case cte src tail?))
    ((##let)
     (##comp-let cte src tail?))
    ((##let*)
     (##comp-let* cte src tail?))
    ((##letrec)
     (##comp-letrec cte src tail?))
    ((##do)
     (##comp-do cte src tail?))
    ((##delay)
     (##comp-delay cte src tail?))
    ((##future)
     (##comp-future cte src tail?))
    ((##c-define-type)
     (unsupported))
    ((##c-declare)
     (unsupported))
    ((##c-initialize)
     (unsupported))
    ((##c-lambda)
     (unsupported))
    ((##c-define)
     (unsupported))
    ((##this-source-file)
     (##comp-this-source-file cte src tail?))
    (else
     (##comp-app cte src tail?))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-ref cte src tail?)
  (##variable src)
  (let ((x (##var-lookup cte src)))
    (if (loc-access? x)
      (let ((up (loc-access-up x))
            (over (loc-access-over x)))
        (macro-gen ##gen-loc-ref src
          up
          over))
      (macro-gen ##gen-glo-ref src
        x))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-cst cte src tail?)
  (macro-gen ##gen-cst src
    (##desourcify src)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-quote cte src tail?)
  (##shape src src 2)
  (let ((code (##source-code src)))
    (macro-gen ##gen-cst src
      (##desourcify (##cadr code)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-quasiquote cte src tail?)
  (##shape src src 2)
  (let ((code (##source-code src)))
    (##comp-template cte
                     src
                     tail?
                     (##sourcify (##cadr code) src)
                     1)))

;;*********************** fix me

(define (##comp-template cte src tail? form-src depth)
  (let ((form (##source-code form-src)))
    (cond ((##pair? form)
           (##comp-list-template cte
                                 src
                                 tail?
                                 form
                                 depth))
          ((##vector? form)
           (macro-gen ##gen-quasi-list->vector src
             (##comp-list-template cte
                                   src
                                   #f
                                   (##vector->list form)
                                   depth)))
          (else
           (macro-gen ##gen-cst-no-step src
             (##desourcify form-src))))))

(define (##comp-list-template cte src tail? lst depth)
  (cond ((##pair? lst)
         (let* ((first-src (##sourcify (##car lst) src))
                (first (##source-code first-src)))

           (define (non-special-list)
             (if (and (##pair? first)
                      (##eq? (##source-code
                              (##sourcify (##car first) first-src))
                             'unquote-splicing)
                      (##pair? (##cdr first)) ;; proper list of length 2?
                      (##null? (##cddr first)))
               (if (##eq? depth 1)
                 (let ((second-src (##sourcify (##cadr first) src)))
                   (if (##null? (##cdr lst))
                     (##comp cte second-src tail?)
                     (macro-gen ##gen-quasi-append src
                       (##comp cte second-src #f)
                       (##comp-list-template cte
                                             src
                                             #f
                                             (##cdr lst)
                                             depth))))
                 (macro-gen ##gen-quasi-cons src
                   (##comp-template cte
                                    src
                                    #f
                                    first-src
                                    (##fixnum.- depth 1))
                   (##comp-list-template cte
                                         src
                                         #f
                                         (##cdr lst)
                                         depth)))
               (macro-gen ##gen-quasi-cons src
                 (##comp-template cte
                                  src
                                  #f
                                  first-src
                                  depth)
                 (##comp-list-template cte
                                       src
                                       #f
                                       (##cdr lst)
                                       depth))))

           (if (and (##pair? (##cdr lst)) ;; proper list of length 2?
                    (##null? (##cddr lst)))
             (case first
               ((quasiquote)
                (macro-gen ##gen-quasi-cons src
                  (macro-gen ##gen-cst-no-step first-src
                    first)
                  (##comp-list-template cte
                                        src
                                        #f
                                        (##cdr lst)
                                        (##fixnum.+ depth 1))))
               ((unquote)
                (if (##eq? depth 1)
                  (##comp cte (##sourcify (##cadr lst) first-src) tail?)
                  (macro-gen ##gen-quasi-cons src
                    (macro-gen ##gen-cst-no-step first-src
                      first)
                    (##comp-list-template cte
                                          src
                                          #f
                                          (##cdr lst)
                                          (##fixnum.- depth 1)))))
               (else
                (non-special-list)))
             (non-special-list))))

         ((##null? lst)
          (macro-gen ##gen-cst-no-step src
            '()))

         (else
          (##comp-template cte
                           src
                           tail?
                           (##sourcify lst src)
                           depth))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-set! cte src tail?)
  (##shape src src 3)
  (let* ((code (##source-code src))
         (var-src (##sourcify (##cadr code) src))
         (val-src (##sourcify (##caddr code) src)))
    (##variable var-src)
    (let ((x (##var-lookup cte var-src)))
      (if (loc-access? x)
        (let ((up (loc-access-up x))
              (over (loc-access-over x)))
          (macro-gen ##gen-loc-set src
            up
            over
            (##comp cte val-src #f)))
        (macro-gen ##gen-glo-set src
          x
          (##comp cte val-src #f))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-lambda cte src tail?)
  (##shape src src -3)
  (let* ((code (##source-code src))
         (parms-src (##sourcify (##cadr code) src))
         (body (##cddr code)))
    (##comp-lambda-aux cte src tail? parms-src body)))

(define (##comp-lambda-aux cte src tail? parms-src body)
  (let* ((all-parms
          (##extract-parameters src parms-src))
         (required-parameters
          (##vector-ref all-parms 0))
         (optional-parameters
          (##vector-ref all-parms 1))
         (rest-parameter
          (##vector-ref all-parms 2))
         (dsssl-style-rest?
          (##vector-ref all-parms 3))
         (key-parameters
          (##vector-ref all-parms 4)))
    (let loop1 ((frame required-parameters)
                (lst (or optional-parameters '()))
                (rev-inits '()))
      (if (##pair? lst)
        (let ((x (##car lst))
              (new-cte (##cte-frame cte (##cons (macro-self-var) frame))))
          (loop1 (##append frame (##list (##car x)))
                 (##cdr lst)
                 (##cons (##comp new-cte (##cdr x) #f)
                         rev-inits)))
        (let loop2 ((frame (if (and rest-parameter dsssl-style-rest?)
                             (##append frame (##list rest-parameter))
                             frame))
                    (lst (or key-parameters '()))
                    (rev-inits rev-inits)
                    (rev-keys '()))
          (if (##pair? lst)
            (let ((x (##car lst))
                  (new-cte (##cte-frame cte (##cons (macro-self-var) frame))))
              (loop2 (##append frame (##list (##car x)))
                     (##cdr lst)
                     (##cons (##comp new-cte (##cdr x) #f)
                             rev-inits)
                     (##cons (##string->keyword (##symbol->string (##car x)))
                             rev-keys)))
            (let* ((frame (if (and rest-parameter (not dsssl-style-rest?))
                            (##append frame (##list rest-parameter))
                            frame))
                   (new-cte (##cte-frame cte (##cons (macro-self-var) frame)))
                   (c (##comp-body new-cte src #t body)))
              (cond ((or optional-parameters key-parameters)
                     (macro-gen ##gen-prc src
                       frame
                       (and rest-parameter (if dsssl-style-rest? 'dsssl #t))
                       (and key-parameters
                            (##list->vector (##reverse rev-keys)))
                       c
                       (##reverse rev-inits)))
                    (rest-parameter
                     (macro-gen ##gen-prc-rest src
                       frame
                       c))
                    (else
                     (macro-gen ##gen-prc-req src
                       frame
                       c))))))))))

(define (##extract-parameters src parms-src)

  (define (parm-expected-err src)
    (##raise-expression-parsing-exception
     'parameter-must-be-id
     src))

  (define (parm-or-default-binding-expected-err src)
    (##raise-expression-parsing-exception
     'parameter-must-be-id-or-default
     src))

  (define (duplicate-parm-err src)
    (##raise-expression-parsing-exception
     'duplicate-parameter
     src))

  (define (duplicate-rest-parm-err src)
    (##raise-expression-parsing-exception
     'duplicate-rest-parameter
     src))

  (define (rest-parm-expected-err src)
    (##raise-expression-parsing-exception
     'parameter-expected-after-rest
     src))

  (define (rest-parm-must-be-last-err src)
    (##raise-expression-parsing-exception
     'rest-parm-must-be-last
     src))

  (define (default-binding-err src)
    (##raise-expression-parsing-exception
     'ill-formed-default
     src))

  (define (optional-illegal-err src)
    (##raise-expression-parsing-exception
     'ill-placed-optional
     src))

  (define (key-illegal-err src)
    (##raise-expression-parsing-exception
     'ill-placed-key
     src))

  (define (key-expected-err src)
    (##raise-expression-parsing-exception
     'key-expected-after-rest
     src))

  (define (default-binding-illegal-err src)
    (##raise-expression-parsing-exception
     'ill-placed-default
     src))

  (let loop ((lst (##source->parms parms-src))
             (rev-required-parms '())
             (rev-optional-parms #f)
             (rest-parm #f)
             (rev-key-parms #f)
             (state 1)) ;; 1 = required parms or #!optional/#!rest/#!key
                        ;; 2 = optional parms or #!rest/#!key
                        ;; 3 = #!key
                        ;; 4 = key parms (or #!rest if rest-parm=#f)

    (define (done rest-parm2)
      (##vector (##reverse rev-required-parms)
                (and rev-optional-parms (##reverse rev-optional-parms))
                rest-parm2
                (and rest-parm (##fixnum.= state 4))
                (if (or (##not rev-key-parms)
                        (and (##null? rev-key-parms) (##not rest-parm2)))
                  #f
                  (##reverse rev-key-parms))))

    (define (check-if-duplicate parm-src)
      (let ((parm (##source-code parm-src)))
        (if (or (##memq parm rev-required-parms)
                (and rev-optional-parms (##assq parm rev-optional-parms))
                (and rest-parm (##eq? parm rest-parm))
                (and rev-key-parms (##assq parm rev-key-parms)))
          (duplicate-parm-err parm-src))))

    (cond ((##null? lst)
           (done rest-parm))
          ((##pair? lst)
           (let* ((parm-src (##sourcify (##car lst) src))
                  (parm (##source-code parm-src)))
             (cond ((##eq? #!optional parm)
                    (if (##not (##fixnum.= 1 state))
                      (optional-illegal-err parm-src))
                    (loop (##cdr lst)
                          rev-required-parms
                          '()
                          rest-parm
                          rev-key-parms
                          2))
                   ((##eq? #!rest parm)
                    (if rest-parm
                      (duplicate-rest-parm-err parm-src))
                    (if (##pair? (##cdr lst))
                      (let* ((parm-src (##sourcify (##cadr lst) src))
                             (parm (##source-code parm-src)))
                        (##variable parm-src)
                        (check-if-duplicate parm-src)
                        (if (##fixnum.= state 4)
                          (if (##null? (##cddr lst))
                            (done parm)
                            (rest-parm-must-be-last-err parm-src))
                          (loop (##cddr lst)
                                rev-required-parms
                                rev-optional-parms
                                parm
                                rev-key-parms
                                3)))
                      (rest-parm-expected-err parm-src)))
                   ((##eq? #!key parm)
                    (if (##fixnum.= 4 state)
                      (key-illegal-err parm-src))
                    (loop (##cdr lst)
                          rev-required-parms
                          rev-optional-parms
                          rest-parm
                          '()
                          4))
                   ((##fixnum.= state 3)
                    (key-expected-err parm-src))
                   ((##symbol? parm)
                    (##variable parm-src)
                    (check-if-duplicate parm-src)
                    (case state
                      ((1)
                       (loop (##cdr lst)
                             (##cons parm
                                     rev-required-parms)
                             rev-optional-parms
                             rest-parm
                             rev-key-parms
                             state))
                      ((2)
                       (loop (##cdr lst)
                             rev-required-parms
                             (##cons (##cons parm
                                             (##sourcify #f parm-src))
                                     rev-optional-parms)
                             rest-parm
                             rev-key-parms
                             state))
                      (else
                       (loop (##cdr lst)
                             rev-required-parms
                             rev-optional-parms
                             rest-parm
                             (##cons (##cons parm
                                             (##sourcify #f parm-src))
                                     rev-key-parms)
                             state))))
                   ((##pair? parm)
                    (if (##not (or (##fixnum.= state 2) (##fixnum.= state 4)))
                      (default-binding-illegal-err parm-src))
                    (let ((len (##proper-length parm)))
                      (if (##not (##eq? len 2))
                        (default-binding-err parm-src)))
                    (let* ((val-src (##sourcify (##cadr parm) parm-src))
                           (parm-src (##sourcify (##car parm) parm-src))
                           (parm (##source-code parm-src)))
                      (##variable parm-src)
                      (check-if-duplicate parm-src)
                      (case state
                        ((2)
                         (loop (##cdr lst)
                               rev-required-parms
                               (##cons (##cons parm val-src)
                                       rev-optional-parms)
                               rest-parm
                               rev-key-parms
                               state))
                        (else
                         (loop (##cdr lst)
                               rev-required-parms
                               rev-optional-parms
                               rest-parm
                               (##cons (##cons parm val-src)
                                       rev-key-parms)
                               state)))))
                   (else
                    (if (##not (##fixnum.= 1 state))
                      (parm-or-default-binding-expected-err parm-src)
                      (parm-expected-err parm-src))))))
          (else
           (let ((parm-src (##sourcify lst src)))
             (##variable parm-src)
             (if rest-parm
               (duplicate-rest-parm-err parm-src))
             (check-if-duplicate parm-src)
             (done (##source-code parm-src)))))))

(define (##source->parms src)
  (let ((x (##source-code src)))
    (if (or (##pair? x) (##null? x)) x src)))

(define (##comp-body cte src tail? body)

  (define (letrec-defines cte rev-vars rev-vals body)
    (if (##pair? body)

      (let* ((src (##sourcify (##car body) src))
             (code (##source-code src)))
        (if (##not (##pair? code))
          (letrec-defines* cte rev-vars rev-vals body)
          (let* ((first-src (##sourcify (##car code) src))
                 (first (##source-code first-src))
                 (descr (##macro-lookup cte first)))
            (if descr
              (letrec-defines cte
                              rev-vars
                              rev-vals
                              (##cons
                               (##macro-expand cte src descr)
                               (##cdr body)))
              (case first
                ((##begin)
                 (##shape src src -1)
                 (letrec-defines cte
                                 rev-vars
                                 rev-vals
                                 (##append (##cdr code) (##cdr body))))
                ((##define)
                 (let* ((name-src (##definition-name src))
                        (name (##source-code name-src)))
                   (##variable name-src)
                   (if (##memq name rev-vars)
                     (##raise-expression-parsing-exception
                      'duplicate-variable-definition
                      name-src))
                   (let ((val (##definition-value src)))
                     (letrec-defines cte
                                     (##cons name rev-vars)
                                     (##cons val rev-vals)
                                     (##cdr body)))))
                ((##define-macro ##define-syntax)
                 (let* ((def-syntax? (##eq? first '##define-syntax))
                        (name-src (##definition-name src))
                        (name (##source-code name-src))
                        (val (##definition-value src)))
                   (letrec-defines (##cte-macro
                                    cte
                                    name
                                    (##macro-descr val def-syntax?))
                                   rev-vars
                                   rev-vals
                                   (##cdr body))))
                ((##include)
                 (##shape src src 2)
                 (letrec-defines cte
                                 rev-vars
                                 rev-vals
                                 (##cons
                                  (##include-file-as-a-begin-expr src)
                                  (##cdr body))))
                ((##declare)
                 (##shape src src -1)
                 (letrec-defines (##cte-process-declare cte src)
                                 rev-vars
                                 rev-vals
                                 (##cdr body)))
                ((##namespace)
                 (##shape src src -1)
                 (letrec-defines (##cte-process-namespace cte src)
                                 rev-vars
                                 rev-vals
                                 (##cdr body)))
;;                ((library ##library)
;;                 (##raise-expression-parsing-exception
;;                  'ill-placed-library
;;                  src))
;;                ((export ##export)
;;                 (##raise-expression-parsing-exception
;;                  'ill-placed-export
;;                  src))
;;                ((import ##import)
;;                 (##shape src src 2)
;;                 (letrec-defines cte
;;                                 rev-vars
;;                                 rev-vals
;;                                 (##cons (##cte-process-import cte src)
;;                                         (##cdr body))))
                (else
                 (letrec-defines* cte rev-vars rev-vals body)))))))

      (##raise-expression-parsing-exception
       'empty-body
       src)))

  (define (letrec-defines* cte rev-vars rev-vals body)
    (if (##null? rev-vars)
      (##comp-seq cte src tail? body)
      (##comp-letrec-aux cte
                         src
                         tail?
                         (##reverse rev-vars)
                         (##reverse rev-vals)
                         body)))

  (letrec-defines cte '() '() body))

(define (##definition-name src)
  (##shape src src -2)
  (let* ((code (##source-code src))
         (head-src (##sourcify (##car code) src))
         (head (##source-code head-src))
         (pattern-src (##sourcify (##cadr code) src))
         (pattern (##source-code pattern-src)))
    (##shape src
             src
             (cond ((and (##eq? head '##define)
                         (##not (##pair? pattern)))
                    (if (##not (##pair? (##cddr code)))
                      2
                      3))
                   ((or (##eq? head '##define-syntax)
                        (and (##eq? head '##define-macro)
                             (##not (##pair? pattern))))
                    3)
                   (else
                    -3)))
    (let* ((name-src
            (if (and (##not (##eq? head '##define-syntax))
                     (##pair? pattern))
              (##sourcify (##car pattern) src)
              pattern-src))
           (name
            (##source-code name-src)))
      (if (##not (##symbol? name))
        (##raise-expression-parsing-exception
         'id-expected
         name-src))
      name-src)))

(define (##definition-value src)
  (let* ((code (##source-code src))
         (pattern-src (##sourcify (##cadr code) src))
         (pattern (##source-code pattern-src))
         (locat (##source-locat src)))
    (cond ((##pair? pattern)
           (let ((parms (##cdr pattern)))
             (##make-source
              (##cons (##make-source '##lambda locat)
                      (##cons (if (##source? parms) ;; rest parameter?
                                parms
                                (##make-source parms locat))
                              (##cddr code)))
              locat)))
           ((##pair? (##cddr code))
            (##sourcify (##caddr code) src))
           (else
            (##make-source
             (##list (##make-source '##quote locat)
                     (##make-source (##void) locat))
             locat)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-if cte src tail?)
  (##shape src src -3)
  (let* ((code (##source-code src))
         (pre-src (##sourcify (##cadr code) src))
         (con-src (##sourcify (##caddr code) src)))
    (if (##pair? (##cdddr code))
      (let ((alt-src (##sourcify (##cadddr code) src)))
        (##shape src src 4)
        (macro-gen ##gen-if3 src
          (##comp cte pre-src #f)
          (##comp cte con-src tail?)
          (##comp cte alt-src tail?)))
      (begin
        (##shape src src 3)
        (macro-gen ##gen-if2 src
          (##comp cte pre-src #f)
          (##comp cte con-src tail?))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-cond cte src tail?)
  (##shape src src -2)
  (let* ((code (##source-code src))
         (clauses (##cdr code)))
    (##comp-cond-aux cte src tail? clauses)))

(define (##comp-cond-aux cte src tail? clauses)
  (if (##pair? clauses)
    (let* ((clause-src (##sourcify (##car clauses) src))
           (clause (##source-code clause-src)))
      (##shape src clause-src -1)
      (let* ((first-src (##sourcify (##car clause) clause-src))
             (first (##source-code first-src)))
        (cond ((##eq? first 'else)
               (##shape src clause-src -2)
               (if (##not (##null? (##cdr clauses)))
                 (##raise-expression-parsing-exception
                  'else-clause-not-last
                  clause-src))
               (##comp-seq cte src tail? (##cdr clause)))
              ((##not (##pair? (##cdr clause)))
               (macro-gen ##gen-cond-or src
                 (##comp cte first-src #f)
                 (##comp-cond-aux cte src tail? (##cdr clauses))))
              (else
               (let* ((second-src (##sourcify (##cadr clause) clause-src))
                      (second (##source-code second-src)))
                 (if (##eq? second '=>)
                   (begin
                     (##shape src clause-src 3)
                     (let ((third-src
                            (##sourcify (##caddr clause) clause-src)))
                       (macro-gen ##gen-cond-send src
                         (##comp cte first-src #f)
                         (##comp cte third-src #f)
                         (##comp-cond-aux cte src tail? (##cdr clauses)))))
                   (macro-gen ##gen-cond-if src
                     (##comp cte first-src #f)
                     (##comp-seq cte src tail? (##cdr clause))
                     (##comp-cond-aux cte src tail? (##cdr clauses)))))))))
    (macro-gen ##gen-cst-no-step src
      (##void))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-and cte src tail?)
  (##shape src src -1)
  (let* ((code (##source-code src))
         (rest (##cdr code)))
    (if (##pair? rest)
      (##comp-and-aux cte src tail? rest)
      (macro-gen ##gen-cst src
        #t))))

(define (##comp-and-aux cte src tail? lst)
  (let ((first-src (##sourcify (##car lst) src))
        (rest (##cdr lst)))
    (if (##pair? rest)
      (macro-gen ##gen-and first-src
        (##comp cte first-src #f)
        (##comp-and-aux cte src tail? rest))
      (##comp cte first-src tail?))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-or cte src tail?)
  (##shape src src -1)
  (let* ((code (##source-code src))
         (rest (##cdr code)))
    (if (##pair? rest)
      (##comp-or-aux cte src tail? rest)
      (macro-gen ##gen-cst src
        #f))))

(define (##comp-or-aux cte src tail? lst)
  (let ((first-src (##sourcify (##car lst) src))
        (rest (##cdr lst)))
    (if (##pair? rest)
      (macro-gen ##gen-or first-src
        (##comp cte first-src #f)
        (##comp-or-aux cte src tail? rest))
      (##comp cte first-src tail?))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-case cte src tail?)
  (##shape src src -3)
  (let* ((code (##source-code src))
         (first-src (##sourcify (##cadr code) src))
         (clauses (##cddr code)))
    (macro-gen ##gen-case first-src
      (##comp cte first-src #f)
      (let ((cte (##cte-frame cte (##list (macro-selector-var)))))
        (##comp-case-aux cte src tail? clauses)))))

(define (##comp-case-aux cte src tail? clauses)
  (if (##pair? clauses)
    (let* ((clause-src (##sourcify (##car clauses) src))
           (clause (##source-code clause-src)))
      (##shape src clause-src -2)
      (let* ((first-src (##sourcify (##car clause) clause-src))
             (first (##source-code first-src)))
        (if (##eq? first 'else)
          (begin
            (if (##not (##null? (##cdr clauses)))
              (##raise-expression-parsing-exception
               'else-clause-not-last
               clause-src))
            (macro-gen ##gen-case-else clause-src
              (##comp-seq cte src tail? (##cdr clause))))
          (let ((n (##proper-length first)))
            (if (##not n)
              (##raise-expression-parsing-exception
               'ill-formed-selector-list
               first-src))
            (macro-gen ##gen-case-clause clause-src
              (##desourcify first-src)
              (##comp-seq cte src tail? (##cdr clause))
              (##comp-case-aux cte src tail? (##cdr clauses)))))))
    (macro-gen ##gen-case-else src
      (macro-gen ##gen-cst-no-step src
        (##void)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-let cte src tail?)
  (##shape src src -3)
  (let* ((code (##source-code src))
         (first-src (##sourcify (##cadr code) src))
         (first (##source-code first-src)))
    (if (##symbol? first)
      (begin
        (##shape src src -4)
        (let ((bindings-src (##sourcify (##caddr code) src)))
          (let* ((vars (##bindings->vars src bindings-src #t #f))
                 (vals (##bindings->vals src bindings-src)))
            (macro-gen ##gen-app-no-step src
              (let ((inner-cte (##cte-frame cte (##list first))))
                (macro-gen ##gen-letrec src
                  (##list first)
                  (let ((cte inner-cte)
                        (tail? #f))
                    (##list (macro-gen ##gen-prc-req-no-step src
                              vars
                              (##comp-body (##cte-frame
                                             cte
                                             (##cons (macro-self-var) vars))
                                           src
                                           #t
                                           (##cdddr code)))))
                  (let ((cte inner-cte)
                        (tail? #f))
                    (macro-gen ##gen-loc-ref-no-step src ;; fetch loop variable
                      0
                      1))))
              (##comp-vals cte src vals)))))
      (let* ((vars (##bindings->vars src first-src #t #f))
             (vals (##bindings->vals src first-src)))
        (if (##null? vars)
          (##comp-body cte src tail? (##cddr code))
          (let ((c
                 (##comp-body
                   (##cte-frame cte vars)
                   src
                   tail?
                   (##cddr code))))
            (macro-gen ##gen-let src
              vars
              (##comp-vals cte src vals)
              c)))))))

(define (##comp-vals cte src lst)
  (if (##pair? lst)
    (##cons (##comp cte (##sourcify (##car lst) src) #f)
            (##comp-vals cte src (##cdr lst)))
    '()))

(define (##bindings->vars src bindings-src check-duplicates? allow-steps?)

  (define (bindings->vars lst rev-vars)
    (if (##pair? lst)
      (let* ((binding-src (##sourcify (##car lst) src))
             (binding (##source-code binding-src)))
        (if allow-steps?
          (begin
            (##shape src binding-src -2)
            (if (##pair? (##cddr binding)) (##shape src binding-src 3)))
          (##shape src binding-src 2))
        (let* ((first-src (##sourcify (##car binding) binding-src))
               (first (##source-code first-src)))
          (##variable first-src)
          (if (and check-duplicates? (##memq first rev-vars))
            (##raise-expression-parsing-exception
             'duplicate-variable-binding
             first-src))
          (bindings->vars (##cdr lst)
                          (##cons first rev-vars))))
      (##reverse rev-vars)))

  (let* ((bindings (##source-code bindings-src))
         (len (##proper-length bindings)))
    (if len
      (bindings->vars bindings '())
      (##raise-expression-parsing-exception
       'ill-formed-binding-list
       bindings-src))))

(define (##bindings->vals src bindings-src)

  (define (bindings->vals lst)
    (if (##pair? lst)
      (let* ((binding-src (##sourcify (##car lst) src))
             (binding (##source-code binding-src)))
        (##cons (##sourcify (##cadr binding) src)
                (bindings->vals (##cdr lst))))
      '()))

  (let ((bindings (##source-code bindings-src)))
    (bindings->vals bindings)))

(define (##bindings->steps src bindings-src)

  (define (bindings->steps lst)
    (if (##pair? lst)
      (let* ((binding-src (##sourcify (##car lst) src))
             (binding (##source-code binding-src)))
        (##cons (##sourcify (if (##pair? (##cddr binding))
                              (##caddr binding)
                              (##car binding))
                            src)
                (bindings->steps (##cdr lst))))
      '()))

  (let ((bindings (##source-code bindings-src)))
    (bindings->steps bindings)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-let* cte src tail?)
  (##shape src src -3)
  (let* ((code (##source-code src))
         (bindings-src (##sourcify (##cadr code) src))
         (vars (##bindings->vars src bindings-src #f #f))
         (vals (##bindings->vals src bindings-src)))
    (##comp-let*-aux cte src tail? vars vals (##cddr code))))

(define (##comp-let*-aux cte src tail? vars vals body)
  (if (##pair? vars)
    (let ((frame (##list (##car vars))))
      (let ((inner-cte (##cte-frame cte frame)))
        (macro-gen ##gen-let src
          frame
          (##list (##comp cte (##car vals) #f))
          (##comp-let*-aux inner-cte
                           src
                           tail?
                           (##cdr vars)
                           (##cdr vals)
                           body))))
    (##comp-body cte src tail? body)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-letrec cte src tail?)
  (##shape src src -3)
  (let* ((code (##source-code src))
         (bindings-src (##sourcify (##cadr code) src))
         (vars (##bindings->vars src bindings-src #t #f))
         (vals (##bindings->vals src bindings-src)))
    (##comp-letrec-aux cte src tail? vars vals (##cddr code))))

(define (##comp-letrec-aux cte src tail? vars vals body)
  (if (##pair? vars)
    (let ((inner-cte (##cte-frame cte vars)))
      (macro-gen ##gen-letrec src
        vars
        (##comp-vals inner-cte src vals)
        (##comp-body inner-cte src tail? body)))
    (##comp-body cte src tail? body)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-do cte src tail?)
  (##shape src src -3)
  (let* ((code (##source-code src))
         (bindings-src (##sourcify (##cadr code) src))
         (exit-src (##sourcify (##caddr code) src))
         (exit (##source-code exit-src)))
    (##shape src exit-src -1)
    (let* ((vars (##bindings->vars src bindings-src #t #t))
           (do-loop-vars (##list (macro-do-loop-var)))
           (inner-cte (##cte-frame cte do-loop-vars)))
      (macro-gen ##gen-letrec src
        do-loop-vars
        (##list
          (let ((cte inner-cte)
                (tail? #f))
            (macro-gen ##gen-prc-req-no-step src
              vars
              (let ((cte (##cte-frame cte (##cons (macro-self-var) vars)))
                    (tail? #t))
                (macro-gen ##gen-if3 src
                  (##comp cte (##sourcify (##car exit) src) #f)
                  (##comp-seq cte src tail? (##cdr exit))
                  (let ((call
                          (macro-gen ##gen-app-no-step src
                            (let ((tail? #f))
                              (macro-gen ##gen-loc-ref-no-step src; fetch do-loop-var
                                1
                                1))
                            (##comp-vals cte
                                         src
                                         (##bindings->steps src
                                                            bindings-src)))))
                    (if (##null? (##cdddr code))
                      call
                      (macro-gen ##gen-seq src
                        (##comp-seq cte src #f (##cdddr code))
                        call))))))))
        (let ((cte inner-cte))
          (macro-gen ##gen-app-no-step src
            (let ((tail? #f))
              (macro-gen ##gen-loc-ref-no-step src ;; fetch do-loop-var
                0
                1))
            (##comp-vals cte src (##bindings->vals src bindings-src))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-app cte src tail?)
  (let* ((code (##source-code src))
         (len (##proper-length code)))
    (if len
      (macro-gen ##gen-app src
        (##comp cte (##sourcify (##car code) src) #f)
        (##comp-vals cte src (##cdr code)))
      (##raise-expression-parsing-exception
       'ill-formed-call
       src))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-delay cte src tail?)
  (##shape src src 2)
  (let ((code (##source-code src)))
    (macro-gen ##gen-delay src
      (##comp cte (##sourcify (##cadr code) src) #t))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-future cte src tail?)
  (##shape src src 2)
  (let ((code (##source-code src)))
    (macro-gen ##gen-future src
      (##comp cte (##sourcify (##cadr code) src) #t))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-this-source-file cte src tail?)
  (let* ((locat
          (##source-locat src))
         (file
          (and locat
               (##container->file (##locat-container locat)))))
    (if file
      (macro-gen ##gen-cst src
        file)
      (##raise-expression-parsing-exception
       'unknown-location
       src))))

;;;============================================================================

;;; Code generation procedures

;;;----------------------------------------------------------------------------

(define ##cprc-top
  (macro-make-cprc
   (let* (($code (^ 0))
          (rte (macro-make-rte rte #f)))
     (##first-argument #f) ;; make sure $code and rte are in environment-map
     (##check-heap-limit)
     (macro-code-run $code))))

(define ##gen-top
  (macro-make-gen (val)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-top cte src stepper (val)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-cst
  (macro-make-cprc
   (macro-constant-step! ()
    (^ 0))))

(define ##gen-cst
  (macro-make-gen (val)
    (let ((stepper (##current-stepper)))
      (macro-make-code ##cprc-cst cte src stepper ()
        val))))

(define ##gen-cst-no-step
  (macro-make-gen (val)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-cst cte src stepper ()
        val))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-loc-ref-0-1
  (macro-make-cprc
   (macro-reference-step! ()
    (macro-rte-ref rte 1))))

(define ##cprc-loc-ref-0-2
  (macro-make-cprc
   (macro-reference-step! ()
    (macro-rte-ref rte 2))))

(define ##cprc-loc-ref-0-3
  (macro-make-cprc
   (macro-reference-step! ()
    (macro-rte-ref rte 3))))

(define ##cprc-loc-ref-1-1
  (macro-make-cprc
   (macro-reference-step! ()
    (macro-rte-ref (macro-rte-up rte) 1))))

(define ##cprc-loc-ref-1-2
  (macro-make-cprc
   (macro-reference-step! ()
    (macro-rte-ref (macro-rte-up rte) 2))))

(define ##cprc-loc-ref-1-3
  (macro-make-cprc
   (macro-reference-step! ()
    (macro-rte-ref (macro-rte-up rte) 3))))

(define ##cprc-loc-ref-2-1
  (macro-make-cprc
   (macro-reference-step! ()
    (macro-rte-ref (macro-rte-up (macro-rte-up rte)) 1))))

(define ##cprc-loc-ref-2-2
  (macro-make-cprc
   (macro-reference-step! ()
    (macro-rte-ref (macro-rte-up (macro-rte-up rte)) 2))))

(define ##cprc-loc-ref-2-3
  (macro-make-cprc
   (macro-reference-step! ()
    (macro-rte-ref (macro-rte-up (macro-rte-up rte)) 3))))

(define ##cprc-loc-ref
  (macro-make-cprc
   (macro-reference-step! ()
    (let ((up (^ 0)))
      (let loop ((e rte) (i up))
        (if (##fixnum.< 0 i)
          (loop (macro-rte-up e) (##fixnum.- i 1))
          (macro-rte-ref e (^ 1))))))))

(define ##gen-loc-ref-aux
  (macro-make-gen (stepper up over)
    (case up
      ((0)
       (case over
         ((1)  (macro-make-code ##cprc-loc-ref-0-1 cte src stepper ()))
         ((2)  (macro-make-code ##cprc-loc-ref-0-2 cte src stepper ()))
         ((3)  (macro-make-code ##cprc-loc-ref-0-3 cte src stepper ()))
         (else (macro-make-code ##cprc-loc-ref     cte src stepper ()
                 up
                 over))))
      ((1)
       (case over
         ((1)  (macro-make-code ##cprc-loc-ref-1-1 cte src stepper ()))
         ((2)  (macro-make-code ##cprc-loc-ref-1-2 cte src stepper ()))
         ((3)  (macro-make-code ##cprc-loc-ref-1-3 cte src stepper ()))
         (else (macro-make-code ##cprc-loc-ref     cte src stepper ()
                 up
                 over))))
      ((2)
       (case over
         ((1)  (macro-make-code ##cprc-loc-ref-2-1 cte src stepper ()))
         ((2)  (macro-make-code ##cprc-loc-ref-2-2 cte src stepper ()))
         ((3)  (macro-make-code ##cprc-loc-ref-2-3 cte src stepper ()))
         (else (macro-make-code ##cprc-loc-ref     cte src stepper ()
                 up
                 over))))
     (else
      (macro-make-code ##cprc-loc-ref cte src stepper ()
        up
        over)))))

(define ##gen-loc-ref
  (macro-make-gen (up over)
    (let ((stepper (##current-stepper)))
      (macro-gen ##gen-loc-ref-aux src stepper up over))))

(define ##gen-loc-ref-no-step
  (macro-make-gen (up over)
    (let ((stepper (##no-stepper)))
      (macro-gen ##gen-loc-ref-aux src stepper up over))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-glo-ref
  (macro-make-cprc
   (macro-reference-step! ()
    (let ((val (##global-var-ref (^ 0))))
      (if (macro-unbound? val)
        (##first-argument ;; keep $code and rte in environment-map
          (##raise-unbound-global-exception $code rte (^ 0))
          $code
          rte)
        val)))))

(define ##gen-glo-ref
  (macro-make-gen (ind)
    (let ((stepper (##current-stepper)))
      (macro-make-code ##cprc-glo-ref cte src stepper ()
        ind))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-loc-set
  (macro-make-cprc
   (let ((val (macro-code-run (^ 0))))
     (macro-set!-step! (val)
      (let ((up (^ 1)))
        (let loop ((e rte) (i up))
          (if (##fixnum.< 0 i)
            (loop (macro-rte-up e) (##fixnum.- i 1))
            (begin
              (macro-rte-set! e (^ 2) val)
              (##void)))))))))

(define ##gen-loc-set
  (macro-make-gen (up over val)
    (let ((stepper (##current-stepper)))
      (macro-make-code ##cprc-loc-set cte src stepper (val)
        up
        over))))

(define ##cprc-glo-set
  (macro-make-cprc
   (let ((val (macro-code-run (^ 0))))
     (macro-set!-step! (val)
      (if (macro-unbound? (##global-var-ref (^ 1)))
        (##first-argument ;; keep $code and rte in environment-map
          (##raise-unbound-global-exception $code rte (^ 1))
          $code
          rte)
        (begin
          (##global-var-set! (^ 1) val)
          (##void)))))))

(define ##gen-glo-set
  (macro-make-gen (ind val)
    (let ((stepper (##current-stepper)))
      (macro-make-code ##cprc-glo-set cte src stepper (val)
        ind))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-glo-def
  (macro-make-cprc
   (let ((rte (##first-argument #f))) ;; avoid constant propagation of #f
     (let ((val (macro-code-run (^ 0))))
       (macro-define-step! (val)
         (##global-var-set! (^ 1) val)
         (##void))))))

(define ##gen-glo-def
  (macro-make-gen (ind val)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-glo-def cte src stepper (val)
        ind))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-if2
  (macro-make-cprc
   (let ((pred (macro-code-run (^ 0))))
     (macro-force-vars (pred)
       (if (macro-true? pred)
         (macro-code-run (^ 1))
         (##void))))))

(define ##gen-if2
  (macro-make-gen (pre con)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-if2 cte src stepper (pre con)))))

(define ##cprc-if3
  (macro-make-cprc
   (let ((pred (macro-code-run (^ 0))))
     (macro-force-vars (pred)
       (if (macro-true? pred)
         (macro-code-run (^ 1))
         (macro-code-run (^ 2)))))))

(define ##gen-if3
  (macro-make-gen (pre con alt)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-if3 cte src stepper (pre con alt)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-seq
  (macro-make-cprc
   (begin
     (macro-code-run (^ 0))
     (macro-code-run (^ 1)))))

(define ##gen-seq
  (macro-make-gen (val1 val2)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-seq cte src stepper (val1 val2)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-quasi-list->vector
  (macro-make-cprc
   (##quasi-list->vector
    (##first-argument ;; keep $code and rte in environment-map
      (macro-code-run (^ 0))
      $code
      rte))))

(define ##gen-quasi-list->vector
  (macro-make-gen (val)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-quasi-list->vector cte src stepper (val)))))

(define ##cprc-quasi-append
  (macro-make-cprc
   (let* ((val1
           (macro-code-run (^ 0)))
          (val2
           (macro-code-run (^ 1))))
     (##first-argument $code rte) ;; keep $code and rte in environment-map
     (##quasi-append val1 val2))))

(define ##gen-quasi-append
  (macro-make-gen (val1 val2)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-quasi-append cte src stepper (val1 val2)))))

(define ##cprc-quasi-cons
  (macro-make-cprc
   (let* ((val1
           (macro-code-run (^ 0)))
          (val2
           (macro-code-run (^ 1))))
     (##first-argument $code rte) ;; keep $code and rte in environment-map
     (##quasi-cons val1 val2))))

(define ##gen-quasi-cons
  (macro-make-gen (val1 val2)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-quasi-cons cte src stepper (val1 val2)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-cond-if
  (macro-make-cprc
   (let ((pred (macro-code-run (^ 0))))
     (macro-force-vars (pred)
       (if (macro-true? pred)
         (macro-code-run (^ 1))
         (macro-code-run (^ 2)))))))

(define ##gen-cond-if
  (macro-make-gen (val1 val2 val3)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-cond-if cte src stepper (val1 val2 val3)))))

(define ##cprc-cond-or
  (macro-make-cprc
   (let ((pred (macro-code-run (^ 0))))
     (macro-force-vars (pred)
       (if (macro-true? pred)
         pred
         (macro-code-run (^ 1)))))))

(define ##gen-cond-or
  (macro-make-gen (val1 val2)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-cond-or cte src stepper (val1 val2)))))

(define ##cprc-cond-send-red
  (macro-make-cprc
   (let ((pred (macro-code-run (^ 0))))
     (macro-force-vars (pred)
       (if (macro-true? pred)
         (let ((oper (macro-code-run (^ 1))))
           (macro-force-vars (oper)
             (if (##not (##procedure? oper))
               (let ((args (##list pred)))
                 (##check-heap-limit)
                 (##raise-nonprocedure-operator-exception oper args $code rte))
               (macro-call-step! (oper pred)
                 (oper pred)))))
         (macro-code-run (^ 2)))))))

(define ##cprc-cond-send-sub
  (macro-make-cprc
   (let ((pred (macro-code-run (^ 0))))
     (macro-force-vars (pred)
       (if (macro-true? pred)
         (let ((oper (macro-code-run (^ 1))))
           (macro-force-vars (oper)
             (if (##not (##procedure? oper))
               (let ((args (##list pred)))
                 (##check-heap-limit)
                 (##raise-nonprocedure-operator-exception oper args $code rte))
               (##subproblem-apply1 $code rte oper pred))))
         (macro-code-run (^ 2)))))))

(define ##gen-cond-send
  (macro-make-gen (val1 val2 val3)
    (let ((stepper (##no-stepper)))
      (macro-make-code (if tail? ##cprc-cond-send-red ##cprc-cond-send-sub)
                       cte
                       src
                       stepper
                       (val1 val2 val3)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-or
  (macro-make-cprc
   (let ((pred (macro-code-run (^ 0))))
     (macro-force-vars (pred)
       (if (macro-true? pred)
         pred
         (macro-code-run (^ 1)))))))

(define ##gen-or
  (macro-make-gen (val1 val2)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-or cte src stepper (val1 val2)))))

(define ##cprc-and
  (macro-make-cprc
   (let ((pred (macro-code-run (^ 0))))
     (macro-force-vars (pred)
       (if (##not (macro-true? pred))
         pred
         (macro-code-run (^ 1)))))))

(define ##gen-and
  (macro-make-gen (val1 val2)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-and cte src stepper (val1 val2)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-case
  (macro-make-cprc
   (let ((selector (macro-code-run (^ 0))))
     (macro-force-vars (selector)
       (let* (($code (^ 1))
              (rte (macro-make-rte rte selector)))
         (##first-argument #f) ;; make sure $code and rte are in environment-map
         (##check-heap-limit)
         (macro-code-run $code))))))

(define ##gen-case
  (macro-make-gen (val1 val2)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-case cte src stepper (val1 val2)))))

(define ##cprc-case-clause
  (macro-make-cprc
   (if (##case-memv (macro-rte-ref rte 1) (^ 2))
     (macro-code-run (^ 0))
     (macro-code-run (^ 1)))))

(define ##gen-case-clause
  (macro-make-gen (cases val1 val2)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-case-clause cte src stepper (val1 val2)
        cases))))

(define ##cprc-case-else
  (macro-make-cprc
   (macro-code-run (^ 0))))

(define ##gen-case-else
  (macro-make-gen (val)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-case-else cte src stepper (val)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-let
  (macro-make-cprc
   (let ((ns (##fixnum.- (macro-code-length $code) 2)))
     (let loop1 ((i 1) (args '()))
       (if (##fixnum.< ns i)
         (let ((inner-rte (macro-make-rte* rte ns)))
           (##check-heap-limit)
           (let loop2 ((i ns) (args args))
             (if (##fixnum.< 0 i)
               (begin
                 (macro-rte-set! inner-rte i (##car args))
                 (loop2 (##fixnum.- i 1) (##cdr args)))
               (let* (($code
                       (^ 0))
                      (rte
                       (##first-argument ;; keep $code and rte in environment-map
                         inner-rte
                         rte)))
                 (macro-code-run $code)))))
         (let ((new-args
                (##cons (macro-code-run (macro-code-ref $code i)) args)))
           (##check-heap-limit)
           (loop1 (##fixnum.+ i 1) new-args)))))))

(define ##gen-let
  (macro-make-gen (vars vals body)
    (let* ((stepper
            (##no-stepper))
           (c
            (##make-code* ##cprc-let cte src stepper (##cons body vals) 1)))
      (macro-code-set! c (##fixnum.+ (##length vals) 1) vars)
      c)))

(define ##cprc-letrec
  (macro-make-cprc
   (let ((ns (##fixnum.- (macro-code-length $code) 2)))
     (let ((inner-rte (macro-make-rte* rte ns)))
       (let loop1 ((i 1) (rev-vals '()))
         (if (##fixnum.< ns i)
           (let loop2 ((i i) (rev-vals rev-vals))
             (if (##fixnum.< 1 i)
               (let ((new-i (##fixnum.- i 1)))
                 (macro-rte-set! inner-rte new-i (##car rev-vals))
                 (loop2 new-i (##cdr rev-vals)))
               (let* (($code (^ 0))
                      (rte (##first-argument inner-rte rte)))
                 (macro-code-run $code))))
           (let ((new-rev-vals
                  (##cons (let* (($code (macro-code-ref $code i))
                                 (rte inner-rte))
                            (macro-code-run $code))
                          rev-vals)))
             (##check-heap-limit)
             (loop1 (##fixnum.+ i 1) new-rev-vals))))))))

(define ##gen-letrec
  (macro-make-gen (vars vals body)
    (let* ((stepper
            (##no-stepper))
           (c
            (##make-code* ##cprc-letrec cte src stepper (##cons body vals) 1)))
      (macro-code-set! c (##fixnum.+ (##length vals) 1) vars)
      c)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-prc-req0
  (macro-make-cprc
   (macro-lambda-step! ()
     (letrec ((proc
               (lambda arg1-and-up

                 (##define-macro (execute)
                   `(if (##not (##null? arg1-and-up))
                      (##raise-wrong-number-of-arguments-exception
                       proc
                       arg1-and-up)
                      (let* (($code (^ 0))
                             (rte (macro-make-rte rte proc)))
                        (##first-argument #f) ;; make sure $code and rte are in environment-map
                        (##check-heap-limit)
                        (macro-code-run $code))))

                 (let ((entry-hook (^ 1)))
                   (if entry-hook
                     (let ((exec (lambda () (execute))))
                       (##check-heap-limit)
                       (entry-hook proc arg1-and-up exec))
                     (execute))))))

       (##check-heap-limit)
       (##first-argument ;; keep $code and rte in environment-map
         proc
         $code
         rte)))))

(define ##cprc-prc-req1
  (macro-make-cprc
   (macro-lambda-step! ()
     (letrec ((proc
               (lambda (#!optional (arg1 (macro-absent-obj))
                        #!rest arg2-and-up)

                 (##define-macro (execute)
                   `(if (or (##eq? arg1 (macro-absent-obj))
                            (##not (##null? arg2-and-up)))
                      (let ((args
                             (cond ((##eq? arg1 (macro-absent-obj))
                                    '())
                                   (else
                                    (##cons arg1 arg2-and-up)))))
                        (##check-heap-limit)
                        (##first-argument $code rte)
                        (##raise-wrong-number-of-arguments-exception
                         proc
                         args))
                      (let* (($code (^ 0))
                             (rte (macro-make-rte rte proc arg1)))
                        (##first-argument #f) ;; make sure $code and rte are in environment-map
                        (##check-heap-limit)
                        (macro-code-run $code))))

                 (let ((entry-hook (^ 1)))
                   (if entry-hook
                     (let* ((args
                              (##cons arg1 arg2-and-up))
                            (exec
                             (lambda () (execute))))
                       (##check-heap-limit)
                       (##first-argument $code rte)
                       (entry-hook proc args exec))
                     (execute))))))

       (##check-heap-limit)
       (##first-argument ;; keep $code and rte in environment-map
         proc
         $code
         rte)))))

(define ##cprc-prc-req2
  (macro-make-cprc
   (macro-lambda-step! ()
     (letrec ((proc
               (lambda (#!optional (arg1 (macro-absent-obj))
                                   (arg2 (macro-absent-obj))
                        #!rest arg3-and-up)

                 (##define-macro (execute)
                   `(if (or (##eq? arg2 (macro-absent-obj))
                            (##not (##null? arg3-and-up)))
                      (let ((args
                             (cond ((##eq? arg1 (macro-absent-obj))
                                    '())
                                   ((##eq? arg2 (macro-absent-obj))
                                    (##list arg1))
                                   (else
                                    (##cons arg1
                                            (##cons arg2 arg3-and-up))))))
                        (##check-heap-limit)
                        (##first-argument $code rte)
                        (##raise-wrong-number-of-arguments-exception
                         proc
                         args))
                      (let* (($code (^ 0))
                             (rte (macro-make-rte rte proc arg1 arg2)))
                        (##first-argument #f) ;; make sure $code and rte are in environment-map
                        (##check-heap-limit)
                        (macro-code-run $code))))

                 (let ((entry-hook (^ 1)))
                   (if entry-hook
                     (let* ((args
                              (##cons arg1
                                      (##cons arg2 arg3-and-up)))
                            (exec
                             (lambda () (execute))))
                       (##check-heap-limit)
                       (##first-argument $code rte)
                       (entry-hook proc args exec))
                     (execute))))))

       (##check-heap-limit)
       (##first-argument ;; keep $code and rte in environment-map
         proc
         $code
         rte)))))

(define ##cprc-prc-req3
  (macro-make-cprc
   (macro-lambda-step! ()
     (letrec ((proc
               (lambda (#!optional (arg1 (macro-absent-obj))
                                   (arg2 (macro-absent-obj))
                                   (arg3 (macro-absent-obj))
                        #!rest arg4-and-up)

                 (##define-macro (execute)
                   `(if (or (##eq? arg3 (macro-absent-obj))
                            (##not (##null? arg4-and-up)))
                      (let ((args
                             (cond ((##eq? arg1 (macro-absent-obj))
                                    '())
                                   ((##eq? arg2 (macro-absent-obj))
                                    (##list arg1))
                                   ((##eq? arg3 (macro-absent-obj))
                                    (##list arg1 arg2))
                                   (else
                                    (##cons arg1
                                            (##cons arg2
                                                    (##cons arg3
                                                            arg4-and-up)))))))
                        (##check-heap-limit)
                        (##first-argument $code rte)
                        (##raise-wrong-number-of-arguments-exception
                         proc
                         args))
                      (let* (($code (^ 0))
                             (rte (macro-make-rte rte proc arg1 arg2 arg3)))
                        (##first-argument #f) ;; make sure $code and rte are in environment-map
                        (##check-heap-limit)
                        (macro-code-run $code))))

                 (let ((entry-hook (^ 1)))
                   (if entry-hook
                     (let* ((args
                              (##cons arg1
                                      (##cons arg2
                                              (##cons arg3 arg4-and-up))))
                            (exec
                             (lambda () (execute))))
                       (##check-heap-limit)
                       (##first-argument $code rte)
                       (entry-hook proc args exec))
                     (execute))))))

       (##check-heap-limit)
       (##first-argument ;; keep $code and rte in environment-map
         proc
         $code
         rte)))))

(define ##cprc-prc-req
  (macro-make-cprc
   (macro-lambda-step! ()
     (letrec ((proc
               (lambda args

                 (define (execute)
                   (let ((ns (^ 1)))
                     (let ((inner-rte (macro-make-rte* rte ns)))
                       (##check-heap-limit)
                       (macro-rte-set! inner-rte 1 proc)
                       (let loop ((i 2) (lst args))
                         (if (##fixnum.< ns i)
                           (if (##pair? lst)
                             (##raise-wrong-number-of-arguments-exception
                              proc
                              args)
                             (let* (($code (^ 0))
                                    (rte (##first-argument inner-rte rte)))
                               (macro-code-run $code)))
                           (if (##pair? lst)
                             (begin
                               (macro-rte-set! inner-rte i (##car lst))
                               (loop (##fixnum.+ i 1) (##cdr lst)))
                             (##raise-wrong-number-of-arguments-exception
                              proc
                              args)))))))

                 (let ((entry-hook (^ 2)))
                   (if entry-hook
                     (let ((exec
                            (lambda () (execute))))
                       (##check-heap-limit)
                       (##first-argument $code rte)
                       (entry-hook proc args exec))
                     (execute))))))

       (##check-heap-limit)
       (##first-argument ;; keep $code and rte in environment-map
         proc
         $code
         rte)))))

(define ##gen-prc-req-aux
  (macro-make-gen (stepper frame body)
    (let ((n (##length frame)))
      (case n
        ((0)
         (macro-make-code ##cprc-prc-req0 cte src stepper (body)
           #f
           frame))
        ((1)
         (macro-make-code ##cprc-prc-req1 cte src stepper (body)
           #f
           frame))
        ((2)
         (macro-make-code ##cprc-prc-req2 cte src stepper (body)
           #f
           frame))
        ((3)
         (macro-make-code ##cprc-prc-req3 cte src stepper (body)
           #f
           frame))
        (else
         (let ((n+1 (##fixnum.+ n 1)))
           (macro-make-code ##cprc-prc-req  cte src stepper (body)
             n+1
             #f
             frame)))))))

(define ##gen-prc-req
  (macro-make-gen (frame body)
    (let ((stepper (##current-stepper)))
      (macro-gen ##gen-prc-req-aux src stepper frame body))))

(define ##gen-prc-req-no-step
  (macro-make-gen (frame body)
    (let ((stepper (##no-stepper)))
      (macro-gen ##gen-prc-req-aux src stepper frame body))))

(define ##cprc-prc-rest
  (macro-make-cprc
   (macro-lambda-step! ()
     (letrec ((proc
               (lambda args

                 (define (execute)
                   (let ((ns (^ 1)))
                     (let ((inner-rte (macro-make-rte* rte ns)))
                       (##check-heap-limit)
                       (macro-rte-set! inner-rte 1 proc)
                       (let loop ((i 2) (lst args))
                         (if (##fixnum.< i ns)
                           (if (##pair? lst)
                             (begin
                               (macro-rte-set! inner-rte i (##car lst))
                               (loop (##fixnum.+ i 1) (##cdr lst)))
                             (##raise-wrong-number-of-arguments-exception
                              proc
                              args))
                           (begin
                             (macro-rte-set! inner-rte i lst)
                             (let* (($code (^ 0))
                                    (rte (##first-argument inner-rte rte)))
                               (macro-code-run $code))))))))

                 (let ((entry-hook (^ 2)))
                   (if entry-hook
                     (let ((exec
                            (lambda () (execute))))
                       (##check-heap-limit)
                       (##first-argument $code rte)
                       (entry-hook proc args exec))
                     (execute))))))

       (##check-heap-limit)
       (##first-argument ;; keep $code and rte in environment-map
         proc
         $code
         rte)))))

(define ##gen-prc-rest
  (macro-make-gen (frame body)
    (let ((stepper (##current-stepper))
          (n+1 (##fixnum.+ (##length frame) 1)))
      (macro-make-code ##cprc-prc-rest cte src stepper (body)
        n+1
        #f
        frame))))

(define ##cprc-prc
  (macro-make-cprc
   (macro-lambda-step! ()
     (letrec ((proc
               (lambda args

                 (define (execute)
                   (let* ((n
                           (macro-code-length $code))
                          (inner-rte
                           (macro-make-rte*
                            rte
                            (macro-code-ref $code (##fixnum.- n 7)))))

                     (define reject-illegal-dsssl-parameter-list? #f)

                     (define (get-keys i j left rest? keys)
                       (let loop1 ((end left))

                         (define (keys-ok)
                           (let loop3 ((i i) (j j) (k 0))
                             (if (##fixnum.< k (##vector-length keys))
                               (let ((key (##vector-ref keys k)))
                                 (let loop4 ((lst left))
                                   (if (##eq? lst end)
                                     (begin
                                       (macro-rte-set! inner-rte i
                                         (let* (($code
                                                 (macro-code-ref $code j))
                                                (rte
                                                 inner-rte))
                                           (macro-code-run $code)))
                                       (loop3 (##fixnum.+ i 1)
                                              (##fixnum.+ j 1)
                                              (##fixnum.+ k 1)))
                                     (if (##eq? (##car lst) key)
                                       (begin
                                         (macro-rte-set! inner-rte i
                                           (##cadr lst))
                                         (loop3 (##fixnum.+ i 1)
                                                (##fixnum.+ j 1)
                                                (##fixnum.+ k 1)))
                                       (loop4 (##cddr lst))))))
                               (begin
                                 (if (##eq? rest? #t)
                                   (macro-rte-set! inner-rte i end))
                                 (let* (($code (^ 0))
                                        (rte (##first-argument inner-rte rte)))
                                   (macro-code-run $code))))))

                         (if (##pair? end)
                           (let ((key (##car end))
                                 (lst (##cdr end)))
                             (cond ((##not (##pair? lst))
                                    (if (or (##not rest?)
                                            (and reject-illegal-dsssl-parameter-list?
                                                 (##eq? rest? 'dsssl)))
                                      (##raise-wrong-number-of-arguments-exception
                                       proc
                                       args)
                                      (keys-ok)))
                                   ((##keyword? key)
                                    (if (##eq? rest? 'dsssl)
                                      (loop1 (##cdr lst))
                                      (let loop2 ((k (##fixnum.-
                                                      (##vector-length keys)
                                                      1)))
                                        (cond ((##fixnum.< k 0)
                                               (##raise-unknown-keyword-argument-exception
                                                proc
                                                args))
                                              ((##eq? key (##vector-ref keys k))
                                               (loop1 (##cdr lst)))
                                              (else
                                               (loop2 (##fixnum.- k 1)))))))
                                   (else
                                    (if (or (##not rest?)
                                            (and reject-illegal-dsssl-parameter-list?
                                                 (##eq? rest? 'dsssl)))
                                      (##raise-keyword-expected-exception
                                       proc
                                       args)
                                      (keys-ok)))))
                           (keys-ok))))

                     (##check-heap-limit)
                     (macro-rte-set! inner-rte 1 proc)
                     (let loop1 ((i 2) (lst args))
                       (if (##fixnum.<
                            i
                            (macro-code-ref $code (##fixnum.- n 6)))
                         (if (##pair? lst)
                           (begin
                             (macro-rte-set! inner-rte i (##car lst))
                             (loop1 (##fixnum.+ i 1) (##cdr lst)))
                           (##raise-wrong-number-of-arguments-exception
                            proc
                            args))
                         (let loop2 ((i i) (j 1) (lst lst))
                           (if (##fixnum.<
                                i
                                (macro-code-ref $code (##fixnum.- n 5)))
                             (if (##pair? lst)
                               (begin
                                 (macro-rte-set! inner-rte i (##car lst))
                                 (loop2 (##fixnum.+ i 1)
                                        (##fixnum.+ j 1)
                                        (##cdr lst)))
                               (begin
                                 (macro-rte-set! inner-rte i
                                   (let* (($code (macro-code-ref $code j))
                                          (rte inner-rte))
                                     (macro-code-run $code)))
                                 (loop2 (##fixnum.+ i 1)
                                        (##fixnum.+ j 1)
                                        '())))
                             (let ((keys
                                    (macro-code-ref $code (##fixnum.- n 3)))
                                   (rest?
                                    (macro-code-ref $code (##fixnum.- n 4))))
                               (cond (rest?
                                      (if keys
                                        (get-keys
                                         (if (##eq? rest? 'dsssl)
                                           (begin
                                             (macro-rte-set! inner-rte i lst)
                                             (##fixnum.+ i 1))
                                           i)
                                         j
                                         lst
                                         rest?
                                         keys)
                                        (begin
                                          (macro-rte-set! inner-rte i lst)
                                          (let* (($code
                                                  (^ 0))
                                                 (rte
                                                  (##first-argument
                                                   inner-rte
                                                   rte)))
                                            (macro-code-run $code)))))
                                     (keys
                                      (get-keys i
                                                j
                                                lst
                                                rest?
                                                keys))
                                     ((##null? lst)
                                      (let* (($code
                                              (^ 0))
                                             (rte
                                              (##first-argument
                                                inner-rte
                                                rte)))
                                        (macro-code-run $code)))
                                     (else
                                      (##raise-wrong-number-of-arguments-exception
                                       proc
                                       args))))))))))

                 (let ((entry-hook
                        (macro-code-ref $code
                                        (##fixnum.- (macro-code-length $code) 2))))
                   (if entry-hook
                     (let ((exec
                            (lambda () (execute))))
                       (##check-heap-limit)
                       (##first-argument $code rte)
                       (entry-hook proc args exec))
                     (execute))))))

       (##check-heap-limit)
       (##first-argument ;; keep $code and rte in environment-map
         proc
         $code
         rte)))))

(define ##gen-prc
  (macro-make-gen (frame rest? keys body inits)
    (let* ((stepper
            (##current-stepper))
           (n
            (##length frame))
           (ni
            (##length inits))
           (nr
            (##fixnum.- (##fixnum.- n ni) (if rest? 1 0)))
           (no
            (##fixnum.- ni (if keys (##vector-length keys) 0)))
           (c
            (##make-code* ##cprc-prc cte src stepper (##cons body inits) 7)))
      (macro-code-set! c (##fixnum.+ ni 1) (##fixnum.+ n 1))
      (macro-code-set! c (##fixnum.+ ni 2) (##fixnum.+ nr 2))
      (macro-code-set! c (##fixnum.+ ni 3) (##fixnum.+ (##fixnum.+ nr 2) no))
      (macro-code-set! c (##fixnum.+ ni 4) rest?)
      (macro-code-set! c (##fixnum.+ ni 5) keys)
      (macro-code-set! c (##fixnum.+ ni 6) #f)
      (macro-code-set! c (##fixnum.+ ni 7) frame)
      c)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-app0-red
  (macro-make-cprc
   (let ((oper (macro-code-run (^ 0))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
         (##raise-nonprocedure-operator-exception oper '() $code rte)
         (macro-call-step! (oper)
           (oper)))))))

(define ##cprc-app1-red
  (macro-make-cprc
   (let* ((oper (macro-code-run (^ 0)))
          (arg1 (macro-code-run (^ 1))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
         (let ((args (##list arg1)))
           (##check-heap-limit)
           (##raise-nonprocedure-operator-exception oper args $code rte))
         (macro-call-step! (oper arg1)
           (oper arg1)))))))

(define ##cprc-app2-red
  (macro-make-cprc
   (let* ((oper (macro-code-run (^ 0)))
          (arg1 (macro-code-run (^ 1)))
          (arg2 (macro-code-run (^ 2))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
         (let ((args (##list arg1 arg2)))
           (##check-heap-limit)
           (##raise-nonprocedure-operator-exception oper args $code rte))
         (macro-call-step! (oper arg1 arg2)
           (oper arg1 arg2)))))))

(define ##cprc-app3-red
  (macro-make-cprc
   (let* ((oper (macro-code-run (^ 0)))
          (arg1 (macro-code-run (^ 1)))
          (arg2 (macro-code-run (^ 2)))
          (arg3 (macro-code-run (^ 3))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
         (let ((args (##list arg1 arg2 arg3)))
           (##check-heap-limit)
           (##raise-nonprocedure-operator-exception oper args $code rte))
         (macro-call-step! (oper arg1 arg2 arg3)
           (oper arg1 arg2 arg3)))))))

(define ##cprc-app4-red
  (macro-make-cprc
   (let* ((oper (macro-code-run (^ 0)))
          (arg1 (macro-code-run (^ 1)))
          (arg2 (macro-code-run (^ 2)))
          (arg3 (macro-code-run (^ 3)))
          (arg4 (macro-code-run (^ 4))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
         (let ((args (##list arg1 arg2 arg3 arg4)))
           (##check-heap-limit)
           (##raise-nonprocedure-operator-exception oper args $code rte))
         (macro-call-step! (oper arg1 arg2 arg3 arg4)
           (oper arg1 arg2 arg3 arg4)))))))

(define ##cprc-app-red
  (macro-make-cprc
   (let ((oper (macro-code-run (^ 0))))
     (let loop ((i 1) (rev-args '()))
       (if (##fixnum.< i (macro-code-length $code))
         (let ((new-rev-args
                (##cons (macro-code-run (macro-code-ref $code i)) rev-args)))
           (##check-heap-limit)
           (loop (##fixnum.+ i 1) new-rev-args))
         (let ((args (##reverse rev-args)))
           (macro-force-vars (oper)
             (if (##not (##procedure? oper))
               (##raise-nonprocedure-operator-exception oper args $code rte)
               (macro-call-step! (oper args)
                 (begin
                   (##first-argument $code rte);;;;;;;;;obsolete?
                   (##apply oper args)))))))))))

(define ##cprc-app0-sub
  (macro-make-cprc
   (let ((oper (macro-code-run (^ 0))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
         (##raise-nonprocedure-operator-exception oper '() $code rte)
         (##subproblem-apply0 $code rte oper))))))

(define ##cprc-app1-sub
  (macro-make-cprc
   (let* ((oper (macro-code-run (^ 0)))
          (arg1 (macro-code-run (^ 1))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
         (let ((args (##list arg1)))
           (##check-heap-limit)
           (##raise-nonprocedure-operator-exception oper args $code rte))
         (##subproblem-apply1 $code rte oper arg1))))))

(define ##cprc-app2-sub
  (macro-make-cprc
   (let* ((oper (macro-code-run (^ 0)))
          (arg1 (macro-code-run (^ 1)))
          (arg2 (macro-code-run (^ 2))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
         (let ((args (##list arg1 arg2)))
           (##check-heap-limit)
           (##raise-nonprocedure-operator-exception oper args $code rte))
         (##subproblem-apply2 $code rte oper arg1 arg2))))))

(define ##cprc-app3-sub
  (macro-make-cprc
   (let* ((oper (macro-code-run (^ 0)))
          (arg1 (macro-code-run (^ 1)))
          (arg2 (macro-code-run (^ 2)))
          (arg3 (macro-code-run (^ 3))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
         (let ((args (##list arg1 arg2 arg3)))
           (##check-heap-limit)
           (##raise-nonprocedure-operator-exception oper args $code rte))
         (##subproblem-apply3 $code rte oper arg1 arg2 arg3))))))

(define ##cprc-app4-sub
  (macro-make-cprc
   (let* ((oper (macro-code-run (^ 0)))
          (arg1 (macro-code-run (^ 1)))
          (arg2 (macro-code-run (^ 2)))
          (arg3 (macro-code-run (^ 3)))
          (arg4 (macro-code-run (^ 4))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
         (let ((args (##list arg1 arg2 arg3 arg4)))
           (##check-heap-limit)
           (##raise-nonprocedure-operator-exception oper args $code rte))
         (##subproblem-apply4 $code rte oper arg1 arg2 arg3 arg4))))))

(define ##cprc-app-sub
  (macro-make-cprc
   (let ((oper (macro-code-run (^ 0))))
     (let loop ((i 1) (rev-args '()))
       (if (##fixnum.< i (macro-code-length $code))
         (let ((new-rev-args
                (##cons (macro-code-run (macro-code-ref $code i)) rev-args)))
           (##check-heap-limit)
           (loop (##fixnum.+ i 1) new-rev-args))
         (let ((args (##reverse rev-args)))
           (macro-force-vars (oper)
             (if (##not (##procedure? oper))
               (##raise-nonprocedure-operator-exception oper args $code rte)
               (macro-call-step! (oper args)
                 (##subproblem-apply $code rte oper args))))))))))

(define ##generate-proper-tail-calls
  (##make-parameter #t))

(define generate-proper-tail-calls
  ##generate-proper-tail-calls)

(define ##gen-app-aux
  (macro-make-gen (stepper oper args)
    (if (and tail? (##generate-proper-tail-calls))
      (case (##length args)
        ((0)
         (macro-make-code ##cprc-app0-red
                          cte
                          src
                          stepper
                          (oper)))
        ((1)
         (macro-make-code ##cprc-app1-red
                          cte
                          src
                          stepper
                          (oper (##car args))))
        ((2)
         (macro-make-code ##cprc-app2-red
                          cte
                          src
                          stepper
                          (oper (##car args) (##cadr args))))
        ((3)
         (macro-make-code ##cprc-app3-red
                          cte
                          src
                          stepper
                          (oper (##car args) (##cadr args) (##caddr args))))
        ((4)
         (macro-make-code ##cprc-app4-red
                          cte
                          src
                          stepper
                          (oper (##car args) (##cadr args) (##caddr args) (##cadddr args))))
        (else
         (##make-code* ##cprc-app-red
                       cte
                       src
                       stepper
                       (##cons oper args)
                       0)))
      (case (##length args)
        ((0)
         (macro-make-code ##cprc-app0-sub
                          cte
                          src
                          stepper
                          (oper)))
        ((1)
         (macro-make-code ##cprc-app1-sub
                          cte
                          src
                          stepper
                          (oper (##car args))))
        ((2)
         (macro-make-code ##cprc-app2-sub
                          cte
                          src
                          stepper
                          (oper (##car args) (##cadr args))))
        ((3)
         (macro-make-code ##cprc-app3-sub
                          cte
                          src
                          stepper
                          (oper (##car args) (##cadr args) (##caddr args))))
        ((4)
         (macro-make-code ##cprc-app4-sub
                          cte
                          src
                          stepper
                          (oper (##car args) (##cadr args) (##caddr args) (##cadddr args))))
        (else
         (##make-code* ##cprc-app-sub
                       cte
                       src
                       stepper
                       (##cons oper args)
                       0))))))

(define ##gen-app
  (macro-make-gen (oper args)
    (let ((stepper (##current-stepper)))
      (macro-gen ##gen-app-aux src stepper oper args))))

(define ##gen-app-no-step
  (macro-make-gen (oper args)
    (let ((stepper (##no-stepper)))
      (macro-gen ##gen-app-aux src stepper oper args))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##subproblem-apply0
  (let ()
    (##declare (not inline) (not interrupts-enabled) (environment-map))
    (lambda ($code rte proc)
      (macro-call-step! (proc)
        (##first-argument
         (proc)
         $code
         rte)))))

(define ##subproblem-apply1
  (let ()
    (##declare (not inline) (not interrupts-enabled) (environment-map))
    (lambda ($code rte proc arg1)
      (macro-call-step! (proc arg1)
        (##first-argument
         (proc arg1)
         $code
         rte)))))

(define ##subproblem-apply2
  (let ()
    (##declare (not inline) (not interrupts-enabled) (environment-map))
    (lambda ($code rte proc arg1 arg2)
      (macro-call-step! (proc arg1 arg2)
        (##first-argument
         (proc arg1 arg2)
         $code
         rte)))))

(define ##subproblem-apply3
  (let ()
    (##declare (not inline) (not interrupts-enabled) (environment-map))
    (lambda ($code rte proc arg1 arg2 arg3)
      (macro-call-step! (proc arg1 arg2 arg3)
        (##first-argument
         (proc arg1 arg2 arg3)
         $code
         rte)))))

(define ##subproblem-apply4
  (let ()
    (##declare (not inline) (not interrupts-enabled) (environment-map))
    (lambda ($code rte proc arg1 arg2 arg3 arg4)
      (macro-call-step! (proc arg1 arg2 arg3 arg4)
        (##first-argument
         (proc arg1 arg2 arg3 arg4)
         $code
         rte)))))

(define ##subproblem-apply
  (let ()
    (##declare (not inline) (not interrupts-enabled) (environment-map))
    (lambda ($code rte proc args)
      (macro-call-step! (proc args)
        (##first-argument
         (##apply proc args)
         $code
         rte)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-delay
  (macro-make-cprc
   (macro-delay-step! ()
     (let ((promise (delay (macro-code-run (^ 0)))))
       (##check-heap-limit)
       (##first-argument promise $code rte)))))

(define ##gen-delay
  (macro-make-gen (val)
    (let ((stepper (##current-stepper)))
      (macro-make-code ##cprc-delay cte src stepper (val)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-future
  (macro-make-cprc
   (macro-future-step! ()
     (let ((promise (future (macro-code-run (^ 0)))))
       (##first-argument promise $code rte)))))

(define ##gen-future
  (macro-make-gen (val)
    (let ((stepper (##current-stepper)))
      (macro-make-code ##cprc-future cte src stepper (val)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-require
  (macro-make-cprc
   (let ((requirements (^ 1)))
     (##fulfill-requirements requirements)
     (macro-code-run (^ 0)))))

(define ##gen-require
  (macro-make-gen (val requirements)
    (let ((stepper (##no-stepper)))
      (macro-make-code ##cprc-require cte src stepper (val)
        requirements))))

;;;============================================================================

;;; Eval

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Evaluation in a top environment within the current continuation.

(define ##eval-module #f)
(set! ##eval-module
  (lambda (src top-cte)
    (let ((c (##compile-module top-cte (##sourcify src (##make-source #f #f)))))
      (let ((rte #f))
        (macro-code-run c)))))

(define ##eval-top #f)
(set! ##eval-top
  (lambda (src top-cte)
    (let ((c (##compile-top top-cte (##sourcify src (##make-source #f #f)))))
      (let ((rte #f))
        (macro-code-run c)))))

(define-prim (##eval expr #!optional env)
  (##eval-top (##sourcify expr (##make-source #f #f))
              ##interaction-cte))

(define-prim (eval expr #!optional env)
  (##eval expr env))

(define-prim (interaction-environment)
  'interaction-environment)

(define-prim (null-environment)
  'null-environment)

(define-prim (scheme-report-environment n)
  n)

;;;============================================================================

(define (##wrap-datum re x)
  (##make-source x (##make-locat-from-readenv re)))

(define (##unwrap-datum re x)
  (##source-code x))

(define (##read-expr-from-port port)
  (let ((re
         (##make-readenv port
                         (macro-character-port-input-readtable port)
                         ##wrap-datum
                         ##unwrap-datum
                         #f)))
    (##read-datum-or-eof re)))

(define (##load
         path
         script-callback
         clone-cte?
         raise-os-exception?
         #!optional
         (settings (macro-absent-obj)))

  (define (raise-os-exception-if-needed x)
    (if (and (##fixnum? x)
             raise-os-exception?)
      (##raise-os-exception #f x load path settings)
      x))

  (define (load-source source-path)
    (let ((x
           (##read-all-as-a-begin-expr-from-path
            source-path
            (##current-readtable)
            ##wrap-datum
            ##unwrap-datum)))
      (if (##fixnum? x)
        x
        (begin
          (script-callback (##vector-ref x 0) (##vector-ref x 2))
          (##eval-module (##vector-ref x 1)
                         (if clone-cte?
                           (##top-cte-clone ##interaction-cte)
                           ##interaction-cte))
          (##vector-ref x 2)))))

  (define (load-binary abs-path)

    (##define-macro (module-prefix)
      c#module-prefix)

    (let* ((module-name
            (##string-append
             (module-prefix)
             (##path-strip-directory abs-path)))
           (result
            (##os-load-object-file abs-path module-name)))
      (cond ((##fixnum? result)
             (##raise-os-exception #f result load path settings))
            ((##string? result)
             (##raise-os-exception result #f load path settings))
            (else
             (let ((exec-vector (##vector-ref result 0))
                   (undefined (##vector-ref result 1))
                   (script-line (##vector-ref result 2)))
               (let loop ((lst (##reverse undefined)))
                 (if (##pair? lst)
                   (let ((var-module (##car lst)))
                     (##repl
                      (lambda (first output-port)
                        (##write-string "*** WARNING -- Variable " output-port)
                        (##write (##car var-module) output-port)
                        (##write-string " used in module " output-port)
                        (##write (##cdr var-module) output-port)
                        (##write-string " is undefined" output-port)
                        (##newline output-port)
                        #t))
                     (loop (##cdr lst)))))
               (script-callback script-line abs-path)
               (##execute-modules exec-vector 0)
               abs-path)))))

  (define (load-no-ext)
    (let* ((source-path (##path-expand path))
           (result (load-source source-path)))
      (if (##not (##fixnum? result))
        result
        (let loop1 ((version 1) (last-expanded-path #f))
          (let ((expanded-path
                 (##path-expand
                  (##string-append path
                                   ".o"
                                   (##number->string version 10)))))
            (if (##file-exists? expanded-path)
              (loop1 (##fixnum.+ version 1)
                     expanded-path)
              (if last-expanded-path
                (load-binary last-expanded-path)
                (let loop2 ((lst ##scheme-file-extensions))
                  (if (##pair? lst)
                    (let* ((source-path
                            (##path-expand (##string-append path (##caar lst))))
                           (x
                            (load-source source-path)))
                      (if (##fixnum? x)
                        (loop2 (##cdr lst))
                        x))
                    (raise-os-exception-if-needed result))))))))))

  (define (binary-extension? ext)
    (let ((len (##string-length ext)))
      (and (##fixnum.< 2 len)
           (##char=? (##string-ref ext 0) #\.)
           (##char=? (##string-ref ext 1) #\o)
           (let ((c (##string-ref ext 2)))
             (and (##char>=? c #\1) (##char<=? c #\9)
                  (let loop ((i (##fixnum.- len 1)))
                    (if (##fixnum.< i 3)
                      #t
                      (let ((c (##string-ref ext i)))
                        (and (##char>=? c #\0) (##char<=? c #\9)
                             (loop (##fixnum.- i 1)))))))))))

  (let ((ext (##path-extension path)))
    (cond ((##string=? ext "")
           (load-no-ext))
          ((binary-extension? ext)
           (let ((expanded-path (##path-expand path)))
             (load-binary expanded-path)))
          (else
           (raise-os-exception-if-needed (load-source path))))))

(define (load
         path
         #!optional
         (settings (macro-absent-obj)))
  (macro-force-vars (path settings)
    (macro-check-string path 1 (load path settings)
      (##load path
              (lambda (script-line script-path) #f)
              #t
              #t
              settings))))

;;;----------------------------------------------------------------------------

;;; Syntactic aliases.

(define-runtime-syntax quote
  (##make-alias-syntax '##quote))

(define-runtime-syntax quasiquote
  (##make-alias-syntax '##quasiquote))

(define-runtime-syntax set!
  (##make-alias-syntax '##set!))

(define-runtime-syntax lambda
  (##make-alias-syntax '##lambda))

(define-runtime-syntax if
  (##make-alias-syntax '##if))

(define-runtime-syntax cond
  (##make-alias-syntax '##cond))

(define-runtime-syntax and
  (##make-alias-syntax '##and))

(define-runtime-syntax or
  (##make-alias-syntax '##or))

(define-runtime-syntax case
  (##make-alias-syntax '##case))

(define-runtime-syntax let
  (##make-alias-syntax '##let))

(define-runtime-syntax let*
  (##make-alias-syntax '##let*))

(define-runtime-syntax letrec
  (##make-alias-syntax '##letrec))

(define-runtime-syntax do
  (##make-alias-syntax '##do))

(define-runtime-syntax delay
  (##make-alias-syntax '##delay))

(define-runtime-syntax future
  (##make-alias-syntax '##future))

(define-runtime-syntax c-define-type
  (##make-alias-syntax '##c-define-type))

(define-runtime-syntax c-declare
  (##make-alias-syntax '##c-declare))

(define-runtime-syntax c-initialize
  (##make-alias-syntax '##c-initialize))

(define-runtime-syntax c-lambda
  (##make-alias-syntax '##c-lambda))

(define-runtime-syntax c-define
  (##make-alias-syntax '##c-define))

(define-runtime-syntax begin
  (##make-alias-syntax '##begin))

(define-runtime-syntax define
  (##make-alias-syntax '##define))

(define-runtime-syntax define-macro
  (##make-alias-syntax '##define-macro))

;;(define-runtime-syntax define-syntax
;;  (##make-alias-syntax '##define-syntax))

(define-runtime-syntax include
  (##make-alias-syntax '##include))

(define-runtime-syntax declare
  (##make-alias-syntax '##declare))

(define-runtime-syntax namespace
  (##make-alias-syntax '##namespace))

(define-runtime-syntax this-source-file
  (##make-alias-syntax '##this-source-file))

;;;============================================================================
