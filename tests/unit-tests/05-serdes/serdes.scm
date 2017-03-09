(include "#.scm")

(declare (block)) ;; needed for serialization/deserialization when compiled

(define (serdes1 obj)
  (let ((ser (object->u8vector obj)))
    (let ((des (u8vector->object ser)))
      des)))

(define (serdes2 obj)
  (let ((ser (object->u8vector obj (lambda (x) x))))
    (let ((des (u8vector->object ser (lambda (x) x))))
      des)))

(define-type point
  id: the-point-object
  x
  y
  z)

(define objects
  (list (cons 11 22)
        (list 11 22 33)

        0
        1
        -1
        2
        -2
        100
        -100
        ##max-fixnum
        ##min-fixnum
        12345678901234567890
        -12345678901234567890
        0.0
        -0.0
        3.1415
        +inf.0
        -inf.0
        1/3
        1+3i

        'allo
        'allo:

        ""
        "hello"
        "abcdefghijklmno"

        #\x
        #\u1234

        #f
        #t
        '()
        #!eof
        #!void
        ;;(macro-absent-obj)
        #!unbound
        #!unbound2
        #!optional
        #!key
        #!rest
        ;;(macro-unused-obj)
        ;;(macro-deleted-obj)

        (box 123)

        (vector)
        (vector 0 1 2 3 4 5 6 7 8 9 10 11 12)

        (s8vector)
        (s8vector 0 1 2 3 4 5 6 7 8 9 10 -128 127)

        (u8vector)
        (u8vector 0 1 2 3 4 5 6 7 8 9 10 11 255)

        (s16vector)
        (s16vector 0 1 2 3 4 5 6 7 8 9 10 -32768 32767)

        (u16vector)
        (u16vector 0 1 2 3 4 5 6 7 8 9 10 11 65535)

        (s32vector)
        (s32vector 0 1 2 3 4 5 6 7 8 9 10 -2147483648 2147483647)

        (u32vector)
        (u32vector 0 1 2 3 4 5 6 7 8 9 10 11 4294967295)

        (s64vector)
        (s64vector 0 1 2 3 4 5 6 7 8 9 10 -9223372036854775808 9223372036854775807)

        (u64vector)
        (u64vector 0 1 2 3 4 5 6 7 8 9 10 11 18446744073709551615)

        (f32vector)
        (f32vector 0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 +inf.0)

        (f64vector)
        (f64vector 0.0 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 +inf.0)

        car

        (make-point 1 2 3)
        ))

(define t (list->table '((a . 11) (b . 22))))

(for-each
 (lambda (obj)
   (check-equal? (serdes1 obj) obj))
 (cons t
       objects))

(for-each
 (lambda (obj)
   (check-equal? (serdes2 obj) obj))
 objects)

(define circular (cons 11 22))

(set-car! circular circular)
(set-cdr! circular circular)

(define circular2 (serdes1 circular))

(check-eq? circular2 (car circular2))
(check-eq? circular2 (cdr circular2))

(define make-adder
  (lambda (x)
    (lambda (y)
      (+ x y))))

(define add10 (make-adder 10))

(check-equal? ((serdes1 add10) 5) 15)
