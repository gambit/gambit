(import (_test))
(import (srfi 143))


(define-macro 
  (test-equivalence val procedures prefix suffix)
  (define (sym . lst)
    (string->symbol
      (apply string-append
             (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                  lst))))


  `(begin
     ,@(map 
         (lambda (proc)
           `(if (and 
                  (number? (,proc ,@val)) 
                  (or (> (,proc ,@val) fx-greatest)
                      (< (,proc ,@val) fx-least)))
            (test-error #t (,(sym prefix proc suffix) ,@val))
            (test-equal (,proc ,@val) (,(sym prefix proc suffix) ,@val)))
           ) procedures)))

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

(define-macro 
  (test-equivalence-check val procedures prefix suffix check)
  (define (sym . lst)
    (string->symbol
      (apply string-append
             (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                  lst))))


  `(begin
     ,@(map 
         (lambda (proc)
           `(if (or (and 
                  (number? (,proc ,@val)) 
                  (or (> (,proc ,@val) fx-greatest)
                      (< (,proc ,@val) fx-least)))
                 ,check)
            (test-error #t (,(sym prefix proc suffix) ,@val))
            (test-equal (,proc ,@val) (,(sym prefix proc suffix) ,@val)))
           ) procedures)))

(define (values->list valu)
  (receive (a b) valu (list a b)))

(define-macro
  (test-fixnum-operations vals)
  `(begin
     ,@(map 
         (lambda (w) 
           (let ((x (eval w)))
           `(begin
              (test-equivalence
                (,x)
                (zero? positive? 
                negative? odd? even? abs square bit-count first-set-bit)
                fx ||)
              (test-equal ,(integer-length x) (fxlength ,x))
              (test-error #t (fxquotient x 0))
              (test-error #t (fxremainder x 0))
              ,@(map 
                  (lambda (z)
                     (let ((y (eval z)))
                    `(begin
                        (test-equal
                          (fxneg ,x)
                          (- ,x))
                        (test-equivalence 
                          (,x ,y)
                          (= < > <= >=)
                          fx ?)
                        (test-equivalence
                           (,x ,y)
                           (max min + - *)
                           fx ||)
                        ,(if (not (= y 0))
                            `(test-equivalence
                               (,x ,y)
                               (quotient remainder)
                               fx ||)
                        #f)
                        ,(if (and (>= y 0)
                                  (< y (##fixnum-width)))
                            `(test-equivalence
                              (,x ,y ,(+ y 3))
                              (bit-field bit-field-reverse)
                              fx ||)
                              `(begin 
                                 (test-error #t (fxbit-field ,x ,y ,(+ y 1)))
                                 (test-error #t (fxbit-field-reverse ,x ,y ,(+ y 1)))))
                        (test-equal
                          (values->list (+/carry ,x ,y 1))
                          (values->list (fx+/carry ,x ,y 1)))
                        (test-equal
                          (values->list (-/carry ,x ,y 1))
                          (values->list (fx-/carry ,x ,y 1)))
                        (test-equal
                          (values->list (*/carry ,x ,y 1))
                          (values->list (fx*/carry ,x ,y 1)))
                        (test-equal
                           ,(bit-field-rotate x y 1 3)
                           (fxbit-field-rotate ,x ,y 1 3))
                        (if (or (< ,x 0) (>= ,x fx-width))
                            (begin
                            (test-error #t (fxcopy-bit ,x ,y #t))
                            (test-error #t (fxcopy-bit ,x ,y #f)))
                            (begin
                            (test-equal
                              (fxcopy-bit ,x ,y #t)
                              (copy-bit ,x ,y #t))
                            (test-equal
                              (fxcopy-bit ,x ,y #f)
                              (copy-bit ,x ,y #f))))
                        (test-equal 
                          ,(bitwise-and x y) 
                          (fxand ,x ,y))
                        (test-equal 
                          ,(bitwise-ior x y) 
                          (fxior ,x ,y))
                        (test-equal 
                          ,(bitwise-if x y (min x y)) 
                          (fxif  ,x ,y ,(min x y)))
                        (test-equal 
                          ,(bitwise-if (max x y) x y) 
                          (fxif ,(max x y) ,x ,y))
                        (test-equal 
                          ,(bitwise-xor x y) 
                          (fxxor ,x ,y))
                        (if (or (>= ,x fx-width) (< ,x 0))
                          (test-error #t (fxbit-set? ,x ,y))
                          (test-equal (bit-set? ,x ,y) (fxbit-set? ,x ,y)))
                        (if (or (>= ,(abs y) fx-width) (> (arithmetic-shift ,x ,y) fx-greatest))
                           (test-error #t (fxarithmetic-shift ,x ,y))
                           (test-equal
                             (arithmetic-shift ,x ,y)
                             (fxarithmetic-shift ,x ,y)))
                        (if (or (< ,y 0) (>= ,y fx-width) (> (arithmetic-shift ,x ,y) fx-greatest))
                           (test-error #t (fxarithmetic-shift-left ,x ,y))
                           (test-equal
                             (arithmetic-shift ,x ,y)
                             (fxarithmetic-shift ,x ,y)))
                        (if (or (< ,y 0) (>= ,y fx-width) (> (arithmetic-shift ,x ,(* -1 y)) fx-greatest))
                           (test-error #t (fxarithmetic-shift-right ,x ,y))
                           (test-equal
                             (arithmetic-shift ,x ,(* -1 y))
                             (fxarithmetic-shift-right ,x ,y)))

))) vals)))) vals)))

(test-assert (>= fx-width 24))
(test-equal (- (expt 2 (- fx-width 1)) 1) fx-greatest)
(test-equal (* -1 (expt 2 (- fx-width 1))) fx-least)
(test-equal (fixnum? 2) #t)
(test-equal (fixnum? 3) #t)
(test-equal (fixnum? #\c) #f)
(test-equal (fixnum? #f) #f)
(test-error #t (fx+ 1 1 1))
(test-error #t (fx- 1 1 1))
(test-error #t (fx* 1 1 1))
(test-error #t (fxneg 1 2))
(test-fixnum-operations (1 3 2 45 56 423 6 56 -3 5 4 0 (##greatest-fixnum)  (##least-fixnum)))
