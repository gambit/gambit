;;;============================================================================

;;; File: "repo.scm"

;;; Copyright (c) 2011-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("repo#"))

(##include "~~lib/gambit#.scm")

(##include "repo#.scm")
(##include "intf#.scm")

(declare
 (standard-bindings)
 (extended-bindings)
 (block)
 (fixnum)
 ;;(not safe)
)


;;;============================================================================

;; Login info.

(define predefined-login-info '("" "" #t))

(define login-info #f)
(define login-info-version "1.0")

(define (reset-login-info)
  (let ((info (get-login-info)))
    (set-login-info "" "" (caddr info))
    (save-login-info)))

(define (set-login-info username password remember-pass?)
  (set! login-info
        (list username
              (if remember-pass? password "")
              remember-pass?)))

(define (get-login-info)
  (if (not login-info)
      (set! login-info
            (let ((x (get-pref "login-info")))
              (if x
                  (let ((lst (with-input-from-string x read)))
                    (if (pair? lst)
                        (let ((version (car lst))
                              (info (cdr lst)))
                          (cond ((equal? version login-info-version)
                                 info)
                                (else
                                 predefined-login-info)))
                        predefined-login-info))
                  predefined-login-info))))
  login-info)

(define (save-login-info)
  (if login-info
      (set-pref "login-info"
                (with-output-to-string
                  ""
                  (lambda ()
                    (write (cons login-info-version login-info)))))))


;;;============================================================================
