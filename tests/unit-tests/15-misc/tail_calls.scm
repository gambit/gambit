(include "#.scm")

(define old-generate-proper-tail-calls (generate-proper-tail-calls))

(test-assert (boolean? old-generate-proper-tail-calls))
(test-eq (void) (generate-proper-tail-calls #f))
(test-eq #f (generate-proper-tail-calls))
(test-eq (void) (generate-proper-tail-calls #t))
(test-eq #t (generate-proper-tail-calls))

(generate-proper-tail-calls old-generate-proper-tail-calls)
(test-eq old-generate-proper-tail-calls (generate-proper-tail-calls))

(test-error-tail wrong-number-of-arguments-exception? (generate-proper-tail-calls #t #f))
