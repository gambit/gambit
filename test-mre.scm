;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (C) Siegfried Gonzi 2002
;;
;; a translation of the C++ version written
;; by Scott Robert Ladd.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(declare (version-limit 1) (inlining-limit 0) (standard-bindings) (extended-bindings) (not safe) (block))


(define TEST_LOOPS (##first-argument 999))

(define (run i) (if (##= i TEST_LOOPS) 'WRONG 'OK)) ;; wrong specifically when using a global here

(run 0)


