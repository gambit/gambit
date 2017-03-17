(include "#.scm")

(define (iota n)
  (let loop ((i (- n 1)) (lst '()))
    (if (>= i 0)
        (loop (- i 1) (cons i lst))
        lst)))

(define iterations 1000000)
(define nb-competing-threads 10)
(define nb-independent-threads
  (quotient (+ (##current-vm-processor-count) 1) 2))

(define (run test)
  (for-each thread-join!
            (map (lambda (id) (thread-start! (make-thread test)))
                 (iota nb-independent-threads))))

(define (flood target)

  (define threads #f)

  (define (inc!)
    ;; atomic increment of element at index 0
    (##primitive-unlock! (thread-specific (current-thread)) 0 0))

  (define (body)
    (let loop ((n iterations))
      (if (> n 0)
          (begin
            (thread-interrupt! target inc!)
            (loop (- n 1))))))

  (set! threads
        (map (lambda (id) (make-thread body))
             (iota nb-competing-threads)))

  (for-each thread-start! threads)
  (for-each thread-join! threads))

(define (test1)
  (let* ((loop?
          #t)
         (t
          (make-thread
           (lambda ()
             (let loop ()
               (let small-delay ((n 100)) (if (> n 0) (small-delay (- n 1))))
               (thread-yield!) ;; give interrupting threads a chance to run
               (if loop? (loop)))))))

    (thread-specific-set! t (vector 0))
    (thread-start! t)

    (flood t)

    (set! loop? #f) ;; terminate t

    (thread-join! t)

    (check-equal? (vector-ref (thread-specific t) 0)
                  (* iterations nb-competing-threads))))

(define (test2)
  (let ((t
         (make-thread
          (lambda ()
            (thread-sleep! 1000)))))

    (thread-specific-set! t (vector 0))
    (thread-start! t)

    (flood t)

    (thread-terminate! t) ;; terminate t

    (check-equal? (vector-ref (thread-specific t) 0)
                  (* iterations nb-competing-threads))))

(define (test3)
  (let* ((m
          (make-mutex))
         (t
          (make-thread
           (lambda ()
             (mutex-lock! m)))))

    (mutex-lock! m)
    (thread-specific-set! t (vector 0))
    (thread-start! t)

    (flood t)

    (mutex-unlock! m) ;; terminate t

    (thread-join! t)

    (check-equal? (vector-ref (thread-specific t) 0)
                  (* iterations nb-competing-threads))))

(define (test4)
  (let* ((m
          (make-mutex))
         (t
          (make-thread
           (lambda ()
             (mutex-lock! m 1000)))))

    (mutex-lock! m)
    (thread-specific-set! t (vector 0))
    (thread-start! t)

    (flood t)

    (mutex-unlock! m) ;; terminate t

    (thread-join! t)

    (check-equal? (vector-ref (thread-specific t) 0)
                  (* iterations nb-competing-threads))))

(define (test5)
  (let* ((m
          (make-mutex))
         (cv
          (make-condition-variable))
         (loop?
          #t)
         (loop-count
          0)
         (t
          (make-thread
           (lambda ()
             (let loop ()
               (mutex-lock! m)
               (if loop?
                   (begin
                     (set! loop-count (+ loop-count 1))
                     (mutex-unlock! m cv)
                     (loop))
                   (mutex-unlock! m)))))))

    (thread-specific-set! t (vector 0))
    (thread-start! t)

    (flood t)

    (mutex-lock! m)
    (set! loop? #f) ;; terminate t
    (condition-variable-signal! cv)
    (mutex-unlock! m)

    (thread-join! t)

    (check-true (> loop-count 1))

    (check-equal? (vector-ref (thread-specific t) 0)
                  (* iterations nb-competing-threads))))

(define (test6)
  (let* ((m
          (make-mutex))
         (cv
          (make-condition-variable))
         (loop?
          #t)
         (loop-count
          0)
         (t
          (make-thread
           (lambda ()
             (let loop ()
               (mutex-lock! m)
               (if loop?
                   (begin
                     (set! loop-count (+ loop-count 1))
                     (mutex-unlock! m cv 1000)
                     (loop))
                   (mutex-unlock! m)))))))

    (thread-specific-set! t (vector 0))
    (thread-start! t)

    (flood t)

    (mutex-lock! m)
    (set! loop? #f) ;; terminate t
    (condition-variable-signal! cv)
    (mutex-unlock! m)

    (thread-join! t)

    (check-true (> loop-count 1))

    (check-equal? (vector-ref (thread-specific t) 0)
                  (* iterations nb-competing-threads))))

(run test1)
(run test2)
(run test3)
(run test4)
(run test5)
(run test6)