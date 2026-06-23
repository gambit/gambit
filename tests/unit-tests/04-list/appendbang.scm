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

(test-equal '() (append!))

(test-equal 99 (append! 99))
(test-equal 99 (append! '() 99))
(test-equal 99 (append! '() '() 99))
(test-equal 99 (append! '() '() '() 99))

(test-equal '(11 . 99) (append! (list 11) 99))
(test-equal '(11 . 99) (append! (list 11) '() 99))
(test-equal '(11 . 99) (append! '() (list 11) '() 99))
(test-equal '(11 . 99) (append! '() '() (list 11) 99))

(test-equal '(11 22 . 99) (append! (list 11 22) 99))
(test-equal '(11 22 . 99) (append! (list 11 22) '() 99))
(test-equal '(11 22 . 99) (append! (list 11) (list 22) 99))
(test-equal '(11 22 . 99) (append! '() (list 11 22) 99))
(test-equal '(11 22 . 99) (append! (list 11 22) '() '() 99))
(test-equal '(11 22 . 99) (append! (list 11) (list 22) '() 99))
(test-equal '(11 22 . 99) (append! (list 11) '() (list 22) 99))
(test-equal '(11 22 . 99) (append! '() (list 11 22) '() 99))
(test-equal '(11 22 . 99) (append! '() (list 11) (list 22) 99))
(test-equal '(11 22 . 99) (append! '() '() (list 11 22) 99))

(test-error-tail type-exception? (append! 11 99))
(test-error-tail type-exception? (append! (cons 11 22) 99))
(test-error-tail type-exception? (append! (cons 11 22) '(33) 99))
(test-error-tail type-exception? (append! (cons 11 22) '() '(33) 99))
(test-error-tail type-exception? (append! '() 11 99))
(test-error-tail type-exception? (append! '() '(11) '() 22 99))
(test-error-tail type-exception? (append! '() '(11) '() '(22 . 33) 99))
