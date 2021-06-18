;;;============================================================================

;;; File: "process.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Process related operations.

(##include "process#.scm")

;;;----------------------------------------------------------------------------

;;; Support for R7RS process-context library, SRFI 193 and Gambit specific
;;; subprocess creation.

;;;----------------------------------------------------------------------------

;;; Interface to OS.

(macro-case-target

 ((C)  ;;......................................................................

(c-declare #<<c-declare-end

#include "os_shell.h"

c-declare-end
)

(define-prim ##os-shell-command
  (c-lambda (scheme-object)
            scheme-object
   "___os_shell_command"))

(define (##get-command-line)
  (##declare (not interrupts-enabled))
  (##c-code "___RESULT = ___GSTATE->command_line;"))
)

 (else))  ;;...................................................................

;;;----------------------------------------------------------------------------

(define-prim (exit #!optional (status (macro-absent-obj)))
  (if (##eq? status (macro-absent-obj))
      (##exit (macro-EXIT-CODE-OK))
      (macro-force-vars (status)
        (if (##eq? status #f)
            (##exit (macro-EXIT-CODE-SOFTWARE))
            (macro-check-exact-unsigned-int8 status 1 (exit status)
              (##exit status))))))

(define-prim (emergency-exit #!optional (status (macro-absent-obj)))
  (if (##eq? status (macro-absent-obj))
      (##exit-abruptly (macro-EXIT-CODE-OK))
      (macro-force-vars (status)
        (if (##eq? status #f)
            (##exit-abruptly (macro-EXIT-CODE-SOFTWARE))
            (macro-check-exact-unsigned-int8 status 1 (emergency-exit status)
              (##exit-abruptly status))))))

;;;----------------------------------------------------------------------------

;; The ##run-subprocess procedure is a utility procedure that is
;; useful to execute shell scripts that are part of the Gambit system,
;; for example to view documentation and invoke the C compiler.  To
;; avoid string escaping problems and improve portability the
;; parameters of these scripts are sometimes passed using dedicated
;; shell variables.  The strings are created using the procedures
;; ##shell-var-binding, ##shell-var-bindings and
;; ##shell-args-numbered.

(define-prim (##run-subprocess
              path
              #!optional
              (arguments (macro-absent-obj))
              (capture? (macro-absent-obj))
              (null-stdin? (macro-absent-obj))
              (directory (macro-absent-obj))
              (add-vars (macro-absent-obj))
              (raise-os-exception? (macro-absent-obj))
              (cont (macro-absent-obj)))

  ;;                subprocess stdout/stderr
  ;; capture? = #f  not redirected (so will appear on current stdout/stderr)
  ;; capture? = #t  captured to a string and returned in cdr of result
  ;; capture? = ()  captured but discarded

  ;; null-stdin? = #f  subprocess stdin will be the same as current stdin
  ;; null-stdin? = #t  subprocess stdin will be empty

  (##open-process-generic
   (if (##eq? null-stdin? #t)
       (macro-direction-in)
       (macro-direction-inout))
   #f
   (lambda (port)
     (let ((cont2 (if (##eq? cont (macro-absent-obj)) ##identity cont)))
       (if (##fixnum? port)
           (if (##eq? raise-os-exception? #f)
               (cont2 port)
               (##raise-os-exception
                #f
                (if (##fx= port 1) ;; couldn't set current directory?
                    ##err-code-ENOENT ;; pretend directory does not exist
                    port)
                ##run-subprocess
                path
                arguments
                capture?
                null-stdin?
                directory
                add-vars
                raise-os-exception?
                cont))
           (begin
             (if (##not (##eq? null-stdin? #t))
                 (##close-output-port port))
             (if (##eq? capture? #t)
                 (let* ((out (##read-line port #f #f ##max-fixnum))
                        (output (if (##string? out) out "")))
                   (##close-input-port port)
                   (let ((status (##process-status port)))
                     (cont2 (##cons status output))))
                 (let loop ()
                   (if (##char? (##read-char port))
                       (loop)
                       (begin
                         (##close-input-port port)
                         (cont2 (##process-status port))))))))))
   open-process
   (let ((cap (##not (or (##eq? capture? (macro-absent-obj))
                         (##not capture?)))))
     (##list path: path
             arguments: (if (##eq? arguments (macro-absent-obj)) '() arguments)
             directory: (if (##eq? directory (macro-absent-obj)) #f directory)
             environment:
             (##append (if (##eq? add-vars (macro-absent-obj)) '() add-vars)
                       (let ((env (##os-environ)))
                         (if (##fixnum? env) '() env)))
             stdin-redirection: (##eq? null-stdin? #t)
             stdout-redirection: cap
             stderr-redirection: cap))))

(define-prim (##shell-var-binding
              var
              val
              #!optional
              (var-prefix (macro-absent-obj))
              (var-suffix (macro-absent-obj)))
  (##string-append
   (if (##eq? var-prefix (macro-absent-obj)) "" var-prefix)
   var
   (if (##eq? var-suffix (macro-absent-obj)) "_PARAM" var-suffix)
   "="
   val))

(define-prim (##shell-var-bindings
              alist
              #!optional
              (var-prefix (macro-absent-obj))
              (var-suffix (macro-absent-obj)))
  (##map (lambda (var-val)
           (##shell-var-binding (##car var-val)
                                (##cdr var-val)
                                var-prefix
                                var-suffix))
         alist))

(define-prim (##shell-args-numbered lst)

  (define (gen lst i)
    (if (##pair? lst)
        (##cons (##cons (##string-append "ARG" (##fixnum->string i))
                        (##car lst))
                (gen (##cdr lst) (##fx+ i 1)))
        '()))

  (gen lst 1))

(define-prim (##shell-install-dirs lst)
  (##map (lambda (str)
           (##cons (##string-append "GAMBITDIR_" (##string-upcase str))
                   (##path-strip-trailing-directory-separator
                    (##path-normalize-directory-existing
                     (##string-append "~~" str)))))
         lst))

;;;----------------------------------------------------------------------------

(define ##processed-command-line
  (##get-command-line))

(define-prim (##processed-command-line-set! x)
  (set! ##processed-command-line x))

(define ##script-command-line #f)

(define (##script-command-line-set! x)
  (set! ##script-command-line x))

(define-prim&proc (command-line)
  (or ##script-command-line
      ##processed-command-line))

(define-prim&proc (command-name)
  (let ((path (car (command-line))))
    (and (not (fx= 0 (string-length path)))
         (path-strip-extension (path-strip-directory path)))))

(define-prim&proc (command-args)
  (cdr (command-line)))

(define-prim&proc (script-file)
  (and ##script-command-line
       (let ((path (car ##script-command-line)))
         (and (not (fx= 0 (string-length path)))
              path))))

(define-prim&proc (script-directory)
  (let ((path (script-file)))
    (and path
         (path-directory path))))

(define-prim (##shell-command-blocking cmd)
  (let ((code (##os-shell-command cmd)))
    (if (##fx< code 0)
        (##raise-os-exception #f code ##shell-command-blocking cmd)
        code)))

(define ##shell-program #f)  ;; remember shell program previously executed
(define ##shell-command-fallback #t)  ;; allow fallback to ##os-shell-command

(define-prim (##get-shell-program)

  (define unix-shell-program    '("/bin/sh" . "-c"))
  (define windows-shell-program '("CMD.EXE" . "/C"))
  (define default-shell-program '("sh"      . "-c"))

  (or ##shell-program
      (let* ((cd
              (##current-directory))
             (directory-separator
              (##string-ref cd (##fx- (##string-length cd) 1)))
             (sp
              (if (##char=? #\\ directory-separator)
                  (let ((comspec (##getenv "COMSPEC" #f)))
                    (if comspec
                        (##cons comspec "/C")
                        windows-shell-program))
                  (if (##file-exists? (##car unix-shell-program))
                      unix-shell-program
                      default-shell-program))))
        (set! ##shell-program sp)
        sp)))

(define-prim (##shell-command cmd #!optional (capture? (macro-absent-obj)))
  (let ((shell-prog (##get-shell-program)))
    (##run-subprocess
     (##car shell-prog)
     (##list (##cdr shell-prog) cmd)
     capture?
     #f  ;; subprocess will receive same stdin as current stdin
     #f  ;; use current directory
     '() ;; no additional environment variables
     #f  ;; don't raise OS exceptions
     (lambda (result)
       (if (and (##fixnum? result)
                (##fx< result 0))
           (if (and ##shell-command-fallback
                    (##fx= result ##err-code-unimplemented))
               (let ((code (##os-shell-command cmd)))
                 (if (##fx< code 0)
                     (##raise-os-exception #f code shell-command cmd capture?)
                     (if (##eq? capture? #t)
                         (##cons code "")
                         code)))
               (##raise-os-exception #f result shell-command cmd capture?))
           result)))))

#;
(define-prim (##escape-string str escape-char to-escape)
  (let* ((len
          (##string-length str))
         (nb-escapes
          (let loop1 ((i (##fx- len 1))
                      (n 0))
            (if (##fx< i 0)
                n
                (let ((c (##string-ref str i)))
                  (loop1 (##fx- i 1)
                         (if (##memq c to-escape)
                             (##fx+ n 1)
                             n))))))
         (escaped-len
          (##fx+ len nb-escapes))
         (escaped-str
          (##make-string escaped-len 0)))
    (let loop2 ((i (##fx- len 1))
                (j (##fx- escaped-len 1)))
      (if (and (##not (##fx< i 0)) (##not (##fx< j 0)))
          (let ((c (##string-ref str i)))
            (##string-set! escaped-str j c)
            (loop2 (##fx- i 1)
                   (if (and (##fx< 0 j)
                            (##memq c to-escape))
                       (let ()
                         (##string-set! escaped-str
                                        (##fx- j 1)
                                        escape-char)
                         (##fx- j 2))
                       (##fx- j 1))))
          escaped-str))))

(define-prim (shell-command cmd #!optional (capture? (macro-absent-obj)))
  (macro-force-vars (cmd capture?)
    (macro-check-string cmd 1 (shell-command cmd capture?)
      (if (##eq? capture? (macro-absent-obj))
          (##shell-command cmd)
          (##shell-command cmd capture?)))))

(define-prim&proc (version-alist)

  (let ()

    (define (format-stamp stamp)
      (define (padded-number i)
        (if (< i 10)
            (string-append "0" (number->string i))
            (number->string i)))
      (let ((nums
             (let loop ((num stamp) (nums '()) (count 5))
               (if (< count 1) (cons num nums)
                   (let ((num (truncate-quotient  num 100))
                         (rem (truncate-remainder num 100)))
                     (loop num (cons rem nums) (- count 1)))))))
        (let ((year   (list-ref nums 0))
              (month  (list-ref nums 1))
              (day    (list-ref nums 2))
              (hour   (list-ref nums 3))
              (minute (list-ref nums 4))
              (second (list-ref nums 5)))
          (string-append
           (padded-number year) "-"
           (padded-number month) "-"
           (padded-number day) "T"
           (padded-number hour) ":"
           (padded-number minute) ":"
           (padded-number second) "Z"))))

    (define (split-command-line string)
      (let loop ((i 0) (args '()) (arg #f))
        (if (= i (string-length string))
            (reverse args)
            (let ((c (string-ref string i)))
              (cond ((not (char=? #\' c))
                     (loop (+ i 1) args (and arg
                                             (cons c arg))))
                    ((not arg)
                     (loop (+ i 1) args '()))
                    (else
                     (let ((arg (list->string (reverse arg))))
                       (loop (+ i 1) (cons arg args) #f))))))))

    `((command "gsi")  ; TODO: Should vary between "gsi" and "gsc".
      (version ,(##system-version-string))
      (website "https://gambitscheme.org")
      (scheme.id gambit)
      (encodings utf-8)
      (languages scheme r5rs r7rs)
      (build.date ,(format-stamp (##system-stamp)))
      (build.platform ,##os-system-type-string-saved)
      (build.configure
       ,@(split-command-line ##os-configure-command-string-saved)))))

;;;============================================================================
