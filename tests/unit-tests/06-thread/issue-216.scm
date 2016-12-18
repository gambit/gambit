(include "#.scm")

;;; Create some threads but don't start them.

(define t1
  (make-thread
   (lambda ()
     (thread-sleep! 0.02)
     (println "t1 ending"))))

(define t2
  (make-thread
   (lambda ()
     (thread-sleep! 0.02)
     (println "t2 ending"))))

(define t3
  (make-thread
   (lambda ()
     (println "t3 ending"))))

(define t4
  (make-thread
   (lambda ()
     (println "t4 ending"))))


;;; Interrupting a thread after it begins executing the body
;;; has always worked:

(println "t1 starting")

(thread-start! t1)

(thread-sleep! 0.01)

(thread-interrupt! t1 (lambda () (println "t1 interrupt")))

(thread-sleep! 0.05)


;;; Multiple interruptions has caused problems in the past:

(println "t2 starting")

(thread-start! t2)

(thread-sleep! 0.01)

(thread-interrupt! t2 (lambda () (println "t2 interrupt #1")))
(thread-interrupt! t2 (lambda () (println "t2 interrupt #2")))
(thread-interrupt! t2 (lambda () (println "t2 interrupt #3")))

(thread-sleep! 0.05)


;;; Interrupting a thread after it is started but before it begins
;;; executing the body has caused problems in the past:

(println "t3 starting")

(thread-start! t3)

(thread-interrupt! t3 (lambda () (println "t3 interrupt")))

(thread-sleep! 0.05)
