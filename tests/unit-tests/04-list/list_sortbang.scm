(include "#.scm")

(test-equal
 '()
 (let ((lst (list))) (list-sort! (lambda (x y) (< (car x) (car y))) lst)))

(test-equal
 '((11 5) (22 2) (22 4) (33 1) (33 6) (55 3) (55 7))
 (let ((lst (list '(33 1) '(22 2) '(55 3) '(22 4) '(11 5) '(33 6) '(55 7))))
   (list-sort! (lambda (x y) (< (car x) (car y))) lst)))

(test-error-tail wrong-number-of-arguments-exception? (list-sort!))
(test-error-tail wrong-number-of-arguments-exception? (list-sort! <))

(test-error-tail type-exception? (list-sort! #f (list)))
(test-error-tail type-exception? (list-sort! < #f))
(test-error-tail type-exception? (list-sort! < (cons 1 2)))
