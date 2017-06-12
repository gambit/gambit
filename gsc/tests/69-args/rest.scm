(define (rest1 . rest)
  (println (car rest)))

(rest1 1)
(rest1 1 2 3 4)

(define (rest2 a . rest)
  (println a)
  (println (car rest)))

(rest2 1 2 3 4)
