(define-macro (init-compiled-feature!)
  (if (##not
       (##unbound?
        (##global-var-ref
         (##make-global-var '##compilation-options))))
      `(define-cond-expand-feature compiled)
      `(begin)))

(init-compiled-feature!)

(cond-expand

 (compiled
  (declare (standard-bindings) (fixnum) (not safe))
  (define loop-delay 12000)
  (define time-scale 100))

 (else
  (define loop-delay 37)
  (define time-scale 100)))

(define expo 101)
(define big (expt 11 expo))

(define (short-delay)
  (integer-sqrt big))

(define (start-short-thread)
  (thread-start!
   (make-thread
    (lambda ()
      (short-delay)))))

(define (delayed-thread-terminate! thread delay)
  (let loop ((i delay))
    (if (> i 0)
        (loop (- i 1))
        (thread-terminate! thread))))

(define count-inactive 0)
(define count-abandoned 0)

(define (go n)

  (define cycle (quotient (* loop-delay 5) 100)) ;; 5% variation in delay
  (define mod (* time-scale 1000))

  (let loop ((i 0))
    (if (= 0 (modulo i mod)) (pp i))
    (if (< i n)
        (begin
          (let ((t (start-short-thread)))
            (with-exception-catcher
             (lambda (exc)
               (cond ((inactive-thread-exception? exc)
                      (set! count-inactive (+ count-inactive 1))
                      #f)
                     ((abandoned-mutex-exception? exc)
                      (set! count-abandoned (+ count-abandoned 1))
                      #f)
                     (else
                      (raise exc))))
             (lambda ()
               (delayed-thread-terminate! t (+ loop-delay (modulo i cycle))))))
          (loop (+ i 1))))))

(go (* time-scale 60000))

(pp (list inactive: count-inactive abandoned: count-abandoned))
