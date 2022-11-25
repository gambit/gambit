;;;============================================================================

;;; File: "_module.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "_module#.scm")

(implement-type-modref)

;;;----------------------------------------------------------------------------

(define-prim&proc (module-whitelist-reset!)
  (##set-module-whitelist! '()))

(define-prim&proc (module-whitelist-add! source)
  (let ((modref (##parse-module-ref source #t)))
    (if (and modref (macro-modref-host modref))
        (let ((module-whitelist (##get-module-whitelist))
              (modref-str (##modref->string modref)))
          (if (##not (##member modref-str module-whitelist))
              (##set-module-whitelist!
               (##cons modref-str module-whitelist)))
          (##void))
        (error "hosted module reference expected but got" source))))

(define-prim&proc (module-search-order-reset!)
  (##set-module-search-order! '()))

(define-primitive (module-search-order-add! dir)
  (##set-module-search-order! (##cons dir (##get-module-search-order))))

(define-procedure (module-search-order-add! (dir string))
  (##module-search-order-add! dir))

(define-prim (##module-search-directory? str)
  (let ((len (##string-length str)))
    (and (##fx>= len 1)
         (or (##char=? (##string-ref str (##fx- len 1)) #\.)
             (##string=? (##path-strip-directory str) "")))))

;;;----------------------------------------------------------------------------

(define-prim (##modref->string modref #!optional (namespace? #f))
  (let* ((host
          (macro-modref-host modref))
         (tag
          (macro-modref-tag modref))
         (rpath
          (macro-modref-rpath modref))
         (parts
          (##append (if host (##reverse host) '())
                    (##reverse
                     (if tag
                         (##cons (##string-append (##car rpath) "@" tag)
                                 (##cdr rpath))
                         rpath))))
         (name
          (##string-concatenate parts
                                (##string ##module-path-sep))))
    (if namespace?
        (##string-append name "#")
        name)))

(define (##modref->path modref full? tag?)

  ;;TODO: deprecated (use ##path-join instead)
  (define (join parts dir)
    (if (pair? parts)
      (join (cdr parts)
            (if (string? dir) ;; Avoid trailing '/'
              (path-expand dir (car parts))
              (car parts)))
      dir))

  (let ((host (macro-modref-host modref))
        (tag (macro-modref-tag modref))
        (rpath (macro-modref-rpath modref)))
    (let ((module-name (##last rpath))
          (rest (##butlast rpath)))
      ;; rpath contains at least one element.
      (if full?
        (join host
              (join
                (if (not tag?)
                    (list module-name)
                    (list (string-append "@" (or tag "")) module-name))
                (join rest #f)))
        ;; ignore the rest of rpath.
        (join host
              (if (not tag?)
                  module-name
                  (path-expand
                    (string-append "@" (or tag ""))
                    module-name)))))))

(define (##modref-hosted? modref)
  (##pair? (macro-modref-host modref)))

(define (##modref-force-not-hosted modref)
  (let ((host (macro-modref-host modref))
        (tag (macro-modref-tag modref))
        (rpath (macro-modref-rpath modref)))
    (macro-make-modref
     #f
     tag
     (##append rpath (or host '())))))

(define-prim (##modref->namespace modref)
  (##modref->string modref #t))

(define-prim (##make-module-var modref sym)
  (##make-global-var
   (##string->symbol
    (##string-append (##modref->namespace modref)
                     (##symbol->string sym)))))

(define (##module-var-ref modref sym)
  (##global-var-ref (##make-module-var modref sym)))

(define (##module-var-set! modref sym val)
  (##global-var-set! (##make-module-var modref sym) val))

;;;----------------------------------------------------------------------------

(define ##module-path-sep #\/)

(define-prim (##parse-module-ref
              str-or-src
              #!optional
              (allow-empty-path? #f))
  (let ((x (##parse-module-ref-possibly-relative str-or-src allow-empty-path?)))
    (and x
         (##fx= (##car x) 0)
         (##cdr x))))

(define-prim (##parse-module-ref-possibly-relative
              str-or-src
              #!optional
              (allow-empty-path? #f))

  (define (valid-module-ref-part? x)
    (or (##symbol? x)
        (and (macro-exact-int? x) (##not (##negative? x)))))

  (define (module-ref-part->string x)
    (if (##symbol? x)
        (##symbol->string x)
        (##number->string x)))

  (define (reverse-split-at-module-path-sep str tail)
    (and tail
         (##string-split-at-char-reversed str ##module-path-sep tail)))

  (define (reverse-split-path lst tail)
    (let loop ((lst lst) (rev-parts tail))
      (if (##pair? lst)
          (let ((x (##source-strip (##car lst)))
                (rest (##cdr lst)))
            (and (valid-module-ref-part? x)
                 (let ((str (module-ref-part->string x)))
                   (and (##fx>= (##string-length str) 1)
                        (if (##char=? (##string-ref str 0) #\@)
                            (if (or (##pair? rest) (##not (##pair? rev-parts)))
                                #f
                                (##cons (##string-append (##car rev-parts) str)
                                        (##cdr rev-parts)))
                            (loop rest
                                  (reverse-split-at-module-path-sep
                                   str
                                   rev-parts)))))))
          (if (##null? lst)
              rev-parts
              #f))))

  (define (valid-component? str context)
    (let ((len (##string-length str)))
      (and (##fx>= len 1) ;; component must not be empty
           (or (##not (##eq? context 'host))
               ;; a host name component must not start or end with "-"
               (##not (or (##char=? (##string-ref str 0) #\-)
                          (##char=? (##string-ref str (##fx- len 1)) #\-))))
           ;; a component must not start or end with "."
           (##not (or (##char=? (##string-ref str 0) #\.)
                      (##char=? (##string-ref str (##fx- len 1)) #\.)))
           (let loop ((i (##fx- len 1)))
             (if (##fx< i 0)
                 #t
                 (let ((c (##string-ref str i)))
                   ;; otherwise a-z, A-Z, 0-9 and "-" are allowed
                   (and (or (and (##char>=? c #\a) (##char<=? c #\z))
                            (and (##char>=? c #\A) (##char<=? c #\Z))
                            (and (##char>=? c #\0) (##char<=? c #\9))
                            (##char=? c #\-)
                            (and (##not (##eq? context 'host))
                                 (or
                                  ;; except in host name, allow "_" and
                                  (##char=? c #\_)
                                  ;; in tag, allow "."
                                  (and (##eq? context 'tag)
                                       (##char=? c #\.)
                                       ;; must not be followed by "."
                                       (##not (##char=? (##string-ref str (##fx+ i 1)) #\.))))))
                        (loop (##fx- i 1)))))))))

  (define (valid-components? lst context)
    (if (##pair? lst)
        (let ((head (##car lst))
              (rest (##cdr lst)))
          (and (valid-component? head context)
               (valid-components? rest context)))
        #t))

  (define (valid-host-name? str) ;; syntax: component.component[.component]*
    (let ((x (##string-split-at-char-reversed  str #\.)))
      (and (##pair? (##cdr x)) ;; must have at least one "."
           (valid-components? x 'host)))) ;; and valid host components

  (define (parse-rest-with-tag nb-dots tag rev-parts)

    (define (done host)
      (and (or (##pair? rev-parts)
               allow-empty-path?)
           (##cons nb-dots
                   (macro-make-modref host
                                      tag
                                      rev-parts))))

    (if (##pair? rev-parts)
        (let loop ((prev2 #f) (prev1 #f) (curr rev-parts))
          (let ((part (##car curr))
                (next (##cdr curr)))
            (if (##pair? next)
                (and (valid-component? part 'path)
                     (loop prev1 curr next))
                (if (and (##fx= nb-dots 0) ;; hosted module?
                         (valid-host-name? part))
                    (and prev1
                         (begin
                           (if prev2
                               (##set-cdr! prev2 '()) ;; terminate path
                               (set! rev-parts '()))
                           (done prev1)))
                    (and (valid-component? part 'path)
                         (done #f))))))
        (done #f)))

  (define (parse-rest nb-dots rev-parts)
    (if (##pair? rev-parts)
        (let* ((head (##car rev-parts))
               (x (##string-split-at-char-reversed  head #\@))
               (len (##length x)))
          (cond ((##fx> len 2) ;; improper syntax to have more than one "@"
                 #f)
                ((##fx= len 2) ;; one "@", check for valid tag
                 (let ((tag (##car x)))
                   (and (valid-component? tag 'tag)
                        (parse-rest-with-tag nb-dots
                                             tag
                                             (let ((name (##cadr x))
                                                   (tail (##cdr rev-parts)))
                                               (if (##string=? name "")
                                                   tail
                                                   (##cons name tail)))))))
                (else
                 (parse-rest-with-tag nb-dots
                                      #f
                                      rev-parts))))
        (parse-rest-with-tag nb-dots
                             #f
                             rev-parts)))

  (define (parse-head-rest head-str rest)
    (let ((len-head-str (##string-length head-str)))
      (let loop ((nb-dots 0))
        (if (##fx< nb-dots len-head-str)
            (if (##char=? (##string-ref head-str nb-dots) #\.)
                (loop (##fx+ nb-dots 1))
                (parse-rest
                 nb-dots
                 (reverse-split-path
                  rest
                  (reverse-split-at-module-path-sep
                   (##substring head-str nb-dots len-head-str)
                   '()))))
            (parse-rest
             nb-dots
             (reverse-split-path
              rest
              '()))))))

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

;;;----------------------------------------------------------------------------

(define (##search-module-with-exts mod-filename-noext mod-dir root path exts)
  (let ((mod-path-noext (##path-expand mod-filename-noext mod-dir)))

    (define (try-opening-source-file path cont)
      (and ##debug-modules?
           (##debug-modules-trace 'try-opening-source-file path))
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

    (define (check-source-with-ext ext)
      (let ((mod-path (##string-append mod-path-noext (##car ext))))
        (try-opening-source-file
         mod-path
         (lambda (port resolved-path)
           (and (##not (##fixnum? port))
                (##vector mod-dir
                          mod-filename-noext
                          ext
                          mod-path
                          port
                          root
                          path))))))

    (let loop ((exts exts))
      (and (##pair? exts)
           (or (check-source-with-ext (##car exts))
               (loop (##cdr exts)))))))

(define (##search-module-at dirs nested-dirs root exts)
  (and (##pair? dirs)
       (let ()

         (define (check dirs2)
           (##search-module-with-exts
            (##car dirs)
            (##path-join-reversed dirs2 root)
            root
            dirs2
            exts))

         (or (check nested-dirs)
             (and (##pair? nested-dirs)
                  (check (##cdr nested-dirs)))))))

(define (##search-module-in-dir modref dir)
  (let* ((host
          (macro-modref-host modref))
         (tag
          (macro-modref-tag modref))
         (rpath
          (macro-modref-rpath modref)))
    (if (or host tag)

        (##search-module-at
         rpath
         (##butlast rpath)
         (##path-join-reversed
          (##list (##string-append "@" (or tag "")))
          (##path-expand (##last rpath)
                         (if host
                             (##path-join-reversed host dir)
                             dir)))
         ##scheme-file-extensions)

        (let ((main-repo-path
               (##path-expand "@" (##path-expand (##last rpath) dir))))
          (if (##file-exists? main-repo-path)

              (##search-module-at
               rpath
               (##butlast rpath)
               main-repo-path
               ##scheme-file-extensions)

              (##search-module-at
               rpath
               rpath
               dir
               ##scheme-file-extensions))))))

(define (##default-search-module-in-search-order modref search-order)
  (let loop ((lst search-order))
    (and (##pair? lst)
         (let ((dir (##car lst)))
           (or (##search-module-in-dir
                modref
                (##path-expand-in-initial-current-directory dir))
               (loop (##cdr lst)))))))

(define ##search-module-in-search-order
  ##default-search-module-in-search-order)

(define-prim (##search-module-in-search-order-set! x)
  (set! ##search-module-in-search-order x))

(define-prim (##search-module
              modref
              #!optional
              (search-order (##get-module-search-order)))
  (##search-module-in-search-order modref search-order))

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

(define (##compile-mod top-cte src module-ref module-root modref-path script-line)
  (##compile-in-new-compilation-ctx
   top-cte
   src
   #f
   (lambda (cte src tail?)
     (if script-line
         (##compilation-meta-info-add! 'script-line script-line))
     (##compilation-module-ref-set! module-ref)
     (let ((comp-scope (##compilation-scope)));;TODO: deprecated interface
       (##table-set! comp-scope '##module-root module-root)
       (##table-set! comp-scope '##modref-path modref-path))
     (let ((tail? #f))
       (##comp-top top-cte src tail?)))))

(define-prim (##get-module-from-file module-ref modref mod-info)

  (define (err)
    (##raise-module-not-found-exception
     ##get-module
     module-ref))

  (define (search-for-highest-object-file path-noext stop-at-first?)
    (let loop ((version 1)
               (highest-object-file-path #f)
               (highest-object-file-info #f))
      (let* ((resolved-path
              (##path-resolve
               (##string-append path-noext
                                ".o"
                                (##number->string version 10))))
             (_
              (and ##debug-modules?
                   (##debug-modules-trace 'path-exists? resolved-path)))
             (resolved-info
              (##file-info-aux resolved-path))
             (resolved-path-exists?
              (##not (##fixnum? resolved-info))))
        (if resolved-path-exists?
            (if stop-at-first?
                (##vector resolved-path
                          resolved-info)
                (loop (##fx+ version 1)
                      resolved-path
                      resolved-info))
            (and highest-object-file-path
                 (##vector highest-object-file-path
                           highest-object-file-info))))))

;;  (pp `(##get-module-from-file module-ref: ,module-ref modref: ,(##vector-copy modref) mod-info: ,mod-info))

  (let ((mod-dir            (##vector-ref mod-info 0))
        (mod-filename-noext (##vector-ref mod-info 1))
        (ext                (##vector-ref mod-info 2))
        (mod-path           (##vector-ref mod-info 3))
        (port               (##vector-ref mod-info 4))
        (root               (##vector-ref mod-info 5))
        (path               (##vector-ref mod-info 6)))

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
                    (##symbol->string module-ref)))
              (##call-with-values
               (lambda ()
                 (##compile-mod
                  (##top-cte-clone ##interaction-cte)
                  (##sourcify src (##make-source #f #f))
                  module-ref
                  root
                  path
                  script-line))
               (lambda (code comp-ctx)
                 (let* ((supply-modules
                         (let ((mods (macro-compilation-ctx-supply-modules comp-ctx)))
                           (##list->vector
                            (if (##not (##memq module-ref mods))
                                (##append (##list module-ref) mods)
                                mods))))
                        (demand-modules
                         (let ((mods (macro-compilation-ctx-demand-modules comp-ctx)))
                           (##list->vector mods)))
                        (meta-info
                         (##meta-info->alist
                          (macro-compilation-ctx-meta-info comp-ctx)))
                        (module-descr
                         (macro-make-module-descr
                          supply-modules
                          demand-modules
                          meta-info
                          0
                          (lambda ()
                            (let ((rte #f))
                              (macro-code-run code)))
                          #f)))
                   (macro-code-parent-set!
                    code
                    (macro-make-code-attributes
                     supply-modules
                     demand-modules
                     meta-info
                     code))
                   ;;(pp (list 'code-parent= (##subvector (##vector-copy (macro-code-parent code)) 0 3)))
                   (##register-module-descrs (##vector module-descr))
                   (or (##lookup-registered-module module-ref)
                       (err)))))))))

    (define (get-from-object-file path-and-info)
      (##close-port port)
      (let* ((path
              (##vector-ref path-and-info 0))
             (linker-name
              (##path-strip-directory path))
             (_
              (and ##debug-modules?
                   (##debug-modules-trace '##os-load-object-file path linker-name)))
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

    (define (search-for-object-file dir stop-at-first?)
      (search-for-highest-object-file
       (##path-expand mod-filename-noext dir)
       stop-at-first?))

    (let* ((build-subdir-path
            (##module-build-subdir-path mod-dir
                                        mod-filename-noext
                                        (macro-target)))
           (object-file-path-and-info
            (or (search-for-object-file build-subdir-path #t)
                (search-for-object-file mod-dir #f))))

      (cond ((and object-file-path-and-info
                  ;; check that the object file is not older than the
                  ;; source file
                  (let ((mod-path-info
                         (##file-info-aux mod-path)))
                    (and mod-path-info ;; source file (still) exists
                         (##not (##fl<
                                 (macro-time-point
                                  (macro-file-info-last-modification-time
                                   (##vector-ref object-file-path-and-info 1)))
                                 (macro-time-point
                                  (macro-file-info-last-modification-time
                                   mod-path-info)))))))
             (get-from-object-file object-file-path-and-info))

            ((##file-exists?
              (##path-expand
               (##string-append mod-filename-noext "._must-build_")
               mod-dir))

             ;; run a subprocess to build module
             (##build-module-subprocess
              mod-path
              (macro-target)
              (##list (##list 'module-ref module-ref)))

             (let ((object-file-path-and-info
                    (search-for-object-file build-subdir-path #t)))
               (if object-file-path-and-info
                   (get-from-object-file object-file-path-and-info)
                   (get-from-source-file))))

            (else
             (get-from-source-file))))))

(define-prim (##build-module-subprocess path target options)

  (define (install-dir name rest)
    (let ((dir (##os-path-gambitdir-map-lookup name)))
      (if dir
          (##cons (##string-append "~~" name "=" dir) rest)
          rest)))

  (let* ((gsc-path
          (##path-expand
           (##string-append "gsc-script"
                            ##os-bat-extension-string-saved)
           (##path-normalize-directory-existing "~~bin")))
         (arguments
          (##list (##string-concatenate
                   (##cons (##string-append "-:=" (##os-path-gambitdir))
                           (install-dir "lib"
                                        (install-dir "userlib"
                                                     '())))
                   ",")
                  "-e"
                  (##object->string
                   `(##begin
                     (##set-module-search-order!
                      ',(##get-module-search-order))
                     (##build-module
                      ',path
                      ',target
                      ',(##append
                         options
                         ##build-module-subprocess-default-options)))))))

    (##tty-mode-reset) ;; reset tty (in case subprocess needs to read tty)

    (let ((status
           (##run-subprocess
            gsc-path
            arguments
            #f  ;; don't capture output
            #f  ;; don't redirect stdin
            #f))) ;; run in current directory
      (##eqv? status 0))))

(define ##build-module-subprocess-default-options '())

(define-prim (##build-module-subprocess-default-options-set! default-options)
  (set! ##build-module-subprocess-default-options default-options))

(define-prim (##module-prefix=? str prefix)
  (let ((str-len (##string-length str))
        (prefix-len (##string-length prefix)))
    (and
     (##fx<= prefix-len str-len)
     (let loop ((i 0))
       (if (##fx< i prefix-len)
           (let ((c1 (##string-ref prefix i))
                 (c2 (##string-ref str i)))
             (and
              (##char=? c1 c2)
              (loop (##fx+ i 1))))
           (if (##fx= i str-len)
               #t
               (##char=? ##module-path-sep (##string-ref str i))))))))

(define-prim (##install-module modref)

  (define (repl-confirm? question)
    (##member (##repl-channel-confirm question) '("y" "yes")))

  ;;; handle the install mode (ask always, ask never, ask when repl)
  (define (module-install-confirm? modstr)
    (let ((install-mode (##get-module-install-mode)))
      (and (or (##fx= install-mode
                      (macro-module-install-mode-ask-always))
               (and (##fx= install-mode
                           (macro-module-install-mode-ask-when-repl))
                    (macro-thread-repl-channel
                     (macro-current-thread))))
           (repl-confirm?
            (##string-append
             "Hosted module "
             modstr
             " is required but is not installed.\nDownload and install (y/n)? ")))))

  (and (##not (##fx= (##get-module-install-mode)
                     (macro-module-install-mode-ask-never)))
       (##pair? (macro-modref-host modref)) ;; only install hosted modules
       (begin
         (and ##debug-modules?
              (##debug-modules-trace '##install-module modref))
         (let ((mod-string (##modref->string modref)))

           (and (or (##member
                     mod-string
                     (##get-module-whitelist)
                     ##module-prefix=?)
                    ;; Ask user to install.
                    (module-install-confirm? mod-string))

                ((##eval '(##let ()
                            (##demand-module _pkg)
                            _pkg#install))
                 mod-string)

                ;; Return the modref
                modref)))))

(define-prim (##install-module-set! x)
  (set! ##install-module x))

(define-prim (##search-or-else-install-module
              modref
              #!optional
              (search-order (##get-module-search-order)))
  (or (##search-module modref search-order)
      (and (##install-module modref)
           (##search-module modref search-order))))

(##get-module-set!
 (lambda (module-ref)

   (define (err)
     (##raise-module-not-found-exception
      ##get-module
      module-ref))

   (or (##lookup-registered-module module-ref)
       (let ((modref (##parse-module-ref (##symbol->string module-ref))))
         (if (##not modref)
             (err)
             (let ((mod-info (##search-or-else-install-module modref)))
               (if mod-info ;; found module?
                   (##get-module-from-file module-ref modref mod-info)
                   (err))))))))

(define-prim (##load-module-or-file
              module-or-file
              #!optional
              (script-callback (lambda (script-line script-path) #f)))

  (define (load-file)
    (##load module-or-file
            script-callback
            #t   ;; clone-cte?
            #t   ;; raise-os-exception?
            #f   ;; linker-name
            #f)) ;; quiet?

  (define (handle-script-callback mod mod-info)
    (let* ((module-descr
            (macro-module-module-descr mod))
           (meta-info
            (macro-module-descr-meta-info module-descr))
           (x
            (##assq 'script-line meta-info)))
      (if x
          (let ((y (##cdr x)))
            (script-callback (if (##pair? y) (##car y) y)
                             (and mod-info
                                  (##vector-ref mod-info 3)))))))

  (define (load-module-handling-script-callback mod mod-info)
    (handle-script-callback mod mod-info)
    (##load-module (macro-module-module-ref mod)))

  (let ((modref (##parse-module-ref module-or-file)))
    (if (##not modref)

        ;; not a valid module-ref syntax, so load as a file
        (load-file)

        (let* ((modstr (##modref->string modref))
               (module-ref (##string->symbol modstr))
               (mod (##lookup-registered-module module-ref)))
          (if mod

              ;; module is in the registered module table, so load it
              (load-module-handling-script-callback mod #f)

              (let ((mod-info (##search-or-else-install-module modref)))
                (if mod-info

                    ;; module was found somewhere in the module search order
                    ;; or in the initial current directory, so load it from
                    ;; the filesystem
                    (load-module-handling-script-callback
                     (##get-module-from-file module-ref modref mod-info)
                     mod-info)

                    ;; last resort is to load a file
                    (load-file))))))))

(define (##debug-modules-trace . info)
  (##repl
   (lambda (first port)
     (##write-string "*** " port)
     (##write info port)
     (##newline port)
     #t)))

(define ##debug-modules?
  (let* ((settings
          (##set-debug-settings! 0 0))
         (level
          (##fxwraplogical-shift-right
           (##fxand
            settings
            (macro-debug-settings-level-mask))
           (macro-debug-settings-level-shift))))
    (##fx>= level 4)))

(define-prim (##debug-modules?-set! x)
  (set! ##debug-modules? x))

;;;----------------------------------------------------------------------------

(define-prim (##search-setup-file
              rpath
              root
              #!optional
              (alt-name (macro-absent-obj)))

  (define (try-open fn)
    (with-exception-handler
      (lambda (exn)
        #f)
      (lambda ()
        (##open-input-file fn))))

  (define (rpath-join p lst)
    (if (##pair? lst)
        (rpath-join
          (##path-expand p (##car lst))
          (##cdr lst))
        p))

  (define (parent-directory dir)
    (##path-directory
      (##path-strip-trailing-directory-separator
        dir)))

  (macro-force-vars (rpath root alt-name)
    (let ((name (if (##eq? alt-name (macro-absent-obj))
                  "_setup_.scm"
                  alt-name)))

      (let loop ((dir (if (##pair? rpath)
                          (rpath-join (##car rpath) (##cdr rpath))
                          "")))
        (let ((fn (##path-expand name (##path-expand dir root))))
          (let ((port (try-open fn)))
            (if port
              (##vector fn port)
              (and
                (##fx< 0 (##string-length dir))
                (loop (parent-directory dir))))))))))

(define-prim (##extend-aliases-from-rpath rpath root)

  (define (read-setup-file-from-port port)
    (let ((ret (##read-all-as-a-begin-expr-from-port
                  port
                  (##current-readtable)
                  ##wrap-datum
                  ##unwrap-datum #f #t)))
      (and (##vector? ret)
           (##vector-ref ret 1))))

  (let* ((result
          (##search-setup-file rpath root))
         (comp-ctx
          (##compilation-ctx))
         (module-aliases
          (if comp-ctx
              (macro-compilation-ctx-module-aliases comp-ctx)
              '())))
    (if (##vector? result)
        (let* ((port (##vector-ref result 1))
               (src (read-setup-file-from-port port)))
          (##deconstruct-call
           src
           -1
           (lambda srcs
             (##append
              module-aliases
              (##fold
               (lambda (decl-src base)
                 (let ((decl (##source-strip decl-src)))
                   (and (##pair? decl)
                        (case (##source-strip (##car decl))
                          ((##define-module-alias define-module-alias)
                           (##extend-module-aliases
                            (##validate-define-module-alias decl-src)
                            base))

                          (else base)))))
               '()
               srcs)))))
        module-aliases)))

(define-prim (##make-pattern-module-alias in-modref out-modref)
  (lambda (modref)
    (let* ((in-host (macro-modref-host in-modref))
           (in-tag (macro-modref-tag in-modref))
           (in-rpath (macro-modref-rpath in-modref))
           (out-host (macro-modref-host out-modref))
           (out-tag (macro-modref-tag out-modref))
           (out-rpath (macro-modref-rpath out-modref)))

      (if (and (##not out-host) out-tag (##null? out-rpath)
               (##not in-tag) (##pair? in-rpath)
               (##equal? (macro-modref-host modref) in-host)
               (##equal? (macro-modref-rpath modref) in-rpath))

          (macro-make-modref
           in-host
           out-tag
           in-rpath)

          (and (##equal? (macro-modref-host modref) in-host)
               (if in-tag
                   (##equal? (macro-modref-tag modref) in-tag)
                   #t)
               (let loop ((spath (##reverse (macro-modref-rpath modref)))
                          (ipath (##reverse in-rpath)))
                 (if (##pair? ipath)
                     (and (##pair? spath)
                          (##string=? (##car spath) (##car ipath))
                          (loop (##cdr spath) (##cdr ipath)))
                     ;; spath prefix matches so append rest of spath to alias
                     (let ((rpath (##append (##reverse spath) out-rpath)))
                       (and (##pair? rpath)
                            (macro-make-modref
                             out-host
                             (or out-tag (macro-modref-tag modref))
                             rpath))))))))))

(define (##apply-module-alias modref module-alias)
  (module-alias modref))

;;;----------------------------------------------------------------------------

;;; validate the define-module-alias and return the alias

(define-prim (##validate-define-module-alias src)

  (define (ill-formed-define-module-alias)
    (##raise-expression-parsing-exception
     'ill-formed-define-module-alias
     src))

  (define (module-alias->modref alias allow-empty-path?)
    (cond
      ((or (##symbol? alias)
           (##pair? alias))
       (let ((modref (##parse-module-ref alias allow-empty-path?)))
         (if (macro-modref? modref)
             modref
             (ill-formed-define-module-alias))))
      (else
        (ill-formed-define-module-alias))))

  (##deconstruct-call
    src
    3
    (lambda (in-src out-src)
      (let* ((in (##desourcify in-src))
             (out (##desourcify out-src))
             (in-modref (module-alias->modref in #f))
             (out-modref (module-alias->modref out #t)))
        (##make-pattern-module-alias in-modref out-modref)))))

(define-prim (##parse-define-module-alias src)

  (##compilation-module-aliases-add!
   (##validate-define-module-alias src))

  (##expand-source-template
   src
   `(##begin)))

(define-runtime-syntax ##define-module-alias
  ##parse-define-module-alias)

(define-runtime-syntax define-module-alias
  (##make-alias-syntax '##define-module-alias))

;;;----------------------------------------------------------------------------

(define-prim (##find-mod-info src arg-src)
  (let ((modref (##parse-module-ref arg-src)))
    (if (##not modref)

        (##raise-ill-formed-special-form src)

        (let* ((relative-to-path
                (##source-path src))

               (rpath
                (if (##not relative-to-path)
                    '()
                    (##table-ref (##compilation-scope);;TODO: deprecated interface
                                 '##modref-path
                                 '())))

               (root
                ;; TODO: make this depend on the modref of the current code
                (if (##not relative-to-path)
                    (##current-directory)
                    (##table-ref (##compilation-scope);;TODO: deprecated interface
                                 '##module-root
                                 (##path-directory relative-to-path))))

               (module-aliases
                (##extend-aliases-from-rpath rpath root))

               (final-modref
                (let loop1 ((mod modref))
                  (let loop2 ((mod mod)
                              (rest module-aliases))
                    (if (##pair? rest)
                        (let ((m (##apply-module-alias mod (##car rest))))
                          (if m
                              (loop1 m)
                              (loop2 mod
                                     (##cdr rest))))
                        mod)))))

          (##values (##search-or-else-install-module final-modref)
                    (##string->symbol (##modref->string final-modref)))))))

(define-runtime-syntax ##import
  (lambda (src)
    (##deconstruct-call
     src
     2
     (lambda (arg-src)
       (##call-with-values
        (lambda ()
          (##find-mod-info src arg-src))
        (lambda (mod-info module-ref)
          (if (##not mod-info)
              (##raise-expression-parsing-exception
               'module-not-found
               src
               (##desourcify arg-src))
              (let ((sharp-path
                     (##path-normalize
                      (##path-expand (##string-append
                                      (##vector-ref mod-info 1)
                                      "#"
                                      ".scm" #;(##car (##vector-ref mod-info 2)))
                                     (##vector-ref mod-info 0))
                      #f))
                    (port
                     (##vector-ref mod-info 4)))
                (if port
                    (##close-port port))
                `(##begin
                  ,@(if (##file-exists? sharp-path)
                        `((##include ,sharp-path))
                        `())
                  (##demand-module ,module-ref))))))))))

;;;----------------------------------------------------------------------------

(define (##gsi-option-update args)
  ((##eval '(##let ()
              (##demand-module _pkg)
              _pkg#gsi-option-update))
   args))

(define (##gsi-option-install args)
  ((##eval '(##let ()
              (##demand-module _pkg)
              _pkg#gsi-option-install))
   args))

(define (##gsi-option-uninstall args)
  ((##eval '(##let ()
              (##demand-module _pkg)
              _pkg#gsi-option-uninstall))
   args))

(define ##gsi-option-handlers
 (##list (##cons 'update  ##gsi-option-update)
         (##cons 'uninstall ##gsi-option-uninstall)
         (##cons 'install ##gsi-option-install)))

;;;----------------------------------------------------------------------------

;;; Accelerate syntax transformations.

(##include "~~lib/_syntax-xform.scm")
(##include "~~lib/_syntax-case-xform.scm")
(##include "~~lib/_syntax-rules-xform.scm")

(##include "~~lib/_syntax.scm")

(define (syn#define-syntax-form-transformer src)
  (syntax-case src ()
    ((_ id fn)
     #'(##define-syntax id
         (##lambda (##src)
;;           (##include "~~lib/_syntax.scm")
           (fn ##src))))))

(define-runtime-syntax define-syntax
  (lambda (src)
    (let ((locat (##source-locat src)))
      (##make-source
       (##cons (##make-source '##define-syntax locat)
               (##cdr (##source-code src)))
       locat))))

(define-runtime-syntax syntax
  (lambda (src)
    (syn#syntax-form-transformer src '())))

(define-runtime-syntax syntax-case
  (lambda (src)
    (syn#syntax-case-form-transformer src)))

(define-runtime-syntax syntax-rules
  (lambda (src)
    (syn#syntax-rules-form-transformer src)))

;;;============================================================================
