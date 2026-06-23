(include "#.scm")

;;; Test special values

(test-eqv 0 (tan 0))

;;; Test for accuracy near 0

(test-eqv 1e-30+1e-40i (tan 1e-30+1e-40i))

;;; Tests derived from https://github.com/racket/racket/issues/3324

(test-assert (eq? #f (zero? (real-part (tan 20+300i)))))
(test-assert
 (eq? #t
      (rational?
       (real-part (tan 1.3482698511467367e308+266.42844752772896i)))))

;;; Test exceptions

(test-error-tail type-exception? (tan 'a))

