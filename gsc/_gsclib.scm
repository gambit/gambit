;;;============================================================================

;;; File: "_gsclib.scm", Time-stamp: <2011-03-20 21:15:32 feeley>

;;; Copyright (c) 1994-2009 by Marc Feeley, All Rights Reserved.

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

(define (compile-file-to-c
         filename
         #!rest other;;;;;;;;;;
         #!key
         (options (macro-absent-obj))
         (output (macro-absent-obj))
         (module-name (macro-absent-obj)))
  (macro-force-vars (filename)
    (macro-check-string filename 1 (compile-file-to-c filename . other);;;;;;
      (let* ((opts
              (if (##eq? options (macro-absent-obj))
                  '()
                  (macro-force-vars (options)
                    options)))
             (out
              (if (##eq? output (macro-absent-obj))
                  (##path-directory
                   (##path-normalize filename))
                  (macro-force-vars (output)
                    output)))
             (mod-name
              (if (##eq? module-name (macro-absent-obj))
                  #f
                  (macro-force-vars (module-name)
                    module-name))))
        (cond ((##not (or (##null? opts)
                          (##pair? opts)))
               (error "list expected for options: parameter"));;;;;;;
              ((##not (##string? out))
               (error "string expected for output: parameter"));;;;;;;;;;
              ((##not (or (##not mod-name) (##string? mod-name)))
               (error "string or #f expected for module-name: parameter"));;;;;;;;;;
              (else
               (##compile-file-to-c filename
                                    opts
                                    out
                                    mod-name)))))))

(define (##compile-file-to-c filename options output mod-name)
  (let* ((expanded-output
          (##path-normalize output))
         (c-filename
          (if (##equal? expanded-output
                        (##path-strip-trailing-directory-separator
                         expanded-output))
              expanded-output
              (##string-append
               (##path-expand
                (##path-strip-directory
                 (##path-strip-extension filename))
                expanded-output)
               ".c")))
         (c-filename-no-dir-no-ext
          (##path-strip-directory
           (##path-strip-extension c-filename))))
    (and (c#cf filename
               #f
               options
               c-filename
               (or mod-name
                   c-filename-no-dir-no-ext))
         c-filename)))

(define (compile-file
         filename
         #!rest other;;;;;;;;;;
         #!key
         (options (macro-absent-obj))
         (output (macro-absent-obj))
         (cc-options (macro-absent-obj))
         (ld-options-prelude (macro-absent-obj))
         (ld-options (macro-absent-obj)))
  (macro-force-vars (filename)
    (macro-check-string filename 1 (compile-file filename . other);;;;;;
      (let* ((opts
              (if (##eq? options (macro-absent-obj))
                  '()
                  (macro-force-vars (options)
                    options)))
             (out
              (if (##eq? output (macro-absent-obj))
                  (##path-directory
                   (##path-normalize filename))
                  (macro-force-vars (output)
                    output)))
             (cc-opts
              (if (##eq? cc-options (macro-absent-obj))
                  ""
                  (macro-force-vars (cc-options)
                    cc-options)))
             (ld-opts-prelude
              (if (##eq? ld-options-prelude (macro-absent-obj))
                  ""
                  (macro-force-vars (ld-options-prelude)
                    ld-options-prelude)))
             (ld-opts
              (if (##eq? ld-options (macro-absent-obj))
                  ""
                  (macro-force-vars (ld-options)
                    ld-options))))
        (cond ((##not (or (##null? opts)
                          (##pair? opts)))
               (error "list expected for options: parameter"));;;;;;;
              ((##not (##string? out))
               (error "string expected for output: parameter"));;;;;;;;;;
              ((##not (##string? cc-opts))
               (error "string expected for cc-options: parameter"));;;;;;;;;;
              ((##not (##string? ld-opts-prelude))
               (error "string expected for ld-options-prelude: parameter"));;;;;;;;;;
              ((##not (##string? ld-opts))
               (error "string expected for ld-options: parameter"));;;;;;;;;;
              (else
               (##compile-file filename
                               opts
                               out
                               cc-opts
                               ld-opts-prelude
                               ld-opts)))))))

(define (##compile-file
         filename
         options
         output
         cc-options
         ld-options-prelude
         ld-options)

  (define type
    (cond ((##memq 'obj options)
           'obj)
          ((##memq 'exe options)
           'exe)
          (else
           'dyn)))

  (define (generate-next-version-of-object-file root)
    (let loop ((version 1))
      (let ((root-with-ext
             (##string-append root ".o" (##number->string version 10))))
        (if (##file-exists? root-with-ext)
            (loop (##fixnum.+ version 1))
            root-with-ext))))

  (define (generate-output-filename root input-is-c-file?)
    (case type
      ((obj)
       (##string-append root ##os-obj-extension-string-saved))
      (else
       (if input-is-c-file?
           root
           (generate-next-version-of-object-file root)))))

  (let* ((c-filename
          (##string-append (##path-strip-extension filename) ".c"))
         (input-is-c-file?
          (##string=? filename c-filename))
         (expanded-output
          (##path-normalize output))
         (output-filename
          (if (##equal? expanded-output
                        (##path-strip-trailing-directory-separator
                         expanded-output))
              expanded-output
              (generate-output-filename
               (##path-expand
                (##path-strip-directory
                 (##path-strip-extension filename))
                expanded-output)
               input-is-c-file?)))
         (output-dir
          (##path-directory output-filename))
         (output-filename-no-dir
          (##path-strip-directory output-filename)))
    (and (or input-is-c-file?
             (c#cf filename
                   #f
                   options
                   c-filename
                   (if (##eq? type 'dyn)
                       output-filename-no-dir
                       (##path-strip-extension output-filename-no-dir))))
         (let ((exit-status
                (##gambc-cc
                 type
                 output-dir
                 (##list c-filename)
                 output-filename-no-dir
                 cc-options
                 ld-options-prelude
                 ld-options
                 (##memq 'verbose options))))
           (if (and (##not (##memq 'keep-c options))
                    (##not (##string=? filename c-filename)))
               (##delete-file c-filename))
           (if (##fixnum.= exit-status 0)
               output-filename
               (##raise-error-exception
                "C compilation or link failed while compiling"
                (##list filename)))))))

(define (##build-executable
         obj-files
         options
         output-filename
         cc-options
         ld-options-prelude
         ld-options)
  (let* ((output-dir
          (##path-directory output-filename))
         (output-filename-no-dir
          (##path-strip-directory output-filename))
         (exit-status
          (##gambc-cc
           'exe
           output-dir
           obj-files
           output-filename-no-dir
           cc-options
           ld-options-prelude
           ld-options
           (##memq 'verbose options))))
    (if (##fixnum.= exit-status 0)
        output-filename
        (##raise-error-exception
         "C link failed while linking"
         obj-files))))

(define (##gambc-cc
         op
         output-dir
         input-filenames
         output-filename
         cc-options
         ld-options-prelude
         ld-options
         verbose?)

  (define arg-prefix
    (case op
      ((obj) "BUILD_OBJ_")
      ((dyn) "BUILD_DYN_")
      ((exe) "BUILD_EXE_")
      (else  "BUILD_OTHER_")))

  (define (arg name val)
    (##string-append name "=" val))

  (define (prefixed-arg name val)
    (arg (##string-append arg-prefix name) val))

  (define (install-dir path)
    (parameterize
     ((##current-directory
       (##path-expand path)))
     (##current-directory)))

  (define (relative-to-output-dir filename)
    (##path-normalize (##path-expand filename) #t output-dir))

  (define (separate lst sep)
    (if (##pair? lst)
        (##cons sep (##cons (##car lst) (separate (##cdr lst) sep)))
        '()))

  (let* ((gambcdir-bin
          (install-dir "~~bin"))
         (gambcdir-include
          (install-dir "~~include"))
         (gambcdir-lib
          (install-dir "~~lib"))
         (input-filenames-relative
          (##map relative-to-output-dir input-filenames)))
    (##open-process-generic
     (macro-direction-inout)
     #t
     (lambda (port)
       (let ((status (##process-status port)))
         (##close-port port)
         status))
     open-process
     (##list path:
             (##string-append gambcdir-bin
                              "gambc-cc"
                              ##os-bat-extension-string-saved)
             arguments:
             (##list (##symbol->string op))
             directory:
             output-dir
             environment:
             (##append
              (##list (arg "GAMBCDIR_BIN"
                           (##path-strip-trailing-directory-separator
                            gambcdir-bin))
                      (arg "GAMBCDIR_INCLUDE"
                           (##path-strip-trailing-directory-separator
                            gambcdir-include))
                      (arg "GAMBCDIR_LIB"
                           (##path-strip-trailing-directory-separator
                            gambcdir-lib))
                      (prefixed-arg "INPUT_FILENAMES"
                                    (##append-strings
                                     (##cdr (separate input-filenames-relative
                                                      " "))))
                      (prefixed-arg "OUTPUT_FILENAME"
                                    output-filename)
                      (prefixed-arg "CC_OPTIONS"
                                    cc-options)
                      (prefixed-arg "LD_OPTIONS_PRELUDE"
                                    ld-options-prelude)
                      (prefixed-arg "LD_OPTIONS"
                                    ld-options))
              (##append
               (if verbose?
                   (##list (arg "GAMBC_CC_VERBOSE" "yes"))
                   '())
               (let ((env (##os-environ)))
                 (if (##fixnum? env) '() env))))
             stdin-redirection: #f
             stdout-redirection: #f
             stderr-redirection: #f))))

(define (link-incremental
         modules
         #!rest other;;;;;;;;;;
         #!key
         (output (macro-absent-obj))
         (base (macro-absent-obj))
         (warnings? (macro-absent-obj)))
  (macro-force-vars (modules)
    (if (##not (##pair? modules))
        (macro-check-string-list modules 1 (link-incremental modules . other);;;;;;;;;;;;
          #f)
        (let loop ((lst modules) (rev-mods '()))
          (macro-force-vars (lst)
            (if (##pair? lst)
                (let ((s (##car lst)))
                  (macro-force-vars (s)
                    (macro-check-string-list
                      s
                      1
                      (link-incremental modules . other);;;;;;;;;;;;
                      (loop (##cdr lst) (##cons s rev-mods)))))
                (let* ((out
                        (if (##eq? output (macro-absent-obj))
                            (##path-directory
                             (##path-normalize
                              (##string-append (##car rev-mods) ".c")))
                            (macro-force-vars (output)
                              output)))
                       (baselib
                        (if (##eq? base (macro-absent-obj))
                            (let ((gambcdir-lib
                                   (parameterize
                                    ((##current-directory
                                      (##path-expand "~~lib")))
                                    (##current-directory))))
                              (##string-append gambcdir-lib "_gambc"))
                            (macro-force-vars (base)
                              base)))
                       (warn?
                        (if (##eq? warnings? (macro-absent-obj))
                            #t
                            (macro-force-vars (warnings?)
                              warnings?))))
                  (cond ((##not (##string? out))
                         (error "string expected for output: parameter"));;;;;;;;;;
                        ((##not (##string? baselib))
                         (error "string expected for base: parameter"));;;;;;;;;;
                        (else
                         (##link-incremental rev-mods
                                             out
                                             baselib
                                             warn?))))))))))

(define (##link-incremental rev-mods output base warnings?)
  (let* ((expanded-output
          (##path-normalize output))
         (c-filename
          (if (##equal? expanded-output
                        (##path-strip-trailing-directory-separator
                         expanded-output))
              expanded-output
              (##path-expand
               (##path-strip-directory
                (##string-append (##car rev-mods) "_.c"))
               expanded-output)))
         (base-and-mods
          (##cons base (##reverse rev-mods))))
    (c#targ-linker #t
                   base-and-mods
                   c-filename
                   #f
                   warnings?)))

(define (link-flat
         modules
         #!rest other;;;;;;;;;;
         #!key
         (output (macro-absent-obj))
         (warnings? (macro-absent-obj)))
  (macro-force-vars (modules)
    (if (##not (##pair? modules))
        (macro-check-string-list modules 1 (link-flat modules . other);;;;;;;;;;;;
          #f)
        (let loop ((lst modules) (rev-mods '()))
          (macro-force-vars (lst)
            (if (##pair? lst)
                (let ((s (##car lst)))
                  (macro-force-vars (s)
                    (macro-check-string-list
                      s
                      1
                      (link-flat modules . other);;;;;;;;;;;;
                      (loop (##cdr lst) (##cons s rev-mods)))))
                (let* ((out
                        (if (##eq? output (macro-absent-obj))
                            (##path-directory
                             (##path-normalize
                              (##string-append (##car rev-mods) ".c")))
                            (macro-force-vars (output)
                              output)))
                        (warn?
                         (if (##eq? warnings? (macro-absent-obj))
                             #t
                             (macro-force-vars (warnings?)
                               warnings?))))
                  (cond ((##not (##string? out))
                         (error "string expected for output: parameter"));;;;;;;;;;
                        (else
                         (##link-flat rev-mods
                                      out
                                      warn?))))))))))

(define (##link-flat rev-mods output warnings?)
  (let* ((expanded-output
          (##path-normalize output))
         (c-filename
          (if (##equal? expanded-output
                        (##path-strip-trailing-directory-separator
                         expanded-output))
              expanded-output
              (##path-expand
               (##path-strip-directory
                (##string-append (##car rev-mods) "_.c"))
               expanded-output)))
         (mods
          (##reverse rev-mods)))
    (c#targ-linker #f
                   mods
                   c-filename
                   #f
                   warnings?)))

(define-prim (##c-code . args) ;; avoid errors when using -expansion
  (error "##c-code is not callable dynamically"))

;;;============================================================================
