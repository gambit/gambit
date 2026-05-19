
(import (srfi 143))
(import (_test))


(define-macro 
  (test-equivalence val procedures prefix suffix)
  (define (sym . lst)
    (string->symbol
      (apply string-append
             (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                  lst))))

  (define (+/carry i j k)
    (let*-values (((s) (+ i j k))
                  ((q r) (balanced/ s (expt 2 fx-width))))
      (values r q)))

  (define (-/carry i j k)
    (let*-values (((d) (- i j k))
                  ((q r) (balanced/ d (expt 2 fx-width))))
      (values r q)))

  (define (*/carry i j k)
    (let*-values (((s) (+ (* i j) k))
                  ((q r) (balanced/ s (expt 2 fx-width))))
      (values r q)))

  `(begin
     ,@(map 
         (lambda (proc)
           `(test-equal ,(proc val) (,(sym prefix proc suffix) ,@val))
           ) procedures)))


(define-macro 
  (test-fixnum-operations vals)
  `(begin
     ,@(map 
         (lambda (x) 
           `(begin
              (test-equivalence
                (,x)
                (zero? positive? 
                negative? odd? even? neg abs square bit-count)
                fx ||)
              (test-equal ,(exact-integer-sqrt x) (fxsqrt ,x))
              (test-equal ,(integer-length x) (fxlength ,x))
              ,@(map 
                  (lambda (y)
                    `(begin
                        (test-equivalence 
                          (,x ,y)
                          (= < > <= >= first-set-bit)
                          fx ?)
                        (test-equivalence
                           (,x ,y)
                           (max min bit-set? + - * quotient remainder)
                           fx ||)
                        (test-equivalence
                          (,x ,y 1)
                          (copy-bit bit-field-reverse +/carry -/carry */carry)
                          fx ||)
                        (test-equal
                           ,(bit-field-rotate x y 1 3)
                           (fxbit-field-rotate ,x ,y 1 3))
                        (test-equal 
                          ,(bitwise-and x y) 
                          (fxand ,x ,y))
                        (test-equal 
                          ,(bitwise-ior x y) 
                          (fxior ,x ,y))
                        (test-equal 
                          ,(bitwise-if (* x y) x y) 
                          (fxif ,(* x y) ,x ,y))
                        (test-equal 
                          ,(bitwise-if (+ x y) x y) 
                          (fxif ,(+ x y) ,x ,y))
                        (test-equal 
                          ,(bitwise-xor x y) 
                          (fxxor ,x ,y))
                        ,(if (> (abs y) (- (fx-width) 1))
                           `(test-error #t (fxarithmetic-shift ,x ,y))
                           `(test-equal
                             ,(arithmetic-shift x y)
                             (fxarithmetic-shift ,x ,y)))
                        ,(if (< y 0)
                           `(test-error #t (fxarithmetic-shift-left ,x ,y))
                           `(test-equal
                             ,(arithmetic-shift x y)
                             (fxarithmetic-shift ,x ,y)))
                        ,(if (> y 0)
                           `(test-error #t (fxarithmetic-shift-right ,x ,y))
                           `(test-equal
                             ,(arithmetic-shift x (* -1 y))
                             (fxarithmetic-shift-right ,x ,y)))

)) vals))) vals)))

(test-assert (>= 24 (fx-width)))
(test-equal (- (expt 2 (- (fx-width) 1)) 1) (fx-greatest))
(test-equal (* -1 (expt 2 (- (fx-width) 1))) (fx-least))
(test-equal (fixnum? 2) #t)
(test-equal (fixnum? 3) #t)
(test-equal (fixnum? #\c) #f)
(test-equal (fixnum? #f) #f)
(test-fixnum-operations (1 3 2  3 5 3 5 3 5 35 3 7  6 66 44  64  6 6 4 654 5 42  63 6 3 643 64))
