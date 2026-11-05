(include "#.scm")

(define cv1 (make-condition-variable))
(define cv2 (make-condition-variable 'cv2))
(define mtx (make-mutex))

(test-equal (void) (condition-variable-name cv1))
(test-eq 'cv2 (condition-variable-name cv2))

(test-equal (void) (condition-variable-specific cv1))
(test-equal (void) (condition-variable-specific-set! cv1 'meta))
(test-eq 'meta (condition-variable-specific cv1))

(mutex-lock! mtx)
(test-equal (void) (condition-variable-signal! cv1))
(test-equal (void) (condition-variable-broadcast! cv1))
(mutex-unlock! mtx)

(test-error-tail type-exception? (condition-variable-broadcast! #f))
(test-error-tail type-exception? (condition-variable-signal! #f))
(test-error-tail type-exception? (condition-variable-name #f))
(test-error-tail type-exception? (condition-variable-specific #f))
(test-error-tail wrong-number-of-arguments-exception? (condition-variable-broadcast!))
