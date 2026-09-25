(include "#.scm")

(define old-bt (repl-backtrace-detail-level))
(define old-hl (repl-highlight-source-level))

(test-assert (fixnum? old-bt))
(test-assert (fixnum? old-hl))

(repl-backtrace-detail-level 2)
(test-equal 2 (repl-backtrace-detail-level))
(repl-backtrace-detail-level old-bt)
(test-equal old-bt (repl-backtrace-detail-level))

(repl-highlight-source-level 0)
(test-equal 0 (repl-highlight-source-level))
(repl-highlight-source-level old-hl)
(test-equal old-hl (repl-highlight-source-level))
