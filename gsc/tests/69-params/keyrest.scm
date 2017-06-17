(define (keys-rest a b c #!key (k1 "default1") (k2 "default2") . rest)
  (println a)
  (println b)
  (println c)
  (println k1)
  (println k2))

(keys-rest 1 2 3)

(keys-rest 1 2 3
           1 2 3 4 5 6 7 8)

(keys-rest 1 2 3
           k1: "key value"
           1 2 3 4 5 6 7 8)

(keys-rest 1 2 3
           k2: "key value")

(keys-rest 1 2 3
           k2: "key value"
           k1: "key value"
           1 2 3 4 5 6 7 8)

(keys-rest k1: 1000 1
           2 3 1 2 3 4 5 6 7 8)
