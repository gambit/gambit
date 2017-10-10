(include "#.scm")

(declare (block)) ;; needed for serialization/deserialization when compiled

(define i 0)
(define (serdes1 obj)
  ;(println (object->string obj))
  (let ((ser (object->u8vector obj)))
    (let ((des (u8vector->object ser)))
      des)))

(define (serdes2 obj)
  (let ((ser (object->u8vector obj (lambda (x) x))))
    (let ((des (u8vector->object ser (lambda (x) x))))
      des)))

(define (serdes3 obj expect-ser expect-des)
  (define (make-transform expected)
    (lambda (o)
      (if (pair? expected)
        (let ((cur (car expected)))
          (check-equal? o cur)
          (set! expected (cdr expected))))
      o))

  (define (ser lst)
    (object->u8vector obj (make-transform expect-ser)))

  (define (des u8vect)
    (u8vector->object u8vect)) ;(make-transform expect-des)))

  (let* ((ser-obj (ser obj))
         (des-obj (des ser-obj)))
      des-obj))

(define-type point
  id: the-point-object
  x
  y
  z)

(define-type point-0
  id: the-point-0object
  x
  (y serialization-atomicity-depth: 2
     serialization-atomicity-width: 2))

(define-type point-1
  id: the-point-1-object
  (x serialization-atomicity-depth: 2
     serialization-atomicity-width: 2)
  y)

(define-type point-2
  id: the-point-2-object
  (x serialization-atomicity-depth: 2)
  (y serialization-atomicity-depth: 2))

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

(define structs
  (let* ((p0 (make-point 1 2 3))
        (p1 (make-point-0 1 2))
        (p2 (make-point-1 1 2))
        (p3 (make-point-2 1 2))
        (o4 (list p1 3 4)))
    (list
      (vector p0 (list p0 1 2 3) (list 1 2 3 p0))
      (vector p1 (list p1 1) (list 1 p1))
      (vector p2 (list p2 2) (list 2 p2))
      (vector p3 (list p3) (list p3))
      (vector o4
              (list o4 p1 1 '(3 4) 3 '(4) 4 '())
              (list 1 p1 3 4 '() '(4) '(3 4) o4)))))

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

(for-each
  (lambda (test)
    (let ((o (vector-ref test 0))
          (expect-ser (vector-ref test 1))
          (expect-des (vector-ref test 2)))
      (check-equal? (serdes3 o expect-ser expect-des) o)))
  structs)

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

(define-type container-5-5
  id: container-5-5-unique-id
  ;; Depth: 3 + cell
  ;; Width: 4
  (data serialization-atomicity-depth: 5
        serialization-atomicity-width: 5))

(define-type container-0-5
  id: container-0-5-unique-id
  ;; Depth: 3 + cell
  (data serialization-atomicity-depth: 5
        serialization-atomicity-width: 0))

(define-type container-5-0
  id: container-5-0-unique-id
  ;; Width: 4
  (data serialization-atomicity-depth: 0
        serialization-atomicity-width: 5))


(define (create-list-table w d)
  (let loop ((d d) (acc '()))
    (if (> d 0)
      (loop (- d 1)
            (cons acc
              (vector->list (make-vector w)))) acc)))

(define lst (create-list-table 30 30))

(define (test-w-d-attribute
          make-obj
          obj-data
          w d lst)
  (check-equal?
    (obj-data
      (u8vector->object
        (object->u8vector
          (make-obj lst)
          (lambda (o)
            (if (pair? o)
              '()
              o)))))
    (create-list-table w d)))

(test-w-d-attribute
  make-container-5-5
  container-5-5-data
  3 4 lst)

(test-w-d-attribute
  make-container-5-0
  container-5-0-data
  3 30 lst)

(test-w-d-attribute
  make-container-0-5
  container-0-5-data
  30 4 lst)
