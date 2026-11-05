(include "#.scm")

(define p (open-input-string "xy"))
(test-assert (exact-integer? (input-port-characters-buffered p)))
(test-assert (>= (input-port-characters-buffered p) 0))
(close-port p)

(define b (open-input-u8vector '#u8(1 2 3)))
(test-assert (exact-integer? (input-port-bytes-buffered b)))
(test-assert (>= (input-port-bytes-buffered b) 0))
(close-port b)

(test-error-tail type-exception? (input-port-characters-buffered 1))
(test-error-tail wrong-number-of-arguments-exception? (input-port-characters-buffered))
(test-error-tail type-exception? (input-port-bytes-buffered 1))
