(include "#.scm")

(define t
  (make-thread
   (lambda ()
     (thread-sleep! 0.01))))

(thread-start! t)

(thread-sleep! 0.02)
