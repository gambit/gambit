(include "#.scm")

(define p
  (exit0-when-unimplemented-operation-os-exception
   (lambda ()
     (open-udp))))

(check-eq? (write '#u8() p) (void))
(check-eq? (write '#u8(11) p) (void))
(check-eq? (write '#u8(22 33) p) (void))
(check-eq? (write '#u8(44 55 66) p) (void))

(check-equal? (read p) '#u8())
(check-equal? (read p) '#u8(11))
(check-equal? (read p) '#u8(22 33))
(check-equal? (read p) '#u8(44 55 66))

(check-eq? (udp-write-u8vector '#u8() p) (void))
(check-eq? (udp-write-u8vector '#u8(11) p) (void))
(check-eq? (udp-write-u8vector '#u8(22 33) p) (void))
(check-eq? (udp-write-u8vector '#u8(44 55 66) p) (void))

(check-equal? (udp-read-u8vector p) '#u8())
(check-equal? (udp-read-u8vector p) '#u8(11))
(check-equal? (udp-read-u8vector p) '#u8(22 33))
(check-equal? (udp-read-u8vector p) '#u8(44 55 66))

(parameterize ((current-output-port p))
  (check-eq? (write '#u8()) (void))
  (check-eq? (write '#u8(11)) (void))
  (check-eq? (write '#u8(22 33)) (void))
  (check-eq? (write '#u8(44 55 66)) (void)))

(parameterize ((current-input-port p))
  (check-equal? (read) '#u8())
  (check-equal? (read) '#u8(11))
  (check-equal? (read) '#u8(22 33))
  (check-equal? (read) '#u8(44 55 66)))

(parameterize ((current-output-port p))
  (check-eq? (udp-write-u8vector '#u8()) (void))
  (check-eq? (udp-write-u8vector '#u8(11)) (void))
  (check-eq? (udp-write-u8vector '#u8(22 33)) (void))
  (check-eq? (udp-write-u8vector '#u8(44 55 66)) (void)))

(parameterize ((current-input-port p))
  (check-equal? (udp-read-u8vector) '#u8())
  (check-equal? (udp-read-u8vector) '#u8(11))
  (check-equal? (udp-read-u8vector) '#u8(22 33))
  (check-equal? (udp-read-u8vector) '#u8(44 55 66)))

(check-eq? (udp-write-subu8vector '#u8(1 2 3 4 5) 1 3 p) (void))
(check-eq? (udp-write-subu8vector '#u8(1 2 3 4 5) 0 5 p) (void))

(define buf (make-u8vector 10 0))

(check-= (udp-read-subu8vector buf 0 10 p) 2)
(check-equal? buf '#u8(2 3 0 0 0 0 0 0 0 0))

(check-= (udp-read-subu8vector buf 0 10 p) 5)
(check-equal? buf '#u8(1 2 3 4 5 0 0 0 0 0))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-write-u8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-write-u8vector 1 2 3)))

(check-tail-exn type-exception? (lambda () (udp-write-u8vector 1)))
(check-tail-exn type-exception? (lambda () (udp-write-u8vector 1 p)))
(check-tail-exn type-exception? (lambda () (udp-write-u8vector buf #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-read-u8vector 1 2)))

(check-tail-exn type-exception? (lambda () (udp-read-u8vector 1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-write-subu8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-write-subu8vector 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-write-subu8vector 1 2)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-write-subu8vector 1 2 3 4 5)))

(check-tail-exn type-exception? (lambda () (udp-write-subu8vector 1 0 1)))
(check-tail-exn type-exception? (lambda () (udp-write-subu8vector buf #f 1)))
(check-tail-exn type-exception? (lambda () (udp-write-subu8vector buf 0 #f)))
(check-tail-exn type-exception? (lambda () (udp-write-subu8vector buf 0 1 #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-read-subu8vector)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-read-subu8vector 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-read-subu8vector 1 2)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-read-subu8vector 1 2 3 4 5)))

(check-tail-exn type-exception? (lambda () (udp-read-subu8vector 1 0 1)))
(check-tail-exn type-exception? (lambda () (udp-read-subu8vector buf #f 1)))
(check-tail-exn type-exception? (lambda () (udp-read-subu8vector buf 0 #f)))
(check-tail-exn type-exception? (lambda () (udp-read-subu8vector buf 0 1 #f)))

(check-tail-exn type-exception? (lambda () (write #f p)))
