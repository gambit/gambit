(declare
 (standard-bindings)
 (fixnum)
 (not safe))
;; (not interrupts-enabled))

(define (fact n)
  (if (fx< n 2)
      1
      (fx* n (fact (fx- n 1)))))

(print (fact 6))
