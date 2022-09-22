;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2019 by Frédéric Hamel, All Rights Reserved.
;;; Copyright (c) 2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(import _test)
(import _uri)
(import _http)

;;; From examples/web-server
(define permissive-read-line
  (lambda (port)
    (let ((s (read-line port)))
      (if (and (string? s)
               (> (string-length s) 0)
               (char=? (string-ref s (- (string-length s) 1)) #\return))
          ; efficient version of (substring s 0 (- (string-length s) 1))
          (begin (string-shrink! s (- (string-length s) 1)) s)
          s))))

(define find-char-pos
  (lambda (str char)
    (let loop ((i 0))
      (if (< i (string-length str))
          (if (char=? char (string-ref str i))
              i
              (loop (+ i 1)))
          #f))))

(define split-attribute-line
  (lambda (line)
    (let ((pos (find-char-pos line #\:)))
      (and pos
           (< (+ pos 1) (string-length line))
           (char=? #\space (string-ref line (+ pos 1)))
           (cons (substring line 0 pos)
                 (substring line (+ pos 2) (string-length line)))))))

;; ----------------------------------------------------------------------------

(define (make-http-test-server port)
  (define (send-error code msg conn)
    (display "HTTP/1.1 " conn)
    (display code conn)
    (display #\space conn)
    (display msg conn)
    (display "\r\nContent-Type: text/plain\r\nContent-Length: " conn)
    (display (string-length msg) conn)
    (display "\r\n\r\n" conn)
    (display msg conn)
    (force-output conn)
    (close-port conn))

  (define (send-error-not-implemented conn)
    (send-error 501 "Method Not implemented" conn))

  (define (send-error-bad-request conn)
    (send-error 400 "Bad Request" conn))

  (define (read-header conn)
    (let loop ((attributes '()))
      (let ((line (permissive-read-line conn)))
        (cond ((not line)
               #f)
              ((= 0 (string-length line))
               attributes)
              (else
                (let ((attribute (split-attribute-line line)))
                  (and attribute
                      (loop (cons attribute attributes)))))))))

  (let ((serv-port (open-tcp-server (list
                      server-address: '#u8(127 0 0 1)
                      port-number: port
                      backlog: 16
                      reuse-address: #t))))
    (vector (socket-info-port-number (tcp-server-socket-info serv-port))
            (make-thread
              (lambda ()

                (let loop ((conn (read serv-port)))
                  (let loop1 ((req-header '()))
                    (let ((req (permissive-read-line conn)))
                      (if (not (string? req))
                        (begin
                          (close-port conn)
                          (loop (read serv-port)))

                        (let* ((end (find-char-pos req #\space))
                               (method (substring req 0 end)))
                          ;(display req)
                          ;(newline)
                          (cond
                            ((string=? "GET" method)
                             (parse-uri
                               req
                               (+ end 1)
                               (string-length req)
                               #t
                               (lambda (uri i)
                                 (define (handle-version version)
                                   (case version
                                     ((HTTP/1.0 HTTP/1.1)
                                      (let ((attributes (read-header conn)))
                                        (if attributes
                                          (handle-request version attributes)
                                          (send-error-bad-request conn))))
                                     (else
                                       (send-error-bad-request conn))))

                                 (define (handle-request version attributes)
                                   (let ((path (uri-path uri)))
                                     (cond
                                       ((##string-prefix? "/identity" path)
                                        (display "HTTP/1.1 200 ok\r\nContent-Type: text/plain\r\nContent-Length: " conn)
                                        (display (string-length path) conn)
                                        (display "\r\n\r\n" conn)
                                        (display path conn)
                                        (force-output conn)
                                        (close-port conn)

                                        (loop (read serv-port)))

                                       ((##string-prefix? "/chunked" path)
                                        (display "HTTP/1.1 200 ok\r\nContent-Type: text/plain\r\nTransfer-Encoding: chunked\r\n\r\n" conn)
                                        (let ((msglen (string-length path)))
                                          (let loop2 ((i 0))
                                            (if (< i msglen)
                                              (let ((chunk-size (min (- msglen i) 4)))
                                                (display chunk-size conn)
                                                (display "\r\n" conn)
                                                (display (substring path i (+ i chunk-size)) conn)
                                                (display "\r\n" conn)
                                                (force-output conn)
                                                (loop2 (+ i chunk-size)))

                                              (begin
                                                (display "0\r\n\r\n" conn)
                                                (force-output conn)
                                                (close-port conn)

                                                (loop (read serv-port)))))))

                                       ((string=? "/close" path)
                                        ;; return empty body
                                        (display "HTTP/1.1 200 ok\r\nContent-Length: 0\r\n\r\n" conn)
                                        (force-output conn)

                                        (close-port conn)
                                        (close-port serv-port))

                                       (else
                                         (send-error 404 "Page not found" conn)))))

                                 (cond ((not uri)
                                        (send-error-bad-request conn))

                                       ((not (char=? (string-ref req i) #\space))
                                        (send-error-bad-request conn))

                                       (else
                                         (let ((version (substring req (+ i 1) (string-length req))))
                                           (if (= 0 (string-length version))
                                             (send-error-bad-request conn)
                                             (handle-version (string->symbol version)))))))))
                            (else
                              (send-error-not-implemented conn)))))))))))))

(define (u8vector->string u8vect)
  (list->string (map integer->char (u8vector->list u8vect))))


;; Start server
(define http-server (make-http-test-server 0))
(thread-start! (vector-ref http-server 1))

(define port-number (number->string (vector-ref http-server 0)))

;; Test
(let ((base-url (string-append "http://localhost:" port-number "/identity")))
  (define result-identity0 (http-get (string-append base-url "/foo bar")))
  (define result-identity1 (http-get (string-append base-url "/foo bar") #f #t))
  (define result-identity2 (http-get (string-append base-url "/foo%20bar") #f #f))

  (test-equal "/identity/foo bar"
              (u8vector->string
                (vector-ref result-identity0 1)))

  (test-equal result-identity0 result-identity1)
  (test-equal result-identity0 result-identity2))

(let ((base-url (string-append "http://localhost:" port-number "/chunked")))
  (define result-chunked0 (http-get (string-append base-url "/foo bar")))
  (define result-chunked1 (http-get (string-append base-url "/foo bar") #f #t))
  (define result-chunked2 (http-get (string-append base-url "/foo%20bar") #f #f))

  (test-equal "/chunked/foo bar"
              (u8vector->string
                (vector-ref result-chunked0 1)))

  (test-equal result-chunked0 result-chunked1)
  (test-equal result-chunked0 result-chunked2))

(let ((base-url (string-append "http://localhost:" port-number "/close")))
  (define result-empty (http-get base-url))
  (test-eqv 0 (u8vector-length (vector-ref result-empty 1))))

;; Server terminate
(test-assert
  (with-exception-handler
    (lambda (exn)
      #f)

    (lambda ()
      (thread-join! (vector-ref http-server 1) 1))))

;; Invalid URL
(test-error (http-get "//localhost"))
(test-error (http-get "localhost"))

;;;============================================================================
