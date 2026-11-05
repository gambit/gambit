(include "#.scm")

(test-eq
 42
 (let ((r #f))
   (call-with-output-string
    (lambda (p)
      (set! r (time (+ 40 2) p))))
   r))
