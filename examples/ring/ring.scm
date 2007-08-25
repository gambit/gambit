#! /usr/local/Gambit-C/bin/gsi-script

; File: "ring.scm", Time-stamp: <2007-04-04 14:35:17 feeley>

(declare (standard-bindings))

(define (joes-challenge n m) ; uses mailboxes

  (define (create-processes)

    (declare (fixnum) (not safe))

    (define (action)
      (let ((neighbor (thread-receive)))
        (let loop ((j m))
          (if (> j 0)
            (let ((message (thread-receive)))
              (thread-send neighbor message)
              (loop (- j 1)))))))

    (let loop ((i n) (processes '()))
      (if (> i 0)
          (loop (- i 1)
                (cons (make-thread action) processes))
          processes)))

  (let* ((point1
          (cpu-time))
         (processes
          (create-processes))
         (point2
          (cpu-time))
         (neighbors
          (append (cdr processes) (list (car processes))))
         (first-process
          (car processes))
         (last-process
          (car (reverse processes)))
         (point3
          (cpu-time)))

    (map thread-send neighbors processes)

    (thread-send last-process 'go)
    (for-each thread-start! processes)
    (thread-join! first-process)

    (let ((point4
           (cpu-time)))

      (display "Time to create a thread: ")
      (display (/ (- point2 point1) n))
      (display " secs.\n")
      (display "Time to send+receive a message and suspend+wake up a thread: ")
      (display (/ (- point4 point3) (* n m)))
      (display " secs.\n"))))

(define (joes-challenge-old n m) ; uses FIFOs

  (define (create-processes)

    (declare (fixnum) (not safe))

    (define (iota n)
      (iota-aux n '()))

    (define (iota-aux n lst)
      (if (= n 0)
          lst
          (iota-aux (- n 1) (cons n lst))))

    (let* ((1-to-n
            (iota n))
           (channels
            (list->vector
             (map (lambda (i) (open-vector))
                  1-to-n)))
           (processes
            (map (lambda (i)
                   (let ((input (vector-ref channels (modulo (- i 1) n)))
                         (output (vector-ref channels (modulo i n))))
                     (make-thread
                      (lambda ()
                        (let loop ((j m))
                          (if (> j 0)
                              (let ((message (read input)))
                                (write message output)
                                (force-output output)
                                (loop (- j 1)))))))))
                 1-to-n)))
      (write 'go (vector-ref channels 1))
      (force-output (vector-ref channels 1))
      processes))

  (let* ((point1
          (cpu-time))
         (processes
          (create-processes))
         (point2
          (cpu-time)))

    (for-each thread-start! processes)
    (thread-join! (car processes))

    (let ((point3
           (cpu-time)))

      (display "Time to create a thread: ")
      (display (/ (- point2 point1) n))
      (display " secs.\n")
      (display "Time to send+receive a message and suspend+wake up a thread: ")
      (display (/ (- point3 point2) (* n m)))
      (display " secs.\n"))))

(define (main . args)

  (define (usage) (display "usage: ring <nb-processes>\n"))

  (if (null? args)
      (usage)
      (let ((n (string->number (car args))))
        (if (not (and (integer? n)
                      (exact? n)
                      (>= n 2)
                      (<= n 1000000)))
            (usage)
            (let ((m (quotient 1000000 n)))
              (display "There are n=")
              (display n)
              (display " threads organized as a ring.\n")
              (display "A message will go around the ring m=")
              (display m)
              (display " times.\n")
              (time (joes-challenge n m)))))))
