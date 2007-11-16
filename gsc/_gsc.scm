;;;============================================================================

;;; File: "_gsc.scm", Time-stamp: <2007-11-16 14:05:32 feeley>

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
         (let* ((gambcdir
                 (##path-expand "~~"))
                (gambcdir-bin
                 (parameterize
                  ((##current-directory
                    (##path-expand "bin" gambcdir)))
                  (##current-directory)))
                (exit-status
                 (##shell-command
                  (##string-append
                   gambcdir-bin
                   "gsc-cc-o \""
                   (parameterize
                    ((##current-directory (##path-directory c-filename)))
                    (##current-directory))
                   "\" \""
                   gambcdir
                   "\" \""
                   obj-filename
                   "\" "
                   cc-options
                   " "
                   ld-options-prelude
                   " \""
                   (##path-strip-directory c-filename)
                   "\" "
                   ld-options))))
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

;;;----------------------------------------------------------------------------

(##define-macro (macro-extension-file)
  "gambcext")

(##define-macro (macro-initialization-file)
  "gambcini")

(##define-macro (interpreter-or x)
  x)

(define-prim (##main-gsi/gsc)

  (define (process-initialization-file)

    (define (try filename)
      (##string?
       (##load filename
               (lambda (script-line script-path) #f)
               #f
               #f)))

    (or (try (macro-initialization-file))
        (let ((homedir (##path-expand "~")))
          (try (##string-append homedir (macro-initialization-file))))))

  (define (read-source-from-string str name)
    (let ((port
           (##open-input-string str)))
      (if name
        (macro-port-name-set!
         port
         (lambda (port) name)))
      (let* ((rt
              (macro-character-port-input-readtable port))
             (x
              (##read-all-as-a-begin-expr-from-port
               port
               rt
               ##wrap-datum
               ##unwrap-datum
               (macro-readtable-start-syntax rt)
               #f)))
        (##vector-ref x 1))))

  (define (interpreter-interactive-or-batch-mode arguments)
    (let loop ((lst arguments)
               (batch-mode? #f))
      (if (##pair? lst)
        (let ((file
               (##car lst))
              (rest
               (##cdr lst)))
          (if (option? file)
            (let ((option-name (convert-option file)))
              (cond ((##string=? option-name "")
                     (##repl-debug #f #t)
                     (loop rest
                           #t))
                    ((##string=? option-name "e")
                     (if (##pair? rest)
                       (let ((src (read-source-from-string
                                   (##car rest)
                                   #f)))
                         (##eval-top src ##interaction-cte)
                         (loop (##cdr rest)
                               #t))
                       (begin
                         (warn-missing-argument-for-option "e")
                         (loop rest
                               #t))))
                    (else
                     (warn-unknown-option option-name)
                     (loop rest
                           batch-mode?))))
            (let* ((starter
                    #f)
                   (script-callback
                    (lambda (script-line script-path)
                      (if script-line
                        (let ((language-and-tail
                               (##extract-language-and-tail
                                script-line)))
                          (set! starter
                            (if language-and-tail
                              (let ((language (##car language-and-tail)))
                                (##readtable-setup-for-language!
                                 ##main-readtable
                                 language)
                                (##start-main language))
                              ##exit))
                          (set! ##processed-command-line
                            (##cons script-path rest)))))))

              (##load file
                      script-callback
                      #t
                      #t)

              (if starter
                (starter)
                (loop rest
                      #t)))))
        (if (##not batch-mode?)
          (##repl-debug-main)
          (##exit)))))

  (define (compiler-batch-mode options arguments)

    (define (c-file? file)
      (##string=? (##path-extension file) ".c"))

    (let* ((opts (##map ##car options))
           (sym-opts (##map ##string->symbol opts)))
      (if (let ((c-opt? (##memq 'c sym-opts))
                (link-opt? (##memq 'link sym-opts))
                (dynamic-opt? (##memq 'dynamic sym-opts)))
            (or (and c-opt? link-opt?)
                (and c-opt? dynamic-opt?)
                (and link-opt? dynamic-opt?)))
        (warn-c-link-dynamic-mutually-exclusive)              
        (let loop1 ((lst arguments)
                    (nb-scheme-files 0))
          (if (##pair? lst)

            (let ((file (##car lst))
                  (rest (##cdr lst)))
              (cond ((option? file)
                     (let ((option-name (convert-option file)))
                       (cond ((##string=? option-name "")
                              (loop1 rest
                                     nb-scheme-files))
                             ((##string=? option-name "e")
                              (if (##pair? rest)
                                (loop1 (##cdr rest)
                                       nb-scheme-files)
                                (loop1 rest
                                       nb-scheme-files)))
                             (else
                              (warn-unknown-option option-name)
                              (loop1 rest
                                     nb-scheme-files)))))
                    ((c-file? file)
                     (loop1 rest
                            nb-scheme-files))
                    (else
                     (loop1 rest
                            (##fixnum.+ nb-scheme-files 1)))))

            (let* ((link?
                    (##memq 'link sym-opts))
                   (gen-c?
                    (##memq 'c sym-opts))
                   (gen-dynamic?
                    (##not (or link? gen-c?)))
                   (output
                    (let ((x (##assoc "o" options)))
                      (cond ((##not x)
                             #f)
                            ((and (##not link?)
                                  (##fixnum.< 1 nb-scheme-files)
                                  (let ((outdir (##path-normalize (##cdr x))))
                                    (##equal?
                                     outdir
                                     (##path-strip-trailing-directory-separator
                                      outdir))))
                             (warn-multiple-output-files-and-o-option)
                             #f)
                            (else
                             (##cdr x)))))
                   (pre
                    (##assoc "prelude" options))
                   (post
                    (##assoc "postlude" options))
                   (cc-options
                    (let ((x (##assoc "cc-options" options)))
                      (if x
                        (##cdr x)
                        "")))
                   (ld-options-prelude
                    (let ((x (##assoc "ld-options-prelude" options)))
                      (if x
                        (##cdr x)
                        "")))
                   (ld-options
                    (let ((x (##assoc "ld-options" options)))
                      (if x
                        (##cdr x)
                        ""))))

              (if (or pre post)
                (set! wrap-program
                  (lambda (program)
                    (let ((file
                           (##container->file
                            (##locat-container
                             (##source-locat program)))))
                      (##sourcify
                       (##cons (##sourcify 'begin program)
                               (##append
                                (if pre
                                  (let ((pre-src
                                         (read-source-from-string
                                          (##cdr pre)
                                          (and file
                                               (##string-append
                                                file
                                                ".prelude")))))
                                    (##list pre-src))
                                  '())
                                (##cons program
                                        (if post
                                          (let ((post-src
                                                 (read-source-from-string
                                                  (##cdr post)
                                                  (and file
                                                       (##string-append
                                                        file
                                                        ".postlude")))))
                                            (##list post-src))
                                          '()))))
                       program)))))

              (let loop2 ((lst arguments)
                          (rev-roots '()))
                (if (##pair? lst)

                  (let ((file (##car lst))
                        (rest (##cdr lst)))
                    (if (option? file)
                      (let ((option-name (convert-option file)))
                        (cond ((##string=? option-name "")
                               (##repl-debug #f #t)
                               (loop2 rest
                                      rev-roots))
                              ((##string=? option-name "e")
                               (if (##pair? rest)
                                 (let ((src (read-source-from-string
                                             (##car rest)
                                             #f)))
                                   (##eval-top src ##interaction-cte)
                                   (loop2 (##cdr rest)
                                          rev-roots))
                                 (loop2 rest
                                        rev-roots)))
                              (else
                               (loop2 rest
                                      rev-roots))))
                      (let ((root (##path-strip-extension file)))
                        (if (c-file? file)

                          (loop2 rest
                                 (##cons root rev-roots))

                          (begin
                            (if (##fixnum.< 1 nb-scheme-files)
                              (##repl
                               (lambda (first output-port)
                                 (##write-string file output-port)
                                 (##write-string ":\n" output-port)
                                 #t)))
                            (if (##not
                                 (if gen-dynamic?
                                     (if output
                                         (compile-file
                                          file
                                          options: sym-opts
                                          output: output
                                          cc-options: cc-options
                                          ld-options-prelude: ld-options-prelude
                                          ld-options: ld-options)
                                         (compile-file
                                          file
                                          options: sym-opts
                                          cc-options: cc-options
                                          ld-options-prelude: ld-options-prelude
                                          ld-options: ld-options))
                                   (if (and output (##not link?))
                                       (compile-file-to-c
                                        file
                                        options: sym-opts
                                        output: output)
                                       (compile-file-to-c
                                        file
                                        options: sym-opts))))
                                (##exit-abnormally))
                            (loop2 rest
                                   (##cons (##path-strip-directory root)
                                           rev-roots)))))))

                  (let* ((flat?
                          (##memq 'flat sym-opts))
                         (base
                          (let ((x (##assoc "l" options)))
                            (cond ((##not x)
                                   #f)
                                  ((or (##not link?) flat?)
                                   (warn-no-incremental-link)
                                   #f)
                                  (else
                                   (##cdr x))))))

                    (if link?

                        (if (##not (##null? rev-roots))
                            (let ((roots (##reverse rev-roots)))
                              (if flat?
                                  (if output
                                      (link-flat roots output: output)
                                      (link-flat roots))
                                  (if output
                                      (if base
                                          (link-incremental
                                           roots
                                           output: output
                                           base: base)
                                          (link-incremental
                                           roots
                                           output: output))
                                      (if base
                                          (link-incremental
                                           roots
                                           base: base)
                                          (link-incremental
                                           roots))))))

                        (if flat?
                            (warn-flat-and-not-link)))

                    (##exit))))))))))

  (define (warn-missing-argument-for-option opt)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- Missing argument for option \""
        output-port)
       (##write-string opt output-port)
       (##write-string "\"\n" output-port)
       #t)))

  (define (warn-unknown-option opt)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- Unknown or improperly placed option: "
        output-port)
       (##write opt output-port)
       (##newline output-port)
       #t)))

  (define (warn-multiple-output-files-and-o-option)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- Multiple output files: non-directory \"o\" option ignored\n"
        output-port)
       #t)))

  (define (warn-no-incremental-link)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- No incremental link: \"l\" option ignored\n"
        output-port)
       #t)))

  (define (warn-flat-and-not-link)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- \"link\" option was not specified: \"flat\" option ignored\n"
        output-port)
       #t)))

  (define (warn-c-link-dynamic-mutually-exclusive)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- The options \"c\", \"link\" and \"dynamic\" are mutually exclusive\n"
        output-port)
       #t)))

  (define (option? arg)
    (and (##fixnum.< 0 (##string-length arg))
         (##char=? (##string-ref arg 0) #\-)))

  (define (convert-option arg)
    (##substring arg 1 (##string-length arg)))

  (define (split-command-line
           arguments
           options-with-no-args
           options-with-args
           cont)
    (let loop1 ((args arguments)
                (rev-options '()))
      (if (and (##pair? args)
               (option? (##car args)))

        (let ((opt (convert-option (##car args)))
              (rest (##cdr args)))
          (cond ((##member opt options-with-no-args)
                 (loop1 rest
                        (##cons (##cons opt #f) rev-options)))
                ((##member opt options-with-args)
                 (if (##pair? rest)
                   (loop1 (##cdr rest)
                          (##cons (##cons opt (##car rest)) rev-options))
                   (begin
                     (warn-missing-argument-for-option opt)
                     (loop1 rest rev-options))))
                (else
                 (cont (##reverse rev-options) args))))

        (cont (##reverse rev-options) args))))

  (let ((gambcdir (##path-expand "~~")))
    (##load (##string-append gambcdir (macro-extension-file))
            (lambda (script-line script-path) #f)
            #f
            #f))

  (let ((language-and-tail
         (##extract-language-and-tail (##car ##processed-command-line))))

    (if language-and-tail
      (let ((language (##car language-and-tail)))
        (##readtable-setup-for-language! ##main-readtable language)))

    (split-command-line
      (##cdr ##processed-command-line)
      '("f" "i" "v")
      '()
      (lambda (main-options arguments)
        (let ((skip-initialization-file?
               (##assoc "f" main-options))
              (force-interpreter?
               (or language-and-tail
                   (##assoc "i" main-options)))
              (version?
               (##assoc "v" main-options)))
          (if version?
            (begin
              (##write-string (##system-version-string) ##stdout-port)
              (##newline ##stdout-port)
              (##exit))
            (split-command-line
              arguments
              (if (interpreter-or force-interpreter?)
                '()
                '("c" "dynamic" "link" "flat"
                  "warnings" "verbose" "report" "expansion" "gvm"
                  "check" "force" "debug" "track-scheme" "keep-c"))
              (if (interpreter-or force-interpreter?)
                '()
                '("o" "l" "prelude" "postlude"
                  "cc-options" "ld-options-prelude" "ld-options"))
              (lambda (known-options arguments)

                (if (##not skip-initialization-file?)
                  (process-initialization-file))

                (if (or (##null? arguments)
                        (interpreter-or force-interpreter?))
                 (interpreter-interactive-or-batch-mode arguments)
                 (compiler-batch-mode known-options arguments))))))))))

(##main-set! ##main-gsi/gsc)

(define-prim (main . args) ;; predefine main procedure so scripts don't have to
  0)

(##namespace (""))

;;;============================================================================
