(declare (extended-bindings) (not constant-fold) (not safe))

(define b2f? #f)

(if (##fx= 1 (##bignum.adigit-length (##fixnum->bignum 16384)))

    (set! b2f? ##bignum->fixnum?)

    (set! b2f?
          (lambda (bn)
            (define ##bignum.mdigit-base 16384)
            (define ##bignum.mdigit-base-minus-1 16383)
            (let* ((i
                    (##fx- (##bignum.mdigit-length bn) 1))
                   (n
                    (##bignum.mdigit-ref bn i))
                   (bias
                    (if (##fx< (##fx* 2 n) ##bignum.mdigit-base)
                        0
                        ##bignum.mdigit-base-minus-1)))
              (let loop ((n (##fx- n bias))
                         (i (##fx- i 1)))
                (if (##fx< i 0)
                    (if (##fx= 0 bias)
                        n
                        (##fx+? n -1))
                    (let ((n1 (##fx*? n ##bignum.mdigit-base)))
                      (and n1
                           (let ((n2 (##fx+? n1 (##fx- (##bignum.mdigit-ref bn i) bias))))
                             (and n2
                                  (loop n2
                                        (##fx- i 1))))))))))))

(define (test x)
  (let* ((bn (##fixnum->bignum x))
         (y (b2f? bn)))
    (println y)))

(let loop ((n -1))
  (test n)
  (if (##fx> n -536870912)
      (begin
        (test (##fx- n 1))
        (test (##fx- n 16384))
        (test (##fx- n 16385))
        (loop (##fx* n 2)))))

(let loop ((n 1))
  (test n)
  (if (##fx< n 536870911)
      (begin
        (test (##fx+ n 1))
        (test (##fx+ n 16384))
        (test (##fx+ n 16385))
        (loop (##fx+ 1 (##fx* n 2))))))
