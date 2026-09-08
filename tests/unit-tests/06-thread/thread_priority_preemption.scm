(include "#.scm")

(define current (current-thread))
(define processor (current-processor))
(define saved-base-priority (thread-base-priority current))
(define saved-quantum (thread-quantum current))

(thread-base-priority-set! current 0)
(thread-quantum-set! current 1000)

(define (make-pinned-thread thunk)
  (let ((thread (make-thread thunk)))
    (##thread-pin! thread processor)
    thread))

;; Starting a higher-priority thread on the current processor preempts
;; the caller before thread-start! returns.
(define start-ran? #f)
(define start-worker
  (make-pinned-thread
   (lambda ()
     (set! start-ran? #t)
     'started)))
(thread-base-priority-set! start-worker 10)
(thread-start! start-worker)
(test-eq #t start-ran?)
(test-eq 'started (thread-join! start-worker))

;; Raising the priority of a runnable thread also preempts the caller.
(define priority-ran? #f)
(define priority-worker
  (make-pinned-thread
   (lambda ()
     (set! priority-ran? #t)
     'reprioritized)))
(thread-start! priority-worker)
(test-eq #f priority-ran?)
(thread-base-priority-set! priority-worker 10)
(test-eq #t priority-ran?)
(test-eq 'reprioritized (thread-join! priority-worker))

;; Signaling a higher-priority waiter preempts the signaling thread.
(define mutex (make-mutex))
(define condvar (make-condition-variable))
(define waiting? #f)
(define signal-ran? #f)
(define signal-worker
  (make-pinned-thread
   (lambda ()
     (mutex-lock! mutex)
     (set! waiting? #t)
     (mutex-unlock! mutex condvar)
     (set! signal-ran? #t)
     'signaled)))
(thread-base-priority-set! signal-worker 10)
(thread-start! signal-worker)
(test-eq #t waiting?)
(test-eq #f signal-ran?)
(mutex-lock! mutex)
(condition-variable-signal! condvar)
(test-eq #t signal-ran?)
(mutex-unlock! mutex)
(test-eq 'signaled (thread-join! signal-worker))

;; Unlocking a mutex for a higher-priority waiter preempts the owner.
(define unlock-mutex (make-mutex))
(define unlock-ran? #f)
(define unlock-worker
  (make-pinned-thread
   (lambda ()
     (mutex-lock! unlock-mutex)
     (set! unlock-ran? #t)
     (mutex-unlock! unlock-mutex)
     'unlocked)))
(mutex-lock! unlock-mutex)
(thread-base-priority-set! unlock-worker 10)
(thread-start! unlock-worker)
(test-eq #f unlock-ran?)
(mutex-unlock! unlock-mutex)
(test-eq #t unlock-ran?)
(test-eq 'unlocked (thread-join! unlock-worker))

;; An already-expired condition-variable wait also preempts a waiter
;; made runnable by releasing its mutex.
(define expired-mutex (make-mutex))
(define expired-condvar (make-condition-variable))
(define expired-ran? #f)
(define expired-worker
  (make-pinned-thread
   (lambda ()
     (mutex-lock! expired-mutex)
     (set! expired-ran? #t)
     (mutex-unlock! expired-mutex)
     'expired)))
(mutex-lock! expired-mutex)
(thread-base-priority-set! expired-worker 10)
(thread-start! expired-worker)
(test-eq #f expired-ran?)
(test-eq #f (mutex-unlock! expired-mutex expired-condvar 0))
(test-eq #t expired-ran?)
(test-eq 'expired (thread-join! expired-worker))

(thread-base-priority-set! current saved-base-priority)
(thread-quantum-set! current saved-quantum)
