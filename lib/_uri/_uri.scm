;;;============================================================================

;;; File: "_uri.scm"

;;; Copyright (c) 2019 by Frédéric Hamel, All Rights Reserved.

;;;============================================================================

(##supply-module _uri)

(declare (not safe))
(declare (standard-bindings))
(declare (extended-bindings))


(##namespace ("_uri#"))
(##include "~~lib/_prim#.scm")

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
                    (string-set! result j c #;(if (char=? c #\+) #\space c))
                    (loop (+ i 1)
                          (+ j 1)))))
            result)))))

(define-type uri
  id: 62788556-c247-11d9-9598-00039301ba52

  scheme
  slashes
  authority
  path
  query
  fragment
)

(define parse-uri
  (lambda (str start end decode? cont)
    (let ((uri (make-uri #f #f #f "/" #f #f)))

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
                                        (begin
                                          (uri-slashes-set! uri #t)
                                          (state1 (+ j 3) (+ j 3) 0))
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
                (cond #;((char=? c #\space)
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

