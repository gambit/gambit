(include "#.scm")

(test-assert (eq? #t (thread-group? (thread-thread-group (current-thread)))))
(test-assert (eq? #f (thread-group? #f)))
(test-assert (eq? #f (thread-group? (current-thread))))
(test-assert (eq? #f (thread-group? 'primordial)))

(define tg-unnamed (make-thread-group))
(test-assert (eq? #t (thread-group? tg-unnamed)))
(test-equal (void) (thread-group-name tg-unnamed))
(test-eq (thread-thread-group (current-thread)) (thread-group-parent tg-unnamed))

(define tg-named (make-thread-group 'named))
(test-eq 'named (thread-group-name tg-named))
(test-eq (thread-thread-group (current-thread)) (thread-group-parent tg-named))

(define parent (make-thread-group 'parent))
(define child (make-thread-group 'child parent))
(test-eq 'child (thread-group-name child))
(test-eq parent (thread-group-parent child))
(test-eq 'parent (thread-group-name parent))

(define orphan (make-thread-group 'orphan #f))
(test-eq 'orphan (thread-group-name orphan))
(test-eq #f (thread-group-parent orphan))

(test-eq #f (thread-group-specific parent))
(test-equal (void) (thread-group-specific-set! parent 'meta))
(test-eq 'meta (thread-group-specific parent))
(test-eq #f (thread-group-specific child))

(define t-child (make-thread (lambda () 111) 't-child child))
(test-eq child (thread-thread-group t-child))
(test-assert (memq t-child (thread-group->thread-list child)))
(test-assert (memq child (thread-group->thread-group-list parent)))

(test-assert
 (eq? #t (vector? (thread-group->thread-vector child))))
(test-assert
 (eq? #t (vector? (thread-group->thread-group-vector parent))))

(test-error-tail type-exception? (thread-group-name #f))
(test-error-tail type-exception? (thread-group-parent #f))
(test-error-tail type-exception? (thread-group-specific #f))
(test-error-tail type-exception? (thread-group-specific-set! #f 'x))
(test-error-tail type-exception? (thread-group->thread-list #f))
(test-error-tail type-exception? (thread-group->thread-vector #f))
(test-error-tail type-exception? (thread-group->thread-group-list #f))
(test-error-tail type-exception? (thread-group->thread-group-vector #f))
(test-error-tail type-exception? (thread-group-suspend! #f))
(test-error-tail type-exception? (thread-group-resume! #f))
(test-error-tail type-exception? (thread-group-terminate! #f))
(test-error-tail type-exception? (make-thread-group 'x 123))

(test-error-tail wrong-number-of-arguments-exception? (thread-group?))
(test-error-tail wrong-number-of-arguments-exception? (thread-group? #t #f))
(test-error-tail wrong-number-of-arguments-exception? (thread-group-name))
(test-error-tail wrong-number-of-arguments-exception? (thread-group-name parent #f))
(test-error-tail wrong-number-of-arguments-exception? (thread-group-parent))
(test-error-tail wrong-number-of-arguments-exception? (thread-group-specific))
(test-error-tail wrong-number-of-arguments-exception? (thread-group-specific-set! parent))
(test-error-tail
 wrong-number-of-arguments-exception?
 (thread-group-specific-set! parent 'x #f))
(test-error-tail wrong-number-of-arguments-exception? (make-thread-group 'a parent #f))
