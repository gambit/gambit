;; All hail the RECV form
(define-macro (recv . clauses)
  (let ((msg  (gensym 'msg))   ;; the current mailbox message
        (loop (gensym 'loop))) ;; the mailbox seeking loop

    ;; check the last clause to see if it's a timeout
    (let ((sesualc (reverse clauses)))
      (if (and (pair? (car sesualc))
               (eq? (caar sesualc) 'after))

        (let ((clauses (reverse (cdr sesualc)))
              ;; the code to compute the timeout
              (init (cadar sesualc))
              ;; the variable holding the timeout
              (timeout (gensym 'timeout))
              ;; the code to be executed on a timeout
              (on-timeout (cddar sesualc))
              ;; the timeout exception-handler to the whole match
              (e (gensym 'e)))

          ;; RECV code when there is a timeout
          `(let ((,timeout ,init))
             (with-exception-catcher
               (lambda (,e)
                 (if ((let () (##namespace ("")) mailbox-receive-timeout-exception?) ,e)
                   (begin
                     ((let () (##namespace ("")) thread-mailbox-rewind))
                     ,@on-timeout)
                   (raise ,e)))
               (lambda ()
                 (let ,loop ((,msg ((let () (##namespace ("")) thread-mailbox-next) ,timeout)))
                   (match/action
                     ((let () (##namespace ("")) thread-mailbox-extract-and-rewind))
                     (,loop
                       ((let () (##namespace ("")) thread-mailbox-next) ,timeout))
                     ,msg
                     ;; extra clause to handle system events
                     (event
                       (where (termite-exception? event))
                       (handle-exception-message event))
                     ;; the user clauses
                     ,@clauses))))))

        ;; RECV code when there is no timeout
        `(let ,loop ((,msg ((let () (##namespace ("")) thread-mailbox-next))))
           (match/action
             ((let () (##namespace ("")) thread-mailbox-extract-and-rewind))
             (,loop
               ((let () (##namespace ("")) thread-mailbox-next)))
             ,msg
             ;; extra clause to handle system events
             (event
               (where (termite-exception? event))
               (handle-exception-message event))
             ;; the user clauses
             ,@clauses))))))

