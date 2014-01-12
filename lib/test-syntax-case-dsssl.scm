
(or (eq? ((lambda () 'pass)) 'pass)
    (error '(fail 1)))

(or (eq? ((lambda (a) a) 'pass) 'pass)
    (error '(fail 2)))

(or (equal? ((lambda (a . r) `(,a . ,r)) 'pass) '(pass))
    (error '(fail 2a)))

(or (equal? ((lambda (a b) `(,a ,b)) 1 2) '(1 2))
    (error '(fail 3)))

(or (equal? ((lambda (#!optional a) a) #f) #f)
    (error '(fail 4)))

(or (equal? ((lambda (a #!optional b) `(,a ,b)) 1) '(1 #f))
    (error '(fail 5)))

(or (equal? ((lambda (a #!optional b) `(,a ,b)) 1 2) '(1 2))
    (error '(fail 6)))

(or (equal? ((lambda (a #!optional (b 3)) `(,a ,b)) 1) '(1 3))
    (error '(fail 7)))

(or (equal? ((lambda (a #!optional (b 3)) `(,a ,b)) 1 4) '(1 4))
    (error '(fail 8)))

(or (equal? ((lambda (a #!optional (b 3) #!rest r) `(,a ,b ,r)) 1 4 5 6) '(1 4 (5 6)))
    (error '(fail 8a)))

(or (equal? ((lambda (#!key a) a)) #f)
    (error '(fail 9)))

(or (equal? ((lambda (#!key (a 4)) a)) 4)
    (error '(fail 10)))

(or (equal? ((lambda (#!key a) a) a: 1) 1)
    (error '(fail 11)))

(or (equal? ((lambda (x #!key a) `(,x ,a)) 4 a: 1) '(4 1))
    (error '(fail 12)))

(or (equal? ((lambda (x #!optional o #!key a) `(,x ,o ,a)) 4) '(4 #f #f))
    (error '(fail 13)))

(or (equal? ((lambda (x #!optional o #!key a) `(,x ,o ,a)) 4 1) '(4 1 #f))
    (error '(fail 14)))

(or (equal? ((lambda (x #!optional o #!key a) `(,x ,o ,a)) 4 1 a: 2) '(4 1 2))
    (error '(fail 15)))

(or (equal? ((lambda (x #!optional o #!key a #!rest r) `(,x ,o ,a ,r)) 4 1 2 3 5 6) '(4 1 #f (2 3 5 6)))
    (error '(fail 16)))

(or (equal? ((lambda (x #!optional o #!key a #!rest r) `(,x ,o ,a ,r)) 4 1 a: 2 3 5 6) '(4 1 2 (3 5 6)))
    (error '(fail 17)))

(or (equal? ((lambda (x #!optional o #!key a . r) `(,x ,o ,a ,r)) 4 1 a: 2 3 5 6) '(4 1 2 (3 5 6)))
    (error '(fail 17a)))

(or (equal? (let ((a 1))
              ((lambda (#!optional (b (begin (+ 1 a)))) b))) 2)
    (error '(fail 18)))

(or (equal? (let ((a 1))
              ((lambda (#!optional (b (begin (+ 1 a)))) b))) 2)
    (error '(fail 19)))
