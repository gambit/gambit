;;;============================================================================

;;; File: "main.scm"

;;; Copyright (c) 1994-2012 by Marc Feeley, All Rights Reserved.

;;;----------------------------------------------------------------------------

(##define-macro (macro-initialization-file)
  ".gambcini")

(define-prim (##main-gsi/gsc)

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
                                 (##current-readtable)
                                 language)
                                (##start-main language))
                              ##exit))
                          (set! ##processed-command-line
                            (##cons script-path rest)))))))

              (##load file
                      script-callback
                      #t
                      #t
                      #f)

              (if starter
                (starter)
                (loop rest
                      #t)))))
        (if (##not batch-mode?)
          (##repl-debug-main)
          (##exit)))))

  (define (compiler-batch-mode options arguments)

    (define (c-file? file)
      (##assoc (##path-extension file) c#targ-c-file-extensions))

    (define (obj-file? file)
      (##string=? (##path-extension file) ##os-obj-extension-string-saved))

    (let* ((c-opt?       (##assq 'c options))
           (link-opt?    (##assq 'link options))
           (exe-opt?     (##assq 'exe options))
           (obj-opt?     (##assq 'obj options))
           (dynamic-opt? (##assq 'dynamic options)))
      (if (##fixnum.< 1 (##fixnum.+
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
                       (else      'dyn)))) ;; dynamic is default
            (let loop1 ((lst arguments)
                        (nb-output-files 0))
              (if (##pair? lst)

                  (let ((file (##car lst))
                        (rest (##cdr lst)))
                    (cond ((option? file)
                           (let ((option-name (convert-option file)))
                             (cond ((##string=? option-name "")
                                    (loop1 rest
                                           nb-output-files))
                                   ((##string=? option-name "e")
                                    (loop1 (if (##pair? rest)
                                               (##cdr rest)
                                               rest)
                                           nb-output-files))
                                   (else
                                    (warn-unknown-option option-name)
                                    (loop1 rest
                                           nb-output-files)))))
                          ((c-file? file)
                           (loop1 rest
                                  (if (and (##eq? type 'obj)
                                           (c#targ-generated-c-file? file))
                                      (##fixnum.+ nb-output-files 1)
                                      nb-output-files)))
                          ((obj-file? file)
                           (loop1 rest
                                  nb-output-files))
                          (else
                           (loop1 rest
                                  (##fixnum.+ nb-output-files 1)))))

                  (let* ((output
                          (let ((x (##assq 'o options)))
                            (cond ((##not x)
                                   #f)
                                  ((and (##not (##memq type '(link exe)))
                                        (##fixnum.< 1 nb-output-files)
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
                         (cc-options
                          (let ((x (##assq 'cc-options options)))
                            (if x
                                (##cadr x)
                                "")))
                         (ld-options-prelude
                          (let ((x (##assq 'ld-options-prelude options)))
                            (if x
                                (##cadr x)
                                "")))
                         (ld-options
                          (let ((x (##assq 'ld-options options)))
                            (if x
                                (##cadr x)
                                ""))))

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

                    (let ((rev-gen-c-files '())
                          (rev-obj-files '())
                          (rev-tmp-files '()))

                      (define (add-gen-c-file gen-c-file)
                        (set! rev-gen-c-files
                              (##cons gen-c-file
                                      rev-gen-c-files)))

                      (define (add-obj-file obj-file)
                        (set! rev-obj-files
                              (##cons obj-file
                                      rev-obj-files)))

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
                        (##exit-abnormally))

                      (define (handling file)
                        (if (##fixnum.< 1 nb-output-files)
                            (##repl
                             (lambda (first output-port)
                               (##write-string file output-port)
                               (##write-string ":\n" output-port)
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
                                 ld-options: ld-options)
                                (compile-file
                                 file
                                 options: opts
                                 cc-options: cc-options
                                 ld-options-prelude: ld-options-prelude
                                 ld-options: ld-options))
                            (exit-abnormally)))

                      (define (do-compile-file-to-c file opts output)
                        (handling file)
                        (or (if output
                                (compile-file-to-c
                                 file
                                 options: opts
                                 output: output)
                                (compile-file-to-c
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
                             ld-options)
                            (exit-abnormally)))

                      (let loop2 ((lst arguments))
                        (if (##pair? lst)

                            (let ((file (##car lst))
                                  (rest (##cdr lst)))
                              (if (option? file)
                                  (let ((option-name (convert-option file)))
                                    (cond ((##string=? option-name "")
                                           (##repl-debug #f #t)
                                           (loop2 rest))
                                          ((##string=? option-name "e")
                                           (if (##pair? rest)
                                               (let ((src (read-source-from-string
                                                           (##car rest)
                                                           #f)))
                                                 (##eval-top src ##interaction-cte)
                                                 (loop2 (##cdr rest)))
                                               (loop2 rest)))
                                          (else
                                           (loop2 rest))))
                                  (let ((root (##path-strip-extension file)))
                                    (cond ((c-file? file)
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
                                                    (c#targ-generated-c-file? file))
                                               (add-gen-c-file file))
                                           (loop2 rest))
                                          ((obj-file? file)
                                           (add-obj-file file)
                                           (loop2 rest))
                                          (else
                                           (case type
                                             ((dyn)
                                              (let ((dyn-obj-file
                                                     (do-compile-file
                                                      file
                                                      options
                                                      output)))
                                                #f))
                                             ((obj)
                                              (let ((obj-file
                                                     (do-compile-file
                                                      file
                                                      (##cons '(obj) options)
                                                      output)))
                                                (add-obj-file obj-file)))
                                             ((link exe c)
                                              (let ((gen-c-file
                                                     (do-compile-file-to-c
                                                      file
                                                      options
                                                      (and (##eq? type 'c)
                                                           output))))
                                                (add-gen-c-file gen-c-file)
                                                (if (##eq? type 'exe)
                                                    (let ((obj-file
                                                           (do-compile-file
                                                            gen-c-file
                                                            (##cons '(obj) options)
                                                            #f)))
                                                      (add-obj-file obj-file)
                                                      (add-tmp-file obj-file)
                                                      (if (##not (##assq 'keep-c options))
                                                          (add-tmp-file gen-c-file)))))))
                                           (loop2 rest))))))

                            (let* ((flat?
                                    (##assq 'flat options))
                                   (base
                                    (let ((x (##assq 'l options)))
                                      (cond ((##not x)
                                             #f)
                                            ((or (##not (##eq? type 'link))
                                                 flat?)
                                             (warn-no-incremental-link)
                                             #f)
                                            (else
                                             (##cadr x))))))

                              (if (##memq type '(link exe))

                                  (let ((gen-c-files
                                         (##reverse rev-gen-c-files)))

                                    (if (##pair? gen-c-files)
                                        (let* ((link-file
                                                (if flat?
                                                    (if (and output
                                                             (##eq? type 'link))
                                                        (link-flat gen-c-files
                                                                   output: output)
                                                        (link-flat gen-c-files))
                                                    (if (and output
                                                             (##eq? type 'link))
                                                        (if base
                                                            (link-incremental
                                                             gen-c-files
                                                             output: output
                                                             base: base)
                                                            (link-incremental
                                                             gen-c-files
                                                             output: output))
                                                        (if base
                                                            (link-incremental
                                                             gen-c-files
                                                             base: base)
                                                            (link-incremental
                                                             gen-c-files))))))
                                          (add-gen-c-file link-file)
                                          (if (##eq? type 'exe)
                                              (let ((obj-link-file
                                                     (do-compile-file
                                                      link-file
                                                      (##cons '(obj) options)
                                                      #f)))
                                                (add-obj-file obj-link-file)
                                                (add-tmp-file obj-link-file)
                                                (if (##not (##assq 'keep-c options))
                                                    (add-tmp-file link-file))))))

                                    (if (##eq? type 'exe)
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
                                                        (##car
                                                         (if (##pair? gen-c-files)
                                                             (##reverse gen-c-files)
                                                             rev-obj-files)))
                                                       ##os-exe-extension-string-saved))))))))

                                  (if flat?
                                      (warn-flat-and-not-link-or-exe)))

                              (cleanup)
                              (##exit))))))))))))

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

  (define (warn-flat-and-not-link-or-exe)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- \"link\" or \"exe\" options were not specified: \"flat\" option ignored\n"
        output-port)
       #t)))

  (define (warn-mutually-exclusive-options)
    (##repl
     (lambda (first output-port)
       (##write-string
        "*** WARNING -- The options \"c\", \"link\", \"dynamic\", \"exe\" and \"obj\" are mutually exclusive\n"
        output-port)
       #t)))

  (define (option? arg)
    (and (##fixnum.< 0 (##string-length arg))
         (##char=? (##string-ref arg 0) #\-)))

  (define (convert-option arg)
    (##substring arg 1 (##string-length arg)))

  (define (split-command-line
           arguments
           allowed-options
           cont)
    (let loop1 ((args arguments)
                (rev-options '()))
      (if (and (##pair? args)
               (option? (##car args)))

        (let* ((opt (convert-option (##car args)))
               (rest (##cdr args))
               (x (##assoc opt allowed-options)))
          (if x
              (let ((opt-sym (##string->symbol opt)))
                (cond ((##not (##pair? (##cdr x)))
                       (loop1 rest
                              (##cons (##cons opt-sym
                                              '())
                                      rev-options)))
                      ((##not (##pair? rest))
                       (warn-missing-argument-for-option opt)
                       (loop1 rest rev-options))
                      (else
                       (let ((opt-val (##car rest)))
                         (case (##cadr x)
                           ((symbol)
                            (loop1 (##cdr rest)
                                   (##cons (##list opt-sym
                                                   (##string->symbol opt-val))
                                           rev-options)))
                           (else
                            (loop1 (##cdr rest)
                                   (##cons (##list opt-sym
                                                   opt-val)
                                           rev-options))))))))
              (cont (##reverse rev-options) args)))

        (cont (##reverse rev-options) args))))

  (##load-support-libraries)

  (let ((language-and-tail
         (##extract-language-and-tail (##car ##processed-command-line))))

    (if language-and-tail
      (let ((language (##car language-and-tail)))
        (##readtable-setup-for-language! (##current-readtable) language)))

    (split-command-line
      (##cdr ##processed-command-line)
      '(("f") ("i") ("v"))
      (lambda (main-options arguments)
        (let ((skip-initialization-file?
               (##assq 'f main-options))
              (force-interpreter?
               (or language-and-tail
                   (##assq 'i main-options)))
              (version?
               (##assq 'v main-options)))
          (if version?
            (begin
              (##write-string (##system-version-string) ##stdout-port)
              (##write-string " " ##stdout-port)
              (##write (##system-stamp) ##stdout-port)
              (##write-string " " ##stdout-port)
              (##write-string ##os-system-type-string-saved ##stdout-port)
              (##write-string " " ##stdout-port)
              (##write ##os-configure-command-string-saved ##stdout-port)
              (##newline ##stdout-port)
              (##exit))
            (split-command-line
              arguments
              (if (interpreter-or force-interpreter?)
                '()
                '(("c") ("dynamic") ("exe") ("obj") ("link") ("flat")
                  ("warnings") ("verbose") ("report")
                  ("expansion") ("gvm") ("asm")
                  ("check") ("force") ("keep-c")
                  ("debug") ("debug-location") ("debug-source") ("debug-environments")
                  ("track-scheme")
                  ("o" string) ("l" string)
                  ("prelude" string) ("postlude" string)
                  ("cc-options" string)
                  ("ld-options-prelude" string) ("ld-options" string)
                  ("target" symbol)))
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
