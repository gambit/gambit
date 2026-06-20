(include "#.scm")

(define (obj->str obj proc)
  (with-output-to-string
   ""
   (lambda ()
     (output-port-readtable-set!
      (current-output-port)
      (readtable-sharing-allowed?-set
       (output-port-readtable (current-output-port))
       'serialize))
     (proc obj))))

(define (str->obj str proc)
  (with-input-from-string
   str
   (lambda ()
     (output-port-readtable-set!
      (current-output-port)
      (readtable-sharing-allowed?-set
       (output-port-readtable (current-output-port))
       'serialize))
     (proc))))

(define (obj->str->obj obj wr rd)
  (str->obj (obj->str obj wr) rd))

(let ((basic
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
             '())))
  (test-equal
   basic
   (obj->str->obj basic (lambda (obj) (write obj)) (lambda () (read)))))

(let ((shared
          (let* ((a '(123 #\space))
                 (b (list a a))
                 (c (vector b b)))
            (cons c '()))))
  (test-equal
   shared
   (obj->str->obj shared (lambda (obj) (write obj)) (lambda () (read)))))

(define-type point
  id: FF13874C-F7AB-44D2-BD01-A1C77C375742
  extender: define-type-of-point
  x
  y)

(define-type-of-point point3d
  id: F8A6D13D-1AAB-405B-8780-CA41F2F065B3
  z)

(let ((point
       (make-point 11 22)))
  (test-equal
   point
   (obj->str->obj point (lambda (obj) (write obj)) (lambda () (read)))))

(let ((point3d
       (make-point3d 11 22 33)))
  (test-equal
   point3d
   (obj->str->obj point3d (lambda (obj) (write obj)) (lambda () (read)))))

(let ((predef-procedure
       list))
  (test-equal
   predef-procedure
   (obj->str->obj predef-procedure (lambda (obj) (write obj)) (lambda () (read))))
  (test-equal
   (predef-procedure 1 2 3)
   ((obj->str->obj predef-procedure (lambda (obj) (write obj)) (lambda () (read))) 1 2 3)))

(let ((parameter-object
       current-directory))
  (test-equal
   (parameter-object)
   ((obj->str->obj parameter-object (lambda (obj) (write obj)) (lambda () (read))))))

(let* ((equal-table
        (list->table '(("xyz" . 123)) init: 42))
       (deserialized-equal-table
        (obj->str->obj equal-table (lambda (obj) (write obj)) (lambda () (read)))))
  (test-equal
   equal-table
   (obj->str->obj equal-table (lambda (obj) (write obj)) (lambda () (read))))
  (test-equal (table-ref equal-table "xyz")
              (table-ref deserialized-equal-table "xyz"))
  (test-equal (table-ref equal-table "abc")
              (table-ref deserialized-equal-table "abc"))
  (test-equal (table-ref equal-table 'foo 'undefined)
              (table-ref deserialized-equal-table 'foo 'undefined)))

(let* ((eq-table
        (list->table '((abc . 123) (456 . 789)) test: eq?))
       (deserialized-eq-table
        (obj->str->obj eq-table (lambda (obj) (write obj)) (lambda () (read)))))
  (test-equal
   eq-table
   (obj->str->obj eq-table (lambda (obj) (write obj)) (lambda () (read))))
  (test-equal (table-ref eq-table 'abc)
              (table-ref deserialized-eq-table 'abc))
  (test-equal (table-ref eq-table 456)
              (table-ref deserialized-eq-table 456))
  (test-equal (table-ref eq-table 'foo 'undefined)
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
        (obj->str->obj ret (lambda (obj) (write obj)) (lambda () (read))))
       (deserialized-frame
        (obj->str->obj frame (lambda (obj) (write obj)) (lambda () (read))))
       (deserialized-cont
        (obj->str->obj cont (lambda (obj) (write obj)) (lambda () (read)))))

  (test-equal
   ret
   deserialized-ret)

  (test-equal
   (##frame-fs frame)
   (##frame-fs deserialized-frame))

  (test-equal
   (##frame-ret frame)
   (##frame-ret deserialized-frame))

  (let ((unique (list 1 2 3)))
    (test-eq
     unique
     (thread-join!
      (thread-start!
       (make-thread
        (lambda () (continuation-return deserialized-cont unique))))))))

(let ((promise
       (delay (* 6 7))))
  (test-equal
   (force promise)
   (force (obj->str->obj promise (lambda (obj) (write obj)) (lambda () (read))))))
