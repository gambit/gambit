;;;============================================================================

;;; File: "_eval.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;(##define-macro (macro-step! leapable? handler-index vars . body) `(let () ,@body)) ;; disable single-stepping

;;;============================================================================

;;; Implementation of exceptions.

(implement-library-type-expression-parsing-exception)

(define-prim (##raise-expression-parsing-exception kind source . parameters)
  (macro-abort
   (macro-make-expression-parsing-exception kind source parameters)))

(implement-library-type-unbound-global-exception)

(define-prim (##raise-unbound-global-exception code rte variable)
  (macro-raise
   (macro-make-unbound-global-exception code rte variable)))

;;;----------------------------------------------------------------------------

(define (##make-code* code-prc cte src stepper lst n)
  (let ((code (##make-vector (##fx+ (##length lst) (##fx+ n 5)) #f)))
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
            (loop (##fx+ i 1) (##cdr l)))
          code))))

(define (##no-stepper) (macro-make-no-stepper))

(define ##main-stepper (##no-stepper))

(define-prim (##main-stepper-set! x)
  (set! ##main-stepper x))

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
      (##sourcify-aux2 x src)))

(define (##sourcify-aux1 code src)
  (##vector ##source1-marker
            code
            (##vector-ref src 2)
            (##vector-ref src 3)))

(define (##sourcify-aux2 code src)
  (##vector ##source2-marker
            code
            (##vector-ref src 2)
            (##vector-ref src 3)))

(define (##sourcify-deep x src)
  (let ((visited (##make-table 0 (macro-absent-obj) #f #f ##eq?)))

    (define not-yet-visited                      0)
    (define children-being-visited               1)
    (define not-part-of-a-cycle-and-maybe-shared 2)
    (define not-part-of-a-cycle-and-is-shared    3)
    (define part-of-a-cycle                      4)

    (define (visit obj begin?)
      (let ((x (##table-ref visited obj not-yet-visited)))
        (if (##fx= x not-yet-visited)
            (begin
              (##table-set! visited obj children-being-visited)
              #t)
            (let ((s (cond ((##fx= x children-being-visited)
                            (if begin?
                                part-of-a-cycle
                                not-part-of-a-cycle-and-maybe-shared))
                           ((##fx= x not-part-of-a-cycle-and-maybe-shared)
                            not-part-of-a-cycle-and-is-shared)
                           (else
                            x))))
              (##table-set! visited obj s)
              #f))))

    (define (visit-begin obj)
      (visit obj #t))

    (define (visit-end obj)
      (visit obj #f))

    (define (analyze-pair p)
      (and (visit-begin p)
           (begin
             (analyze (##car p))
             (analyze-list (##cdr p))
             (visit-end p))))

    (define (analyze-list lst)
      (cond ((##pair? lst)
             (analyze-pair lst))
            ((##not (##null? lst)))
             (analyze lst)))

    (define (analyze-vector v)
      (and (visit-begin v)
           (let loop ((i (##fx- (##vector-length v) 1)))
             (if (##fx< i 0)
                 (visit-end v)
                 (begin
                   (analyze (##vector-ref v i))
                   (loop (##fx- i 1)))))))

    (define (analyze-box b)
      (and (visit-begin b)
           (begin
             (analyze (##unbox b))
             (visit-end b))))

    (define (analyze x)
      (cond ((##source? x)
             (and (visit-begin x)
                  (begin
                    (analyze (##source-code x))
                    (visit-end x))))
            ((##pair? x)
             (analyze-pair x))
            ((##vector? x)
             (analyze-vector x))
            ((##box? x)
             (analyze-box x))
            (else
             x)))

    (define (sourcify-deep-pair p src)
      (let* ((a (##car p))
             (d (##cdr p))
             (sa (sourcify-deep a src))
             (sd (sourcify-deep-list d src)))
        (if (and (##eq? a sa) (##eq? d sd))
            p
            (##cons sa sd))))

    (define (sourcify-deep-list lst src)
      (cond ((##pair? lst)
             (let ((shared-lst (##table-ref visited lst not-yet-visited)))
               (if (##not (##fixnum? shared-lst))
                   (##source-code shared-lst)
                   (if (shared? shared-lst)
                       (##source-code (sourcify-deep lst src))
                       (sourcify-deep-pair lst src)))))
            ((##null? lst)
             '())
            (else
             (sourcify-deep lst src))))

    (define (sourcify-deep-vector v src)
      (let* ((len (##vector-length v))
             (new-v (##make-vector len 0))
             (same? #t))
        (let loop ((i (##fx- len 1)))
          (if (##fx< i 0)
              (if same? v new-v)
              (let ((s (sourcify-deep (##vector-ref v i) src)))
                (if (##not (##eq? s (##vector-ref v i)))
                    (set! same? #f))
                (##vector-set! new-v i s)
                (loop (##fx- i 1)))))))

    (define (sourcify-deep-box b src)
      (let* ((val (##unbox b))
             (new-val (sourcify-deep val src)))
        (if (##eq? new-val val)
            b
            (##box new-val))))

    (define (sourcify-deep-aux x src)
      (cond ((##pair? x)
             (sourcify-deep-pair x src))
            ((##vector? x)
             (sourcify-deep-vector x src))
            ((##box? x)
             (sourcify-deep-box x src))
            (else
             x)))

    (define (shared? state)
      (##fx>= state not-part-of-a-cycle-and-is-shared))

    (define (sourcify-deep x src)
      (let ((shared-x (##table-ref visited x not-yet-visited)))
        (if (##not (##fixnum? shared-x))
            shared-x
            (if (##source? x)
                (let* ((code (##source-code x))
                       (shared-code (##table-ref visited code not-yet-visited)))
                  (if (##not (##fixnum? shared-code))
                      shared-code
                      (if (or (shared? shared-x)
                              (shared? shared-code))
                          (let ((wrapper (##sourcify-aux1 #f x)))
                            (##table-set! visited x wrapper)
                            (##table-set! visited code wrapper)
                            (let ((code2 (sourcify-deep-aux code x)))
                              (##source-code-set! wrapper code2))
                            wrapper)
                          (let ((code2 (sourcify-deep-aux code x)))
                            (if (##eq? code2 code)
                                x
                                (##sourcify-aux1 code2 x))))))
                (if (shared? shared-x)
                    (let ((wrapper (##sourcify-aux1 #f src)))
                      (##table-set! visited x wrapper)
                      (let ((code2 (sourcify-deep-aux x src)))
                        (##source-code-set! wrapper code2))
                      wrapper)
                    (let ((code2 (sourcify-deep-aux x src)))
                      (##sourcify-aux1 code2 src)))))))

    (analyze x) ;; determine if there is sharing or cycles

    (sourcify-deep x src)))

(define (##source? x)
  (and (##vector? x)
       (##fx< 0 (##vector-length x))
       (let ((y (##vector-ref x 0)))
         (and (##vector? y)
              (##fx= 1 (##vector-length y))
              (let ((z (##vector-ref y 0)))
                (or (##eq? z 'source1)
                    (##eq? z 'source2)))))))

(define (##source-code src)
  (##vector-ref src 1))

(define (##source-code-set! src code)
  (##vector-set! src 1 code))

(define (##source-locat src)
  (let ((container (##vector-ref src 2)))
    (if container
        (##make-locat container
                      (##vector-ref src 3))
        #f)))

(define (##source-path src)
  (let ((locat
         (##source-locat src)))
    (and locat
         (##container->path (##locat-container locat)))))

(define (##desourcify src)
  (let ((visited (##make-table 0 (macro-absent-obj) #f #f ##eq?)))

    (define (share x)
      (##table-ref visited x #f))

    (define (desourcify-pair p)
      (or (share p)
          (let ((new-p (##cons #f #f)))
            (##table-set! visited p new-p)
            (##set-car! new-p (desourcify (##car p)))
            (##set-cdr! new-p (desourcify-list (##cdr p)))
            new-p)))

    (define (desourcify-list lst)
      (cond ((##pair? lst)
             (desourcify-pair lst))
            ((##null? lst)
             '())
            (else
             (desourcify lst))))

    (define (desourcify-vector v)
      (or (share v)
          (let* ((len (##vector-length v))
                 (new-v (##make-vector len 0)))
            (##table-set! visited v new-v)
            (let loop ((i (##fx- len 1)))
              (if (##fx< i 0)
                  new-v
                  (begin
                    (##vector-set! new-v i (desourcify (##vector-ref v i)))
                    (loop (##fx- i 1))))))))

    (define (desourcify-box b)
      (or (share b)
          (let ((new-b (##box #f)))
            (##table-set! visited b new-b)
            (##set-box! new-b (desourcify (##unbox b)))
            new-b)))

    (define (desourcify src)
      (if (##source? src)
          (let ((code (##source-code src)))
            (if (##eq? (##vector-ref (##vector-ref src 0) 0) 'source2)
                code
                (cond ((##pair? code)
                       (desourcify-list code))
                      ((##vector? code)
                       (desourcify-vector code))
                      ((##box? code)
                       (desourcify-box code))
                      (else
                       code))))
          src))

    (desourcify src)))

(define (##make-alias-syntax alias)
  (lambda (src)
    (let ((locat (##source-locat src)))
      (##make-source
       (##cons (##make-source alias locat)
               (##cdr (##source-code src)))
       locat))))

;;;----------------------------------------------------------------------------

;; A "locat" object represents a source code location.  The location
;; is a 2 element vector composed of the container of the source code
;; (a file, a text editor window, etc) and a position within that
;; container (a character offset, a line/column index, a text
;; bookmark, an expression, etc).
;;
;; Source code location containers and positions can be encoded with
;; any concrete type, except that positions cannot be pairs.  The
;; procedure "##container->path" takes a container object and returns
;; #f if the container does not denote a file, otherwise it returns the
;; absolute path of the file as a string.  The procedure
;; "##container->id" takes a container object and returns a string that
;; can be used to identify the container when it is not a file
;; (e.g. the name of a text editor window).  The procedure
;; "##position->filepos" takes a position object and returns a fixnum
;; encoding the line and column position (see function ##make-filepos).

(define-prim (##readenv->locat re)
  (let ((container
         (or (macro-readenv-container re)
             (let ((c
                    (##port-name->container
                     (##port-name (macro-readenv-port re)))))
               (macro-readenv-container-set! re c)
               c))))
    (##make-locat container
                  (##filepos->position
                   (macro-readenv-filepos re)))))

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

(define-prim (##port-name->container port-name)
  ;; port-name is an arbitrary object and result is an arbitrary object
  (if (##string? port-name)
      (##path->container port-name)
      port-name))

(define ##path->container-hook #f)

(define-prim (##path->container-hook-set! x)
  (set! ##path->container-hook #f))

(define-prim (##path->container path)
  ;; path is a string and result is an arbitrary object
  (let ((hook ##path->container-hook))
    (or (and (##procedure? hook)
             (hook path))
        path)))

(define ##container->path-hook #f)

(define-prim (##container->path-hook-set! x)
  (set! ##container->path-hook #f))

(define-prim (##container->path container)
  ;; container is an arbitrary object and result must be a string or #f
  (let ((x
         (let ((hook ##container->path-hook))
           (or (and (##procedure? hook)
                    (hook container))
               container))))
    (cond ((##string? x)
           x)
          (else
           #f))))

(define ##container->id-hook #f)

(define-prim (##container->id-hook-set! x)
  (set! ##container->id-hook x))

(define-prim (##container->id container)
  ;; container is an arbitrary object and result must be a string
  (let ((x
         (let ((hook ##container->id-hook))
           (and (##procedure? hook)
                (hook container)))))
    (cond ((##string? x)
           x)
          (else
           (##object->string container)))))

(define-prim (##position->filepos position)
  (cond ((##fixnum? position)
         position)
        (else
         0)))

(define-prim (##filepos->position filepos)
  filepos)

;;;============================================================================

;;; Compiler

;;;----------------------------------------------------------------------------

;;; Compile time environments

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of local variables (up and over) and global variables.

(##define-macro (mk-loc-access src var up over) `(##vector ,var ,up ,over))
(##define-macro (loc-access? x) `(##vector? ,x))
(##define-macro (loc-access-var x) `(##vector-ref ,x 0))
(##define-macro (loc-access-up x) `(##vector-ref ,x 1))
(##define-macro (loc-access-over x) `(##vector-ref ,x 2))

(##define-macro (mk-glo-access src id)
  `(##make-global-var ,id))

(##define-macro (glo-access? x)
  `(##not (##vector? ,x)))

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
  (##fx= (##vector-length cte) 1))

(define (##cte-top-cte cte)
  (##vector-ref cte 0))

(define (##cte-top-cte-set! cte new-cte)
  (##vector-set! cte 0 new-cte))

(define (##cte-parent-cte cte)
  (##vector-ref cte 0))

(define (##cte-frame parent-cte vars)
  (##vector parent-cte vars))

(define (##cte-frame? cte)
  (##fx= (##vector-length cte) 2))

(define (##cte-frame-vars cte)
  (##vector-ref cte 1))

(define (##cte-frame-i parent-cte vars)
  (##cte-frame parent-cte
               vars)) ;; equivalent to: (map ##var-i vars)

(define (##var-i name)
  name)

(define (##var-i? x)
  (##not (##pair? x)))

(define (##var-i-name x)
  x)

(define (##var-c name boxed?)
  (##cons name boxed?))

(define (##var-c? x)
  (##pair? x))

(define (##var-c-name x)
  (##car x))

(define (##var-c-boxed? x)
  (##cdr x))

(define (##cte-macro parent-cte name descr)
  (##vector parent-cte name descr))

(define (##cte-macro? cte)
  (and (##fx= (##vector-length cte) 3)
       (##not (##string? (##vector-ref cte 1))))) ;; distinguish from namespace

(define (##cte-macro-name cte)
  (##vector-ref cte 1))

(define (##cte-macro-descr cte)
  (##vector-ref cte 2))

(define (##cte-decl parent-cte name value)
  (##vector parent-cte name value #f))

(define (##cte-decl? cte)
  (##fx= (##vector-length cte) 4))

(define (##cte-decl-name cte)
  (##vector-ref cte 1))

(define (##cte-decl-value cte)
  (##vector-ref cte 2))

(define (##cte-namespace parent-cte prefix aliases)
  (##vector parent-cte prefix aliases))

(define (##cte-namespace? cte)
  (and (##fx= (##vector-length cte) 3)
       (##string? (##vector-ref cte 1)))) ;; distinguish from macro

(define (##cte-namespace-prefix cte)
  (##vector-ref cte 1))

(define (##cte-namespace-aliases cte)
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
            ((##cte-decl? cte)
             (##cte-decl new-parent-cte
                         (##cte-decl-name cte)
                         (##cte-decl-value cte)))
            ((##cte-namespace? cte)
             (##cte-namespace new-parent-cte
                              (##cte-namespace-prefix cte)
                              (##cte-namespace-aliases cte))))
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

(define (##cte-add-namespace parent-cte prefix aliases)

  (define (replace cte)
    (cond ((##cte-top? cte)
           #f)
          ((##cte-namespace? cte)
           (if (##pair? (##cte-namespace-aliases cte))
               (replace (##cte-parent-cte cte))
               (##cte-namespace (##cte-parent-cte cte) prefix aliases)))
          (else
           #f))) ;; don't go beyond a frame, macro definition or declaration

  (if (##pair? aliases)
      (##cte-namespace parent-cte prefix aliases)
      (or (replace parent-cte)
          (##cte-namespace parent-cte prefix aliases))))

(define (##check-namespace src)
  (let ((code (##source-code src)))
    (let loop1 ((forms (##cdr code)))
      (cond ((##pair? forms)
             (let* ((form-src (##sourcify (##car forms) src))
                    (form (##source-code form-src)))
               (if (##not (##pair? form))
                   (##raise-expression-parsing-exception
                    'ill-formed-namespace
                    form-src)
                   (let* ((space-src (##sourcify (##car form) form-src))
                          (space (##source-code space-src)))
                     (if (##not (##string? space))
                         (##raise-expression-parsing-exception
                          'namespace-prefix-must-be-string
                          space-src)
                         (if (##not (##valid-prefix? space))
                             (##raise-expression-parsing-exception
                              'ill-formed-namespace-prefix
                              space-src)
                             (let loop2 ((lst (##cdr form)))
                               (cond ((##pair? lst)
                                      (let* ((alias-src
                                              (##sourcify (##car lst) form-src))
                                             (alias
                                              (##source-code alias-src)))
                                        (if (##not (or (##symbol? alias)
                                                       (and (##pair? alias)
                                                            (##pair? (##cdr alias))
                                                            (##null? (##cddr alias))
                                                            (##symbol?
                                                             (##source-code
                                                              (##sourcify (##car alias) form-src)))
                                                            (##symbol?
                                                             (##source-code
                                                              (##sourcify (##cadr alias) form-src))))))

                                            (##raise-expression-parsing-exception

                                             'ill-formed-namespace
                                             form-src))
                                        (loop2 (##cdr lst))))
                                     ((##not (##null? lst))
                                      (##raise-expression-parsing-exception
                                       'ill-formed-namespace
                                       form-src))
                                     (else
                                      (loop1 (##cdr forms)))))))))))
            ((##not (##null? forms))
             (##raise-expression-parsing-exception
              'ill-formed-namespace
              src))))))

(define (##cte-process-declare parent-cte src)
  (let ((decls (##cdr (##desourcify src))))
    (let loop ((cte parent-cte) (decls decls))
      (if (##pair? decls)
          (let ((decl (##car decls)))
            (if (##pair? decl)
                (let ((d (##car decl)))
                  (cond ((and (##eq? d 'proper-tail-calls)
                              (##null? (##cdr decl)))
                         (loop (##cte-decl cte 'proper-tail-calls #t)
                               (##cdr decls)))
                        ((and (##eq? d 'not)
                              (##pair? (##cdr decl))
                              (##eq? (##cadr decl) 'proper-tail-calls)
                              (##null? (##cddr decl)))
                         (loop (##cte-decl cte 'proper-tail-calls #f)
                               (##cdr decls)))
                        (else
                         (loop cte
                               (##cdr decls)))))
                (loop cte
                      (##cdr decls))))
          cte))))

(define (##cte-process-namespace parent-cte src)
  (##check-namespace src)
  (let ((forms (##cdr (##desourcify src))))
    (let loop ((cte parent-cte) (forms forms))
      (if (##pair? forms)
          (let ((form (##car forms)))
            (loop (##cte-add-namespace
                   cte
                   (##car form)
                   (##map (lambda (x)
                            (if (##symbol? x)
                                (##cons x x)
                                (##cons (##car x) (##cadr x))))
                          (##cdr form)))
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
  (let loop1 ((name name) (full? (##full-name? name)) (cte cte) (up 0))
    (if (##cte-top? cte)
        (##vector 'not-found name)
        (let ((parent-cte (##cte-parent-cte cte)))
          (cond ((##cte-frame? cte)
                 (let loop2 ((vars (##cte-frame-vars cte))
                             (over 1))
                   (if (##pair? vars)
                       (let ((var (##car vars)))
                         (if (##eq? name (if (##var-i? var)
                                             (##var-i-name var)
                                             (##var-c-name var)))
                             (##vector 'var var up over)
                             (loop2 (##cdr vars)
                                    (##fx+ over 1))))
                       (loop1 name full? parent-cte (##fx+ up 1)))))
                ((##cte-macro? cte)
                 (if (##eq? name (##cte-macro-name cte))
                     (##vector 'macro name (##cte-macro-descr cte))
                     (loop1 name full? parent-cte up)))
                ((and (##not full?) (##cte-namespace? cte))
                 (let ((full-name (##cte-namespace-lookup cte name)))
                   (if full-name
                       (loop1 full-name #t parent-cte up)
                       (loop1 name #f parent-cte up))))
                (else
                 (loop1 name full? parent-cte up)))))))

(define (##cte-global-macro-name cte name)
  (if (##full-name? name)
      name
      (let loop ((cte cte))
        (if (##cte-top? cte)
            name
            (let ((parent-cte (##cte-parent-cte cte)))
              (cond ((##cte-namespace? cte)
                     (let ((full-name (##cte-namespace-lookup cte name)))
                       (or full-name
                           (loop parent-cte))))
                    (else
                     (loop parent-cte))))))))

(define (##cte-namespace-lookup cte name)
  (let ((aliases (##cte-namespace-aliases cte)))
    (if (##null? aliases)
        (##make-full-name (##cte-namespace-prefix cte) name)
        (let ((a (##assq name aliases)))
          (if a
              (##make-full-name (##cte-namespace-prefix cte) (##cdr a))
              #f)))))

(define ##namespace-separators '(#\#))

(define-prim (##namespace-separators-set! x)
  (set! ##namespace-separators x))

(define (##full-name? sym) ;; full name if it contains a namespace separator
  (let ((str (##symbol->string sym)))
    (let loop ((i (##fx- (##string-length str) 1)))
      (if (##fx< i 0)
          #f
          (if (##memq (##string-ref str i) ##namespace-separators)
              #t
              (loop (##fx- i 1)))))))

(define (##make-full-name prefix sym)
  (if (##fx= (##string-length prefix) 0)
      sym
      (##string->symbol (##string-append prefix (##symbol->string sym)))))

(define (##valid-prefix? str)

  ;; non-null name followed by a namespace separator at end is
  ;; valid as is the special prefix ""

  (let ((l (##string-length str)))
    (or (##fx= l 0)
        (and (##not (##fx< l 2))
             (##memq (##string-ref str (##fx- l 1))
                     ##namespace-separators)))))

(define (##var-lookup cte src)
  (let* ((name (##source-code src))
         (ind (##cte-lookup cte name)))
    (case (##vector-ref ind 0)
      ((not-found)
       (let ((var (##vector-ref ind 1)))
         (mk-glo-access src var)))
      ((var)
       (let ((var (##vector-ref ind 1))
             (up (##vector-ref ind 2))
             (over (##vector-ref ind 3)))
         (mk-loc-access src var up over)))
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

(define-prim (##macro-lookup cte name)
  (and (##symbol? name)
       (let ((ind (##cte-lookup cte name)))
         (case (##vector-ref ind 0)
           ((macro)
            (##vector-ref ind 2))
           (else
            #f)))))

(define-prim (##macro-lookup-set! x)
  (set! ##macro-lookup x))

(define-prim (##macro-expand cte src descr)
  (##shape src src (##macro-descr-size descr))
  (##sourcify
   (if (##macro-descr-def-syntax? descr)
       ((##macro-descr-expander descr) src)
       (##apply (##macro-descr-expander descr)
                (##cdr (##desourcify src))))
   src))

(define-prim (##macro-expand-set! x)
  (set! ##macro-expand x))

(define-prim (##macro-descr src def-syntax?)

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
            (err)))))

(define-prim (##macro-descr-set! x)
  (set! ##macro-descr x))

(define (##form-size parms-src)
  (let ((parms (##source-code parms-src)))
    (let loop ((lst parms) (n 1))
      (cond ((##pair? lst)
             (let ((parm (##source-code (##sourcify (##car lst) parms-src))))
               (if (##memq parm '(#!optional #!key #!rest))
                   (##fx- 0 n)
                   (loop (##cdr lst)
                         (##fx+ n 1)))))
            ((##null? lst)
             n)
            (else
             (##fx- 0 n))))))

(define (##cte-lookup-decl cte name default-value)
  (##declare (inlining-limit 500)) ;; inline CTE access procedures
  (let loop ((cte cte))
    (if (##cte-top? cte)
        default-value
        (let ((parent-cte (##cte-parent-cte cte)))
          (if (and (##cte-decl? cte)
                   (##eq? name (##cte-decl-name cte)))
              (##cte-decl-value cte)
              (loop parent-cte))))))

(define (##tail-call? cte tail?)
  (and tail?
       (##cte-lookup-decl cte 'proper-tail-calls #t)))

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
                ))
      (##vector? val)
      (##u8vector? val)
      (##s8vector? val)
      (##u16vector? val)
      (##s16vector? val)
      (##u32vector? val)
      (##s32vector? val)
      (##u64vector? val)
      (##s64vector? val)
      (##f32vector? val)
      (##f64vector? val)))

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
            (if (##fx< 0 size)
                (##not (##fx= n size))
                (##fx< n (##fx- 0 size))))
        (##raise-expression-parsing-exception
         'ill-formed-special-form
         src
         (let* ((code (##source-code src))
                (head (##source-code (##sourcify (##car code) src)))
                (name (##symbol->string head))
                (len (##string-length name)))
           (if (and (##fx< 2 len)
                    (##char=? #\# (##string-ref name 0))
                    (##char=? #\# (##string-ref name 1)))
               (##string->symbol (##substring name 2 len))
               head))))))

(define (##proper-length lst)
  (let loop ((lst lst) (n 0))
    (cond ((##pair? lst) (loop (##cdr lst) (##fx+ n 1)))
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
                     (##container->path (##locat-container locat)))))
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

(define-prim (##expand-source src)
  src)

(define-prim (##expand-source-set! x)
  (set! ##expand-source x))

(define (##compile-module top-cte src)
  (##compile-in-compilation-scope
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
  (##compile-in-compilation-scope
   top-cte
   src
   #f
   (lambda (cte src tail?)
     (let ((tail? #f))
       (##comp-top top-cte src tail?)))))

(define (##compile-inner cte src)
  (##compile-in-compilation-scope
   cte
   src
   #f
   (lambda (cte src tail?)
     (macro-gen ##gen-top src
       (##comp-inner
        (##cte-frame-i cte (##list (macro-self-var)))
        src
        tail?)))))

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
        (if (##fx< i n)
            (let ((x (macro-code-ref code i)))
              (if (macro-is-child-code? x code)
                  (begin
                    (convert! container x)
                    (loop (##fx+ i 1)))))))))

  (convert! #f code)
  code)

(define ##compilation-scope
  (##make-parameter #f))

(define (##compile-in-compilation-scope cte src tail? proc)
  (let* ((src
          (##expand-source src))
         (x
          (##in-new-compilation-scope
           (lambda ()
             (proc cte src tail?))))
         (code
          (##car x))
         (comp-scope
          (##cdr x))
         (required-modules
          (##table-ref comp-scope 'required-modules '())))

    (define (add-loading-of-required-modules required-modules code)
      (if (##pair? required-modules)

          (let ((module-ref (##car required-modules)))
            (macro-gen ##gen-seq src
              (macro-gen ##gen-app-no-step src
                (macro-gen ##gen-glo-ref src
                  (##make-global-var '##load-required-module))
                (##list (macro-gen ##gen-cst-no-step src
                          module-ref)))
              (add-loading-of-required-modules
               (##cdr required-modules)
               code)))

          code))

    (##convert-source-to-locat!
     (add-loading-of-required-modules required-modules code))))

(define (##in-new-compilation-scope thunk)
  (let* ((comp-scope
          (##make-table 0 (macro-absent-obj) #f #f ##eq?))
         (result
          (##parameterize
           ##compilation-scope
           comp-scope
           thunk)))
    (##cons result
            comp-scope)))

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

(define-prim (##add-import-requirement lib-name)
  (let ((comp-scope (##compilation-scope)))
    (##table-set!
     comp-scope
     'imports
     (##cons lib-name
             (##table-ref comp-scope 'imports '())))
    #f))

(define-prim (##add-import-requirement-set! x)
  (set! ##add-import-requirement x))

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

(define-prim (##generate-library-prelude lib)
  lib)

(define-prim (##generate-library-prelude-set! x)
  (set! ##generate-library-prelude x))

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
;;;                ((library ##library) (##comp-top-library top-cte src tail?))
;;;                ((export ##export)   (##comp-top-export top-cte src tail?))
;;;                ((import ##import)   (##comp-top-import top-cte src tail?))
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
        (##comp-subexpr cte val #f)))))

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

(define (##comp-inner cte src tail?)
  (##comp-expr cte src tail? #f))

(define (##comp-subexpr cte src tail?)
  (##comp-expr cte src tail? #t))

(define (##comp-expr cte src tail? subexpr?)
  (let ((code (##source-code src)))
    (if (##pair? code)
        (let* ((first-src (##sourcify (##car code) src))
               (first (##source-code first-src))
               (descr (##macro-lookup cte first)))
          (if descr
              (##comp-expr cte (##macro-expand cte src descr) tail? subexpr?)
              (case first
                ((##begin)
                 (##comp-begin cte src tail? subexpr?))
                ((##define)
                 (##comp-define cte src tail? subexpr?))
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
;;;                ((library ##library)
;;;                 (##raise-expression-parsing-exception
;;;                  'ill-placed-library
;;;                  src))
;;;                ((export ##export)
;;;                 (##raise-expression-parsing-exception
;;;                  'ill-placed-export
;;;                  src))
;;;                ((import ##import)
;;;                 (##raise-expression-parsing-exception
;;;                  'ill-placed-import
;;;                  src))
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

(define (##comp-define cte src tail? subexpr?)
  (let* ((name (##definition-name src))
         (val (##definition-value src))
         (ind (##var-lookup cte name)))
    (if (or subexpr?
            (##not ##allow-inner-global-define?)
            (##not (glo-access? ind)))
      (##raise-expression-parsing-exception
       'ill-placed-define
       src)
      (begin
        (##variable name)
        (if (##not (##eq? ##allow-inner-global-define? #t))
            (##repl
             (lambda (first output-port)
               (##write-string "*** WARNING -- defining global variable: " output-port)
               (##write (##source-code name) output-port)
               (##newline output-port)
               #t)))
        (macro-gen ##gen-glo-def src
          ind
          (##comp-subexpr cte val #f))))))

(define ##allow-inner-global-define? 'warn)

(define-prim (##allow-inner-global-define?-set! x)
  (set! ##allow-inner-global-define? x))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-begin cte src tail? subexpr?)
  (##shape src src -2)
  (let ((code (##source-code src)))
    (##comp-seq cte src tail? subexpr? (##cdr code))))

(define (##comp-seq cte src tail? subexpr? seq)
  (if (##pair? seq)
      (##comp-seq-aux cte src tail? subexpr? seq)
      (macro-gen ##gen-cst-no-step src
        (##void))))

(define (##comp-seq-aux cte src tail? subexpr? seq)
  (let ((first-src (##sourcify (##car seq) src))
        (rest (##cdr seq)))
    (if (##pair? rest)
        (let ((code (##source-code first-src)))
          (macro-gen ##gen-seq first-src
            (##comp-expr cte first-src #f subexpr?)
            (##comp-seq-aux cte src tail? subexpr? rest)))
        (##comp-expr cte first-src tail? subexpr?))))

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
    ((##letrec*)
     (##comp-letrec* cte src tail?))
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
    (else
     (##comp-app cte src tail?))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-ref cte src tail?)
  (##variable src)
  (let ((x (##var-lookup cte src)))
    (if (loc-access? x)
        (let ((var (loc-access-var x))
              (up (loc-access-up x))
              (over (loc-access-over x)))
          (macro-gen ##gen-loc-ref src
            var
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
                           (##comp-subexpr cte second-src tail?)
                           (macro-gen ##gen-quasi-append src
                             (##comp-subexpr cte second-src #f)
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
                                        (##fx- depth 1))
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
                                          (##fx+ depth 1))))
                 ((unquote)
                  (if (##eq? depth 1)
                      (##comp-subexpr cte (##sourcify (##cadr lst) first-src) tail?)
                      (macro-gen ##gen-quasi-cons src
                        (macro-gen ##gen-cst-no-step first-src
                          first)
                        (##comp-list-template cte
                                              src
                                              #f
                                              (##cdr lst)
                                              (##fx- depth 1)))))
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
          (let ((var (loc-access-var x)))
            (if (and (##var-c? var)
                     (##not (##var-c-boxed? var)))
                (##raise-expression-parsing-exception
                 'variable-is-immutable
                 src
                 (##var-c-name var))
                (let ((val (##comp-subexpr cte val-src #f)))
                  (let ((up (loc-access-up x))
                        (over (loc-access-over x)))
                    (macro-gen ##gen-loc-set src
                      var
                      up
                      over
                      val)))))
          (macro-gen ##gen-glo-set src
            x
            (##comp-subexpr cte val-src #f))))))

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
                (new-cte (##cte-frame-i cte (##cons (macro-self-var) frame))))
            (loop1 (##append frame (##list (##car x)))
                   (##cdr lst)
                   (##cons (##comp-subexpr new-cte (##cdr x) #f)
                           rev-inits)))
          (let loop2 ((frame (if (and rest-parameter dsssl-style-rest?)
                                 (##append frame (##list rest-parameter))
                                 frame))
                      (lst (or key-parameters '()))
                      (rev-inits rev-inits)
                      (rev-keys '()))
            (if (##pair? lst)
                (let ((x (##car lst))
                      (new-cte (##cte-frame-i cte (##cons (macro-self-var) frame))))
                  (loop2 (##append frame (##list (##car x)))
                         (##cdr lst)
                         (##cons (##comp-subexpr new-cte (##cdr x) #f)
                                 rev-inits)
                         (##cons (##string->keyword (##symbol->string (##car x)))
                                 rev-keys)))
                (let* ((frame (if (and rest-parameter (##not dsssl-style-rest?))
                                  (##append frame (##list rest-parameter))
                                  frame))
                       (new-cte (##cte-frame-i cte (##cons (macro-self-var) frame)))
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
             (state 1)) ;;; 1 = required parms or #!optional/#!rest/#!key
                        ;;; 2 = optional parms or #!rest/#!key
                        ;;; 3 = #!key
                        ;;; 4 = key parms (or #!rest if rest-parm=#f)

    (define (done rest-parm2)
      (##vector (##reverse rev-required-parms)
                (and rev-optional-parms (##reverse rev-optional-parms))
                rest-parm2
                (and rest-parm (##fx= state 4))
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
                    (if (##not (##fx= 1 state))
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
                          (if (##fx= state 4)
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
                    (if (##fx= 4 state)
                        (key-illegal-err parm-src))
                    (loop (##cdr lst)
                          rev-required-parms
                          rev-optional-parms
                          rest-parm
                          '()
                          4))
                   ((##fx= state 3)
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
                    (if (##not (or (##fx= state 2) (##fx= state 4)))
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
                    (if (##not (##fx= 1 state))
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

  (define (internal-defs cte rev-vars rev-vals body)
    (if (##pair? body)

        (let* ((src (##sourcify (##car body) src))
               (code (##source-code src)))
          (if (##not (##pair? code))
              (internal-defs-done cte rev-vars rev-vals body)
              (let* ((first-src (##sourcify (##car code) src))
                     (first (##source-code first-src))
                     (descr (##macro-lookup cte first)))
                (if descr
                    (internal-defs cte
                                   rev-vars
                                   rev-vals
                                   (##cons
                                    (##macro-expand cte src descr)
                                    (##cdr body)))
                    (case first
                      ((##begin)
                       (##shape src src -1)
                       (internal-defs cte
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
                           (internal-defs cte
                                          (##cons name rev-vars)
                                          (##cons val rev-vals)
                                          (##cdr body)))))
                      ((##define-macro ##define-syntax)
                       (let* ((def-syntax? (##eq? first '##define-syntax))
                              (name-src (##definition-name src))
                              (name (##source-code name-src))
                              (val (##definition-value src)))
                         (internal-defs (##cte-macro
                                         cte
                                         name
                                         (##macro-descr val def-syntax?))
                                        rev-vars
                                        rev-vals
                                        (##cdr body))))
                      ((##include)
                       (##shape src src 2)
                       (internal-defs cte
                                      rev-vars
                                      rev-vals
                                      (##cons
                                       (##include-file-as-a-begin-expr src)
                                       (##cdr body))))
                      ((##declare)
                       (##shape src src -1)
                       (internal-defs (##cte-process-declare cte src)
                                      rev-vars
                                      rev-vals
                                      (##cdr body)))
                      ((##namespace)
                       (##shape src src -1)
                       (internal-defs (##cte-process-namespace cte src)
                                      rev-vars
                                      rev-vals
                                      (##cdr body)))
;;;                      ((library ##library)
;;;                       (##raise-expression-parsing-exception
;;;                        'ill-placed-library
;;;                        src))
;;;                      ((export ##export)
;;;                       (##raise-expression-parsing-exception
;;;                        'ill-placed-export
;;;                        src))
;;;                      ((import ##import)
;;;                       (##shape src src 2)
;;;                       (internal-defs cte
;;;                                      rev-vars
;;;                                      rev-vals
;;;                                      (##cons (##cte-process-import cte src)
;;;                                              (##cdr body))))
                      (else
                       (internal-defs-done cte rev-vars rev-vals body)))))))

        (##raise-expression-parsing-exception
         'empty-body
         src)))

  (define (internal-defs-done cte rev-vars rev-vals body)
    (if (##null? rev-vars)
        (##comp-seq cte src tail? #t body)
        (##comp-letrec-aux2 cte
                            src
                            tail?
                            #t
                            (##reverse rev-vars)
                            (##reverse rev-vals)
                            body)))

  (internal-defs cte '() '() body))

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
            (##comp-subexpr cte pre-src #f)
            (##comp-subexpr cte con-src tail?)
            (##comp-subexpr cte alt-src tail?)))
        (begin
          (##shape src src 3)
          (macro-gen ##gen-if2 src
            (##comp-subexpr cte pre-src #f)
            (##comp-subexpr cte con-src tail?))))))

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
                 (##comp-seq cte src tail? #t (##cdr clause)))
                ((##not (##pair? (##cdr clause)))
                 (macro-gen ##gen-cond-or src
                   (##comp-subexpr cte first-src #f)
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
                             (##comp-subexpr cte first-src #f)
                             (##comp-subexpr cte third-src #f)
                             (##comp-cond-aux cte src tail? (##cdr clauses)))))
                       (macro-gen ##gen-cond-if src
                         (##comp-subexpr cte first-src #f)
                         (##comp-seq cte src tail? #t (##cdr clause))
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
          (##comp-subexpr cte first-src #f)
          (##comp-and-aux cte src tail? rest))
        (##comp-subexpr cte first-src tail?))))

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
          (##comp-subexpr cte first-src #f)
          (##comp-or-aux cte src tail? rest))
        (##comp-subexpr cte first-src tail?))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-case cte src tail?)
  (##shape src src -3)
  (let* ((code (##source-code src))
         (first-src (##sourcify (##cadr code) src))
         (clauses (##cddr code)))
    (macro-gen ##gen-case first-src
      (##comp-subexpr cte first-src #f)
      (let ((cte (##cte-frame-i cte (##list (macro-selector-var)))))
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
                  (##comp-seq cte src tail? #t (##cdr clause))))
              (let ((n (##proper-length first)))
                (if (##not n)
                    (##raise-expression-parsing-exception
                     'ill-formed-selector-list
                     first-src))
                (macro-gen ##gen-case-clause clause-src
                  (##desourcify first-src)
                  (##comp-seq cte src tail? #t (##cdr clause))
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
                   (vals (##bindings->vals src bindings-src))
                   (tail? (##tail-call? cte tail?)))
              (macro-gen ##gen-app-no-step src
                (let ((inner-cte (##cte-frame-i cte (##list first)))
                      (tail? #f))
                  (macro-gen ##gen-letrec src
                    (##list first)
                    (let ((cte inner-cte))
                      (##list (macro-gen ##gen-prc-req-no-step src
                                vars
                                (##comp-body (##cte-frame-i
                                              cte
                                              (##cons (macro-self-var) vars))
                                             src
                                             #t
                                             (##cdddr code)))))
                    (let ((cte inner-cte))
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
                      (##cte-frame-i cte vars)
                      src
                      tail?
                      (##cddr code))))
                (macro-gen ##gen-let src
                  vars
                  (##comp-vals cte src vals)
                  c)))))))

(define (##comp-vals cte src lst)
  (if (##pair? lst)
      (##cons (##comp-subexpr cte (##sourcify (##car lst) src) #f)
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
        (let ((inner-cte (##cte-frame-i cte frame)))
          (macro-gen ##gen-let src
            frame
            (##list (##comp-subexpr cte (##car vals) #f))
            (##comp-let*-aux inner-cte
                             src
                             tail?
                             (##cdr vars)
                             (##cdr vals)
                             body))))
      (##comp-body cte src tail? body)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-letrec cte src tail?)
  (##comp-letrec-aux cte src tail? #f))

(define (##comp-letrec* cte src tail?)
  (##comp-letrec-aux cte src tail? #t))

(define (##comp-letrec-aux cte src tail? *?)
  (##shape src src -3)
  (let* ((code (##source-code src))
         (bindings-src (##sourcify (##cadr code) src))
         (vars (##bindings->vars src bindings-src #t #f))
         (vals (##bindings->vals src bindings-src)))
    (##comp-letrec-aux2 cte src tail? *? vars vals (##cddr code))))

(define (##comp-letrec-aux2 cte src tail? *? vars vals body)
  (if (##pair? vars)
      (let ((inner-cte (##cte-frame-i cte vars))
            (gen-letrec (if *? ##gen-letrec* ##gen-letrec)))
        (macro-gen gen-letrec src
          vars
          (##comp-vals inner-cte src vals)
          (##comp-body inner-cte src tail? body)))
      (##comp-body cte src tail? body)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-do cte src tail?)
  (##shape src src -3)
  (let* ((outer-cte cte)
         (code (##source-code src))
         (bindings-src (##sourcify (##cadr code) src))
         (exit-src (##sourcify (##caddr code) src))
         (exit (##source-code exit-src)))
    (##shape src exit-src -1)
    (let* ((vars (##bindings->vars src bindings-src #t #t))
           (do-loop-vars (##list (macro-do-loop-var)))
           (inner-cte (##cte-frame-i cte do-loop-vars)))
      (macro-gen ##gen-letrec src
        do-loop-vars
        (##list
         (let ((cte inner-cte)
               (tail? #f))
           (macro-gen ##gen-prc-req-no-step src
             vars
             (let ((cte (##cte-frame-i cte (##cons (macro-self-var) vars)))
                   (tail? #t))
               (macro-gen ##gen-if3 src
                 (##comp-subexpr cte (##sourcify (##car exit) src) #f)
                 (##comp-seq cte src tail? #t (##cdr exit))
                 (let ((call
                        (let ((tail? (##tail-call? outer-cte tail?)))
                          (macro-gen ##gen-app-no-step src
                            (let ((tail? #f))
                              (macro-gen ##gen-loc-ref-no-step src ;; fetch do-loop-var
                                1
                                1))
                            (##comp-vals cte
                                         src
                                         (##bindings->steps src
                                                            bindings-src))))))
                   (if (##null? (##cdddr code))
                       call
                       (macro-gen ##gen-seq src
                         (##comp-seq cte src #f #t (##cdddr code))
                         call))))))))
        (let ((cte inner-cte)
              (tail? (##tail-call? outer-cte tail?)))
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
        (let ((tail? (##tail-call? cte tail?)))
          (macro-gen ##gen-app src
            (##comp-subexpr cte (##sourcify (##car code) src) #f)
            (##comp-vals cte src (##cdr code))))
        (##raise-expression-parsing-exception
         'ill-formed-call
         src))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-delay cte src tail?)
  (##shape src src 2)
  (let ((code (##source-code src)))
    (macro-gen ##gen-delay src
      (##comp-subexpr cte (##sourcify (##cadr code) src) #t))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##comp-future cte src tail?)
  (##shape src src 2)
  (let ((code (##source-code src)))
    (macro-gen ##gen-future src
      (##comp-subexpr cte (##sourcify (##cadr code) src) #t))))

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
         (if (##fx< 0 i)
             (loop (macro-rte-up e) (##fx- i 1))
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

(define ##cprc-loc-ref-box
  (macro-make-cprc
   (macro-reference-step! ()
     (let ((up (^ 0)))
       (let loop ((e rte) (i up))
         (if (##fx< 0 i)
             (loop (macro-rte-up e) (##fx- i 1))
             (##unbox (macro-rte-ref e (^ 1)))))))))

(define ##gen-loc-ref-box
  (macro-make-gen (stepper up over)
    (macro-make-code ##cprc-loc-ref-box cte src stepper ()
      up
      over)))

(define ##gen-loc-ref
  (macro-make-gen (var up over)
    (let ((stepper (##current-stepper)))
      (if (and (##var-c? var) (##var-c-boxed? var))
          (macro-gen ##gen-loc-ref-box src stepper up over)
          (macro-gen ##gen-loc-ref-aux src stepper up over)))))

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
           (if (##fx< 0 i)
               (loop (macro-rte-up e) (##fx- i 1))
               (begin
                 (macro-rte-set! e (^ 2) val)
                 (##void)))))))))

(define ##cprc-loc-set-box
  (macro-make-cprc
   (let ((val (macro-code-run (^ 0))))
     (macro-set!-step! (val)
       (let ((up (^ 1)))
         (let loop ((e rte) (i up))
           (if (##fx< 0 i)
               (loop (macro-rte-up e) (##fx- i 1))
               (begin
                 (##set-box! (macro-rte-ref e (^ 2)) val)
                 (##void)))))))))

(define ##gen-loc-set
  (macro-make-gen (var up over val)
    (let ((stepper (##current-stepper)))
      (if (and (##var-c? var) (##var-c-boxed? var))
          (macro-make-code ##cprc-loc-set-box cte src stepper (val)
            up
            over)
          (macro-make-code ##cprc-loc-set cte src stepper (val)
            up
            over)))))

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
   (let ((val (macro-code-run (^ 0))))
     (macro-define-step! (val)
       (begin
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
           (macro-code-run (^ 1)))
          (result
           (##quasi-cons val1 val2)))
     (##check-heap-limit)
     (##first-argument result $code rte)))) ;; keep $code and rte in environment-map

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
                     (##first-argument ;; keep $code and rte in environment-map
                      (##raise-nonprocedure-operator-exception oper args $code rte)
                      $code
                      rte))
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
                     (##first-argument ;; keep $code and rte in environment-map
                      (##raise-nonprocedure-operator-exception oper args $code rte)
                      $code
                      rte))
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
   (let ((ns (##fx- (macro-code-length $code) 2)))
     (let loop1 ((i 1) (args '()))
       (if (##fx< ns i)
           (let ((inner-rte (macro-make-rte* rte ns)))
             (##check-heap-limit)
             (let loop2 ((i ns) (args args))
               (if (##fx< 0 i)
                   (begin
                     (macro-rte-set! inner-rte i (##car args))
                     (loop2 (##fx- i 1) (##cdr args)))
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
             (loop1 (##fx+ i 1) new-args)))))))

(define ##gen-let
  (macro-make-gen (vars vals body)
    (let* ((stepper
            (##no-stepper))
           (c
            (##make-code* ##cprc-let cte src stepper (##cons body vals) 1)))
      (macro-code-set! c (##fx+ (##length vals) 1) vars)
      c)))

(define ##cprc-letrec
  (macro-make-cprc
   (let ((ns (##fx- (macro-code-length $code) 2)))
     (let ((inner-rte (macro-make-rte* rte ns)))
       (let loop1 ((i 1) (rev-vals '()))
         (if (##fx< ns i)
             (let loop2 ((i i) (rev-vals rev-vals))
               (if (##fx< 1 i)
                   (let ((new-i (##fx- i 1)))
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
               (loop1 (##fx+ i 1) new-rev-vals))))))))

(define ##gen-letrec
  (macro-make-gen (vars vals body)
    (let* ((stepper
            (##no-stepper))
           (c
            (##make-code* ##cprc-letrec cte src stepper (##cons body vals) 1)))
      (macro-code-set! c (##fx+ (##length vals) 1) vars)
      c)))

(define ##cprc-letrec*
  (macro-make-cprc
   (let ((ns (##fx- (macro-code-length $code) 2)))
     (let ((inner-rte (macro-make-rte* rte ns)))
       (let loop ((i 1))
         (if (##fx< ns i)
             (let* (($code (^ 0))
                    (rte (##first-argument inner-rte rte)))
               (macro-code-run $code))
             (begin
               (macro-rte-set!
                inner-rte
                i
                (let* (($code (macro-code-ref $code i))
                       (rte inner-rte))
                  (macro-code-run $code)))
               (loop (##fx+ i 1)))))))))

(define ##gen-letrec*
  (macro-make-gen (vars vals body)
    (let* ((stepper
            (##no-stepper))
           (c
            (##make-code* ##cprc-letrec* cte src stepper (##cons body vals) 1)))
      (macro-code-set! c (##fx+ (##length vals) 1) vars)
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
                         (if (##fx< ns i)
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
                                   (loop (##fx+ i 1) (##cdr lst)))
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
         (let ((n+1 (##fx+ n 1)))
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
                         (if (##fx< i ns)
                             (if (##pair? lst)
                                 (begin
                                   (macro-rte-set! inner-rte i (##car lst))
                                   (loop (##fx+ i 1) (##cdr lst)))
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
          (n+1 (##fx+ (##length frame) 1)))
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
                            (macro-code-ref $code (##fx- n 7)))))

                     (define reject-illegal-dsssl-parameter-list? #f)

                     (define (get-keys i j left rest? keys)
                       (let loop1 ((end left))

                         (define (keys-ok)
                           (let loop3 ((i i) (j j) (k 0))
                             (if (##fx< k (##vector-length keys))
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
                                           (loop3 (##fx+ i 1)
                                                  (##fx+ j 1)
                                                  (##fx+ k 1)))
                                         (if (##eq? (##car lst) key)
                                             (begin
                                               (macro-rte-set! inner-rte i
                                                               (##cadr lst))
                                               (loop3 (##fx+ i 1)
                                                      (##fx+ j 1)
                                                      (##fx+ k 1)))
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
                                          (let loop2 ((k (##fx-
                                                          (##vector-length keys)
                                                          1)))
                                            (cond ((##fx< k 0)
                                                   (##raise-unknown-keyword-argument-exception
                                                    proc
                                                    args))
                                                  ((##eq? key (##vector-ref keys k))
                                                   (loop1 (##cdr lst)))
                                                  (else
                                                   (loop2 (##fx- k 1)))))))
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
                       (if (##fx<
                            i
                            (macro-code-ref $code (##fx- n 6)))
                           (if (##pair? lst)
                               (begin
                                 (macro-rte-set! inner-rte i (##car lst))
                                 (loop1 (##fx+ i 1) (##cdr lst)))
                               (##raise-wrong-number-of-arguments-exception
                                proc
                                args))
                           (let loop2 ((i i) (j 1) (lst lst))
                             (if (##fx<
                                  i
                                  (macro-code-ref $code (##fx- n 5)))
                                 (if (##pair? lst)
                                     (begin
                                       (macro-rte-set! inner-rte i (##car lst))
                                       (loop2 (##fx+ i 1)
                                              (##fx+ j 1)
                                              (##cdr lst)))
                                     (begin
                                       (macro-rte-set! inner-rte i
                                                       (let* (($code (macro-code-ref $code j))
                                                              (rte inner-rte))
                                                         (macro-code-run $code)))
                                       (loop2 (##fx+ i 1)
                                              (##fx+ j 1)
                                              '())))
                                 (let ((keys
                                        (macro-code-ref $code (##fx- n 3)))
                                       (rest?
                                        (macro-code-ref $code (##fx- n 4))))
                                   (cond (rest?
                                          (if keys
                                              (get-keys
                                               (if (##eq? rest? 'dsssl)
                                                   (begin
                                                     (macro-rte-set! inner-rte i lst)
                                                     (##fx+ i 1))
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
                                        (##fx- (macro-code-length $code) 2))))
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
            (##fx- (##fx- n ni) (if rest? 1 0)))
           (no
            (##fx- ni (if keys (##vector-length keys) 0)))
           (c
            (##make-code* ##cprc-prc cte src stepper (##cons body inits) 7)))
      (macro-code-set! c (##fx+ ni 1) (##fx+ n 1))
      (macro-code-set! c (##fx+ ni 2) (##fx+ nr 2))
      (macro-code-set! c (##fx+ ni 3) (##fx+ (##fx+ nr 2) no))
      (macro-code-set! c (##fx+ ni 4) rest?)
      (macro-code-set! c (##fx+ ni 5) keys)
      (macro-code-set! c (##fx+ ni 6) #f)
      (macro-code-set! c (##fx+ ni 7) frame)
      c)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##cprc-app0-red
  (macro-make-cprc
   (let ((oper (macro-code-run (^ 0))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
           (##first-argument ;; keep $code and rte in environment-map
            (##raise-nonprocedure-operator-exception oper '() $code rte)
            $code
            rte)
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
             (##first-argument ;; keep $code and rte in environment-map
              (##raise-nonprocedure-operator-exception oper args $code rte)
              $code
              rte))
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
             (##first-argument ;; keep $code and rte in environment-map
              (##raise-nonprocedure-operator-exception oper args $code rte)
              $code
              rte))
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
             (##first-argument ;; keep $code and rte in environment-map
              (##raise-nonprocedure-operator-exception oper args $code rte)
              $code
              rte))
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
             (##first-argument ;; keep $code and rte in environment-map
              (##raise-nonprocedure-operator-exception oper args $code rte)
              $code
              rte))
           (macro-call-step! (oper arg1 arg2 arg3 arg4)
             (oper arg1 arg2 arg3 arg4)))))))

(define ##cprc-app-red
  (macro-make-cprc
   (let ((oper (macro-code-run (^ 0))))
     (let loop ((i 1) (rev-args '()))
       (if (##fx< i (macro-code-length $code))
           (let ((new-rev-args
                  (##cons (macro-code-run (macro-code-ref $code i)) rev-args)))
             (##check-heap-limit)
             (loop (##fx+ i 1) new-rev-args))
           (let ((args (##reverse rev-args)))
             (macro-force-vars (oper)
               (if (##not (##procedure? oper))
                   (##first-argument ;; keep $code and rte in environment-map
                    (##raise-nonprocedure-operator-exception oper args $code rte)
                    $code
                    rte)
                   (macro-call-step! (oper args)
                     (begin
                       (##first-argument $code rte);;;;;;;;;obsolete?
                       (##apply oper args)))))))))))

(define ##cprc-app0-sub
  (macro-make-cprc
   (let ((oper (macro-code-run (^ 0))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
           (##first-argument ;; keep $code and rte in environment-map
            (##raise-nonprocedure-operator-exception oper '() $code rte)
            $code
            rte)
           (##subproblem-apply0 $code rte oper))))))

(define ##cprc-app1-sub
  (macro-make-cprc
   (let* ((oper (macro-code-run (^ 0)))
          (arg1 (macro-code-run (^ 1))))
     (macro-force-vars (oper)
       (if (##not (##procedure? oper))
           (let ((args (##list arg1)))
             (##check-heap-limit)
             (##first-argument ;; keep $code and rte in environment-map
              (##raise-nonprocedure-operator-exception oper args $code rte)
              $code
              rte))
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
             (##first-argument ;; keep $code and rte in environment-map
              (##raise-nonprocedure-operator-exception oper args $code rte)
              $code
              rte))
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
             (##first-argument ;; keep $code and rte in environment-map
              (##raise-nonprocedure-operator-exception oper args $code rte)
              $code
              rte))
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
             (##first-argument ;; keep $code and rte in environment-map
              (##raise-nonprocedure-operator-exception oper args $code rte)
              $code
              rte))
           (##subproblem-apply4 $code rte oper arg1 arg2 arg3 arg4))))))

(define ##cprc-app-sub
  (macro-make-cprc
   (let ((oper (macro-code-run (^ 0))))
     (let loop ((i 1) (rev-args '()))
       (if (##fx< i (macro-code-length $code))
           (let ((new-rev-args
                  (##cons (macro-code-run (macro-code-ref $code i)) rev-args)))
             (##check-heap-limit)
             (loop (##fx+ i 1) new-rev-args))
           (let ((args (##reverse rev-args)))
             (macro-force-vars (oper)
               (if (##not (##procedure? oper))
                   (##first-argument ;; keep $code and rte in environment-map
                    (##raise-nonprocedure-operator-exception oper args $code rte)
                    $code
                    rte)
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

;;;============================================================================

;;; Eval

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Evaluation in a top environment within the current continuation.

(define-prim (##eval-module src top-cte)
  (let ((c (##compile-module top-cte (##sourcify src (##make-source #f #f)))))
    (let ((rte #f))
      (macro-code-run c))))

(define-prim (##eval-module-set! x)
  (set! ##eval-module x))

(define-prim (##eval-top src top-cte)
  (let ((c (##compile-top top-cte (##sourcify src (##make-source #f #f)))))
    (let ((rte #f))
      (macro-code-run c))))

(define-prim (##eval-top-set! x)
  (set! ##eval-top x))

(define-prim (##eval expr #!optional env)
  (##eval-top (##sourcify expr (##make-source #f #f))
              ##interaction-cte))

(define-prim (eval expr #!optional (env (macro-absent-obj)))

  (define r4rs-special-forms
    '(and
      begin
      case
      cond
      define
      delay
      do
      if
      lambda
      let
      let*
      letrec
      or
      quasiquote
      quote
      set!))

  (define r4rs-primitives
    '(*
      +
      -
      /
      <
      <=
      =
      >
      >=
      abs
      acos
      angle
      append
      apply
      asin
      assoc
      assq
      assv
      atan
      boolean?
      caaaar
      caaadr
      caaar
      caadar
      caaddr
      caadr
      caar
      cadaar
      cadadr
      cadar
      caddar
      cadddr
      caddr
      cadr
      call-with-current-continuation
      call-with-input-file
      call-with-output-file
      car
      cdaaar
      cdaadr
      cdaar
      cdadar
      cdaddr
      cdadr
      cdar
      cddaar
      cddadr
      cddar
      cdddar
      cddddr
      cdddr
      cddr
      cdr
      ceiling
      char->integer
      char-alphabetic?
      char-ci<=?
      char-ci<?
      char-ci=?
      char-ci>=?
      char-ci>?
      char-downcase
      char-lower-case?
      char-numeric?
      char-ready?
      char-upcase
      char-upper-case?
      char-whitespace?
      char<=?
      char<?
      char=?
      char>=?
      char>?
      char?
      close-input-port
      close-output-port
      complex?
      cons
      cos
      current-input-port
      current-output-port
      denominator
      display
      eof-object?
      eq?
      equal?
      eqv?
      even?
      exact->inexact
      exact?
      exp
      expt
      floor
      for-each
      force
      gcd
      imag-part
      inexact->exact
      inexact?
      input-port?
      integer->char
      integer?
      lcm
      length
      list
      list->string
      list->vector
      list-ref
      list-tail
      list?
      load
      log
      magnitude
      make-polar
      make-rectangular
      make-string
      make-vector
      map
      max
      member
      memq
      memv
      min
      modulo
      negative?
      newline
      not
      null?
      number->string
      number?
      numerator
      odd?
      open-input-file
      open-output-file
      output-port?
      pair?
      peek-char
      positive?
      procedure?
      quotient
      rational?
      rationalize
      read
      read-char
      real-part
      real?
      remainder
      reverse
      round
      set-car!
      set-cdr!
      sin
      sqrt
      string
      string->list
      string->number
      string->symbol
      string-append
      string-ci<=?
      string-ci<?
      string-ci=?
      string-ci>=?
      string-ci>?
      string-copy
      string-fill!
      string-length
      string-ref
      string-set!
      string<=?
      string<?
      string=?
      string>=?
      string>?
      string?
      substring
      symbol->string
      symbol?
      tan
      transcript-off
      transcript-on
      truncate
      vector
      vector->list
      vector-fill!
      vector-length
      vector-ref
      vector-set!
      vector?
      with-input-from-file
      with-output-to-file
      write
      write-char
      zero?))

  (define r5rs-special-forms
    '(define-syntax
      let-syntax
      letrec-syntax
      syntax-rules))

  (define r5rs-primitives
    '(call-with-values
      dynamic-wind
      eval
      interaction-environment
      null-environment
      scheme-report-environment
      values))

  (define (separate-namespace)
    '("_#"))

  (define (eval-global expr)
    (##eval expr #f))

  (define (eval-global-in-namespace ns expr)
    (eval-global (##list '##let '() ns expr)))

  (define (eval-global-in-separate-namespace-except-for lists-of-names expr)
    (eval-global-in-namespace
     (##list '##namespace
             (separate-namespace)
             (##append '("")
                       (##append-lists lists-of-names)))
     expr))

  (cond ((or (##eq? env (macro-absent-obj))
             (##eqv? env 'interaction-environment))
         (eval-global expr))

        ((##eqv? env 'null-environment)
         (eval-global-in-separate-namespace-except-for
          (##list r5rs-special-forms
                  r4rs-special-forms)
          expr))

        ((##eqv? env 4)
         (eval-global-in-separate-namespace-except-for
          (##list r4rs-special-forms
                  r4rs-primitives)
          expr))

        ((##eqv? env 5)
         (eval-global-in-separate-namespace-except-for
          (##list r5rs-special-forms
                  r5rs-primitives
                  r4rs-special-forms
                  r4rs-primitives)
          expr))

        (else
         (error "unknown environment specifier" env))))

(define-prim (interaction-environment)
  'interaction-environment)

(define-prim (null-environment)
  'null-environment)

(define-prim (scheme-report-environment n)
  n)

;;;============================================================================

(define (##wrap-datum re x)
  (if (##source? x) ;; avoid adding source location on #.expr when expr returns a source object
      x
      (##make-source x (##readenv->locat re))))

(define (##unwrap-datum re x)
  (##source-code x))

(define (##read-expr-from-port port)
  (let ((re
         (##make-readenv port
                         (macro-character-port-input-readtable port)
                         ##wrap-datum
                         ##unwrap-datum
                         #f
                         #f)))
    (##read-datum-or-eof re)))

(define (##load
         path-or-settings
         script-callback
         clone-cte?
         raise-os-exception?
         linker-name
         quiet?)

  (define (raise-os-exception-if-needed x)
    (if (and (##fixnum? x)
             raise-os-exception?)
        (##raise-os-exception #f x load path-or-settings)
        x))

  (define (load-source psettings source-path)
    (macro-psettings-path-set! psettings source-path)
    (let ((x
           (##read-all-as-a-begin-expr-from-psettings
            psettings
            path-or-settings
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
    (let* ((linker-name
            (or linker-name
                (##path-strip-directory abs-path)))
           (result
            (##load-object-file abs-path linker-name quiet?)))

      (define (raise-error code)
        (if (##fixnum? code)
            (##raise-os-exception #f code load path-or-settings)
            (##raise-os-exception code #f load path-or-settings)))

      (cond ((##not (##vector? result))
             (raise-error result))
            ((##fx= 2 (##vector-length result))
             (raise-error (##vector-ref result 0)))
            (else
             (let ((module-descrs (##vector-ref result 0))
                   (script-line (##vector-ref result 2)))
               (script-callback script-line abs-path)
               (##register-module-descrs-and-load! module-descrs)
               (##path-unresolve abs-path))))))

  (define (load-no-ext psettings path)
    (let ((result (load-source psettings path)))
      (if (##not (##fixnum? result))
          result
          (let loop1 ((version 1)
                      (last-obj-file-path #f)
                      (last-obj-file-info #f))
            (let* ((resolved-path
                    (##path-resolve
                     (##string-append path
                                      ".o"
                                      (##number->string version 10))))
                   (resolved-info
                    (##file-info resolved-path))
                   (resolved-path-exists?
                    (##not (##fixnum? resolved-info))))
              (if resolved-path-exists?
                  (loop1 (##fx+ version 1)
                         resolved-path
                         resolved-info)
                  (if (and last-obj-file-path
                           (##not ##load-source-if-more-recent))
                      (load-binary last-obj-file-path)
                      (let loop2 ((lst ##scheme-file-extensions))
                        (if (##pair? lst)
                            (let* ((src-file-path
                                    (##string-append path (##caar lst)))
                                   (src-file-info
                                    (if (##string? src-file-path)
                                        (##file-info src-file-path)
                                        0))
                                   (src-file-path-exists?
                                    (##not (##fixnum? src-file-info))))
                              (if (##not src-file-path-exists?)
                                  (loop2 (##cdr lst))
                                  (if (or (##not last-obj-file-path)
                                          (##fl<
                                           (macro-time-point
                                            (macro-file-info-last-modification-time
                                             last-obj-file-info))
                                           (macro-time-point
                                            (macro-file-info-last-modification-time
                                             src-file-info))))
                                      (let ((x (load-source psettings src-file-path)))
                                        (if (##fixnum? x)
                                            (raise-os-exception-if-needed result)
                                            x))
                                      (load-binary last-obj-file-path))))
                            (if last-obj-file-path
                                (load-binary last-obj-file-path)
                                (raise-os-exception-if-needed result)))))))))))

  (define (binary-extension? ext)
    (let ((len (##string-length ext)))
      (and (##fx< 2 len)
           (##char=? (##string-ref ext 0) #\.)
           (##char=? (##string-ref ext 1) #\o)
           (let ((c (##string-ref ext 2)))
             (and (##char>=? c #\1) (##char<=? c #\9)
                  (let loop ((i (##fx- len 1)))
                    (if (##fx< i 3)
                        #t
                        (let ((c (##string-ref ext i)))
                          (and (##char>=? c #\0) (##char<=? c #\9)
                               (loop (##fx- i 1)))))))))))

  (define (fail)
    (##fail-check-string-or-settings 1 load path-or-settings))

  (##make-input-path-psettings
   (if (##string? path-or-settings)
       (##list 'path: path-or-settings
               'eol-encoding: 'cr-lf)
       path-or-settings)
   fail
   (lambda (psettings)
     (let ((path (macro-psettings-path psettings)))
       (if (##not path)
           (fail)
           (let ((ext (##path-extension path)))
             (cond ((##string=? ext "")
                    (load-no-ext psettings path))
                   ((binary-extension? ext)
                    (let ((resolved-path (##path-resolve path)))
                      (load-binary resolved-path)))
                   (else
                    (raise-os-exception-if-needed
                     (load-source psettings path))))))))))

(define ##load-source-if-more-recent #t)

(define-prim (##load-source-if-more-recent-set! x)
  (set! ##load-source-if-more-recent x))

(define-prim (##load-object-file abs-path linker-name quiet?)
  (let ((result
         (##os-load-object-file abs-path linker-name)))
    (cond ((##not (##vector? result))
           result)
          ((##fx= 2 (##vector-length result))
           (if (##not quiet?)
               (##repl
                (lambda (first output-port)
                  (##write-string "*** WARNING -- Could not find C function: " output-port)
                  (##write (##vector-ref result 1) output-port)
                  (##newline output-port)
                  #t)))
           result)
          (else
           (let ((exec-vector (##vector-ref result 0))
                 (script-line (##vector-ref result 2)))
             (if (##not quiet?)
                 (let ((undefined (##vector-ref result 1)))
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
                           (loop (##cdr lst)))))))
             result)))))

(define (load path-or-settings)
  (macro-force-vars (path-or-settings)
    (##load path-or-settings
            (lambda (script-line script-path) #f)
            #t
            #t
            #f
            #f)))

;;;----------------------------------------------------------------------------

;; Load support libraries

(define-prim (##load-support-libraries)

  (##define-macro (macro-extension-file)
    "~~lib/gambext")

  (##define-macro (macro-syntax-case-file)
    "~~lib/syntax-case")

  (##load (macro-extension-file)
          (lambda (script-line script-path) #f)
          #f ;; must be #f for the macros to be added to the interaction environment
          #f
          #f
          #f)

  (let ((standard-level (##get-standard-level)))
    (if (##fx<= 4 standard-level)
        (##load (macro-syntax-case-file)
                (lambda (script-line script-path) #f)
                #t
                #t
                #f
                #f))))

;;;----------------------------------------------------------------------------

;;; Interaction environment and syntactic aliases.

(define ##interaction-cte
  (let ((##interaction-cte (##make-top-cte)))

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

    (define-runtime-syntax letrec*
      (##make-alias-syntax '##letrec*))

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

    (define-runtime-syntax define-type
      (##make-alias-syntax '##define-type))

    (define-runtime-syntax define-type-of-thread
      (##make-alias-syntax '##define-type-of-thread))

    (define-runtime-syntax define-structure
      (##make-alias-syntax '##define-structure))

    (define-runtime-syntax include
      (##make-alias-syntax '##include))

    (define-runtime-syntax declare
      (##make-alias-syntax '##declare))

    (define-runtime-syntax namespace
      (##make-alias-syntax '##namespace))

    (define-runtime-syntax case-lambda
      (##make-alias-syntax '##case-lambda))

    (define-runtime-syntax when
      (##make-alias-syntax '##when))

    (define-runtime-syntax unless
      (##make-alias-syntax '##unless))

    (define-runtime-syntax syntax-error
      (##make-alias-syntax '##syntax-error))

    ##interaction-cte))

;;;============================================================================
