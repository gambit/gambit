(include "#.scm")

(test-eqv 42 (force 42))
(let ((p (delay (list 'value))))
  (test-equal '(value) (force p))
  (test-eq (force p) (force p)))

;; Reentrant forcing must retain the value cached by the inner force.
(letrec ((count 0)
         (p (delay
              (begin
                (set! count (+ count 1))
                (if (< count 6) (force p) count)))))
  (test-eqv 6 (force p))
  (test-eqv 6 (force p))
  (test-eqv 6 count))

;; An exception must not leave a promise-state lock held.
(let* ((first? #t)
       (p (delay
            (if first?
                (begin (set! first? #f) (raise 'retry))
                'value))))
  (test-eq 'retry (with-exception-catcher (lambda (e) e)
                   (lambda () (force p))))
  (test-eq 'value (force p)))

(let loop ((n 10000) (p (delay 'value)))
  (if (= n 0)
      (test-eq 'value (force p))
      (loop (- n 1) (delay-force p))))

;; Each worker records its own results; only promises are shared.
;; Check both completion and object identity, not just equal contents.
(define (check-concurrent-force wrap)
  (let* ((n 20000)
         (promises (make-vector n))
         (results (list (make-vector n) (make-vector n)))
         (threads '()))
    (let loop ((i 0))
      (if (< i n)
          (begin
            (vector-set!
             promises i
             (wrap
              (delay
                (let spin ((j 30))
                  (if (> j 0) (spin (- j 1)) (list i))))))
            (loop (+ i 1)))))
    (set! threads
          (map (lambda (result)
                 (make-thread
                  (lambda ()
                    (let loop ((i 0))
                      (if (< i n)
                          (begin
                            (vector-set! result i
                                         (force (vector-ref promises i)))
                            (loop (+ i 1)))))
                    'done)))
               results))
    (for-each thread-start! threads)
    (let ((completed
           (map (lambda (thread) (thread-join! thread 20 'timeout)) threads)))
      (test-equal '(done done) completed)
      (if (equal? completed '(done done))
          (let loop ((i 0) (mismatches 0))
            (if (= i n)
                (test-eqv 0 mismatches)
                (let ((a (vector-ref (car results) i))
                      (b (vector-ref (cadr results) i))
                      (cached (force (vector-ref promises i))))
                  (loop (+ i 1)
                        (+ mismatches
                           (if (and (eq? a b) (eq? a cached)
                                    (equal? a (list i)))
                               0 1))))))
          (for-each thread-terminate! threads)))))

(check-concurrent-force (lambda (p) p))
(check-concurrent-force (lambda (p) (delay-force p)))
