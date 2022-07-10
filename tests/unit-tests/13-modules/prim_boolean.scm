(include "#.scm")

(check-same-behavior ("" "##" "~~lib/gambit/prim/boolean#.scm")

;; R4RS

(boolean? #f) (boolean? #t) (boolean? 123)
(not #f) (not #t) (not 123)

;; R7RS

(boolean=?) (boolean=? #f) (boolean=? #f #f) (boolean=? #f #t) (boolean=? #f #f #f)

)
