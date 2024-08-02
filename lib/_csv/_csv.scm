;;;============================================================================

;;; File: "_csv.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; CSV reading/writing.

(##supply-module _csv)

(##namespace ("_csv#"))                   ;; in _csv#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;----------------------------------------------------------------------------

(##include "_csv#.scm")

;;;----------------------------------------------------------------------------

(define-procedure (read-csv
                   (port        character-input-port (macro-current-input-port))
                   (separator   char #\,)
                   (permissive? boolean #f)
                   (as-list?    boolean #f))

  (define initial-buffer-size 64)

  (define quote-char #\")
  (define lf-char    #\newline)
  (define cr-char    #\return)

  (define (err)
    (error "csv syntax error"))

  (let ((buffer (make-string initial-buffer-size)))

    (define (accumulate-rows rev-rows)
      (let ((c (read-char port)))
        (if (char? c)
            (let ()

              (define (row-end rev-fields rev-rows)
                (accumulate-rows
                 (cons (reverse! rev-fields) rev-rows)))

              (define (beginning-of-field c rev-rows rev-fields)

                (cond ((or (not (char? c))
                           (char=? c lf-char))
                       (row-end rev-fields rev-rows))

                      ((char=? c cr-char)
                       (if (eqv? (peek-char port) lf-char)
                           (read-char port))
                       (row-end rev-fields rev-rows))

                      ((char=? c separator)
                       (beginning-of-field
                        (read-char port)
                        rev-rows
                        (cons "" rev-fields)))

                      ((char<=? c #\space)
                       (beginning-of-field (read-char port)
                                           rev-rows
                                           rev-fields))

                      ((char=? c quote-char)
                       (accumulate-field #t
                                         rev-rows
                                         rev-fields
                                         0))

                      (else
                       (string-set! buffer 0 c)
                       (accumulate-field #f
                                         rev-rows
                                         rev-fields
                                         1))))

              (define (accumulate-field quoted? rev-rows rev-fields pos)
                (let ((c (read-char port)))

                  (define (accumulate-char c)
                    (if (fx>= pos (string-length buffer))
                        (let ((new-buffer (make-string (fx* 2 pos))))
                          (substring-move! buffer 0 pos new-buffer 0)
                          (set! buffer new-buffer)))
                    (string-set! buffer pos c)
                    (accumulate-field quoted?
                                      rev-rows
                                      rev-fields
                                      (fx+ pos 1)))

                  (define (field-and-row-end)
                    (accumulate-rows
                     (cons (reverse! (cons (field-end) rev-fields))
                           rev-rows)))

                  (define (field-end)
                    (if quoted?
                        (substring buffer 0 pos) ;; keep trailing spaces
                        (let loop ((pos pos)) ;; remove trailing spaces
                          (if (fx> pos 0)
                              (let ((new-pos (fx- pos 1)))
                                (if (char<=? (string-ref buffer new-pos)
                                             #\space)
                                    (loop new-pos)
                                    (substring buffer 0 pos)))
                              (substring buffer 0 pos)))))

                  (cond ((not (char? c))
                         (if (and quoted? (not permissive?))
                             (err)
                             (field-and-row-end)))

                        (quoted?
                         (if (char=? c quote-char)
                             (if (eqv? (peek-char port) quote-char)
                                 (accumulate-char (read-char port))
                                 (let skip () ;; ignore trailing spaces
                                   (let ((c (read-char port)))
                                     (cond ((or (not (char? c))
                                                (char=? c lf-char))
                                            (field-and-row-end))
                                           ((char=? c cr-char)
                                            (if (eqv? (peek-char port) lf-char)
                                                (read-char port))
                                            (field-and-row-end))
                                           ((char=? c separator)
                                            (beginning-of-field
                                             (read-char port)
                                             rev-rows
                                             (cons (field-end) rev-fields)))
                                           ((or (char<=? c #\space)
                                                permissive?)
                                            (skip))
                                           (else
                                            (err))))))
                             (accumulate-char c)))

                        ((char=? c lf-char)
                         (field-and-row-end))

                        ((char=? c cr-char)
                         (if (eqv? (peek-char port) lf-char)
                             (read-char port))
                         (field-and-row-end))

                        ((char=? c separator)
                         (beginning-of-field
                          (read-char port)
                          rev-rows
                          (cons (field-end) rev-fields)))

                        (else
                         (accumulate-char c)))))

              (beginning-of-field c rev-rows '()))

            (reverse! rev-rows))))

    (let ((rows (accumulate-rows '())))
      (if as-list?
          rows
          (begin
            (let loop ((lst rows))
              (if (pair? lst)
                  (begin
                    (set-car! lst (list->vector (car lst)))
                    (loop (cdr lst)))))
            (list->vector rows))))))

(define-procedure (read-file-csv
                   (path        string)
                   (separator   char #\,)
                   (permissive? boolean #f)
                   (as-list?    boolean #f))
  (let* ((port
          (open-input-file path))
         (result
          (read-csv port
                    separator
                    permissive?
                    as-list?)))
    (close-input-port port)
    result))

(define-procedure (csv-string->vector
                   (string      string)
                   (separator   char #\,)
                   (permissive? boolean #f))
  (let* ((port
          (open-input-string string))
         (result
          (read-csv port
                    separator
                    permissive?
                    #f)))
    (close-input-port port)
    result))

(define-procedure (csv-string->list
                   (string      string)
                   (separator   char #\,)
                   (permissive? boolean #f))
  (let* ((port
          (open-input-string string))
         (result
          (read-csv port
                    separator
                    permissive?
                    #t)))
    (close-input-port port)
    result))

(define-procedure (write-csv
                   (obj       object)
                   (port      character-output-port (macro-current-output-port))
                   (separator char #\,))

  (define quote-char #\")

  (define (err)
    (error "csv structure error"))

  (define (write-cell cell)
    (let ((str
           (cond ((string? cell)
                  cell)
                 ((symbol? cell)
                  (symbol->string cell))
                 ((number? cell)
                  (number->string cell))
                 (else
                  (err)))))
      (if (fx> (string-length str) 0)
          (if (or (char<=? (string-ref str 0) #\space)
                  (char<=? (string-ref str (fx- (string-length str) 1)) #\space)
                  (let find-special ((i 0))
                    (if (fx< i (string-length str))
                        (let ((c (string-ref str i)))
                          (or (char=? c separator)
                              (char=? c quote-char)
                              (char<? c #\space)
                              (find-special (fx+ i 1))))
                        #f)))

              (begin
                (write-char quote-char port)
                (let escape-quotes-loop ((i 0) (j 0))
                  (if (fx< j (string-length str))
                      (let ((c (string-ref str j))
                            (j+1 (fx+ j 1)))
                        (escape-quotes-loop
                         (if (char=? c quote-char)
                             (begin
                               (write-substring str i j+1 port)
                               j)
                             i)
                         j+1))
                      (begin
                        (write-substring str i j port)
                        (write-char quote-char port)))))

              (write-substring str 0 (string-length str) port)))))

  (define (write-row row)
    (if (vector? obj)

        (let loop ((i 0))
          (if (fx< i (vector-length row))
              (let ((cell (vector-ref row i)))
                (if (fx> i 0) (write-char separator port))
                (write-cell cell)
                (loop (fx+ i 1)))))

        (let loop ((lst row))
          (if (pair? lst)
              (let ((cell (car lst)))
                (if (not (eq? lst row)) (write-char separator port))
                (write-cell cell)
                (loop (cdr lst)))
              (if (not (null? lst))
                  (err)))))

    (newline port))

  (if (vector? obj)

      (let loop ((i 0))
        (if (fx< i (vector-length obj))
            (let ((row (vector-ref obj i)))
              (write-row row)
              (loop (fx+ i 1)))))

      (let loop ((lst obj))
        (if (pair? lst)
            (let ((row (car lst)))
              (write-row row)
              (loop (cdr lst)))
            (if (not (null? lst))
                (err))))))

(define-procedure (write-file-csv
                   (path      string)
                   (obj       object)
                   (separator char #\,))
  (let* ((port
          (open-output-file path))
         (result
          (write-csv obj
                     port
                     separator)))
    (close-output-port port)
    result))

(define-procedure (->csv-string
                   (obj       object)
                   (separator char #\,))
  (let ((port
         (open-output-string)))
    (write-csv obj
               port
               separator)
    (get-output-string port)))
