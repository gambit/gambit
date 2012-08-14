(declare (extended-bindings) (not safe))

(println (##fx+? 11 33))
(println (##fx+? 11 -11))
(println (##fx+? 11 -33))
(println (##fx+? -11 33))
(println (##fx+? 536870910 0))
(println (##fx+? 536870910 1))
(println (##fx+? 536870910 2))
