(include "#.scm")

(test-equal
 '#()
 (let ((v (vector))) (vector-sort! (lambda (x y) (< (car x) (car y))) v) v))

(test-equal
 '#((11 5) (22 2) (22 4) (33 1) (33 6) (55 3) (55 7))
 (let ((v (vector '(33 1) '(22 2) '(55 3) '(22 4) '(11 5) '(33 6) '(55 7))))
   (vector-sort! (lambda (x y) (< (car x) (car y))) v)
   v))

(test-equal
 '#((33 1) (22 2) (11 5) (22 4) (33 6) (55 3) (55 7))
 (let ((v (vector '(33 1) '(22 2) '(55 3) '(22 4) '(11 5) '(33 6) '(55 7))))
   (vector-sort! (lambda (x y) (< (car x) (car y))) v 2)
   v))

(test-equal
 '#((33 1) (22 2) (11 5) (22 4) (55 3) (33 6) (55 7))
 (let ((v (vector '(33 1) '(22 2) '(55 3) '(22 4) '(11 5) '(33 6) '(55 7))))
   (vector-sort! (lambda (x y) (< (car x) (car y))) v 2 5)
   v))

(test-equal
 '#((33 1) (22 2) (55 3) (22 4) (11 5) (33 6) (55 7))
 (let ((v (vector '(33 1) '(22 2) '(55 3) '(22 4) '(11 5) '(33 6) '(55 7))))
   (vector-sort! (lambda (x y) (< (car x) (car y))) v 2 2)
   v))

(test-error-tail wrong-number-of-arguments-exception? (vector-sort!))
(test-error-tail wrong-number-of-arguments-exception? (vector-sort! <))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-sort! < (vector) 0 0 #f))

(test-error-tail type-exception? (vector-sort! #f (vector)))
(test-error-tail type-exception? (vector-sort! < #f))
(test-error-tail type-exception? (vector-sort! < (vector) #f))
(test-error-tail type-exception? (vector-sort! < (vector) 0 #f))

(test-error-tail range-exception? (vector-sort < (vector 3 1 2) -1))
(test-error-tail range-exception? (vector-sort < (vector 3 1 2) 0 4))
(test-error-tail range-exception? (vector-sort < (vector 3 1 2) 2 1))
