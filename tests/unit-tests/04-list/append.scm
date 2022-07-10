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

(check-equal? (append) '())

(check-equal? (append 99) 99)
(check-equal? (append '() 99) 99)
(check-equal? (append '() '() 99) 99)
(check-equal? (append '() '() '() 99) 99)

(check-equal? (append '(11) 99) '(11 . 99))
(check-equal? (append '(11) '() 99) '(11 . 99))
(check-equal? (append '() '(11) '() 99) '(11 . 99))
(check-equal? (append '() '() '(11) 99) '(11 . 99))

(check-equal? (append '(11 22) 99) '(11 22 . 99))
(check-equal? (append '(11 22) '() 99) '(11 22 . 99))
(check-equal? (append '(11) '(22) 99) '(11 22 . 99))
(check-equal? (append '() '(11 22) 99) '(11 22 . 99))
(check-equal? (append '(11 22) '() '() 99) '(11 22 . 99))
(check-equal? (append '(11) '(22) '() 99) '(11 22 . 99))
(check-equal? (append '(11) '() '(22) 99) '(11 22 . 99))
(check-equal? (append '() '(11 22) '() 99) '(11 22 . 99))
(check-equal? (append '() '(11) '(22) 99) '(11 22 . 99))
(check-equal? (append '() '() '(11 22) 99) '(11 22 . 99))

(check-tail-exn type-exception? (lambda () (append 11 99)))
(check-tail-exn type-exception? (lambda () (append '(11 . 22) 99)))
(check-tail-exn type-exception? (lambda () (append '(11 . 22) '(33) 99)))
(check-tail-exn type-exception? (lambda () (append '(11 . 22) '() '(33) 99)))
(check-tail-exn type-exception? (lambda () (append '() 11 99)))
(check-tail-exn type-exception? (lambda () (append '() '(11) '() 22 99)))
(check-tail-exn type-exception? (lambda () (append '() '(11) '() '(22 . 33) 99)))
