(include "#.scm")

(check-same-behavior ("" "##" "~~lib/_prim-vector#.scm")

;; R4RS

(list->vector '(1 2 3))
(vector-length (make-vector 5)) (make-vector 5 9)
(vector) (vector 1) (vector 1 2) (vector 1 2 3)
(vector->list '#(1 2 3 4 5))
(let ((x (vector 1 2 3 4 5))) (vector-fill! x 99) x)
(let ((x (vector 1 2 3 4 5))) (vector-fill! x 99 1) x)
(let ((x (vector 1 2 3 4 5))) (vector-fill! x 99 1 3) x)
(vector-length '#(1 2 3 4 5))
(vector-ref '#(1 2 3 4 5) 2)
(let ((x (vector 1 2 3 4 5))) (vector-set! x 2 99) x)
(vector? '#(1 2 3)) (vector? 123)

;; R7RS

(vector-append) (vector-append '#(1)) (vector-append '#(1) '#(2)) (vector-append '#(1) '#(2) '#(3))
(vector-copy '#(1 2 3 4 5))
(vector-copy '#(1 2 3 4 5) 1)
(vector-copy '#(1 2 3 4 5) 1 3)
(let ((x (vector 1 2 3 4)) (y (vector 6 7 8 9 0))) (vector-copy! y 1 x) y)
(let ((x (vector 1 2 3 4)) (y (vector 6 7 8 9 0))) (vector-copy! y 1 x 2) y)
(let ((x (vector 1 2 3 4)) (y (vector 6 7 8 9 0))) (vector-copy! y 1 x 2 3) y)
;;unimplemented;;(vector-for-each vector '#(1 2)) (vector-for-each vector '#(1) '#(2)) (vector-for-each vector '#(1) '#(2) '#(3))
;;unimplemented;;(vector-map vector '#(1 2)) (vector-map vector '#(1) '#(2)) (vector-map vector '#(1) '#(2) '#(3))

;; Gambit

(append-vectors '(#(1) #(2) #(3)))
(vector-set '#(1 2 3 4 5) 2 99)
(let ((x (vector 1 2 3 4 5))) (vector-shrink! x 3) x)
(subvector '#(1 2 3 4 5) 1 3)
(let ((x (vector 1 2 3 4 5))) (subvector-fill! x 1 3 99) x)
(let ((x (vector 1 2 3 4)) (y (vector 6 7 8 9 0))) (subvector-move! x 2 3 y 1) y)
(let ((x (vector 5))) (vector-cas! x 0 6 5) x)
(let ((x (vector 5))) (vector-inc! x 0) x)

)
