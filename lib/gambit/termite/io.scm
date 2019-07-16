
;; io.scm
;; Reaceiving/Sending message.

;; incorrect, because it doesn't handle exception messages
;; (define ? (let () (##namespace ("")) thread-receive))

;; * Retrieve the first message from the mailbox of the current
;; process.  If no message is available, the process will block until
;; a message is received.  If 'timeout' is specified, the process will
;; only block for that amount of time, and then raise an exception.
;; It is possible to also pass the 'default' argument to return a
;; value instead of raising an exception.
(define (? . opt) ;; TODO: inefficient, fix
  (match opt
  (()
   (recv
     (msg msg)))

  ((timeout)
   (recv
     (msg msg)
     (after timeout ((let () (##namespace ("")) thread-receive) 0))))

  ((timeout default)
   (recv
     (msg msg)
     (after timeout default)))))


;; benchmark to see if faster...
;; (define (? #!optional (timeout +inf.0) (default (lambda ((let () (##namespace ("")) thread-receive) 0))))
;;   (with-exception-catcher
;;    (lambda (exception)
;;      (if (mailbox-receive-timeout-exception? exception)
;;          (default)
;;          (raise exception)))
;;    (lambda ()
;;      ((let () (##namespace ("")) thread-receive) timeout))))


;; * Retrieve the first message from the mailbox of the current
;; process that satisfised the predicate 'pred?'.  If no message
;; qualifies, the process will block until a message satisfying the
;; predicate is received.  If 'timeout' is specified, the process will
;; only block for that amount of time, and then raise an exception.
;; It is possible to also pass the 'default' argument to return a
;; value instead of raising an exception.
;; TODO: inefficient, fix
(define (?? pred? . opt)
  (match opt
  (()
   (recv
     (msg (where (pred? msg)) msg)))

  ((timeout)
   (recv
     (msg (where (pred? msg)) msg)
     (after timeout ((let () (##namespace ("")) thread-receive) 0))))

  ((timeout default)
   (recv
     (msg (where (pred? msg)) msg)
     (after timeout default)))))


;; ----------------------------------------------------------------------------
;; Higher-order concurrency primitives

;; * Send a "synchronous" message to a process.  The message will be
;; annotated with a tag and the pid of the current process, therefore
;; sending a message of the form '(from tag msg)'.  The server
;; receiving the message must specifically handle that format of
;; message, and reply with a message of the form '(tag reply)'.
;;
;; Like for the |?| and |??| message retrieving operators, it is
;; possible to specify a 'timeout' to limit the amount of time to wait
;; for a reply, and a 'default' value to return if no reply has been
;; received.
;; RPC
(define (!? pid msg . opt)
  (let ((tag (make-tag)))
  (! pid (list (self) tag msg))

  (match opt
    (()
     (recv
     ((,tag reply) reply)))

    ((timeout)
     (recv
     ((,tag reply) reply)
     (after timeout (raise 'timeout))))

    ((timeout default)
     (recv
     ((,tag reply) reply)
     (after timeout default))))))


;; * Evaluate a 'thunk' on a remote node and return the result of that
;; evaluation.  Just like for |!?|, |?| and |??|, it is possible to
;; specify a 'timeout' and a 'default' argument.
(define (on node thunk)
  (let ((tag (make-tag))
    (from (self)))
  (remote-spawn node
          (lambda ()
          (! from (list tag (thunk)))))
  (recv
    ((,tag reply) reply))))


