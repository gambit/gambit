;; Main program.
(import (scheme base)
        (only (example life) life)
        (rename (prefix (example grid) grid-)
                (grid-make make-grid)))

;; grid-set! didn't work due to macro as variable

;; Initialize a grid with a glider
(define grid (make-grid 41 50))

(do ((i 20 (+ i 1)))
    ((= i 30))
    (grid-set! grid 21 i #t))
#;(grid-put! grid 1 1 #t)
#;(grid-put! grid 2 2 #t)
#;(grid-put! grid 3 0 #t)
#;(grid-put! grid 3 1 #t)
#;(grid-put! grid 3 2 #t)

;; Run for 5000 iterations.
(life grid 5000)
