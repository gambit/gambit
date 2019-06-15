(include "#.scm")

(check-same-behavior ("" "##" "~~lib/_prim-box#.scm")

;; Gambit

(box 5)
(box? 5) (box? (box 5))
(let ((x (box 5))) (set-box! x 7) (unbox x))
(unbox (box 5))

)
