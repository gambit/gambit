(declare (extended-bindings) (not constant-fold) (not safe))

(define (print-list lst)
  (println "vvvvvvvvvvvvvv")
  (let loop ((lst lst))
    (if (##pair? lst)
        (begin
          (println (##car lst))
          (loop (##cdr lst)))))
  (println "^^^^^^^^^^^^^^")
  (println ""))

(define (f0 . z)
  (print-list z))

(define (f1 a . z)
  (println a)
  (print-list z))

(define (f2 a b . z)
  (println a)
  (println b)
  (print-list z))

(define (f3 a b c . z)
  (println a)
  (println b)
  (println c)
  (print-list z))

(define (f4 a b c d . z)
  (println a)
  (println b)
  (println c)
  (println d)
  (print-list z))

(f0)
(f0 1)
(f0 1 2)
(f0 1 2 3)
(f0 1 2 3 4)
(f0 1 2 3 4 5)

(f1 1)
(f1 1 2)
(f1 1 2 3)
(f1 1 2 3 4)
(f1 1 2 3 4 5)

(f2 1 2)
(f2 1 2 3)
(f2 1 2 3 4)
(f2 1 2 3 4 5)

(f3 1 2 3)
(f3 1 2 3 4)
(f3 1 2 3 4 5)

(f4 1 2 3 4)
(f4 1 2 3 4 5)
