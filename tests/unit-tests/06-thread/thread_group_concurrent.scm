(include "#.scm")

(cond-expand
 (enable-smp
  (define parent (make-thread-group 'parent #f))
  (define count 1000)
  (define workers
    (map (lambda (id)
           (thread-start!
            (make-thread
             (lambda ()
               (let loop ((n count) (groups '()))
                 (if (= n 0)
                     groups
                     (loop (- n 1)
                           (cons (make-thread-group n parent) groups))))))))
         (iota 4)))
  (define groups (map thread-join! workers))

  ;; Keep every child reachable independently so GC cannot discard it while
  ;; checking that concurrent insertions all reached the parent's child list.
  (test-equal (* count (length workers))
              (length (thread-group->thread-group-list parent)))
  (test-equal (* count (length workers))
              (apply + (map length groups))))
 (else
  (test-equal #t #t)))
