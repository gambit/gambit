;;;============================================================================

;;; File: "srfi/28/28.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 28, Basic Format Strings

(##supply-module srfi/28)

(##namespace ("srfi/28#"))       ;; in srfi/28#
(##include "~~lib/_prim#.scm")   ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm") ;; for macro-check-string,
                                 ;; macro-absent-obj, etc

(##include "28#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;============================================================================

(define (format format-string . objects)
  (macro-force-vars (format-string)
    (macro-check-string
      format-string
      1
      (format format-string . objects)
      (let ((accumulator (open-output-string)))

        (let loop1 ((i 0)
                    (objects objects))
          (let loop2 ((i i)
                      (objects objects)
                      (j i))

            (define (transfer)
              (if (fx< i j)
                  (write-substring format-string i j accumulator)))

            (if (not (fx< j (string-length format-string)))

                (begin
                  (transfer)
                  (get-output-string accumulator))

                (let ((c (string-ref format-string j)))
                  (if (not (char=? c #\~))
                      (loop2 i
                             objects
                             (fx+ j 1))
                      (begin
                        (transfer)
                        (let ((j+1 (fx+ j 1)))
                          (if (not (fx< j+1 (string-length format-string)))
                              (error "Incomplete escape sequence")
                              (let ((c2 (string-ref format-string j+1)))
                                (case c2
                                  ((#\a)
                                   (if (null? objects)
                                       (error "No value for escape sequence")
                                       (begin
                                         (display (car objects) accumulator)
                                         (loop1 (fx+ j+1 1)
                                                (cdr objects)))))
                                  ((#\s)
                                   (if (null? objects)
                                       (error "No value for escape sequence")
                                       (begin
                                         (write (car objects) accumulator)
                                         (loop1 (fx+ j+1 1)
                                                (cdr objects)))))
                                  ((#\%)
                                   (display "\n" accumulator)
                                   (loop1 (fx+ j+1 1)
                                          objects))
                                  ((#\~)
                                   (display "~" accumulator)
                                   (loop1 (fx+ j+1 1)
                                          objects))
                                  (else
                                   (error "Unrecognized escape sequence"))))))))))))))))

;;;============================================================================
