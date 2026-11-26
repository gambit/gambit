(include "#.scm")

;; Each endpoint must protect the same shared buffers and wait predicates.
;; Pin the server to another processor to exercise simultaneous endpoint
;; access; otherwise wakeups can migrate both conversations to one processor.
;; Pinning is only a scheduling aid.  The I/O operations are public APIs.
(define (check-pipe open-pipe read-one write-one)
  (receive (client server) (open-pipe)
    (define worker
      (make-thread
        (lambda ()
          (let loop ((i 0))
            (if (= i 10000)
                #t
                (let ((expected (modulo i 251))
                      (value (read-one server)))
                  (if (equal? value expected)
                      (begin
                        (write-one value server)
                        (force-output server)
                        (loop (+ i 1)))
                      (list 'server i value))))))))

    ;; Bound a lost-wakeup regression instead of waiting forever for a read.
    (input-port-timeout-set! client 10)
    (input-port-timeout-set! server 10)

    (if (> (##current-vm-processor-count) 1)
        (begin
          (##thread-pin! (current-thread) (##processor 0))
          (##thread-pin! worker (##processor 1))))
    (thread-start! worker)

    (let ((result
           (let loop ((i 0))
             (if (= i 10000)
                 #t
                 (let ((expected (modulo i 251)))
                   (write-one expected client)
                   (force-output client)
                   (let ((value (read-one client)))
                     (if (equal? value expected)
                         (loop (+ i 1))
                         (list 'client i value))))))))
      (close-output-port client)
      (test-equal #t result)
      (test-equal #t (thread-join! worker 12 'worker-timeout)))

    (close-port client)
    (close-port server)
    (if (> (##current-vm-processor-count) 1)
        (##thread-pin! (current-thread) #f))))

(check-pipe open-vector-pipe read write)
(check-pipe open-string-pipe
            read
            (lambda (value port) (write value port) (newline port)))
(check-pipe open-u8vector-pipe read-u8 write-u8)
