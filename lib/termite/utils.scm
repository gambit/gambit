;; utils

;; ----------------------------------------------------------------------------
;; Some basic utilities

(##supply-module termite/utils)
(##namespace ("termite/utils#"))
(##include "~~lib/gambit/prim/prim#.scm")

;; make-uuid
(##include "uuid.scm")

(define (quoted-symbol? datum)
  (and
    (pair? datum)
    (eq? (car datum) 'quote)
    (pair? (cdr datum))
    (symbol? (cadr datum))))

(define (unquoted-symbol? datum)
  (and
    (pair? datum)
    (eq? (car datum) 'unquote)
    (pair? (cdr datum))
    (symbol? (cadr datum))))

