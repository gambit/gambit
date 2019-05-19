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
;;;    debug-mode?
;;;    debug-mode?-set!
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

(declare
  (not safe)
  (extended-bindings))

(##namespace ("gambit/pkg#"))
(##include "~~lib/gambit#.scm")
(##include "~~lib/_module#.scm")

(##supply-module gambit/pkg)

(##namespace ("##"
              <
              car
              cdr
              cadr
              cddr
              close-input-port
              cons
              create-directory
              delete-file-or-directory
              eof-object?
              eq?
              for-each
              list
              not
              null?
              pair?
              path-expand
              path-directory
              path-strip-trailing-directory-separator
              read
              string-append
              string-length
              string=?
              vector-ref
              vector?))

(##import gambit/git)
(##import gambit/tar)

(define-macro (tree-master) "tree/master")

(define-macro (file-exists? x)
  `(##file-exists? ,x #f))

(define-macro (println . args)
  (if (null? args)
    `(##newline (##current-output-port))
    `(begin
      ,(if (null? (cdr args))
         `(##display ,(car args) (##current-output-port))
         `(##for-each
           (lambda (e)
             (##display e (##current-output-port)))
           ,args))
       (##newline (##current-output-port)))))


(define (module-path to)
  (path-expand
   (or to "~~userlib")))

;; Protocols
(define (https-proto mod)
  (string-append "https://" mod))

(define (ssh-proto mod)
  (string-append "ssh://git@" mod))

(define module-default-proto https-proto)

(define (module-default-proto-set! proto)
  (set! module-default-proto proto))

;; Debug mode
(define debug-mode? #f)
(define (debug-mode?-set! x)
  (set! debug-mode? x))

;; Installation function
(define (install mod #!optional (to #f) (prompt? #f) (proto #f))

  (define (join-rev path lst)
    (if (pair? lst)
        (join-rev
         (path-expand path (car lst))
         (cdr lst))
        path))

  (let ((modref (##string->modref mod)))
    (and modref
         (pair? (macro-modref-host modref))
         (let* ((repo-path
                 (module-path to))

                (module-name
                 (let loop ((path (macro-modref-path modref)))
                   (if (pair? (cdr path))
                       (loop (cdr path))
                       (car path))))

                ;; null? if no tag specify
                (tag
                 (macro-modref-tag modref))

                ;; url without the protocol
                (base-url
                 (join-rev module-name
                           (macro-modref-host modref)))

                ;; url used to clone the repo.
                (url
                 ((or proto module-default-proto) base-url))

                (archive-path
                 (path-expand base-url repo-path))

                (supplied-version?
                 (pair? tag))

                ;; Path on the file system where to clone
                (clone-path
                 (path-expand (tree-master) archive-path))

                (install-path
                 (and supplied-version?
                      (let ((version (join-rev (car tag) (cdr tag))))
                        (and (not (string=? (tree-master) version))
                             (path-expand version archive-path))))))

           (if install-path
               (and (not (file-exists? install-path))
                    (let ((repo (or (git-clone url clone-path)
                                    (git-repository-open clone-path))))
                      (and repo
                           (let ((tar-rec-list (git-archive repo (car tag))))
                             (create-directory install-path)
                             (tar-rec-list-write tar-rec-list install-path)))))

               (git-clone url clone-path))))))


;; Return #f if module is not hosted
(define (uninstall module #!optional (to #f))

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

  (let ((modref (##string->modref module)))
    (and modref
         (pair? (macro-modref-host modref))
         (let ((prefix (start-width? module (module-path to))))
           (and prefix
                (let loop ((modref-path (macro-modref-path modref)))
                  (if (pair? (cdr modref-path))
                      (loop (cdr modref-path))
                      (macro-modref-path-set! modref modref-path)))
                (let ((mod-path (##modref->string modref)))
                  (and
                    (delete-file-or-directory
                      (path-expand mod-path prefix) #t)
                    (cleanup-install-folder
                      (path-strip-trailing-directory-separator
                        (path-directory mod-path)) prefix))))))))

(define (installed? module)
  (let ((modref (##string->modref module)))

    (and (pair? (macro-modref-host modref))
         (null? (macro-modref-tag modref))
         (macro-modref-tag-set! modref (list (tree-master))))

    (let ((result (##search-module modref)))
      (and (vector? result)
           (let ((port (vector-ref result 4)))
             (close-input-port port)
             #t)))))

(define (update mod #!optional (to #f))
  (let ((modref (##string->modref mod)))
    (and (pair? (macro-modref-host modref))
         (null? (macro-modref-tag modref))
         (let ()
           (macro-modref-tag-set! modref (list (tree-master)))
           (let ((module-master-path (##modref->string modref)))
             (let ((repo (git-repository-open
                          (path-expand module-master-path
                                       (module-path to)))))
               (and repo (git-pull repo))))))))

(define (install-hook modref)
  (let ((mod-name (##modref->string modref)))
    (let ((result (install mod-name #f #t)))
      (if debug-mode?
          (println "install-hook==>" result))
      (and result (##search-module modref)))))

(##install-module-set! install-hook)

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
          (or (update arg to)
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
                 (to (path-expand "~~userlib")))
        (cond
         ((string=? arg "-to")
          (if (or (null? rest) (null? (cdr rest)))
              (usage)
              (loop (cddr rest) (cadr rest) (car rest))))
         (else
          (println (string-append "install " arg " to " to))
          (or (install arg to)
              (println (string-append "Unable to install '" arg "' to '" to "'\n")))
          (if (pair? rest)
              (loop (cdr rest) (car rest) to)))))))

(define (gsi-option-uninstall args)
  (define (usage)
    (println "Usage: gsi -uninstall [-to dir] module ..."))

  (if (null? args)
    (usage)
    (let loop ((rest (cdr args))
               (arg (car args))
               (to (path-expand "~~userlib")))
      (cond ((string=? arg "-to")
             (if (or (null? rest) (null? (cdr rest)))
                 (usage)
                 (loop (cddr rest) (cadr rest) (car rest))))
            (else
             (println (string-append "uninstall " arg " to " to))
             (or (uninstall arg to)
                 (println (string-append "Unable to uninstall '" arg "' to " to)))
             (if (pair? rest)
                 (loop (cdr rest) (car rest) to)))))))

;;;============================================================================
