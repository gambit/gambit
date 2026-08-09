(include "#.scm")

(define t (make-thread (lambda () (thread-sleep! .01))))

(thread-start! t)

(thread-sleep! .02)
