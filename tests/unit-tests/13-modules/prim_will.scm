(include "#.scm")

(check-same-behavior ("" "##" "~~lib/_prim-will#.scm")

;; Gambit

(will? (make-will (##cons 1 2) ##list))
(will-execute! (make-will (##cons 1 2) ##list))
(will-testator (make-will (##cons 1 2) ##list))
(will? (make-will (##cons 1 2) ##list)) (will? 123)

)
