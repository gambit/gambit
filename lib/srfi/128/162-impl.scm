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

(define symbol-comparator
  (make-comparator
    symbol?
    symbol=?
    symbol<?
    symbol-hash))

(define keyword-comparator
  (make-comparator
     keyword?
     keyword=?
     keyword<?
     keyword-hash))
     
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
    string=?-hash))

(define string-ci-comparator
  (make-comparator
    string?
    string-ci=?
    string-ci<?
    string-ci=?-hash))

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

(define (make-numeric-vector-comparator type-test len-fn ref-fn)
  (make-comparator
    type-test
    equal?
    (make-vector<? real-comparator type-test len-fn ref-fn)
    equal?-hash))

(define s8vector-comparator
  (make-numeric-vector-comparator s8vector? s8vector-length s8vector-ref))

(define u8vector-comparator
  (make-numeric-vector-comparator u8vector? u8vector-length u8vector-ref))

(define s16vector-comparator
  (make-numeric-vector-comparator s16vector? s16vector-length s16vector-ref))

(define u16vector-comparator
  (make-numeric-vector-comparator u16vector? u16vector-length u16vector-ref))

(define s32vector-comparator
  (make-numeric-vector-comparator s32vector? s32vector-length s32vector-ref))

(define u32vector-comparator
  (make-numeric-vector-comparator u32vector? u32vector-length u32vector-ref))

(define s64vector-comparator
  (make-numeric-vector-comparator s64vector? s64vector-length s64vector-ref))

(define u64vector-comparator
  (make-numeric-vector-comparator u64vector? u64vector-length u64vector-ref))

(define f32vector-comparator
  (make-numeric-vector-comparator f32vector? f32vector-length f32vector-ref))

(define f64vector-comparator
  (make-numeric-vector-comparator f64vector? f64vector-length f64vector-ref))


(define eq-comparator (make-eq-comparator))
(define eqv-comparator (make-eqv-comparator))
(define equal-comparator (make-equal-comparator))
