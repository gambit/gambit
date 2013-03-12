(declare (extended-bindings) (not constant-fold) (not safe))

(println (##fx+ 11 33))
(println (##fx+ 11 -11))
(println (##fx+ 11 -33))
(println (##fx+ -11 33))

(println (##fx+))
(println (##fx+ 11))
(println (##fx+ 11 22))
(println (##fx+ 11 22 33))
(println (##fx+ 11 22 33 44))
