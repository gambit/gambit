(define (keys-rest a b c #!key (k1 "default") (k2 "default") . rest)
  (println a)
  (println b)
  (println c)
  (println (length rest))
  (println k1))

(keys-rest 1 2 3)

(keys-rest 1 2 3
           1 2 3 4 5 6 7 8)

(keys-rest 1 2 3
           k1: "key value"
           1 2 3 4 5 6 7 8)

(keys-rest 1 2 3
           k2: "key value"
           k1: "key value"
           1 2 3 4 5 6 7 8)

(keys-rest k1: 1000 1
           2 3 1 2 3 4 5 6 7 8)
