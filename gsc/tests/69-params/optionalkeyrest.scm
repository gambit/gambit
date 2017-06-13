(define (all a b c #!optional opt #!key (key "default") . rest)
  (println a)
  (println b)
  (println c)
  (println "optional :")
  (println opt)
  (println "key :")
  (println key))

(all 5 4 3)

(all 1 2 3
     "option"
     key: "key value"
     1 2 3 4 5 6 7 8)
