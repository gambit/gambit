(declare (extended-bindings) (not constant-fold) (not safe))


(define (test val expected)
  (println (if (##fleqv? val expected)
               "same"
               "diff")))

(test (##flsquare 0.0) 0.0)
(test (##flsquare -0.0) 0.0)
(test (##flsquare 11.0) 121.0)
(test (##flsquare -11.0) 121.0)
(test (##flsquare 23170.0) 536848900.0)
(test (##flsquare -23170.0) 536848900.0)
(test (##flsquare 23171.0) 536895241.0)
(test (##flsquare -23171.0) 536895241.0)

(test (##flsquare 0.3) 0.09)
(test (##flsquare 11.3) 127.69000000000001)
(test (##flsquare -11.3) 127.69000000000001)
(test (##flsquare 23170.3) 536862802.09)
(test (##flsquare -23170.3) 536862802.09)
(test (##flsquare 23171.3) 536909143.6899999)
(test (##flsquare -23171.3) 536909143.6899999)

