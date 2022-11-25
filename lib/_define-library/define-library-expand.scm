;;;============================================================================

;;; File: "_define-library-expand.scm"

;;; Copyright (c) 2014-2021 by Marc Feeley and Frédéric Hamel, All Rights Reserved.

;;;============================================================================

(##supply-module _define-library/define-library-expand)

(##namespace ("_define-library/define-library-expand#"))

(##include "define-library-expand#.scm")

(##include "~~lib/gambit#.scm")
(##include "~~lib/_gambit#.scm")
(##include "~~lib/_module#.scm")

(##include "~~lib/gambit/prim/prim#.scm")

;;;============================================================================

(define (keep keep? lst)
  (cond ((null? lst)       '())
        ((keep? (car lst)) (cons (car lst) (keep keep? (cdr lst))))
        (else              (keep keep? (cdr lst)))))

(set! ##expression-parsing-exception-names
      (append
       '(
         (cannot-find-library            . "Cannot find library")
         (define-library-expected        . "define-library form expected")
         (ill-formed-library-name        . "Ill-formed library name")
         (ill-formed-library-decl        . "Ill-formed library declaration")
         (ill-formed-export-spec         . "Ill-formed export spec")
         (ill-formed-import-set          . "Ill-formed import set")
         (duplicate-identifier-export    . "Duplicate export of identifier")
         (duplicate-identifier-import    . "Duplicate import of identifier")
         (unexported-identifier          . "Library does not export identifier")
         )
       ##expression-parsing-exception-names))

;;;============================================================================

(define-type idmap
  id: E4059B2A-C618-402F-8B43-A77D6C89E466
  (src unprintable:)
  (name-src unprintable:)
  name
  namespace
  macros
  only-export?
  mapping
)

(define-type libdef
  id: B2B06949-BB51-4D4D-87AE-651B297CF0DE
  (src unprintable:)
  (name-src unprintable:)
  name
  namespace
  meta-info
  exports
  imports
  body
)

;; modref defined in _library#.scm
;;(define-type modref
;;  host        ;; ("github.com" "A") or ()
;;  tag         ;; ("tree" "1.0.0") or ()
;;  path)       ;; ("B" "C" "D")

(define (path->parts path)
  (let ((path-len (string-length path)))
    (define (split-path start rev-result)
      (let loop ((end start))
        (if (< end path-len)
          (case (string-ref path end)
            ((#\/)
             (split-path (+ end 1)
                         (if (> end start)
                           (cons (substring path start end) rev-result)
                           rev-result)))
            (else
              (loop (+ end 1))))
            (reverse
              (if (> end start)
                (cons (substring path start end) rev-result)
                rev-result)))))
    (split-path 0 '())))

(define (parts->path parts dir)
  (if (null? parts)
      dir
      (parts->path (cdr parts) (##path-expand (car parts) dir))))

(define (get-libdef import-src reference-src)

  (define (err src)
    (##raise-expression-parsing-exception
     'cannot-find-library
     src
     (##desourcify src)))

  (call-with-values
   (lambda ()
     (##find-mod-info reference-src import-src))

   (lambda (mod-info module-ref)
     (if mod-info
         (let ((mod-dir            (##vector-ref mod-info 0))
               (mod-filename-noext (##vector-ref mod-info 1))
               (ext                (##vector-ref mod-info 2))
               (mod-path           (##vector-ref mod-info 3))
               (port               (##vector-ref mod-info 4))
               (root               (##vector-ref mod-info 5))
               (path               (##vector-ref mod-info 6)))

           (values
             (read-libdef-sld mod-path
                              reference-src
                              module-ref
                              port
                              root
                              path)
             module-ref))
         (err reference-src)))))

(define (read-first port)
  (let* ((rt
          (##readtable-copy-shallow (##current-readtable)))
         (re
          (##make-readenv port rt ##wrap-datum ##unwrap-datum #t '() #f))
         (first
          (##read-datum-or-eof re)))
    (close-input-port port)
    first))


(define (read-libdef-sld name reference-src import-name port
                         module-root modref-path)
  (let ((src (read-first port)))
    (if (eof-object? src)
      #f
      #;(##raise-expression-parsing-exception
       'define-library-expected
       (##make-source src `#(,(string->symbol name))))
      (parse-define-library src import-name module-root modref-path))))

(define (read-libdef-scm name reference-src import-name port)
  (let ((src (read-first port)))
    (parse-define-library src import-name #f #f)))

(define library-kinds
  (list
   (cons ".sld"
         (vector read-libdef-sld))
   (cons ".scm"
         (vector read-libdef-scm))))

(define (library-kinds-set! x)
  (set! library-kinds x))

(define (read-file-as-a-begin-expr lib-decl-src filename-src)
  (let ((filename (##source-strip filename-src)))
    (if (##string? filename)

        (let* ((locat
                (##source-locat lib-decl-src))
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
                 lib-decl-src
                 path)
                (##vector-ref x 1))))

        (##raise-expression-parsing-exception
         'filename-expected
         filename-src))))

(define (parse-name name-src allow-empty-path?)

    (define (library-name-err)
      (##raise-expression-parsing-exception
       'ill-formed-library-name
       name-src))

    ;; Test if part is invalid
    (let ((spec (##desourcify name-src)))
      (if (not (pair? spec))
          (library-name-err)
          (let ((head (car spec)))
            (if (memq head '(rename prefix only except))
                (library-name-err) ;; conflict with import declaration syntax
                (let ((dot-and-modref (##parse-module-ref-possibly-relative spec allow-empty-path?)))
                  (or dot-and-modref (library-name-err))))))))

(define (parse-define-library src modref-str module-root modref-path)

  (define-type ctx
    id: B8BC23AA-15B6-4ABE-ABCE-0E8C8F639A3F
    (src unprintable:)
    (name-src unprintable:)
    name
    namespace
    exports-tbl
    imports-tbl
    macros-tbl
    type-definers-tbl
    meta-info-tbl
    rev-pending-exports
    rev-imports
    rev-body
    module-aliases
  )

  (define (parse-body ctx body-srcs)
    (if (pair? body-srcs)
        (let* ((lib-decl-src (car body-srcs))
               (lib-decl (##source-strip lib-decl-src))
               (rest-srcs (cdr body-srcs)))

          (define (library-decl-err)
            (##raise-expression-parsing-exception
             'ill-formed-library-decl
             lib-decl-src))

          (if (pair? lib-decl)

              (let* ((head-src (car lib-decl))
                     (head (##source-strip head-src))
                     (args-srcs (cdr lib-decl)))
                (case head

                  ((export)
                   ;; export clauses have to be handled after handling
                   ;; other clauses of the define-library because the effect
                   ;; will depend on what is imported and the namespace,
                   ;; so we simply add them to a pending exports list
                   (ctx-rev-pending-exports-set!
                    ctx
                    (cons args-srcs (ctx-rev-pending-exports ctx)))
                   (parse-body ctx rest-srcs))

                  ((import)
                   (parse-import-decl ctx args-srcs)
                   (parse-body ctx rest-srcs))

                  ((begin)
                   (parse-begin-decl ctx args-srcs)
                   (parse-body ctx rest-srcs))

                  ((include include-ci include-library-declarations)
                   (parse-body
                    ctx
                    (append (parse-include
                             ctx
                             args-srcs
                             lib-decl-src
                             head)
                            rest-srcs)))

                  ((cond-expand)
                   (let ((x (##cond-expand-build lib-decl-src args-srcs)))
                     (parse-body
                      ctx
                      (append (cdr x) ;; get rid of "begin"
                              rest-srcs))))

                  ((namespace) ;; extension to R7RS
                   (if (not (and (pair? args-srcs)
                                 (null? (cdr args-srcs))))
                       (library-decl-err)
                       (let ((space
                              (##source-strip (car args-srcs))))
                         (if (not (and (string? space)
                                       (##namespace-valid? space)))
                             (library-decl-err)
                             (begin
                               (ctx-namespace-set! ctx space)
                               (parse-body ctx rest-srcs))))))

                  ((cc-options ;; extensions to R7RS
                    ld-options
                    ld-options-prelude
                    pkg-config
                    pkg-config-path)
                   (let loop ((lst args-srcs))
                     (if (pair? lst)
                         (let ((arg (##source-strip (car lst))))
                           (if (not (string? arg))
                               (library-decl-err)
                               (begin
                                 (##meta-info-add!
                                  (ctx-meta-info-tbl ctx)
                                  head
                                  arg)
                                 (loop (cdr lst)))))
                         (parse-body ctx rest-srcs))))

                  (else
                   (library-decl-err))))

              (library-decl-err)))))

  (define (add-identifier-export! ctx internal-id-src external-id-src)
    (let* ((internal-id (##source-strip internal-id-src))
           (external-id (##source-strip external-id-src))
           (exports-tbl (ctx-exports-tbl ctx))
           (imports-tbl (ctx-imports-tbl ctx)))
      (if (table-ref exports-tbl external-id #f)
          (##raise-expression-parsing-exception
           'duplicate-identifier-export
           external-id-src
           external-id)
          (table-set! exports-tbl
                      external-id
                      (or (table-ref imports-tbl internal-id #f)
                          (##make-full-name (ctx-namespace ctx)
                                            internal-id))))))

  (define (add-imports! ctx import-set-src idmap)
    (let* ((name
            (idmap-name idmap))
           (x
            (assoc name (ctx-rev-imports ctx)))
           (tbl
            (if x
                (vector-ref (cdr x) 1)
                (let ((tbl (make-table test: eq?)))
                  (ctx-rev-imports-set!
                   ctx
                   (cons (cons name (vector idmap tbl))
                         (ctx-rev-imports ctx)))
                  tbl))))
      (for-each (lambda (x)
                  (let* ((external-id (car x))
                         (internal-id (cdr x))
                         (imports-tbl (ctx-imports-tbl ctx))
                         (existing-mapping
                          (table-ref imports-tbl external-id #f)))
                    (if (and existing-mapping
                             ;; ignore redundant imports from a given library
                             (not (eq? internal-id existing-mapping)))
                        (##raise-expression-parsing-exception
                         'duplicate-identifier-import
                         import-set-src
                         external-id)
                        (begin
                          (let ((m (assq internal-id (idmap-macros idmap))))
                            (if m ;; a macro is being imported, so remember def
                                (table-set! (ctx-macros-tbl ctx)
                                            internal-id
                                            (cdr m))))
                          (table-set! imports-tbl
                                      external-id
                                      internal-id)
                          (table-set! tbl
                                      internal-id
                                      external-id)))))
                (idmap-mapping idmap))))

  (define (parse-export-decl ctx export-specs-srcs)
    (if (pair? export-specs-srcs)
        (let* ((export-spec-src (car export-specs-srcs))
               (export-spec (##source-strip export-spec-src))
               (rest-srcs (cdr export-specs-srcs)))

          (define (export-spec-err)
            (##raise-expression-parsing-exception
             'ill-formed-export-spec
             export-spec-src))

          (cond ((symbol? export-spec)
                 (add-identifier-export!
                  ctx
                  export-spec-src
                  export-spec-src)
                 (parse-export-decl ctx rest-srcs))

                ((pair? export-spec)
                 (let* ((head-src (car export-spec))
                        (head (##source-strip head-src))
                        (args-srcs (cdr export-spec)))
                   (case head

                     ((rename)
                      (if (not (and (pair? args-srcs)
                                    (pair? (cdr args-srcs))
                                    (null? (cddr args-srcs))))
                          (export-spec-err)
                          (let* ((internal-id-src (car args-srcs))
                                 (internal-id (##source-strip internal-id-src))
                                 (external-id-src (cadr args-srcs))
                                 (external-id (##source-strip external-id-src)))
                            (if (not (and (symbol? internal-id)
                                          (symbol? external-id)))
                                (export-spec-err)
                                (begin
                                  (add-identifier-export!
                                   ctx
                                   internal-id-src
                                   external-id-src)
                                  (parse-export-decl ctx rest-srcs))))))

                     (else
                      (export-spec-err)))))

                (else
                 (export-spec-err))))))

  (define (parse-import-decl ctx import-sets-srcs)
    (if (pair? import-sets-srcs)
        (let* ((import-set-src (car import-sets-srcs))
               (rest-srcs (cdr import-sets-srcs))
               (idmap
                (parse-import-set import-set-src
                                  (ctx-module-aliases ctx)
                                  (ctx-name ctx))))
          (add-imports! ctx import-set-src idmap)
          (parse-import-decl ctx rest-srcs))))

  (define (parse-begin-decl ctx body-srcs)
    (ctx-rev-body-set! ctx (append (reverse body-srcs) (ctx-rev-body ctx))))

  (define (parse-include ctx filenames-srcs lib-decl-src kind)
    (if (pair? filenames-srcs)
        (let* ((filename-src (car filenames-srcs))
               (rest-srcs (cdr filenames-srcs))
               (x (read-file-as-a-begin-expr lib-decl-src filename-src)))
          (append (if (eq? kind 'include-library-declarations)
                      (cdr (##source-strip x))
                      (list (cons 'begin (cdr (##source-strip x)))))
                  (parse-include ctx rest-srcs lib-decl-src kind)))
        '()))

  (define (resolve-id ctx sym)
    (if (##full-name? sym)
        sym
        (##make-full-name (ctx-namespace ctx)
                          sym)))

  (define (parse-macros ctx body)
    (let loop ((expr-srcs body))
      (if (pair? expr-srcs)
          (let* ((expr-src (car expr-srcs))
                 (expr (##source-strip expr-src))
                 (head
                  (and (pair? expr)
                       (##source-strip (car expr)))))
            (cond ((memq head '(begin ##begin))
                   (loop
                    (append (cdr expr) (cdr expr-srcs))))
                  ((table-ref (ctx-type-definers-tbl ctx) head #f) =>
                   (lambda (define-type-expand-params)
                     (loop
                      (cons
                       (##sourcify-deep
                        (apply
                         ##define-type-expand
                         (append define-type-expand-params
                                 (list (map ##desourcify (cdr expr)))))
                        expr-src)
                       (cdr expr-srcs)))))
                  (else
                   (let* ((def-syntax?
                            (memq head '(define-syntax ##define-syntax)))
                          (def-macro?
                            (memq head '(define-macro ##define-macro)))
                          (sym
                           (and (pair? expr)
                                (pair? (cdr expr))
                                (pair? (cddr expr))
                                (let ((x (##source-strip (cadr expr))))
                                  (cond (def-syntax?
                                          (and (null? (cdddr expr))
                                               x))
                                        (def-macro?
                                          (if (pair? x)
                                              (##source-strip (car x))
                                              x))
                                        (else
                                         #f))))))
                     (if (not (symbol? sym))
                         (loop (cdr expr-srcs)) ;; keep looking for syntax defs
                         (let* ((id
                                 (resolve-id ctx sym))
                                (val-src
                                 (caddr expr))
                                (val
                                 (##source-strip val-src))
                                (def
                                 (##make-source
                                  (if def-syntax?
                                      (if (and (pair? val)
                                               (eq? (##source-strip (car val))
                                                    'syntax-rules))
                                          (let ((crules
                                                 (syn#syntax-rules->crules val-src)))
                                            `(##define-syntax ,id
                                               (##lambda (##src)
                                                         (syn#apply-rules ',crules
                                                                          ##src))))
                                          `(##define-syntax ,id ,val-src))
                                      `(##define-macro ,id
                                         ,(##definition-value expr-src)))
                                  (##source-locat expr-src))))

                           (if (table-ref (ctx-exports-tbl ctx) sym #f) ;;exported?
                               (if (table-ref (ctx-macros-tbl ctx) id #f) ;; already def?
                                   (##raise-expression-parsing-exception
                                    'duplicate-exported-macro-definition
                                    expr-src)
                                   (table-set! (ctx-macros-tbl ctx) id def)))

                           ;; replace original define-syntax by def with resolved id
                           (set-car! expr-srcs def)

                           (let* ((def-body
                                    (caddr (##desourcify def)))
                                  (define-type-expand-params
                                   (and (eqv? (##proper-length def-body) 3)
                                        (eq? (list-ref def-body 0) '##lambda)
                                        (eq? (list-ref def-body 1) 'args)
                                        (let ((x (list-ref def-body 2)))
                                          (and (eqv? (##proper-length x) 5)
                                               (eq? (list-ref x 0)
                                                    '##define-type-expand)
                                               (eq? (list-ref x 4)
                                                    'args)
                                               (list (cadr (list-ref x 1))
                                                     (cadr (list-ref x 2))
                                                     (cadr (list-ref x 3))))))))
                             (if define-type-expand-params
                                 (table-set! (ctx-type-definers-tbl ctx)
                                             sym
                                             define-type-expand-params)))

                           (loop (cdr expr-srcs)))))))))))

  (define (parse-string-args base args-srcs err)
    (if (pair? args-srcs)
      (let ((args (##source-strip (car args-srcs)))
            (rest-srcs (cdr args-srcs)))
        (if (string? args)
          (parse-string-args (cons args base) rest-srcs err)
          (err)))
      base))

  (define (has-suffix? str suffix)
    (let ((str-len (string-length str))
          (suffix-len (string-length suffix)))
      (and (<= suffix-len str-len)
           (string=?
             suffix
             (substring str (- str-len suffix-len) str-len)))))

  (define (join-rev path lst)
    (if (pair? lst)
      (join-rev
        (path-expand path (car lst))
        (cdr lst))
      path))

  (let ((form (##source-strip src)))
    (if (not (and (pair? form)
                  (eq? 'define-library (##source-strip (car form)))))

        ;; Provide src information to the caller.
        src
        #;(##raise-expression-parsing-exception
         'define-library-expected
         src)

        (##deconstruct-call
         src
         -2
         (lambda (name-src . body-srcs)
           ;;TODO: deprecated interface
           (let* ((comp-ctx (##compilation-ctx))
                  (module-ref (or modref-str (macro-compilation-ctx-module-ref comp-ctx)))
                  (module-root (table-ref (##compilation-scope) '##module-root module-root))
                  (modref-path (table-ref (##compilation-scope) '##modref-path modref-path))

                  ;; ("A" "B" "C")
                  (dot-and-modref
                    (parse-name name-src #f))

                  (name-default (if (> 0 (car dot-and-modref))
                                    (##raise-expression-parsing-exception
                                      'invalid-module-name
                                      name-src)
                                    (cdr dot-and-modref)))

                  ;; "A/B/C"
                  (name-default-string (##modref->string name-default))

                  (library-name (if module-ref
                                  (cond
                                    ((symbol? module-ref)
                                     (##symbol->string module-ref))
                                    (else module-ref))
                                  name-default-string))

                  (modref (##parse-module-ref library-name))

                  ;; Test if modref-path == .../ + name-default-string
                  #;(valid? (if (not (macro-modref-host modref))
                            (has-suffix? library-name name-default-string)
                            (let ((mod-path (macro-modref-rpath modref)))
                              (has-suffix?
                                (join-rev (car mod-path) (cdr mod-path))
                                name-default-string))))

                  (ctx
                   (make-ctx src
                             name-src
                             library-name
                             (##modref->namespace modref) ;; namespace
                             (make-table test: eq?) ;; exports-tbl
                             (make-table test: eq?) ;; imports-tbl
                             (make-table test: eq?) ;; macros-tbl
                             (make-table test: eq?) ;; type-definers-tbl
                             (make-table test: eq?) ;; meta-info-tbl
                             '()
                             '()
                             '()
                             (##extend-aliases-from-rpath modref-path
                                                          module-root))))

             (let ((tbl (ctx-type-definers-tbl ctx)))
               (table-set! tbl 'define-type        '(define-type #f #f))
               (table-set! tbl '##define-type      '(define-type #f #f))
               (table-set! tbl 'define-structure   '(define-structure #f #f))
               (table-set! tbl '##define-structure '(define-structure #f #f)))

             (parse-body ctx body-srcs)

             (for-each (lambda (args-srcs)
                         (parse-export-decl ctx args-srcs))
                       (reverse (ctx-rev-pending-exports ctx)))

             (let ((body (reverse (ctx-rev-body ctx))))

               (parse-macros ctx body)

               (let ((ctxsrc (ctx-src ctx))
                     (exports (ctx-exports-tbl ctx))
                     (imports (ctx-rev-imports ctx)))

                 (make-libdef
                  ctxsrc
                  (ctx-name-src ctx)
                  (ctx-name ctx)
                  (ctx-namespace ctx)

                  (table->list (ctx-meta-info-tbl ctx))

                  (make-idmap
                   (ctx-src ctx)
                   (ctx-name-src ctx)
                   (ctx-name ctx)
                   (ctx-namespace ctx)
                   (table->list (ctx-macros-tbl ctx))
                   (and (null? body) (null? imports)) ;; Replace with good value
                   (table->list exports))

                  (map cdr (reverse imports))

                  body)))))))))

(define (parse-import-set import-set-src module-aliases #!optional (ctx-library #f))
  (let ((import-set (##source-strip import-set-src)))

    (define (import-set-err)
      (##raise-expression-parsing-exception
       'ill-formed-import-set
       import-set-src))

    (define (ill-formed-library-name)
      (##raise-expression-parsing-exception
       'ill-formed-library-name
       import-set-src))

    (define (define-library-expected src)
      (##raise-expression-parsing-exception
       'define-library-expected
       src))

    (if (pair? import-set)

      (let* ((head-src (car import-set))
             (head (##source-strip head-src))
             (args-srcs (cdr import-set)))
        (if (memq head '(rename prefix only except))

          (if (not (pair? args-srcs))
            (import-set-err)
            (let ((idmap (parse-import-set (car args-srcs) module-aliases ctx-library)))
              (if (not (idmap-namespace idmap))
                  (define-library-expected (idmap-src idmap))
                  (case head

                    ((rename)
                     (let loop ((lst (cdr args-srcs)) (renames '()))
                       (cond ((null? lst)
                              (make-idmap
                                import-set-src
                                (idmap-name-src idmap)
                                (idmap-name idmap)
                                (idmap-namespace idmap)
                                (idmap-macros idmap)
                                (idmap-only-export? idmap)
                                (append (map (lambda (r)
                                               (cons (cdr r) (cdar r)))
                                             renames)
                                        (keep (lambda (x)
                                                (not (assq x renames)))
                                              (idmap-mapping idmap)))))
                             ((pair? lst)
                              (let* ((ren-src (car lst))
                                     (ren (##source-strip ren-src)))
                                (if (not (and (pair? ren)
                                              (pair? (cdr ren))
                                              (null? (cddr ren))))
                                  (import-set-err)
                                  (let* ((id1-src (car ren))
                                         (id1 (##source-strip id1-src))
                                         (id2-src (cadr ren))
                                         (id2 (##source-strip id2-src)))
                                    (if (not (and (symbol? id1)
                                                  (symbol? id2)))
                                      (import-set-err)
                                      (let ((x
                                              (assq id1 (idmap-mapping idmap))))
                                        (if (not x)
                                          (##raise-expression-parsing-exception
                                           'unexported-identifier
                                           id1-src
                                           id1)
                                          (loop (cdr lst)
                                                (cons (cons x id2)
                                                      renames)))))))))
                             (else
                               (import-set-err)))))

                    ((prefix)
                     (if (not (and (pair? (cdr args-srcs))
                                   (null? (cddr args-srcs))))
                       (import-set-err)
                       (let* ((prefix-src
                                (cadr args-srcs))
                              (prefix
                                (##source-strip prefix-src)))
                         (if (not (symbol? prefix))
                           (import-set-err)
                           (make-idmap
                             import-set-src
                             (idmap-name-src idmap)
                             (idmap-name idmap)
                             (idmap-namespace idmap)
                             (idmap-macros idmap)
                             (idmap-only-export? idmap)
                             (let ((prefix-str (symbol->string prefix)))
                               (map (lambda (x)
                                      (cons (string->symbol
                                              (string-append
                                                prefix-str
                                                (symbol->string (car x))))
                                            (cdr x)))
                                    (idmap-mapping idmap))))))))

                    (else
                      (let* ((ids
                              (map (lambda (id-src)
                                     (let ((id (##source-strip id-src)))
                                       (if (not (symbol? id))
                                         (##raise-expression-parsing-exception
                                          'id-expected
                                          id-src)
                                         (if (not (assq id (idmap-mapping idmap)))
                                           (##raise-expression-parsing-exception
                                            'unexported-identifier
                                            id-src
                                            id)
                                           id))))
                                   (cdr args-srcs)))
                            (keep-id
                             (lambda (x)
                               (eq? (eq? head 'except)
                                    (not (memq (car x) ids))))))
                        (make-idmap
                          import-set-src
                          (idmap-name-src idmap)
                          (idmap-name idmap)
                          (idmap-namespace idmap)
                          (keep keep-id (idmap-macros idmap))
                          (idmap-only-export? idmap)
                          (keep keep-id (idmap-mapping idmap)))))))))

          (let* ((dot-and-modref (parse-name import-set-src ctx-library))

                 (dot (car dot-and-modref))
                 (modref (cdr dot-and-modref))

                 (import-modref
                   (if ctx-library
                       (if (##= 0 dot)
                           modref
                           (let ((ctx-modref (##parse-module-ref ctx-library)))
                             (let loop ((dot-count dot)
                                        (rpath (macro-modref-rpath ctx-modref)))
                             (if (##< 1 dot-count)
                                 (if (##pair? (##cdr rpath))
                                     (loop (##- dot-count 1) (##cdr rpath))
                                     (ill-formed-library-name))
                                 (macro-make-modref
                                   (macro-modref-host ctx-modref)
                                   (macro-modref-tag ctx-modref)
                                   (##append (macro-modref-rpath modref) rpath))))))

                       ;; Forbid global (import (..foo)) out of library context
                       (if (##< 0 dot)
                           (ill-formed-library-name)
                           modref)))

                 (module-ref (##string->symbol (##modref->string import-modref))))

            (call-with-values
             (lambda ()
               (get-libdef
                 (##make-source module-ref (##source-locat import-set-src))
                 import-set-src))
             (lambda (ld import-name)
               (make-idmap
                 (if (##source? ld)
                     ld
                     import-set-src)
                 import-set-src
                 import-name
                 (and (libdef? ld) (libdef-namespace ld))
                 (and (libdef? ld) (idmap-macros (libdef-exports ld)))
                 (and (libdef? ld) (null? (libdef-body ld)) (null? (libdef-imports ld)))
                 (and (libdef? ld) (idmap-mapping (libdef-exports ld)))))))))

      (if (symbol? import-set)
          (parse-import-set (##make-source
                             (list import-set)
                             (##source-locat import-set-src))
                            module-aliases
                            ctx-library)
          (import-set-err)))))

(define debug-expansion? #f)

(define (debug-expansion?-set! val)
  (set! debug-expansion? val))

(define (show-expansion thing src)
  (if thing
      (begin
        (display ";; expansion of ")
        (write thing)
        (newline)
        (let ((x (##desourcify src)))
          (if (and (pair? x) (eq? (car x) '##begin))
              (for-each pretty-print (cdr x))
              (pretty-print x)))))
  src)

(define (define-library-expand src)
  (let* ((ld
          (parse-define-library src #f #f #f))
         (ld-imports
          (apply
           append
           (map (lambda (x)
                  (let* ((idmap (vector-ref x 0))
                         (imports (vector-ref x 1)))
                    (if (not (idmap-namespace idmap))

                        ;; Fallback to gambit ##import.
                        `((##import ,(idmap-name idmap)))

                        (append

                         (let ((name-symbol (idmap-name idmap)))
                           (if (idmap-only-export? idmap)
                               `()
                               `((##demand-module ,name-symbol))))

                         (mapping->namespace-declaration
                          (table->list imports))

                         (apply
                          append
                          (map (lambda (m)
                                 (let ((id (car m)))
                                   (if (table-ref imports id #f) ;; macro is imported?
                                       `(,(cdr m))
                                       '())))
                               (idmap-macros idmap)))))))

                (libdef-imports ld)))))
    (show-expansion
     (and debug-expansion?
          (let ((s (##desourcify src)))
            (list (car s) (cadr s) '...)))
     (##expand-source-template
      src
      (if (and (null? (libdef-body ld)) (null? ld-imports))
          `(##begin) ;; empty library
          `(##begin
            (##declare (block))
            (##supply-module ,(string->symbol (libdef-name ld)))
            ,@(map (lambda (kv)
                     `(##meta-info ,(car kv) ,@(cdr kv)))
                   (libdef-meta-info ld))
            (##namespace (,(libdef-namespace ld)))
            ,@ld-imports
            ,@(libdef-body ld)
            (##namespace (""))))))))

(define (mapping->namespace-declaration mapping)
  (if (pair? mapping)
      `((##namespace (""
                      ,@(map (lambda (i)
                               (if (eq? (car i) (cdr i))
                                   (car i)
                                   (list (cdr i) (car i))))
                             mapping))))
      '()))

(define (import-expand src)

  ;; Local ctx
  (define rev-global-imports '())

  (let* ((src-path (##source-path src))
         (rpath
           (if (##not src-path)
               '()
               (##table-ref (##compilation-scope) ;; TODO: deprecated interface
                             '##modref-path '())))

         (root
           (if (##not src-path)
               (##current-directory)
               (##table-ref (##compilation-scope) ;; TODO: deprecated interface
                            '##module-root (##path-directory src-path))))

         (module-aliases (##extend-aliases-from-rpath rpath root)))

  (##deconstruct-call
   src
   -2
   (lambda args-srcs
     (map
       (lambda (args-src)
         (let ((idmap (parse-import-set args-src module-aliases #f)))
           (set! rev-global-imports (cons idmap rev-global-imports))))
       args-srcs)))

  (show-expansion
   (and debug-expansion?
        (##desourcify src))
   (##expand-source-template
    src
    (let ((forms
           (apply
            append
            (map (lambda (idmap)
                   (if (not (idmap-namespace idmap))

                       ;; This was not a define-library import.
                       `((##import ,(idmap-name idmap)))

                       (append

                        ;; Decide if the module needed to have to be loaded. (only exports symbols).
                        (let ((symbol-name (idmap-name idmap)))
                          (if (idmap-only-export? idmap)
                              `()
                              `((##demand-module ,symbol-name))))

                        (mapping->namespace-declaration
                         (map (lambda (x) (cons (cdr x) (car x)))
                              (idmap-mapping idmap)))

                        ;; Macro Handler !!!
                        (apply
                         append
                         (map (lambda (m)
                                `(,(cdr m)))
                              (idmap-macros idmap))))))

                 rev-global-imports))))

      (if (and (pair? forms) (null? (cdr forms)))
          (car forms)
          `(##begin ,@forms)))))))

;;;============================================================================
