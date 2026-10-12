(include "#.scm")

;; A snapshot remains a valid collection of distinct threads even when
;; another processor removes threads from their group during enumeration.
(define count 2000)

(define (check-snapshot group snapshot)
  (let ((seen (make-vector count #f)))
    (test-assert (<= (length snapshot) count))
    (for-each
     (lambda (thread)
       (test-eq group (thread-thread-group thread))
       (let ((id (thread-name thread)))
         (test-eq #f (vector-ref seen id))
         (vector-set! seen id #t)))
     snapshot)))

(let rounds ((round 0))
  (if (< round 10)
      (let* ((group (make-thread-group 'snapshot #f))
             (members
              (let loop ((n count) (threads '()))
                (if (= n 0)
                    threads
                    (loop (- n 1)
                          (cons (make-thread (lambda () #f) (- n 1) group)
                                threads))))))
        (test-equal count (vector-length (thread-group->thread-vector group)))
        (test-equal count (length (thread-group->thread-list group)))
        (let ((worker
               (thread-start!
                (make-thread
                 (lambda ()
                   (for-each
                    (lambda (thread)
                      (thread-terminate! thread)
                      (thread-yield!))
                    members))))))
          (let snapshots ((n 30))
            (if (> n 0)
                (begin
                  (check-snapshot
                   group
                   (vector->list (thread-group->thread-vector group)))
                  (check-snapshot group (thread-group->thread-list group))
                  (snapshots (- n 1)))))
          (thread-join! worker))
        (test-equal '#() (thread-group->thread-vector group))
        (test-equal '() (thread-group->thread-list group))
        (rounds (+ round 1)))))
