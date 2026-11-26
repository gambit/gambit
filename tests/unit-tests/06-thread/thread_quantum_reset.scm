(include "#.scm")

;; Explicit heartbeats make time-slice accounting independent of CPU speed.
;; The long timer interval keeps real timer delivery out of these short tests.
(define saved-heartbeat (make-f64vector 1))
(##get-heartbeat-interval! saved-heartbeat 0)
(define saved-quantum (thread-quantum (current-thread)))
(##set-heartbeat-interval! 1000.0)
(thread-quantum-set! (current-thread) 3000.0)

(define processor (current-processor))
(define (make-local-thread thunk)
  (let ((thread (make-thread thunk)))
    (cond-expand
     (enable-smp (##thread-pin! thread processor))
     (else #f))
    thread))

;; A yield with no other runnable thread must also start a fresh quantum.
(thread-yield!)
(##thread-heartbeat!)
(##thread-heartbeat!)
(thread-yield!)
(define events '())
(define (record! event) (set! events (cons event events)))
(define worker (make-local-thread (lambda () (record! 'worker))))
(thread-start! worker)
(##thread-heartbeat!)
(record! 'one)
(##thread-heartbeat!)
(record! 'two)
(##thread-heartbeat!)
(record! 'three)
(thread-join! worker)
(test-equal '(one two worker three) (reverse events))

;; Every quantum, not just the first, must last for three heartbeats.
(set! events '())
(define (make-worker name)
  (make-local-thread
   (lambda ()
     (let loop ((n 0))
       (if (< n 9)
           (begin
             (record! name)
             (##thread-heartbeat!)
             (loop (+ n 1))))))))
(define a (make-worker 'a))
(define b (make-worker 'b))
(thread-start! a)
(thread-start! b)
(thread-join! a)
(thread-join! b)
(test-equal '(a a a b b b a a a b b b a a a b b b) (reverse events))

;; Blocking also starts a fresh quantum when the thread resumes.
(define (check-blocking-quantum block!)
  (let ((tester
         (make-local-thread
          (lambda ()
            (set! events '())
            (thread-yield!)
            (##thread-heartbeat!)
            (##thread-heartbeat!)
            (block!)
            (let ((worker (make-local-thread (lambda () (record! 'worker)))))
              (thread-start! worker)
              (##thread-heartbeat!)
              (record! 'one)
              (##thread-heartbeat!)
              (record! 'two)
              (##thread-heartbeat!)
              (record! 'three)
              (thread-join! worker))
            (test-equal '(one two worker three) (reverse events))))))
    (thread-start! tester)
    (thread-join! tester)))

(check-blocking-quantum
 (lambda ()
   (let ((worker (make-local-thread (lambda () #t))))
     (thread-start! worker)
     (thread-join! worker))))

(check-blocking-quantum (lambda () (thread-sleep! 0.001)))

;; A contended mutex resumes with a fresh quantum.
(check-blocking-quantum
 (lambda ()
   (let ((mutex (make-mutex)))
     (mutex-lock! mutex #f #f)
     (thread-start! (make-local-thread (lambda () (mutex-unlock! mutex))))
     (mutex-lock! mutex)
     (mutex-unlock! mutex))))

;; Waiting for a condition variable also ends the old quantum.
(check-blocking-quantum
 (lambda ()
   (let ((mutex (make-mutex)) (condvar (make-condition-variable)))
     (mutex-lock! mutex)
     (thread-start! (make-local-thread
                     (lambda () (condition-variable-signal! condvar))))
     (mutex-unlock! mutex condvar))))

(##set-heartbeat-interval! (f64vector-ref saved-heartbeat 0))
(thread-quantum-set! (current-thread) saved-quantum)
