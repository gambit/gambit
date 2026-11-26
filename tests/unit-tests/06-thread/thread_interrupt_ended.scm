(include "#.scm")

(cond-expand
 (enable-smp
  ;; An interrupt may reach the propagation helper after the target ends.
  ;; Exercise that state directly so the test does not depend on race timing.
  (define (check-ended-target target)
    (let ((request (make-mutex (lambda () 'unused))))
      (mutex-specific-set! request target)
      (##thread-intr-propagate! (vector '() request))
      ;; Use trylock before public operations: a leaked lock must fail the
      ;; regression rather than hang the test suite in thread-state.
      (let ((acquired? (##primitive-trylock! target 1 9)))
        (test-assert acquired?)
        (if acquired?
            (begin
              (##primitive-unlock! target 1 9)
              (test-assert
               (or (thread-state-normally-terminated? (thread-state target))
                   (thread-state-abnormally-terminated? (thread-state target)))))))))

  (define normal (thread-start! (make-thread (lambda () 'finished))))
  (test-equal 'finished (thread-join! normal))
  (check-ended-target normal)

  (define abnormal
    (thread-start! (make-thread (lambda () (raise 'finished-with-error)))))
  (test-error uncaught-exception? (thread-join! abnormal))
  (check-ended-target abnormal))
 (else
  ;; The unicore scheduler has a different interruption implementation.
  (test-assert #t)))
