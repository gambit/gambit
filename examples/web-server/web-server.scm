#!/usr/bin/env gsi-script

; File: "web-server.scm", Time-stamp: <2008-12-17 13:41:03 feeley>

; Copyright (c) 2004-2008 by Marc Feeley, All Rights Reserved.

; A minimal web server which implements a web-site with a few
; interesting examples.

;==============================================================================

(##include "~~lib/gambit#.scm") ;; import Gambit procedures and variables
(##include "http#.scm")         ;; import HTTP procedures and variables
(##include "html#.scm")         ;; import HTML procedures and variables
(##include "base64#.scm")       ;; import BASE64 procedures and variables

(declare (block)) ;; required for serializing continuations
                  ;; (for the web-continuation example)

;==============================================================================

(define main
  (lambda (arg)
    (let ((port-number
           (string->number arg)))
      (http-server-start!
       (make-http-server
        port-number: port-number
        threaded?: #t
        GET: GET/POST
        POST: GET/POST)))))

(define page-generators (make-table test: string=?))

(define show-exceptions
  (lambda (thunk)
    (with-exception-catcher
     (lambda (exc)
       (reply-html
        (<html>
         (<head> (<title> "Scheme exception"))
         (<body>
          (<p> "The following Scheme exception occurred while processing the request:")
          (<pre>
           (call-with-output-string
            ""
            (lambda (port) (##display-exception exc port))))))))
     thunk)))

(define GET/POST
  (lambda ()
    (show-exceptions
     (lambda ()
       (let* ((request (current-request))
              (uri (request-uri request))
              (path (uri-path uri))
              (generator (table-ref page-generators path unknown-page)))
         (generator))))))

(define unknown-page
  (lambda ()
    (let* ((request (current-request))
           (uri (request-uri request))
           (path (uri-path uri)))
      (get-filesys-path path))))

(define get-filesys-path
  (lambda (path)
    (let ((type (file-type path)))
      (case type

        ((directory)
         (reply-html
          (<html>
           (<head> (<title> "Files in directory " path))
           (<body>

            (<h1> "Files in " path)

            (<ol>
             (map (lambda (fn)
                    (<li>
                     (<a> href: (object->string (path-expand fn path)) fn)
                     " ("
                     (object->string
                      (with-exception-catcher
                       (lambda (exc) 'other)
                       (lambda () (file-type (path-expand fn path)))))
                     ")"))
                  (directory-files
                   (list path: path ignore-hidden: #f))))))))

        ((regular)
         (let* ((port (open-input-file path))
                (file (read-line port #f)))
           (close-input-port port)
           (let ((ext (path-extension path)))
             (if (or (string-ci=? ext ".htm")
                     (string-ci=? ext ".html"))
                 (reply (lambda () (display file)))
                 (reply-html
                  (<html>
                   (<head> (<title> "File " path))
                   (<body> (<pre> file))))))))

        (else
         (reply-html
          (<html>
           (<head> (<title> "Error"))
           (<body>
            "Only directories and regular files can be displayed"))))))))

;==============================================================================

; Main web page.

(define page-main
  (lambda ()
    (reply-html
     (<html>
      (<head> (<title> "Main page"))
      (<body>
       (<center> (<b> "Welcome to the " (<i> "web-server") " example"))
       (<p> "Please choose one of these examples:")
       (<ul>
        (<li> (<a> href: (object->string (current-directory))
                   "Browse the web server's filesystem"))
        (<li> (<a> href: "/web-continuation"
                   "Web-continuation based calculator"))
        (<li> (<a> href: "/terminate-server"
                   "Terminate server"))))))))

(table-set! page-generators "/"           page-main)
(table-set! page-generators "/index.html" page-main)
(table-set! page-generators "/index.htm"  page-main)

;==============================================================================

; Web pages for web-continuation example.

(define page-web-continuation
  (lambda ()
    (obtain-store-cont-on-server title-embed)))

(table-set! page-generators "/web-continuation" page-web-continuation)

(define page-calculator
  (lambda ()

    ; check if we are resuming a continuation or starting the example

    (let* ((request (current-request))
           (query (request-query request)))

      (cond ((and query (assoc "cont" query))
             =>
             (lambda (x)
               ; we're resuming a continuation
               (resume-continuation (cdr x) query)))

            ((and query (assoc "submit" query))
             =>
             (lambda (x)
               ; we're starting the calculator
               (let* ((x (assoc "store_cont_on_server" query))
                      (on-server? (and x (string=? (cdr x) "yes"))))
                 (parameterize ((store-cont-on-server? on-server?))
                   (calculator-start)))))

            (else
             (reply-html
              (<html>
               (<head> (<title> "Error"))
               (<body>
                (<h1> "Something's wrong with the request...")))))))))

(table-set! page-generators "/calculator" page-calculator)

; BUG: parameters lose their identity when serialized/deserialized so
; we can't store this information in a parameter.
(define store-cont-on-server? (make-parameter #f))

(define calculator-start
  (lambda ()
    (let ((new-number
           (show-sum-and-obtain-number
            '()
            first-number-embed)))
      (calculator-loop (list new-number)))))

(define calculator-loop
  (lambda (numbers-previously-entered)
    (let ((new-number
           (show-sum-and-obtain-number
            numbers-previously-entered
            plain-embed)))
      (calculator-loop (append numbers-previously-entered
                               (list new-number))))))

(define show-sum-and-obtain-number
  (lambda (numbers-previously-entered embed)
    (let ((sum (apply + numbers-previously-entered)))
      (obtain-number
       (lambda (stuff)
         (embed
          (<table>
           (if (null? numbers-previously-entered)
               '()
               (list
                (map (lambda (x)
                       (<tr> (<td>)
                             (<td> align: 'right x)))
                     numbers-previously-entered)
                (<tr> (<td>)
                      (<td> align: 'right "---------------------"))
                (<tr> (<td> "TOTAL:")
                      (<td> align: 'right bgcolor: "yellow" sum))))
           (<tr> (<td>)
                 (<td> stuff)))))))))

(define title-embed
  (lambda (stuff)
    (<html>
     (<head> (<title> "Web-continuation example"))
     (<body>
      (<h1> "Web-continuation example")
      (<p> "This page implements a simple calculator that adds the "
           "numbers that are entered by the user.")
      (<p> "You can use the " (<strong> "back") " button to undo the "
           "additions.  You can also clone the window and copy "
           "the URL to a different browser to start an independent "
            " branch of calculation.")
      (<p> "The web-server can be run interpreted or compiled.  It is "
           "much more efficient to use a compiled web-server because "
           "the continuations in the HTML file sent back to the browser "
           "will be much more compact.")
      (<p> "Please indicate if you want the continuation to be stored "
           "on the web browser or on the web server.  It is more "
           "efficient to store the continuation on the server but it "
           "introduces the problem of web-continuation garbage-collection "
           "(each continuation will be saved as a file on the server's file "
           "system; the issue is: when can these files be deleted?)")
      stuff))))

(define first-number-embed
  (lambda (stuff)
    (<html>
     (<head> (<title> "Web-continuation example"))
     (<body>
      (<h1> "Web-continuation example")
      (<p> "Enter the first number here: " stuff)))))

(define plain-embed
  (lambda (stuff)
    (<html>
     (<head> (<title> "Web-continuation example"))
     (<body>
      (<h1> "Web-continuation example")
      stuff))))

(define form-method "GET") ; can be "GET" or "POST"

(define obtain-number
  (lambda (embed)
    (let ((number-str
           (obtain
            "number"
            (lambda (cont)
              (embed
               (<form>
                action: "/calculator"
                method: form-method
                (<input> type: 'hidden
                         name: "cont"
                         value: cont)
                (<input> type: 'text name: "number")
                (<input> type: 'submit
                         name: "submit"
                         value: "ADD")))))))
      (or (string->number number-str)
          (obtain-number embed)))))

(define obtain-store-cont-on-server
  (lambda (embed)
    (obtain
     "store_cont_on_server"
     (lambda (cont) ; continuation is ignored
       (embed
        (<form>
         action: "/calculator"
         method: form-method
         (<input> type: 'checkbox
                  name: "store_cont_on_server"
                  value: "yes"
                  "Store continuation on server")
         (<input> type: 'submit
                  name: "submit"
                  value: "\"START CALCULATOR\"")))))))

(define obtain
  (lambda (name embed)
    (let ((query
           (capture-continuation
            (lambda (cont)
              (reply-html (embed cont))
              (thread-terminate! (current-thread))))))
      (cdr (assoc name query)))))

(define capture-continuation
  (lambda (receiver)
    (call/cc
     (lambda (k)
       (let* ((k-str
               (u8vector->base64-string (object->u8vector k)))
              (cont
               (if (store-cont-on-server?)
                   (let loop () ; find a unique filename
                     (let* ((rn (random-integer (expt 2 64)))
                            (fn (string-append "_cont"
                                               (number->string rn 16))))
                       (if (file-exists? fn)
                           (loop)
                           (begin
                             (with-output-to-file fn
                               (lambda ()
                                 (display k-str)))
                             fn))))
                   k-str)))
         (receiver cont))))))

(define resume-continuation
  (lambda (cont val)
    (let* ((k-str
            (if (and (> (string-length cont) 0)
                     (char=? (string-ref cont 0) #\_))
                (with-input-from-file cont read-line)
                cont))
           (k
            (u8vector->object (base64-string->u8vector k-str))))
      (k val))))

;==============================================================================

; Web-IDE page.

(define page-web-ide
  (lambda ()
    (reply-html
     (<html>
      (<head>
       (<title> "Web-IDE page")
       (<style> web-ide-style)
       (<script> web-ide-script))
      (<body>
       (<p> "This example is not complete"))))))

(table-set! page-generators "/web-ide" page-web-ide)

(define web-ide-style #<<EOF

web ide style

EOF
)

(define web-ide-script #<<EOF

web ide script

EOF
)

;==============================================================================

; Web-server termination.

(define page-terminate-server
  (lambda ()
    (exit)))

(table-set! page-generators "/terminate-server" page-terminate-server)

;==============================================================================
