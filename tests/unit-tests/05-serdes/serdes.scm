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
  id: FF13874C-F7AB-44D2-BD01-A1C77C375742
  extender: define-type-of-point
  x
  y)

(define-type-of-point point3d
  id: F8A6D13D-1AAB-405B-8780-CA41F2F065B3
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
        ;;#\u1234
        #\u00ff ;; in case compiled with 1 byte characters

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

        (make-point 1 2)
        (make-point3d 1 2 3)
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

(let* ((predef-procedure
        list)
       (deserialized-predef-procedure
        (serdes1 predef-procedure)))
  (check-equal?
   (predef-procedure 1 2 3)
   (deserialized-predef-procedure 1 2 3)))

(let* ((parameter-object
        current-directory)
       (deserialized-parameter-object
        (serdes1 parameter-object)))
  (check-equal?
   (parameter-object)
   (deserialized-parameter-object)))

(let* ((equal-table
        (list->table '(("xyz" . 123)) init: 42))
       (deserialized-equal-table
        (serdes1 equal-table)))
  (check-equal? (table-ref equal-table "xyz")
                (table-ref deserialized-equal-table "xyz"))
  (check-equal? (table-ref equal-table "abc")
                (table-ref deserialized-equal-table "abc"))
  (check-equal? (table-ref equal-table 'foo 'undefined)
                (table-ref deserialized-equal-table 'foo 'undefined)))

(let* ((eq-table
        (list->table '((abc . 123) (456 . 789)) test: eq?))
       (deserialized-eq-table
        (serdes1 eq-table)))
  (check-equal? (table-ref eq-table 'abc)
                (table-ref deserialized-eq-table 'abc))
  (check-equal? (table-ref eq-table 456)
                (table-ref deserialized-eq-table 456))
  (check-equal? (table-ref eq-table 'foo 'undefined)
                (table-ref deserialized-eq-table 'foo 'undefined)))

(let* ((cont
        (thread-join!
         (thread-start!
          (make-root-thread
           (lambda () (continuation-capture identity))
           'root
           (thread-thread-group (current-thread))
           (open-dummy)
           (open-dummy)
           ))))
       (frame
        (##continuation-frame cont))
       (deserialized-frame
        (serdes1 frame))
       (deserialized-cont
        (serdes1 cont)))

  (check-equal?
   (##frame-fs frame)
   (##frame-fs deserialized-frame))

  (check-equal?
   (##frame-ret frame)
   (##frame-ret deserialized-frame))

  (let ((unique (list 1 2 3)))
    (check-eq?
     unique
     (thread-join!
      (thread-start!
       (make-thread
        (lambda () (continuation-return deserialized-cont unique))))))))

(let* ((promise
        (delay (* 6 7)))
       (deserialized-promise
        (serdes1 promise)))
  (check-equal?
   (force promise)
   (force deserialized-promise)))
