(include "#.scm")

(if (= (##current-vm-processor-count) 2)
    (let* ((started? #f)
           (t
            (thread-start!
             (make-thread
              (lambda ()
                (set! started? #t)
                (let loop ()
                  (##void)
                  (loop)))))))
      (let wait ()
        (if (not started?)
            (begin
              (thread-yield!)
              (wait))))
      (check-equal? (thread-terminate! t) (void)))
    (check-equal? #t #t))
