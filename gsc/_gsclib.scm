;;;============================================================================

;;; File: "_gsclib.scm", Time-stamp: <2008-02-28 17:17:26 feeley>

;;; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

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
         (output (macro-absent-obj)))
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
                    output))))
        (cond ((##not (or (##null? opts)
                          (##pair? opts)))
               (error "list expected for options: parameter"));;;;;;;
              ((##not (##string? out))
               (error "string expected for output: parameter"));;;;;;;;;;
              (else
               (##compile-file-to-c filename
                                    opts
                                    out)))))))

(define (##compile-file-to-c filename options output)
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
    (c#cf filename #f options c-filename c-filename-no-dir-no-ext)))

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

  (define (generate-next-version-of-object-file root)
    (let loop ((version 1))
      (let ((root-with-ext
             (##string-append root ".o" (##number->string version 10))))
        (if (##file-exists? root-with-ext)
            (loop (##fixnum.+ version 1))
            root-with-ext))))

  (define (gsc-cc-o c-filename obj-filename)

    (define (arg name val)
      (##string-append "GSC_CC_O_" name "=" val))

    (let* ((gambcdir
            (##path-expand "~~"))
           (gambcdir-bin
            (parameterize
             ((##current-directory
               (##path-expand "bin" gambcdir)))
             (##current-directory)))
           (c-filename-dir
            (parameterize
             ((##current-directory (##path-directory c-filename)))
             (##current-directory)))
           (c-filename-base
            (##path-strip-directory c-filename)))
      (##open-process
       #t
       (lambda (port)
         (##process-status port))
       open-process
       (##list path:
               (##string-append gambcdir-bin "gsc-cc-o.bat")
               arguments:
               '()
               environment:
               (##append
                (let ((env (##os-environ)))
                  (if (##fixnum? env) '() env))
                (##list (arg "GAMBCDIR" gambcdir)
                        (arg "OBJ_FILENAME" obj-filename)
                        (arg "C_FILENAME_DIR" c-filename-dir)
                        (arg "C_FILENAME_BASE" c-filename-base)
                        (arg "CC_OPTIONS" cc-options)
                        (arg "LD_OPTIONS_PRELUDE" ld-options-prelude)
                        (arg "LD_OPTIONS" ld-options)))
               stdin-redirection: #f
               stdout-redirection: #f
               stderr-redirection: #f))))

  (let* ((expanded-output
          (##path-normalize output))
         (obj-filename
          (if (##equal? expanded-output
                        (##path-strip-trailing-directory-separator
                         expanded-output))
              expanded-output
              (generate-next-version-of-object-file
               (##path-expand
                (##path-strip-directory
                 (##path-strip-extension filename))
                expanded-output))))
         (c-filename
          (##string-append (##path-strip-extension filename) ".c"))
         (obj-filename-no-dir
          (##path-strip-directory obj-filename)))
    (and (c#cf filename #f options c-filename obj-filename-no-dir)
         (let ((exit-status (gsc-cc-o c-filename obj-filename)))
           (if (##not (##memq 'keep-c options))
               (##delete-file c-filename))
           (if (##fixnum.= exit-status 0)
               #t
               '(##runtime-error;;;;;;;;;;;;;;;;;;
                 msg
                 'compile-file
                 (##list filename)))))))

(define (link-incremental
         modules
         #!rest other;;;;;;;;;;
         #!key
         (output (macro-absent-obj))
         (base (macro-absent-obj)))
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
                                      (##path-expand "lib" (##path-expand "~~"))))
                                    (##current-directory))))
                              (##string-append gambcdir-lib "_gambc"))
                            (macro-force-vars (base)
                              base))))
                  (cond ((##not (##string? out))
                         (error "string expected for output: parameter"));;;;;;;;;;
                        ((##not (##string? baselib))
                         (error "string expected for base: parameter"));;;;;;;;;;
                        (else
                         (##link-incremental rev-mods out baselib))))))))))

(define (##link-incremental rev-mods output base)
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
                   #f)))

(define (link-flat
         modules
         #!rest other;;;;;;;;;;
         #!key
         (output (macro-absent-obj)))
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
                (let ((out
                       (if (##eq? output (macro-absent-obj))
                           (##path-directory
                            (##path-normalize
                             (##string-append (##car rev-mods) ".c")))
                           (macro-force-vars (output)
                             output))))
                  (cond ((##not (##string? out))
                         (error "string expected for output: parameter"));;;;;;;;;;
                        (else
                         (##link-flat rev-mods out))))))))))

(define (##link-flat rev-mods output)
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
                   #f)))

(define-prim (##c-code . args) ;; avoid errors when using -expansion
  (error "##c-code is not callable dynamically"))

;;;============================================================================
