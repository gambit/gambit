#! /usr/bin/env ../gsi/gsi

;;;============================================================================

;;; File: "run-unit-tests.scm"

;;; Copyright (c) 2012-2021 by Marc Feeley, All Rights Reserved.

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

(define (sort-list lst <?)

  (define (mergesort lst)

    (define (merge lst1 lst2)
      (cond ((null? lst1) lst2)
            ((null? lst2) lst1)
            (else
             (let ((e1 (car lst1)) (e2 (car lst2)))
               (if (<? e1 e2)
                 (cons e1 (merge (cdr lst1) lst2))
                 (cons e2 (merge lst1 (cdr lst2))))))))

    (define (split lst)
      (if (or (null? lst) (null? (cdr lst)))
        lst
        (cons (car lst) (split (cddr lst)))))

    (if (or (null? lst) (null? (cdr lst)))
      lst
      (let* ((lst1 (mergesort (split lst)))
             (lst2 (mergesort (split (cdr lst)))))
        (merge lst1 lst2))))

  (mergesort lst))

(define utf-8
  (equal? ".utf-8"
          (string-downcase
           (path-extension
            (string-append "." (getenv "LANG" ""))))))

(define (show-bar nb-good nb-fail nb-other nb-total elapsed)

  (define (ratio n)
    (quotient (* n (+ nb-good nb-fail nb-other)) nb-total))

  (let* ((istty (tty? (current-output-port)))
         (bar-width 16)
         (unicode? (and istty utf-8)))

    (define (esc x)
      (if istty x ""))

    (define (bar)
      (if unicode?
          (let* ((len (ratio (- (* bar-width 8) 1)))
                 (full (quotient len 8))
                 (mod (modulo len 8))
                 (rest (- bar-width full 1)))
            (string-append
             (make-string full #\x2588) ;; full block
             (string (integer->char (- #x258F mod)))
             (make-string rest #\space)))
          (let ((len (ratio bar-width)))
            (string-append
             (make-string len #\#)
             (make-string (- bar-width len) #\.)))))

    (print (if istty "\r" "\n")
           "["
           (esc "\33[32;1m") (num->string nb-good 3 0) (esc "\33[0m")
           "|"
           (esc "\33[31;1m") (num->string nb-fail 3 0) (esc "\33[0m")
           ;;"|"
           ;;(esc "\33[34;1m") (num->string nb-other 4 0) (esc "\33[0m")
           "] "
           (num->string (ratio 100) 3 0)
           "% "
           (bar)
           " "
           (num->string elapsed 3 1)
           "s"
           (esc "\33[K"))

    (force-output)))

(define (run path . args)
  (let* ((port
          (open-process (list path: path
                              arguments: args
                              ;;stderr-redirection: #t
                              )))
         (output
          (read-line port #f))
         (status
          (process-status port)))
    (close-port port)
    (cons status output)))

(define (run-gsi-under-debugger file debug? target)
  (if debug?

      (if (equal? (cadr (system-type)) 'apple)

          (begin
            (with-output-to-file
                "clean_exit.py"
              (lambda ()
                (print "import os\n"
                       "\n"
                       "def clean_exit(debugger, command, result, internal_dict):\n"
                       "    target = debugger.GetSelectedTarget()\n"
                       "    process = target.GetProcess()\n"
                       "    if not process.exit_state == -1:\n"
                       "        os._exit(process.exit_state)\n"
                       "\n"
                       "def exit1(debugger, command, result, internal_dict):\n"
                       "    os._exit(1)\n"
                       "\n"
                       "def __lldb_init_module(debugger, internal_dict):\n"
                       "    debugger.HandleCommand('command script add -f clean_exit.clean_exit clean_exit')\n"
                       "    debugger.HandleCommand('command script add -f clean_exit.exit1 exit1')\n")))
            (with-output-to-file
                "dbg-script"
              (lambda ()
                (print "settings set auto-confirm 1\n"
                       "command script import clean_exit.py\n"
                       "run -:debug-settings=-,io-settings=lu,~~=.. -f " file "\n"
                       "clean_exit\n"
                       "frame variable\n"
                       "thread backtrace all\n"
                       ;;"call ___print_ctrl_flow_history();"
                       "exit1\n")))
            (let ((result
                   (run "lldb" "-s" "dbg-script" "../gsi/gsi")))
              (delete-file "clean_exit.py")
              (delete-file "dbg-script")
              result))

          (begin
            (with-output-to-file
                "dbg-script"
              (lambda ()
                (print "set $_exitcode = -1\n"
                       "run -:debug-settings=-,io-settings=lu,~~=.. -f " file "\n"
                       "if $_exitcode != -1\n"
                       "  quit $_exitcode\n"
                       "end\n"
                       "info locals\n"
                       "thread apply all bt\n"
                       ;;"call ___print_ctrl_flow_history();"
                       "quit 1\n")))
            (let ((result
                   (if (equal? (cadr (system-type)) 'apple)
                       (run "sudo" "gdb" "-q" "-x" "dbg-script" "../gsi/gsi")
                       (run "gdb" "-q" "-x" "dbg-script" "../gsi/gsi"))))
              (delete-file "dbg-script")
              result)))

      (case target
        ((C)
         (run "../gsi/gsi" "-:debug-settings=-,io-settings=lu,~~=.." "-f" file))
        (else
         (let ((gsi (string-append "../gsi/gsi-" (symbol->string target))))
           (run gsi "-f" file))))))

(define (test-using-mode file mode target)
  (case target
    ((C)
     (cond ((member mode '(gsi gsi-dbg))
            (run-gsi-under-debugger file (eq? mode 'gsi-dbg) target))
           ((member mode '(gsc gsc-dbg))
            (let* ((filename "_test.o1")
                   (result (run "../gsc/gsc" "-:debug-settings=-,io-settings=lu,~~=.." "-f" "-o" filename file)))
              (if (= 0 (car result))
                  (let ((result (run-gsi-under-debugger filename (eq? mode 'gsc-dbg) target)))
                    (if cleanup? (delete-file filename))
                    result)
                  result)))))
    (else
     (let* ((filename "_test.bat")
            (result (run "../gsc/gsc" "-:debug-settings=-,io-settings=lu,~~=.." "-warnings" "-target" (symbol->string target) "-exe" "-postlude" "(##exit)" "-o" filename file)))
       (if (= 0 (car result))
           (let ((result (run (path-expand filename))))
             (if cleanup? (delete-file filename))
             result)
           result)))))

(define (trim-filename file)
  (if (and (>= (string-length file) (string-length default-dir))
           (string=? (substring file 0 (string-length default-dir))
                     default-dir))
      (substring file (string-length default-dir) (string-length file))
      file))

(define (test file target)
  (for-each

   (lambda (mode)

     (print " " (trim-filename file))
     (force-output)

     (let* ((result (test-using-mode file mode target))
            (status (car result))
            (status-hi (quotient status 256))
            (status-lo (modulo status 256)))
       (if (= 0 status)
           (set! nb-good (+ nb-good 1))
           (begin
             (set! nb-fail (+ nb-fail 1))
             (print "\n")
             (print "*** FAILED " (trim-filename file) " WITH EXIT CODE HI="
                    status-hi
                    " LO="
                    status-lo
                    "\n")
             (print (cdr result))))

       (show-bar nb-good
                 nb-fail
                 nb-other
                 nb-total
                 (- (time->seconds (current-time)) start))))

   modes))

(define (run-tests files target)

  (set! nb-good 0)
  (set! nb-fail 0)
  (set! nb-other 0)
  (set! nb-total (length files))
  (set! start (time->seconds (current-time)))

  (show-bar nb-good nb-fail nb-other nb-total 0.0)

  (for-each (lambda (file) (test file target)) files)

  (print "\n")

  (if (= nb-good nb-total)
      (begin
        (print "PASSED ALL " nb-total " UNIT TESTS\n")
        (exit 0))
      (begin
        (print "FAILED " nb-fail " UNIT TESTS OUT OF " nb-total " (" (num->string (* 100. (/ nb-fail nb-total)) 0 1) "%)\n")
        (exit 1))))

(define (find-files file-or-dir filter)
  (if (eq? (file-type file-or-dir) 'directory)

      (apply
       append
       (map
        (lambda (f)
          (find-files (path-expand f file-or-dir) filter))
        (directory-files file-or-dir)))

      (if (filter file-or-dir)
          (list file-or-dir)
          (list))))

(define (list-of-scm-files args stress?)
  (apply
   append
   (map
    (lambda (f)
      (find-files f
                  (lambda (filename)
                    (and (equal? (path-extension filename) ".scm")
                         (not (equal? (path-strip-directory filename) "#.scm"))
                         (or stress?
                             (let ((len (string-length filename)))
                               (not (and (> len 11)
                                         (equal? (substring filename (- len 11) len)
                                                 "_stress.scm")))))))))
    args)))

(define modes '())
(define targets '())

(define default-dir
  (let* ((cd (current-directory))
         (len (string-length cd)))
    (string-append "unit-tests" (substring cd (- len 1) len))))

(define (main . args)

  (define stress? #f)

  (let loop ()
    (if (and (pair? args)
             (> (string-length (car args)) 1)
             (char=? #\- (string-ref (car args) 0)))
        (let ((word (substring (car args) 1 (string-length (car args)))))
          (cond ((equal? word "stress")
                 (set! stress? #t))
                ((member word '("C" "js" "python" "ruby" "php" "go" "java"))
                 (set! targets
                       (cons (string->symbol word)
                             targets)))
                (else
                 (set! modes
                       (cons (string->symbol word)
                             modes))))
          (set! args (cdr args))
          (loop))))

  (if (null? args)
      (set! args (list default-dir)))

  (if (null? modes)
      (set! modes '(gsi)))

  (if (null? targets)
      (set! targets '(C)))

  (let ((files
         (sort-list
          (list-of-scm-files args stress?)
          string<?)))
    (for-each
     (lambda (target)
       (run-tests files target))
     targets)))

;;;============================================================================
