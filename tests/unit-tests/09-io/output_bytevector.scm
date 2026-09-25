(include "#.scm")

(test-equal
 #u8(66)
 (let ((p (open-output-bytevector)))
   (write-u8 66 p)
   (let ((v (get-output-bytevector p)))
     (close-port p)
     v)))

(test-error-tail wrong-number-of-arguments-exception? (open-output-bytevector #f))
(test-error-tail type-exception? (get-output-bytevector 1))
(test-error-tail wrong-number-of-arguments-exception? (get-output-bytevector))
