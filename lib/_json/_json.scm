;;;============================================================================

;;; File: "_json.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; JSON encoding/decoding.

(##supply-module _json)

(##namespace ("_json#"))                  ;; in _json#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;----------------------------------------------------------------------------

(##include "_json#.scm")

;;;----------------------------------------------------------------------------

(define-procedure (object->json-string
                   (obj object))
  (let ((port (open-output-string)))
    (write-json obj port)
    (get-output-string port)))

(define-procedure (write-json
                   (obj object)
                   (port character-output-port (macro-current-output-port)))

  (define (output str)
    (write-substring str 0 (string-length str) port))

  (define (output-quoted-string str)
    (output "\"")
    (let loop ((i 0) (j 0))

      (define (output-chunk)
        (write-substring str i j port))

      (if (fx< j (string-length str))
          (let ((c (string-ref str j)))
            (cond ((char<? c #\space)
                   (output-chunk)
                   (let ((n (char->integer c)))
                     (cond ((fx= 8 n)
                            (output "\\b"))
                           ((fx= 9 n)
                            (output "\\t"))
                           ((fx= 10 n)
                            (output "\\n"))
                           ((fx= 12 n)
                            (output "\\f"))
                           ((fx= 13 n)
                            (output "\\r"))
                           (else
                            (let ((hex (number->string (fx+ #x100000 n) 16)))
                              (string-set! hex 0 #\\)
                              (string-set! hex 1 #\u)
                              (output hex)))))
                   (loop (fx+ 1 j) (fx+ 1 j)))
                  ((or (char=? c #\\) (char=? c #\"))
                   (output-chunk)
                   (output "\\")
                   (loop j (fx+ 1 j)))
                  (else
                   (loop i (fx+ 1 j)))))
          (output-chunk)))
    (output "\""))

  (define (w obj)

    (cond ((eq? obj #f)
           (output "false"))

          ((eq? obj #t)
           (output "true"))

          ((eq? obj (void))
           (output "null"))

          ((null? obj)
           (output "[]"))

          ((pair? obj)
           (output "[")
           (w (car obj))
           (let loop ((probe (cdr obj)))
             (if (pair? probe)
                 (begin
                   (output ",")
                   (w (car probe))
                   (loop (cdr probe)))
                 (begin
                   (if (not (null? probe))
                       (begin
                         (output ",")
                         (w probe))))))
           (output "]"))

          ((vector? obj)
           (output "[")
           (let ((len (vector-length obj)))
             (if (fx> len 0)
                 (begin
                   (w (vector-ref obj 0))
                   (let loop ((i 1))
                     (if (fx< i len)
                         (begin
                           (output ",")
                           (w (vector-ref obj i))
                           (loop (fx+ i 1))))))))
           (output "]"))

          ((table? obj)
           (output "{")
           (let ((alist (table->list obj)))

             (define (output-prop key-val)
               (w (car key-val))
               (output ":")
               (w (cdr key-val)))

             (if (pair? alist)
                 (begin
                   (output-prop (car alist))
                   (let loop ((probe (cdr alist)))
                     (if (pair? probe)
                         (begin
                           (output ",")
                           (output-prop (car probe))
                           (loop (cdr probe))))))))
           (output "}"))

          ((number? obj)
           (if (and (real? obj) (finite? obj))
               (let ((str (number->string obj)))
                 ;; TODO: change Gambit's number->string to produce JSON syntax
                 (cond ((and (char=? (string-ref str 0) #\-)
                             (char=? (string-ref str 1) #\.))
                        (output "-0")
                        (output (substring str 1 (string-length str))))
                       ((char=? (string-ref str 0) #\.)
                        (output "0")
                        (output str))
                       ((char=? (string-ref str (fx- (string-length str) 1)) #\.)
                        (output (substring str 0 (fx- (string-length str) 1))))
                       (else
                        (output str))))
               (output "null")))

          ((string? obj)
           (output-quoted-string obj))

          ((symbol? obj)
           (output-quoted-string (symbol->string obj)))

          (else
           (error "write-json can't handle this type" obj))))

  (w obj))

(define-procedure (json-string->object
                   (str string)
                   (permissive? boolean #f))

  (define pos 0)

  (define (err)
    (error "json syntax error"))

  (define (peek-next-non-whitespace)
    (if (fx< pos (string-length str))
        (let ((c (string-ref str pos)))
          (if (if permissive?
                  (char<=? c #\space)
                  (or (char=? c #\space)
                      (char=? c #\newline)
                      (char=? c #\return)
                      (char=? c #\tab)))
              (begin
                (set! pos (fx+ 1 pos))
                (peek-next-non-whitespace))
              c))
        #\space))

  (define (read-array)
    ;; we know the lookahead character is #\[
    (set! pos (fx+ 1 pos)) ;; skip #\[
    (let ((c2 (peek-next-non-whitespace)))

      (define (read-elements n)
        (let ((c3 (peek-next-non-whitespace)))
          (cond ((char=? c3 #\])
                 (set! pos (fx+ 1 pos)) ;; skip #\]
                 (make-vector n))
                ((char=? c3 #\,)
                 (set! pos (fx+ 1 pos)) ;; skip #\,
                 (let* ((next (read-value))
                        (vect (read-elements (fx+ n 1))))
                   (vector-set! vect n next)
                   vect))
                (else
                 (err)))))

      (if (char=? c2 #\])
          (begin
            (set! pos (fx+ 1 pos)) ;; skip #\]
            '#())
          (let* ((first (read-value-starting-with-non-whitespace c2))
                 (vect (read-elements 1)))
            (vector-set! vect 0 first)
            vect))))

  (define (read-object)
    ;; we know the lookahead character is #\{
    (set! pos (fx+ 1 pos)) ;; skip #\{
    (let* ((obj (make-table))
           (c (peek-next-non-whitespace)))
      (if (char=? c #\})
          (begin
            (set! pos (fx+ 1 pos))
            obj)
          (let loop ((c c))
            (if (char=? c #\")
                (let* ((key (read-string))
                       (c2 (peek-next-non-whitespace)))
                  (if (char=? c2 #\:)
                      (begin
                        (set! pos (fx+ 1 pos))
                        (let ((val (read-value)))
                          (table-set! obj key val)
                          (let ((c3 (peek-next-non-whitespace)))
                            (cond ((char=? c3 #\})
                                   (set! pos (fx+ 1 pos))
                                   obj)
                                  ((char=? c3 #\,)
                                   (set! pos (fx+ 1 pos))
                                   (loop (peek-next-non-whitespace)))
                                  (else
                                   (err))))))
                      (err)))
                (err))))))

  (define (read-string)
    ;; we know the lookahead character is #\"
    (set! pos (fx+ 1 pos)) ;; skip #\"
    (let loop ((i pos) (j pos) (rev-parts '()))

      (define (chunk)
        (substring str i j))

      (if (fx< j (string-length str))
          (let ((c (string-ref str j)))
            (cond ((char=? c #\")
                   (set! pos (fx+ 1 j))
                   (string-concatenate (reverse! (cons (chunk) rev-parts))))
                  ((char=? c #\\)
                   (if (fx< (fx+ 1 j) (string-length str))
                       (let ((c2 (string-ref str (fx+ 1 j))))

                         (define (add-char x i)
                           (loop i i (cons x (cons (chunk) rev-parts))))

                         (cond ((char=? c2 #\\)
                                (add-char "\\" (fx+ 2 j)))
                               ((char=? c2 #\")
                                (add-char "\"" (fx+ 2 j)))
                               ((char=? c2 #\b)
                                (add-char "\b" (fx+ 2 j)))
                               ((char=? c2 #\t)
                                (add-char "\t" (fx+ 2 j)))
                               ((char=? c2 #\n)
                                (add-char "\n" (fx+ 2 j)))
                               ((char=? c2 #\f)
                                (add-char "\f" (fx+ 2 j)))
                               ((char=? c2 #\r)
                                (add-char "\r" (fx+ 2 j)))
                               ((char=? c2 #\/)
                                (add-char "/" (fx+ 2 j)))
                               ((and (char=? c2 #\u)
                                     (fx<= (fx+ 6 j) (string-length str)))
                                (let ((n
                                       (string->number
                                        (substring str (fx+ 2 j) (fx+ 6 j))
                                        16)))
                                  (if n
                                      (cond
                                       ((and (fx>= n #xd800)
                                             (fx<= n #xdbff))
                                        (if (and (fx<= (fx+ 12 j)
                                                       (string-length str))
                                                 (char=? (string-ref str (fx+ 6 j))
                                                         #\\)
                                                 (char=? (string-ref str (fx+ 7 j))
                                                         #\u))
                                            (let ((m
                                                   (string->number
                                                    (substring str (fx+ 8 j) (fx+ 12 j))
                                                    16)))
                                              (if (and m
                                                       (fx>= m #xdc00)
                                                       (fx<= m #xdfff))
                                                  (add-char
                                                   (string
                                                    (integer->char
                                                     (fx+
                                                      #x10000
                                                      (fx* 1024 (fxand n #x3ff))
                                                      (fxand m #x3ff))))
                                                   (fx+ 12 j))
                                                  (err)))
                                            (err)))
                                       ((and (fx>= n #xdc00)
                                             (fx<= n #xdfff))
                                        (err))
                                       (else
                                        (add-char
                                         (string (integer->char n))
                                         (fx+ 6 j))))
                                      (err))))
                               (else
                                (err))))
                       (err)))
                  ((and (char<? c #\space)
                        (not permissive?))
                   (err))
                  (else
                   (loop i (fx+ 1 j) rev-parts))))
          (err))))

  (define (read-number start i)

    (define (read-end i)
      (set! pos i)
      (string->number (substring str start i)))

    (define (read-exponent-digits i)
      (let loop ((i i) (digits? #f))
        (if (and (fx< i (string-length str))
                 (let ((c (string-ref str i)))
                   (and (char>=? c #\0) (char<=? c #\9))))
            (loop (fx+ 1 i) #t)
            (if digits?
                (read-end i)
                (err)))))

    (define (read-exponent i)
      (if (and (fx< (fx+ 1 i) (string-length str))
               (let ((c (string-ref str i)))
                 (or (char=? c #\e) (char=? c #\E))))
          (let ((c2 (string-ref str (fx+ 1 i))))
            (if (or (char=? c2 #\-) (char=? c2 #\+))
                (read-exponent-digits (fx+ 2 i))
                (read-exponent-digits (fx+ 1 i))))
          (read-end i)))

    (define (read-fraction i)
      (if (and (fx< i (string-length str))
               (char=? (string-ref str i) #\.))
          (let loop ((j (fx+ 1 i)) (decimals? #f))
            (if (and (fx< j (string-length str))
                     (let ((c (string-ref str j)))
                       (and (char>=? c #\0) (char<=? c #\9))))
                (loop (fx+ 1 j) #t)
                (if decimals?
                    (read-exponent j)
                    (err))))
          (read-exponent i)))

    (if (char=? (string-ref str (fx- i 1)) #\0)
        (read-fraction i)
        (let loop ((i i))
          (if (and (fx< i (string-length str))
                   (let ((c (string-ref str i)))
                     (and (char>=? c #\0) (char<=? c #\9))))
              (loop (fx+ i 1))
              (read-fraction i)))))

  (define (read-value)
    (read-value-starting-with-non-whitespace (peek-next-non-whitespace)))

  (define (read-value-starting-with-non-whitespace c)

    (cond ((char=? c #\[)
           (read-array))

          ((char=? c #\{)
           (read-object))

          ((char=? c #\")
           (read-string))

          ((and (char=? c #\-)
                (fx< (fx+ 1 pos) (string-length str))
                (let ((c2 (string-ref str (fx+ 1 pos))))
                  (and (char>=? c2 #\0) (char<=? c2 #\9))))
           (read-number pos (fx+ 2 pos)))

          ((and (char>=? c #\0) (char<=? c #\9))
           (read-number pos (fx+ 1 pos)))

          ((and (char=? c #\f)
                (fx<= (fx+ 5 pos) (string-length str))
                (char=? (string-ref str (fx+ 1 pos)) #\a)
                (char=? (string-ref str (fx+ 2 pos)) #\l)
                (char=? (string-ref str (fx+ 3 pos)) #\s)
                (char=? (string-ref str (fx+ 4 pos)) #\e))
           (set! pos (fx+ pos 5))
           #f)

          ((and (char=? c #\t)
                (fx<= (fx+ 4 pos) (string-length str))
                (char=? (string-ref str (fx+ 1 pos)) #\r)
                (char=? (string-ref str (fx+ 2 pos)) #\u)
                (char=? (string-ref str (fx+ 3 pos)) #\e))
           (set! pos (fx+ 4 pos))
           #t)

          ((and (char=? c #\n)
                (fx<= (fx+ 4 pos) (string-length str))
                (char=? (string-ref str (fx+ 1 pos)) #\u)
                (char=? (string-ref str (fx+ 2 pos)) #\l)
                (char=? (string-ref str (fx+ 3 pos)) #\l))
           (set! pos (fx+ 4 pos))
           (void))

          (else
           (err))))

  (let ((value (read-value)))
    (if (char=? (peek-next-non-whitespace) #\space)
        value
        (err))))

;;;============================================================================
