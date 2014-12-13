;;;============================================================================

;;; File: "emacs.scm"

;;; Copyright (c) 2012-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("emacs#"))

(##include "~~lib/gambit#.scm")
(##include "~~lib/_gambit#.scm")

(##include "emacs#.scm")
(##include "intf#.scm")
(##include "json#.scm")
(##include "tar#.scm")

(##namespace
 (""
  repl
  repl-eval)
 ("gr#"
  generic-event-handler)
)

(declare
 (standard-bindings)
 (extended-bindings)
 (block)
 (fixnum)
 ;;(not safe)
)

;;;============================================================================

(define emacs-root-dir (path-expand "~/emacs"))
(define emacs-version-file (path-expand "v0" emacs-root-dir))
(define emacs-root-html-file (path-expand "GambitREPL.html" emacs-root-dir))
(define emacs-tar-file (##path-normalize (path-expand "~~/emacs.tgz")))

(define emacs-webView 4)

(define emacs-initialized? #f)

(define (emacs . files-to-visit)

  (hide-toolbar)
  (set-event-handler
   (lambda (old-event-handler) emacs-event-handler))
  (set-navigation -1)

  (show-view emacs-webView)

  (if (not emacs-initialized?)
      (begin
        (emacs-init files-to-visit)
        (set! emacs-initialized? #t))
      (emacs-visit-files files-to-visit))

  (show-view emacs-webView #t #t))

(define (set-generic-keys)
  (set-ext-keys
   emacs-webView
   "*^C+?/\\-,.2406835179'\"(`~:;)@#"
   "\003\u2191\u2190\030\u2193{}\u2192[]<>C=_*^+!?/\\-,.2406835179'\"(`~:;)@#"
   "\u2190\u2191\u2190\u2190\u2193\u2192\u2192\u2192\003\004{}\t\007\023[]\033\030\032<>C=_*^+&$/\\-|%2406835179'\"(`~:;)@#"))

(define (set-scheme-keys)
  (set-ext-keys
   emacs-webView
   "*^C+?/\\-,.2406835179'\"(`~:;)@#"
   "s\u2191\u2190L\u2193lk\u2192\u03bb\003<>C=_*^+!?/\\-,.2406835179'\"(`~:;)@#"
   "s\u2191\u2190L\u2193lk\u2192\u03bb\003{}\t\004\007[]\033\023\030<>C=_*^+&$/\\-|%2406835179'\"(`~:;)@#"))

(define (emacs-init files-to-visit)

  (if (equal? CFBundleDisplayName "Not Emacs")
      (set-generic-keys)
      (set-scheme-keys))

  (if (not (eq? 'regular
                (with-exception-catcher
                 (lambda (e) #f)
                 (lambda () (file-type emacs-version-file)))))
      (parameterize ((current-directory (path-directory emacs-root-dir)))
        (tar-write-unchecked (tar-unpack-file emacs-tar-file #t))))

  (eval-js-in-webView
   emacs-webView
   (string-append "var filesToVisit = "
                  (json-encode (list->vector files-to-visit))
                  ";"))

  (set-webView-content-from-file emacs-webView emacs-root-html-file))

(define (emacs-visit-files files-to-visit)
  (eval-js-in-webView
   emacs-webView
   (string-append "visitFiles("
                  (json-encode (list->vector files-to-visit))
                  ");")))

;;;----------------------------------------------------------------------------

(define (emacs-event-handler event)

  (define (respond request response)
    (eval-js-in-webView
     emacs-webView
     (string-append "receiveResponse("
                    (number->string (table-ref request "requestId"))
                    ","
                    (json-encode response)
                    ");")))

  (cond ((has-prefix? event "event:") =>
         (lambda (rest)
           (let ((request (json-decode rest)))
             (let ((method (table-ref request "method")))
               (respond
                request
                (with-exception-catcher
                 (lambda (e)

                   (display
                   (call-with-output-string
                    ""
                    (lambda (p) (display-exception e p)))
                   (repl-output-port))

                   (call-with-output-string
                    ""
                    (lambda (p) (display-exception e p))))
                 (lambda ()
                   (cond ((equal? method "fileType")
                          (do-fileType request))

                         ((equal? method "getDirectory")
                          (do-getDirectory request))

                         ((equal? method "getFileContents")
                          (do-getFileContents request))

                         ((equal? method "setFileContents")
                          (do-setFileContents request))

                         ((equal? method "deleteFile")
                          (do-deleteFile request))

                         ((equal? method "remapDir")
                          (do-remapDir request))

                         ((equal? method "killTerminal")
                          (do-killTerminal request))

                         ((equal? method "makeProcess")
                          (do-makeProcess request))

                         ((equal? method "startProcess")
                          (do-startProcess request))

                         ((equal? method "killProcess")
                          (do-killProcess request))

                         ((equal? method "sendProcessInterrupt")
                          (do-sendProcessInterrupt request))

                         ((equal? method "sendProcessInput")
                          (do-sendProcessInput request))

                         ((equal? method "finishSetupEmacs")
                          (do-finishSetupEmacs request))

                         (else
                          '())))))))))

        (else
         (generic-event-handler event))))

(define (do-fileType request)
  (let ((path (table-ref request "path" "")))
    (with-exception-catcher
     (lambda (e)
       '())
     (lambda ()
       (symbol->string (file-type path))))))

(define (do-getDirectory request)
  (let ((path (table-ref request "path" "")))
    (with-exception-catcher
     (lambda (e)
       '())
     (lambda ()
       (parameterize ((current-directory path))
         (let ((cd (current-directory)))
           (let ((files (directory-files (list path: cd))))
             (list->table
              (map (lambda (name)
                     (let ((fi (file-info name)))
                       (cons name
                             (list->table
                              (list (cons "name"
                                          name)
                                    (cons "path"
                                          (path-expand name cd))
                                    (cons "type"
                                          (symbol->string (file-info-type fi)))
                                    (cons "mode"
                                          (file-info-mode fi))
                                    (cons "nlinks"
                                          (file-info-number-of-links fi))
                                    (cons "size"
                                          (file-info-size fi))
                                    (cons "lastmod"
                                          (time->int
                                           (file-info-last-modification-time fi))))))))
                   files)))))))))

(define (time->int t)
  (floor (inexact->exact (time->seconds t))))

(define (do-getFileContents request)
  (let ((path (table-ref request "path" ""))
        (nothrow (table-ref request "nothrow" #f)))
    (with-exception-catcher
     (lambda (e)
       (vector '() '()))
     (lambda ()
       (let* ((content
               (call-with-input-file
                   (list path: path char-encoding: 'UTF-8)
                 (lambda (p) (read-line p #f))))
              (lastmod
               (time->int
                (file-last-modification-time path))))
         (vector content lastmod))))))

(define (do-setFileContents request)
  (let ((path (table-ref request "path" ""))
        (content (table-ref request "content" ""))
        (stamp (table-ref request "stamp" 0)))
    (if (or (null? stamp)
            (with-exception-catcher
             (lambda (e)
               #t)
             (lambda ()
               (equal? stamp
                       (time->int
                        (file-last-modification-time path))))))

        (with-exception-catcher
         (lambda (e)
           '())
         (lambda ()
           (call-with-output-file
               (list path: path char-encoding: 'UTF-8)
             (lambda (p) (display content p)))
           (time->int
            (file-last-modification-time path))))

        '())))

(define (do-deleteFile request)
  (let ((path (table-ref request "path" "")))
    (with-exception-catcher
     (lambda (e)
       '())
     (lambda ()
       (delete-file path)
       '()))))

(define (do-remapDir request)
  (let ((path (table-ref request "path" "")))
    path))

(define (do-killTerminal request)
  (if (not (equal? CFBundleDisplayName "Not Emacs"))
      (begin
        (show-toolbar)
        (repl)))
  '())

(define (do-makeProcess request)
  (let ((process (table-ref request "process" "")))
    (let ((thunk (eval (with-input-from-string process read))))
      (if (procedure? thunk)
          (setup-process-group-io!
           (make-process thunk (void))
           (lambda (processId output)
             (eval-js-in-webView
              emacs-webView
              (string-append "receiveProcessOutput("
                             (number->string processId)
                             ","
                             (json-encode output)
                             ");"))))
          '()))))

(define (do-startProcess request)
  (let ((processId (table-ref request "processId" -1)))
    (start-process! processId)
    '()))

(define (do-killProcess request)
  (let ((processId (table-ref request "processId" -1)))
    (kill-process processId)
    '()))

(define (do-sendProcessInterrupt request)
  (let ((processId (table-ref request "processId" -1)))
    (send-process-interrupt processId)
    '()))

(define (do-sendProcessInput request)
  (let ((processId (table-ref request "processId" -1))
        (input (table-ref request "input" "")))
    (send-process-input processId input)
    '()))

(define (do-finishSetupEmacs request)
  (let ((splash (table-ref request "splash" #f)))
    (if splash
        (eval-js-in-webView
         emacs-webView
         (if (equal? CFBundleDisplayName "Not Emacs")

             "ymacs.getActiveBuffer().signalInfo('<center><img src=\"icon.png\" style=\"width:128px;height:128px\"><h3>This is Not Emacs</h3>For help please use the Help menu</center>', true, 10000);
              file_menu_item.getMenu().children(3).destroy();
              help_menu_item.getMenu().children(3).destroy();"

             "ymacs.getActiveBuffer().signalInfo('<center>For help please use the Help menu</center>', true, 5000);
              withSchemeBuffer(function (buf) { });"))))
  '())

;;;----------------------------------------------------------------------------

;; Process groups.

(define (process-output-pump-start! process-ports output-substring)

  (define buf (make-string 1024))

  (define (process-output)
    (let ((out-rd-port (vector-ref process-ports 3)))
      (let loop ()
        (let ((n (read-substring buf 0 (string-length buf) out-rd-port 1)))
          (output-substring buf 0 n)
          (loop)))))

  (let ((tgroup (make-thread-group 'process-output-pump #f)))
    (thread-start! (make-thread
                    (lambda ()
                      (with-exception-catcher
                       (lambda (e)
                         #f)
                       process-output))
                    #f
                    tgroup))))

(define (make-process-ports process-group)
  (receive (in-rd-port in-wr-port) (open-string-pipe '(direction: input permanent-close: #f buffering: #f))
    (receive (out-wr-port out-rd-port) (open-string-pipe '(direction: output buffering: #f))
      (begin

        ;; Hack... set the names of the ports
        (##vector-set! in-rd-port 4 (lambda (port) '(stdin)))
        (##vector-set! out-wr-port 4 (lambda (port) '(stdout)))

        (vector in-rd-port in-wr-port out-wr-port out-rd-port process-group #f)))))

(define (setup-repl-channel! process-ports)
  (let ((in-rd-port (vector-ref process-ports 0))
        (out-wr-port (vector-ref process-ports 2))
        (process-group (vector-ref process-ports 4)))
    (let ((repl-channel (##make-repl-channel-ports in-rd-port out-wr-port)))
      (table-set! repl-server#repl-channel-table process-group repl-channel))))

(define (make-process thunk name)
  (let* ((process-group (make-thread-group 'process-group #f))
         (process-ports (make-process-ports process-group))
         (main-thread
          (make-thread
           (lambda () (setup-repl-channel! process-ports) (thunk))
           name
           process-group)))
    (vector-set! process-ports 5 main-thread)
    process-ports))

(define (start-process! processId)
  (let ((process-ports (table-ref process-group-table processId #f)))
    (if process-ports
        (let ((main-thread (vector-ref process-ports 5)))
          (thread-start! main-thread)))))

(define process-group-table (make-table))
(define process-group-counter 0)

(define (setup-process-group-io! process-ports send-output)
  (let ((processId process-group-counter))
    (set! process-group-counter (+ process-group-counter 1))
    (table-set! process-group-table processId process-ports)
    (process-output-pump-start!
     process-ports
     (lambda (str start end)
       (send-output processId (substring str start end))))
    processId))

(define (kill-process processId)
  (let ((process-ports (table-ref process-group-table processId #f)))
    (if process-ports
        (begin
          (table-set! process-group-table processId)
          (let ((main-thread (vector-ref process-ports 5)))
            (##thread-terminate! main-thread))))))

(define (send-process-interrupt processId)
  (let ((process-ports (table-ref process-group-table processId #f)))
    (if process-ports
        (let ((main-thread (vector-ref process-ports 5)))
          (##thread-interrupt! main-thread)))))

(define (send-process-input processId input)
  (let ((process-ports (table-ref process-group-table processId #f)))
    (if process-ports
        (let ((port (vector-ref process-ports 1)))
          (if (string? input)
              (begin
                (display input port)
                (force-output port))
              (close-output-port port))))))

;;;============================================================================
