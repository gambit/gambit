;;;============================================================================

;;; File: "script.scm"

;;; Copyright (c) 2011 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("script#"))

(##include "~~lib/gambit#.scm")
(##include "~~lib/_gambit#.scm")

(##include "script#.scm")
(##include "intf#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (fixnum)
  (not safe)
)

;;;============================================================================

;; Script database operations.

(define predefined-scripts '(

("fact100" .
#<<EOF
;;; fact100

;; Compute factorial of 100.

(define (fact n)
  (if (< n 2)
      1
      (* n (fact (- n 1)))))

(repl-eval "(fact 100)\n")
EOF
)

("fib25" .
#<<EOF
;;; fib25

;; Compute fibonacci of 25.

(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

(repl-eval "(time (fib 25))\n")
EOF
)

("F11" .
#<<EOF
;;; F11

;; Visit Gambit wiki.

(open-URL
 "http://www.iro.umontreal.ca/~gambit")
EOF
)

("main" .
#<<EOF
;;; main

;; Start app with splash screen.

(splash)
EOF
)

))

(define script-db #f)
(define script-db-version "1.0")

(define (reset-scripts)
  (set! script-db predefined-scripts)
  (save-script-db))

(define (get-script-by-name name)
  (let* ((scripts (get-script-db))
         (x (assoc name scripts)))
    (and x (cdr x))))

(define (get-script-index-by-name name)
  (let loop ((scripts (get-script-db)) (i 0))
    (if (pair? scripts)
        (let ((x (car scripts)))
          (if (equal? (car x) name)
              i
              (loop (cdr scripts) (+ i 1))))
        #f)))

(define (get-script-at-index index)
  (let loop ((scripts (get-script-db)) (i 0))
    (if (pair? scripts)
        (if (= i index)
            (car scripts)
            (loop (cdr scripts) (+ i 1)))
        #f)))

(define (get-script-db)
  (if (not script-db)
      (set! script-db
            (let ((x (get-pref "script-db")))
              (if x
                  (let ((lst (with-input-from-string x read)))
                    (if (pair? lst)
                        (let ((version (car lst))
                              (db (cdr lst)))
                          (cond ((equal? version script-db-version)
                                 db)
                                (else
                                 predefined-scripts)))
                        predefined-scripts))
                  predefined-scripts))))
  script-db)

(define (new-script)
  (add-script "" ""))

(define (add-script name script)
  (set! script-db (cons (cons name script) (get-script-db)))
  (save-script-db))

(define (save-script-db)
  (if script-db
      (set-pref "script-db"
                (with-output-to-string
                  ""
                  (lambda ()
                    (write (cons script-db-version script-db)))))))

(define (load-script name script)
  (let ((port (open-input-string script)))

    (if (not (equal? name ""))
        ;; Hack... set the names of the port to match the name
        (##vector-set! port 4 (lambda (port) name)))

    (let ((x
           (##read-all-as-a-begin-expr-from-port
            port
            (##current-readtable)
            ##wrap-datum
            ##unwrap-datum
            #f ;; Scheme syntax
            #t)))
      (if (not (##fixnum? x))
          (##eval-module (##vector-ref x 1) ##interaction-cte)))))

(define (run-script name script)
  (##thread-interrupt!
   (macro-primordial-thread)
   (lambda ()
     (##repl-channel-release-ownership!) ;; to prevent deadlock...
     (with-exception-handler
      ##primordial-exception-handler
      (lambda ()
        (load-script name script)))
     (##void))))


;;;============================================================================
