#! /usr/bin/env gsi

;;;============================================================================

;;; File: "runtests.scm"

;;; Copyright (c) 2012 by Marc Feeley, All Rights Reserved.

;;;----------------------------------------------------------------------------

(define nb-tests 0)
(define failed-tests 0)

(define (run path . args)
  (let* ((port
          (open-process (list path: path
                              arguments: args
                              ;; stderr-redirection: #t
                              )))
         (output
          (read-line port #f))
         (status
          (process-status port)))
    (close-port port)
    (cons status output)))

(define (test file)

  (print "****************************************** " file)
  (force-output)

  (let ((results (test-with-each-target file))
        (diff? #f))

    (for-each
     (lambda (x)
       (let ((target (car x))
             (result (cdr x)))
         (if (not (equal? result (cdar results)))
             (begin
               (if (not diff?)
                   (print " (FAILED)\n======================= EXPECTED:\n" (cdr (cdar results))))
               (set! diff? #t)
               (print "======================= " (car target) ":\n" (cdr result))))))
     (cdr results))

    (set! nb-tests (+ nb-tests 1))

    (if diff?
        (set! failed-tests (+ failed-tests 1))
        (print " (OK)\n"))))

(define (test-with-each-target file)
  (map (lambda (t)
         (let ((target (car t))
               (ext (cadr t)))
           (cons t
                 (if ext
                     (let ((out (string-append (path-strip-extension file) ext)))
                       (if (not (equal? target "gambit"))
                           (compile file target))
                       (let ((result (apply run (append (cddr t) (list out)))))
                         (if (not (equal? target "gambit"))
                             (delete-file out))
                         result))
                     (apply run (append (cddr t) (list file)))))))
       (keep (lambda (t)
               (member (car t) (cons "gambit" back-ends)))
             targets)))

(define (compile file target)
  (let ((x
         (if (equal? target "c")
             (run "./gsc" "-:=.."                      file)
             (run "./gsc" "-:=.." "-c" "-target" target file))))
    (if (not (= (car x) 0))
        (error "couldn't compile" file target))))

(define targets
  '(
    ("gambit" ".scm" "./gsc" "-i")
    ("c"      ".o1"  "./gsc" "-i")
    ("nat"    #f     "./gsc" "-:=.." "-target" "nat" "-c" "-e" "(load \"_t-x86.scm\")")
    ("js"     ".js"  "d8")
    ("python" ".py"  "python")
    ("ruby"   ".rb"  "ruby")
   ))

(define (runtest-file file)
  (if (equal? (path-extension file) ".scm")
      (test file)))

(define (runtest-dir dir)
  (for-each
   (lambda (x)
     (runtest (path-expand x dir)))
   (directory-files dir)))

(define (runtest file-or-dir)
  (if (eq? (file-type file-or-dir) 'directory)
      (runtest-dir file-or-dir)
      (runtest-file file-or-dir)))

(define (keep keep? lst)
  (cond ((null? lst)       '())
        ((keep? (car lst)) (cons (car lst) (keep keep? (cdr lst))))
        (else              (keep keep? (cdr lst)))))

(define back-ends '())

(define (main . args)

  (let loop ()
    (if (and (pair? args)
             (> (string-length (car args)) 1)
             (char=? #\- (string-ref (car args) 0)))
        (begin
          (set! back-ends
                (cons (substring (car args) 1 (string-length (car args)))
                      back-ends))
          (set! args (cdr args))
          (loop))))

  (if (null? args)
      (set! args '("tests")))

  (if (null? back-ends)
      (set! back-ends (map car targets)))

  (for-each runtest args)

  (if (> failed-tests 0)
      (print failed-tests " failed tests out of " nb-tests " tests.\n")
      (print "all " nb-tests " tests passed.\n")))

;;;============================================================================
