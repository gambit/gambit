;; For documentation make sure the same random numbers are generated.

(random-source-state-set!
 default-random-source
 (random-source-state-ref (make-random-source)))

(random-source-pseudo-randomize! default-random-source 31 15)
