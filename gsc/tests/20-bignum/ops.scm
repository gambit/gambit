(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##bignum.make 3 #f #f))
(define b (##bignum.make 3 #f #t))
(define c (##fixnum->bignum 1234))
(define d (##fixnum->bignum 100))

(println (##bignum? 0)) ;; #f
(println (##bignum? a)) ;; #t
(println (##bignum? b)) ;; #t
(println (##bignum? c)) ;; #t

(println (##bignum.negative? a)) ;; #f
(println (##bignum.negative? b)) ;; #t
(println (##bignum.negative? c)) ;; #f

(println (##bignum.mdigit-ref a 0)) ;; 0
(println (##bignum.mdigit-ref a 1)) ;; 0
(println (##bignum.mdigit-ref a 2)) ;; 0

(println (##fx= 0 (##bignum.mdigit-ref b 0))) ;; #f
(println (##fx= (##bignum.mdigit-ref b 0) (##bignum.mdigit-ref b 1))) ;; #t
(println (##fx= (##bignum.mdigit-ref b 0) (##bignum.mdigit-ref b 2))) ;; #t

(println (##bignum.mdigit-ref c 0)) ;; 1234

(println (##bignum.adigit-length a)) ;; 3
(println (##bignum.adigit-length b)) ;; 3
(println (##bignum.adigit-length c)) ;; 1

(println (##bignum.adigit-inc! a 0)) ;; 0 (no carry)
(println (##bignum.adigit-inc! b 0)) ;; 1 (carry)
(println (##bignum.adigit-inc! c 0)) ;; 0 (no carry)

(println (##bignum.mdigit-ref a 0)) ;; 1
(println (##bignum.mdigit-ref b 0)) ;; 0
(println (##bignum.mdigit-ref c 0)) ;; 1235

(println (##bignum.adigit-inc! a 0)) ;; 0 (no carry)
(println (##bignum.adigit-inc! b 0)) ;; 0 (no carry)
(println (##bignum.adigit-inc! c 0)) ;; 0 (no carry)

(println (##bignum.mdigit-ref a 0)) ;; 2
(println (##bignum.mdigit-ref b 0)) ;; 1
(println (##bignum.mdigit-ref c 0)) ;; 1236

(println (##bignum.adigit-dec! a 0)) ;; 0 (no borrow)
(println (##bignum.adigit-dec! b 0)) ;; 0 (no borrow)
(println (##bignum.adigit-dec! c 0)) ;; 0 (no borrow)

(println (##bignum.mdigit-ref a 0)) ;; 1
(println (##bignum.mdigit-ref b 0)) ;; 0
(println (##bignum.mdigit-ref c 0)) ;; 1235

(println (##bignum.adigit-dec! a 0)) ;; 0 (no borrow)
(println (##bignum.adigit-dec! b 0)) ;; 1 (borrow)
(println (##bignum.adigit-dec! c 0)) ;; 0 (no borrow)

(println (##bignum.mdigit-ref a 0)) ;; 0
(println (##bignum.mdigit-ref c 0)) ;; 1234

(println (##bignum.adigit-add! c 0 d 0 1)) ;; 0 (no carry)
(println (##bignum.mdigit-ref c 0)) ;; 1335
(println (##bignum.adigit-add! c 0 b 0 0)) ;; 1 (carry)
(println (##bignum.mdigit-ref c 0)) ;; 1334

(println (##bignum.adigit-sub! c 0 d 0 1)) ;; 0 (no borrow)
(println (##bignum.mdigit-ref c 0)) ;; 1233
(println (##bignum.adigit-sub! c 0 b 0 0)) ;; 1 (borrow)
(println (##bignum.mdigit-ref c 0)) ;; 1234

(##bignum.mdigit-set! c 0 4321)
(println (##bignum.mdigit-ref c 0)) ;; 4321

(println (##bignum.adigit-ones? a 0)) ;; #f
(println (##bignum.adigit-ones? b 0)) ;; #t

(println (##bignum.adigit-zero? a 0)) ;; #t
(println (##bignum.adigit-zero? b 0)) ;; #f

(println (##bignum.adigit-negative? a 0)) ;; #f
(println (##bignum.adigit-negative? b 0)) ;; #t

(println (##bignum.adigit-= a b 0)) ;; #f
(println (##bignum.adigit-= a a 0)) ;; #t

(println (##bignum.adigit-< a b 0)) ;; #t
(println (##bignum.adigit-< b a 0)) ;; #f

(let ((len1 (##bignum.mdigit-length a)))
  (##bignum.adigit-shrink! a 1)
  (let ((len2 (##bignum.mdigit-length a)))
    (println (##fx= len1 (##fx* 3 len2))))) ;; #t

#|

##bignum.mdigit-mul!
##bignum.mdigit-div!
##bignum.mdigit-quotient
##bignum.mdigit-remainder
##bignum.mdigit-test?

##bignum.adigit-copy!
##bignum.adigit-cat!
##bignum.adigit-bitwise-and!
##bignum.adigit-bitwise-ior!
##bignum.adigit-bitwise-xor!
##bignum.adigit-bitwise-not!

|#
