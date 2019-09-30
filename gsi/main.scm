;;;============================================================================

;;; File: "main.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;----------------------------------------------------------------------------

(##define-macro (macro-initialization-file)
  ".gambini")

(define (##main-gsi/gsc)

  (define (in-homedir filename)
    (let ((homedir (##path-expand "~")))
      (##string-append homedir filename)))

  (define (process-initialization-file)

    (define (try filename)
      (##string?
       (##load filename
               (lambda (script-line script-path) #f)
               #f
               #f
               #f
               #f)))

    (or (try (macro-initialization-file))
        (try (in-homedir (macro-initialization-file)))))

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
               (batch-mode? #f)
               (load-options '()))
      (if (##pair? lst)
        (let ((file
               (##car lst))
              (rest
               (##cdr lst)))
          (if (option? file)
            (let ((option-name (convert-option file)))
              (cond ((##eq? option-name '||)
                     (##repl-debug #f #t)
                     (loop rest
                           #t
                           load-options))
                    ((##eq? option-name 'e)
                     (if (##pair? rest)
                       (let ((src (read-source-from-string
                                   (##car rest)
                                   #f)))
                         (##eval-top src ##interaction-cte)
                         (loop (##cdr rest)
                               #t
                               load-options))
                       (begin
                         (warn-missing-argument-for-option option-name)
                         (loop rest
                               #t
                               load-options))))
                    ((##assq option-name ##gsi-option-handlers)
                     =>
                     (lambda (x)
                       ((##cdr x) rest)
                       (##exit)))
                    ((##eq? option-name 'test)
                     (loop rest
                           batch-mode?
                           (##cons 'test (##remq 'test load-options))))
                    ((##eq? option-name 'notest)
                     (loop rest
                           batch-mode?
                           (##remq 'test load-options)))
                    (else
                     (warn-unknown-option option-name)
                     (loop rest
                           batch-mode?
                           load-options))))
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
                                 (##current-readtable)
                                 language)
                                (##start-main language))
                              ##exit))
                          (set! ##processed-command-line
                            (##cons script-path rest)))))))

              (##load-module-or-file file load-options script-callback)

              (if starter
                (starter)
                (loop rest
                      #t
                      load-options)))))
        (if (##not batch-mode?)
          (##repl-debug-main)
          (##exit)))))

  (define (compiler-batch-mode options arguments target)

    (define (target-file? file)
      (##assoc (##path-extension file)
               (c#target-file-extensions target)))

    (define (obj-file? file)
      (##string=? (##path-extension file) ##os-obj-extension-string-saved))

    (define (combine-option! opt)
      (let loop1 ((lst options))
        (if (##pair? lst)
            (let ((x (##car lst)))
              (if (##not (##eq? (##car x) opt))
                  (loop1 (##cdr lst))
                  (let loop2 ((lst (##cdr lst))
                              (prev lst)
                              (tail (##last-pair x)))
                    (if (##pair? lst)
                        (let ((x (##car lst)))
                          (if (##not (##eq? (##car x) opt))
                              (loop2 (##cdr lst)
                                     lst
                                     tail)
                              (let ((next-lst (##cdr lst)))
                                (##set-cdr! tail (##cdr x))
                                (##set-cdr! prev next-lst)
                                (loop2 next-lst
                                       prev
                                       (##last-pair tail))))))))))))

    (combine-option! 'cc-options)
    (combine-option! 'ld-options-prelude)
    (combine-option! 'ld-options)
    (combine-option! 'pkg-config)

    (let* ((c-opt?       (##assq 'c options))
           (link-opt?    (##assq 'link options))
           (exe-opt?     (##assq 'exe options))
           (obj-opt?     (##assq 'obj options))
           (dynamic-opt? (##assq 'dynamic options))
           (warnings-opt? (##assq 'warnings options)))
      (if (##fx< 1 (##fx+
                         (if c-opt? 1 0)
                         (if link-opt? 1 0)
                         (if exe-opt? 1 0)
                         (if obj-opt? 1 0)
                         (if dynamic-opt? 1 0)))
          (warn-mutually-exclusive-options)
          (let ((type
                 (cond (c-opt?    'c)
                       (link-opt? 'link)
                       (exe-opt?  'exe)
                       (obj-opt?  'obj)
                       (else      'dyn))))
            (let loop1 ((lst arguments)
                        (nb-output-files 0))
              (if (##pair? lst)

                  (let ((file (##car lst))
                        (rest (##cdr lst)))
                    (cond ((option? file)
                           (let ((option-name (convert-option file)))
                             (cond ((##eq? option-name 'e)
                                    (loop1 (if (##pair? rest)
                                               (##cdr rest)
                                               rest)
                                           nb-output-files))
                                   ((##eq? option-name '||)
                                    (loop1 rest
                                           nb-output-files))
                                   ((or (##eq? option-name 'preload)
                                        (##eq? option-name 'nopreload))
                                    (if (##not (##memq type '(link exe)))
                                        (warn-invalid-preload-options))
                                    (loop1 rest
                                           nb-output-files))
                                   (else
                                    (warn-unknown-option option-name)
                                    (loop1 rest
                                           nb-output-files)))))
                          ((obj-file? file)
                           (loop1 rest
                                  nb-output-files))
                          ((target-file? file)
                           (loop1 rest
                                  (if (and (##eq? type 'obj)
                                           (c#get-link-info file #f))
                                      (##fx+ nb-output-files 1)
                                      nb-output-files)))
                          (else
                           (loop1 rest
                                  (##fx+ nb-output-files 1)))))

                  (let* ((output
                          (let ((x (##assq 'o options)))
                            (cond ((##not x)
                                   #f)
                                  ((and (##not (##memq type '(link exe)))
                                        (##fx< 1 nb-output-files)
                                        (let ((outdir (##path-normalize (##cadr x))))
                                          (##equal?
                                           outdir
                                           (##path-strip-trailing-directory-separator
                                            outdir))))
                                   (warn-multiple-output-files-and-o-option)
                                   #f)
                                  (else
                                   (##cadr x)))))
                         (pre
                          (##assq 'prelude options))
                         (post
                          (##assq 'postlude options))
                         (linker-name
                          (let ((x (##assq 'linker-name options)))
                            (if x
                                (##cadr x)
                                #f)))
                         (cc-options
                          (let ((x (##assq 'cc-options options)))
                            (if x
                                (##cdr x)
                                '())))
                         (ld-options-prelude
                          (let ((x (##assq 'ld-options-prelude options)))
                            (if x
                                (##cdr x)
                                '())))
                         (ld-options
                          (let ((x (##assq 'ld-options options)))
                            (if x
                                (##cdr x)
                                '())))
                         (pkg-config
                          (let ((x (##assq 'pkg-config options)))
                            (if x
                                (##cdr x)
                                '()))))

                    (if (or pre post)
                        (set! c#wrap-program
                              (lambda (program)
                                (let ((path
                                       (##container->path
                                        (##locat-container
                                         (##source-locat program)))))
                                  (##sourcify
                                   (##cons (##sourcify 'begin program)
                                           (##append
                                            (if pre
                                                (let ((pre-src
                                                       (read-source-from-string
                                                        (##cadr pre)
                                                        (and path
                                                             (##string-append
                                                              path
                                                              ".prelude")))))
                                                  (##list pre-src))
                                                '())
                                            (##cons program
                                                    (if post
                                                        (let ((post-src
                                                               (read-source-from-string
                                                                (##cadr post)
                                                                (and path
                                                                     (##string-append
                                                                      path
                                                                      ".postlude")))))
                                                          (##list post-src))
                                                        '()))))
                                   program)))))

                    (let ((rev-gen-files '())
                          (rev-obj-files '())
                          (rev-tmp-files '())
                          (flags '())
                          (meta-info-file #f))

                      (define (add-gen-file file)
                        (set! rev-gen-files
                              (##cons (##cons file flags)
                                      rev-gen-files)))

                      (define (add-obj-file obj-file)
                        (set! rev-obj-files
                              (##cons obj-file
                                      rev-obj-files)))

                      (define (add-obj-file-at-head obj-file)
                        (set! rev-obj-files
                              (##append rev-obj-files (##list obj-file))))

                      (define (add-tmp-file tmp-file)
                        (set! rev-tmp-files
                              (##cons tmp-file
                                      rev-tmp-files)))

                      (define (cleanup)
                        (##for-each
                         ##delete-file
                         (##reverse rev-tmp-files)))

                      (define (exit-abnormally)
                        (cleanup)
                        (##exit-abruptly))

                      (define (handling file)
                        (if (##fx< 1 nb-output-files)
                            (##repl
                             (lambda (first output-port)
                               (##write-string file output-port)
                               (##write-string ":\n" output-port)
                               #t))))

                      (define (handling-module module)
                        (if (##fx< 1 nb-output-files)
                            (##repl
                             (lambda (first output-port)
                               (##write-string "Building module: " output-port)
                               (##write-string module output-port)
                               (##write-string "\n" output-port)
                               #t))))

                      (define (do-compile-file file opts output)
                        (handling file)
                        (or (if output
                                (compile-file
                                 file
                                 options: opts
                                 output: output
                                 cc-options: cc-options
                                 ld-options-prelude: ld-options-prelude
                                 ld-options: ld-options
                                 pkg-config: pkg-config)
                                (compile-file
                                 file
                                 options: opts
                                 cc-options: cc-options
                                 ld-options-prelude: ld-options-prelude
                                 ld-options: ld-options
                                 pkg-config: pkg-config))
                            (exit-abnormally)))

                      (define (do-compile-file-to-target file opts output)
                        (handling file)
                        (or (if output
                                (compile-file-to-target
                                 file
                                 options: opts
                                 output: output)
                                (compile-file-to-target
                                 file
                                 options: opts))
                            (exit-abnormally)))

                      (define (do-build-executable obj-files output-filename)
                        (or (##build-executable
                             obj-files
                             options
                             output-filename
                             cc-options
                             ld-options-prelude
                             ld-options
                             pkg-config
                             meta-info-file)
                            (exit-abnormally)))

                      (define (do-build-module module-ref modref opts)
                        (let ((mod-info (##search-or-else-install-module modref)))
                          (if mod-info

                              (let ((mod-dir            (##vector-ref mod-info 0))
                                    (mod-filename-noext (##vector-ref mod-info 1))
                                    (ext                (##vector-ref mod-info 2))
                                    (mod-path           (##vector-ref mod-info 3))
                                    (port               (##vector-ref mod-info 4)))

                                ;; close unused port.
                                (##close-input-port port)

                                (handling-module module-ref)

                                (##build-module
                                 mod-path
                                 (c#target-name target)
                                 (##cons
                                  (##list 'module-ref (##string->symbol module-ref))
                                  opts)))

                            (##error (##string-append "Module not found '" module-ref "'")))))


                      (define (do-build-file-or-module file opts output)
                        (let* ((modref (##parse-module-ref file))
                               (module? (and modref
                                             (##fx= 0 (##string-length
                                                       (##path-extension
                                                        (##car (##vector-ref modref 3))))))))
                          (if module?
                            (do-build-module file modref opts)
                            (do-compile-file file opts output))))

                      (let loop2 ((lst arguments))
                        (if (##pair? lst)

                            (let ((file (##car lst))
                                  (rest (##cdr lst)))
                              (if (option? file)
                                  (let ((option-name (convert-option file)))
                                    (cond ((##eq? option-name 'e)
                                           (if (##pair? rest)
                                               (let ((src (read-source-from-string
                                                           (##car rest)
                                                           #f)))
                                                 (##eval-top src ##interaction-cte)
                                                 (loop2 (##cdr rest)))
                                               (loop2 rest)))
                                          ((##eq? option-name '||)
                                           (##repl-debug #f #t)
                                           (loop2 rest))
                                          ((##eq? option-name 'preload)
                                           (set! flags '((preload . #t)))
                                           (loop2 rest))
                                          ((##eq? option-name 'nopreload)
                                           (set! flags '((preload . #f)))
                                           (loop2 rest))
                                          (else
                                           (loop2 rest))))
                                  (let ((root (##path-strip-extension file)))
                                    (cond ((target-file? file)
                                           (if (##memq type '(exe obj))
                                               (let ((obj-file
                                                      (do-compile-file
                                                       file
                                                       (##cons '(obj) options)
                                                       (and (##eq? type 'obj)
                                                            output))))
                                                 (add-obj-file obj-file)
                                                 (if (##eq? type 'exe)
                                                     (add-tmp-file obj-file))))
                                           (if (and (##memq type '(link exe))
                                                    (c#get-link-info file #f))
                                               (add-gen-file file))
                                           (loop2 rest))
                                          ((c#get-link-info file #f)
                                           (if (##memq type '(link exe))
                                               (add-gen-file file))
                                           (loop2 rest))
                                          ((obj-file? file)
                                           (add-obj-file file)
                                           (loop2 rest))
                                          (else
                                           (case type
                                             ((dyn)
                                              (do-build-file-or-module
                                               file
                                               options
                                               output))
                                             ((obj)
                                              (let ((obj-file
                                                     (do-compile-file
                                                      file
                                                      (##cons '(obj) options)
                                                      output)))
                                                (add-obj-file obj-file)))
                                             ((link exe c)
                                              (let ((gen-file
                                                     (do-compile-file-to-target
                                                      file
                                                      options
                                                      (and (##eq? type 'c)
                                                           output))))
                                                (add-gen-file gen-file)
                                                (if (and (target-file? gen-file)
                                                         (##eq? type 'exe))
                                                    (let ((obj-file
                                                           (do-compile-file
                                                            gen-file
                                                            (##cons '(obj) options)
                                                            #f)))
                                                      (add-obj-file obj-file)
                                                      (add-tmp-file obj-file)
                                                      (if (##not (##assq 'keep-c options))
                                                          (add-tmp-file gen-file)))))))
                                           (loop2 rest))))))

                            (let* ((flat?
                                    (##assq 'flat options))
                                   (link?
                                    (##eq? type 'link))
                                   (exe?
                                    (##eq? type 'exe))
                                   (base
                                    (let ((x (##assq 'l options)))
                                      (cond ((##not x)
                                             #f)
                                            ((or flat?
                                                 (##not (or link? exe?)))
                                             (warn-no-incremental-link)
                                             #f)
                                            (else
                                             (##cadr x))))))

                              (if (or link? exe?)

                                  (let ((gen-files
                                         (##reverse rev-gen-files)))

                                    (if (##pair? gen-files)
                                        (let* ((link-file
                                                (if flat?
                                                    (if (and output
                                                             link?)
                                                        (link-flat gen-files
                                                                   output: output
                                                                   linker-name: linker-name
                                                                   warnings?: warnings-opt?)
                                                        (link-flat gen-files
                                                                   linker-name: linker-name
                                                                   warnings?: warnings-opt?))
                                                    (if (and output
                                                             link?)
                                                        (if base
                                                            (link-incremental
                                                             gen-files
                                                             output: output
                                                             linker-name: linker-name
                                                             base: base
                                                             warnings?: warnings-opt?)
                                                            (link-incremental
                                                             gen-files
                                                             output: output
                                                             linker-name: linker-name
                                                             warnings?: warnings-opt?))
                                                        (if base
                                                            (link-incremental
                                                             gen-files
                                                             linker-name: linker-name
                                                             base: base
                                                             warnings?: warnings-opt?)
                                                            (link-incremental
                                                             gen-files
                                                             linker-name: linker-name
                                                             warnings?: warnings-opt?))))))
                                          (and link-file
                                               (begin
                                                 (set! meta-info-file link-file)
                                                 (add-gen-file link-file)
                                                 (if exe?
                                                     (let ((obj-link-file
                                                            (do-compile-file
                                                             link-file
                                                             (##cons '(obj) options)
                                                             #f)))
                                                       (add-obj-file-at-head obj-link-file)
                                                       (add-tmp-file obj-link-file)
                                                       (if (##not (##assq 'keep-c options))
                                                           (add-tmp-file link-file))))))))


                                    (if exe?
                                        (and (##pair? rev-obj-files)
                                             (let ((obj-files
                                                    (##reverse rev-obj-files)))

                                               (do-build-executable
                                                obj-files
                                                (let ((expanded-output
                                                       (and output
                                                            (##path-normalize output))))
                                                  (if (and expanded-output
                                                           (##equal? expanded-output
                                                                     (##path-strip-trailing-directory-separator
                                                                      expanded-output)))
                                                      expanded-output
                                                      (##string-append
                                                       (##path-strip-extension
                                                        (if (##pair? gen-files)
                                                            (##car
                                                             (##car
                                                              (##reverse gen-files)))
                                                            (##car
                                                             rev-obj-files)))
                                                       (if (##eq?
                                                            (c#target-name
                                                             target)
                                                            'C)
                                                           ##os-exe-extension-string-saved
                                                           ##os-bat-extension-string-saved)))))))))

                                  (if flat?
                                      (warn-flat-and-not-link-or-exe)))

                              (cleanup)
                              (##exit))))))))))))

  (define (warn-missing-argument-for-option opt-sym)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- Missing argument for -"
        output-port)
       (##write-string (##symbol->string opt-sym) output-port)
       (##write-string " option\n" output-port)
       #t)))

  (define (warn-fixnum-argument-expected-for-option opt-sym)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- Fixnum argument expected for -"
        output-port)
       (##write-string (##symbol->string opt-sym) output-port)
       (##write-string " option\n" output-port)
       #t)))

  (define (warn-unknown-option opt-sym)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- Unknown or improperly placed -"
        output-port)
       (##write-string (##symbol->string opt-sym) output-port)
       (##write-string " option\n" output-port)
       #t)))

  (define (warn-multiple-output-files-and-o-option)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- Multiple output files: non-directory -o option ignored\n"
        output-port)
       #t)))

  (define (warn-no-incremental-link)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- No incremental link: -l option ignored\n"
        output-port)
       #t)))

  (define (warn-flat-and-not-link-or-exe)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- -link or -exe options were not specified: -flat option ignored\n"
        output-port)
       #t)))

  (define (warn-mutually-exclusive-options)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- The -c, -link, -dynamic, -exe and -obj options are mutually exclusive\n"
        output-port)
       #t)))

  (define (warn-invalid-preload-options)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- The -preload and -nopreload options must be used with the -link and -exe options\n"
        output-port)
       #t)))

  (define (option? arg)
    (and (##fx< 0 (##string-length arg))
         (##char=? (##string-ref arg 0) #\-)))

  (define (convert-option arg)
    (##string->symbol (##substring arg 1 (##string-length arg))))

  (define (split-command-line
           arguments
           allowed-options
           warn?
           cont)
    (let loop1 ((args arguments)
                (rev-options '()))

      (define (add-option key-val)
        (##cons key-val rev-options))

      (if (and (##pair? args)
               (option? (##car args)))

          (let* ((opt-sym (convert-option (##car args)))
                 (rest (##cdr args))
                 (x (##assq opt-sym allowed-options)))
            (if x
                (cond ((##not (##cdr x))
                       (cont (##reverse (add-option (##list opt-sym)))
                             (##cdr args)))
                      ((##not (##pair? (##cdr x)))
                       (loop1 rest
                              (add-option (##cons opt-sym '()))))
                      ((##not (##pair? rest))
                       (if warn?
                           (warn-missing-argument-for-option opt-sym))
                       (loop1 rest
                              rev-options))
                      (else
                       (let ((opt-val (##car rest)))
                         (case (##cadr x)
                           ((symbol)
                            (let ((val (##string->symbol opt-val)))
                              (loop1 (##cdr rest)
                                     (add-option (##list opt-sym val)))))
                           ((fixnum)
                            (let ((val (##string->number opt-val)))
                              (if (##fixnum? val)
                                  (loop1 (##cdr rest)
                                         (add-option (##list opt-sym val)))
                                  (begin
                                    (if warn?
                                        (warn-fixnum-argument-expected-for-option opt-sym))
                                    (loop1 (##cdr rest)
                                           rev-options)))))
                           (else
                            (loop1 (##cdr rest)
                                   (add-option (##list opt-sym opt-val))))))))
                (cont (##reverse rev-options)
                      args)))

          (cont (##reverse rev-options)
                args))))

  (##load-support-libraries)

  (let ((language-and-tail
         (##extract-language-and-tail (##car ##processed-command-line))))

    (if language-and-tail
      (let ((language (##car language-and-tail)))
        (##readtable-setup-for-language! (##current-readtable) language)))

    (split-command-line
      (##cdr ##processed-command-line)
      '((f) (i) (v))
      #t
      (lambda (main-options arguments)
        (let ((skip-initialization-file?
               (##assq 'f main-options))
              (force-interpreter?
               (or language-and-tail
                   (##assq 'i main-options)))
              (version?
               (##assq 'v main-options)))

          (define (run-interpreter-or-compiler known-options arguments target)

            (if (##not skip-initialization-file?)
                (process-initialization-file))

            (if (or (##null? arguments)
                    (interpreter-or force-interpreter?))
                (interpreter-interactive-or-batch-mode arguments)
                (compiler-batch-mode known-options arguments target)))

          (cond (version?
                 (##write-string (##system-version-string) ##stdout-port)
                 (##write-string " " ##stdout-port)
                 (##write (##system-stamp) ##stdout-port)
                 (##write-string " " ##stdout-port)
                 (##write-string ##os-system-type-string-saved ##stdout-port)
                 (##write-string " " ##stdout-port)
                 (##write ##os-configure-command-string-saved ##stdout-port)
                 (##newline ##stdout-port)
                 (##exit))

                ((interpreter-or force-interpreter?)
                 (split-command-line
                  arguments
                  '()
                  #t
                  (lambda (known-options arguments)
                    (run-interpreter-or-compiler
                     known-options
                     arguments
                     #f))))

                (else
                 (let* ((common-compiler-options
                         '((target symbol)
                           (c) (dynamic) (exe) (obj) (link) (flat)
                           (warnings) (verbose) (report)
                           (expansion) (gvm) (cfg) (dg) (asm) (keep-c)
;;TODO: enable and document when compiler supports these options
;;                           (type-checking) (no-type-checking)
;;                           (auto-forcing) (no-auto-forcing)
                           (debug) (debug-location) (debug-source) (debug-environments)
                           (track-scheme)
                           (o string) (l string)
                           (module-ref symbol) (linker-name string)
                           (prelude string) (postlude string)
                           (cc-options string)
                           (ld-options-prelude string)
                           (ld-options string)
                           (pkg-config string))))

                   ;; parse command line to try to find the -target option
                   (split-command-line
                    arguments
                    (##append common-compiler-options
                              (##append-lists ;; allow all target options
                               (##map c#target-options
                                      (c#targets-loaded))))
                    #f
                    (lambda (known-options dummy-arguments)
                      (let* ((t
                              (##assq 'target known-options))
                             (target
                              (c#with-exception-handling
                               (lambda ()
                                 (c#target-get
                                  (if t
                                      (##cadr t)
                                      (c#default-target)))))))
                        (if (##not target)

                            (##exit)

                            ;; parse command line again, but with the target
                            ;; specific options
                            (split-command-line
                             arguments
                             (##append common-compiler-options
                                       (c#target-options target))
                             #t
                             (lambda (known-options arguments)
                               (run-interpreter-or-compiler
                                known-options
                                arguments
                                target)))))))))))))))

;;(define ##gsi-option-handlers '()) ;; OK to be undefined

(define (##gsi-option-handlers-set! x)
  (set! ##gsi-option-handlers x))

(##main-set! ##main-gsi/gsc)

(##namespace (""))

;;;============================================================================
