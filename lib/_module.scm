;;;============================================================================

;;; File: "_module.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "_module#.scm")

(implement-type-modref)

;;;----------------------------------------------------------------------------

(define ##module-search-order (##os-module-search-order))

(define-prim (##module-search-order-add! dir)
  (set! ##module-search-order (##cons dir ##module-search-order)))

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
          (##append-strings parts
                            (##string ##module-path-sep))))
    (if namespace?
        (##string-append name "#")
        name)))

(define (##modref->path modref full?)

  (define (last lst)
    (if (pair? (cdr lst))
      (last (cdr lst))
      (car lst)))

  (define (butlast lst)
    (if (pair? (cdr lst))
      (cons (car lst) (butlast (cdr lst)))
      '()))

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
    (let ((module-name (last rpath))
          (rest (butlast rpath)))
      ;; rpath contains at least one element.
      (if full?
        (join host
              (join
                (list (string-append "@" (or tag "")) module-name)
                (join rest #f)))
        ;; ignore the rest of rpath.
        (join host
              (path-expand
                (string-append "@" (or tag ""))
                module-name))))))

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
         (##reverse-string-split-at str ##module-path-sep tail)))

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
                                       (##char=? c #\.)))))
                        (loop (##fx- i 1)))))))))

  (define (valid-components? lst context)
    (if (##pair? lst)
        (let ((head (##car lst))
              (rest (##cdr lst)))
          (and (valid-component? head context)
               (valid-components? rest context)))
        #t))

  (define (valid-host-name? str) ;; syntax: component.component[.component]*
    (let ((x (##reverse-string-split-at str #\. '())))
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
               (x (##reverse-string-split-at head #\@ '()))
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

(define (##reverse-string-split-at str sep #!optional (rest '()))
  (let ((len (##string-length str)))
    (let loop ((i 0) (j 0) (lst rest))
      (if (##fx< j (##string-length str))
          (let ((c (##string-ref str j))
                (j+1 (##fx+ j 1)))
            (if (##char=? c sep)
                (loop j+1
                      j+1
                      (##cons (##substring str i j) lst))
                (loop i
                      j+1
                      lst)))
          (##cons (##substring str i j) lst)))))

;;;----------------------------------------------------------------------------

(define-prim (##search-module-aux modref check-mod search-order)

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
               (check-mod (##car dirs) (join dirs2 root) root dirs2))

             (or (check nested-dirs)
                 (and (##pair? nested-dirs)
                      (check (##cdr nested-dirs)))))))

    (let* ((host
            (macro-modref-host modref))
           (tag
            (macro-modref-tag modref))
           (rpath
            (macro-modref-rpath modref)))
      (if (or host tag)

          (search rpath
                  (butlast rpath)
                  (join (##list (##string-append "@" (or tag "")))
                        (##path-expand (last rpath)
                                       (if host
                                           (join host dir)
                                           dir)))
                  check-mod)

          (search rpath
                  rpath
                  dir
                  check-mod))))

  (let loop ((lst search-order))
    (and (##pair? lst)
         (let ((search-in (##car lst)))
           (or (search-dir (##path-expand-in-initial-current-directory search-in))
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

  (define (check-mod mod-filename-noext mod-dir root path)
    (let ((mod-path-noext (##path-expand mod-filename-noext mod-dir)))

      (define (check-source-with-ext ext)
        (let ((mod-path (##string-append mod-path-noext (##car ext))))
          (try-opening-source-file
           mod-path
           (lambda (port)
             (and (##not (##fixnum? port))
                  (##vector mod-dir
                            mod-filename-noext
                            ext
                            mod-path
                            port
                            root
                            path))))))

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

(define (##compile-mod top-cte src module-ref module-root modref-path script-line)
  (##compile-in-new-compilation-ctx
   top-cte
   src
   #f
   (lambda (cte src tail?)
     (if script-line
         (##compilation-ctx-meta-info-add! 'script-line script-line))
     (##compilation-ctx-module-ref-set! module-ref)
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

  (define (search-for-highest-object-file path-noext)
    (let loop ((version 1)
               (highest-object-file-path #f)
               (highest-object-file-info #f))
      (let* ((resolved-path
              (##path-resolve
               (##string-append path-noext
                                ".o"
                                (##number->string version 10))))
             (_ (if ##debug-modules? (pp (list '##file-info-aux resolved-path))));;;;;;;;;;;;;
             (resolved-info
              (##file-info-aux resolved-path))
             (resolved-path-exists?
              (##not (##fixnum? resolved-info))))
        (if resolved-path-exists?
            (loop (##fx+ version 1)
                  resolved-path
                  resolved-info)
            highest-object-file-path))))

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
                         (##vector supply-modules
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

  (define (module-prefix=? str prefix)
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

  (define (repl-confirm? question)
    (##member (##repl-channel-confirm question) '("y" "yes")))

  ;;; handle the install mode (ask always, ask never, ask when repl)
  (define (module-install-confirm? modstr)
    (let ((install-mode (##os-module-install-mode)))
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

  (if ##debug-modules? (pp (list '##install-module modref)));;;;;;;;;;;;;;;;;

  (and (##pair? (macro-modref-host modref))
       (let ((mod-string (##modref->string modref)))
         (and (or (##member
                   mod-string
                   (##os-module-whitelist)
                   (lambda (a b)
                     (module-prefix=? a b)))
                  ;; Ask user to install.
                  (module-install-confirm? mod-string))

              ((##eval '(let () (##import gambit/pkg) install)) mod-string)
              ;; Return the modref
              modref))))

(define-prim (##install-module-set! x)
  (set! ##install-module x))

(define-prim (##search-or-else-install-module
              modref
              #!optional
              (build? #f)
              (search-order ##module-search-order))

  (define (install-dir name rest)
    (let ((dir (##os-path-gambitdir-map-lookup name)))
      (if dir
          (##cons (##string-append "~~" name "=" dir) rest)
          rest)))

  (define (build-module modref)
    (let (#;(build-module (##global-var-ref
                         (##make-global-var '##build-module)))
          (modstr (##modref->string modref)))
      (if ##debug-modules? (pp (##list 'build-module modstr)))

      (##call-with-output-process
        (##list path: (##path-expand "gsc-script" (##path-expand "~~bin"))
                stdin-redirection: #f
                stdout-redirection: #f
                stderr-redirection: #f
                arguments:
                (##list (##append-strings
                         (##cons (##string-append "-:=" (##os-path-gambitdir))
                                 (install-dir "lib"
                                              (install-dir "userlib"
                                                           '())))
                         ",")
                        "-target"
                        (##symbol->string (macro-target))
                        modstr))
        (lambda (pid)
          (let ((status (##process-status pid)))
            (##eq? status 0))))))

  (or (##search-module modref search-order)
      (and (##install-module modref)
           (or (##not build?) (build-module modref))
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
             (let ((mod-info (##search-or-else-install-module modref #t)))
               (if mod-info ;; found module?
                   (##get-module-from-file module-ref modref mod-info)
                   (err))))))))

(define-prim (##load-module-or-file
              module-or-file
              #!optional
              (load-options '())
              (script-callback (lambda (script-line script-path) #f)))

  (define (load-file)
    (after-load
     (##load module-or-file
             script-callback
             #t  ;; clone-cte?
             #t  ;; raise-os-exception?
             #f  ;; linker-name
             #f) ;; quiet?
     module-or-file))

  (define (after-load result path)
    (if (##memq 'test load-options)
        (##load (##string-append (##path-strip-extension path) "-test")
                (lambda (script-line script-path) #f)
                #t   ;; clone-cte?
                #t   ;; raise-os-exception?
                #f   ;; linker-name
                #f)) ;; quiet?
    result)

  (let ((modref (##parse-module-ref module-or-file)))
    (if (##not modref)

        ;; not a valid module-ref syntax, so load as a file
        (load-file)

        (let* ((modstr (##modref->string modref))
               (module-ref (##string->symbol modstr))
               (mod (##lookup-registered-module module-ref)))
          (if mod

              ;; module is in the registered module table, so load it
              (##load-module (macro-module-module-ref mod))

              (let ((mod-info (##search-or-else-install-module modref #f)))
                (if mod-info

                    ;; module was found somewhere in the module search order
                    ;; or in the initial current directory, so load it from
                    ;; the filesystem
                    (let* ((mod
                            (##get-module-from-file module-ref
                                                    modref
                                                    mod-info))
                           (module-descr
                            (macro-module-module-descr mod))
                           (meta-info
                            (macro-module-descr-meta-info module-descr))
                           (x
                            (##assq 'script-line meta-info)))
                      (if x
                          (script-callback (##cdr x)
                                           (##vector-ref mod-info 3)))
                      (after-load
                       (##load-module (macro-module-module-ref mod))
                       (##vector-ref mod-info 3)))

                    ;; last resort is to load a file
                    (load-file))))))))

(define ##debug-modules? #f)

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

  (let* ((result (##search-setup-file rpath root))
         (comp-ctx (##compilation-ctx))
         (module-aliases (macro-compilation-ctx-module-aliases comp-ctx)))
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

(define (##apply-module-alias modref module-alias)
 (let* ((in (##car module-alias))
        (in-host (macro-modref-host in))
        (in-tag (macro-modref-tag in))
        (in-rpath (macro-modref-rpath in))

        (out (##cdr module-alias))
        (out-host (macro-modref-host out))
        (out-tag (macro-modref-tag out))
        (out-rpath (macro-modref-rpath out)))

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
                       (ipath (##reverse (macro-modref-rpath in))))
              (if (##pair? ipath)
                (and (##pair? spath)
                     (##string=? (##car spath) (##car ipath))
                     (loop (##cdr spath) (##cdr ipath)))               ;; prefix of spath matches so append rest of spath to alias
                  (macro-make-modref
                   out-host
                   (or out-tag (macro-modref-tag modref))
                   (##append (##reverse spath)
                             (macro-modref-rpath out)))))))))

;;;----------------------------------------------------------------------------

;;; validate and return the alias pair
(define-prim ##validate-define-module-alias
  (lambda (src)
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
      (lambda (name-src value-src)
        (let* ((name (##desourcify name-src))
               (value (##desourcify value-src))
               (name-modref (module-alias->modref name #f))
               (value-modref (module-alias->modref value #t)))

          ;;; TODO: make and abstraction to alias
          (##cons name-modref value-modref))))))

(define-prim ##parse-define-module-alias
  (lambda (src)
    (##compilation-ctx-module-aliases-add!
     (##validate-define-module-alias src))

    (##expand-source-template
     src
     `(##begin))))

(define-runtime-syntax ##define-module-alias
  ##parse-define-module-alias)

(define-runtime-syntax define-module-alias
  (##make-alias-syntax '##define-module-alias))

;;;----------------------------------------------------------------------------

(define-runtime-syntax ##import
  (lambda (src)
    (##deconstruct-call
     src
     2
     (lambda (arg-src)
       (let ((modref (##parse-module-ref arg-src)))
         (if (##not modref)

             (##raise-expression-parsing-exception
              'ill-formed-special-form
              src
              (##source-strip (##car (##source-strip src))))

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


                    (module-aliases (##extend-aliases-from-rpath rpath root))

                    (modref-alias
                      (let loop ((mod modref)
                                 (rest module-aliases))
                        (if (pair? rest)
                            (let ((alias (car rest)))
                              (loop (or (##apply-module-alias mod alias) mod)
                                    (cdr rest)))
                            mod)))

                    (mod-info
                     (##search-or-else-install-module modref-alias #t)))

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
                                           (##car (##vector-ref mod-info 2)))
                                          (##vector-ref mod-info 0))
                           #f))
                         (port
                          (##vector-ref mod-info 4)))
                     (if port
                         (##close-port port))
                     (let ((module-ref
                            (##string->symbol
                             (##modref->string modref-alias))))
                       `(##begin
                         ,@(if (##file-exists? sharp-path)
                               `((##include ,sharp-path))
                               `())
                         (##demand-module ,module-ref))))))))))))

;;;----------------------------------------------------------------------------

(define (##gsi-option-update args)
  ((##eval '(let () (##import gambit/pkg) gsi-option-update)) args))

(define (##gsi-option-install args)
  ((##eval '(let () (##import gambit/pkg) gsi-option-install)) args))

(define (##gsi-option-uninstall args)
  ((##eval '(let () (##import gambit/pkg) gsi-option-uninstall)) args))

(define ##gsi-option-handlers
 (##list (##cons 'update  ##gsi-option-update)
         (##cons 'uninstall ##gsi-option-uninstall)
         (##cons 'install ##gsi-option-install)))

;;;============================================================================
