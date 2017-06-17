(declare (extended-bindings) (not safe))

(define (global-set! name val)
 (let ((gv (##make-global-var name)))
   (##global-var-primitive-set! gv val)))

(global-set!
 '##raise-wrong-number-of-arguments-exception-nary
 (lambda (proc . args)
   "wrong-number-of-arguments-exception"))

(global-set!
 '##raise-keyword-expected-exception-nary
 (lambda (proc . args)
   "keyword-expected-exception"))

(global-set!
 '##raise-unknown-keyword-argument-exception-nary
 (lambda (proc . args)
   "unknown-keyword-argument-exception"))

(define (len lst)
  (if (##pair? lst)
      (##fx+ 1 (len (##cdr lst)))
      0))

;; rest exceptions

(define (rest a b c . rest)
  (len rest))

(println (rest))
(println (rest 1))
(println (rest 1 2))
(println (rest 1 2 3))
(println (rest 1 2 3 4))
(println (rest 1 2 3 4 5))

;; key exceptions

(define (keys-and-required a b c d #!key (k1 999) (k2 (##fx+ k1 1)))
  (##fx+ (##fx* k1 1000) k2))

(println (keys-and-required))
(println (keys-and-required 1))
(println (keys-and-required 1 2))
(println (keys-and-required 1 2 3))
(println (keys-and-required 1 2 3 4))
(println (keys-and-required 1 2 3 4 5))
(println (keys-and-required k1: 10 k2: 20))
(println (keys-and-required 1 k1: 10 k2: 20))
(println (keys-and-required 1 2 k1: 10 k2: 20))
(println (keys-and-required 1 2 3 k1: 10 k2: 20))
(println (keys-and-required 1 2 3 4 k1: 10 k2: 20))
(println (keys-and-required 1 2 3 4 k1: 10))
(println (keys-and-required 1 2 3 4 k2: 20))
(println (keys-and-required 1 2 3 4 k1: 10 k2: 20))
(println (keys-and-required 1 2 3 4 k2: 20 k1: 10))
(println (keys-and-required 1 2 3 4 k2: 20 k1: 10 k2: 30))
(println (keys-and-required 1 2 3 4 k1: 10 k2: 20 19))
(println (keys-and-required 1 2 3 4 k1: 10 20 30))
(println (keys-and-required 1 2 3 4 k1: 10 k-not-found: 30))

;; key + rest exceptions

(define (keys-and-rest a b c d #!key (k1 999) (k2 (##fx+ k1 1)) . rest)
  (println (len rest))
  (##fx+ (##fx* k1 1000) k2))

(println (keys-and-rest))
(println (keys-and-rest 1))
(println (keys-and-rest 1 2))
(println (keys-and-rest 1 2 3))
(println (keys-and-rest 1 2 3 4))
(println (keys-and-rest 1 2 3 4 5))
(println (keys-and-rest k1: 10 k2: 20))
(println (keys-and-rest 1 k1: 10 k2: 20))
(println (keys-and-rest 1 2 k1: 10 k2: 20))
(println (keys-and-rest 1 2 3 k1: 10 k2: 20))
(println (keys-and-rest 1 2 3 4 k1: 10 k2: 20))
(println (keys-and-rest 1 2 3 4 k1: 10))
(println (keys-and-rest 1 2 3 4 k2: 20))
(println (keys-and-rest 1 2 3 4 k1: 10 k2: 20))
(println (keys-and-rest 1 2 3 4 k2: 20 k1: 10))
(println (keys-and-rest 1 2 3 4 k2: 20 k1: 10 k2: 30))
(println (keys-and-rest 1 2 3 4 k1: 10 k2: 20 19))
(println (keys-and-rest 1 2 3 4 k1: 10 20 30))
(println (keys-and-rest 1 2 3 4 k1: 10 k-not-found: 30))
