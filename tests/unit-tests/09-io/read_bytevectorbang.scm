(include "#.scm")

(test-equal
 '(#!eof #u8(0 1 2 3 4 5 6 7))
 (with-input-from-u8vector
  '#u8()
  (lambda ()
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-bytevector! u8vect) u8vect)))))

(test-equal
 '(2 #u8(11 22 2 3 4 5 6 7))
 (with-input-from-u8vector
  '#u8(11 22)
  (lambda ()
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-bytevector! u8vect) u8vect)))))

(test-equal
 '(2 #u8(11 22 2 3 4 5 6 7))
 (call-with-input-u8vector
  '#u8(11 22)
  (lambda (port)
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-bytevector! u8vect port) u8vect)))))

(test-equal
 '(2 #u8(0 1 2 11 22 5 6 7))
 (call-with-input-u8vector
  '#u8(11 22)
  (lambda (port)
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-bytevector! u8vect port 3) u8vect)))))

(test-equal
 '(5 #u8(0 1 2 11 22 33 44 55))
 (call-with-input-u8vector
  '#u8(11 22 33 44 55 66 77)
  (lambda (port)
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-bytevector! u8vect port 3) u8vect)))))

(test-equal
 '(1 #u8(0 1 2 11 4 5 6 7))
 (call-with-input-u8vector
  '#u8(11 22)
  (lambda (port)
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-bytevector! u8vect port 3 4) u8vect)))))

(test-equal
 '(0 #u8(0 1 2 3 4 5 6 7))
 (call-with-input-u8vector
  '#u8(11 22)
  (lambda (port)
    (let ((u8vect (u8vector 0 1 2 3 4 5 6 7)))
      (list (read-bytevector! u8vect port 3 3) u8vect)))))

(test-error-tail wrong-number-of-arguments-exception? (read-bytevector!))

(test-error-tail
 wrong-number-of-arguments-exception?
 (read-bytevector! (u8vector) (current-input-port) 0 0 #f))

(test-error-tail type-exception? (read-bytevector! #f))
(test-error-tail type-exception? (read-bytevector! (u8vector) #f))
(test-error-tail
 type-exception?
 (read-bytevector! (u8vector) (current-input-port) #f))
(test-error-tail
 type-exception?
 (read-bytevector! (u8vector) (current-input-port) 0 #f))

(test-error-tail
 range-exception?
 (read-bytevector! (u8vector 1 2 3) (current-input-port) -1))
(test-error-tail
 range-exception?
 (read-bytevector! (u8vector 1 2 3) (current-input-port) 4))
(test-error-tail
 range-exception?
 (read-bytevector! (u8vector 1 2 3) (current-input-port) 0 4))
(test-error-tail
 range-exception?
 (read-bytevector! (u8vector 1 2 3) (current-input-port) 3 2))
