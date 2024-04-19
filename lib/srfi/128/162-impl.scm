(define (comparator-max-in-list comp list)
  (let ((< (comparator-ordering-predicate comp)))
    (let loop ((max (car list)) (list (cdr list)))
      (if (null? list)
        max
        (if (< max (car list))
          (loop (car list) (cdr list))
          (loop max (cdr list)))))))

(define (comparator-min-in-list comp list)
  (let ((< (comparator-ordering-predicate comp)))
    (let loop ((min (car list)) (list (cdr list)))
      (if (null? list)
        min
        (if (< min (car list))
          (loop min (cdr list))
          (loop (car list) (cdr list)))))))

(define (comparator-max comp . args)
  (comparator-max-in-list comp args))

(define (comparator-min comp . args)
  (comparator-min-in-list comp args))

(define default-comparator
  (make-default-comparator))

(define boolean-comparator
  (make-comparator
    boolean?
    boolean=?
    (lambda (x y) (and (not x) y))
    boolean-hash))

(define real-comparator
  (make-comparator
    real?
    =
    <
    number-hash))

(define char-comparator
  (make-comparator
    char?
    char=?
    char<?
    (lambda (c) (number-hash (char->integer c)))))

(define char-ci-comparator
  (make-comparator
    char?
    char-ci=?
    char-ci<?
    (lambda (c) (number-hash (char->integer (char-downcase c))))))

(define string-comparator
  (make-comparator
    string?
    string=?
    string<?
    string-hash))

(define string-ci-comparator
  (make-comparator
    string?
    string-ci=?
    string-ci<?
    string-ci-hash))

(define pair-comparator
  (make-pair-comparator
    default-comparator
    default-comparator))

(define list-comparator
  (make-list-comparator
    default-comparator
    list?
    null?
    car
    cdr))

(define vector-comparator
  (make-vector-comparator
    default-comparator
    vector?
    vector-length
    vector-ref))

(define eq-comparator (make-eq-comparator))
(define eqv-comparator (make-eqv-comparator))
(define equal-comparator (make-equal-comparator))
