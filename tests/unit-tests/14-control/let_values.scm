(include "#.scm")

(test-equal
 3
 (let-values (((a b) (values 1 2)))
   (+ a b)))

(test-equal
 6
 (let-values (((a b c) (values 1 2 3)))
   (+ a b c)))

(test-equal
 '(1 2)
 (let-values (((a . rest) (values 1 2)))
   (cons a rest)))

(test-equal
 3
 (let*-values (((a b) (values 1 2))
               ((c) (values (+ a b))))
   c))
