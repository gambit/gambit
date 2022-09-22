;;;============================================================================

;;; File: "_http.scm"

;;; Copyright (c) 2019-2020 by Frédéric Hamel, All Rights Reserved.
;;; Copyright (c) 2020-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##supply-module _http)

(declare
  (not safe)
  (standard-bindings)
  (extended-bindings))

(##namespace ("_http#"))
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/gambit#.scm")
(##include "~~lib/_gambit#.scm") ;; for macro-check-string

(##import _tar)
(##import _uri)
(##import _zlib)

;; Representation of exception

(define-type http-exception
  id: CAEA867E-9D31-4D36-A350-CCB9C78F9445
  constructor: macro-make-http-exception
  copier: #f
  opaque:
  macros:
  prefix: macro-

  (message read-only: no-functional-setter:))

;; ----------------------------------------------------------------------------

(define-macro (CR) #\return)
(define-macro (LF) #\newline)
(define-macro (CRLF) "\r\n")

;; string-utility

(define (string-index-of str c)
  (let ((str-len (string-length str)))
    (and (< 0 str-len)
      (let loop ((i 0))
        (if (char=? (string-ref str i) c)
            i
            (let ((next (+ i 1)))
              (and (< next str-len)
                   (loop next))))))))

;; ----------------------------------------------------------------------------

(define (parse-http-header port)
  (define (validate-char? chr expected)
    (and (char? chr)
         (char=? chr expected)))

  (let loop ((status+msg #f)
             (rev-header '()))
    (let ((line (read-line port (CR))))
      (if (string? line)
          (if (validate-char? (read-char port) (LF))
              (cond ((= 0 (string-length line))
                     (vector status+msg
                             (reverse rev-header)))

                    ((and (not status+msg)
                          (or (##string-prefix-strip "HTTP/1.0 " line)
                              (##string-prefix-strip "HTTP/1.1 " line)))
                     =>
                     (lambda (rest)
                       (let ((end-of-status (string-index-of rest #\space)))
                         (if end-of-status
                             (loop (cons
                                     (string->number (substring rest 0 end-of-status))
                                     (substring rest (+ end-of-status 1) (string-length rest)))
                                   rev-header)

                             (raise (macro-make-http-exception "Invalid HTTP status"))))))

                    (else
                      (let* ((pos-colon (string-index-of line #\:))
                             (line-len (string-length line))
                             (header-field (string->symbol (string-foldcase (substring line 0 pos-colon))))
                             (header-value (let loop1 ((non-space-pos (+ pos-colon 1)))
                                             (if (and (< non-space-pos (string-length line))
                                                      (char=? (string-ref line non-space-pos) #\space))
                                                 (loop1 (+ non-space-pos 1))
                                                 (substring line non-space-pos line-len)))))

                        (loop status+msg
                              (cons
                                (cons header-field
                                      (case header-field
                                        ((content-length)
                                         (let ((val (string->number header-value)))
                                           (if val
                                             val
                                             (raise (macro-make-http-exception "Invalid content-length data type")))))

                                        ((transfer-encoding)
                                         (let ((transfer-encoding (string->symbol header-value)))
                                           (case transfer-encoding
                                             ((identity chunked)
                                              transfer-encoding)
                                             (else
                                               (raise (macro-make-http-exception
                                                        (string-append "Unimplemented Transfer-Encoding " header-value)))))))

                                        (else header-value)))
                                rev-header)))))

              (raise (macro-make-http-exception "Incomplete http header received")))

          (raise (macro-make-http-exception "Incomplete http header received"))))))

(define (parse-http-body port header)
  (define (validate-char? chr expected)
    (and (char? chr)
         (char=? chr expected)))

  (define (CHECK-CRLF p)
    (or (and (validate-char? (read-char p) (CR))
             (validate-char? (read-char p) (LF)))
        (raise (macro-make-http-exception "Expecting cr-lf"))))

  (define (CHECK-LF p)
    (or (char=? (read-char p) (LF))
        (raise (macro-make-http-exception "\\n expected after \\r"))))

  (define (invalid-chunk-error msg)
    (close-port port)
    (raise (macro-make-http-exception
             (string-append "Invalid chunk " msg))))

  (define (done p val)
    (close-port p)
    (list->u8vector (map char->integer (string->list val))))

  (define (read-chunk-header p)
    (define (done-header val)
      (if (< 0 (string-length val))
          (##string-split-at-char val #\;)
          (invalid-chunk-error)))

    (let loop ((rev-result '()))
      (let ((line (read-line p (CR) #t)))
        (if (eof-object? line)
          (invalid-chunk-error)

          (if (validate-char? (peek-char p) (LF))
              (begin
                (read-char p)
                (string-shrink! line (- (string-length line) 1))

                (done-header
                  (if (null? rev-result)
                    line
                    (string-concatenate (reverse (cons line rev-result))))))

              (loop (cons line rev-result)))))))

  (define (read-chunked-body p)
    (let loop ((rev-result '()) (total 0))
      (let* ((parts (read-chunk-header p))
             (len (string->number (car parts) 16)))
        (if len
          (if (< 0 len)
            (let ((buf (make-string len)))
              (read-substring buf 0 len p)
              (CHECK-CRLF p)
              (loop (cons buf rev-result) (+ total len)))

            (let ((trailing-chunk (read-line p)))
              (if (and (string? trailing-chunk)
                       (string=? trailing-chunk "\r"))
                (done p (string-concatenate (reverse rev-result)))
                (raise (macro-make-http-exception "Missing trailing chunk")))))

          (begin
            (close-port p)
            (raise (macro-make-http-exception "Invalid chunk size")))))))


  (let ((transfer-encoding (cond
                             ((assoc 'transfer-encoding header)
                              => cdr)
                             (else 'identity)))

        (content-length (cond
                          ((assoc 'content-length header)
                           => cdr)
                          (else #f)))

        (content-type (assoc 'content-type header)))

    (case transfer-encoding
      ((chunked)
       (read-chunked-body port))

      ((identity)
       (if content-length
         (let ((buf (make-string content-length)))
           (read-substring buf 0 content-length port)
           (done port buf))
         (raise (macro-make-http-exception "No content-length supplied"))))

      (else
        (raise (macro-make-http-exception
                 (string-append "Unimplemented transfer-encoding "
                                (symbol->string transfer-encoding))))))))





;;; (http-get (list host: "foo.com" port: 80)
(define (http-get-aux url ver encode?)
  (let ((uri (string->uri (if encode?
                            (encode-for-uri url)
                            url) #f)))
    (if (not uri)
      (raise (macro-make-http-exception
               (string-append "Invalid url '" url "'")))
      (let* ((scheme (or (uri-scheme uri) (raise (macro-make-http-exception "No scheme"))))
             (host+port
              (##string-split-at-char (or (uri-authority uri)
                                          (raise (macro-make-http-exception "No authority"))) #\:))
             (tls-context (cond
                            ((string=? scheme "https")
                             (make-tls-context))
                            ((string=? scheme "http")
                             #f)
                            (else
                              (raise
                                (macro-make-http-exception "Invalid HTTP scheme"))))))


        (let* ((host (car host+port))
               (port-number (if (null? (cdr host+port))
                              (if tls-context
                                443 ;; https port
                                80) ;; http port
                              (string->number (cadr host+port))))
               (path (uri-path uri))

               (port (##open-tcp-client
                      #t
                      (lambda (port) port)
                      http-get
                      (cons
                       address:
                       (cons
                        host
                        (cons
                         port-number:
                         (cons
                          port-number
                          (cons
                           char-encoding:
                           (cons
                            'ISO-8859-1
                            (if tls-context
                                (list tls-context: tls-context)
                                '())))))))))
               (eol (CRLF)))

          (print
            port: port
            (list
              "GET " path " " ver eol
              "Host: " host eol
              eol))

          ;(display "GET " port)
          ;(display path port)
          ;(display " " port)
          ;(display ver port)
          ;(display "\r\nHost: " port)
          ;(display host port)
          ;(display "\r\n\r\n" port)
          (force-output port)

          (let* ((header (parse-http-header port))
                 (body (parse-http-body port (vector-ref header 1))))
            (close-port port)
            (vector header body)))))))

(define (http-get url
                  #!optional
                  (ver (macro-absent-obj))
                  (enc? (macro-absent-obj)))
  (macro-force-vars (url ver)
    (let ((http-version (if (or (eq? ver (macro-absent-obj))
                                (eq? ver #f))
                          'HTTP/1.1
                          ver))
          (encode? (if (eq? enc? (macro-absent-obj))
                     #t
                     enc?)))
      (macro-check-string
        url
        1
        (http-get url ver enc?)
        (macro-check-symbol
          http-version
          3
          (http-get url ver enc?)
          (http-get-aux url http-version encode?))))))

