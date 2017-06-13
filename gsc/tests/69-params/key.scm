(define (one-key #!key a)
  (println a))

(one-key)
(one-key a: "value")

(define (one-key-default #!key (a "default"))
  (println a))

(one-key-default)
(one-key-default a: "value")

(define (multiple-keys #!key a b c)
  (println a)
  (println b)
  (println c))

(multiple-keys)
(multiple-keys b: "value")
(multiple-keys a: "value")
(multiple-keys c: 123 a: 456)

(define (multiple-keys-default #!key (a "default a") (b "default b") (c "default c"))
  (println a)
  (println b)
  (println c))

(multiple-keys-default)
(multiple-keys-default b: "value")
(multiple-keys-default a: "value")
(multiple-keys-default c: 123 a: 456)

(define (keys-and-required a b c #!key (k1 "default") (k2 "default"))
  (println a)
  (println b)
  (println c)
  (println k1)
  (println k2))

(keys-and-required 1 2 3)
(keys-and-required 1 2 3 k1: "value1")
(keys-and-required 1 2 3 k2: "value2")
(keys-and-required 1 2 3 k2: "value2" k1: "value1")
(keys-and-required 1 2 3 k1: "value1" k2: "value2")
