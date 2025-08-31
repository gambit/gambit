(import (srfi 128))
(import (_test))

(define (vector-cdr vec)
  (let* ((len (vector-length vec))
         (result (make-vector (- len 1))))
    (let loop ((n 1))
      (cond
        ((= n len) result)
        (else (vector-set! result (- n 1) (vector-ref vec n))
              (loop (+ n 1)))))))

(test-group "vector/cdr"
  (test-assert (equal? '#(2 3 4) (vector-cdr '#(1 2 3 4))))
  (test-assert (equal? '#() (vector-cdr '#(1)))))

(test-group "comparators"

  (define degenerate-comparator (make-comparator (lambda (x) #t) equal? #f #f))
  (define bool-pair-comparator (make-pair-comparator boolean-comparator boolean-comparator))
  (define num-list-comparator
    (make-list-comparator real-comparator list? null? car cdr))
  (define num-vector-comparator
    (make-vector-comparator real-comparator vector? vector-length vector-ref))
  (define vector-qua-list-comparator
    (make-list-comparator
      real-comparator
      vector?
      (lambda (vec) (= 0 (vector-length vec)))
      (lambda (vec) (vector-ref vec 0))
      vector-cdr))
  (define list-qua-vector-comparator
    (make-vector-comparator default-comparator list? length list-ref))

  (test-group "comparators/predicates"
    (test-assert (comparator? real-comparator))
    (test-assert (not (comparator? =)))
    (test-assert (comparator-ordered? real-comparator))
    (test-assert (comparator-hashable? real-comparator))
    (test-assert (not (comparator-ordered? degenerate-comparator)))
    (test-assert (not (comparator-hashable? degenerate-comparator)))
  ) ; end comparators/predicates

  (test-group "comparators/constructors"
    (define bool-pair (cons #t #f))
    (define bool-pair-2 (cons #t #f))
    (define reverse-bool-pair (cons #f #t))
    (test-assert (=? boolean-comparator #t #t))
    (test-assert (not (=? boolean-comparator #t #f)))
    (test-assert (<? boolean-comparator #f #t))
    (test-assert (not (<? boolean-comparator #t #t)))
    (test-assert (not (<? boolean-comparator #t #f)))

    (test-assert (comparator-test-type bool-pair-comparator '(#t . #f)))
    (test-assert (not (comparator-test-type bool-pair-comparator 32)))
    (test-assert (not (comparator-test-type bool-pair-comparator '(32 . #f))))
    (test-assert (not (comparator-test-type bool-pair-comparator '(#t . 32))))
    (test-assert (not (comparator-test-type bool-pair-comparator '(32 . 34))))
    (test-assert (=? bool-pair-comparator '(#t . #t) '(#t . #t)))
    (test-assert (not (=? bool-pair-comparator '(#t . #t) '(#f . #t))))
    (test-assert (not (=? bool-pair-comparator '(#t . #t) '(#t . #f))))
    (test-assert (<? bool-pair-comparator '(#f . #t) '(#t . #t)))
    (test-assert (<? bool-pair-comparator '(#t . #f) '(#t . #t)))
    (test-assert (not (<? bool-pair-comparator '(#t . #t) '(#t . #t))))
    (test-assert (not (<? bool-pair-comparator '(#t . #t) '(#f . #t))))
    (test-assert (not (<? bool-pair-comparator '(#f . #t) '(#f . #f))))

    (test-assert (comparator-test-type num-vector-comparator '#(1 2 3)))
    (test-assert (comparator-test-type num-vector-comparator '#()))
    (test-assert (not (comparator-test-type num-vector-comparator 1)))
    (test-assert (not (comparator-test-type num-vector-comparator '#(a 2 3))))
    (test-assert (not (comparator-test-type num-vector-comparator '#(1 b 3))))
    (test-assert (not (comparator-test-type num-vector-comparator '#(1 2 c))))
    (test-assert (=? num-vector-comparator '#(1 2 3) '#(1 2 3)))
    (test-assert (not (=? num-vector-comparator '#(1 2 3) '#(4 5 6))))
    (test-assert (not (=? num-vector-comparator '#(1 2 3) '#(1 5 6))))
    (test-assert (not (=? num-vector-comparator '#(1 2 3) '#(1 2 6))))
    (test-assert (<? num-vector-comparator '#(1 2) '#(1 2 3)))
    (test-assert (<? num-vector-comparator '#(1 2 3) '#(2 3 4)))
    (test-assert (<? num-vector-comparator '#(1 2 3) '#(1 3 4)))
    (test-assert (<? num-vector-comparator '#(1 2 3) '#(1 2 4)))
    (test-assert (<? num-vector-comparator '#(3 4) '#(1 2 3)))
    (test-assert (not (<? num-vector-comparator '#(1 2 3) '#(1 2 3))))
    (test-assert (not (<? num-vector-comparator '#(1 2 3) '#(1 2))))
    (test-assert (not (<? num-vector-comparator '#(1 2 3) '#(0 2 3))))
    (test-assert (not (<? num-vector-comparator '#(1 2 3) '#(1 1 3))))

    (test-assert (not (<? vector-qua-list-comparator '#(3 4) '#(1 2 3))))
    (test-assert (<? list-qua-vector-comparator '(3 4) '(1 2 3)))

    (test-assert (=? eq-comparator #t #t))
    (test-assert (not (=? eq-comparator #f #t)))
    (test-assert (=? eqv-comparator bool-pair bool-pair))
    (test-assert (not (=? eqv-comparator bool-pair bool-pair-2)))
    (test-assert (=? equal-comparator bool-pair bool-pair-2))
    (test-assert (not (=? equal-comparator bool-pair reverse-bool-pair)))
  ) ; end comparators/constructors

  (test-group "comparators/hash"
    (test-assert (exact-integer? (boolean-hash #f)))
    (test-assert (not (negative? (boolean-hash #t))))
    (test-assert (exact-integer? (char-hash #\a)))
    (test-assert (not (negative? (char-hash #\b))))
    (test-assert (exact-integer? (char-ci-hash #\a)))
    (test-assert (not (negative? (char-ci-hash #\b))))
    (test-assert (= (char-ci-hash #\a) (char-ci-hash #\A)))
    (test-assert (exact-integer? (symbol-hash 'f)))
    (test-assert (not (negative? (symbol-hash 't))))
    (test-assert (exact-integer? (number-hash 3)))
    (test-assert (not (negative? (number-hash 3))))
    (test-assert (exact-integer? (number-hash -3)))
    (test-assert (not (negative? (number-hash -3))))
    (test-assert (exact-integer? (number-hash 3.0)))
    (test-assert (not (negative? (number-hash 3.0))))

  ) ; end comparators/hash

  (test-group "comparators/default"
    (test-assert (<? default-comparator '() '(a)))
    (test-assert (not (=? default-comparator '() '(a))))
    (test-assert (=? default-comparator #t #t))
    (test-assert (not (=? default-comparator #t #f)))
    (test-assert (<? default-comparator #f #t))
    (test-assert (not (<? default-comparator #t #t)))
    (test-assert (=? default-comparator #\a #\a))
    (test-assert (<? default-comparator #\a #\b))
    (test-assert (=? default-comparator kw: kw:))
    (test-assert (<? default-comparator a: b:))
    (test-assert (not (<? default-comparator q: p:)))

    (test-assert (comparator-test-type default-comparator '()))
    (test-assert (comparator-test-type default-comparator #t))
    (test-assert (comparator-test-type default-comparator #\t))
    (test-assert (comparator-test-type default-comparator '(a)))
    (test-assert (comparator-test-type default-comparator 'a))
    (test-assert (comparator-test-type default-comparator kw:))
    (test-assert (comparator-test-type default-comparator (make-bytevector 10)))
    (test-assert (comparator-test-type default-comparator 10))
    (test-assert (comparator-test-type default-comparator 10.0))
    (test-assert (comparator-test-type default-comparator "10.0"))
    (test-assert (comparator-test-type default-comparator '#(10)))

    (test-assert (=? default-comparator '(#t . #t) '(#t . #t)))
    (test-assert (not (=? default-comparator '(#t . #t) '(#f . #t))))
    (test-assert (not (=? default-comparator '(#t . #t) '(#t . #f))))
    (test-assert (<? default-comparator '(#f . #t) '(#t . #t)))
    (test-assert (<? default-comparator '(#t . #f) '(#t . #t)))
    (test-assert (not (<? default-comparator '(#t . #t) '(#t . #t))))
    (test-assert (not (<? default-comparator '(#t . #t) '(#f . #t))))
    (test-assert (not (<? default-comparator '(#f . #t) '(#f . #f))))

    (test-assert (=? default-comparator '#(#t #t) '#(#t #t)))
    (test-assert (not (=? default-comparator '#(#t #t) '#(#f #t))))
    (test-assert (not (=? default-comparator '#(#t #t) '#(#t #f))))
    (test-assert (<? default-comparator '#(#f #t) '#(#t #t)))
    (test-assert (<? default-comparator '#(#t #f) '#(#t #t)))
    (test-assert (not (<? default-comparator '#(#t #t) '#(#t #t))))
    (test-assert (not (<? default-comparator '#(#t #t) '#(#f #t))))
    (test-assert (not (<? default-comparator '#(#t #t) '#(#t #f))))

    (test-assert (= (comparator-hash default-comparator #t) (boolean-hash #t)))
    (test-assert (= (comparator-hash default-comparator #\t) (char-hash #\t)))
    (test-assert (= (comparator-hash default-comparator kw:) (keyword-hash kw:)))
    (test-assert (= (comparator-hash default-comparator 10) (number-hash 10)))
    (test-assert (= (comparator-hash default-comparator 10.0) (number-hash 10.0)))

    (comparator-register-default!
      (make-comparator procedure? (lambda (a b) #t) (lambda (a b) #f) (lambda (obj) 200)))
    (test-assert (comparator-test-type default-comparator (lambda () #t)))
    (test-assert (=? default-comparator (lambda () #t) (lambda () #f)))
    (test-assert (not (<? default-comparator (lambda () #t) (lambda () #f))))
    (test-assert (= 200 (comparator-hash default-comparator (lambda () #t))))
    
    ;; numeric vectors are part of default, tested more below
    (test-assert (=? default-comparator #f32(1.0 2.0 3.0) #f32(1.0 2.0 3.0)))
  ) ; end comparators/default

  (test-group "comparators/accessors"
    (define x1 0)
    (define x2 0)
    (define x3 0)
    (define x4 0)
    (define ttp (lambda (x) (set! x1 111) #t))
    (define eqp (lambda (x y) (set! x2 222) #t))
    (define orp (lambda (x y) (set! x3 333) #t))
    (define hf (lambda (x) (set! x4 444) 0))
    (define comp (make-comparator ttp eqp orp hf))
    (test-assert (and ((comparator-type-test-predicate comp) x1)   (= x1 111)))
    (test-assert (and ((comparator-equality-predicate comp) x1 x2) (= x2 222)))
    (test-assert (and ((comparator-ordering-predicate comp) x1 x3) (= x3 333)))
    (test-assert (and (zero? ((comparator-hash-function comp) x1)) (= x4 444)))
  ) ; end comparators/accessors

  (test-group "comparators/invokers"
    (test-assert (comparator-test-type real-comparator 3))
    (test-assert (comparator-test-type real-comparator 3.0))
    (test-assert (comparator-test-type real-comparator (expt 2 128)))
    (test-assert (comparator-check-type boolean-comparator #t))
    (test-error (comparator-check-type boolean-comparator 't))
  ) ; end comparators/invokers

  (test-group "comparators/comparison"
    (test-assert (=? real-comparator 2 2.0 2))
    (test-assert (<? real-comparator 2 3.0 4))
    (test-assert (>? real-comparator 4.0 3.0 2))
    (test-assert (<=? real-comparator 2.0 2 3.0))
    (test-assert (>=? real-comparator 3 3.0 2))
    (test-assert (not (=? real-comparator 1 2 3)))
    (test-assert (not (<? real-comparator 3 1 2)))
    (test-assert (not (>? real-comparator 1 2 3)))
    (test-assert (not (<=? real-comparator 4 3 3)))
    (test-assert (not (>=? real-comparator 3 4 4.0)))

  ); end comparators/comparison

  (test-group "comparators/syntax"
    (test-eq 'less (comparator-if<=> real-comparator 1 2 'less 'equal 'greater))
    (test-eq 'equal (comparator-if<=> real-comparator 1 1 'less 'equal 'greater))
    (test-eq 'greater (comparator-if<=> real-comparator 2 1 'less 'equal 'greater))
    (test-eq 'less (comparator-if<=> "1" "2" 'less 'equal 'greater))
    (test-eq 'equal (comparator-if<=> "1" "1" 'less 'equal 'greater))
    (test-eq 'greater (comparator-if<=> "2" "1" 'less 'equal 'greater))

  ) ; end comparators/syntax

  (test-group "comparators/bound-salt"
    (test-assert (exact-integer? (hash-bound)))
    (test-assert (exact-integer? (hash-salt)))
    (test-assert (< (hash-salt) (hash-bound)))
  ) ; end comparators/bound-salt

  (test-group "comparators/min-max"
    (test-eqv 5 (comparator-max real-comparator 1 5 3 2 -2))
    (test-eqv -2 (comparator-min real-comparator 1 5 3 2 -2))
    (test-eqv 5 (comparator-max-in-list real-comparator '(1 5 3 2 -2)))
    (test-eqv -2 (comparator-min-in-list real-comparator '(1 5 3 2 -2)))
    (test-eqv 1.0 (comparator-max real-comparator 0.0 0.5 1.0 -1.0))
  ) ; end comparators/min-max

  (test-group "comparators/variables"
    ;; Most of the variables have been tested above.
    (test-assert (=? char-comparator #\C #\C))
    (test-assert (=? char-ci-comparator #\c #\C))
    (test-assert (=? string-comparator "ABC" "ABC"))
    (test-assert (=? string-ci-comparator "abc" "ABC"))
    (test-assert (=? eq-comparator 32 32))
    (test-assert (=? eqv-comparator 32 32))
    (test-assert (=? equal-comparator "ABC" "ABC"))
  ) ; end comparators/variables

  (test-group "comparators/homogenous-vectors"
    (test-assert (comparator-test-type s8vector-comparator #s8(1 2 -3)))
    (test-assert (=? s8vector-comparator #s8(1 2 -3) #s8(1 2 -3)))
    (test-assert (not (=? s8vector-comparator #s8(1 2 3) #s8(2 1 3))))
    (test-assert (<? s8vector-comparator #s8(-1 2 3) #s8(1 2 3)))
    (test-assert (not (<? s8vector-comparator #s8(1 2 3) #s8(1 2 3))))
    (test-assert (not (<? s8vector-comparator #s8(1 2 4) #s8(1 2 3))))
    (test-assert (= (comparator-hash s8vector-comparator #s8(-1 -2 -3)) (equal?-hash #s8(-1 -2 -3))))

    (test-assert (comparator-test-type u8vector-comparator #u8(1 2 3)))
    (test-assert (=? u8vector-comparator #u8(1 2 3) #u8(1 2 3)))
    (test-assert (not (=? u8vector-comparator #u8(1 2 3) #u8(2 1 3))))
    (test-assert (<? u8vector-comparator #u8(1 2 3) #u8(1 2 4)))
    (test-assert (not (<? u8vector-comparator #u8(1 2 3) #u8(1 2 3))))
    (test-assert (not (<? u8vector-comparator #u8(1 2 4) #u8(1 2 3))))
    (test-assert (= (comparator-hash u8vector-comparator #u8(1 2 3)) (equal?-hash #u8(1 2 3))))

    (test-assert (comparator-test-type s16vector-comparator #s16(1 128 -3))) ;; 2^7 is not s8
    (test-assert (=? s16vector-comparator #s16(1 2 -3) #s16(1 2 -3)))
    (test-assert (not (=? s16vector-comparator #s16(1 2 3) #s16(2 1 3))))
    (test-assert (<? s16vector-comparator #s16(-1 2 3) #s16(1 2 3)))
    (test-assert (not (<? s16vector-comparator #s16(1 2 3) #s16(1 2 3))))
    (test-assert (not (<? s16vector-comparator #s16(1 2 4) #s16(1 2 3))))
    (test-assert (= (comparator-hash s16vector-comparator #s16(-1 -2 -3)) (equal?-hash #s16(-1 -2 -3))))

    (test-assert (comparator-test-type u16vector-comparator #u16(1 2 256))) ;; 2^8 is not u8
    (test-assert (=? u16vector-comparator #u16(1 2 3) #u16(1 2 3)))
    (test-assert (not (=? u16vector-comparator #u16(1 2 3) #u16(2 1 3))))
    (test-assert (<? u16vector-comparator #u16(1 2 3) #u16(1 2 4)))
    (test-assert (not (<? u16vector-comparator #u16(1 2 3) #u16(1 2 3))))
    (test-assert (not (<? u16vector-comparator #u16(1 2 4) #u16(1 2 3))))
    (test-assert (= (comparator-hash u16vector-comparator #u16(1 2 3)) (equal?-hash #u16(1 2 3))))

    (test-assert (comparator-test-type s32vector-comparator #s32(1 32768 -3))) ;; 2^15 not s16 etc.
    (test-assert (=? s32vector-comparator #s32(1 2 -3) #s32(1 2 -3)))
    (test-assert (not (=? s32vector-comparator #s32(1 2 3) #s32(2 1 3))))
    (test-assert (<? s32vector-comparator #s32(-1 2 3) #s32(1 2 3)))
    (test-assert (not (<? s32vector-comparator #s32(1 2 3) #s32(1 2 3))))
    (test-assert (not (<? s32vector-comparator #s32(1 2 4) #s32(1 2 3))))
    (test-assert (= (comparator-hash s32vector-comparator #s32(-1 -2 -3)) (equal?-hash #s32(-1 -2 -3))))

    (test-assert (comparator-test-type u32vector-comparator #u32(1 2 65536)))
    (test-assert (=? u32vector-comparator #u32(1 2 3) #u32(1 2 3)))
    (test-assert (not (=? u32vector-comparator #u32(1 2 3) #u32(2 1 3))))
    (test-assert (<? u32vector-comparator #u32(1 2 3) #u32(1 2 4)))
    (test-assert (not (<? u32vector-comparator #u32(1 2 3) #u32(1 2 3))))
    (test-assert (not (<? u32vector-comparator #u32(1 2 4) #u32(1 2 3))))
    (test-assert (= (comparator-hash u32vector-comparator #u32(1 2 3)) (equal?-hash #u32(1 2 3))))

    (test-assert (comparator-test-type s64vector-comparator #s64(1 2147483648 -3)))
    (test-assert (=? s64vector-comparator #s64(1 2 -3) #s64(1 2 -3)))
    (test-assert (not (=? s64vector-comparator #s64(1 2 3) #s64(2 1 3))))
    (test-assert (<? s64vector-comparator #s64(-1 2 3) #s64(1 2 3)))
    (test-assert (not (<? s64vector-comparator #s64(1 2 3) #s64(1 2 3))))
    (test-assert (not (<? s64vector-comparator #s64(1 2 4) #s64(1 2 3))))
    (test-assert (= (comparator-hash s64vector-comparator #s64(-1 -2 -3)) (equal?-hash #s64(-1 -2 -3))))

    (test-assert (comparator-test-type u64vector-comparator #u64(1 2 4294967296)))
    (test-assert (=? u64vector-comparator #u64(1 2 3) #u64(1 2 3)))
    (test-assert (not (=? u64vector-comparator #u64(1 2 3) #u64(2 1 3))))
    (test-assert (<? u64vector-comparator #u64(1 2 3) #u64(1 2 4)))
    (test-assert (not (<? u64vector-comparator #u64(1 2 3) #u64(1 2 3))))
    (test-assert (not (<? u64vector-comparator #u64(1 2 4) #u64(1 2 3))))
    (test-assert (= (comparator-hash u64vector-comparator #u64(1 2 3)) (equal?-hash #u64(1 2 3))))

    (test-assert (comparator-test-type f32vector-comparator #f32(1.0 2.71828 +inf.0)))
    (test-assert (=? f32vector-comparator #f32(1. 2. -3.) #f32(1. 2. -3.0)))
    (test-assert (not (=? f32vector-comparator #f32(1.0 2.0 3.0) #f32(2.0 1.0 3.0))))
    (test-assert (<? f32vector-comparator #f32(-1.0 2.0 3.0) #f32(1.0 2.0 3.0)))
    (test-assert (not (<? f32vector-comparator #f32(1.0 2.0 3.0) #f32(1.0 2.0 3.0))))
    (test-assert (not (<? f32vector-comparator #f32(1.0 2.0 +inf.0) #f32(1.0 2.0 3.0))))
    (test-assert (= (comparator-hash f32vector-comparator #f32(-1.0 -2.0 -3.0)) (equal?-hash #f32(-1.0 -2.0 -3.0))))

    (test-assert (comparator-test-type f64vector-comparator #f64(1.0 2.71828 +inf.0)))
    (test-assert (=? f64vector-comparator #f64(1. 2. -3.) #f64(1. 2. -3.0)))
    (test-assert (not (=? f64vector-comparator #f64(1.0 2.0 3.0) #f64(2.0 1.0 3.0))))
    (test-assert (<? f64vector-comparator #f64(-1.0 2.0 3.0) #f64(1.0 2.0 3.0)))
    (test-assert (not (<? f64vector-comparator #f64(1.0 2.0 3.0) #f64(1.0 2.0 3.0))))
    (test-assert (not (<? f64vector-comparator #f64(1.0 2.0 +inf.0) #f64(1.0 2.0 3.0))))
    (test-assert (= (comparator-hash f64vector-comparator #f64(-1.0 -2.0 -3.0)) (equal?-hash #f64(-1.0 -2.0 -3.0))))

  ) ; end comparators/homogenous-vectors 

) ; end comparators
