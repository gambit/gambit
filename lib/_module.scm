;;;============================================================================

;;; File: "_module.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "_module#.scm")

(implement-type-modref)

;;;----------------------------------------------------------------------------

(define ##module-search-order
  '("~~userlib"
    "~~lib"))

(define-prim (##module-search-order-set! x)
  (set! ##module-search-order x))

;;;----------------------------------------------------------------------------

(define-prim (##modref->string modref #!optional (namespace? #f))
  (let* ((rpath
          (##reverse (macro-modref-path modref)))
         (parts
          (##append (##reverse (macro-modref-host modref))
                    (##cons (##car rpath)
                            (##append (##reverse (macro-modref-tag modref))
                                      (##cdr rpath)))))
         (name
          (##append-strings
           (##map (lambda (x)
                    (##string-append x "/"))
                  parts))))
    (let ((len-1 (##fx- (##string-length name) 1)))
      (if namespace?
          (##string-set! name len-1 #\#)
          (##string-shrink! name len-1)))
    name))

(define-prim (##string->modref str)
  (let ((x (##parse-module-ref str)))
    (and x
         (##fx= (##car x) 0)
         (##cdr x))))

;;;----------------------------------------------------------------------------

(define-prim (##parse-module-ref str-or-src)

  (define (valid-module-ref-part? x)
    (or (##symbol? x)
        (and (macro-exact-int? x) (##not (##negative? x)))))

  (define (module-ref-part->string x)
    (if (##symbol? x)
        (##symbol->string x)
        (##number->string x)))

  (define (split-at-path-sep str rest)
    (and rest
         (##string-split-at str #\/ rest)))

  (define (split-rest lst)
    (if (##pair? lst)
        (let ((x (##source-strip (##car lst))))
          (and (valid-module-ref-part? x)
               (split-at-path-sep (module-ref-part->string x)
                                  (split-rest (##cdr lst)))))
        (if (##null? lst)
            '()
            #f)))

  (define (valid-component? str in-hostname?)
    (let ((len (##string-length str)))
      (and (##fx> len 0)
           (or (##not in-hostname?)
               (##not (or (##char=? (##string-ref str 0) #\-)
                          (##char=? (##string-ref str (##fx- len 1)) #\-))))
           (let loop ((i (##fx- len 1)))
             (if (##fx< i 0)
                 #t
                 (let ((c (##string-ref str i)))
                   (if (or (and (##char>=? c #\a) (##char<=? c #\z))
                           (and (##char>=? c #\A) (##char<=? c #\Z))
                           (and (##char>=? c #\0) (##char<=? c #\9))
                           (##char=? c #\-)
                           (and (##not in-hostname?)
                                (or (##char=? c #\_)
                                    (##char=? c #\.))))
                       (loop (##fx- i 1)))))))))

  (define (valid-components? lst in-hostname?)
    (if (##pair? lst)
        (and (valid-component? (##car lst) in-hostname?)
             (valid-components? (##cdr lst) in-hostname?))
        #t))

  (define (valid-hostname? str)
    (let ((x (##string-split-at str #\. '())))
      (and (##pair? x)
           (##pair? (##cdr x))
           (valid-components? x #t))))

  (define (parse-hosted hostname parts)
    (and (##pair? parts)
         (let ((username (##car parts))
               (parts (##cdr parts)))
           (and (##pair? parts)
                (let ((repo (##car parts))
                      (parts (##cdr parts)))
                  (if (##pair? parts)
                      (let ((tree (##car parts))
                            (parts (##cdr parts)))
                        (and (##pair? parts)
                             (let ((tag (##car parts))
                                   (parts (##cdr parts)))
                               (macro-make-modref
                                (##list username hostname)
                                (##list tag tree)
                                (##reverse (##cons repo parts))))))
                      (macro-make-modref
                       (##list username hostname)
                       '()
                       (##list repo))))))))

  (define (validate-rest nb-dots parts)
    (and (##pair? parts)
         (valid-components? (##cdr parts) #f)
         (let ((head (##car parts)))
           (if (valid-hostname? head)
               (let ((modref (parse-hosted head (##cdr parts))))
                 (and modref
                      (##cons nb-dots modref)))
               (and (valid-component? head #f)
                    (##cons nb-dots
                            (macro-make-modref
                             '()
                             '()
                             (##reverse parts))))))))

  (define (parse-head-rest head-str rest)
    (let ((len-head-str (##string-length head-str)))
      (let loop ((nb-dots 0))
        (if (##fx< nb-dots len-head-str)
            (if (##char=? (##string-ref head-str nb-dots) #\.)
                (loop (##fx+ nb-dots 1))
                (validate-rest
                 nb-dots
                 (split-at-path-sep
                  (##substring head-str nb-dots len-head-str)
                  (split-rest rest))))
            (validate-rest
             nb-dots
             (split-rest rest))))))

  (define (parse head rest)
    (and (valid-module-ref-part? head)
         (let ((head-str (module-ref-part->string head)))
           (parse-head-rest head-str rest))))

  (if (##string? str-or-src)
      (parse-head-rest str-or-src '())
      (let ((code (##source-strip str-or-src)))
        (if (##pair? code)
            (parse (##source-strip (##car code))
                   (##cdr code))
            (parse code
                   '())))))

(define-prim (##string-split-at str sep #!optional (rest '()))
  (let ((len (##string-length str)))
    (let loop ((i (##fx- len 1)) (j len) (lst rest))
      (if (##fx< i 0)
          (##cons (##substring str 0 j) lst)
          (let ((c (##string-ref str i)))
            (if (##char=? c sep)
                (loop (##fx- i 1)
                      i
                      (##cons (##substring str (##fx+ i 1) j) lst))
                (loop (##fx- i 1)
                      j
                      lst)))))))

;;;----------------------------------------------------------------------------

(define-prim (##search-module-aux
              modref
              check-mod
              #!optional
              (search-order ##module-search-order))

  (define (last lst)
    (if (##pair? (##cdr lst))
        (last (##cdr lst))
        (##car lst)))

  (define (butlast lst)
    (if (##pair? (##cdr lst))
        (##cons (##car lst) (butlast (##cdr lst)))
        '()))

  (define (join parts dir)
    (if (##pair? parts)
        (##path-expand (##car parts)
                       (join (##cdr parts) dir))
        dir))

  (define (search-dir dir)

    (define (search dirs nested-dirs root check-mod)
      (and (##pair? dirs)
           (let ()

             (define (check dirs2)
               (check-mod (##car dirs) (join dirs2 root)))

             (or (check nested-dirs)
                 (and (##pair? nested-dirs)
                      (check (##cdr nested-dirs)))))))

    (let ((path (macro-modref-path modref)))
      (if (and (##null? (macro-modref-host modref))
               (##null? (macro-modref-tag modref)))

          (search path
                  path
                  dir
                  check-mod)

          (search path
                  (butlast path)
                  (join (macro-modref-tag modref)
                        (##path-expand (last path)
                                       (join (macro-modref-host modref)
                                             dir)))
                  check-mod))))

  (let loop ((lst search-order))
    (and (##pair? lst)
         (let ((search-in (##car lst)))
           (or (search-dir (##path-expand search-in))
               (loop (##cdr lst)))))))

(define-prim (##search-module
              modref
              #!optional
              (search-order ##module-search-order))

  (define (try-opening-source-file path cont)
    (if ##debug-modules? (pp (list 'try-opening-source-file path)));;;;;;;;;;;;;;
    (##make-input-path-psettings
     (##list 'path: path
             'char-encoding: 'UTF-8
             'eol-encoding: 'cr-lf)
     (lambda ()
       #f)
     (lambda (psettings)
       (let ((path (macro-psettings-path psettings)))
         (##open-file-generic-from-psettings
          psettings
          #f ;; raise-os-exception?
          cont
          open-input-file
          path
          (macro-absent-obj))))))

  (define (check-mod mod-filename-noext mod-dir)
    (let ((mod-path-noext (##path-expand mod-filename-noext mod-dir)))

      (define (check-source-with-ext ext)
        (let ((mod-path (##string-append mod-path-noext (##car ext))))
          (try-opening-source-file
           mod-path
           (lambda (port)
             (and (##not (##fixnum? port))
                  (##vector mod-dir mod-filename-noext ext mod-path port))))))

      (let loop ((exts ##scheme-file-extensions))
        (and (##pair? exts)
             (or (check-source-with-ext (##car exts))
                 (loop (##cdr exts)))))))

  (##search-module-aux modref check-mod search-order))

(define-prim (##module-build-subdir-path mod-dir mod-filename-noext target)
  (##path-expand (##module-build-subdir-name mod-filename-noext target)
                 mod-dir))

(define-prim (##module-build-subdir-name mod-filename-noext target)
  (##string-append mod-filename-noext
                   "@gambit"
                   (##module-system-configuration-string target)))

(define-prim (##module-system-configuration-string target)
  (##string-append (##number->string (##system-version))
                   "@"
                   (##symbol->string target)))

;;;----------------------------------------------------------------------------

(define (##compile-mod top-cte src module-ref)
  (##compile-in-compilation-scope
   top-cte
   src
   #f
   (lambda (cte src tail?)
     (##table-set! (##compilation-scope) '##module-ref module-ref)
     (let ((tail? #f))
       (##comp-top top-cte src tail?)))))

(define-prim (##get-module-from-file module-ref modref mod-info)

  (define (err)
    (##raise-module-not-found-exception
     ##get-module
     module-ref))

  (define (search-for-highest-object-file path-noext)
    (let loop ((version 1)
               (highest-object-file-path #f)
               (highest-object-file-info #f))
      (let* ((resolved-path
              (##path-resolve
               (##string-append path-noext
                                ".o"
                                (##number->string version 10))))
             (_ (if ##debug-modules? (pp (list '##file-info resolved-path))));;;;;;;;;;;;;
             (resolved-info
              (##file-info resolved-path))
             (resolved-path-exists?
              (##not (##fixnum? resolved-info))))
        (if resolved-path-exists?
            (loop (##fx+ version 1)
                  resolved-path
                  resolved-info)
            highest-object-file-path))))

  (let ((mod-dir            (##vector-ref mod-info 0))
        (mod-filename-noext (##vector-ref mod-info 1))
        (ext                (##vector-ref mod-info 2))
        (mod-path           (##vector-ref mod-info 3))
        (port               (##vector-ref mod-info 4)))

    (define (get-from-source-file)
      (let ((x
             (##read-all-as-a-begin-expr-from-port
              port
              ##main-readtable
              ##wrap-datum
              ##unwrap-datum
              (##cdr ext) ;; start-syntax
              #t          ;; close-port?
              '())))
        (if (##fixnum? x)
            (##raise-os-exception
             #f
             x
             ##get-module
             module-ref)
            (let* ((script-line
                    (##vector-ref x 0))
                   (src
                    (##vector-ref x 1))
                   (module-name
                    (##symbol->string module-ref))
                   (c
                    (##compile-mod
                     (##top-cte-clone ##interaction-cte)
                     (##sourcify src (##make-source #f #f))
                     module-ref))
                   (code
                    (##car c))
                   (comp-scope
                    (##cdr c))
                   (supply-modules
                    (##table-ref comp-scope '##supply-modules '()))
                   (demand-modules
                    (##table-ref comp-scope '##demand-modules '()))
                   (module-descr
                    (##vector (##list->vector
                               (if (##not (##memq module-ref supply-modules))
                                   (##append supply-modules
                                             (##list module-ref))
                                   supply-modules))
                              (##list->vector demand-modules)
                              (if script-line
                                  (##list (##cons 'script-line script-line))
                                  '())
                              0
                              (lambda ()
                                (let ((rte #f))
                                  (macro-code-run code)))
                              #f)))
              (##register-module-descrs (##vector module-descr))
              (or (##lookup-registered-module module-ref)
                  (err))))))

    (define (get-from-object-file path)
      (##close-port port)
      (let* ((linker-name
              (##path-strip-directory path))
             (_ (if ##debug-modules? (pp (list '##os-load-object-file path linker-name))));;;;;;;;;;;;;
             (result
              (##os-load-object-file path linker-name)))

        (define (raise-error code)
          (if (##fixnum? code)
              (##raise-os-exception #f code ##get-module module-ref)
              (##raise-os-exception code #f ##get-module module-ref)))

        (cond ((##not (##vector? result))
               (raise-error result))
              ((##fx= 2 (##vector-length result))
               (raise-error (##vector-ref result 0)))
              (else
               (let ((module-descrs (##vector-ref result 0)))
                 (##register-module-descrs module-descrs)
                 (or (##lookup-registered-module module-ref)
                     (err)))))))

    (define (search-for-object-file mod-filename-noext dir)
      (search-for-highest-object-file
       (##path-expand mod-filename-noext dir)))

    (let ((object-file-path
           (or (search-for-object-file
                mod-filename-noext
                (##module-build-subdir-path mod-dir
                                            mod-filename-noext
                                            (macro-target)))
               (search-for-object-file
                mod-filename-noext
                mod-dir))))

      (if object-file-path
          (get-from-object-file object-file-path)
          (get-from-source-file)))))

(define-prim (##install-module modref)
  (if ##debug-modules? (pp (list '##install-module modref)));;;;;;;;;;;;;;;;;
  #f)

(define-prim (##install-module-set! x)
  (set! ##install-module x))

(define-prim (##search-or-else-install-module modref)
  (or (##search-module modref)
      (##install-module modref)))

(##get-module-set!
 (lambda (module-ref)

   (define (err)
     (##raise-module-not-found-exception
      ##get-module
      module-ref))

   (or (##lookup-registered-module module-ref)
       (let ((modref (##string->modref (##symbol->string module-ref))))
         (if (##not modref)
             (err)
             (let ((mod-info (##search-or-else-install-module modref)))
               (if mod-info ;; found module?
                   (##get-module-from-file module-ref modref mod-info)
                   (err))))))))

(define-prim (##load-module-or-file mod-str script-callback)

  (define (fallback)
    (##load mod-str
            script-callback
            #t   ;; clone-cte?
            #t   ;; raise-os-exception?
            #f   ;; linker-name
            #f)) ;; quiet?

  (if (##not (##string=? "" (##path-extension mod-str)))
      (fallback)
      (let ((modref (##string->modref mod-str)))
        (if (##not modref)
            (fallback)
            (let ((module-ref (##string->symbol mod-str)))
              (or (##lookup-registered-module module-ref)
                  (let ((mod-info (##search-module
                                   modref
                                   (##cons "" ##module-search-order))))
                    (if mod-info ;; found module?
                        (let* ((module
                                (##get-module-from-file module-ref
                                                        modref
                                                        mod-info))
                               (module-descr
                                (macro-module-module-descr module))
                               (meta-info
                                (macro-module-descr-meta-info module-descr))
                               (x
                                (##assq 'script-line meta-info)))
                          (if x
                              (script-callback (##cdr x)
                                               (##vector-ref mod-info 3)))
                          (##load-module (macro-module-module-ref module)))
                        (fallback)))))))))

(define ##debug-modules? #f)

(define-prim (##debug-modules?-set! x)
  (set! ##debug-modules? x))

;;;----------------------------------------------------------------------------

(define-runtime-syntax ##include*
  (lambda (src)
    (##deconstruct-call
     src
     2
     (lambda (arg-src)
       (let ((x (##parse-module-ref arg-src)))
         (if (or (##not x) (##not (##fx= (##car x) 0)))
             (##raise-expression-parsing-exception
              'ill-formed-special-form
              src
              (##source-strip (##car (##source-strip src))))
             (let* ((modref (##cdr x))
                    (mod-info (##search-or-else-install-module modref)))
               (if (##not mod-info)
                   (##raise-expression-parsing-exception
                    'module-not-found
                    src
                    (##desourcify arg-src))
                   (let ((path
                          (##path-expand (##string-append
                                          (##vector-ref mod-info 1)
                                          "#"
                                          (##car (##vector-ref mod-info 2)))
                                         (##vector-ref mod-info 0)))
                         (port
                          (##vector-ref mod-info 4)))
                     (if port
                         (##close-port port))
                     (if (##file-exists? path)
                         `(##include ,path)
                         `(##begin)))))))))))

;;;============================================================================
