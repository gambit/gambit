;;;============================================================================

;;; File: "wiki.scm"

;;; Copyright (c) 2011-2012 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("wiki#"))

(##include "~~lib/gambit#.scm")

(##include "wiki#.scm")
(##include "url#.scm")
(##include "json#.scm")
(##include "genport#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (fixnum)
  (not safe)
)

;;;============================================================================

;; Mediawiki methods.

(define (mediawiki-request timeout server-address req)
  (let ((conn
         (with-exception-catcher
          (lambda (e)
            (raise mediawiki-failed-to-connect-error))
          (lambda ()
            (open-tcp-client
             (list server-address: server-address
                   eol-encoding: 'cr-lf))))))

    (define (raise-close-conn e)
      (close-port conn)
      (raise e))

    (define (failed-to-connect)
      (raise-close-conn mediawiki-failed-to-connect-error))

    (with-exception-catcher
     raise-close-conn
     (lambda ()

       (output-port-timeout-set! conn timeout failed-to-connect)
       (input-port-timeout-set! conn timeout failed-to-connect)

       (print port: conn req)
       (force-output conn)

       (let ((status (read-line conn)))
         (if (not (equal? status "HTTP/1.1 200 OK"))
             (failed-to-connect)
             (let loop ()
               (let ((line (read-line conn)))
                 (if (not (string? line))
                     (failed-to-connect)
                     (if (not (equal? line "")) ;; empty line
                         (loop)
                         (let ((response (json-read conn)))
                           (close-port conn)
                           response)))))))))))

(define mediawiki-failed-to-connect-error "failed to connect")

(define (mediawiki-post timeout server-address docu params cookie)
  (let ((content
         (with-output-to-string
           ""
           (lambda () (print params)))))
    (mediawiki-request
     timeout
     server-address
     (list
      "POST " docu " HTTP/1.0\n"
      "Host: " server-address "\n"
      "Content-Type: " "application/x-www-form-urlencoded" "\n"
      "Content-Length: " (string-length content) "\n"
      (if cookie
          (string-append
           "Cookie: " cookie "\n")
          "")
      "\n"
      content))))

(define (mediawiki-action timeout server-address docu session action attribs)
  (mediawiki-post
   timeout
   server-address
   docu
   (list "action=" action
         (map (lambda (a)
                (list "&"
                      (url-encode (symbol->string (car a)))
                      "="
                      (url-encode (cdr a))))
              (append attribs
                      '((format . "json")))))
   (and session
        (let* ((login
                (table-ref session "login"))
               (sessionid
                (table-ref login "sessionid"))
               (cookieprefix
                (table-ref login "cookieprefix"))
               (cookie
                (string-append cookieprefix "_session=" sessionid)))
          cookie))))

(define (mediawiki-login timeout server-address docu username password)
  (let* ((user-pass
          (list (cons 'lgname username)
                (cons 'lgpassword password)))
         (phase1
          (mediawiki-action timeout
                            server-address
                            docu
                            #f
                            "login"
                            user-pass))
         (login1
          (table-ref phase1 "login" #f)))

    (if (not login1)

        (raise "unknown")

        (let ((result1
               (table-ref login1 "result")))

          (cond ((equal? result1 "Success")
                 phase1)

                ((equal? result1 "NeedToken")
                 (let* ((token
                         (table-ref login1 "token"))
                        (phase2
                         (mediawiki-action timeout
                                           server-address
                                           docu
                                           phase1
                                           "login"
                                           (cons (cons 'lgtoken token)
                                                 user-pass)))
                        (login2
                         (table-ref phase2 "login" #f)))

                   (if (not login2)

                       (raise "unknown")

                       (let ((result2
                              (table-ref login2 "result")))

                         (cond ((equal? result2 "Success")
                                phase2)
                               (else
                                (raise result2)))))))

                (else
                 (raise result1)))))))

(define (mediawiki-query-allpages timeout server-address docu session ns)
  (let loop ((from "") (rev-allpages '()))
    (let* ((x
            (mediawiki-action
             timeout
             server-address
             docu
             session
             "query"
             (list (cons 'list "allpages")
                   (cons 'apnamespace ns)
                   (cons 'apfrom from)
                   (cons 'aplimit "500"))))
           (query
            (table-ref x "query" #f)))

      (if (not query)

          (raise "unknown")

          (let* ((allpages
                  (vector->list (table-ref query "allpages")))
                 (new-rev-allpages
                  (cons allpages rev-allpages))
                 (query-continue
                  (table-ref x "query-continue" #f)))
            (if query-continue
                (loop (table-ref (table-ref query-continue "allpages") "apfrom")
                      new-rev-allpages)
                (map (lambda (x)
                       (table-ref x "title"))
                     (apply append (reverse new-rev-allpages)))))))))

(define (mediawiki-page-store timeout server-address docu session title text)
  (let* ((x
          (mediawiki-action
           timeout
           server-address
           docu
           session
           "query"
           (list (cons 'prop "info")
                 (cons 'intoken "edit")
                 (cons 'titles title))))
         (query
          (table-ref x "query" #f)))

    (if (not query)

        (raise "unknown")

        (let* ((pages
                (table-ref query "pages"))
               (page1
                (cdar (table->list pages)))
               (edittoken
                (table-ref page1 "edittoken"))
               (y
                (mediawiki-action
                 timeout
                 server-address
                 docu
                 session
                 "edit"
                 (list (cons 'title title)
                       (cons 'summary title)
                       (cons 'token edittoken)
                       (cons 'text text))))
               (edit
                (table-ref y "edit" #f)))

          (if (not edit)

              (raise "unknown")

              (let ((result
                     (table-ref edit "result")))
                (if (not (equal? result "Success"))
                    (raise result))))))))

(define (mediawiki-page-fetch timeout server-address docu session title)
  (let* ((x
          (mediawiki-action
           timeout
           server-address
           docu
           session
           "query"
           (list (cons 'prop "revisions")
                 (cons 'titles title)
                 (cons 'rvprop "content"))))
         (query
          (table-ref x "query" #f)))

    (if (not query)

        (raise "unknown")

        (let* ((pages
                (table-ref query "pages"))
               (page1
                (cdar (table->list pages)))
               (revisions
                (table-ref page1 "revisions" #f)))

          (if (not revisions)

              (raise "script not found")

              (let* ((revision1
                      (vector-ref revisions 0))
                     (content
                      (cdar (table->list revision1))))
                content))))))

(define (mediawiki-page-remove timeout server-address docu session title)
  (let* ((x
          (mediawiki-action
           timeout
           server-address
           docu
           session
           "query"
           (list (cons 'prop "info")
                 (cons 'intoken "delete")
                 (cons 'titles title))))
         (query
          (table-ref x "query" #f)))

    (if (not query)

        (raise "script not found")

        (let* ((pages
                (table-ref query "pages"))
               (page1
                (cdar (table->list pages)))
               (deletetoken
                (table-ref page1 "deletetoken"))
               (y
                (mediawiki-action
                 timeout
                 server-address
                 docu
                 session
                 "delete"
                 (list (cons 'title title)
                       (cons 'summary title)
                       (cons 'token deletetoken))))
               (delete
                (table-ref y "delete" #f)))

          (if (not delete)
              (raise "script not found"))))))

;;;----------------------------------------------------------------------------

;; Gambit wiki methods.

(define wiki-session #f)

(define wiki-timeout        #f)
(define wiki-server-address #f)
(define wiki-root           #f)
(define wiki-api            #f)
(define wiki-script-ns      #f)
(define wiki-script-prefix  #f)
(define wiki-script-tags    #f)

(set! wiki-timeout        15)
(set! wiki-server-address "dynamo.iro.umontreal.ca:80")
(set! wiki-root           "/~gambit/wiki")
(set! wiki-api            "/api.php")
(set! wiki-script-ns      "102")
(set! wiki-script-prefix  "Script:")
(set! wiki-script-tags    '("<schemecode>" . "</schemecode>"))

(define (wiki-login username password #!optional (force? #f))
  (if (or (not (wiki-logged-in?))
          force?)
      (let ((session
             (mediawiki-login
              wiki-timeout
              wiki-server-address
              (string-append wiki-root wiki-api)
              username
              password)))
        (set! wiki-session session)))
  wiki-session)

(define (wiki-logout)
  (set! wiki-session #f))

(define (wiki-script-list)
  (wiki-logged-in-verify)
  (let ((x
         (mediawiki-query-allpages
          wiki-timeout
          wiki-server-address
          (string-append wiki-root wiki-api)
          wiki-session
          wiki-script-ns)))
    (let loop ((lst x) (rev-scripts '()))
      (if (pair? lst)
          (let ((str (car lst)))
            (let ((len (string-length str))
                  (prefix-len (string-length wiki-script-prefix)))
              (loop (cdr lst)
                    (if (or (< len prefix-len)
                            (not (string=? (substring str 0 prefix-len)
                                           wiki-script-prefix)))
                        rev-scripts
                        (cons (substring str prefix-len len)
                              rev-scripts)))))
          (reverse rev-scripts)))))

(define (wiki-script-store script-name source-text)
  (wiki-script-name-verify script-name)
  (wiki-logged-in-verify)
  (let ((text
         (string-append
          (car wiki-script-tags)
          source-text
          (cdr wiki-script-tags))))
    (mediawiki-page-store
     wiki-timeout
     wiki-server-address
     (string-append wiki-root wiki-api)
     wiki-session
     (string-append wiki-script-prefix script-name)
     text)))

(define (wiki-script-fetch script-name)
  (wiki-script-name-verify script-name)
  (wiki-logged-in-verify)
  (let ((text
         (mediawiki-page-fetch
          wiki-timeout
          wiki-server-address
          (string-append wiki-root wiki-api)
          wiki-session
          (string-append wiki-script-prefix script-name))))
    (let* ((tag1 (car wiki-script-tags))
           (tag2 (cdr wiki-script-tags))
           (tag1-len (string-length tag1))
           (tag2-len (string-length tag2))
           (len (string-length text)))
      (if (or (< len (+ tag1-len tag2-len))
              (not (string=? tag1 (substring text 0 tag1-len)))
              (not (string=? tag2 (substring text (- len tag2-len) len))))
          (raise "malformed script")
          (let ((source-text (substring text tag1-len (- len tag2-len))))
            source-text)))))

(define (wiki-script-remove script-name)
  (wiki-script-name-verify script-name)
  (wiki-logged-in-verify)
  (mediawiki-page-remove
   wiki-timeout
   wiki-server-address
   (string-append wiki-root wiki-api)
   wiki-session
   (string-append wiki-script-prefix script-name)))

(define (wiki-logged-in?)
  (not (not wiki-session)))

(define (wiki-logged-in-verify)
  (if (not (wiki-logged-in?))
      (raise "you must first login to the Gambit wiki")))

(define (wiki-script-name-verify script-name)
  (if (not (eq? (wiki-script-name-type script-name) 'wiki))
      (raise "illegal wiki script name")))

(define (wiki-script-name-type script-name)
  (if (not (string? script-name))
      #f
      (let ((len (string-length script-name)))
        (if (= len 0)
            #f
            (let ((has-scm-ext? #f)
                  (has-colon? #f)
                  (has-space? #f))
              (let loop ((i (- (if (or (< len 4)
                                       (not (string=? ".scm"
                                                      (substring script-name (- len 4) len))))
                                   len
                                   (begin
                                     (set! has-scm-ext? #t)
                                     (- len 4)))
                               1)))
                (if (< i 0)
                    (cond ((and has-scm-ext?
                                has-colon?
                                (let ((c (string-ref script-name 0)))
                                  (and (char>=? c #\A) (char<=? c #\Z))))
                           'wiki)
                          ((and has-scm-ext?
                                (not has-colon?)
                                (not has-space?))
                           'file)
                          ((not has-space?)
                           'script)
                          (else
                           #f))
                    (let ((c (string-ref script-name i)))
                      (cond ((char=? c #\:)
                             (set! has-colon? #t)
                             (loop (- i 1)))
                            ((char=? c #\space)
                             (set! has-space? #t)
                             (loop (- i 1)))
                            ((or (and (char>=? c #\a) (char<=? c #\z))
                                 (and (char>=? c #\A) (char<=? c #\Z))
                                 (and (char>=? c #\0) (char<=? c #\9))
                                 (memv c '(#\- #\.)))
                             (loop (- i 1)))
                            (else
                             #f))))))))))

;;;----------------------------------------------------------------------------

(define (http-get docu #!optional (server-address wiki-server-address))
  (let ((port (open-tcp-client server-address)))
    (print port: port "GET " docu "\r\n\r\n")
    (force-output port)
    (let* ((genport-in (genport-native-input-port->genport port))
           (u8vect (genport-read-u8vector genport-in)))
      (close-port port)
      u8vect)))

;;;============================================================================
