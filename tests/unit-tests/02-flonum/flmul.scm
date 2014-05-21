(include "#.scm")

(check-eqv? (##fl* 0.11   0.33)    0.0363)
(check-eqv? (##fl* 0.11  -0.11)    -0.0121)
(check-eqv? (##fl* 0.11  -0.33)    -0.0363)
(check-eqv? (##fl* -0.11 0.33)     -0.0363)


(check-eqv? (##fl*)                     1.)
(check-eqv? (##fl* 0.11)                0.11)
(check-eqv? (##fl* 0.11 0.22)           0.0242)
(check-eqv? (##fl* 0.11 0.22 0.33)      0.007986)
(check-eqv? (##fl* 0.11 0.22 0.33 0.44) 0.00351384)

(check-eqv? (fl* 0.11   0.33)    0.0363)
(check-eqv? (fl* 0.11  -0.11)    -0.0121)
(check-eqv? (fl* 0.11  -0.33)    -0.0363)
(check-eqv? (fl* -0.11 0.33)     -0.0363)

(check-eqv? (fl*)                     1.)
(check-eqv? (fl* 0.11)                0.11)
(check-eqv? (fl* 0.11 0.22)           0.0242)
(check-eqv? (fl* 0.11 0.22 0.33)      0.007986)
(check-eqv? (fl* 0.11 0.22 0.33 0.44) 0.00351384)

(check-tail-exn type-exception? (lambda () (fl* 1)))
(check-tail-exn type-exception? (lambda () (fl* 1 4.2)))
(check-tail-exn type-exception? (lambda () (fl* 0.5 9)))
(check-tail-exn type-exception? (lambda () (fl* 0.5 9 4.2)))
(check-tail-exn type-exception? (lambda () (fl* 0.5 9 4.2)))
(check-tail-exn type-exception? (lambda () (fl* 0.5 9 4.2)))
