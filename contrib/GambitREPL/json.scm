;;;============================================================================

;;; File: "json.scm"

;;; Copyright (c) 2011-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("json#"))

(##include "~~lib/gambit#.scm")

(##include "json#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (fixnum)
  (not safe)
)

;;;============================================================================

(define use-symbols? #f) ;; how to encode JS true, false and null
(define use-tables? #t)  ;; how to encode JS objects

(define debug? #f)

(if debug?
    (set! ##wr
          (lambda (we obj)
            (##default-wr
             we
             (if (table? obj)
                 (cons 'TABLE (table->list obj))
                 obj)))))

(define (json-decode str)
  (call-with-input-string str json-read))

(define (json-encode obj)
  (call-with-output-string "" (lambda (port) (json-write obj port))))

(define (json-read port)

  (define (create-object props)
    (if use-tables?
        (list->table props)
        props))

  (define (create-array elements)
    (list->vector elements))

  (define (rd)
    (read-char port))

  (define (pk)
    (peek-char port))

  (define (accum c i str)
    (if (not (json-error? str))
        (string-set! str i c))
    str)

  (define (digit? c radix)
    (and (char? c)
         (let ((n
                (cond ((and (char>=? c #\0) (char<=? c #\9))
                       (- (char->integer c) (char->integer #\0)))
                      ((and (char>=? c #\a) (char<=? c #\z))
                       (+ 10 (- (char->integer c) (char->integer #\a))))
                      ((and (char>=? c #\A) (char<=? c #\Z))
                       (+ 10 (- (char->integer c) (char->integer #\A))))
                      (else
                       999))))
           (and (< n radix)
                n))))

  (define (space)
    (let ((c (pk)))
      (if (and (char? c)
               (char<=? c #\space))
          (begin (rd) (space)))))

  (define (parse-value)
    (space)
    (let ((c (pk)))
      (if (not (char? c))
          json-error
          (cond ((eqv? c #\{)
                 (parse-object))
                ((eqv? c #\[)
                 (parse-array))
                ((eqv? c #\")
                 (parse-string))
                ((or (eqv? c #\-) (digit? c 10))
                 (parse-number))
                ((eqv? c #\f)
                 (rd)
                 (if (not (and (eqv? (rd) #\a)
                               (eqv? (rd) #\l)
                               (eqv? (rd) #\s)
                               (eqv? (rd) #\e)))
                     json-error
                     (if use-symbols?
                         'false
                         #f)))
                ((eqv? c #\t)
                 (rd)
                 (if (not (and (eqv? (rd) #\r)
                               (eqv? (rd) #\u)
                               (eqv? (rd) #\e)))
                     json-error
                     (if use-symbols?
                         'true
                         #t)))
                ((eqv? c #\n)
                 (rd)
                 (if (not (and (eqv? (rd) #\u)
                               (eqv? (rd) #\l)
                               (eqv? (rd) #\l)))
                     json-error
                     (if use-symbols?
                         'null
                         '())))
                (else
                 json-error)))))

  (define (parse-object)
    (rd) ;; skip #\{
    (space)
    (if (eqv? (pk) #\})
        (begin (rd) (create-object '()))
        (let loop ((rev-elements '()))
          (let ((str (if (not (eqv? (pk) #\")) json-error (parse-string))))
            (if (json-error? str)
                str
                (begin
                  (space)
                  (if (not (eqv? (pk) #\:))
                      json-error
                      (begin
                        (rd)
                        (space)
                        (let ((val (parse-value)))
                          (if (json-error? val)
                              val
                              (let ((new-rev-elements
                                     (cons (cons str val) rev-elements)))
                                (space)
                                (let ((c (pk)))
                                  (cond ((eqv? c #\})
                                         (rd)
                                         (create-object
                                          (reverse new-rev-elements)))
                                        ((eqv? c #\,)
                                         (rd)
                                         (space)
                                         (loop new-rev-elements))
                                        (else
                                         json-error))))))))))))))

  (define (parse-array)
    (rd) ;; skip #\[
    (space)
    (if (eqv? (pk) #\])
        (begin (rd) (create-array '()))
        (let ((x (parse-value)))
          (if (json-error? x)
              x
              (let loop ((rev-elements (list x)))
                (space)
                (let ((c (pk)))
                  (cond ((eqv? c #\])
                         (rd)
                         (create-array (reverse rev-elements)))
                        ((eqv? c #\,)
                         (rd)
                         (let ((y (parse-value)))
                           (if (json-error? y)
                               y
                               (loop (cons y rev-elements)))))
                        (else
                         json-error))))))))

  (define (parse-string)

    (define (parse-str pos)
      (let ((c (rd)))
        (cond ((eqv? c #\")
               (make-string pos))
              ((eqv? c #\\)
               (let ((x (rd)))
                 (if (eqv? x #\u)
                     (let loop ((n 0) (i 4))
                       (if (> i 0)
                           (let ((h (rd)))
                             (cond ((not (char? h))
                                    json-error)
                                   ((digit? h 16)
                                    =>
                                    (lambda (d)
                                      (loop (+ (* n 16) d) (- i 1))))
                                   (else
                                    json-error)))
                           (accum (integer->char n) pos (parse-str (+ pos 1)))))
                     (let ((e (assv x json-string-escapes)))
                       (if e
                           (accum (cdr e) pos (parse-str (+ pos 1)))
                           json-error)))))
              ((char? c)
               (accum c pos (parse-str (+ pos 1))))
              (else
               json-error))))

    (rd) ;; skip #\"
    (parse-str 0))

  (define (parse-number)

    (define (sign-part)
      (let ((c (pk)))
        (if (eqv? c #\-)
            (begin (rd) (accum c 0 (after-sign-part 1)))
            (after-sign-part 0))))

    (define (after-sign-part pos)
      (if (not (digit? (pk) 10))
          json-error
          (integer-part pos)))

    (define (integer-part pos)
      (let ((c (pk)))
        (if (digit? c 10)
            (begin (rd) (accum c pos (integer-part (+ pos 1))))
            (if (eqv? c #\.)
                (begin (rd) (accum c pos (decimals-part (+ pos 1))))
                (exponent-part pos)))))

    (define (decimals-part pos)
      (let ((c (pk)))
        (if (digit? c 10)
            (begin (rd) (accum c pos (decimals-part (+ pos 1))))
            (exponent-part pos))))

    (define (exponent-part pos)
      (let ((c (pk)))
        (if (or (eqv? c #\e) (eqv? c #\E))
            (begin (rd) (accum c pos (exponent-sign-part (+ pos 1))))
            (done pos))))

    (define (exponent-sign-part pos)
      (let ((c (pk)))
        (if (or (eqv? c #\-) (eqv? c #\+))
            (begin (rd) (accum c pos (exponent-after-sign-part (+ pos 1))))
            (exponent-after-sign-part pos))))

    (define (exponent-after-sign-part pos)
      (if (not (digit? (pk) 10))
          json-error
          (exponent-integer-part pos)))

    (define (exponent-integer-part pos)
      (let ((c (pk)))
        (if (digit? c 10)
            (begin (rd) (accum c pos (exponent-integer-part (+ pos 1))))
            (done pos))))

    (define (done pos)
      (make-string pos))

    (let ((str (sign-part)))
      (if (json-error? str)
          str
          (string->number str))))

  (parse-value))

(define (json-write obj port)

  (define (wr-string s)
    (display #\" port)
    (let loop ((i 0) (j 0))
      (if (< j (string-length s))
          (let* ((c
                  (string-ref s j))
                 (n
                  (char->integer c))
                 (ctrl-char?
                  (or (<= n 31) (>= n 127)))
                 (x
                  (cond ((or (char=? c #\\)
                             (char=? c #\"))
                         c)
                        ((and ctrl-char?
                              (##assq-cdr c json-string-escapes))
                         =>
                         car)
                        (else
                         #f)))
                 (j+1
                  (+ j 1)))
            (if (or x ctrl-char?)
                (begin
                  (display (substring s i j) port)
                  (display #\\ port)
                  (if x
                      (begin
                        (display x port)
                        (loop j+1 j+1))
                      (begin
                        (display #\u port)
                        (display (substring (number->string (+ n #x10000) 16)
                                            1
                                            5)
                                 port)
                        (loop j+1 j+1))))
                (loop i j+1)))
          (begin
            (display (substring s i j) port)
            (display #\" port)))))

  (define (wr-prop prop)
    (wr-string (car prop))
    (display ":" port)
    (wr (cdr prop)))

  (define (wr-object obj)
    (wr-props (table->list obj)))

  (define (wr-props lst)
    (display "{" port)
    (if (pair? lst)
        (begin
          (wr-prop (car lst))
          (let loop ((lst (cdr lst)))
            (if (pair? lst)
                (begin
                  (display "," port)
                  (wr-prop (car lst))
                  (loop (cdr lst)))))))
    (display "}" port))

  (define (wr-array obj)
    (display "[" port)
    (let loop ((i 0))
      (if (< i (vector-length obj))
          (begin
            (if (> i 0) (display "," port))
            (wr (vector-ref obj i))
            (loop (+ i 1)))))
    (display "]" port))

  (define (wr-time obj)
    ;; this works when using JavaScript's eval to decode the object
    (display "new Date(" port)
    (display (* 1000 (time->seconds obj)) port)
    (display ")" port))

  (define (wr obj)

    (cond ((number? obj)
           (write (if (integer? obj) obj (exact->inexact obj)) port))

          ((string? obj)
           (wr-string obj))

          ((symbol? obj)
           (display (symbol->string obj) port))

          ((boolean? obj)
           (display (if obj "true" "false") port))

          ((and (not use-symbols?)
                (null? obj))
           (display "null" port))

          ((or (null? obj)
               (pair? obj))
           (wr-props obj))

          ((vector? obj)
           (wr-array obj))

          ((table? obj)
           (wr-object obj))

          ((time? obj)
           (wr-time obj))

          (else
           (error "unwritable object" obj))))

  (wr obj))

(define json-string-escapes
  '((#\" . #\")
    (#\\ . #\\)
    (#\/ . #\/)
    (#\b . #\x08)
    (#\t . #\x09)
    (#\n . #\x0A)
    (#\v . #\x0B)
    (#\f . #\x0C)
    (#\r . #\x0D)))

(define json-error
  'json-error)

(define (json-error? x)
  (eq? x json-error))

;;;============================================================================
