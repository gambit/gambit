(define (optional #!optional a b c)
  (println a)
  (println b)
  (println c))

(optional)
(optional 1)
(optional 1 2 3)

(define (default-values #!optional (a 10) (b 20) (c 30))
  (println a)
  (println b)
  (println c))

(default-values)
(default-values 1)
(default-values 1 2)
(default-values 1 2 3)
