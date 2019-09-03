
;; ----------------------------------------------------------------------------
;; process manipulation primitives

;; * Get the pid of the current process.
(define self (let () (##namespace ("")) current-thread))

;; Base exception handler for Termite processes.
(define (base-exception-handler e)
  ((let () (##namespace ("")) continuation-capture)
    (lambda (k)
      (let ((log-crash
              (lambda (e)
                (termite-log
                  'error
                  (list
                    (call-with-output-string ""
                      (lambda (port)
                        ((let () (##namespace ("")) display-exception-in-context) e k port))))))))
        (cond
          ;; Propagated Termite exception?
          ((termite-exception? e)
           (if (not (eq? (termite-exception-reason e) 'normal))
               (log-crash (termite-exception-object e)))
           (for-each
             (lambda (pid) (! pid e))
             (process-links (self)))
           (halt!))
          ;; Gambit exception in the current process
          (else
            (log-crash e)
            (for-each
              (lambda (pid)
                (! pid (make-termite-exception (self) 'failure e)))
              (process-links (self)))
            (halt!)))))))


;; * Start a new process executing the code in 'thunk'.
(define (spawn thunk #!key (links '()) (name 'anonymous))
  (let ((t ((let () (##namespace ("")) make-thread)
       (lambda ()
         (with-exception-handler
         base-exception-handler
         thunk)
         (shutdown!))
             name)))
  ((let () (##namespace ("")) thread-specific-set!) t links)
  ((let () (##namespace ("")) thread-start!) t)
  t))


(define (spawn-linked-to to thunk #!key (name 'anonymous-linked-to))
  (spawn thunk links: (list to) name: name))


;; * Start a new process with a bidirectional link to the current
;; process.
(define (spawn-link thunk #!key (name 'anonymous-linked))
  (let ((pid (spawn thunk links: (list (self)) name: name)))
  (outbound-link pid)
  pid))


;; * Start a new process on remote node 'node', executing the code
;; in 'thunk'.
(define (remote-spawn node thunk #!key (links '()) (name 'anonymous-remote))
  (if (equal? node (current-node))
    (spawn thunk links: links name: name)
    (!? (remote-service 'spawner node)
      (list 'spawn thunk links name))))


;; * Start a new process on remote node 'node', with a bidirectional
;; link to the current process.
(define (remote-spawn-link node thunk)
  (let ((pid (remote-spawn node thunk links: (list (self)))))
  (outbound-link pid)
  pid))


;; * Cleanly stop the execution of the current process.  Linked
;; processes will receive a "normal" exit message.
(define (shutdown!)
  (for-each
  (lambda (pid)
    (! pid (make-termite-exception (self) 'normal #f)))
  (process-links (self)))
  (halt!))

;; this is *not* nice: it wont propagate the exit message to the other
;; processes
(define (halt!)
  ((let () (##namespace ("")) thread-terminate!) ((let () (##namespace ("")) current-thread))))


;; * Forcefully terminate a local process.  Warning: it only works on
;; local processes!  This should be used with caution.
(define (terminate! victim)
  ((let () (##namespace ("")) thread-terminate!) victim)
  (for-each
  (lambda (link)
    (! link (make-termite-exception victim 'terminated #f)))
  (process-links victim)))


;; TODO 'wait-for' and 'alive?' should be grouped in a more general
;; procedure able to determine the status of a process (alive, dead,
;; waiting, etc.) and the procedure should work on remote processes

;; * Wait for the end of a process 'pid'.  Does not return anything.
;; Warning: will not work on remote processes.
(define (%wait-for pid)
  (with-exception-catcher
  (lambda (e)
    (void))
  (lambda ()
    ((let () (##namespace ("")) thread-join!) pid)
    (void))))


;; Check whether the process 'pid' is still alive.  Warning: will not
;; work on remote processes.
(define (%alive? pid)
  (with-exception-catcher
  (lambda (e)
    ((let () (##namespace ("")) join-timeout-exception?) e))
  (lambda ()
    ((let () (##namespace ("")) thread-join!) pid 0)
    #f)))

