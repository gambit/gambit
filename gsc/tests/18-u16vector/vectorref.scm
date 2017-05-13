(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u16vector 0 111 65535))
(define v2 (##make-u16vector 10))
(define v3 (##make-u16vector 10 111))
(define v4 (##make-u16vector 10 65535))
(define v5 '#u16(0 111 65535))

(define (test v i expected)
  (let ((val (##u16vector-ref v i))) 
    (println (if (##fx= val expected) "good" "bad"))))

(test v1 0 0)
(test v1 1 111)
(test v1 2 65535)

(test v2 9 0)
(test v3 9 111)
(test v4 9 65535)

(test v5 0 0)
(test v5 1 111)
(test v5 2 65535)
