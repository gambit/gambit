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

(declare
  (not safe)
  (extended-bindings))

(namespace ("gambit/git#"))
(##include "~~lib/gambit#.scm")
(##include "~~lib/_module#.scm")

(##import gambit/git)
(##import gambit/tar)

(##supply-module gambit/git)

;;; XXX: may be unstable because of this namespace declaration
(##namespace ("##"
              ;; call-with-input-process
              cons
              eof-object?
              file-exists?
              list
              member
              newline
              not
              print
              ;; println
              process-status
              ;; read-line
              string-append
              =))

(define-macro (call-with-input-process path-or-settings proc)
  `((lambda (port)
      (let ((results (,proc port)))
        (##close-port port)
        (##process-status port)
        results))
    (open-input-process ,path-or-settings)))

(implement-type-git-repository)

(define (git-repository-open path)
  (and (file-exists? path)
       (macro-make-git-repository path)))

(define (git-command args proc directory #!optional (prompt? #f))

  (##tty-mode-reset)

  (call-with-input-process
   (list path: "git"
         arguments: args
         directory: directory
         environment: (and (not prompt?)
                           (cons "GIT_TERMINAL_PROMPT=0" (##os-environ))))
   proc))

(define (git-archive repo ref)
  (and (macro-git-repository? repo)
       (let ((tags (git-tag repo)))
         (and (member ref tags)
              (git-command (list "archive" ref)
                           (lambda (p)
                             (tar-unpack-port p))
                           (macro-git-repository-path repo))))))

(define (git-clone url dir #!optional prompt?)
  (and (not (file-exists? dir))
       (git-command (list "clone" url dir)
                    (lambda (p)
                      (let ((line (read-line p)))
                        ;; XXX: add quiet?
                        (if (not (eof-object? line))
                            (println line)))
                      (= (process-status p) 0))
                    #f
                    prompt?)
       (macro-make-git-repository dir)))


;; Add remote
(define (git-pull repo)
  (and (macro-git-repository? repo)
       (git-command
        (list "pull" "origin")
        (lambda (p)
          (let loop ()
            (let ((line (read-line p)))
              (cond
               ((not (eof-object? line))
                (println line)
                (loop))
               (else (= (process-status p) 0))))))
        (macro-git-repository-path repo))))

(define (git-status repo)
  (and (macro-git-repository? repo)
       (git-command
        (list "status")
        (lambda (p)
          (let loop ()
            (let ((line (read-line p)))
              (cond
               ((not (eof-object? line))
                (println line)
                (loop))))))
        (macro-git-repository-path repo))))

(define (git-tag repo)
  (and (macro-git-repository? repo)
       (git-command
        (list "tag")
        (lambda (p)
          (let loop ((tags-rev '()))
            (let ((current-tag (read-line p)))
              (if (eof-object? current-tag)
                  tags-rev
                  (loop (cons current-tag tags-rev))))))

        ;; Directory
        (macro-git-repository-path repo))))

;;;============================================================================
