(include "#.scm")

(define bool #f)

(test-assert (eq? #t (bytevector? #u8())))
(test-assert (eq? #t (bytevector? #u8(1 2 3))))
(test-assert (eq? #t (bytevector? (make-bytevector 0))))
(test-assert (eq? #t (bytevector? (make-bytevector 3 7))))
(test-assert (eq? #f (bytevector? bool)))
(test-assert (eq? #f (bytevector? "AB")))
(test-assert (eq? #f (bytevector? '(1 2))))

(test-eqv 0 (bytevector-length #u8()))
(test-eqv 3 (bytevector-length #u8(1 2 3)))
(test-eqv 3 (bytevector-length (make-bytevector 3 7)))

(test-eqv 7 (bytevector-u8-ref (make-bytevector 3 7) 0))
(test-eqv 7 (bytevector-u8-ref (make-bytevector 3 7) 2))
(test-eqv 1 (bytevector-u8-ref #u8(1 2 3) 0))
(test-eqv 3 (bytevector-u8-ref #u8(1 2 3) 2))

(define b (make-bytevector 3 0))
(test-equal (void) (bytevector-u8-set! b 1 9))
(test-eqv 0 (bytevector-u8-ref b 0))
(test-eqv 9 (bytevector-u8-ref b 1))
(test-eqv 0 (bytevector-u8-ref b 2))

(test-equal #u8(1 2 3) (bytevector-copy #u8(1 2 3)))
(test-equal #u8(2 3) (bytevector-copy #u8(1 2 3) 1))
(test-equal #u8(2) (bytevector-copy #u8(1 2 3) 1 2))

(test-equal #u8() (bytevector-append))
(test-equal #u8(1 2 3) (bytevector-append #u8(1 2) #u8(3)))
(test-equal #u8(1 2 3 4) (bytevector-append #u8(1) #u8(2 3) #u8(4)))

(define dst (make-bytevector 4 0))
(bytevector-copy! dst 1 #u8(9 8 7))
(test-equal #u8(0 9 8 7) dst)

(test-error-tail type-exception? (bytevector-length bool))
(test-error-tail type-exception? (bytevector-u8-ref bool 0))
(test-error-tail type-exception? (bytevector-u8-set! bool 0 1))
(test-error-tail type-exception? (bytevector-copy bool))
(test-error-tail type-exception? (bytevector-append bool))
(test-error-tail type-exception? (bytevector-copy! bool 0 #u8(1)))
(test-error-tail type-exception? (make-bytevector bool))

(test-error-tail range-exception? (bytevector-u8-ref #u8(1 2) -1))
(test-error-tail range-exception? (bytevector-u8-ref #u8(1 2) 2))
(test-error-tail range-exception? (bytevector-u8-set! #u8(1 2) 2 0))
(test-error-tail range-exception? (make-bytevector -1))

(test-error-tail wrong-number-of-arguments-exception? (bytevector?))
(test-error-tail wrong-number-of-arguments-exception? (bytevector-length))
(test-error-tail wrong-number-of-arguments-exception? (bytevector-u8-ref #u8(1)))
(test-error-tail wrong-number-of-arguments-exception? (bytevector-u8-set! #u8(1) 0))
