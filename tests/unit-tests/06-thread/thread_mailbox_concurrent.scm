(include "#.scm")

(cond-expand
 (enable-smp

  (define senders 4)

  (##cvmr senders)

  (define (test-concurrent-mailbox-initialization)
    (define trials 2000)
    (define ready-a (make-vector trials #f))
    (define ready-b (make-vector trials #f))
    (define receivers
      (let ((result (make-vector trials)))
        (let loop ((i 0))
          (if (< i trials)
              (begin
                (vector-set!
                 result
                 i
                 (make-thread
                  (lambda ()
                    (let ((first (thread-receive 2.0 'timeout))
                          (second (thread-receive 2.0 'timeout)))
                      (+ (if (eq? first 'timeout) 0 1)
                         (if (eq? second 'timeout) 0 1))))))
                (loop (+ i 1)))))
        result))
    (define (send-all mine other value)
      (let loop ((i 0))
        (if (< i trials)
            (begin
              (vector-set! mine i #t)
              (let wait ()
                (if (not (vector-ref other i))
                    (begin
                      (thread-yield!)
                      (wait))))
              (thread-send (vector-ref receivers i) value)
              (loop (+ i 1))))))
    (let ((sender-a
           (make-thread (lambda () (send-all ready-a ready-b 'a))))
          (sender-b
           (make-thread (lambda () (send-all ready-b ready-a 'b)))))
      (##thread-pin! sender-a (##processor 1))
      (##thread-pin! sender-b (##processor 2))
      (thread-start! sender-a)
      (thread-start! sender-b)
      (thread-join! sender-a)
      (thread-join! sender-b))
    (let start ((i 0))
      (if (< i trials)
          (begin
            (thread-start! (vector-ref receivers i))
            (start (+ i 1)))))
    (let count ((i 0) (received 0))
      (if (= i trials)
          received
          (count (+ i 1)
                 (+ received (thread-join! (vector-ref receivers i)))))))

  (test-equal 4000 (test-concurrent-mailbox-initialization))

  (define messages-per-sender 25000)
  (define expected (* senders messages-per-sender))

  (define receiver
    (make-thread
     (lambda ()
       (let loop ((received 0))
         (if (= received expected)
             received
             (let ((message (thread-receive 2.0 'timeout)))
               (if (eq? message 'timeout)
                   received
                   (loop (+ received 1)))))))))

  (define sender-threads
    (let loop ((id 0) (result '()))
      (if (= id senders)
          result
          (loop
           (+ id 1)
           (cons
            (make-thread
             (lambda ()
               (let send ((remaining messages-per-sender))
                 (if (> remaining 0)
                     (begin
                       (thread-send receiver id)
                       (send (- remaining 1)))))))
            result)))))

  (##thread-pin! receiver (##processor 0))
  (let pin ((threads sender-threads) (processor-id 1))
    (if (pair? threads)
        (begin
          (##thread-pin! (car threads) (##processor processor-id))
          (pin (cdr threads) (+ 1 (modulo processor-id 3))))))
  (thread-start! receiver)
  (for-each thread-start! sender-threads)
  (for-each thread-join! sender-threads)
  (test-equal expected (thread-join! receiver)))

 (else))
