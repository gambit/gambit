(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

;; proper lists
(define lst0 '())
(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

;; dotted list
(define lst3 (cons 11 (cons 22 (cons 33 44))))

;; circular-lists
(define lst4 (list 11))
(set-cdr! lst4 lst4)
(define lst5 (list 11 22))
(set-cdr! (cdr lst5) lst5)
(define lst6 (list 11 22 33))
(set-cdr! (cddr lst6) lst6)
(define lst7 (list 11 22 33))
(set-cdr! (cddr lst7) (cdr lst7))

(check-eqv? (length+ lst0) 0)
(check-eqv? (length+ lst1) 3)
(check-eqv? (length+ lst2) 4)

(check-eqv? (length+ lst4) #f)
(check-eqv? (length+ lst5) #f)
(check-eqv? (length+ lst6) #f)
(check-eqv? (length+ lst7) #f)

(check-tail-exn type-exception? (lambda () (length+ str)))
(check-tail-exn type-exception? (lambda () (length+ int)))
(check-tail-exn type-exception? (lambda () (length+ bool)))
(check-tail-exn type-exception? (lambda () (length+ lst3)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (length+)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (length+ bool bool)))
