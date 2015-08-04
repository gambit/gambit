(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##s32vector -2147483648 2147483647))
(define v2 (##make-s32vector 10 99))

(define (bignum= x y)
  (and (##fx= (##bignum.adigit-length x)
              (##bignum.adigit-length y))
       (let loop ((i (##fx- (##bignum.adigit-length x) 1)))
         (if (and (##fx> i 0)
                  (##bignum.adigit-= x y i))
             (loop (##fx- i 1))
             (##bignum.adigit-= x y i)))))

(define (test v i eq)
  (if (##fixnum? (##s32vector-ref v i))
      (begin
       (println (if (##fx= (##s32vector-ref v i) eq)  "same" "different"))
       (println (##eq? v (##s32vector-set! v i 88)))
       (println (##s32vector-ref v i)))
      (begin
       (println (if (bignum= (##s32vector-ref v i) eq)  "same" "different"))
       (println (##eq? v (##s32vector-set! v i 88)))
       (println (##s32vector-ref v i)))))
 

(test v1 1 2147483647)
(test v2 9 99)
