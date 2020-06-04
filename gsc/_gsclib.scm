;;;============================================================================

;;; File: "_gsclib.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

(include "generic.scm")

;;;----------------------------------------------------------------------------

(set! make-global-environment ;; import runtime macros into compilation env
  (lambda ()

    (define (extract-macros cte)
      (if (##cte-top? cte)
        (env-frame #f '())
        (let ((parent-cte (##cte-parent-cte cte)))
          (if (##cte-macro? cte)
            (env-macro (extract-macros parent-cte)
                       (##cte-macro-name cte)
                       (##cte-macro-descr cte))
            (extract-macros parent-cte)))))

    (extract-macros (##cte-top-cte ##interaction-cte))))

(define (##compile-options-normalize options)
  (##map (lambda (opt)
           (if (##pair? opt)
               opt
               (##list opt)))
         options))

(define (##with-resolved-input-file module-or-file options callback)
  (let* ((modref (##parse-module-ref module-or-file))
         (mod-info (if modref
                       (##search-or-else-install-module modref)
                       #f))
         (file-path (if mod-info
                        (##vector-ref mod-info 3)
                        module-or-file))
         (base-dir (##path-directory
                    (##path-normalize file-path)))
         (target-dir (if mod-info
                         (##module-build-subdir-path
                          base-dir
                          (##path-strip-extension file-path)
                          (c#target-name (##extract-target options)))
                        base-dir))
         (temp-dir (and mod-info
                        ;; Create a temporary directory under the module output
                        ;; path with the name of '.gsc-temp-NNNN'
                        (##create-temporary-directory
                         (##path-expand
                          ".gsc-temp-"
                          ;; Create the target directory if it doesn't exist
                          (begin
                            (##create-directory target-dir #f)
                            target-dir)))))
         (options (if (##not modref)
                      options
                      (##cons
                         (##list 'module-ref
                                 (##string->symbol module-or-file))
                         options))))

    (let* ((output-file (callback file-path (or temp-dir target-dir) options))
           (target-file (##path-normalize
                         (##path-expand
                          (##path-strip-directory output-file)
                          target-dir))))
      (and modref
           (begin
             (##rename-file-if-changed output-file target-file)
             (##delete-file-or-directory temp-dir #t)))

      (if modref
          target-file
          output-file))))

(define (##files-equal? path1 path2)
  (##call-with-input-file
      path1
    (lambda (port1)
      (##call-with-input-file
          path2
        (lambda (port2)
          (let loop ()
            (let* ((chunk1 (read-bytevector 4096 port1))
                   (chunk2 (read-bytevector 4096 port2)))
              (and (equal? chunk1 chunk2)
                   (or (eof-object? chunk1)
                       (loop))))))))))

(define (##rename-file-if-changed old-path new-path)
  (and (or (not (##file-exists? new-path))
           (not (##files-equal? old-path new-path)))
       (##rename-file old-path new-path)))

(define (compile-file-to-target
         ;; REVIEW: Should this parameter be renamed to 'module-or-file'?
         filename
         #!rest other;;;;;;;;;;
         #!key
         (options (macro-absent-obj))
         (output (macro-absent-obj))
         (expression (macro-absent-obj)))
  (macro-force-vars (filename)
    (macro-check-string filename 1 (compile-file-to-target filename . other) ;;;;;;
      (##with-resolved-input-file
       filename
       (if (##eq? options (macro-absent-obj))
           '()
           (macro-force-vars (options)
             options))
       (lambda (filename target-dir opts)
         (let* ((out
                  (if (##eq? output (macro-absent-obj))
                      target-dir
                      (macro-force-vars (output)
                        output)))
                (filename-or-source
                  (if (##eq? expression (macro-absent-obj))
                      filename
                      (if (##source? expression)
                          expression
                          (##make-source
                            expression
                            (##make-locat (##path->container filename) 0))))))
        (cond ((##not (or (##null? opts)
                          (##pair? opts)))
               (error "list expected for options: parameter")) ;;;;;;;
              ((##not (##string? out))
               (error "string expected for output: parameter")) ;;;;;;;;;;
              (else
               (##compile-file-to-target filename-or-source
                                         opts
                                         out)))))))))

(define (##compile-file-to-target filename-or-source options output)
  (let* ((options
          (##compile-options-normalize options))
         (module-ref
          (cond ((##assq 'module-ref options) => ##cadr)
                (else #f)))
         (linker-name
          (cond ((##assq 'linker-name options) => ##cadr)
                (else #f))))
    (cond ((##not (or (##not module-ref) (##symbol? module-ref)))
           (error "symbol or #f expected for module-ref option"))
          ((##not (or (##not linker-name) (##string? linker-name)))
           (error "string or #f expected for linker-name option"))
          (else
           (let* ((filename
                   (if (##source? filename-or-source)
                       (##source-path filename-or-source)
                       filename-or-source))
                  (expanded-output
                   (##path-normalize output))
                  (output-directory?
                   (##not (##equal? expanded-output
                                    (##path-strip-trailing-directory-separator
                                     expanded-output))))
                  (output-filename-gen
                   (lambda ()
                     (if output-directory?
                         (##string-append
                          (##path-expand
                           (##path-strip-directory
                            (##path-strip-extension filename))
                           expanded-output)
                          (##caar target.file-extensions))
                         expanded-output)))
                  (mod-ref
                   (or module-ref
                       (##string->symbol
                        (##path-strip-directory
                         (##path-strip-extension
                          (if output-directory?
                              filename
                              expanded-output))))))
                  (options
                   (if module-ref
                       options
                       (##cons (##list 'module-ref mod-ref)
                               options)))
                  (options
                   (if linker-name
                       options
                       (##cons (##list 'linker-name (##symbol->string mod-ref))
                               options))))
             (c#cf filename-or-source
                   options
                   output-filename-gen))))))

(define (##string-or-string-list? x)
  (or (##string? x)
      (let loop ((lst x))
        (cond ((##pair? lst)
               (and (##string? (##car lst))
                    (loop (##cdr lst))))
              ((##null? lst)
               #t)
              (else
               #f)))))

(define (##string-or-string-list-join x sep)
  (if (##string? x)
      x
      (##append-strings x sep)))

(define (##multiple-args-join x)
  (##string-or-string-list-join x "\n"))

(define (compile-file
         ;; REVIEW: Should this parameter be renamed to 'module-or-file'?
         filename
         #!rest other;;;;;;;;;;
         #!key
         (options (macro-absent-obj))
         (output (macro-absent-obj))
         (base (macro-absent-obj))
         (cc-options (macro-absent-obj))
         (ld-options-prelude (macro-absent-obj))
         (ld-options (macro-absent-obj))
         (pkg-config (macro-absent-obj))
         (pkg-config-path (macro-absent-obj))
         (expression (macro-absent-obj)))

  (macro-force-vars (filename)
    (macro-check-string filename 1 (compile-file filename . other) ;;;;;;
      (##with-resolved-input-file
       filename
       (if (##eq? options (macro-absent-obj))
           '()
           (macro-force-vars (options)
             options))
       (lambda (filename target-dir opts)
         (let* ((out
                  (if (##eq? output (macro-absent-obj))
                      target-dir
                      (macro-force-vars (output)
                        output)))
                (bas
                  (if (##eq? base (macro-absent-obj))
                      #f
                      (macro-force-vars (base)
                        base)))
                (cc-opts
                  (if (##eq? cc-options (macro-absent-obj))
                      '()
                      (macro-force-vars (cc-options)
                        cc-options)))
                (ld-opts-prelude
                  (if (##eq? ld-options-prelude (macro-absent-obj))
                      '()
                      (macro-force-vars (ld-options-prelude)
                        ld-options-prelude)))
                (ld-opts
                  (if (##eq? ld-options (macro-absent-obj))
                      '()
                      (macro-force-vars (ld-options)
                        ld-options)))
                (pkg-cfg
                  (if (##eq? pkg-config (macro-absent-obj))
                      '()
                      (macro-force-vars (pkg-config)
                        pkg-config)))
                (pkg-cfg-path
                  (if (##eq? pkg-config-path (macro-absent-obj))
                      '()
                      (macro-force-vars (pkg-config-path)
                        pkg-config-path)))
                (filename-or-source
                  (if (##eq? expression (macro-absent-obj))
                      filename
                      (if (##source? expression)
                          expression
                          (##make-source
                            expression
                            (##make-locat (##path->container filename) 0))))))
            (cond ((##not (or (##null? opts)
                              (##pair? opts)))
                   (error "list expected for options: parameter")) ;;;;;;;
                  ((##not (##string? out))
                   (error "string expected for output: parameter")) ;;;;;;;;;;
                  ((##not (or (##string? bas) (##eq? bas #f)))
                   (error "string or #f expected for base: parameter")) ;;;;;;;;;;
                  ((##not (##string-or-string-list? cc-opts))
                   (error "string or string list expected for cc-options: parameter")) ;;;;;;;;;;
                  ((##not (##string-or-string-list? ld-opts-prelude))
                   (error "string or string list expected for ld-options-prelude: parameter")) ;;;;;;;;;;
                  ((##not (##string-or-string-list? ld-opts))
                   (error "string or string list expected for ld-options: parameter")) ;;;;;;;;;;
                  ((##not (##string-or-string-list? pkg-cfg))
                   (error "string or string list expected for pkg-config: parameter")) ;;;;;;;;;;
                  ((##not (##string-or-string-list? pkg-cfg-path))
                   (error "string or string list expected for pkg-config-path: parameter")) ;;;;;;;;;;
                  (else
                   (##compile-file filename-or-source
                                   opts
                                   out
                                   bas
                                   cc-opts
                                   ld-opts-prelude
                                   ld-opts
                                   pkg-cfg
                                   pkg-cfg-path)))))))))

(define (##compile-file
         filename-or-source
         options
         output
         base
         cc-options
         ld-options-prelude
         ld-options
         pkg-config
         pkg-config-path)
  (let* ((options
          (##compile-options-normalize options))
         (target
          (##extract-target options)))

    (define type
      (cond ((##assq 'obj options)
             'obj)
            ((##assq 'exe options)
             'exe)
            (else
             'dyn)))

    (define (generate-next-version-of-object-file root)
      (let loop ((version 1))
        (let ((root-with-ext
               (##string-append root ".o" (##number->string version 10))))
          (if (##file-exists? root-with-ext)
              (loop (##fx+ version 1))
              root-with-ext))))

    (define (generate-output-filename root input-is-target-file?)
      (case type
        ((obj)
         (##string-append
          root
          ##os-obj-extension-string-saved))
        (else
         (if input-is-target-file?
             root
             (generate-next-version-of-object-file root)))))

    (let* ((filename
            (if (##source? filename-or-source)
                (##source-path filename-or-source)
                filename-or-source))
           (input-is-target-file?
            (##assoc (##path-extension filename)
                     (c#target-file-extensions target)))
           (expanded-output
            (##path-normalize output))
           (target-filename
            (if input-is-target-file?
                filename
                (##string-append
                 (##path-expand
                  (##path-strip-directory
                   (##path-strip-extension filename))
                  expanded-output)
                 (##caar (c#target-file-extensions target)))))
           (output-directory?
            (##not (##equal? expanded-output
                             (##path-strip-trailing-directory-separator
                              expanded-output))))
           (output-filename
            (if output-directory?
                (generate-output-filename
                 (##path-expand
                  (##path-strip-directory
                   (##path-strip-extension filename))
                  expanded-output)
                 input-is-target-file?)
                expanded-output))
           (output-dir
            (##path-directory output-filename))
           (output-filename-no-dir
            (##path-strip-directory output-filename))
           (module-ref
            (cond ((##assq 'module-ref options) => ##cadr)
                  (else #f)))
           (mod-ref
            (or module-ref
                (##string->symbol
                 (##path-strip-extension output-filename-no-dir))))
           (linker-name
            (cond ((##assq 'linker-name options) => ##cadr)
                  (else #f)))
           (link-name
            (or linker-name
                (if (##eq? type 'dyn)
                    output-filename-no-dir
                    (##symbol->string mod-ref))))
           (options
            (if module-ref
                options
                (##cons (##list 'module-ref mod-ref) options)))
           (options
            (if linker-name
                options
                (##cons (##list 'linker-name link-name) options))))
      (and (or input-is-target-file?
               (c#cf filename-or-source
                     options
                     (lambda () target-filename)))
           (let* ((target-filename-relative-to-output-dir
                   (##path-relative-to-dir target-filename output-dir))
                  (exit-status
                   (##gambuild
                    (c#target-name target)
                    type
                    output-dir
                    (##assq 'verbose options)
                    (##gambuild-params
                     (##base-library-from-base base)
                     (##list target-filename-relative-to-output-dir)
                     output-filename-no-dir
                     cc-options
                     ld-options-prelude
                     ld-options
                     pkg-config
                     pkg-config-path
                     target-filename-relative-to-output-dir))))
             (if (and (##not (##assq 'keep-temp options))
                      (##not (##string=? filename target-filename)))
                 (##delete-file target-filename))
             (if (##fx= exit-status 0)
                 output-filename
                 (##raise-error-exception
                  "target compilation or link failed while compiling"
                  (##list filename))))))))

;; REVIEW: Is this procedure no longer necessary now that the
;;         compiler APIs can build modules directly?
(define (##build-module path target options)

  (define (get-option key)
    (cond ((##assq key options) => ##cdr)
          (else '())))

  (let* ((module-dir
          (##path-normalize (##path-directory path)))
         (module-filename
          (##path-strip-directory path))
         (module-filename-noext
          (##path-strip-extension module-filename))
         (module-object-filename
          (##string-append module-filename-noext ".o1"))
         (build-subdir
          (##module-build-subdir-path module-dir module-filename-noext target))
         (cc-options
          (get-option 'cc-options))
         (ld-options-prelude
          (get-option 'ld-options-prelude))
         (ld-options
          (get-option 'ld-options))
         (pkg-config
          (get-option 'pkg-config))
         (pkg-config-path
          (get-option 'pkg-config-path)))

    ;; create build subdirectory (removing it first to make sure it is empty)
    (##delete-file-or-directory build-subdir #t #f)
    (##create-directory build-subdir)

    (let* ((opts
            (##cons (##list 'target target)
                    (##cons
                     (##list 'linker-name module-object-filename)
                     options)))
           (target-file
            (##compile-file-to-target path opts build-subdir)))
      (and target-file
           (##compile-file
            target-file
            opts
            (##path-expand module-object-filename build-subdir)
            #f ;; base
            cc-options
            ld-options-prelude
            ld-options
            pkg-config
            pkg-config-path)
           build-subdir))))

(define (##build-executable
         base
         obj-files
         options
         output-filename
         cc-options
         ld-options-prelude
         ld-options
         pkg-config
         pkg-config-path
         meta-info-file)
  (let* ((options
          (##compile-options-normalize options))
         (target
          (##extract-target options))
         (output-dir
          (##path-directory output-filename))
         (output-filename-no-dir
          (##path-strip-directory output-filename))
         (exit-status
          (##gambuild
           (c#target-name target)
           'exe
           output-dir
           (##assq 'verbose options)
           (##gambuild-params
            (##base-library-from-base base)
            (##map (lambda (path) (##path-relative-to-dir path output-dir))
                   obj-files)
            output-filename-no-dir
            cc-options
            ld-options-prelude
            ld-options
            pkg-config
            pkg-config-path
            meta-info-file))))
    (if (##fx= exit-status 0)
        output-filename
        (##raise-error-exception
         "target link failed while linking"
         obj-files))))

(define (##path-relative-to-dir path dir)
  (##path-normalize (##path-expand path) #t dir))

(define (##gambuild-params
         base-library
         input-filenames
         output-filename
         cc-options
         ld-options-prelude
         ld-options
         pkg-config
         pkg-config-path
         meta-info-file)
  (##fold-right
   (lambda (param params)
     (if param (##cons param params) params))
   '()
   (##list (and base-library
                (##cons "BASE_LIBRARY"
                        base-library))
           (and input-filenames
                (##cons "INPUT_FILENAMES"
                        (##multiple-args-join input-filenames)))
           (and output-filename
                (##cons "OUTPUT_FILENAME"
                        output-filename))
           (and cc-options
                (##cons "CC_OPTIONS"
                        (##multiple-args-join cc-options)))
           (and ld-options-prelude
                (##cons "LD_OPTIONS_PRELUDE"
                        (##multiple-args-join ld-options-prelude)))
           (and ld-options
                (##cons "LD_OPTIONS"
                        (##multiple-args-join ld-options)))
           (and pkg-config
                (##cons "PKG_CONFIG"
                        (##multiple-args-join pkg-config)))
           (and pkg-config-path
                (##cons "PKG_CONFIG_PATH"
                        (##multiple-args-join pkg-config-path)))
           (and meta-info-file
                (##cons "META_INFO_FILE"
                        meta-info-file)))))

(define (##gambuild
         target
         op
         output-dir
         verbose?
         params)

  (define prefix "GAMBUILD_")

  (define param-prefix
    (case op
      ((obj) "BUILD_OBJ_")
      ((dyn) "BUILD_DYN_")
      ((lib) "BUILD_LIB_")
      ((exe) "BUILD_EXE_")
      (else  "BUILD_OTHER_")))

  (let* ((path
          (##path-expand
           (##string-append "gambuild-"
                            (##symbol->string target)
                            ##os-bat-extension-string-saved)
           (##path-normalize-directory-existing "~~bin")))
         (add-vars ;; pass arguments in shell environment variables
          (##append
           (if verbose?
               (##shell-var-bindings
                (##list (##cons "VERBOSE" "yes"))
                prefix
                "")
               '())
           (##shell-var-bindings
            params
            param-prefix)
           (##shell-var-bindings
            (##shell-install-dirs '("include" "lib"))
            ""
            ""))))

    (##tty-mode-reset) ;; reset tty (in case subprocess needs to read tty)

    (##run-subprocess
     path
     (##list (##symbol->string op)) ;; single argument is operation
     #f  ;; don't capture output
     #f  ;; don't redirect stdin
     output-dir  ;; run in output directory
     add-vars)))

(define (##extract-target options)
  (let ((t (##assq 'target options)))
    (c#with-exception-handling
     (lambda ()
       (c#target-get
        (if (and (##pair? t)
                 (##pair? (##cdr t)))
            (##cadr t)
            (c#default-target)))))))

(define (link-incremental
         modules
         #!rest other;;;;;;;;;;
         #!key
         (output (macro-absent-obj))
         (linker-name (macro-absent-obj))
         (base (macro-absent-obj))
         (warnings? (macro-absent-obj)))
  (macro-force-vars (modules)
    (let loop ((lst modules) (rev-mods '()))
      (macro-force-vars (lst)
        (if (##pair? lst)
            (let ((m (##car lst)))
              (cond ((##string? m)
                     (loop (##cdr lst)
                           (##cons (##list m) rev-mods)))
                    ((and (##pair? m)
                          (##string? (##car m)))
                     (loop (##cdr lst)
                           (##cons m rev-mods)))
                    (else
                     (error "module list expected")))) ;;;;;;;;;;
            (let* ((out
                    (if (##eq? output (macro-absent-obj))
                        (##path-directory
                         (##path-normalize (##car (##car rev-mods))))
                        (macro-force-vars (output)
                          output)))
                   (link-name
                    (if (##eq? linker-name (macro-absent-obj))
                        #f
                        (macro-force-vars (linker-name)
                          linker-name)))
                   (bas
                    (if (##eq? base (macro-absent-obj))
                        #f
                        (macro-force-vars (base)
                          base)))
                   (warn?
                    (if (##eq? warnings? (macro-absent-obj))
                        #t
                        (macro-force-vars (warnings?)
                          warnings?))))
              (cond ((##not (##string? out))
                     (error "string expected for output: parameter")) ;;;;;;;;;;
                    ((##not (or (##not link-name) (##string? link-name)))
                     (error "string or #f expected for linker-name: parameter"));;;;;;;;;;
                    ((##not (or (##not bas) (##string? bas)))
                     (error "string or #f expected for base: parameter"));;;;;;;;;;
                    (else
                     (##link-incremental rev-mods
                                         out
                                         link-name
                                         bas
                                         warn?)))))))))

(define (##link-incremental rev-mods output linker-name base warnings?)
  (c#link-modules #t
                  (##cons (##list (or base (##default-base-linkfile)))
                          (##reverse rev-mods))
                  output
                  linker-name
                  warnings?))

(define (##default-base-linkfile)
  (let ((gambitdir-lib
         (parameterize
             ((##current-directory
               (##path-expand "~~lib")))
           (##current-directory))))
    (##string-append gambitdir-lib "_gambit")))

(define (##base-library-from-base base)
  base)

(define (link-flat
         modules
         #!rest other;;;;;;;;;;
         #!key
         (output (macro-absent-obj))
         (linker-name (macro-absent-obj))
         (warnings? (macro-absent-obj)))
  (macro-force-vars (modules)
    (let loop ((lst modules) (rev-mods '()))
      (macro-force-vars (lst)
        (if (##pair? lst)
            (let ((m (##car lst)))
              (cond ((##string? m)
                     (loop (##cdr lst)
                           (##cons (##list m) rev-mods)))
                    ((and (##pair? m)
                          (##string? (##car m)))
                     (loop (##cdr lst)
                           (##cons m rev-mods)))
                    (else
                     (error "module list expected")))) ;;;;;;;;;;
            (let* ((out
                    (if (##eq? output (macro-absent-obj))
                        (##path-directory
                         (##path-normalize (##car (##car rev-mods))))
                        (macro-force-vars (output)
                          output)))
                   (link-name
                    (if (##eq? linker-name (macro-absent-obj))
                        #f
                        (macro-force-vars (linker-name)
                          linker-name)))
                   (warn?
                    (if (##eq? warnings? (macro-absent-obj))
                        #t
                        (macro-force-vars (warnings?)
                          warnings?))))
              (cond ((##not (##string? out))
                     (error "string expected for output: parameter")) ;;;;;;;;;;
                    ((##not (or (##not link-name) (##string? link-name)))
                     (error "string or #f expected for linker-name: parameter"));;;;;;;;;;
                    (else
                     (##link-flat rev-mods
                                  out
                                  link-name
                                  warn?)))))))))

(define (##link-flat rev-mods output linker-name warnings?)
  (c#link-modules #f
                  (##reverse rev-mods)
                  output
                  linker-name
                  warnings?))

(define (##c-code . args) ;; avoid errors when using -expansion
  (error "##c-code is not callable dynamically"))

;;;============================================================================
