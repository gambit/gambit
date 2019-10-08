;;;============================================================================

;;; File: "_pkg.scm"

;;; Copyright (c) 2019 by Frédéric Hamel, All Rights Reserved.
;;; Copyright (c) 2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Description:
;;; A module that manages the installation, update
;;; and removal of Gambit modules.
;;;
;;; It exports the following functionalities:
;;;
;;;    https-proto
;;;    install
;;;    install-hook
;;;    installed?
;;;    module-default-proto
;;;    module-default-proto-set!
;;;    ssh-proto
;;;    uninstall
;;;    update
;;;    gsi-option-update
;;;    gsi-option-uninstall
;;;    gsi-option-install

(##supply-module _pkg)

(##namespace ("_pkg#"))
(##include "~~lib/_prim#.scm")
(##include "~~lib/_gambit#.scm")
(##include "~~lib/_module#.scm")

(##import _git)
(##import _tar)

(declare
  (block)
  (not safe)
  (extended-bindings))

;;;----------------------------------------------------------------------------

(##include "_pkg#.scm")

(define-type pkg-exception
  id: 65615C63-2EC3-43F7-89C2-ADC230DFD651
  constructor: macro-make-pkg-exception
  copier: #f
  opaque:
  macros:
  prefix: macro-

  (message read-only: no-functional-setter:))

(define (default-installation-directory)
  (path-expand "~~instlib"))

;; Protocols
(define (https-proto mod)
  (string-append "https://" mod))

(define (ssh-proto mod)
  (string-append "ssh://git@" mod))

(define module-default-proto https-proto)

(define (module-default-proto-set! proto)
  (macro-check-procedure
    proto
    1
    (module-default-proto-set! proto)
    (set! module-default-proto proto)))

;; remove folder tree from the prefix
(define (cleanup-install-folder folder prefix)
  (if (< 0 (string-length folder))
    (let ((folder-name (path-expand folder prefix)))
      (if (not (fixnum? (##delete-file-or-directory folder-name #f #f)))
          (cleanup-install-folder
            (path-strip-trailing-directory-separator
              (path-directory folder)) prefix)))))

(define (invalid-module-name)
  (macro-make-pkg-exception "Invalid module name"))

(define (unable-to-install-module)
  (macro-make-pkg-exception "Unable to install module"))

(define (unable-to-install-specific-version mod)
  (macro-make-pkg-exception (string-append "Unable to install specific version of " mod)))

(define (module-already-installed mod)
  (macro-make-pkg-exception (string-append "Module " mod " is already installed")))

(define (module-not-installed module)
  (macro-make-pkg-exception (string-append "Module " module " is not installed")))

(define (module-not-found module)
  (macro-make-pkg-exception (string-append "Module not found " module)))

(define (install-archive archive output raise-exn)
  (let ((tmp-dir (create-temporary-directory output)))
    (with-exception-catcher
      (lambda (exn)
        (delete-file-or-directory tmp-dir #t)
        (if raise-exn
            (raise exn)
            #f))
      (lambda ()
        (tar-rec-list-write archive tmp-dir)
        (rename-file tmp-dir output)))))

(define (install-hosted modref install-dir prompt? url-transformer raise-exn)
  (let* ((host (macro-modref-host modref))
         (tag (macro-modref-tag modref))
         (rpath (macro-modref-rpath modref))

         (module-name (last rpath))
         (base-url (fold (lambda (a b)
                           (path-expand b a))
                         module-name host))

         (url (url-transformer base-url)) ;; transform url

         (clone-path (path-expand "@" base-url))
         (cache (path-expand clone-path install-dir))
         (output (path-expand (##modref->path modref #f) install-dir)))

    (if (file-exists? output)
        (if raise-exn
            (raise (module-already-installed (##modref->string modref)))
            #f)
        ;;; update here
        (let ((repo (or (git-repository-open cache)
                        (git-clone url
                                   cache
                                   #f
                                   prompt?))))
          (if (macro-git-repository? repo)
              (if tag
                  (let ((archive (or (git-archive repo tag)
                                     (and (update-modref modref install-dir raise-exn) ;; TODO: handle prompt? in update
                                          (git-archive repo tag)))))
                    (if (pair? archive)
                        (install-archive archive output raise-exn)
                        (if raise-exn
                            (raise (unable-to-install-specific-version (##modref->string modref)))
                            #f))))
              (begin
                (cleanup-install-folder clone-path install-dir)
                (if raise-exn
                    (raise (unable-to-install-module))
                    #f)))))))

(define (install-local modref install-dir raise-exn)
  (let* ((tag (macro-modref-tag modref))
         (at-tag (string-append "@" (or tag "")))


         (rpath (macro-modref-rpath modref))
         (mod-name (car rpath))
         (local-modref (macro-make-modref
                         #f
                         tag
                         (list mod-name)))

         (mod-path (fold (lambda (p acc)
                              (path-expand acc p))
                            (car rpath)
                            (cdr rpath)))

         (origin (git-repository-open
                   (path-expand mod-path)))
         (clone-path (path-expand "@" mod-name))
         (cache (path-expand clone-path install-dir))
         (output (path-expand
                   (path-expand at-tag mod-name)
                   install-dir)))

    (if (file-exists? output)
        (if raise-exn
            (raise (module-already-installed (##modref->string local-modref)))
            #f)

        (let ((repo (or (git-repository-open cache)
                        (and (macro-git-repository? origin)
                             (git-clone (macro-git-repository-path origin) cache)))))
          (if (macro-git-repository? repo)
              (if tag
                  (let ((archive (or (git-archive repo tag)
                                     (and (update-modref local-modref install-dir raise-exn)
                                          (git-archive repo tag)))))
                    (if (pair? archive)
                        (install-archive archive output raise-exn)
                        (if raise-exn
                            (raise (unable-to-install-specific-version
                                   (##modref->string local-modref)))
                            #f))))
              (begin
                (cleanup-install-folder clone-path install-dir)
                (if raise-exn
                    (raise (unable-to-install-module))
                    #f)))))))


(define (install-modref modref install-dir prompt? url-transformer raise-exn)
  (if (pair? (macro-modref-host modref))
    (install-hosted modref install-dir prompt? url-transformer raise-exn)
    (install-local modref install-dir raise-exn)))

(define (install-aux modstr install-dir prompt? url-transformer raise-exn)
  (let ((modref (##parse-module-ref modstr)))
    (if (macro-modref? modref)
        (install-modref modref install-dir prompt? url-transformer raise-exn)
        (if raise-exn
            (raise (invalid-module-name))
            #f))))

;; Installation function
(define (install modstr
                 #!optional
                 (install-dir (macro-absent-obj))
                 (prompt? (macro-absent-obj))
                 (url-transformer (macro-absent-obj))
                 (raise-exn (macro-absent-obj)))
  (macro-force-vars (modstr install-dir prompt? url-transformer)
    (macro-check-string
      modstr
      1
      (install modstr install-dir prompt? url-transformer raise-exn)
      (let ((dir (if (or (##eq? install-dir (macro-absent-obj))
                         (##not install-dir))
                     (default-installation-directory)
                     (macro-check-string
                       install-dir
                       2
                       (install modstr install-dir prompt? url-transformer raise-exn)
                       install-dir))))
        (let ((transformer (if (or (##eq? url-transformer (macro-absent-obj))
                                   (##not url-transformer))
                               module-default-proto
                               (macro-check-procedure
                                 url-transformer
                                 4
                                 (install modstr install-dir prompt? url-transformer raise-exn)
                                 url-transformer))))
          (install-aux modstr
                       dir
                       (if (##eq? prompt? (macro-absent-obj))
                           #f
                           prompt?)
                       transformer
                       (if (##eq? raise-exn (macro-absent-obj))
                           #f
                           raise-exn)))))))

(define (uninstall-aux module dir)
  (define (uninstall-modref modref install-dir)
    (let* ((tag (macro-modref-tag modref))
           (mod-path (##modref->string
                      (macro-make-modref
                       (macro-modref-host modref)
                       #f
                       (##list (##last (macro-modref-rpath modref)))))))
      (if tag
          (let ((at-tag (string-append "@" tag)))
             (delete-file-or-directory
               (path-expand
                 (path-expand
                   at-tag
                   mod-path)
                 install-dir)
               #t)
             (cleanup-install-folder mod-path install-dir))
            (let ((root-path (path-expand mod-path install-dir)))
              (if (and (file-exists? root-path)
                       (eq? (file-info-type
                              (file-info root-path))
                            'directory))
                  (begin
                    (for-each
                      (lambda (ver)
                        (case (string-ref ver 0)
                          ((#\@)
                            (delete-file-or-directory
                               (path-expand
                                  (path-expand ver mod-path)
                                  install-dir) #t))))
                      (directory-files root-path))
                    (cleanup-install-folder mod-path install-dir))
                  (raise (module-not-installed mod-path)))))))


  (let ((modref (##parse-module-ref module)))
    (if (macro-modref? modref)
        (let ((install-dir (path-expand dir)))
          (if (pair? (macro-modref-host modref))
              (let ((mod-info (##search-module modref (list install-dir))))
                (if mod-info
                    (let ((mod-info-dir  (vector-ref mod-info 0))
                          (mod-info-port (vector-ref mod-info 4)))
                      (close-input-port mod-info-port)
                      (uninstall-modref modref install-dir))
                    (raise (module-not-installed module))))
              (uninstall-modref modref install-dir)))
        (raise (invalid-module-name)))))

;; Return #f if module is not hosted
(define (uninstall module
                   #!optional
                   (t (macro-absent-obj)))

  (macro-force-vars (module t)
    (let ((to (if (or (eq? t (macro-absent-obj))
                      (eq? t #f))
                  (default-installation-directory)
                  t)))
      (macro-check-string
        module
        1
        (uninstall module t)
        (macro-check-string
          to
          2
          (uninstall module t)
          (uninstall-aux module to))))))

(define (installed? module #!optional (dir #f))
  (let ((modref (##parse-module-ref module)))
    (let ((result (##search-module modref dir)))
      (and (vector? result)
           (let ((port (vector-ref result 4)))
             (close-input-port port)
             #t)))))

(define (update-modref modref dir raise-exn)
  (define (string-contain? str pat)
    (and (< (string-length pat) (string-length str) )
         (let ((len (- (string-length str)
                       (string-length pat))))
           (let loop ((i-str 0) (i-pat 0))
             (or (and (= i-pat (string-length pat)) (- i-str (string-length pat)))
                 (and (< i-str len)
                      (if (char=? (string-ref str i-str)
                                  (string-ref pat i-pat))
                          (loop (+ i-str 1) (+ i-pat 1))
                          (loop (+ i-str 1) 0))))))))

  (if (macro-modref? modref)
      (let* ((cache-modref
               (macro-make-modref
                 (macro-modref-host modref)
                 #f
                 (macro-modref-rpath modref)))
             (mod-info (##search-module cache-modref (##list dir))))
        (if (not mod-info)
            (if raise-exn
                (raise (module-not-found (##modref->string modref)))
                #f)
            (let* ((mod-info-root (vector-ref mod-info 0))
                   (repo (git-repository-open mod-info-root)))
              (close-input-port (##vector-ref mod-info 4))

              (and (git-pull repo)
                   (for-each
                     (lambda (build-dir)
                       (let ((full-path (path-expand build-dir mod-info-root)))
                         (if (and (eq? (file-info-type (file-info full-path)) 'directory)
                                  (string-contain? build-dir "@gambit"))
                             (delete-file-or-directory full-path #t))))
                     (directory-files mod-info-root))))))
      (if raise-exn
          (raise (invalid-module-name))
          #f)))

(define (update-aux mod dir)
  (let ((modref (##parse-module-ref mod)))
    (update-modref modref dir)))

;; git-pull and remove *@gambit...
(define (update mod
                #!optional
                (t (macro-absent-obj)))
  (macro-force-vars (mod t)
    (let ((to (if (or (eq? t (macro-absent-obj))
                      (eq? t #f))
                (default-installation-directory)
                t)))

      (macro-check-string
        mod
        1
        (update mod t)
        (macro-check-string
          to
          2
          (update mod t)
          (update-aux mod to))))))

(define (gsi-option-update args)

  (define (usage)
    (##repl (lambda (first port)
              (##write-string "Usage: gsi -update [-dir dir] module ..." port)
              (##newline port)
              #t)))

  (if (null? args)
      (usage)
      (let loop ((rest (cdr args))
                 (arg (car args))
                 (to (default-installation-directory)))
        (cond
         ((string=? arg "-dir")
          (if (or (null? rest) (null? (cdr rest)))
              (usage)
              (loop (cddr rest) (cadr rest) (car rest))))
         (else
          (##repl (lambda (first port)
                    (##write-string "updating " port)
                    (##write-string arg port)
                    (##write-string " in " port)
                    (##write-string to port)
                    (##newline port)
                    #t))
          (with-exception-catcher
            (lambda (exn)
              (cond
                ((macro-pkg-exception? exn)
                 (##repl (lambda (first port)
                           (##write-string "*** UPDATE ERROR -- " port)
                           (##write-string (macro-pkg-exception-message exn) port)
                           (##newline port)
                           #t)))
                (else
                  (raise exn))))
            (lambda ()
              (update arg (path-expand to))))

          (if (pair? rest)
              (loop (cdr rest) (car rest) to)))))))

(define (gsi-option-install args)

  (define (usage)
    (##repl (lambda (first port)
              (##write-string "Usage: gsi -install [-dir dir] module ..." port)
              (##newline port)
              #t)))

  (if (null? args)
      (usage)
      (let loop ((rest (cdr args))
                 (arg (car args))
                 (to (default-installation-directory)))
        (cond
         ((string=? arg "-dir")
          (if (or (null? rest) (null? (cdr rest)))
              (usage)
              (loop (cddr rest) (cadr rest) (car rest))))

         ((##parse-module-ref arg)
          => (lambda (modref)
               (##repl (lambda (first port)
                       (##write-string "installing " port)
                       (##write-string arg port)
                       (##write-string " to " port)
                       (##write-string to port)
                       (##newline port)
                       #t))
               (with-exception-catcher
                 (lambda (exn)
                   (cond
                     ((macro-pkg-exception? exn)
                      (##repl (lambda (first port)
                                (##write-string "*** INSTALLATION ERROR -- " port)
                                (##write-string (macro-pkg-exception-message exn) port)
                                (##newline port)
                                #t)))
                     (else
                      (raise exn))))
                 (lambda ()
                   (install-modref modref (path-expand to) #f module-default-proto #t)))

               (if (pair? rest)
                 (loop (cdr rest) (car rest) to))))

         (else
           (usage))))))

(define (gsi-option-uninstall args)
  (define (usage)
    (##repl
     (lambda (first port)
       (##write-string "Usage: gsi -uninstall [-dir dir] module ..." port)
       (##newline port)
       #t)))

  (if (null? args)
    (usage)
    (let loop ((rest (cdr args))
               (arg (car args))
               (to (default-installation-directory)))
      (cond ((string=? arg "-dir")
             (if (or (null? rest) (null? (cdr rest)))
                 (usage)
                 (loop (cddr rest) (cadr rest) (car rest))))
            (else
             (##repl (lambda (first port)
                       (##write-string "uninstalling " port)
                       (##write-string arg port)
                       (##write-string " from " port)
                       (##write-string to port)
                       (##newline port)
                       #t))
             (with-exception-handler
               (lambda (exn)
                 (cond
                   ((macro-pkg-exception? exn)
                    (##repl (lambda (first port)
                              (##write-string "UNINSTALLATION ERROR -- " port)
                              (##write-string (macro-pkg-exception-message exn) port)
                              (##newline port)
                              #t)))
                   (else
                     (raise exn))))

               (lambda ()
                 (uninstall arg (path-expand to))
                 (if (pair? rest)
                     (loop (cdr rest) (car rest) to)))))))))

;;;============================================================================
