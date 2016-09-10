;;; DDERIV -- Table-driven symbolic derivation.

;;; Returns the wrong answer for quotients.
;;; Fortunately these aren't used in the benchmark.

(define (lookup key table)
  (let loop ((x table))
    (if (null? x)
      #f
      (let ((pair (car x)))
        (if (eq? (car pair) key)
          pair
          (loop (cdr x)))))))

(define properties '())

(define (get key1 key2)
  (let ((x (lookup key1 properties)))
    (if x
      (let ((y (lookup key2 (cdr x))))
        (if y
          (cdr y)
          #f))
      #f)))

(define (put key1 key2 val)
  (let ((x (lookup key1 properties)))
    (if x
      (let ((y (lookup key2 (cdr x))))
        (if y
          (set-cdr! y val)
          (set-cdr! x (cons (cons key2 val) (cdr x)))))
      (set! properties
        (cons (list key1 (cons key2 val)) properties)))))

(define (my+dderiv a)
  (cons '+
        (map dderiv (cdr a))))

(define (my-dderiv a)
  (cons '-
        (map dderiv (cdr a))))

(define (*dderiv a)
  (list '*
         a
         (cons '+
               (map (lambda (a) (list '/ (dderiv a) a)) (cdr a)))))

(define (/dderiv a)
  (list '-
        (list '/
              (dderiv (cadr a))
              (caddr a))
        (list '/
              (cadr a)
              (list '*
                    (caddr a)
                    (caddr a)
                    (dderiv (caddr a))))))

(put '+ 'dderiv my+dderiv)
(put '- 'dderiv my-dderiv)
(put '* 'dderiv *dderiv)
(put '/ 'dderiv /dderiv)

(define (dderiv a)
  (if (not (pair? a))
    (if (eq? a 'x) 1 0)
    (let ((f (get (car a) 'dderiv)))
      (if f
        (f a)
        (fatal-error "No derivation method available")))))

(define (main . args)
  (run-benchmark
    "dderiv"
    dderiv-iters
    (lambda (result)
      (equal? result
              '(+ (* (* 3 x x) (+ (/ 0 3) (/ 1 x) (/ 1 x)))
                  (* (* a x x) (+ (/ 0 a) (/ 1 x) (/ 1 x)))
                  (* (* b x) (+ (/ 0 b) (/ 1 x)))
                  0)))
    (lambda (a) (lambda () (dderiv a)))
    '(+ (* 3 x x) (* a x x) (* b x) 5)))
