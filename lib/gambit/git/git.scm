;;;============================================================================

;;; File: "gambit/git/git.scm"

;;; Copyright (c) 2019 by Frédéric Hamel, All Rights Reserved.
;;; Copyright (c) 2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Description:
;;; A module that wraps the git command utility.
;;; It exports the following functionalities:
;;;
;;;    git-archive
;;;    git-clone
;;;    git-command
;;;    git-pull
;;;    git-repository-open
;;;    git-status
;;;    git-tag
;;;
;;; The procedure git-command allows executing git commands that
;;; aren't implemented with exported procedures such as `git fetch`.

(##supply-module gambit/git)

(##namespace ("gambit/git#"))
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

(##include "git#.scm")

(implement-type-git-repository)

(define (git-repository-open path)
  (macro-force-vars (path)
    (macro-check-string
      path
      1
      (git-repository-open path)
      (and (file-exists? path)
           (eq? 'directory (file-info-type (file-info path)))
           ;;; Test if it contains .git
           (eq? 'directory (file-info-type (file-info (path-expand ".git" path))))
           (macro-make-git-repository (path-expand path))))))

(define (git-command-aux args proc repo interactive?)
  ;; TODO: Move this code to git-command instead
  (let ((directory (and (macro-git-repository? repo)
                        (macro-git-repository-path repo))))

  (##tty-mode-reset)

  (call-with-input-process
    (list path: "git"
          arguments: args
          directory: directory
          stdin-redirection: #f
          stdout-redirection: (not interactive?)
          stderr-redirection: (not interactive?)
          pseudo-terminal: interactive?
          environment: (and (not interactive?)
                            (cons "GIT_TERMINAL_PROMPT=0" (##os-environ))))
    proc)))

(define (git-command args proc #!optional (repo (macro-absent-obj)) (i? (macro-absent-obj)))
  (macro-force-vars (args proc repo i?)
    (let ((interactive? (if (eq? i? (macro-absent-obj))
                            #f
                            i?)))

      (let loop ((x args) (rev-args '()))
        (if (pair? x)
          (let ((arg (car x)))
            (macro-force-vars (arg)
                              (if (string? arg)
                                (let ((rest (cdr x)))
                                  (macro-force-vars (rest)
                                                    (loop rest (cons arg rev-args))))
                                (##fail-check-string-list 1 git-command args proc d i?))))
          (macro-check-procedure
            proc
            2
            (git-command args proc repo i?)
            (git-command-aux (reverse rev-args) proc repo interactive?)))))))

(define (git-archive repo ref)
  (and (macro-git-repository? repo)
       ;; Remove tags restriction.
       (git-command-aux (list "archive" ref)
                        (lambda (p)
                          (and (= (process-status p) 0)
                               (tar-unpack-port p)))
                        repo
                        #f)))

(define (git-clone url dir
                   #!optional
                   (cb (macro-absent-obj))
                   (i? (macro-absent-obj)))
  (macro-force-vars (url dir cb i?)
    (let ((proc (if (or (eq? cb (macro-absent-obj))
                        (eq? cb #f))
                    (lambda (port)
                      (and
                        (= (process-status port) 0)
                        (macro-make-git-repository
                          (path-expand dir))))
                    cb))
          (interactive? (if (eq? i? (macro-absent-obj))
                            #f
                            i?)))
      (macro-check-string
        url
        1
        (git-clone url dir cb i?)
        (macro-check-string
          dir
          2
          (git-clone url dir cb i?)
          (macro-check-procedure
            proc
            3
            (git-clone url dir cb i?)
            (and (not (file-exists? dir))
                 (git-command-aux (list "clone" url dir)
                                  proc
                                  #f                     ;; current directory
                                  interactive?))))))))   ;; interactive

;; Add remote
(define (git-pull repo
                  #!optional
                  (cb (macro-absent-obj))
                  (i? (macro-absent-obj)))
  (macro-force-vars (repo cb i?)
    (let ((proc (if (eq? cb (macro-absent-obj))
                    (lambda (port)
                      (= (process-status port) 0))
                    cb))
          (interactive? (if (eq? i? (macro-absent-obj))
                            #f
                            i?)))
      (macro-check-procedure
        proc
        2
        (git-pull repo cb i?)
        (and (macro-git-repository? repo)
             (git-command-aux
               (list "pull" "origin")
               proc
               repo
               interactive?))))))

(define (git-status repo
                    #!optional
                    (cb (macro-absent-obj))
                    (i? (macro-absent-obj)))
  (macro-force-vars (repo cb i?)
    (let ((proc (if (eq? cb (macro-absent-obj))
                    (lambda (port)
                      (= (process-status port) 0))
                    cb))
          (interactive? (if (eq? i? (macro-absent-obj))
                            #f
                            i?)))
      (macro-check-procedure
        proc
        2
        (git-status repo cb i?)
        (and (macro-git-repository? repo)
             (git-command-aux
               (list "status")
               proc
               repo
               interactive?))))))

(define (git-tag repo)
  (macro-force-vars (repo)
    (and (macro-git-repository? repo)
         (git-command-aux
           (list "tag")
           (lambda (p)
             (let loop ((tags-rev '()))
               (let ((current-tag (read-line p)))
                 (if (eof-object? current-tag)
                   tags-rev
                   (loop (cons current-tag tags-rev))))))
           ;; Repository
           repo
           ;; Not interractive
           #f))))

;;;============================================================================
