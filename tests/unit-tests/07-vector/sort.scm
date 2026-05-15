(include "#.scm")

(define a #(1 3 2 5 4))
(vector-sort! < a)
(check-equal? #(1 2 3 4 5) a)

(check-equal? #(1 2 3 4 5) (vector-sort  < #(1 3 2 5 4)))

(define a #(1 3 6 4 2 5))
(vector-sort! < a 1 4)
(check-equal? #(1 3 4 6 2 5) a)
(check-equal? #(1 3 4 6 2 5) (vector-sort  < #(1 3 6 4 2 5) 1 4))

(define a #(21 33 65 54 2 5))
(vector-sort! < a 1 4)
(check-equal? a #(21 33 54 65 2 5))
(check-equal? #(21 33 54 65 2 5) (vector-sort < #(21 33 65 54 2 5) 1 4))

(define a #(21 33 65 54 2 5))
(vector-sort! < a 1 4)
(check-equal? #(21 33 54 65 2 5) a)
(check-equal? #(21 33 54 65 2 5) (vector-sort < #(21 33 65 54 2 5) 1 4))

(define a #(1 3 2 5 4))
(vector-sort! > a)
(check-equal? #(5 4 3 2 1) a)
(check-equal? #(5 4 3 2 1) (vector-sort > #(1 3 2 5 4)))

(define a #(1 3 6 4 2 5))
(vector-sort! > a 1 4)
(check-equal? #(1 6 4 3 2 5) a)
(check-equal? #(1 6 4 3 2 5) (vector-sort > #(1 3 6 4 2 5) 1 4))

(define a #(21 33 65 54 2 5))
(vector-sort! > a 1 4)
(check-equal? #(21 65 54 33 2 5) a)
(check-equal? #(21 65 54 33 2 5) (vector-sort > #(21 33 65 54 2 5) 1 4))

(define a #(21 33 65 54 2 5))
(vector-sort! > a 1 4)
(check-equal? #(21 65 54 33 2 5) a)
(check-equal? #(21 65 54 33 2 5) (vector-sort > #(21 33 65 54 2 5) 1 4))

(define a #(1.5 2.3 0.0 65 54 1.0 5))
(vector-sort! > a 0 0)
(check-equal? #(1.5 2.3 0.0 65 54 1.0 5) a)
(check-equal? #(1.5 2.3 0.0 65 54 1.0 5) (vector-sort > #(1.5 2.3 0.0 65 54 1.0 5) 0 0))

(check-equal? (vector-sort! < #(1 3 2 4 5)) #(1 2 3 4 5)) ;; ensure vector-sort! return sorted vector

(define a #((1 . 0) (1 . 3) (2 . 2) (65 54) (1 . 5)))
(vector-sort! (lambda (x y) (< (car x) (car y))) a)
(check-equal? #((1 . 0) (1 . 3) (1 . 5) (2 . 2) (65 54)) a) ;; stabillity test
(check-equal? #((1 . 0) (1 . 3) (1 . 5) (2 . 2) (65 54)) a) ;; stabillity te)(vector-sort < #((1 . 0) (1 . 3) (2 . 2) (65 54) (1 . 5))t

(define a #("aaaa" "bbb" "aab" "ddc" "eef" "gga" "ggf"))
(vector-sort! string<? a)
(check-equal? #("aaaa" "aab" "bbb" "ddc" "eef" "gga" "ggf") a)
(check-equal? #("aaaa" "aab" "bbb" "ddc" "eef" "gga" "ggf") (vector-sort string<? #("aaaa" "bbb" "aab" "ddc" "eef" "gga" "ggf")))


