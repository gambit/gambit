#! /usr/bin/env gsi

;;;============================================================================

;;; File: "runtests.scm"

;;; Copyright (c) 2012-2015 by Marc Feeley, All Rights Reserved.

;;;----------------------------------------------------------------------------

(define cleanup? #t)

(define nb-good 0)
(define nb-fail 0)
(define nb-other 0)
(define nb-total 0)
(define start 0)

(define (num->string num w d) ; w = total width, d = decimals
  (let ((n (floor (inexact->exact (round (* (abs num) (expt 10 d)))))))
    (let ((i (quotient n (expt 10 d)))
          (f (modulo n (expt 10 d))))
      (let ((si (string-append
                  (if (< num 0) "-" "")
                  (if (and (= i 0) (> d 0)) "" (number->string i 10))))
            (sf (number->string (+ f (expt 10 d)) 10)))
        (if (> d 0)
          (string-set! sf 0 #\.)
          (set! sf ""))
        (let ((lsi (string-length si))
              (lsf (string-length sf)))
          (let ((blanks (- w (+ lsi lsf))))
            (string-append (make-string (max blanks 0) #\space) si sf)))))))

(define (show-bar nb-good nb-fail nb-other nb-total elapsed)

  (define (ratio n)
    (quotient (* n (+ nb-good nb-fail nb-other)) nb-total))

  (let* ((bar-width 42)
         (bar-length (ratio bar-width)))
    (print "\r"
           "["
           "\33[32;1m" (num->string nb-good 4 0) "\33[0m"
           "|"
           "\33[31;1m" (num->string nb-fail 4 0) "\33[0m"
           "|"
           "\33[34;1m" (num->string nb-other 4 0) "\33[0m"
           "] "
           (num->string (ratio 100) 3 0)
           "% "
           (make-string bar-length #\#)
           (make-string (- bar-width bar-length) #\.)
           (num->string elapsed 6 1)
           "s"
           "\33[K")))

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

  (let ((results (test-with-each-target file))
        (diff? #f))

    (for-each
     (lambda (x)
       (let ((target (car x))
             (result (cdr x)))

         ;;(pp result)
         ;;(pp (cdar results))

         (if (not (equal? result (cdar results)))
             (begin
               (if (not diff?)
                   (begin
                     (print "\n")
                     (print "*********************** FAILED TEST " file "\n")
                     (print "======================= EXPECTED:\n" (cdr (cdar results)))))
               (set! diff? #t)
               (print "======================= ")
               (write (cons (car target) (caddr target)))
               (print ":\n")
               (print (cdr result))
               #;(print (diff (car target) (cdr (cdar results)) (cdr result)))
               ))))
     (cdr results))

    (if diff?
        (set! nb-fail (+ nb-fail 1))
        (set! nb-good (+ nb-good 1)))

    (show-bar nb-good
              nb-fail
              nb-other
              nb-total
              (- (time->seconds (current-time)) start))))

(define (runtests files)

  (set! nb-good 0)
  (set! nb-fail 0)
  (set! nb-other 0)
  (set! nb-total (length files))
  (set! start (time->seconds (current-time)))

  (for-each test files)

  (print "\n")

  (if (= nb-good nb-total)
      (begin
        (print "PASSED ALL\n")
        (exit 0))
      (begin
        (print "FAILED " nb-fail " OUT OF " nb-total " (" (num->string (* 100. (/ nb-fail nb-total)) 0 1) "%)\n")
        (exit 1))))

(define (diff target-name target-output expected-output)
  (with-output-to-file "expected" (lambda () (print expected-output)))
  (with-output-to-file target-name (lambda () (print target-output)))
  (let ((d (run "diff" "-u" target-name "expected")))
    (delete-file target-name)
    (delete-file "expected")
    (cdr d)))

(define (test-with-each-target file)
  (map (lambda (t)
         (let ((target (car t))
               (ext (cadr t)))
           (cons t
                 (if ext
                     (let* ((file-no-ext (path-strip-extension file))
                            (out (string-append file-no-ext ext)))

                       (if (not (equal? target "gambit"))
                           (compile file target (caddr t)))

                       (let ((result
                              (if (equal? target "java")
                                  (begin
                                    (run "javac" out)
                                    (apply run
                                           (append (cdddr t)
                                                   (list "-classpath"
                                                         (path-directory file-no-ext)
                                                         (string-append "Gambit_" (path-strip-directory file-no-ext))))))
                                  (apply run (append (cdddr t) (list out))))))

                         (if (not (equal? target "gambit"))
                             (if cleanup?
                                 (begin
                                   (delete-file out)
                                   (if (equal? target "java")
                                       (parameterize ((current-directory
                                                       (path-directory out)))
                                         (shell-command "rm Gambit_*.class"))))))

                         result))

                     (apply run (append (cdddr t) (list file)))))))
       (keep (lambda (t)
               (member (car t) (cons "c" back-ends)))
             targets)))

(define (compile file target options)
  (let ((x
         (if (equal? target "c")
             (run "./gsc" "-:=.."                      file)
             (apply run
                    (append (list "./gsc" "-:=.." "-c" "-target" target)
                            options
                            (list file))))))
    (if (not (= (car x) 0))
        (error "couldn't compile" file target))))

(define targets
  '(
    ("gambit" ".scm"  ()
                      "./gsc" "-i")

    ("c"      ".o1"   ()
                      "./gsc" "-i")

    ("x86"    #f      ()
                      "./gsc32" "-:=.." "-target" "nat" "-c" "-e" "(load \"_t-x86.scm\")")

    ("x86-64" #f      ()
                      "./gsc64" "-:=.." "-target" "nat" "-c" "-e" "(load \"_t-x86.scm\")")

    ("java"   ".java" ()
                      "java")

    #;
    ("js"     ".js"   ()
                      "d8")

    ("js"     ".js"   ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "d8")
    ("js"     ".js"   ("-repr-module"    "class"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "d8")
    ("js"     ".js"   ("-repr-module"    "globals"
                       "-repr-procedure" "class"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "d8")
    ("js"     ".js"   ("-repr-module"    "class"
                       "-repr-procedure" "class"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "d8")
    ("js"     ".js"   ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "class"
                      )
                      "d8")
    ("js"     ".js"   ("-repr-module"    "class"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "class"
                      )
                      "d8")
    ("js"     ".js"   ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "host"
                      )
                      "d8")
    ("js"     ".js"   ("-repr-module"    "class"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "host"
                      )
                      "d8")

    #;
    ("python" ".py"   ()
                      "python")
    ("python" ".py"   ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "python")
    ("python" ".py"   ("-repr-module"    "globals"
                       "-repr-procedure" "class"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "python")
    ("python" ".py"   ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "class"
                      )
                      "python")
    ("python" ".py"   ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "host"
                      )
                      "python")

    ("python" ".py"   ("-python3"
                       "-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "python3")
    ("python" ".py"   ("-python3"
                       "-repr-module"    "globals"
                       "-repr-procedure" "class"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "python3")
    ("python" ".py"   ("-python3"
                       "-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "class"
                      )
                      "python3")
    ("python" ".py"   ("-python3"
                       "-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "host"
                      )
                      "python3")

#;
    ("ruby"   ".rb"   ()
                      "/usr/bin/ruby") ;; ruby 2.0.0p451
#;
    ("ruby"   ".rb"   ()
                      "/usr/local/Cellar/ruby/2.1.5/bin/ruby") ;; ruby 2.1.5
#;
    ("ruby"   ".rb"   ()
                      "/usr/local/bin/ruby") ;; ruby 1.9.3p392

    ("ruby"   ".rb"   ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "/usr/local/bin/ruby") ;; ruby 1.9.3p392
    ("ruby"   ".rb"   ("-repr-module"    "globals"
                       "-repr-procedure" "class"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "/usr/local/bin/ruby") ;; ruby 1.9.3p392
    ("ruby"   ".rb"   ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "class"
                      )
                      "/usr/local/bin/ruby") ;; ruby 1.9.3p392
    ("ruby"   ".rb"   ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "host"
                      )
                      "/usr/local/bin/ruby") ;; ruby 1.9.3p392

#;
    ("php"   ".php"   ("-php53")
                      "/usr/bin/php") ;; PHP 5.5.20
    ("php"    ".php"  ("-php53"
                       "-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "/usr/bin/php") ;; PHP 5.5.20
    ("php"    ".php"  ("-php53"
                       "-repr-module"    "globals"
                       "-repr-procedure" "class"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "/usr/bin/php") ;; PHP 5.5.20
    ("php"    ".php"  ("-php53"
                       "-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "class"
                      )
                      "/usr/bin/php") ;; PHP 5.5.20
    ("php"    ".php"  ("-php53"
                       "-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "host"
                      )
                      "/usr/bin/php") ;; PHP 5.5.20

#|
    ("php"    ".php"  ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "/Users/feeley/php5.2.17/bin/php")
    ("php"    ".php"  ("-repr-module"    "globals"
                       "-repr-procedure" "class"
                       "-repr-fixnum"    "host"
                       "-repr-flonum"    "class"
                      )
                      "/Users/feeley/php5.2.17/bin/php")
    ("php"    ".php"  ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "class"
                      )
                      "/Users/feeley/php5.2.17/bin/php")
    ("php"    ".php"  ("-repr-module"    "globals"
                       "-repr-procedure" "host"
                       "-repr-fixnum"    "class"
                       "-repr-flonum"    "host"
                      )
                      "/Users/feeley/php5.2.17/bin/php")
|#

#;
    ("dart"   ".dart" ()
                      "/Users/feeley/dart/dart-sdk/bin/dart")
   ))

(define (list-of-files-with-extension file-or-dir extension)
  (if (eq? (file-type file-or-dir) 'directory)

      (apply
       append
       (map
        (lambda (f)
          (list-of-files-with-extension (path-expand f file-or-dir) extension))
        (directory-files file-or-dir)))

      (if (equal? (path-extension file-or-dir) extension)
          (list file-or-dir)
          (list))))

(define (list-of-scm-files args)
  (apply
   append
   (map
    (lambda (f)
      (list-of-files-with-extension f ".scm"))
    args)))

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

  (runtests (list-of-scm-files args)))

;;;============================================================================
