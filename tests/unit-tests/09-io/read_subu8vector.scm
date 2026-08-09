(include "#.scm")

(test-equal
 '(0 #u8(0 1 2 3 4 5 6 7))
 (with-input-from-u8vector
  '#u8()
  (lambda ()
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-subu8vector u8vect 2 5) u8vect)))))

(test-equal
 '(2 #u8(0 1 11 22 4 5 6 7))
 (with-input-from-u8vector
  '#u8(11 22)
  (lambda ()
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-subu8vector u8vect 2 5) u8vect)))))

(test-equal
 '(3 #u8(0 1 11 22 33 5 6 7))
 (with-input-from-u8vector
  '#u8(11 22 33 44 55)
  (lambda ()
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-subu8vector u8vect 2 5) u8vect)))))

(test-equal
 '(3 #u8(0 1 11 22 33 5 6 7))
 (call-with-input-u8vector
  '#u8(11 22 33 44 55)
  (lambda (port)
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-subu8vector u8vect 2 5 port) u8vect)))))

(test-equal
 '(3 #u8(0 1 11 22 33 5 6 7))
 (call-with-input-u8vector
  '#u8(11 22 33 44 55)
  (lambda (port)
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-subu8vector u8vect 2 5 port 0) u8vect)))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (let ((u8vect (u8vector 0 1 2 3 4 5 6 7))) (read-subu8vector)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (let ((u8vect (u8vector 0 1 2 3 4 5 6 7))) (read-subu8vector u8vect 2)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
   (read-subu8vector u8vect 2 5 (current-input-port) 0 #f)))

(test-error-tail type-exception? (read-subu8vector #f 2 5))

(test-error-tail
 type-exception?
 (let ((u8vect (u8vector 0 1 2 3 4 5 6 7))) (read-subu8vector u8vect #f 5)))

(test-error-tail
 type-exception?
 (let ((u8vect (u8vector 0 1 2 3 4 5 6 7))) (read-subu8vector u8vect 2 #f)))

(test-error-tail
 type-exception?
 (let ((u8vect (u8vector 0 1 2 3 4 5 6 7))) (read-subu8vector u8vect 2 5 #f)))
