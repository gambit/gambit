(include "#.scm")

(define (obj->str obj)
  (with-output-to-string
   ""
   (lambda ()
     (output-port-readtable-set!
      (current-output-port)
      (readtable-sharing-allowed?-set
       (output-port-readtable (current-output-port))
       'serialize))
     (write obj))))

(define (str->obj str)
  (with-input-from-string
   str
   (lambda ()
     (output-port-readtable-set!
      (current-output-port)
      (readtable-sharing-allowed?-set
       (output-port-readtable (current-output-port))
       'serialize))
     (read))))

(let* ((basic
        (list 123
              -45678901234567890
              1.25
              #t
              #f
              #\space
              "hello\nworld"
              'sym
              'key:
              '#(1 2 3)
              '(1 2 . 3)
              '()))
       (deserialized-basic
        (str->obj (obj->str basic))))
  (check-equal? basic deserialized-basic))

(let* ((shared
        (let* ((a '(123 #\space))
               (b (list a a))
               (c (vector b b)))
          (cons c '())))
       (deserialized-shared
        (str->obj (obj->str shared))))
  (check-equal? shared deserialized-shared))

(define-type point
  id: FF13874C-F7AB-44D2-BD01-A1C77C375742
  extender: define-type-of-point
  x
  y)

(define-type-of-point point3d
  id: F8A6D13D-1AAB-405B-8780-CA41F2F065B3
  z)

(let* ((point
        (make-point 11 22))
       (deserialized-point
        (str->obj (obj->str point))))
  (check-equal? point deserialized-point))

(let* ((point3d
        (make-point3d 11 22 33))
       (deserialized-point3d
        (str->obj (obj->str point3d))))
  (check-equal? point3d deserialized-point3d))

(let* ((predef-procedure
        list)
       (deserialized-predef-procedure
        (str->obj (obj->str predef-procedure))))
  (check-equal?
   (predef-procedure 1 2 3)
   (deserialized-predef-procedure 1 2 3)))

(let* ((parameter-object
        current-directory)
       (deserialized-parameter-object
        (str->obj (obj->str parameter-object))))
  (check-equal?
   (parameter-object)
   (deserialized-parameter-object)))

(let* ((equal-table
        (list->table '(("xyz" . 123)) init: 42))
       (deserialized-equal-table
        (str->obj (obj->str equal-table))))
  (check-equal? (table-ref equal-table "xyz")
                (table-ref deserialized-equal-table "xyz"))
  (check-equal? (table-ref equal-table "abc")
                (table-ref deserialized-equal-table "abc"))
  (check-equal? (table-ref equal-table 'foo 'undefined)
                (table-ref deserialized-equal-table 'foo 'undefined)))

(let* ((eq-table
        (list->table '((abc . 123) (456 . 789)) test: eq?))
       (deserialized-eq-table
        (str->obj (obj->str eq-table))))
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
       (ret
        (##frame-ret frame))
       (deserialized-ret
        (str->obj (obj->str ret)))
       (deserialized-frame
        (str->obj (obj->str frame)))
       (deserialized-cont
        (str->obj (obj->str cont))))

  (check-equal?
   ret
   deserialized-ret)

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
        (str->obj (obj->str promise))))
  (check-equal?
   (force promise)
   (force deserialized-promise)))
