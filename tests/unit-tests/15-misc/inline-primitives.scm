(include "#.scm")

(declare (safe) (standard-bindings) (extended-bindings))

(define-type inline-slot x)
(define slot-type (##structure-type (make-inline-slot #f)))

(define (read-slot obj)
  (##unchecked-structure-ref obj 1 #f #f))

(define (write-slot obj value)
  (##unchecked-structure-set! obj value 1 #f #f))

(define (checked-slot obj)
  (##direct-structure-ref obj 1 slot-type #f))

(define (checked-slot-set! obj value)
  (##direct-structure-set! obj value 1 slot-type #f))

(define (read-pair obj) (##car obj))
(define (pair-test obj) (if (##car obj) 1 2))
(define (minimum-fixnums a b) (if (##fx< a b) a b))
(define (write-vector obj i value) (##vector-set! obj i value))
(define (read-vector obj i) (##vector-ref obj i))

(define obj (make-inline-slot 42))
(define vec (vector 1 2))

(test-equal 42 (read-slot obj))
(write-slot obj 43)
(test-equal 43 (checked-slot obj))
(checked-slot-set! obj 44)
(test-equal 44 (read-slot obj))
(test-equal 'a (read-pair '(a . b)))
(test-equal 1 (pair-test '(#t)))
(test-equal 2 (pair-test '(#f)))
(test-equal 3 (minimum-fixnums 3 7))
(test-equal 3 (minimum-fixnums 7 3))
(write-vector vec 1 10)
(test-equal 10 (read-vector vec 1))

;; Explicit checked ## operations and ordinary safe operations must retain checks.
(test-error type-exception? (checked-slot vec))
(test-error type-exception? (checked-slot-set! vec 0))
(test-error type-exception? (car #f))
(test-error type-exception? (vector-ref #f 0))
(test-error range-exception? (vector-ref vec 2))
(test-error type-exception? (vector-set! #f 0 1))
(test-error type-exception? (fx+ #f 1))
