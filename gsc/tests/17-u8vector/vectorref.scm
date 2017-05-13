(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u8vector 0 111 255))
(define v2 (##make-u8vector 10))
(define v3 (##make-u8vector 10 111))
(define v4 (##make-u8vector 10 255))
(define v5 '#u8(0 111 255))

(define (test v i expected)
  (let ((val (##u8vector-ref v i))) 
    (println (if (##fx= val expected) "good" "bad"))))

(test v1 0 0)
(test v1 1 111)
(test v1 2 255)

(test v2 9 0)
(test v3 9 111)
(test v4 9 255)

(test v5 0 0)
(test v5 1 111)
(test v5 2 255)
