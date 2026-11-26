(define (make-browser name available? open)
  (vector name available? open))

(define (browser-name b) (vector-ref b 0))
(define (browser-available? b) ((vector-ref b 1)))
(define (browser-open b url) ((vector-ref b 2) url))

(define (check-exit exit-status)
  (or (##fx= exit-status 0)
      (##raise-error-exception "failed to start web browser")))

(define (text-browser command)
  (make-browser
   command
   (lambda () (executable? command))
   (lambda (url)
     (##tty-mode-reset) ;; reset tty (in case subprocess needs to read tty)
     (check-exit
      (##run-subprocess
       command
       '() ;; no arguments
       #f  ;; don't capture output
       #f  ;; don't redirect stdin
       #f  ;; run in current directory
       (list url))))))

(define (gui-browser command)
  (make-browser
   command
   (lambda () (executable? command))
   (lambda (url)
     (check-exit
      (##run-subprocess
       command
       '() ;; no arguments
       #f  ;; don't capture output
       #f  ;; don't redirect stdin
       #f  ;; run in current directory
       (list url))))))

(define (gui-browser-osascript url)
  (let ((command "osascript"))
    (make-browser
     command
     (lambda () (executable? command))
     (lambda (url)
       (let ((stdin (string-append "tell application \"Safari\"\n"
                                   "    open location \"" url "\"\n"
                                   "end tell\n")))
         (check-exit
          (##run-subprocess
           command
           '()    ;; no arguments
           #f     ;; don't capture output
           stdin  ;; don't redirect stdin
           #f     ;; run in current directory
           '())))))))

(define (gui-browser-js url)
  (##inline-host-statement "window.open(@scm2host@(@1@));" url))

;;;

(define ##help-browsers
  (##make-parameter
   (append
    (if (equal? "" "@HELP_BROWSER@")
        '()
        (list (text-browser "@HELP_BROWSER@")))
    (list gui-browser-js
          (text-browser "lynx")
          (gui-browser "firefox")
          (gui-browser "mozilla")
          (gui-browser "netscape")
          gui-browser-osascript
          (gui-browser "chrome")
          (gui-browser "chromium")
          (gui-browser "chromium-browser")))
   (lambda (val)
     val)))

(define help-browsers
  ##help-browsers)

(define (help-browse-url url)
  (let ((browsers (help-browsers)))
    (let loop ((tail browsers))
      (if (null? tail)
          (begin (display "*** WARNING -- none of these browsers")
                 (display " can be found to view the documentation:")
                 (display "***            " (string-join browsers " ")))
          (let ((browser (car tail)))
            (if (browser-available? browser)
                (browser-open browser url)
                (loop (cdr tail))))))))

;;;

(define help-root "~~doc/")
(define help-index "gambit.tsv")

(define (tsv-lookup path subject index)
  (let ((suffix (string-append "\t" index "\t" subject)))
    (call-with-input-file path
      (lambda (port)
        (let loop ()
          (let ((line (read-line port)))
            (if (string? line)
                (if (##string-suffix=? line suffix)
                    (let ((fields (##string-split-at-char line #\tab)))
                      (url-join help-root (car fields)))
                    (loop))
                #f)))))))

(define-prim (##show-help subject index)
  (define path-append string-append)
  (let* ((tsv-file (path-append help-root help-index))
         (relative-url (tsv-lookup tsv-file subject index)))
    (if (not relative-url)
        (##raise-error-exception "no help found for" (##list subject))
        (help-browse-url (path-append help-root relative-url)))))

(define-prim (##show-documentation-of object)
  (##show-help (if (##string? object)
                   object
                   (##object->string (if (##procedure? object)
                                         (##procedure-name object)
                                         object)))
               "fn"))

(define-prim (##default-help object)
  (##show-documentation-of object))

(define ##help-hook ##default-help)

(define-prim (##help-hook-set! x)
  (set! ##help-hook x))

(define-prim (##help subject)
  (##help-hook subject))

(define-prim (help #!optional (subject (macro-absent-obj)))
  (macro-force-vars (subject)
    (##help (if (##eq? subject (macro-absent-obj)) help subject))))
