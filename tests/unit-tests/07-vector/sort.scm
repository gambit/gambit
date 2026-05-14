(include "#.scm")

(define a #(1 3 2 5 4))
(vector-sort! < a)
(check-equal a #(1 2 3 4 5))

(define a #(1 3 6 4 2 5))
(vector-sort! < a 1 3)
(check-equal a #(1 3 4 6 2 5))

(define a #(21 33 65 54 2 5))
(vector-sort! < a 1 3)
(check-equal a #(21 33 54 65 2 5))
