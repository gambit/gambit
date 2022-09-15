(include "../#.scm")

(define-macro (check-same-behavior namespaces . calls)
  `(compare-behavior
    ',namespaces
    ',calls
    ,@(map (lambda (namespace)
             `(let ()
                ,(if (string? namespace)
                     (if (##string-prefix? "~~lib/" namespace)
                         `(include ,namespace)
                         `(namespace (,namespace)
                                     ("" list capture-behavior lambda let quote)))
                     `(##import ,namespace))
                (list ,@(map (lambda (call)
                               `(capture-behavior (lambda () ,call)))
                             calls))))
           namespaces)))

(define (capture-behavior thunk)
  (with-exception-catcher
   (lambda (e) e)
   thunk))

(define (compare-behavior namespaces calls . behaviors)

  (define (compare namespace1 namespace2 behavior1 behavior2)
    (for-each (lambda (call behavior1 behavior2)
                (if (not (equal? behavior1 behavior2))
                    (##failed-check
                     (string-append
                      (object->string call)
                      " in "
                      (object->string
                       (if (string? namespace2)
                           (if (##string-prefix? "~~lib/" namespace2)
                               `(include ,namespace2)
                               `(namespace (,namespace2)))
                           `(##import ,namespace2)))
                      " returned "
                      (object->string behavior2)
                      " but expected "
                      (object->string behavior1)))))
              calls
              behavior1
              behavior2))

  (let loop ((i (- (length behaviors) 1)))
    (if (> i 0)
        (begin
          (compare (list-ref namespaces 0)
                   (list-ref namespaces i)
                   (list-ref behaviors 0)
                   (list-ref behaviors i))
          (loop (- i 1))))))
