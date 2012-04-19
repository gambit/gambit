;;;============================================================================

;;; File: "json.scm"

;;; Copyright (c) 2011 by Marc Feeley, All Rights Reserved.

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

(define (json-read port)

  (define (create-object props)
    (list->table props))

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
                      ((and (char>=? c #\a) (char<=? c #\Z))
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
                     #f))
                ((eqv? c #\t)
                 (rd)
                 (if (not (and (eqv? (rd) #\r)
                               (eqv? (rd) #\u)
                               (eqv? (rd) #\e)))
                     json-error
                     #t))
                ((eqv? c #\n)
                 (rd)
                 (if (not (and (eqv? (rd) #\u)
                               (eqv? (rd) #\l)
                               (eqv? (rd) #\l)))
                     json-error
                     '()))
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

  (define string-escapes
    '((#\" . #\")
      (#\\ . #\\)
      (#\/ . #\/)
      (#\b . #\x08)
      (#\t . #\x09)
      (#\n . #\x0A)
      (#\v . #\x0B)
      (#\f . #\x0C)
      (#\r . #\x0D)))

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
                     (let ((e (assv x string-escapes)))
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

(define json-error
  'json-error)

(define (json-error? x)
  (eq? x json-error))

;;;============================================================================
