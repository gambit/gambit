;==============================================================================

; File: "http.scm"

; Copyright (c) 2005-2019 by Marc Feeley, All Rights Reserved.

;==============================================================================

(##namespace ("http#"))

(##include "~~lib/gambit#.scm")
(##include "html#.scm")

(##include "http#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (not safe)
)

;==============================================================================

; Token tables.

(define hash-substring
  (lambda (str start end)

    (define loop
      (lambda (h i)
        (if (< i end)
            (loop (modulo (+ (* h 5063) (char->integer (string-ref str i)))
                          65536)
                  (+ i 1))
            h)))

    (loop 0 start)))

(define-macro (make-token-table . alist)

  ; "alist" is a list of lists of the form "(string expression)"

  ; The result is a perfect hash-table represented as a vector of
  ; length 2*N, where N is the hash modulus.  If the string S is in
  ; the hash-table it is at index
  ;
  ;   X = (* 2 (modulo (hash-substring S 0 (string-length S)) N))
  ;
  ; and the associated expression is at index X+1.

  (define hash-substring    ; repeated from above to be
    (lambda (str start end) ; available for macro expansion

      (define loop
        (lambda (h i)
          (if (< i end)
              (loop (modulo (+ (* h 5063) (char->integer (string-ref str i)))
                            65536)
                    (+ i 1))
              h)))

      (loop 0 start)))

  (define make-perfect-hash-table
    (lambda (alist)
      (let loop1 ((n (length alist)))
        (let ((v (make-vector (* 2 n) #f)))
          (let loop2 ((lst alist))
            (if (pair? lst)
                (let* ((x (car lst))
                       (str (car x)))
                  (let ((h
                         (* 2
                            (modulo (hash-substring str 0 (string-length str))
                                    n))))
                    (if (vector-ref v h)
                        (loop1 (+ n 1))
                        (begin
                          (vector-set! v h str)
                          (vector-set! v (+ h 1) (cadr x))
                          (loop2 (cdr lst))))))
                v))))))

    (cons 'vector (vector->list (make-perfect-hash-table alist))))

(define token-table-lookup-substring
  (lambda (table str start end)
    (let* ((n (quotient (vector-length table) 2))
           (h (* 2 (modulo (hash-substring str start end) n)))
           (x (vector-ref table h)))

      (define loop
        (lambda (i j)
          (if (< i end)
              (if (char=? (string-ref str i) (string-ref x j))
                  (loop (+ i 1) (+ j 1))
                  #f)
              h)))

      (and x
           (= (string-length x) (- end start))
           (loop start 0)))))

(define token-table-lookup-string
  (lambda (table str)
    (token-table-lookup-substring table str 0 (string-length str))))

;==============================================================================

; URI parsing.

(define hex-digit
  (lambda (str i)
    (let ((n (char->integer (string-ref str i))))
      (cond ((and (>= n 48) (<= n 57))
             (- n 48))
            ((and (>= n 65) (<= n 70))
             (- n 55))
            ((and (>= n 97) (<= n 102))
             (- n 87))
            (else
             #f)))))

(define hex-octet
  (lambda (str i)
    (let ((n1 (hex-digit str i)))
      (and n1
           (let ((n2 (hex-digit str (+ i 1))))
             (and n2
                  (+ (* n1 16) n2)))))))

(define plausible-hex-escape?
  (lambda (str end j)
    (and (< (+ j 2) end)
         (not (control-or-space-char? (string-ref str (+ j 1))))
         (not (control-or-space-char? (string-ref str (+ j 2)))))))

(define control-or-space-char?
  (lambda (c)
    (or (not (char<? #\space c))
        (not (char<? c #\x7f)))))

(define excluded-char?
  (lambda (c)
    (or (not (char<? #\space c))
        (not (char<? c #\x7f))
        (char=? c #\<)
        (char=? c #\>)
        (char=? c #\#)
        (char=? c #\%)
        (char=? c #\")
        (char=? c #\{)
        (char=? c #\})
        (char=? c #\|)
        (char=? c #\\)
        (char=? c #\^)
        (char=? c #\[)
        (char=? c #\])
        (char=? c #\`))))

(define extract-escaped
  (lambda (str start n)
    (let ((result (make-string n)))
      (let loop ((i start) (j 0))
        (if (< j n)
            (let ((c (string-ref str i)))
              (if (char=? c #\%)
                  (let ((n (hex-octet str (+ i 1))))
                    (and n
                         (begin
                           (string-set! result j (integer->char n))
                           (loop (+ i 3)
                                 (+ j 1)))))
                  (begin
                    (string-set! result j (if (char=? c #\+) #\space c))
                    (loop (+ i 1)
                          (+ j 1)))))
            result)))))

(define-type uri
  id: 62788556-c247-11d9-9598-00039301ba52

  scheme
  authority
  path
  query
  fragment
)

(define parse-uri
  (lambda (str start end decode? cont)
    (let ((uri (make-uri #f #f "" #f #f)))

      (define extract-string
        (lambda (i j n)
          (if decode?
              (extract-escaped str i n)
              (substring str i j))))

      (define extract-query
        (lambda (i j n)
          (if decode?
              (parse-uri-query
               str
               i
               j
               decode?
               (lambda (bindings end)
                 bindings))
              (substring str i j))))

      (define state0 ; possibly inside the "scheme" part
        (lambda (i j n)
          (if (< j end)
              (let ((c (string-ref str j)))
                (cond ((char=? c #\:)
                       (if (= n 0)
                           (state2 j (+ j 1) 1) ; the ":" is in the "path" part
                           (let ((scheme (extract-string i j n)))
                             (and scheme
                                  (begin
                                    (uri-scheme-set! uri scheme)
                                    (if (and (< (+ j 2) end)
                                             (char=? (string-ref str (+ j 1))
                                                     #\/)
                                             (char=? (string-ref str (+ j 2))
                                                     #\/))
                                        (state1 (+ j 3) (+ j 3) 0)
                                        (state2 (+ j 1) (+ j 1) 0)))))))
                      ((char=? c #\/)
                       (if (and (= n 0)
                                (< (+ j 1) end)
                                (char=? (string-ref str (+ j 1)) #\/))
                           (state1 (+ j 2) (+ j 2) 0)
                           (state2 i (+ j 1) (+ n 1))))
                      ((char=? c #\?)
                       (let ((path (extract-string i j n)))
                         (and path
                              (begin
                                (uri-path-set! uri path)
                                (state3 (+ j 1) (+ j 1) 0)))))
                      ((char=? c #\#)
                       (let ((path (extract-string i j n)))
                         (and path
                              (begin
                                (uri-path-set! uri path)
                                (state4 (+ j 1) (+ j 1) 0)))))
                      ((char=? c #\%)
                       (and (plausible-hex-escape? str end j)
                            (state0 i (+ j 3) (+ n 1))))
                      ((control-or-space-char? c)
                       (let ((path (extract-string i j n)))
                         (and path
                              (begin
                                (uri-path-set! uri path)
                                j))))
                      (else
                       (state0 i (+ j 1) (+ n 1)))))
              (let ((path (extract-string i j n)))
                (and path
                     (begin
                       (uri-path-set! uri path)
                       j))))))

      (define state1 ; inside the "authority" part
        (lambda (i j n)
          (if (< j end)
              (let ((c (string-ref str j)))
                (cond ((char=? c #\/)
                       (let ((authority (extract-string i j n)))
                         (and authority
                              (begin
                                (uri-authority-set! uri authority)
                                (state2 j (+ j 1) 1)))))
                      ((char=? c #\?)
                       (let ((authority (extract-string i j n)))
                         (and authority
                              (begin
                                (uri-authority-set! uri authority)
                                (state3 (+ j 1) (+ j 1) 0)))))
                      ((char=? c #\#)
                       (let ((authority (extract-string i j n)))
                         (and authority
                              (begin
                                (uri-authority-set! uri authority)
                                (state4 (+ j 1) (+ j 1) 0)))))
                      ((char=? c #\%)
                       (and (plausible-hex-escape? str end j)
                            (state1 i (+ j 3) (+ n 1))))
                      ((control-or-space-char? c)
                       (let ((authority (extract-string i j n)))
                         (and authority
                              (begin
                                (uri-authority-set! uri authority)
                                j))))
                      (else
                       (state1 i (+ j 1) (+ n 1)))))
              (let ((authority (extract-string i j n)))
                (and authority
                     (begin
                       (uri-authority-set! uri authority)
                       j))))))

      (define state2 ; inside the "path" part
        (lambda (i j n)
          (if (< j end)
              (let ((c (string-ref str j)))
                (cond ((char=? c #\?)
                       (let ((path (extract-string i j n)))
                         (and path
                              (begin
                                (uri-path-set! uri path)
                                (state3 (+ j 1) (+ j 1) 0)))))
                      ((char=? c #\#)
                       (let ((path (extract-string i j n)))
                         (and path
                              (begin
                                (uri-path-set! uri path)
                                (state4 (+ j 1) (+ j 1) 0)))))
                      ((char=? c #\%)
                       (and (plausible-hex-escape? str end j)
                            (state2 i (+ j 3) (+ n 1))))
                      ((control-or-space-char? c)
                       (let ((path (extract-string i j n)))
                         (and path
                              (begin
                                (uri-path-set! uri path)
                                j))))
                      (else
                       (state2 i (+ j 1) (+ n 1)))))
              (let ((path (extract-string i j n)))
                (and path
                     (begin
                       (uri-path-set! uri path)
                       j))))))

      (define state3 ; inside the "query" part
        (lambda (i j n)
          (if (< j end)
              (let ((c (string-ref str j)))
                (cond ((char=? c #\#)
                       (let ((query (extract-query i j n)))
                         (and query
                              (begin
                                (uri-query-set! uri query)
                                (state4 (+ j 1) (+ j 1) 0)))))
                      ((char=? c #\%)
                       (and (plausible-hex-escape? str end j)
                            (state3 i (+ j 3) (+ n 1))))
                      ((control-or-space-char? c)
                       (let ((query (extract-query i j n)))
                         (and query
                              (begin
                                (uri-query-set! uri query)
                                j))))
                      (else
                       (state3 i (+ j 1) (+ n 1)))))
              (let ((query (extract-query i j n)))
                (and query
                     (begin
                       (uri-query-set! uri query)
                       j))))))

      (define state4 ; inside the "fragment" part
        (lambda (i j n)
          (if (< j end)
              (let ((c (string-ref str j)))
                (cond ((char=? c #\%)
                       (and (plausible-hex-escape? str end j)
                            (state4 i (+ j 3) (+ n 1))))
                      ((control-or-space-char? c)
                       (let ((fragment (extract-string i j n)))
                         (and fragment
                              (begin
                                (uri-fragment-set! uri fragment)
                                j))))
                      (else
                       (state4 i (+ j 1) (+ n 1)))))
              (let ((fragment (extract-string i j n)))
                (and fragment
                     (begin
                       (uri-fragment-set! uri fragment)
                       j))))))

      (let ((i (state0 start start 0)))
        (cont (and i uri)
              (or i start))))))

(define parse-uri-query
  (lambda (str start end decode? cont)
    (let ((rev-bindings '()))

      (define extract-string
        (lambda (i j n)
          (if decode?
              (extract-escaped str i n)
              (substring str i j))))

      (define state0
        (lambda (i j n)
          (if (< j end)
            (let ((c (string-ref str j)))
              (cond ((char=? c #\%)
                     (and (plausible-hex-escape? str end j)
                          (state0 i
                                  (+ j 3)
                                  (+ n 1))))
                    ((char=? c #\=)
                     (let ((name (extract-string i j n)))
                       (and name
                            (let ((j (+ j 1)))
                              (state1 j
                                      j
                                      0
                                      name)))))
                    ((char=? c #\&)
                     #f)
                    ((excluded-char? c)
                     (if (= n 0)
                         j
                         #f))
                    (else
                     (state0 i
                             (+ j 1)
                             (+ n 1)))))
            (if (= n 0)
                j
                #f))))

      (define state1
        (lambda (i j n name)
          (if (< j end)
            (let ((c (string-ref str j)))
              (cond ((char=? c #\%)
                     (and (plausible-hex-escape? str end j)
                          (state1 i
                                  (+ j 3)
                                  (+ n 1)
                                  name)))
                    ((char=? c #\&)
                     (let ((val (extract-string i j n)))
                       (and val
                            (let ((j (+ j 1)))
                              (set! rev-bindings
                                    (cons (cons name val) rev-bindings))
                              (and (< j end)
                                   (state0 j
                                           j
                                           0))))))
                    ((char=? c #\=)
                     #f)
                    ((excluded-char? c)
                     (let ((val (extract-string i j n)))
                       (and val
                            (begin
                              (set! rev-bindings
                                    (cons (cons name val) rev-bindings))
                              j))))
                    (else
                     (state1 i
                             (+ j 1)
                             (+ n 1)
                             name))))
            (let ((val (extract-string i j n)))
              (and val
                   (begin
                     (set! rev-bindings
                           (cons (cons name val) rev-bindings))
                     j))))))

      (let ((i (state0 start start 0)))
        (cont (and i (reverse rev-bindings))
              (or i start))))))

(define string->uri
  (lambda (str decode?)
    (parse-uri str
               0
               (string-length str)
               decode?
               (lambda (uri end)
                 (and (= end (string-length str))
                      uri)))))

(define string->uri-query
  (lambda (str decode?)
    (parse-uri-query str
                     0
                     (string-length str)
                     decode?
                     (lambda (query end)
                       (and (= end (string-length str))
                            query)))))

(define encode-for-uri
  (lambda (str)
    (let ((end (string-length str)))

      (define copy
        (lambda (result i j n)
          (if (< i j)
              (let ((new-j (- j 1))
                    (new-n (- n 1)))
                (string-set! result new-n (string-ref str new-j))
                (copy result i new-j new-n))
              result)))

      (define hex
        (lambda (x)
          (string-ref "0123456789ABCDEF" (bitwise-and x 15))))

      (define encode
        (lambda (i j n)
          (if (< j end)
              (let ((c (string-ref str j)))
                (cond ((char=? c #\space)
                       (let ((result (encode (+ j 1) (+ j 1) (+ n 1))))
                         (string-set! result n #\+)
                         (copy result i j n)))
                      ((or (char=? c #\+)
                           (excluded-char? c))
                       (let ((result (encode (+ j 1) (+ j 1) (+ n 3))))
                         (let* ((x (char->integer c))
                                (hi (hex (arithmetic-shift x -4)))
                                (lo (hex x)))
                           (string-set! result n #\%)
                           (string-set! result (+ n 1) hi)
                           (string-set! result (+ n 2) lo))
                         (copy result i j n)))
                      (else
                       (encode i (+ j 1) (+ n 1)))))
              (let ((result (make-string n)))
                (copy result i j n)))))

      (encode 0 0 0))))

;==============================================================================

; x-www-form-urlencoded encoding and decoding.

(define encode-x-www-form-urlencoded
  (lambda (fields)

    (define write-urlencoded
      (lambda (str)

        (define write-nibble
          (lambda (n)
            (write-char (string-ref "0123456789ABCDEF" n))))

        (let loop ((i 0))
          (if (< i (string-length str))
              (let ((c (string-ref str i)))
                (cond ((or (and (char>=? c #\a) (char<=? c #\z))
                           (and (char>=? c #\A) (char<=? c #\Z))
                           (and (char>=? c #\0) (char<=? c #\9)))
                       (write-char c))
                      ((char=? c #\space)
                       (write-char #\+))
                      (else
                       (let ((n (char->integer c)))
                         (write-char #\%)
                         (write-nibble
                          (bitwise-and (arithmetic-shift n -4) 15))
                         (write-nibble (bitwise-and n 15)))))
                (loop (+ i 1)))))))

    (define write-field
      (lambda (field)
        (write-urlencoded (car field))
        (write-char #\=)
        (write-urlencoded (cdr field))))

    (if (null? fields)
        ""
        (with-output-to-string
          ""
          (lambda ()
            (let ((field1 (car fields)))
              (write-field field1)
              (for-each (lambda (field)
                          (write-char #\&)
                          (write-field field))
                        (cdr fields))))))))

(define decode-x-www-form-urlencoded
  (lambda (str)
    (let ((n (string-length str)))

      (define extract
        (lambda (start len)
          (let ((s (make-string len)))
            (let loop ((i start) (j 0))
              (if (< j len)
                  (let ((c (string-ref str i)))
                    (cond ((char=? c #\%)
                           (cond ((hex (+ i 1))
                                  =>
                                  (lambda (x)
                                    (string-set! s j (integer->char x))
                                    (loop (+ i 3) (+ j 1))))
                                 (else
                                  #f)))
                          ((char=? c #\+)
                           (string-set! s j #\space)
                           (loop (+ i 1) (+ j 1)))
                          (else
                           (string-set! s j c)
                           (loop (+ i 1) (+ j 1)))))
                  s)))))

      (define hex
        (lambda (i)
          (if (< (+ i 1) n)
              (let ((h1 (nibble i))
                    (h2 (nibble (+ i 1))))
                (and h1 h2 (+ (* h1 16) h2)))
              #f)))

      (define nibble
        (lambda (i)
          (let ((c (string-ref str i)))
            (cond ((and (char>=? c #\0) (char<=? c #\9))
                   (- (char->integer c) (char->integer #\0)))
                  ((and (char>=? c #\a) (char<=? c #\f))
                   (+ 10 (- (char->integer c) (char->integer #\a))))
                  ((and (char>=? c #\A) (char<=? c #\F))
                   (+ 10 (- (char->integer c) (char->integer #\A))))
                  (else
                   #f)))))

      (define state0 ; at beginning of string
        (lambda (i rev-fields)
          (if (< i n)
              (state1 i
                      i
                      0
                      rev-fields)
              (reverse rev-fields))))

      (define state1 ; in field name
        (lambda (i start len rev-fields)
          (if (< i n)
              (let ((c (string-ref str i)))
                (cond ((char=? c #\=)
                       (state2 (+ i 1)
                               (+ i 1)
                               0
                               (extract start len)
                               rev-fields))
                      ((char=? c #\%)
                       (and (hex (+ i 1))
                            (state1 (+ i 3)
                                    start
                                    (+ len 1)
                                    rev-fields)))
                      (else
                       (state1 (+ i 1)
                               start
                               (+ len 1)
                               rev-fields))))
              #f)))

      (define state2 ; in field value
        (lambda (i start len name rev-fields)

          (define end-of-field
            (lambda ()
              (cons (cons name (extract start len))
                    rev-fields)))

          (if (< i n)
              (let ((c (string-ref str i)))
                (cond ((char=? c #\&)
                       (state1 (+ i 1)
                               (+ i 1)
                               0
                               (end-of-field)))
                      ((char=? c #\%)
                       (and (hex (+ i 1))
                            (state2 (+ i 3)
                                    start
                                    (+ len 1)
                                    name
                                    rev-fields)))
                      (else
                       (state2 (+ i 1)
                               start
                               (+ len 1)
                               name
                               rev-fields))))
              (reverse (end-of-field)))))

      (state0 0 '()))))

;==============================================================================

; HTTP server.

(define-type server
  id: c69165bd-c13f-11d9-830f-00039301ba52

  port-number
  timeout
  threaded?
  method-table
)

(define-type request
  id: 8e66862f-c143-11d9-9f4e-00039301ba52

  (server unprintable:)
  connection
  method
  uri
  version
  attributes
  query
)

(define make-http-server
  (lambda (#!key
           (port-number 80)
           (timeout     300)
           (threaded?   #f)
           (OPTIONS     unimplemented-method)
           (GET         unimplemented-method)
           (HEAD        unimplemented-method)
           (POST        unimplemented-method)
           (PUT         unimplemented-method)
           (DELETE      unimplemented-method)
           (TRACE       unimplemented-method)
           (CONNECT     unimplemented-method))
    (make-server
     port-number
     timeout
     threaded?
     (make-token-table
      ("OPTIONS" OPTIONS)
      ("GET"     GET)
      ("HEAD"    HEAD)
      ("POST"    POST)
      ("PUT"     PUT)
      ("DELETE"  DELETE)
      ("TRACE"   TRACE)
      ("CONNECT" CONNECT)))))

(define http-server-start!
  (lambda (hs)
    (let ((server-port
           (open-tcp-server
            (list server-address: '#u8(127 0 0 1) ; on localhost interface only
                  port-number: (server-port-number hs)
                  backlog: 128
                  reuse-address: #t
                  char-encoding: 'ISO-8859-1))))
      (accept-connections hs server-port))))

(define accept-connections
  (lambda (hs server-port)
    (let loop ()
      (let ((connection
             (read server-port)))
        (if (server-threaded? hs)
            (let ((dummy-port (open-dummy)))
              (parameterize ((current-input-port dummy-port)
                             (current-output-port dummy-port))
                (thread-start!
                 (make-thread
                  (lambda ()
                    (serve-connection hs connection))))))
            (serve-connection hs connection)))
      (loop))))

(define send-error
  (lambda (connection html)
    (write-html html connection)
    (close-port connection)))

(define method-not-implemented-error
  (lambda (connection)
    (send-error
     connection
     (<html> (<head> (<title> "501 Method Not Implemented"))
             (<body>
              (<h1> "Method Not Implemented"))))))

(define unimplemented-method
  (lambda ()
    (let* ((request (current-request))
           (connection (request-connection request)))
      (method-not-implemented-error connection))))

(define bad-request-error
  (lambda (connection)
    (send-error
     connection
     (<html> (<head> (<title> "400 Bad Request"))
             (<body>
              (<h1> "Bad Request")
              (<p> "Your browser sent a request that this server could "
                   "not understand."
                   (<br>)))))))

(define reply
  (lambda (thunk)
    (let* ((request
            (current-request))
           (connection
            (request-connection request))
           (version
            (request-version request)))

      (define generate-reply
        (lambda (port)
          (if (or (eq? version 'HTTP/1.0)
                  (eq? version 'HTTP/1.1))
              (let ((message
                     (with-output-to-u8vector
                      '(char-encoding: ISO-8859-1
                        eol-encoding: cr-lf)
                      thunk))
                    (eol
                     "\r\n"))
                (print
                 port: port
                 (list version " 200 OK" eol
                       "Content-Length: " (u8vector-length message) eol
                       "Content-Type: text/html; charset=ISO-8859-1" eol
                       "Connection: close" eol
                       eol))
                (write-subu8vector
                 message
                 0
                 (u8vector-length message)
                 port))
              (with-output-to-port port thunk))))

      (define debug? #f)

      (if (not debug?)
          (generate-reply connection)
          (let ((output
                 (call-with-output-u8vector
                  '#u8()
                  (lambda (port) (generate-reply port)))))
            (write-subu8vector output 0 (u8vector-length output) ##stdout-port)
            (force-output ##stdout-port)
            (write-subu8vector output 0 (u8vector-length output) connection)))

      (close-port connection))))

(define reply-html
  (lambda (html)
    (reply (lambda () (write-html html)))))

(define current-request
  (lambda ()
    (thread-specific (current-thread)))) ; request is stored in thread

;------------------------------------------------------------------------------

(define serve-connection
  (lambda (hs connection)

    ; Configure the connection with the client so that if we can't
    ; read the request after 300 seconds, the read operation will fail
    ; (and the thread will terminate).

    (input-port-timeout-set! connection 300)

    ; Configure the connection with the client so that if we can't
    ; write the response after 300 seconds, the write operation will
    ; fail (and the thread will terminate).

    (output-port-timeout-set! connection 300)

    (let ((req (permissive-read-line connection)))
      (if (not (string? req))
          (bad-request-error connection)
          (let* ((end
                  (let loop ((i 0))
                    (cond ((= i (string-length req))
                           #f)
                          ((char=? (string-ref req i) #\space)
                           i)
                          (else
                           (loop (+ i 1))))))
                 (method-index
                  (and end
                       (token-table-lookup-substring
                        (server-method-table hs)
                        req
                        0
                        end))))
            (if method-index

                (parse-uri
                 req
                 (+ end 1)
                 (string-length req)
                 #t
                 (lambda (uri i)

                   (define handle-version
                     (lambda (version)
                       (case version
                         ((HTTP/1.0 HTTP/1.1)
                          (let ((attributes (read-header connection)))
                            (if attributes
                                (handle-request version attributes)
                                (bad-request-error connection))))
                         ((#f)
                          ; this is an HTTP/0.9 request
                          (handle-request 'HTTP/0.9 '()))
                         (else
                          (bad-request-error connection)))))

                   (define handle-request
                     (lambda (version attributes)
                       (let* ((method-table
                               (server-method-table hs))
                              (method-name
                               (vector-ref method-table method-index))
                              (method-action
                               (vector-ref method-table (+ method-index 1)))
                              (content
                               (read-content connection attributes))
                              (query
                               (let ((x (assoc "Content-Type" attributes)))
                                 (if (and x
                                          (string=?
                                           (cdr x)
                                           "application/x-www-form-urlencoded"))
                                     (decode-x-www-form-urlencoded content)
                                     (uri-query uri)))))
                         (let ((request
                                (make-request
                                 hs
                                 connection
                                 method-name
                                 uri
                                 version
                                 attributes
                                 query)))
                           (thread-specific-set! (current-thread) request))
                         (method-action))))

                   (cond ((not uri)
                          (bad-request-error connection))
                         ((not (< i (string-length req)))
                          (handle-version #f))
                         ((not (char=? (string-ref req i) #\space))
                          (bad-request-error connection))
                         (else
                          (let ((version-index
                                 (token-table-lookup-substring
                                  version-table
                                  req
                                  (+ i 1)
                                  (string-length req))))
                            (if version-index
                                (handle-version
                                 (vector-ref version-table
                                             (+ version-index 1)))
                                (bad-request-error connection)))))))

                (method-not-implemented-error connection)))))))

(define version-table
  (make-token-table
   ("HTTP/1.0" 'HTTP/1.0)
   ("HTTP/1.1" 'HTTP/1.1)))

(define read-header
  (lambda (connection)
    (let loop ((attributes '()))
      (let ((line (permissive-read-line connection)))
        (cond ((not line)
               #f)
              ((= (string-length line) 0)
               attributes)
              (else
               (let ((attribute (split-attribute-line line)))
                 (if attribute
                     (loop (cons attribute attributes))
                     #f))))))))

(define read-content
  (lambda (connection attributes)
    (let ((cl
           (cond ((assoc "Content-Length" attributes)
                  =>
                  (lambda (x)
                    (let ((n (string->number (cdr x))))
                      (and n (integer? n) (exact? n) n))))
                 (else
                  #f))))
      (if cl
          (let ((str (make-string cl)))
            (let ((n (read-substring str 0 cl connection)))
              (if (= n cl)
                  str
                  "")))
          ""))))

(define permissive-read-line
  (lambda (port)
    (let ((s (read-line port)))
      (if (and (string? s)
               (> (string-length s) 0)
               (char=? (string-ref s (- (string-length s) 1)) #\return))
          ; efficient version of (substring s 0 (- (string-length s) 1))
          (begin (##string-shrink! s (- (string-length s) 1)) s)
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

;==============================================================================
