;;;============================================================================

;;; File: "gambit/pkg/pkg.scm"

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

(##supply-module gambit/pkg)

(##namespace ("gambit/pkg#"))
(##include "~~lib/_prim#.scm")
(##include "~~lib/_gambit#.scm")
(##include "~~lib/_module#.scm")

(##import gambit/git)
(##import gambit/tar)

(declare
  (block)
  (not safe)
  (extended-bindings))

;;;----------------------------------------------------------------------------

(##include "pkg#.scm")

(define-macro (tree-master) "tree/master")

(define-macro (default-install-prefix)
  (path-expand "~~userlib"))

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

;; Installation function
(define (install mod
                 #!optional
                 (to (macro-absent-obj))
                 (p? (macro-absent-obj))
                 (p (macro-absent-obj)))

  (define (join-rev path lst)
    (if (pair? lst)
        (join-rev
         (path-expand path (car lst))
         (cdr lst))
        path))

  (define (last lst)
    (if (pair? (cdr lst))
        (last (cdr lst))
        (car lst)))

  (define (check-status process)
    (eq? (process-status process) 0))

  ;; XXX: Variable names are bad
  (macro-force-vars (mod to p? p)
    (let ((repo-path (if (or (eq? to (macro-absent-obj))
                             (eq? to #f))
                         (default-install-prefix)
                         to))
          (prompt? (if (eq? p? (macro-absent-obj))
                       #f
                       p?))
          (proto (if (eq? p (macro-absent-obj))
                     module-default-proto
                     p)))

    (macro-check-string
      mod
      1
      (install mod to p? p)
      (macro-check-string
        repo-path
        2
        (install mod to p? p)
        (macro-check-procedure
          proto
          4
          (install mod to p? p)
          (let ((modref (##parse-module-ref mod)))
            (and modref
                 (pair? (macro-modref-host modref))
                 (let* ((host (macro-modref-host modref))
                        (tag (macro-modref-tag modref))
                        (rpath (macro-modref-rpath modref))

                        (module-name (last rpath))

                        ;; url without the protocol
                        (base-url (join-rev module-name host))

                        ;; url used to clone the repo.
                        (url (proto base-url))

                        ;; Path on the file system where to clone
                        (clone-path
                          (join-rev
                            "@"
                            (list base-url repo-path)))

                        (install-path (path-expand (##modref->path modref #f) repo-path)))

                   (if (string=? install-path clone-path)
                       (git-clone url clone-path check-status prompt?)
                       (and (not (file-exists? install-path))
                            (let ((repo (or (git-clone url clone-path #f prompt?)
                                            (git-repository-open clone-path))))
                              (and repo ;; (git-repository? repo)
                                   (let ((tar-rec-list (or (git-archive repo tag)
                                                           (and (git-pull repo)
                                                                (git-archive repo tag))))
                                         (tmp-dir (create-temporary-directory install-path)))
                                     (with-exception-handler
                                       (lambda (_)
                                         (delete-file-or-directory tmp-dir #t)
                                         #f)
                                       (lambda ()
                                         (tar-rec-list-write tar-rec-list tmp-dir)
                                         (rename-file tmp-dir install-path)))))))))))))))))


;; Return #f if module is not hosted
(define (uninstall module
                   #!optional
                   (t (macro-absent-obj)))

  ;; return the prefix if prefix/folder exists else #f.
  (define (start-width? folder prefix)
    (and (file-exists? (path-expand folder prefix)) prefix))

  (define (cleanup-install-folder folder prefix)
    (if (< 0 (string-length folder))
      (let ((folder-name (path-expand folder prefix)))
        (##delete-file-or-directory folder-name #f #f)
        (cleanup-install-folder
          (path-strip-trailing-directory-separator
            (path-directory folder)) prefix)
        #t)))

  (macro-force-vars (module t)
    (let ((to (if (or (eq? t (macro-absent-obj))
                      (eq? t #f))
                  (default-install-prefix)
                  t)))
      (macro-check-string
        module
        1
        (uninstall module t)
        (macro-check-string
          to
          2
          (uninstall module t)
          (let ((modref (##parse-module-ref module)))
            (and modref
                 (pair? (macro-modref-host modref))
                 (let* ((mod-path (##modref->path modref #f))
                        (full-path (path-expand mod-path to)))
                   (display full-path) (newline)
                   (and (file-exists? full-path)
                        (delete-file-or-directory
                          (path-expand full-path) #t)
                        (cleanup-install-folder
                          (path-strip-trailing-directory-separator
                            (path-directory mod-path)) to))))))))))

(define (installed? module)
  (let ((modref (##parse-module-ref module)))
    (let ((result (##search-module modref)))
      (and (vector? result)
           (let ((port (vector-ref result 4)))
             (close-input-port port)
             #t)))))

(define (update mod
                #!optional
                (t (macro-absent-obj)))
  (macro-force-vars (mod t)
    (let ((to (if (or (eq? t (macro-absent-obj))
                      (eq? t #f))
                (default-install-prefix)
                t)))

      (macro-check-string
        mod
        1
        (update mod t)
        (macro-check-string
          to
          2
          (update mod t)
          (let ((modref (##parse-module-ref mod)))
            (and (pair? (macro-modref-host modref))
                 (not (macro-modref-tag modref))
                 (let ()
                   (let ((module-master-path (##modref->path modref #f)))
                     (let ((repo (git-repository-open
                                  (path-expand module-master-path to))))
                       (and repo (git-pull repo))))))))))))

(define (gsi-option-update args)

  (define (usage)
    (println "Usage: gsi -update [-to dir] module ..."))

  (if (null? args)
      (usage)
      (let loop ((rest (cdr args))
                 (arg (car args))
                 (to (path-expand "~~userlib")))
        (cond
         ((string=? arg "-to")
          (if (or (null? rest) (null? (cdr rest)))
              (usage)
              (loop (cddr rest) (cadr rest) (car rest))))
         (else
          (println (string-append "update " arg " to " to))
          (or (update arg (path-expand to))
              (println (string-append "Unable to update '" arg "' to '" to "'\n")))
          (if (pair? rest)
              (loop (cdr rest) (car rest) to)))))))

(define (gsi-option-install args)

  (define (usage)
    (println "Usage: gsi -install [-to dir] module ..."))

  (if (null? args)
      (usage)
      (let loop ((rest (cdr args))
                 (arg (car args))
                 (to "~~userlib"))
        (cond
         ((string=? arg "-to")
          (if (or (null? rest) (null? (cdr rest)))
              (usage)
              (loop (cddr rest) (cadr rest) (car rest))))
         (else
          (println (string-append "install " arg " to " to))
          (or (install arg (path-expand to))
              (println (string-append "Unable to install '" arg "' to " to)))
          (if (pair? rest)
              (loop (cdr rest) (car rest) to)))))))

(define (gsi-option-uninstall args)
  (define (usage)
    (println "Usage: gsi -uninstall [-to dir] module ..."))

  (if (null? args)
    (usage)
    (let loop ((rest (cdr args))
               (arg (car args))
               (to "~~userlib"))
      (cond ((string=? arg "-to")
             (if (or (null? rest) (null? (cdr rest)))
                 (usage)
                 (loop (cddr rest) (cadr rest) (car rest))))
            (else
             (println (string-append "uninstall " arg " to " to))
             (or (uninstall arg (path-expand to))
                 (println (string-append "Unable to uninstall '" arg "' to " to)))
             (if (pair? rest)
                 (loop (cdr rest) (car rest) to)))))))

;;;============================================================================
